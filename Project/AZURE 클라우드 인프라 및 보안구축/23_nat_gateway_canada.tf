resource "azurerm_nat_gateway" "lsbin_natgw_b" {
  name                    = "lsbin-natgw-b"
  resource_group_name     = azurerm_resource_group.lsbin_rg_02.name
  location                = azurerm_resource_group.lsbin_rg_02.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = "4"
  tags                    = local.common_tags
}

resource "azurerm_nat_gateway_public_ip_association" "lsbin_natgw_pubip_b" {
  nat_gateway_id       = azurerm_nat_gateway.lsbin_natgw_b.id
  public_ip_address_id = azurerm_public_ip.lsbin_natip_b.id
}
