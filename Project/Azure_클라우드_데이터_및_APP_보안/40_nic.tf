resource "azurerm_network_interface" "lsbin_bat_nic" {
  name                = "${var.prefix}-bat-nic"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
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
  name                = "${var.prefix}-web1-nic"
  location            = azurerm_resource_group.team03_lsbin_rg.location
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "lsbin-web1-nic-ipcon"
    subnet_id                     = azurerm_subnet.lsbin_web1.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "10.0.1.4"
  }
}
