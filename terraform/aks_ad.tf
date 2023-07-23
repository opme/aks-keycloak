resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.aks.location
  name                = "${random_pet.prefix.id}-uai"
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.aks.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "cluster_users_assignment" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.aks_users
}

resource "azurerm_role_assignment" "cluster_admins_assignment" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = var.aks_admins
}
