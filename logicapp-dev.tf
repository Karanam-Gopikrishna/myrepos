resource "azurerm_resource_group" "testla-rg" {
  name     = "testlapp-rg"
  location = var.location_eus2
}

resource "azurerm_storage_account" "test-la-str" {
  name                     = "test-la-str"
  resource_group_name      = azurerm_resource_group.testla-rg.name
  location                 = azurerm_resource_group.testla-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "test-la-splan" {
  name                = "test-la-splan"
  location            = azurerm_resource_group.testla-rg.location
  resource_group_name = azurerm_resource_group.testla-rg.name
  kind                = "elastic"


  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "test-la-app1" {
  name                       = "test-azure-logic-app1"
  location                   = azurerm_resource_group.testla-rg.location
  resource_group_name        = azurerm_resource_group.testla-rg.name
  app_service_plan_id        = azurerm_app_service_plan.testlasplan.id
  storage_account_name       = azurerm_storage_account.testla-str.name
  storage_account_access_key = azurerm_storage_account.testla-str.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
}