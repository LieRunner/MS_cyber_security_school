resource "azurerm_subnet_network_security_group_association" "lsbin_bat_assoc" {
  subnet_id                 = azurerm_subnet.lsbin_bat.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_bat.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_web_assoc" {
  subnet_id                 = azurerm_subnet.lsbin_web1.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_web.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_appgw_assoc" {
  subnet_id                 = azurerm_subnet.lsbin_load.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_appgw.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_db_secure_assoc" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_db.id
}
