variable "name" {
  description = "Name of the acr"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "location" {
  description = "Location"
  type        = string
  default     = "westeurope"
}

variable "private_endpoint_subnet_id" {
  description = "Subnet id for private endpoint"
  type        = string
}

variable "enable_admin_login" {
  description = "Is admin login enabled, defaults to false"
  type        = bool
  default     = false
}
