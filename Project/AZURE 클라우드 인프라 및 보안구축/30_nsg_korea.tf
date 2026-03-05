resource "azurerm_network_security_group" "lsbin_nsg_ssh" {
  name                = "lsbin-nsg-ssh"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  security_rule {
    name                       = "ssh"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["61.108.60.26", "10.0.0.0/16", "122.36.194.150"]
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_range     = "22"
  }
}



resource "azurerm_network_security_group" "lsbin_nsg_http" {
  name                = "lsbin-nsg-http"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  security_rule {
    name                       = "http"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_range     = "80"
  }

  security_rule {
    name                       = "ssh-bastion"
    priority                   = "101"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "10.0.0.0/24"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_range     = "22"
  }
}



resource "azurerm_network_security_group" "lsbin_web_nsg_a" {
  name                = "lsbin-nsg-web-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  security_rule {
    name                       = "allow-web-to-pe-mysql-3306"
    priority                   = "200"
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["10.0.1.0/24", "10.0.2.0/24"]
    source_port_range          = "*"
    destination_address_prefix = "10.0.6.0/24"
    destination_port_range     = "3306"
  }
}



resource "azurerm_network_security_group" "lsbin_fd_only_appgw_a" {
  name                = "lsbin-nsg-fd-only-appgw-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  security_rule {
    name                       = "allow-gatewaymanager"
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "GatewayManager"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["65200-65535"]
  }

  security_rule {
    name                       = "allow-afd-backend-80-443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureFrontDoor.Backend"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["80", "443"]
  }

  security_rule {
    name                       = "azure-lb"
    priority                   = "120"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "AzureLoadBalancer"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "DenyInternet80_443"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "Internet"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_ranges    = ["80", "443"]
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = "4096"
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}
