resource "azurerm_public_ip" "lsbin_batip_b" {
  name                = "lsbin-batip-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}



resource "azurerm_public_ip" "lsbin_natip_b" {
  name                = "lsbin-natip-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}



resource "azurerm_public_ip" "lsbin_loadip_b" {
  name                = "lsbin-loadip-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}
