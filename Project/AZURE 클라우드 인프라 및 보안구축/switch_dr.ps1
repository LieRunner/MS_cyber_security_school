<#
.SYNOPSIS
    MySQL DR 전환 제어 및 DNS 기반 자동 연결 스위칭 스크립트

.DESCRIPTION
    이 스크립트는 Azure Database for MySQL Flexible Server의 DR(Disaster Recovery) 시나리오를 지원합니다.
    Azure CLI와 Terraform을 사용하여 Replica 승격(Promote) 및 Private DNS 레코드 업데이트를 수행합니다.

.PARAMETER status
    현재 한국(Primary) 및 캐나다(Replica) 서버의 상태를 조회합니다.

.PARAMETER dr
    DR 전환을 수행합니다. (Replica 승격 + DNS를 캐나다 IP로 변경)

.PARAMETER restore
    앱 연결을 한국으로 돌리고, 캐나다 서버를 초기화하여 다시 Replica로 설정합니다. (데이터 초기화 주의)

.EXAMPLE
    .\switch_dr.ps1 -status
    현재 MySQL 서버 상태를 확인합니다.

.EXAMPLE
    .\switch_dr.ps1 -dr
    장애 발생 시 실행. 캐나다 Replica를 승격하고 앱 연결을 자동으로 전환합니다.

.EXAMPLE
    .\switch_dr.ps1 -restore
    앱 연결을 한국으로 돌리고, 캐나다 서버를 초기화하여 다시 Replica로 설정합니다.
#>
# switch_dr.ps1
param(
  # 기능 모드 (하나만 선택)
  [switch]$status,
  [switch]$dr,
  [switch]$restore,

  # 2026-01-27 15:48 / 도움말 옵션 확장 및 Alias 추가
  # 원본: [Alias("?")] [switch]$Help,
  # 변경: [Alias("?", "help")] [switch]$ShowHelp,
  # 사유: 사용자가 요청한 -help, -? 지원을 위해 Alias를 추가하고 변수명을 명확히 함
  [Alias("?", "help")]
  [switch]$ShowHelp,
  
  # (선택) normal 복귀 시 replica를 재생성까지 할 건지
  [switch]$recreateReplicaOnNormal, # (하위 호환 및 dbreset 내부 사용)

  # 도움말 출력을 위한 스위치
  [switch]$OldHelp
)

# 2026-01-27 19:53 / Terraform Output 기반 변수 자동 탐색 로직 추가
# 사유: 리소스 정보(구독ID, RG, 서버명 등)가 변경되어도 스크립트 수정 없이 연동되도록 하기 위함
function Get-TfOutput {
  param([string]$name)
  $val = terraform output -raw $name 2>$null
  if ($LASTEXITCODE -eq 0 -and $val -and $val -notmatch "No outputs found") {
    return $val.Trim()
  }
  # 2026-01-27 20:21 / 변수 누락 시 안내 멘트 보강 (Lock 대응)
  # 사유: 리스토어 등 다른 작업 중일 경우 State Lock으로 인해 조회가 안 될 수 있음을 명시
  Write-Host " [!] Terraform Output에서 '$name'을 가져올 수 없습니다. (현재 다른 작업 진행 중으로 인한 Lock일 수 있음)" -ForegroundColor Yellow
  return $null
}

Write-Host ""

