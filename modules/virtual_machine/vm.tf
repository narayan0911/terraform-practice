variable "vms" {}

data "azurerm_subnet" "vm" {
  for_each = var.vms

  name                 = each.value.subnet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
}

data "azurerm_key_vault" "kv" {
  for_each = var.vms
  name                = each.value.kv
  resource_group_name = each.value.rg

}

data "azurerm_key_vault_secret" "vm_password" {

  for_each = var.vms

  name         = each.value.password_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id

}

resource "azurerm_network_interface" "vm" {
  for_each = var.vms

  name                = each.value.nic
  location            = each.value.location
  resource_group_name = each.value.rg

  ip_configuration {
    name                          = each.value.ip_config_name
    subnet_id                     = data.azurerm_subnet.vm[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.vms

  name                = each.value.vm
  location            = each.value.location
  resource_group_name = each.value.rg
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = data.azurerm_key_vault_secret.vm_password[each.key].value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }


}