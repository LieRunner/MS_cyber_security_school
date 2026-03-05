resource "azurerm_linux_virtual_machine" "lsbin_web3vm_b" {
  name                  = "lsbin-web3vm"
  resource_group_name   = azurerm_resource_group.lsbin_rg_02.name
  location              = azurerm_resource_group.lsbin_rg_02.location
  size                  = local.size
  admin_username        = "lsbin"
  network_interface_ids = [azurerm_network_interface.lsbin_web3_nic_b.id]
  tags                  = local.common_tags

  admin_ssh_key {
    # 2026-01-25 12:44
    # 원본: public_key = file("id_rsa.pub")
    # 변경: public_key = trimspace(file("${path.module}/id_rsa.pub"))
    # 사유: Azure API에서 줄바꿈 및 UTF-8 BOM 문자가 포함된 경우 Invalid SSH Key 오류(400)가 발생하므로 trimspace 추가 및 경로 명확화
    public_key = trimspace(file("${path.module}/keys/id_rsa.pub"))
    username   = "lsbin"
  }

  custom_data = base64encode(templatefile("${path.module}/110_install.sh.tftpl", {
    db_host = azurerm_mysql_flexible_server.mysql-a[0].fqdn
    db_name = "wordpress"

    # WordPress가 실제로 사용할 쓰기 전용 계정
    ro_db_user = var.ro_db_user
    ro_db_pass = local.ro_db_pass

    # (자동 생성/권한부여용) 관리자 계정
    db_admin      = var.db_admin
    db_admin_pass = local.db_admin_pass

    # Front Door FQDN 고정값
    fd_fqdn = azurerm_cdn_frontdoor_endpoint.lsbin_fd_ep.host_name

    # 커스텀 도메인 (WordPress 설정용)
    custom_domain = var.custom_domain
  }))

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "resf"
    offer     = "rockylinux-x86_64"
    sku       = "9-lvm"
    version   = "9.3.20231113"
  }

  plan {
    publisher = "resf"
    product   = "rockylinux-x86_64"
    name      = "9-lvm"
  }
  boot_diagnostics {
    storage_account_uri = null
  }
}
