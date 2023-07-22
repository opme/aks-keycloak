resource "random_pet" "prefix" {}

resource "azurerm_resource_group" "aks" {
  name     = "${random_pet.prefix.id}-rg"
  location = var.location

  tags = {
    environment = "Demo"
  }
}
