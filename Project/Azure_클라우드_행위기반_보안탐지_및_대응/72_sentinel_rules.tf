resource "azurerm_sentinel_alert_rule_scheduled" "detect_ssh_bruteforce" {
  name                       = "${var.prefix}-rule-ssh-bruteforce"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lsbin_law.id
  display_name               = "[Security] 비정상적인 SSH 로그인 실패 탐지"
  description                = "10분 내에 동일한 IP에서 5회 이상 SSH 로그인에 실패할 경우 브루트포스 공격으로 간주하고 보안 인시던트를 생성합니다."
  severity                   = "Medium"

  query = <<-KQL
    Syslog
    | where Facility == "auth" or Facility == "authpriv"
    | where SyslogMessage has "Failed password" or SyslogMessage has "Invalid user"
    | parse SyslogMessage with * "from " SourceIP " port" *
    | summarize FailureCount = count() by SourceIP, Computer
    | where FailureCount >= 5
  KQL

  query_frequency     = "PT10M"
  query_period        = "PT10M"
  trigger_operator    = "GreaterThan"
  trigger_threshold   = 0
  suppression_enabled = false

  incident {
    create_incident_enabled = true
    grouping {
      enabled                 = true
      lookback_duration       = "PT5H"
      reopen_closed_incidents = false
      entity_matching_method  = "AllEntities"
    }
  }
}
