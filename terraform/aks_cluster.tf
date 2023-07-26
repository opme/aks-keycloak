provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  tags                = var.tags

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  timeouts {
    update = "90m"
  } 

  default_node_pool {
    name                 = "default"
    enable_auto_scaling  = false
    node_count           = var.default_pool.pool_node_count
    vm_size              = var.default_pool.pool_vm_size
    type                 = "VirtualMachineScaleSets"
    os_disk_size_gb      = var.default_pool.pool_os_disk_size_gb
    os_disk_type         = var.default_pool_os_disk_type
    vnet_subnet_id       = azurerm_subnet.aks-default.id
    orchestrator_version = var.kubernetes_version
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = "calico"
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  }
}
