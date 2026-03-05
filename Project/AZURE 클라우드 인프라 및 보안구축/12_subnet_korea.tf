resource "azurerm_subnet" "lsbin_bat" {
  name                            = "lsbin-bat"
  resource_group_name             = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = ["10.0.0.0/24"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "lsbin_web1" {
  name                            = "lsbin-web1"
  resource_group_name             = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = ["10.0.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "lsbin_web2" {
  name                            = "lsbin-web2"
  resource_group_name             = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = ["10.0.2.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "lsbin_nat" {
  name                            = "lsbin-nat"
  resource_group_name             = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = ["10.0.3.0/24"]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "lsbin_load" {
  name                            = "lsbin-load"
  resource_group_name             = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes                = ["10.0.4.0/24"]
  default_outbound_access_enabled = true
}

#resource "azurerm_subnet" "lsbin_db" {
#  name                            = "lsbin-db"
#  resource_group_name             = var.na_01
#  virtual_network_name            = azurerm_virtual_network.lsbin_vnet.name
#  address_prefixes                = ["10.0.5.0/24"]
#  default_outbound_access_enabled = false
#}

resource "azurerm_subnet" "lsbin_pe" {
  name                 = "lsbin-pe"
  resource_group_name  = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name = azurerm_virtual_network.lsbin_vnet.name
  address_prefixes     = ["10.0.6.0/24"]

  private_endpoint_network_policies = "Disabled"
  default_outbound_access_enabled   = false
}
