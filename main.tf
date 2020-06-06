# Configure the Microsoft Azure Provider.
provider "azurerm" {
  version = "~>1.31"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-hca-kestral-rg"
  location = var.location
  tags     = var.tags
}
