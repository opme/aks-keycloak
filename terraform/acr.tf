locals {
  acr_name = "${replace(var.dns_prefix, "-", "")}acr"
}
resource "azurerm_container_registry" "aks" {
  name                     = local.acr_name
  resource_group_name      = azurerm_resource_group.aks.name
  location                 = azurerm_resource_group.aks.location
  sku                      = "Standard"
  admin_enabled            = false
}
