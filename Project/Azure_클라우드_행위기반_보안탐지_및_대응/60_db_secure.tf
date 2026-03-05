# 날짜/시간: 2026-02-06 15:06
# 원본 코드: 60_db_secure.tf
# 변경된 코드: 90_variables.tf 기반 리팩토링 및 명명 규칙 적용
# 변경 사유: 모든 하드코딩된 설정을 변수화하여 중앙 관리 체계를 완성하고 리소스 명칭 일관성 확보

# 1. Subnet Infrastructure (기존 VNet 활용)
resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.prefix}-snet-db-secure"
  resource_group_name  = azurerm_resource_group.team03_lsbin_rg.name
  virtual_network_name = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes     = var.subnet_prefixes["db_secure"]

  delegation {
    name = "mysql_fs_delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# 2. Private DNS & Networking (경계 보안)
resource "azurerm_private_dns_zone" "mysql_dns" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  tags                = local.common_tags
}

# 2026-02-07: 삭제 지연을 위한 리소스 추가 (순환 참조 방지를 위해 구조 최적화)
# Creation 순서: Zone -> Sleep(10s) -> Link
# Destruction 순서: Link -> Sleep(30s) -> Zone
resource "time_sleep" "wait_for_dns_cleanup" {
  create_duration  = "10s"
  destroy_duration = "30s"

  depends_on = [azurerm_private_dns_zone.mysql_dns]
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_link" {
  name                = "${var.prefix}-vnet-link-main"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  # 순환 참조 방지를 위해 azurerm_private_dns_zone.mysql_dns.name 대신 문자열 직접 사용
  private_dns_zone_name = "privatelink.mysql.database.azure.com"
  virtual_network_id    = azurerm_virtual_network.lsbin_vnet.id

  depends_on = [time_sleep.wait_for_dns_cleanup]
}

# 3. Security & Secrets (프로젝트 4)
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "db_kv" {
  name                       = "kv-${var.prefix}-${random_string.kv_suffix.result}"
  location                   = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name        = azurerm_resource_group.team03_lsbin_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = local.common_tags
}

# [진단 설정] Key Vault 로그를 LAW로 전송 (보안 감사용)
resource "azurerm_monitor_diagnostic_setting" "kv_diag" {
  name                       = "${var.prefix}-diag-kv"
  target_resource_id         = azurerm_key_vault.db_kv.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lsbin_law.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

data "azurerm_client_config" "current" {}

# 4. Monitoring & Logging (프로젝트 5)
resource "azurerm_log_analytics_workspace" "lsbin_law" {
  name                = "law-${var.prefix}"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  sku                 = var.law_sku
  retention_in_days   = var.law_retention
  tags                = local.common_tags
}

# 5. Database (핵심 리소스)
# 2026-02-07: MySQL Server 삭제 시 Subnet Delegation 해제 지연 문제 해결을 위한 대기 시간 추가
resource "time_sleep" "wait_for_server_destroy" {
  depends_on       = [azurerm_subnet.db_subnet]
  create_duration  = "30s"  # 생성 시 대기 (안전장치)
  destroy_duration = "120s" # 삭제 시 대기 (Subnet 해제 보장)
}

resource "azurerm_mysql_flexible_server" "db_server" {
  name                   = "mysql-${var.prefix}-${random_string.kv_suffix.result}"
  resource_group_name    = azurerm_resource_group.team03_lsbin_rg.name
  location               = azurerm_resource_group.team03_lsbin_rg.location
  administrator_login    = var.db_admin
  administrator_password = local.db_admin_pass
  sku_name               = var.db_sku
  version                = var.db_version
  delegated_subnet_id    = azurerm_subnet.db_subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql_dns.id
  zone                   = "1"

  storage {
    size_gb = var.db_storage_gb
  }

  backup_retention_days        = var.db_backup_retention
  geo_redundant_backup_enabled = false

  tags = local.common_tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql_dns_link,
    time_sleep.wait_for_server_destroy
  ]
}

resource "azurerm_monitor_diagnostic_setting" "mysql_diag" {
  name                       = "${var.prefix}-diag-mysql"
  target_resource_id         = azurerm_mysql_flexible_server.db_server.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lsbin_law.id

  enabled_log {
    category = "MySqlAuditLogs"
  }

  enabled_log {
    category = "MySqlSlowLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# 6. Database & Server Configuration (Project 4 Fix)
# WordPress용 데이터베이스 명시적 생성
resource "azurerm_mysql_flexible_database" "wordpress_db" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# SSL 연결 강제 비활성화 (보안 수준을 낮추어 워드프레스 연결 호환성 확보)
resource "azurerm_mysql_flexible_server_configuration" "mysql_disable_ssl" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  value               = "OFF"
}

# [보안] MySQL 감사 로그(Audit Log) 활성화
resource "azurerm_mysql_flexible_server_configuration" "audit_log_enable" {
  name                = "audit_log_enabled"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  value               = "ON"
}

# [보안] 감사할 이벤트 유형 선택 (접속 시도 포함)
resource "azurerm_mysql_flexible_server_configuration" "audit_log_events" {
  name                = "audit_log_events"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  server_name         = azurerm_mysql_flexible_server.db_server.name
  value               = "CONNECTION" # 접속(CONNECT) 로그 기록

  depends_on = [azurerm_mysql_flexible_server_configuration.audit_log_enable]
}

# Key Vault에 민감 정보(Secret) 추가
resource "azurerm_key_vault_secret" "db_admin_pass_secret" {
  name         = "db-admin-password"
  value        = local.db_admin_pass
  key_vault_id = azurerm_key_vault.db_kv.id

  # 주의: RBAC 기반 Key Vault이므로 역할 할당이 끝난 후 Secret이 생성되어야 403 에러가 나지 않습니다.
  depends_on = [
    azurerm_role_assignment.kv_admin_infra,
    azurerm_role_assignment.kv_user_lead,
    azurerm_role_assignment.kv_user_member
  ]
}
