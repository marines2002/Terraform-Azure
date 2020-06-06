
provider "azurerm" {
  version = "~>1.31"
}

resource "azurerm_resource_group" "kestrel" {
  name     = "${var.prefix}-hca-kestrel-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_app_service_plan" "kestrel" {
    name                = "${var.prefix}-hca-kestrel-appserviceplan"
    location            = azurerm_resource_group.kestrel.location
    resource_group_name = azurerm_resource_group.kestrel.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "kestrel" {
    name                = "kestrelAppService"
    location            = azurerm_resource_group.kestrel.location
    resource_group_name = azurerm_resource_group.kestrel.name
    app_service_plan_id = azurerm_app_service_plan.kestrel.id
}
