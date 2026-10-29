
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  lower   = false
  special = false
  numeric = true
}

resource "azurecaf_name" "name" {
  resource_type = "azurerm_eventhub_namespace"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.suffix.result ]
}

resource "azurerm_eventhub_namespace" "example" {
  name                = azurecaf_name.name.result
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  local_authentication_enabled = var.local_authentication_enabled
  capacity            = var.capacity

  # Public access is only enabled when specific IPs are allowed; otherwise private endpoint only.
  public_network_access_enabled = length(var.allowed_ip_addresses) > 0

  dynamic "network_rulesets" {
    for_each = length(var.allowed_ip_addresses) > 0 ? [1] : []
    content {
      default_action                 = "Deny"
      public_network_access_enabled  = true
      trusted_service_access_enabled = var.trusted_service_access_enabled

      dynamic "ip_rule" {
        for_each = var.allowed_ip_addresses
        content {
          ip_mask = ip_rule.value
          action  = "Allow"
        }
      }
    }
  }

  tags = var.tags
}


resource "azurerm_private_endpoint" "eventhub_namespace_pep" {
  name = "pe-${azurerm_eventhub_namespace.example.name}"
  location = azurerm_eventhub_namespace.example.location
  subnet_id = var.private_endpoint_subnet_id
  resource_group_name = var.resource_group_name
  private_service_connection {
    is_manual_connection = false
    name = "pe-connection-${azurerm_eventhub_namespace.example.name}"
    private_connection_resource_id = azurerm_eventhub_namespace.example.id
    subresource_names = [ "namespace" ]
  }
  private_dns_zone_group {
    private_dns_zone_ids = var.private_endpoint_dns_zone_ids
    name = var.private_endpoint_dns_zone_group_name
  }
}
