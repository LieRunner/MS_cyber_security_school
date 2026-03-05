# [한국] Primary (쓰기 가능)
resource "azurerm_mysql_flexible_server" "mysql-a" {
  count               = var.enable_db_korea ? 1 : 0
  name                = "lsbin-mysql-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location

  version                = "8.0.21"
  administrator_login    = var.db_admin
  administrator_password = local.db_admin_pass

  sku_name = "GP_Standard_D2ds_v4"
  storage {
    size_gb = 20
  }

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  public_network_access        = "Disabled"
  tags                         = local.common_tags


  # 1) 2026-01-27 / 14:15
  # 2) lifecycle {
  #      prevent_destroy = var.mysql_allow_destroy ? false : true
  #    }
  # 3) (삭제됨)
  # 4) prevent_destroy 속성은 변수 사용이 불가능하여 오류 발생. 
  #    대체 방안으로 azurerm_management_lock 리소스를 사용하기 위해 해당 블록 삭제.
}

# [캐나다] Replica (읽기 전용, KR을 바라봄) - "항상" Replica로 유지
resource "azurerm_mysql_flexible_server" "mysql-b" {
  count               = (var.enable_db_canada && var.enable_db_korea) ? 1 : 0
  name                = "lsbin-mysql-b"
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  location            = azurerm_resource_group.lsbin_rg_02.location

  create_mode      = "Replica"
  source_server_id = azurerm_mysql_flexible_server.mysql-a[0].id

  sku_name = "GP_Standard_D2ds_v4"
  storage {
    size_gb = 20
  }

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  public_network_access        = "Disabled"
  tags                         = local.common_tags


  # 1) 2026-01-27 / 14:15
  # 2) lifecycle {
  #      prevent_destroy = var.mysql_allow_destroy ? false : true
  #    }
  # 3) (삭제됨)
  # 4) prevent_destroy 속성은 변수 사용이 불가능하여 오류 발생. 
  #    대체 방안으로 azurerm_management_lock 리소스를 사용하기 위해 해당 블록 삭제.
}

# 1) 2026-01-27 / 14:15
# 2) (신규 추가)
# 3) resource "azurerm_management_lock" "mysql_a_lock" { ... }
# 4) prevent_destroy 오류 해결을 위해 추가. 
#    mysql_allow_destroy 변수(false)일 때 Lock을 생성하여 삭제 방지 구현.
resource "azurerm_management_lock" "mysql_a_lock" {
  count      = (var.enable_db_korea && !var.mysql_allow_destroy) ? 1 : 0
  name       = "mysql-a-lock"
  scope      = azurerm_mysql_flexible_server.mysql-a[0].id
  lock_level = "CanNotDelete"
  notes      = "Prevent accidental deletion"
}

# 1) 2026-01-27 / 14:15
# 2) (신규 추가)
# 3) resource "azurerm_management_lock" "mysql_b_lock" { ... }
# 4) prevent_destroy 오류 해결을 위해 추가. 
#    mysql_allow_destroy 변수(false)일 때 Lock을 생성하여 삭제 방지 구현.
resource "azurerm_management_lock" "mysql_b_lock" {
  count      = (var.enable_db_canada && var.enable_db_korea && !var.mysql_allow_destroy) ? 1 : 0
  name       = "mysql-b-lock"
  scope      = azurerm_mysql_flexible_server.mysql-b[0].id
  lock_level = "CanNotDelete"
  notes      = "Prevent accidental deletion"
}

