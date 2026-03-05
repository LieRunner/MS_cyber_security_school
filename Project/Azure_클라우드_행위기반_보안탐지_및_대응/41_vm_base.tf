resource "azurerm_linux_virtual_machine" "lsbin_batvm" {
  name                  = "${var.prefix}-batvm"
  resource_group_name   = azurerm_resource_group.team03_lsbin_rg.name
  location              = azurerm_resource_group.team03_lsbin_rg.location
  size                  = var.vm_size
  admin_username        = "lsbin"
  network_interface_ids = [azurerm_network_interface.lsbin_bat_nic.id]
  tags                  = local.common_tags

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    public_key = trimspace(file("${path.module}/keys/id_rsa.pub"))
    username   = var.admin_username
  }
  user_data = base64encode(templatefile("${path.module}/99_key.sh.tftpl", {
    private_key = file("${path.module}/keys/id_rsa")
  }))

  os_disk {
    name                 = "${var.prefix}-batvm-osdisk"
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
