variable "cluster_name" {
  description = "Short friendly name for the AKS cluster. Used as part of the FQDN so only standard letters and numbers (eg. 'tools1')"
  type        = string
}

variable "location" {
  description = "Target region where the module should be deployed into"
  type        = string
}

variable "default_pool" {
  description = "Object that describes the default node pool"
  type = object({
    pool_node_count      = number
    pool_vm_size         = string
    pool_os_disk_size_gb = number
  })
}

variable "default_pool_os_disk_type" {
  description = "Disk type (managed / ephemeral) for the os disk. Controlled with a separate variable for the node pools"
  type        = string
  default     = "Managed"
}

variable "aks_admins" {
  description = "Azure AD object id of the group or user designated to get clusterAdmin permissions"
  type        = string
}

variable "aks_users" {
  description = "Azure AD object id of the group or user designated to get clusterUser permissions"
  type        = string
}

variable "aks_pools" {
  description = "Configuration for non-default node pools to be deployed for the cluster"
  type = map(
    object({
      name = string

      # "Regular" or "Spot"
      priority = optional(string, "Regular")

      pool_node_count      = optional(number, 1)
      pool_vm_size         = string
      pool_os_disk_size_gb = optional(string, "20")
      pool_os_disk_type    = optional(string, "Managed")

      # Defaults to var.kubernetes_version
      orchestrator_version = optional(string, null)

      enable_auto_scaling = optional(bool, false)
      max_count           = optional(number, 1000)
      min_count           = optional(number, 1)
      max_pods            = optional(number, 250)

      # If priority is "Spot", this defaults to
      #   ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"]
      node_taints = optional(list(string), [])
      # If priority is "Spot", this defaults to
      #   {"kubernetes.azure.com/scalesetpriority" = "spot"}
      node_labels = optional(map(string), {})

      # If priority is "Spot", this defaults to "Delete"
      eviction_policy = optional(string, "Delete")
      # The maximum price you're willing to pay in USD per Virtual Machine.
      # Valid values are -1 (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places.
      spot_max_price = optional(string, null)
    })
  )
}

variable "kubernetes_version" {
  description = "Kubernetes version to be used in this cluster. You can check the available ones by running 'az aks get-versions'"
  type        = string
}

variable "aks_cluster_sku_tier" {
  description = "turns on or off paid Uptime SLA for the AKS (free or paid value)"
  type        = string
}

variable "enable_rbac" {
  description = "Boolean value for enabling or disabling Azure AD rbac"
  type        = bool
}

variable "enable_aad_integrated_aks" {
  description = "Boolean value for enabling or disabling Azure AD integrated AKS"
  type        = bool
}

variable "network_plugin" {
  description = "The network plugin of choice for a new AKS cluster. Suitable values are either kubenet or azure. Changing this value requires a cluster redeployment."
  type        = string
  default     = "azure"
}

variable "enable_container_log_v2" {
  description = "Boolean of enabling containerLogV2 schemas (preview feature in aks)"
  type        = bool
  default     = false
}

variable "aks_identity" {
  description = "User assigned managed identity resource"
  type = object({
    id           = string
    principal_id = string
  })
  default = null
}

variable "tags" {
  description = "Map object of tag key-value pairs to be added."
  type        = map(string)
}

variable "admin_aad_group_object_ids" {
  description = "Object id for the Azure AD group that will serve as the administrator, in case enable_aad_integrated_aks is enabled"
  type = string
}

variable "acr_enable_admin_login" {
  description = "Is admin login enabled, defaults to false"
  type        = bool
  default     = false
}
