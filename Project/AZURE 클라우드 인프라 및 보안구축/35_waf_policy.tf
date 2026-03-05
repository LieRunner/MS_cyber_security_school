resource "azurerm_web_application_firewall_policy" "lsbin_waf_a" {
  name                = "lsbin-waf-appgw-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  tags                = local.common_tags

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  custom_rules {
    name      = "blocknonfrontdoor"
    priority  = 1
    rule_type = "MatchRule"
    action    = "Block"

    match_conditions {
      match_variables {
        variable_name = "RequestHeaders"
        selector      = "X-Azure-FDID"
      }

      operator           = "Equal"
      match_values       = [local.fdid]
      negation_condition = true
    }
  }
}



resource "azurerm_web_application_firewall_policy" "lsbin_waf_b" {
  name                = "lsbin-waf-appgw-b"
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  location            = azurerm_resource_group.lsbin_rg_02.location
  tags                = local.common_tags

  policy_settings {
    enabled = true
    mode    = "Prevention"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  custom_rules {
    name      = "blocknonfrontdoor"
    priority  = 1
    rule_type = "MatchRule"
    action    = "Block"

    match_conditions {
      match_variables {
        variable_name = "RequestHeaders"
        selector      = "X-Azure-FDID"
      }

      operator           = "Equal"
      match_values       = [local.fdid]
      negation_condition = true
    }
  }
}
