
variable "solution_name" {
  description = "The solution name used in the generated Event Hub namespace name"
  type        = string
}

variable "environment" {
  description = "The environment used in the generated Event Hub namespace name"
  type        = string
}

variable "location" {
  description = "The Azure location where the Event Hub namespace will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "sku" {
  description = "The SKU for the Event Hub namespace (Standard or Dedicated)"
  type        = string
  default     = "Standard"

  # Basic does not support private endpoints, which this module always creates.
  validation {
    condition     = contains(["Standard", "Dedicated"], var.sku)
    error_message = "SKU must be one of: Standard or Dedicated."
  }
}

variable "capacity" {
  description = "The capacity for the Event Hub namespace (throughput units)"
  type        = number
  default     = 2

  validation {
    condition     = var.capacity >= 1 && var.capacity <= 20
    error_message = "Capacity must be between 1 and 20."
  }
}

variable "tags" {
  description = "A map of tags to apply to the resources"
  type        = map(string)

}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet where the private endpoint will be created"
  type        = string
}

variable "private_endpoint_dns_zone_ids" {
  description = "A list of private DNS zone IDs for the private endpoint"
  type        = list(string)
  default     = ["/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"]
}

variable "private_endpoint_dns_zone_group_name" {
  description = "The name of the private DNS zone group"
  type        = string
  default     = "default"
}

variable "allowed_ip_addresses" {
  description = "IPv4 addresses or CIDR ranges allowed to reach the namespace over the public endpoint. When empty, public access is disabled (private endpoint only)."
  type        = list(string)
  default     = []
}

variable "trusted_service_access_enabled" {
  description = "Whether trusted Microsoft services can bypass the IP rules (only applies when allowed_ip_addresses is set)"
  type        = bool
  default     = false
}

variable "local_authentication_enabled" {
  description = "Whether local authentication is enabled for the Event Hub namespace"
  type        = bool
  default     = false
}
