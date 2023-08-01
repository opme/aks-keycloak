data "azurerm_client_config" "current" {} 

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "adfsample"
  location = "eastus"
}

resource "azurerm_data_factory" "example" {
  name                = "adf-sample-factory"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_data_factory_pipeline" "example" {
  name            = "adf-sample-pipeline"
  data_factory_id = azurerm_data_factory.example.id
}
