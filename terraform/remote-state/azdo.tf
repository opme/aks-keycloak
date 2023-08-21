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
  project_ids2 = [ for key in azuredevops_project.org : key.id ]
}

output "project_ids" {
  description = "Resource IDs of created projects"
  value       = local.project_ids
}

output "project_ids2" {
  description = "Resource IDs of created projects"
  value       = local.project_ids2
}

module "multi_stage_repo" {
  for_each = local.project_ids
  source = "./modules/repo/multi-stage-terraform"

  application_name = var.application_name
  project_id       = each.value
  repo_name        = "test-terraform"
  reviewers        = var.reviewers

  environments = {
    dev = {
      azure_credential = var.dev_subscription
      azure_backend    = var.dev_backend
    }
    prod = {
      azure_credential = var.prod_subscription
      azure_backend    = var.prod_backend
    }
  }
}
