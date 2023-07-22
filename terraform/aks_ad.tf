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
