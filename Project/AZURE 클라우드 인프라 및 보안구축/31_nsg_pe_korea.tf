resource "azurerm_network_security_group" "lsbin_nsg_pe_a" {
  name                = "lsbin-nsg-pe-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  # Web1/Web2/Web3-b -> PE Subnet(MySQL 3306) 인바운드 허용
  security_rule {
    name                       = "allow-web-to-pe-mysql-3306"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["10.0.1.0/24", "10.0.2.0/24", "10.1.1.0/24"]
    source_port_range          = "*"
    destination_address_prefix = "10.0.6.0/24"
    destination_port_range     = "3306"
  }
}
