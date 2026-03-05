resource "azurerm_application_gateway" "lsbin_appgw" {
  name                = "${var.prefix}-appgw"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
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
      azurerm_network_interface.lsbin_web1_nic.private_ip_address
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

    host = "127.0.0.1"

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

  firewall_policy_id = azurerm_web_application_firewall_policy.lsbin_waf.id
}

# [진단 설정] App Gateway 로그를 LAW로 전송 (WAF 로그 확인용)
resource "azurerm_monitor_diagnostic_setting" "appgw_diag" {
  name                       = "${var.prefix}-diag-appgw"
  target_resource_id         = azurerm_application_gateway.lsbin_appgw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lsbin_law.id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_application_gateway.lsbin_appgw,
    azurerm_log_analytics_workspace.lsbin_law
  ]
}
