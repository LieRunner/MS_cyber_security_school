resource "azurerm_resource_group" "lsbin_rg_01" {
  name     = var.rg_korea_name
  location = var.location_korea
  tags     = local.common_tags
}



resource "azurerm_resource_group" "lsbin_rg_02" {
  name     = var.rg_canada_name
  location = var.location_canada
  tags     = local.common_tags
}
