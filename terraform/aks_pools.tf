resource "azurerm_kubernetes_cluster_node_pool" "cluster_pool" {
  for_each = var.aks_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  priority             = each.value.priority
  orchestrator_version = each.value.orchestrator_version != null ? each.value.orchestrator_version : var.kubernetes_version

  vm_size         = each.value.pool_vm_size
  os_disk_size_gb = each.value.pool_os_disk_size_gb
  os_disk_type    = each.value.pool_os_disk_type

  node_taints = each.value.priority == "Spot" ? concat(each.value.node_taints, ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]) : each.value.node_taints
  node_labels = each.value.priority == "Spot" ? merge(each.value.node_labels, { "kubernetes.azure.com/scalesetpriority" = "spot" }) : each.value.node_labels

  node_count = each.value.pool_node_count
  max_pods   = each.value.max_pods

  enable_auto_scaling = each.value.enable_auto_scaling
  max_count           = each.value.enable_auto_scaling ? each.value.max_count : null
  min_count           = each.value.enable_auto_scaling ? each.value.min_count : null

  eviction_policy = each.value.priority == "Spot" ? each.value.eviction_policy : null

  spot_max_price = each.value.priority == "Spot" ? each.value.spot_max_price : null
  vnet_subnet_id = var.subnet_id

  lifecycle {
    ignore_changes = [
      node_count # with this we ensure that the initial node count can vary without
    ]
  }
}
