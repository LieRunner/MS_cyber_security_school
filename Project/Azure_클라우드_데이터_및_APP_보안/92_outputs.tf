# 날짜/시간: 2026-02-06 12:48
# 원본 코드: 기존 92_outputs.tf (PubIP, SubID, RG)
# 변경된 코드: DB FQDN, Key Vault Name, MySQL Server Name 추가됨
# 변경 사유: 신규 DB 및 보안 리소스 출력을 기존 92_outputs.tf로 통합하여 파일 관리 효율화

output "bat-pubip" {
  value = azurerm_public_ip.lsbin_batip.ip_address
}

# switch_dr.ps1 자동 변수 로드를 위한 출력
output "subscription_id" {
  value = local.prodid
}

output "primary_rg" {
  value = azurerm_resource_group.team03_lsbin_rg.name
}

# DB 및 보안 리소스 추가 출력 (프로젝트 4/5)
output "db_fqdn" {
  value = azurerm_mysql_flexible_server.db_server.fqdn
}

output "key_vault_name" {
  value = azurerm_key_vault.db_kv.name
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.db_server.name
}

output "appgw_pubip" {
  value = azurerm_public_ip.lsbin_loadip.ip_address
}

# 2026-02-09: App Gateway DNS 설정 가이드 출력 추가
output "dns_setup_guide" {
  value = <<EOT
[DNS 설정 정보]
도메인: ${var.custom_domain}

1. A 레코드 (IP 주소 사용)
   - 레코드 이름: www (또는 @)
   - 값 (Value): ${azurerm_public_ip.lsbin_loadip.ip_address}

2. CNAME 레코드 (Azure 도메인 사용 - 권장)
   - 레코드 이름: www
   - 값 (Value): ${azurerm_public_ip.lsbin_loadip.fqdn}
EOT
}
