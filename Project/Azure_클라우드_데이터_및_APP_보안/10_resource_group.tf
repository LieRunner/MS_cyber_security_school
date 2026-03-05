resource "azurerm_resource_group" "team03_lsbin_rg" {
  name     = var.rg_name
  location = var.location
  tags     = local.common_tags
}
