resource "azurerm_subnet" "lsbin_bat_b" {
  name                            = "lsbin-bat-b"
  resource_group_name             = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet_b.name
  address_prefixes                = ["10.1.0.0/24"]
  default_outbound_access_enabled = true
}



resource "azurerm_subnet" "lsbin_web3_b" {
  name                            = "lsbin-web3-b"
  resource_group_name             = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet_b.name
  address_prefixes                = ["10.1.1.0/24"]
  default_outbound_access_enabled = false
}



resource "azurerm_subnet" "lsbin_nat_b" {
  name                            = "lsbin-nat-b"
  resource_group_name             = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet_b.name
  address_prefixes                = ["10.1.2.0/24"]
  default_outbound_access_enabled = true
}



resource "azurerm_subnet" "lsbin_load_b" {
  name                            = "lsbin-load-b"
  resource_group_name             = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet_b.name
  address_prefixes                = ["10.1.3.0/24"]
  default_outbound_access_enabled = true
}

#resource "azurerm_subnet" "lsbin_db_b" {
#  name                            = "lsbin-db-b"
#  resource_group_name             = var.na_02
#  virtual_network_name            = azurerm_virtual_network.lsbin_vnet_b.name
#  address_prefixes                = ["10.1.4.0/24"]
#  default_outbound_access_enabled = false
#}



resource "azurerm_subnet" "lsbin_pe_b" {
  name                              = "lsbin-pe-b"
  resource_group_name               = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name              = azurerm_virtual_network.lsbin_vnet_b.name
  address_prefixes                  = ["10.1.5.0/24"]
  default_outbound_access_enabled   = false
  private_endpoint_network_policies = "Disabled"
}
