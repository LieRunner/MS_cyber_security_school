# 4차 기준=======================================================================
# [팀장 A] 거버넌스 및 통합 관제
# 역할: 구독 내 RBAC 설계, Azure Policy 할당 및 규정 준수 보고
# ==============================================================================

# 1. [Azure Policy] 컴플라이언스 및 비용 통제

# 1-1. 리전 제한 정책
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

resource "azurerm_resource_group_policy_assignment" "geo_restriction" {
  name                 = "lsbin-geo-policy"
  resource_group_id    = azurerm_resource_group.team03_lsbin_rg.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  display_name         = "[Governance] 허용된 리전(Korea)만 사용 가능"

  parameters = <<PARAMETERS
{
  "listOfAllowedLocations": {
    "value": [ "koreacentral", "koreasouth" ]
  }
}
PARAMETERS
}

# 1-2. VM SKU 제한 정책
data "azurerm_policy_definition" "allowed_vm_skus" {
  display_name = "Allowed virtual machine size SKUs"
}

resource "azurerm_resource_group_policy_assignment" "sku_restriction" {
  name                 = "lsbin-cost-policy"
  resource_group_id    = azurerm_resource_group.team03_lsbin_rg.id
  policy_definition_id = data.azurerm_policy_definition.allowed_vm_skus.id
  display_name         = "[Cost] 허용된 VM 등급(B-Series)만 사용 가능"

  parameters = <<PARAMETERS
{
  "listOfAllowedSKUs": {
    "value": [ "Standard_B1ms", "Standard_B2s", "Standard_B4ms" ]
  }
}
PARAMETERS
}
