# 1. [RBAC] Key Vault 역할 할당

# 1-1. 팀장 (본인: e4f65a17...) -> [수정] Secrets User (조회만 가능)
# 역할: 보안 감사를 위해 비밀번호가 있는지 확인은 하지만, 직접 건드리지는 않음.
resource "azurerm_role_assignment" "kv_user_lead" {
  scope                = azurerm_key_vault.db_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.member_a
}

# 1-2. DB/인프라 담당자 (2c311acc...) -> Administrator (관리 가능)
# 역할: 실제 DB 비밀번호를 변경하고 관리해야 함.
resource "azurerm_role_assignment" "kv_admin_infra" {
  scope                = azurerm_key_vault.db_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.member_c
}

# 1-3. 일반 팀원 (c5bbd38d...) -> Secrets User (조회만 가능)
resource "azurerm_role_assignment" "kv_user_member" {
  scope                = azurerm_key_vault.db_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.member_b
}

# 2. [Custom Role] 삭제 방지 운영자 (Site Reliability Engineer)
resource "azurerm_role_definition" "no_delete_ops" {
  name        = "Team02-NoDelete-Operator"
  scope       = azurerm_resource_group.team03_lsbin_rg.id
  description = "Can create and update resources, but CANNOT delete anything."

  permissions {
    actions = ["*"]                      # 모든 작업 허용
    not_actions = [                      # 단, 아래 작업은 금지
      "*/delete",                        # 모든 리소스 삭제 금지
      "Microsoft.Authorization/*/write", # 권한 변경 금지 (자기가 권한 풀면 안 되니까)
    ]
    data_actions     = ["*"]
    not_data_actions = []
  }

  assignable_scopes = [
    azurerm_resource_group.team03_lsbin_rg.id
  ]
}

resource "azurerm_role_assignment" "assign_nodelete_ops_b" {
  scope              = azurerm_resource_group.team03_lsbin_rg.id
  role_definition_id = azurerm_role_definition.no_delete_ops.role_definition_resource_id
  principal_id       = var.member_b
}

resource "azurerm_role_assignment" "assign_nodelete_ops_c" {
  scope              = azurerm_resource_group.team03_lsbin_rg.id
  role_definition_id = azurerm_role_definition.no_delete_ops.role_definition_resource_id
  principal_id       = var.member_c
}
