resource "azurerm_linux_virtual_machine" "lsbin_batvm" {
  name                  = "lsbin-batvm"
  resource_group_name   = azurerm_resource_group.lsbin_rg_01.name
  location              = azurerm_resource_group.lsbin_rg_01.location
  size                  = local.size
  admin_username        = "lsbin"
  network_interface_ids = [azurerm_network_interface.lsbin_bat_nic.id]
  tags                  = local.common_tags

  admin_ssh_key {
    public_key = trimspace(file("${path.module}/keys/id_rsa.pub"))
    username   = "lsbin"
  }
  user_data = base64encode(templatefile("${path.module}/111_key.sh.tftpl", {
    private_key = file("${path.module}/keys/id_rsa")
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
