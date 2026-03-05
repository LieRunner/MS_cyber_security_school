resource "azurerm_private_endpoint" "lsbin_pe" {
  count               = var.enable_db_korea ? 1 : 0
  name                = "pe-mysql-a"
  resource_group_name = azurerm_resource_group.lsbin_rg_01.name
  location            = azurerm_resource_group.lsbin_rg_01.location
  subnet_id           = azurerm_subnet.lsbin_pe.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "psc-mysql-a"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql-a[0].id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name = "mysql-dns"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.lsbin_pdns[0].id
    ]
  }
}



resource "azurerm_private_endpoint" "lsbin_pe_b" {
  count               = (var.enable_db_canada && var.enable_db_korea) ? 1 : 0
  name                = "pe-mysql-b"
  resource_group_name = azurerm_resource_group.lsbin_rg_02.name
  location            = azurerm_resource_group.lsbin_rg_02.location
  subnet_id           = azurerm_subnet.lsbin_pe_b.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "psc-mysql-b"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql-b[0].id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name = "mysql-dns"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.lsbin_pdns[0].id
    ]
  }
}
