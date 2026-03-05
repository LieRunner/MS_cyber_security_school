locals {
  prodid        = replace(trimspace(file("${path.module}/prodid.txt")), "\ufeff", "")
  db_admin_pass = replace(trimspace(file("${path.module}/db_admin_pass.txt")), "\ufeff", "")

  common_tags = {
    Project     = "${var.prefix}-Project"
    Owner       = var.admin_username
    Environment = "Production"
  }
}
