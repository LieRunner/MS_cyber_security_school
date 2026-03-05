resource "azurerm_subnet_nat_gateway_association" "lsbin_nat_web1" {
  subnet_id      = azurerm_subnet.lsbin_web1.id
  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw.id
}

resource "azurerm_subnet_nat_gateway_association" "lsbin_nat_web2" {
  subnet_id      = azurerm_subnet.lsbin_web2.id
  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw.id
}

#resource "azurerm_subnet_nat_gateway_association" "lsbin_nat_db" {
#  subnet_id      = azurerm_subnet.lsbin_db.id
#  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw.id
#}
