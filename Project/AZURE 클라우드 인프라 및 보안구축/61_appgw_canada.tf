resource "azurerm_application_gateway" "lsbin_appgw_b" {
  name                = "lsbin-appgw-b"
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  location            = azurerm_resource_group.lsbin_rg_02.location
  tags                = local.common_tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration-b"
    subnet_id = azurerm_subnet.lsbin_load_b.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-b"
    public_ip_address_id = azurerm_public_ip.lsbin_loadip_b.id
  }

  backend_address_pool {
    name = "backend-pool-b"
    ip_addresses = [
      azurerm_network_interface.lsbin_web3_nic_b.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "http-settings-b"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "health-probe"
  }

  probe {
    name                = "health-probe"
    protocol            = "Http"
    path                = "/health.html"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = "localhost"

    match {
      status_code = ["200-399"]
    }
  }


  http_listener {
    name                           = "http-listener-b"
    frontend_ip_configuration_name = "frontend-b"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule-b"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener-b"
    backend_address_pool_name  = "backend-pool-b"
    backend_http_settings_name = "http-settings-b"
    priority                   = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.lsbin_waf_b.id
}
