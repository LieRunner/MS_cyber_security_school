locals {
  size          = "Standard_B4ms"
  prodid        = replace(trimspace(file("${path.module}/prodid.txt")), "\ufeff", "")
  db_admin_pass = replace(trimspace(file("${path.module}/db_admin_pass.txt")), "\ufeff", "")
  ro_db_pass    = replace(trimspace(file("${path.module}/ro_db_pass.txt")), "\ufeff", "")

  common_tags = {
    Project     = "Team03-Project"
    Owner       = "lsbin"
    Environment = "Production"
  }
}

locals {
  fdid = azurerm_cdn_frontdoor_profile.lsbin_fd.resource_guid
}
