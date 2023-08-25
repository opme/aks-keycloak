resource "azuredevops_project" "project" {
  name        = var.project_name
  description = "Go compilation project"
}

locals {
  project_id = azuredevops_project.project.id
}

output "project_id" {
  value = local.project_id
}

# add reviewers
data "azuredevops_users" "reviewers" {
  count          = length(var.reviewers)
  principal_name = var.reviewers[count.index]
}
locals {
  user_descriptors = flatten([for k in data.azuredevops_users.reviewers : k.users]).*.descriptor
}
module "reviewer_group" {
  source = "../modules/group/baseline"

  project_id  = local.project_id
  name        = "Terraform Reviewers"
  description = "Terraform Reviewers Description"
  members     = local.user_descriptors

}

module "multi_stage_repo" {
  source = "../modules/repo/multi-stage-terraform"

  application_name = var.application_name
  project       = var.project_name
  repo_name        = "test-terraform"
  reviewers        = var.reviewers

  environments = var.project["environments"]
  depends_on = [ azuredevops_project.project ]
}

resource "azuredevops_environment" "main" {
  for_each = var.project["environments"]
  project_id = local.project_id
  name       = "${var.application_name}-${each.key}"
}

module "pipeline" {
  source = "../modules/pipeline/multi-stage-terraform"

  for_each = var.project["environments"]

  application_name = var.application_name
  environment_name = each.key
  project_id       = local.project_id
  repo_id          = module.multi_stage_repo.repo.id
  default_branch   = module.multi_stage_repo.repo.default_branch
  azure_backend          = each.value.azure_backend
  azure_credential     = each.value.azure_credentials
}

locals {
  branch_policy_environments = {
    for k, v in var.project["environments"] : k =>
    {
      build_definition_id = module.pipeline[k].plan_build_definition_id
      working_directory   = "/src/terraform/*"
    }
  }
}

module "branching_policy" {
  source = "../modules/branch-policy/multi-stage-terraform"

  environments              = local.branch_policy_environments
  project_id                = local.project_id
  min_reviewers_enabled     = var.min_reviewers_enabled
  min_reviewer_count        = var.min_reviewer_count
  work_item_linking_enabled = var.work_item_linking_enabled
  reviewer_group_id         = module.reviewer_group.origin_id

}