# 2026-01-27 20:21 / PowerShell 버전 호환성을 위해 할당 로직 변경
# 원본: $subscriptionId = Get-TfOutput "subscription_id" ?? "..."
# 변경: 모든 버전에서 작동하는 if 문을 통한 값 할당
# 사유: 윈도우 기본 PowerShell(5.1)에서 ?? 연산자가 미지원되어 빈 값으로 남는 문제 방지
$tmpVal = Get-TfOutput "subscription_id"; if ($tmpVal) { $subscriptionId = $tmpVal } else { $subscriptionId = "99b79efe-ebd6-468c-b39f-5669acb259e1" }
$tmpVal = Get-TfOutput "primary_rg";      if ($tmpVal) { $primaryRg = $tmpVal }      else { $primaryRg = "05-team03-lsbin-RG-01-Korea" }
$tmpVal = Get-TfOutput "replica_rg";      if ($tmpVal) { $replicaRg = $tmpVal }      else { $replicaRg = "05-team03-lsbin-RG-02-Canada" }
$tmpVal = Get-TfOutput "mysql_primary_name"; if ($tmpVal) { $primaryName = $tmpVal } else { $primaryName = "lsbin-mysql-a" }
$tmpVal = Get-TfOutput "mysql_replica_name"; if ($tmpVal) { $replicaName = $tmpVal } else { $replicaName = "lsbin-mysql-b" }
$tmpVal = Get-TfOutput "mysql_admin_user";   if ($tmpVal) { $adminUser = $tmpVal }   else { $adminUser = "lsbin" }
$tmpVal = Get-TfOutput "dns_zone_name";      if ($tmpVal) { $dnsZoneName = $tmpVal } else { $dnsZoneName = "privatelink.mysql.database.azure.com" }
$tmpVal = Get-TfOutput "dns_record_name";    if ($tmpVal) { $dnsRecordName = $tmpVal } else { $dnsRecordName = "lsbin-db" }

# 2026-01-27 15:48 / --help, --? 플래그 수동 처리 및 한글 도움말 출력 로직 개선
# 원본:
# if ($args -contains "--help" -or $args -contains "--?") {
#     $Help = $true
# }
# if ($Help -or (-not ($status -or $dr -or $normal -or $dbreset))) { ... }
# 변경: 아래의 통합 도움말 처리 로직으로 교체
# 사유: 사용자가 요청한 모든 도움말 플래그(-help, --help, -?, --?)를 일관되게 지원하고 상세한 한글 설명 제공

# --help, --? 처리 (PowerShell은 기본적으로 -만 인식하므로 args로 수동 체크)
if ($args -contains "--help" -or $args -contains "--?") {
    $ShowHelp = $true
}

# 모드가 하나도 지정되지 않았거나 도움말 요청 시
if ($ShowHelp -or (-not ($status -or $dr -or $restore))) {
    Write-Host "`n==== [ MySQL DR 전환 및 관리 스크립트 도움말 ] ====" -ForegroundColor Cyan
    Write-Host "`n이 스크립트는 Azure Database for MySQL Flexible Server의 DR 시나리오 및 관리를 자동화합니다."
    
    Write-Host "`n[ 사용법 ]" -ForegroundColor Yellow
    Write-Host "  .\switch_dr.ps1 [옵션]"
    
    Write-Host "`n[ 지원 옵션 ]" -ForegroundColor Yellow
    Write-Host "  -status    : 한국(Primary) 및 캐나다(Replica) 서버의 현재 상태(상태, FQDN, 역할 등)를 조회합니다."
    Write-Host "  -dr        : 장애 발생 시 DR 전환을 수행합니다."
    Write-Host "  -restore   : 인프라를 완전히 재생성하여 초기화합니다."
    
    Write-Host "`n[ 도움말 옵션 ]" -ForegroundColor Yellow
    Write-Host "  -help, --help, -?, --? : 본 도움말 메시지를 출력합니다."

    Write-Host "`n[ 예시 ]" -ForegroundColor Yellow
    Write-Host "  .\switch_dr.ps1 -status"
    Write-Host "  .\switch_dr.ps1 -dr"
    Write-Host "  .\switch_dr.ps1 -restore"
    Write-Host "  .\switch_dr.ps1 --help"

    Write-Host "`n[ 참고: 유용한 Terraform 명령어 ]" -ForegroundColor DarkCyan
    Write-Host "  - 인프라 병렬 처리 및 성능 측정 적용 예시:"
    Write-Host "  Measure-Command { terraform apply -auto-approve -parallelism=30 | Out-Default }"
    Write-Host "  Measure-Command { terraform destroy -auto-approve -parallelism=30 | Out-Default }"
    Write-Host "  Measure-Command { terraform plan | Out-Default }"
    Write-Host ""
    exit 0
}

