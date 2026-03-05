resource "azurerm_public_ip" "lsbin_batip" {
  name                = "lsbin-batip"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}



resource "azurerm_public_ip" "lsbin_natip" {
  name                = "lsbin-natip"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}



resource "azurerm_public_ip" "lsbin_loadip" {
  name                = "lsbin-loadip"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}
