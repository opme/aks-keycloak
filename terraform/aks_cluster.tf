# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-rg"
  location = "West US 2"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name                 = "default"
    enable_auto_scaling  = false
    node_count           = var.default_pool.pool_node_count
    vm_size              = var.default_pool.pool_vm_size
    type                 = "VirtualMachineScaleSets"
    os_disk_size_gb      = var.default_pool.pool_os_disk_size_gb
    os_disk_type         = var.default_pool_os_disk_type
    vnet_subnet_id       = var.subnet_id
    orchestrator_version = var.kubernetes_version
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  azure_active_directory_role_based_access_control {
    managed                = var.enable_aad_integrated_aks
    admin_group_object_ids = [var.admin_aad_group_object_ids]
    azure_rbac_enabled     = var.enable_rbac
  }

  tags = {
    environment = "Demo"
  }
}
