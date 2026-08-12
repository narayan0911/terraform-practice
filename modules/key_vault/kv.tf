variable "kvs" {}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.kvs

  name                = each.value.kv
  location            = each.value.location
  resource_group_name = each.value.rg
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
    ]

    secret_permissions = [
      "Get",
      "List",
    ]
  }
}