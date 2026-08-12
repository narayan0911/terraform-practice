variable "nsgs" {}

# data "azurerm_network_interface" "nic" {
#   for_each = var.nsgs

#   name                = each.value.nic
#   resource_group_name = each.value.rg
# }

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.value.nsg
  location            = each.value.location
  resource_group_name = each.value.rg

    security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# resource "azurerm_network_interface_security_group_association" "example" {
#   for_each = var.nsgs
#   network_interface_id      = data.azurerm_network_interface.nic[each.key].id
#   network_security_group_id = azurerm_network_security_group.nsg[each.key].id
# }