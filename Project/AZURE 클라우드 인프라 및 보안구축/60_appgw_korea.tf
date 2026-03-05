resource "azurerm_application_gateway" "lsbin_appgw" {
  name                = "lsbin-appgw"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.lsbin_load.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lsbin_loadip.id
  }

  backend_address_pool {
    name = "backend-pool"
    ip_addresses = [
      azurerm_network_interface.lsbin_web1_nic.private_ip_address,
      azurerm_network_interface.lsbin_web2_nic.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60

    probe_name = "health-probe"
  }

  probe {
    name                = "health-probe"
    protocol            = "Http"
    path                = "/health.html"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    host = "localhost"

    match {
      status_code = ["200-399"]
    }
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.lsbin_waf_a.id
}
