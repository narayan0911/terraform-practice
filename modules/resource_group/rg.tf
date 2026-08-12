variable "rgs" {}

resource "azurerm_resource_group" "rg" {
  for_each = var.rgs

  name     = each.value.rg
  location = each.value.location
}