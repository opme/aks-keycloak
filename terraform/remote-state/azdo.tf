resource "azuredevops_project" "test" {
  name        = var.project_name
  description = "Go compilation project"
}

# read the projects from tfvars and create them
locals {
  project_keys = toset(keys(var.org_setup))  # Gets keys of the outermost map (project names)
}

output "project_keys_output" {
  value = local.project_keys
}

resource "azuredevops_project" "org" {
  for_each = local.project_keys
  name        = each.key
}

locals {
  project_ids = { for key, project in azuredevops_project.org : key => project.id }
}

output "project_ids" {
  description = "Resource IDs of created projects"
  value       = local.project_ids
}

locals {
  project_values = { for key, project in var.org_setup : key => project }
}


output "project_values" {
  description = "Resource IDs of created projects"
  value       = local.project_values
}

module "multi_stage_repo" {
  for_each = var.org_setup
  source = "./modules/repo/multi-stage-terraform"

  application_name = var.application_name
  project       = each.key
  repo_name        = "test-terraform"
  reviewers        = var.reviewers

  environments = each.value.environments
#  environments = {
#    dev = {
#      azure_credential = var.dev_subscription
#      azure_backend    = var.dev_backend
#    }
#    prod = {
#      azure_credential = var.prod_subscription
#      azure_backend    = var.prod_backend
#    }
#  }
#  depends_on = [ azuredevops_project.org ]
}
