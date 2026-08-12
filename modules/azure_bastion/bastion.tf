variable "bastion" {}

data "azurerm_public_ip" "bastion" {
  for_each = var.bastion

  name                = each.value.pip
  resource_group_name = each.value.rg
}

data "azurerm_subnet" "bastion" {
  for_each = var.bastion

  name                 = each.value.subnet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
}

resource "azurerm_bastion_host" "bastion" {
  for_each = var.bastion

  name                = each.value.bastion
  location            = each.value.location
  resource_group_name = each.value.rg
  
  ip_configuration {
    name                 = each.value.ip_config_name
    subnet_id            = data.azurerm_subnet.bastion[each.key].id
    public_ip_address_id = data.azurerm_public_ip.bastion[each.key].id
  }
}