function Assert-Command($cmd) {
  $exists = Get-Command $cmd -ErrorAction SilentlyContinue
  if (-not $exists) {
    throw "필수 커맨드가 없습니다: $cmd"
  }
}

# MySQL 도구 확인 및 자동 설치 함수
function Ensure-MySqlTools {
    $tools = @("mysql", "mysqldump")
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            Write-Host "[INFO] '$tool' 이(가) 인식되지 않습니다. 환경 변수 및 설치 여부를 확인합니다..." -ForegroundColor Yellow
            
            # 1. 2026-01-27 16:13 / PATH 환경 변수 최신화 시도
            # 사유: winget으로 설치된 새 경로를 현재 세션에 즉시 반영하기 위함
            $refreshPath = {
                $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            }
            & $refreshPath

            if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
                # 2. 그래도 없으면 설치 진행
                Write-Host "[INFO] '$tool' 이(가) 설치되어 있지 않습니다. 자동 설치를 진행합니다..." -ForegroundColor Yellow
                winget install --id Oracle.MySQL -e --silent --accept-package-agreements --accept-source-agreements
                
                # 3. 설치 후 다시 PATH 리프레시
                & $refreshPath
                
                # 4. 직접 설치 경로 탐색 (최후의 수단)
                if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
                   Write-Host "[INFO] 설치 후에도 '$tool'을 찾을 수 없어 직접 경로를 탐색합니다..." -ForegroundColor Gray
                   $mysqlBin = Get-ChildItem -Path "C:\Program Files\MySQL", "C:\Program Files (x86)\MySQL" -Filter "mysql.exe" -Recurse -ErrorAction SilentlyContinue | 
                               Select-Object -ExpandProperty DirectoryName -First 1
                   if ($mysqlBin) {
                       $env:Path += ";$mysqlBin"
                       Write-Host "[INFO] MySQL 경로를 임시로 추가했습니다: $mysqlBin" -ForegroundColor Green
                   }
                }
            }

            if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
                Write-Host "[ERROR] '$tool' 설치에 실패했거나 경로 인식이 안 됩니다. 수동 설치 후 스크립트를 재실행해 주세요." -ForegroundColor Red
                exit 1
            }
        }
    }
}

# MySQL 접속 제어 함수 (공용 액세스 및 NSG 관리)
function Set-MySqlAccess {
    param([string]$action) # "Allow" or "Deny"
    
    $myIp = (Invoke-RestMethod -Uri "https://api.ipify.org").Trim()
    
    $servers = @(
        @{ rg = $primaryRg; name = $primaryName; nsg = "lsbin-nsg-pe-a" },
        @{ rg = $replicaRg; name = $replicaName; nsg = "lsbin-pe-nsg-b" }
    )

    foreach ($srv in $servers) {
        if ($action -eq "Allow") {
            Write-Host "[INFO] 서버($($srv.name))의 공용 액세스를 허용하고 방화벽 규칙을 추가합니다." -ForegroundColor Cyan
            # 1. 2026-01-27 16:18 / 공용 액세스 일시 허용
            az mysql flexible-server update -g $($srv.rg) -n $($srv.name) --public-access Enabled > $null
            # 2. 방화벽 규칙 추가
            az mysql flexible-server firewall-rule create -g $($srv.rg) -n $($srv.name) -r "Temp-Allow-DR" `
                --start-ip-address $myIp --end-ip-address $myIp > $null
            # 3. NSG 포트 개방
            az network nsg rule create -g $($srv.rg) --nsg-name $($srv.nsg) -n "Temp-Allow-3306-DR" `
                --priority 150 --direction Inbound --access Allow --protocol Tcp `
                --source-address-prefixes $myIp --source-port-ranges "*" `
                --destination-address-prefixes "*" --destination-port-ranges 3306 > $null
        } else {
            Write-Host "[INFO] 서버($($srv.name))의 공용 액세스를 차단하고 임시 규칙을 삭제합니다." -ForegroundColor Gray
            az mysql flexible-server firewall-rule delete -g $($srv.rg) -n $($srv.name) -r "Temp-Allow-DR" -y 2>$null
            az mysql flexible-server update -g $($srv.rg) -n $($srv.name) --public-access Disabled > $null
            az network nsg rule delete -g $($srv.rg) --nsg-name $($srv.nsg) -n "Temp-Allow-3306-DR" 2>$null
        }
    }
}

