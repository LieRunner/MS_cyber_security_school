resource "azurerm_private_dns_zone" "lsbin_pdns" {
  count               = var.enable_db_korea ? 1 : 0
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  tags                = local.common_tags
}



resource "azurerm_private_dns_zone_virtual_network_link" "lsbin_pdns_vnetlink_a" {
  count                 = var.enable_db_korea ? 1 : 0
  name                  = "lsbin-pdns-vnetlink"
  resource_group_name   = azurerm_resource_group.lsbin_rg_01.name
  private_dns_zone_name = azurerm_private_dns_zone.lsbin_pdns[0].name
  virtual_network_id    = azurerm_virtual_network.lsbin_vnet.id
  tags                  = local.common_tags
}



resource "azurerm_private_dns_zone_virtual_network_link" "lsbin_pdns_vnetlink_b" {
  count                 = (var.enable_db_korea && var.enable_db_canada) ? 1 : 0
  name                  = "lsbin-pdns-vnetlink-b"
  resource_group_name   = azurerm_resource_group.lsbin_rg_01.name
  private_dns_zone_name = azurerm_private_dns_zone.lsbin_pdns[0].name
  virtual_network_id    = azurerm_virtual_network.lsbin_vnet_b.id
  tags                  = local.common_tags
}
