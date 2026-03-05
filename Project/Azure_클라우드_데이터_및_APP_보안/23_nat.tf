resource "azurerm_nat_gateway" "lsbin_natgw" {
  name                    = "${var.prefix}-natgw"
  location                = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name     = azurerm_resource_group.team03_lsbin_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 5
  tags                    = local.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "lsbin_nat_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.lsbin_natgw.id
  public_ip_address_id = azurerm_public_ip.lsbin_natip.id
}

resource "azurerm_subnet_nat_gateway_association" "lsbin_web_nat_association" {
  subnet_id      = azurerm_subnet.lsbin_web1.id
  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw.id
}
