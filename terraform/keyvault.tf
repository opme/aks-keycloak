resource "azurerm_key_vault" "kv" {
  name                = "${random_pet.prefix.id}-demo-kv"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
 
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
 
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
}
