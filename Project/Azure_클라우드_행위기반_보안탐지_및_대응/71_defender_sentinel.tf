resource "azurerm_sentinel_data_connector_azure_security_center" "lsbin_mdc_to_sentinel" {
  name                       = "${var.prefix}-mdc-connector"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lsbin_law.id
  subscription_id            = local.prodid
}
