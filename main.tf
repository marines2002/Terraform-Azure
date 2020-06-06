
provider "azurerm" {
  version = "~>1.31"  
}

resource "azurerm_resource_group" "kestrel" {
  name     = "${var.environment}-hca-kestrel-rg"
  location = var.location
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
}

resource "azurerm_sql_server" "kestrel" {
  name                         = "${var.environment}-hca-kestrel-sqlserver"
  resource_group_name          = azurerm_resource_group.kestrel.name
  location                     = azurerm_resource_group.kestrel.location
  version                      = "12.0"
  administrator_login          = "kestrel"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
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
