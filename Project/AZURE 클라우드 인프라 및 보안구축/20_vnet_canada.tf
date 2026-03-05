resource "azurerm_virtual_network" "lsbin_vnet_b" {
  name                = "lsbin-vnet-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  address_space       = ["10.1.0.0/16"]
  tags                = local.common_tags
}
