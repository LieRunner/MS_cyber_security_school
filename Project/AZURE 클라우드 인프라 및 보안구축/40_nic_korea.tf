resource "azurerm_network_interface" "lsbin_bat_nic" {
  name                = "lsbin-bat-nic"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-bat-nic-ipcon"
    subnet_id                     = azurerm_subnet.lsbin_bat.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.lsbin_batip.id
  }
}



resource "azurerm_network_interface" "lsbin_web1_nic" {
  name                = "lsbin-web1-nic"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-web1-nic-ipcon"
    subnet_id                     = azurerm_subnet.lsbin_web1.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.0.1.4"
  }
}



resource "azurerm_network_interface" "lsbin_web2_nic" {
  name                = "lsbin-web2-nic"
  location            = azurerm_resource_group.lsbin_rg_01.location
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-web2-nic-ipcon"
    subnet_id                     = azurerm_subnet.lsbin_web2.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.0.2.4"
  }
}

#resource "azurerm_network_interface" "lsbin_db_nic" {
#  name                = "lsbin-db-nic"
#  location            = var.lo_01
#  resource_group_name = var.na_01

#  ip_configuration {
#    name                          = "lsbin-db-nic-ipcon"
#    subnet_id                     = azurerm_subnet.lsbin_db.id
#    private_ip_address_allocation = "Static"
#    private_ip_address_version    = "IPv4"
#    private_ip_address            = "10.0.5.4"
#    #public_ip_address_id          = azurerm_public_ip.lsbin_batip.id
#  }
#}
