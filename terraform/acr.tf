resource "azurerm_container_registry" "acr" {
  provider = azurerm.target

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = var.enable_admin_login

  tags = merge(var.tags,
    {
      component = "acr"
  })

  network_rule_set {
    default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }
}