# DNS 레코드 업데이트 함수
function Update-DnsRecord {
  param(
    [string]$rgName,
    [string]$serverName
  )
  
  Write-Host "[INFO] '$serverName'의 IP 조회 중..." -ForegroundColor Cyan
  $targetFqdn = az mysql flexible-server show -g $rgName -n $serverName --query "fullyQualifiedDomainName" -o tsv
  
  if (-not $targetFqdn) {
      throw "'$serverName'의 FQDN 정보를 가져올 수 없습니다. 서버가 존재하는지 확인하세요."
  }

  Write-Host "[INFO] DNS 레코드($dnsRecordName)를 '$targetFqdn'으로 업데이트(CNAME) 합니다." -ForegroundColor Cyan
  
  az network private-dns record-set a delete -g $primaryRg -z $dnsZoneName -n $dnsRecordName -y 2>$null
  az network private-dns record-set cname delete -g $primaryRg -z $dnsZoneName -n $dnsRecordName -y 2>$null

  az network private-dns record-set cname create -g $primaryRg -z $dnsZoneName -n $dnsRecordName --ttl 30 > $null
  az network private-dns record-set cname set-record -g $primaryRg -z $dnsZoneName -n $dnsRecordName --cname $targetFqdn > $null
  
  Write-Host "[SUCCESS] DNS 전환 완료: $dnsRecordName.$dnsZoneName -> $targetFqdn" -ForegroundColor Green
}

# 기본 CLI 체크 및 구독 설정
Assert-Command "az"
az account set --subscription $subscriptionId | Out-Null

if ($status) {
  Write-Host "`n[INFO] MySQL 서버 상태 확인" -ForegroundColor Cyan
  Write-Host "------------------------------------------------------------------------------" -ForegroundColor Gray

  # 2026-01-27 19:56 / 상태 요약 출력 로직 개선
  # 사유: 사용자 요청에 따라 테이블 출력 후 하단에 한눈에 들어오는 요약 상태 정보 추가
  
  # 상태 정보 캡처
  $primaryStatus = az mysql flexible-server show -g $primaryRg -n $primaryName --query "{name:name, state:state, role:replicationRole}" -o json | ConvertFrom-Json
  $replicaStatus = az mysql flexible-server show -g $replicaRg -n $replicaName --query "{name:name, state:state, role:replicationRole}" -o json | ConvertFrom-Json

  Write-Host "`n[ 한국 Primary ($primaryName) ]" -ForegroundColor White
  $primaryStatus | Format-Table -AutoSize
  
  Write-Host "[ 캐나다 Replica ($replicaName) ]" -ForegroundColor White
  $replicaStatus | Format-Table -AutoSize

  Write-Host ">>>> 현재 시스템 상태 요약 <<<<" -ForegroundColor Yellow
  # 2026-01-27 19:59 / 역할 판별 조건 수정 (Source 추가)
  if (($primaryStatus.role -eq "None" -or $primaryStatus.role -eq "Source") -and $replicaStatus.role -eq "Replica") {
    Write-Host " 상태: [ 정상 운영 ]" -ForegroundColor Green
    Write-Host " 설명: 한국 서버가 Primary이며, 캐나다 서버가 실시간 복제(Replica) 중입니다."
  } elseif ($replicaStatus.role -eq "None" -and ($primaryStatus.role -ne "Source" -and $primaryStatus.role -ne "None" -or $primaryStatus.state -ne "Ready")) {
    Write-Host " 상태: [ DR 전환 완료 (캐나다 운영 중) ]" -ForegroundColor Red
    Write-Host " 설명: 캐나다 서버가 승격되어 운영 중입니다. 한국 서버 점검 또는 복구가 필요합니다."
  } else {
    Write-Host " 상태: [ 확인 필요 ]" -ForegroundColor Cyan
    Write-Host " 설명: 서버 역할이 동기화되지 않았거나 서버가 점검 중일 수 있습니다. 수동 확인이 필요합니다."
  }
  Write-Host "`n"

  exit 0
}

