output "namespace_id" {
  description = "The ID of the Event Hub namespace"
  value       = azurerm_eventhub_namespace.example.id
}

output "namespace_name" {
  description = "The name of the Event Hub namespace"
  value       = azurerm_eventhub_namespace.example.name
}

output "primary_connection_string" {
  description = "The primary connection string for the Event Hub namespace"
  value       = azurerm_eventhub_namespace.example.default_primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The secondary connection string for the Event Hub namespace"
  value       = azurerm_eventhub_namespace.example.default_secondary_connection_string
  sensitive   = true
}
