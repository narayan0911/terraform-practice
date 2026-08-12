variable "AGW" {}

data "azurerm_public_ip" "appgw" {
  for_each = var.AGW

  name                = each.value.frontend_public_ip
  resource_group_name = each.value.rg
}

data "azurerm_subnet" "appgw" {
  for_each = var.AGW

  name                 = each.value.subnet
  virtual_network_name = each.value.vnet
  resource_group_name  = each.value.rg
}

resource "azurerm_application_gateway" "appgw" {
  for_each = var.AGW

  name                = each.value.appgw
  location            = each.value.location
  resource_group_name = each.value.rg

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

    ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = data.azurerm_subnet.appgw[each.key].id
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_name
    public_ip_address_id = data.azurerm_public_ip.appgw[each.key].id
  }

  frontend_port {
    name = "appgw-port"
    port = each.value.frontend_port
  }

  backend_address_pool {
    name        = each.value.backend_pool_name
    ip_addresses = compact([for addr in each.value.backend_addresses : addr.ip_address])
    
  }

  backend_http_settings {
    name                    = each.value.backend_http_settings_name
    cookie_based_affinity   = lookup(each.value, "cookie_based_affinity", "Disabled")
    
    port                    = each.value.backend_port
    protocol                = each.value.protocol
    request_timeout         = 30
    host_name               = "frontend.b18g29.online"
    
  }

  http_listener {
    name                           = each.value.http_listener_name
    frontend_ip_configuration_name = each.value.frontend_ip_name
    frontend_port_name             = "appgw-port"
    protocol                       = each.value.protocol
    host_name                      = "backend.b18g29.online"
  }

  request_routing_rule {
    name                       = each.value.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = each.value.http_listener_name
    backend_address_pool_name  = each.value.backend_pool_name
    backend_http_settings_name = each.value.backend_http_settings_name

    priority = 100
  
}
}
