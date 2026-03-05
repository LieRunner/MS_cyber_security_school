resource "azurerm_virtual_network" "lsbin_vnet" {
  name                = "lsbin-vnet"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}
