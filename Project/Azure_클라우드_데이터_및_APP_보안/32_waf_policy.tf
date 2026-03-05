resource "azurerm_web_application_firewall_policy" "lsbin_waf" {
  name                = "${var.prefix}-waf-appgw"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  tags                = local.common_tags

  policy_settings {
    enabled = true
    mode    = "Detection"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}
