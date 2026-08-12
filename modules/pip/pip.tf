variable "pips" {}

resource "azurerm_public_ip" "pip" {
  for_each = var.pips

  name                = each.value.pip
  location            = each.value.location
  resource_group_name = each.value.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}