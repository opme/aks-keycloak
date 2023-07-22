location = "eastus"
cluster_name = "demo"
aks_cluster_sku_tier = "Free"
kubernetes_version = "1.27"
aks_users                  = ""
aks_admins                 = ""
admin_aad_group_object_ids = ""
enable_rbac               = true # enable azure ad rbac
enable_aad_integrated_aks = true # enable aad integration with the aks cluster ie. users need to authenticate with azure ad

default_pool = {
  pool_node_count      = 2
  pool_vm_size         = "Standard_D8ds_v5"
  pool_os_disk_size_gb = 128
  pool_os_disk_type    = "Ephemeral"
}
aks_pools = {
  general = {
    name                 = "general"
    priority             = "Regular"
    pool_node_count      = 2
    pool_vm_size         = "Standard_D8ds_v5"
    pool_os_disk_size_gb = 256
    pool_os_disk_type    = "Ephemeral"

    node_taints = []
    node_labels = {
      "agentpool" : "general"
    }

    enable_auto_scaling = true
    max_count           = 4
    min_count           = 1
    max_pods            = 30
  },
}
tags = {
  "note" = "sample cluster"
}
addons = {}
