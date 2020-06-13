
provider "azurerm" {
  version = "~>1.31"  
}

resource "azurerm_resource_group" "kestrel" {
  name     = "${var.environment}-hca-kestrel-rg"
  location = var.location
}

resource "azurerm_storage_account" "kestrel" {
  name                     = "${var.environment}hcakestrelsa"
  resource_group_name      = azurerm_resource_group.kestrel.name
  location                 = azurerm_resource_group.kestrel.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "kestrel" {
    name                = "${var.environment}-hca-kestrel-appserviceplan"
    location            = azurerm_resource_group.kestrel.location
    resource_group_name = azurerm_resource_group.kestrel.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "kestrel" {
    name                = "${var.environment}-hca-kestrel-appservice"
    location            = azurerm_resource_group.kestrel.location
    resource_group_name = azurerm_resource_group.kestrel.name
    app_service_plan_id = azurerm_app_service_plan.kestrel.id

    site_config {
         dotnet_framework_version = "v4.0"    
    }
}

resource "azurerm_app_service" "kestrel-ui" {
    name                = "${var.environment}-hca-kestrel-appservice-ui"
    location            = azurerm_resource_group.kestrel.location
    resource_group_name = azurerm_resource_group.kestrel.name
    app_service_plan_id = azurerm_app_service_plan.kestrel.id

    site_config {
         dotnet_framework_version = "v4.0"    
         default_documents        = ["index.html"]
    }
}

resource "azurerm_function_app" "kestrel" {
  name                      = "${var.environment}-hca-kestrel-function-app"
  location                  = azurerm_resource_group.kestrel.location
  resource_group_name       = azurerm_resource_group.kestrel.name
  app_service_plan_id       = azurerm_app_service_plan.kestrel.id
  storage_connection_string = azurerm_storage_account.kestrel.primary_connection_string
}

resource "azurerm_sql_server" "kestrel" {
  name                         = "${var.environment}-hca-kestrel-sqlserver"
  resource_group_name          = azurerm_resource_group.kestrel.name
  location                     = azurerm_resource_group.kestrel.location
  version                      = "12.0"
  administrator_login          = "kestrel"
  administrator_login_password = var.sqlpassword
}

resource "azurerm_sql_firewall_rule" "kestrel" {
  name                = "${var.environment}-hca-kestrel-allowazureservices"
  resource_group_name = azurerm_resource_group.kestrel.name
  server_name         = azurerm_sql_server.kestrel.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "kestrel" {
  name                             = "${var.environment}-hca-kestrel-database"
  resource_group_name              = azurerm_resource_group.kestrel.name
  location                         = azurerm_resource_group.kestrel.location
  server_name                      = azurerm_sql_server.kestrel.name
  edition                          = "Standard"
  requested_service_objective_name = "S1"
}