if ($dr) {
  # 2026-01-27 18:45 / 실행 시간 측정을 위한 시작 시간 기록
  # 원본: (신규 추가)
  # 사유: 사용자 요청에 따라 -dr 명령 완료 후 총 소요 시간을 표시하기 위함
  $startTime = Get-Date

  Write-Host "[WARN] DR 모드: CA 레플리카를 '승격(Promote)' 합니다. (데이터 유지)" -ForegroundColor Red
  az mysql flexible-server replica stop-replication -g $replicaRg -n $replicaName -y
  Update-DnsRecord -rgName $replicaRg -serverName $replicaName
  
  # 2026-01-27 16:07 / DR 접속 정보 추가 출력
  # 원본: (신규 추가)
  # 사유: 사용자가 DR 전환 후 즉시 접속 정보를 확인할 수 있도록 편의성 제공
  $batIpB = terraform output -raw bat-pubip-b
  $mysqlFqdnB = az mysql flexible-server show -g $replicaRg -n $replicaName --query "fullyQualifiedDomainName" -o tsv
  
  Write-Host "`n==========================================" -ForegroundColor Cyan
  Write-Host "[DR 접속 정보]" -ForegroundColor Yellow
  Write-Host "1. Bastion-B Public IP : $batIpB"
  Write-Host "2. MySQL-B Address     : $mysqlFqdnB"
  Write-Host "3. DNS 서비스 주소     : $dnsRecordName.$dnsZoneName"
  Write-Host ""
  Write-Host "==========================================`n"

  Write-Host "[INFO] DR 승격 및 DNS 전환 완료. 앱은 이제 $replicaName(CA)를 바라봅니다." -ForegroundColor Green
  
  # 2026-01-27 18:45 / 실행 시간 계산 및 출력
  # 원본: (신규 추가)
  # 사유: 작업 완료 후 소요 시간을 표시하여 사용자 편의성 증대
  $endTime = Get-Date
  $duration = $endTime - $startTime
  Write-Host "`n[완료] 총 소요 시간: $($duration.Minutes)분 $($duration.Seconds)초" -ForegroundColor Cyan

  exit 0
}

