resource "azurerm_network_interface_security_group_association" "lsbin_batnicsec_b" {
  network_interface_id      = azurerm_network_interface.lsbin_bat_nic_b.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_ssh_b.id
}

resource "azurerm_network_interface_security_group_association" "lsbin_web3nicsec_b" {
  network_interface_id      = azurerm_network_interface.lsbin_web3_nic_b.id
  network_security_group_id = azurerm_network_security_group.lsbin_nsg_http_b.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_fd_only_appgw_b_assoc" {
  subnet_id                 = azurerm_subnet.lsbin_load_b.id
  network_security_group_id = azurerm_network_security_group.lsbin_fd_only_appgw_b.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_web_subnet_assoc_b" {
  subnet_id                 = azurerm_subnet.lsbin_web3_b.id
  network_security_group_id = azurerm_network_security_group.lsbin_web_nsg_b.id
}

resource "azurerm_subnet_network_security_group_association" "lsbin_pe_subnet_assoc_b" {
  subnet_id                 = azurerm_subnet.lsbin_pe_b.id
  network_security_group_id = azurerm_network_security_group.lsbin_pe_nsg_b.id
}
