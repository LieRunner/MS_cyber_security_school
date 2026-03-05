resource "azurerm_network_interface" "lsbin_bat_nic_b" {
  name                = "lsbin-bat-nic-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-bat-nic-ipcon-b"
    subnet_id                     = azurerm_subnet.lsbin_bat_b.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.1.0.4"
    public_ip_address_id          = azurerm_public_ip.lsbin_batip_b.id
  }
}



resource "azurerm_network_interface" "lsbin_web3_nic_b" {
  name                = "lsbin-web3-nic-b"
  location            = azurerm_resource_group.lsbin_rg_02.location
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-web3-nic-ipcon-b"
    subnet_id                     = azurerm_subnet.lsbin_web3_b.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.1.1.4"
  }
}

#resource "azurerm_network_interface" "lsbin_db_nic_b" {
#  name                = "lsbin-db-nic-b"
#  location            = var.lo_02
#  resource_group_name = var.na_02

#  ip_configuration {
#    name                          = "lsbin-db-nic-ipcon-b"
#    subnet_id                     = azurerm_subnet.lsbin_db_b.id
#    private_ip_address_allocation = "Static"
#    private_ip_address_version    = "IPv4"
#    private_ip_address            = "10.1.4.4"
#public_ip_address_id          = azurerm_public_ip.lsbin_batip-b.id
#  }
#}
