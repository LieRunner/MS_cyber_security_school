resource "azurerm_subnet_nat_gateway_association" "lsbin_nat_web3" {
  subnet_id      = azurerm_subnet.lsbin_web3_b.id
  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw_b.id
}

#resource "azurerm_subnet_nat_gateway_association" "lsbin_nat_db_b" {
#  subnet_id      = azurerm_subnet.lsbin_db_b.id
#  nat_gateway_id = azurerm_nat_gateway.lsbin_natgw_b.id
#}
