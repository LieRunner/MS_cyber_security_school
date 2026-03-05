resource "azurerm_virtual_network" "lsbin_vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}
