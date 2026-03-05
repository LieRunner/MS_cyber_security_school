resource "azurerm_subnet" "lsbin_bat" {
  name                            = "${var.prefix}-bat"
  resource_group_name             = azurerm_resource_group.team03_lsbin_rg.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = var.subnet_prefixes["bat"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "lsbin_web1" {
  name                            = "${var.prefix}-web1"
  resource_group_name             = azurerm_resource_group.team03_lsbin_rg.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = var.subnet_prefixes["web"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "lsbin_load" {
  name                            = "${var.prefix}-load"
  resource_group_name             = azurerm_resource_group.team03_lsbin_rg.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = var.subnet_prefixes["load"]
  default_outbound_access_enabled = true
}
