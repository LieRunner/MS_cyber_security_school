resource "azurerm_network_interface_security_group_association" "lsbin_batnicsec" {
  network_interface_id      = azurerm_network_interface.lsbin_bat_nic.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_ssh.id
}

resource "azurerm_network_interface_security_group_association" "lsbin_web1nicsec" {
  network_interface_id      = azurerm_network_interface.lsbin_web1_nic.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_http.id
}

resource "azurerm_network_interface_security_group_association" "lsbin_web2nicsec" {
  network_interface_id      = azurerm_network_interface.lsbin_web2_nic.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_http.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_fd_only_appgw_a" {
  subnet_id                 = azurerm_subnet.lsbin_load.id
  network_security_group_id = azurerm_network_security_group.lsbin_fd_only_appgw_a.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_pe_assoc_a" {
  subnet_id                 = azurerm_subnet.lsbin_pe.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_pe_a.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_web1_subnet_assoc_a" {
  subnet_id                 = azurerm_subnet.lsbin_web1.id
  network_security_group_id = azurerm_network_security_group.lsbin_web_nsg_a.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_web2_subnet_assoc_a" {
  subnet_id                 = azurerm_subnet.lsbin_web2.id
  network_security_group_id = azurerm_network_security_group.lsbin_web_nsg_a.id
}
