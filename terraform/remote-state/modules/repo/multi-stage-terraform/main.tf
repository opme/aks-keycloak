data "azuredevops_project" "project" {
  name = var.project
}

output "project" {
  value = data.azuredevops_project.project
}

locals {
  project_id = data.azuredevops_project.project.id
}

resource "azuredevops_git_repository" "main" {

  project_id = data.azuredevops_project.project.id
  name       = var.repo_name

  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/opme/azdo-terraform-template-multi-stage.git"
  }

}

data "azuredevops_users" "main" {
  count          = length(var.reviewers)
  principal_name = var.reviewers[count.index]
}
