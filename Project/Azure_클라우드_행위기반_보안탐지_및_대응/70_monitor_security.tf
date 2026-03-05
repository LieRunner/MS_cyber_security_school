
# 0. [Security] Microsoft Sentinel 활성화 (Onboarding)
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id                 = azurerm_log_analytics_workspace.lsbin_law.id
  customer_managed_key_enabled = false
}


# 1. Data Collection Endpoint (DCE)
resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = "${var.prefix}-dce"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  kind                = "Linux"
  tags                = local.common_tags
}

# 2. Syslog 전용 DCR (이건 문법이 간단해서 성공할 확률 99%)
resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  name                = "${var.prefix}-dcr-linux"
  resource_group_name = azurerm_resource_group.team03_lsbin_rg.name
  location            = azurerm_resource_group.team03_lsbin_rg.location
  kind                = "Linux"
  tags                = local.common_tags

  destinations {
    log_analytics {
      name                  = "law-destination"
      workspace_resource_id = azurerm_log_analytics_workspace.lsbin_law.id
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["law-destination"]
  }

  data_sources {
    syslog {
      name    = "syslog-datasource"
      streams = ["Microsoft-Syslog"]
      facility_names = [
        "auth", "authpriv", "cron", "daemon", "kern", "lpr", "mail", "news", "syslog", "user", "uucp"
      ]
      log_levels = [
        "Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"
      ]
    }
  }
}

# 3. [Agent] VM에 Azure Monitor Agent (AMA) 설치
resource "azurerm_virtual_machine_extension" "ama_web" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.lsbin_web1vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.2"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "ama_bat" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.lsbin_batvm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.2"
  auto_upgrade_minor_version = true
}

resource "time_sleep" "wait_for_ama" {
  create_duration = "60s"

  depends_on = [
    azurerm_virtual_machine_extension.ama_web,
    azurerm_virtual_machine_extension.ama_bat
  ]
}

# 4. [Association] DCR을 VM에 연결
# Syslog 연결 (Web, Bastion)
resource "azurerm_monitor_data_collection_rule_association" "dcr_assoc_web" {
  name                    = "${var.prefix}-dcr-assoc-web"
  target_resource_id      = azurerm_linux_virtual_machine.lsbin_web1vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_linux.id
  depends_on              = [time_sleep.wait_for_ama]
}

resource "azurerm_monitor_data_collection_rule_association" "dcr_assoc_bat" {
  name                    = "${var.prefix}-dcr-assoc-bat"
  target_resource_id      = azurerm_linux_virtual_machine.lsbin_batvm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_linux.id
  depends_on              = [time_sleep.wait_for_ama]
}
