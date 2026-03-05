resource "azurerm_network_security_group" "lsbin_nsg_bat" {
  name                = "${var.prefix}-nsg-bat"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  tags                = local.common_tags

  security_rule {
    name                       = "ssh-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["61.108.60.26", "122.36.194.150"] # User specific IPs
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
}

resource "azurerm_network_security_group" "lsbin_nsg_web" {
  name                = "${var.prefix}-nsg-web"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  tags                = local.common_tags

  security_rule {
    name                       = "http-from-appgw"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnet_prefixes["load"][0] # AppGW Subnet
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "http-from-internal"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnet_prefixes["bat"][0] # Bastion Subnet (내부 테스트용)
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "ssh-from-bastion"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.0.0.4/32" # Bastion IP
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
}

resource "azurerm_network_security_group" "lsbin_nsg_db" {
  name                = "${var.prefix}-nsg-db"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  tags                = local.common_tags

  security_rule {
    name                       = "mysql-from-web"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.subnet_prefixes["web"][0] # Web Subnet (10.0.1.0/24)
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3306"
  }


}

resource "azurerm_network_security_group" "lsbin_nsg_appgw" {
  name                = "${var.prefix}-nsg-appgw"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  tags                = local.common_tags

  # AppGW Infrastructure Ports
  security_rule {
    name                       = "allow-gatewaymanager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["65200-65535"]
  }

  # Public Traffic
  security_rule {
    name                       = "allow-internet-80-443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["80", "443"]
  }

  # Azure Load Balancer
  security_rule {
    name                       = "allow-azure-lb"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}
