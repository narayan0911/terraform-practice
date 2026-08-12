variable "subnets" {}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.subnet
  resource_group_name  = each.value.rg
  virtual_network_name = each.value.vnet
  address_prefixes     = each.value.address_prefixes
}