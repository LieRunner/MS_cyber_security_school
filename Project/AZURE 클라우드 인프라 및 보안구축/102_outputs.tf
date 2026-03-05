output "bat-pubip" {
  value = azurerm_public_ip.lsbin_batip.ip_address
}

output "bat-pubip-b" {
  value = azurerm_public_ip.lsbin_batip_b.ip_address
}

output "frontdoor_fqdn" {
  value = azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.host_name
}

output "Pdns-fqdn-a" {
  value = try(azurerm_private_endpoint.lsbin_pe[0].private_dns_zone_configs[0].record_sets[0].fqdn, null)
}

output "Pdns-fqdn-b" {
  value = try(azurerm_private_endpoint.lsbin_pe_b[0].private_dns_zone_configs[0].record_sets[0].fqdn, null)
}

# 2026-01-27 19:51 / switch_dr.ps1 자동 변수 로드를 위한 출력 추가
output "subscription_id" {
  value = local.prodid
}

output "primary_rg" {
  value = azurerm_resource_group.lsbin_rg_01.name
}

output "replica_rg" {
  value = azurerm_resource_group.lsbin_rg_02.name
}

output "mysql_primary_name" {
  value = azurerm_mysql_flexible_server.mysql-a[0].name
}

output "mysql_replica_name" {
  value = azurerm_mysql_flexible_server.mysql-b[0].name
}

output "mysql_admin_user" {
  value = var.db_admin
}

output "dns_zone_name" {
  value = azurerm_private_dns_zone.lsbin_pdns[0].name
}

output "dns_record_name" {
  value = "lsbin-db"
}

output "dns_setup_guide_cname" {
  value = "CNAME: www -> ${azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.host_name}"
}

output "dns_setup_guide_txt" {
  value = "TXT: _dnsauth.www -> ${azurerm_cdn_frontdoor_custom_domain.lsbin_fd_custom.validation_token}"
}
