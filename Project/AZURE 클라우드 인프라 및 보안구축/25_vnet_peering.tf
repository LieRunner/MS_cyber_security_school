resource "azurerm_virtual_network_peering" "vnet_peering_a_to_b" {
  name                         = "vnet-a-to-b-peering"
  resource_group_name          = azurerm_resource_group.lsbin_rg_01.name
  virtual_network_name         = azurerm_virtual_network.lsbin_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.lsbin_vnet_b.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on = [
    azurerm_virtual_network.lsbin_vnet,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web1,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web2,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web3,
    azurerm_network_interface_security_group_association.lsbin_batnicsec,
    azurerm_network_interface_security_group_association.lsbin_web1nicsec,
    azurerm_network_interface_security_group_association.lsbin_web2nicsec,
    azurerm_subnet_network_security_group_association.lsbin_pe_assoc_a,
    azurerm_subnet_network_security_group_association.lsbin_web1_subnet_assoc_a,
    azurerm_subnet_network_security_group_association.lsbin_web2_subnet_assoc_a
  ]
}



resource "azurerm_virtual_network_peering" "vnet_peering_b_to_a" {
  name                         = "vnet-b-to-a-peering"
  resource_group_name          = azurerm_resource_group.lsbin_rg_02.name
  virtual_network_name         = azurerm_virtual_network.lsbin_vnet_b.name
  remote_virtual_network_id    = azurerm_virtual_network.lsbin_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on = [
    azurerm_virtual_network.lsbin_vnet_b,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web1,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web2,
    azurerm_subnet_nat_gateway_association.lsbin_nat_web3,
    azurerm_network_interface_security_group_association.lsbin_batnicsec,
    azurerm_network_interface_security_group_association.lsbin_web1nicsec,
    azurerm_network_interface_security_group_association.lsbin_web2nicsec,
    azurerm_subnet_network_security_group_association.lsbin_pe_assoc_a,
    azurerm_subnet_network_security_group_association.lsbin_web1_subnet_assoc_a,
    azurerm_subnet_network_security_group_association.lsbin_web2_subnet_assoc_a
  ]
}
