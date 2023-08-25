data "azurerm_client_config" "current" {}

module "azure-terraformer" {
  source  = "markti/azure-terraformer/azuredevops"
  version = "1.0.13"
}

provider "azurerm" {
  features {}
}

provider "azuredevops" {
    org_service_url       = "https://dev.azure.com/shambergerm"
    personal_access_token = "bhfxujqlsh4tbvdjjc2qfdlzno56upjqdabsfbygnzjll74u57ra"
}
