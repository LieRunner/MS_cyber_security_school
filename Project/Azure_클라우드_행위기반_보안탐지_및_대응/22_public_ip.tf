resource "azurerm_public_ip" "lsbin_batip" {
  name                = "${var.prefix}-batip"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}

resource "azurerm_public_ip" "lsbin_natip" {
  name                = "${var.prefix}-natip"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  tags                = local.common_tags
}

resource "azurerm_public_ip" "lsbin_loadip" {
  name                = "${var.prefix}-loadip"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
  domain_name_label   = "${var.prefix}-appgw"
  tags                = local.common_tags
}