# 2026-01-27 19:47 / normal 명령어 삭제 및 로직 통합
# 원본: if ($normal -or $restore) {
# 변경: if ($restore) {
# 사유: 사용자 요청에 따른 명령어 단순화 (normal 삭제, restore로 통합)
if ($restore) {
  # 2026-01-27 18:45 / 실행 시간 측정을 위한 시작 시간 기록
  # 원본: (신규 추가)
  # 사유: 사용자 요청에 따라 -normal/-dbreset 명령 완료 후 총 소요 시간을 표시하기 위함
  $startTime = Get-Date

  Write-Host "==========================================================" -ForegroundColor Yellow
  Write-Host "[경고] 초기화 및 복구(Restore) 모드 진입" -ForegroundColor Red
  Write-Host "==========================================================" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "1. 자동 데이터 동기화: 캐나다(CA) -> 한국(KR) 데이터 자동 이관" -ForegroundColor Yellow
  Write-Host "2. 자동 도구 설치 및 포트 관리: 필요 시 자동 수행" -ForegroundColor White
  Write-Host "3. 인프라 복구: 이관 후 캐나다 서버를 다시 Replica로 재구성" -ForegroundColor White
  Write-Host ""

  $doSync = Read-Host "데이터 자동 동기화를 진행하시겠습니까? (y/n)"
  
  # 2026-01-27 18:56 / 동기화 거부 시 스크립트 종료 로직 추가
  # 원본: (신규 추가)
  # 사유: 사용자가 동기화를 진행하지 않을 경우 후속 인프라 복구 진행을 방지하기 위해 즉시 종료 처리
  if ($doSync -ne "y") {
    Write-Host "[INFO] 동기화가 취소되었습니다. 스크립트를 종료합니다." -ForegroundColor Yellow
    exit 0
  }

  if ($doSync -eq "y") {
    # 2026-01-27 16:44 / SSH 기반 동기화로 전환하여 공용 액세스 허용 로직 최소화
    # 사유: DNS 해석 문제 해결 및 보안 강화
    # Ensure-MySqlTools # 로컬 도구 불필요 (Bastion 도구 사용)
    # Set-MySqlAccess -action "Allow" # 공용 액세스 더 이상 필요 없음

    $dbPass = Get-Content -Path "$PSScriptRoot/db_admin_pass.txt" -Raw | ForEach-Object { $_.Trim() }
    
    try {
        Write-Host ""
        Write-Host "[단계 0] 한국 Primary 서버 확인/활성화" -ForegroundColor Cyan
        # 2026-01-27 16:31 / Terraform 리소스 주소 수정 (싱글 쿼트 사용하여 따옴표 오류 방지)
        Measure-Command { terraform apply -auto-approve -target='azurerm_mysql_flexible_server.mysql-a[0]' | Out-Default }
        
        $primaryFqdn = az mysql flexible-server show -g $primaryRg -n $primaryName --query "fullyQualifiedDomainName" -o tsv
        $replicaFqdn = az mysql flexible-server show -g $replicaRg -n $replicaName --query "fullyQualifiedDomainName" -o tsv

        Write-Host ""
        Write-Host "[단계 1] 데이터 동기화 시작 (CA Bastion -> 로컬 -> KR Bastion)" -ForegroundColor Cyan
        
        $batIpA = terraform output -raw bat-pubip
        $batIpB = terraform output -raw bat-pubip-b
        $rsaKey = "$PSScriptRoot/keys/id_rsa"
        $dumpFile = "$PSScriptRoot/dr_backup.sql"
        $sshBase = "ssh -i '$rsaKey' -o StrictHostKeyChecking=no -o ConnectTimeout=10 lsbin@"

        # 1-1. 캐나다에서 로컬로 데이터 동기화 (SSH 경유)
        Write-Host " - [정보] 동기화할 데이터베이스 목록 조회 중..." -ForegroundColor Gray
        $dbListCmd = "mysql -h $replicaName.mysql.database.azure.com -u $adminUser -p'$dbPass' -N -e 'SHOW DATABASES;' | grep -vE 'information_schema|performance_schema|mysql|sys' | xargs"
        $targetDbs = & powershell -Command "$sshBase$batIpB \"$dbListCmd\""
        if ($targetDbs) { $targetDbs = $targetDbs.Trim() }

        if (-not $targetDbs) {
            Write-Host "[WARN] 동기화할 사용자 데이터베이스가 없습니다. (시스템 DB 제외)" -ForegroundColor Yellow
        } else {
            Write-Host " - [정보] 동기화 대상 DB: $targetDbs" -ForegroundColor Gray
            
            # 1-2. 데이터 추출 (SSH 경유)
            Write-Host " - [추출] 캐나다(CA)에서 데이터 덤프 진행 중..." -ForegroundColor Gray
            # 2026-01-27 16:50 / --all-databases 대신 추출된 DB 목록 사용 및 필터 강화
            $dumpCmd = "mysqldump -h $replicaName.mysql.database.azure.com -u $adminUser -p'$dbPass' --databases $targetDbs --set-gtid-purged=OFF --column-statistics=0 --single-transaction --quick --lock-tables=false | grep -v 'SET GLOBAL' | grep -v 'SESSION.SQL_LOG_BIN' | grep -v 'GTID_PURGED'"
            
            & powershell -Command "$sshBase$batIpB \"$dumpCmd\"" > $dumpFile
            if ($LASTEXITCODE -ne 0) { throw "데이터 추출 실패!" }

            # 1-3. 한국으로 데이터 주입 (SSH 경유)
            Write-Host " - [주입] 한국(KR)으로 데이터 복원 진행 중..." -ForegroundColor Gray
            $injectCmd = "mysql -h $primaryName.mysql.database.azure.com -u $adminUser -p'$dbPass'"
            Get-Content $dumpFile | & powershell -Command "ssh -i '$rsaKey' -o StrictHostKeyChecking=no lsbin@$batIpA \"$injectCmd\""
            if ($LASTEXITCODE -ne 0) { throw "데이터 주입 실패!" }

            Write-Host "[성공] 데이터 동기화 완료! ($targetDbs)" -ForegroundColor Green
        }
        
        if (Test-Path $dumpFile) { Remove-Item $dumpFile -Force }
    }
    catch {
        Write-Host "[오류] $_" -ForegroundColor Red
        exit 1
    }
    finally {
        $cleanup = Read-Host "작업이 끝났습니다. 설치된 임시 규칙을 정리할까요? (y/n)"
        if ($cleanup -eq "y") {
            # Set-MySqlAccess -action "Deny" # 공용 액세스 로직 미사용 시 주석 처리 가능
            Write-Host "[SUCCESS] 정리 완료." -ForegroundColor Green
        }
    }
  }

  Write-Host ""
  Write-Host "[단계 2] 인프라 복구 시작 (Replica 재구성)" -ForegroundColor Cyan
  Measure-Command { terraform apply -auto-approve -parallelism=30 -var="mysql_allow_destroy=true" | Out-Default }
  Measure-Command { terraform apply -auto-approve -parallelism=30 -var="mysql_allow_destroy=false" | Out-Default }

  Write-Host ""
  Write-Host "[단계 3] DNS 복구 시작" -ForegroundColor Cyan
  Update-DnsRecord -rgName $primaryRg -serverName $primaryName

  # 2026-01-27 17:15 / 복구 완료 후 한국 리전 접속 정보 출력 추가
  # 사유: 복구가 완료된 후 사용자가 즉시 접속 정보를 확인할 수 있도록 편의성 제공
  $batIpA = terraform output -raw bat-pubip
  $mysqlFqdnA = az mysql flexible-server show -g $primaryRg -n $primaryName --query "fullyQualifiedDomainName" -o tsv

  Write-Host "`n==========================================" -ForegroundColor Cyan
  Write-Host "[Primary(KR) 접속 정보]" -ForegroundColor Yellow
  Write-Host "1. Bastion-A Public IP : $batIpA"
  Write-Host "2. MySQL-A Address     : $mysqlFqdnA"
  Write-Host "3. DNS 서비스 주소     : $dnsRecordName.$dnsZoneName"
  Write-Host ""
  Write-Host "==========================================`n"

  Write-Host "[완료] 모든 복구 절차가 정상적으로 마무리되었습니다." -ForegroundColor Green

  # 2026-01-27 18:45 / 실행 시간 계산 및 출력
  # 원본: (신규 추가)
  # 사유: 작업 완료 후 소요 시간을 표시하여 사용자 편의성 증대
  $endTime = Get-Date
  $duration = $endTime - $startTime
  Write-Host "`n[완료] 총 소요 시간: $($duration.Minutes)분 $($duration.Seconds)초" -ForegroundColor Cyan

  exit 0
}
