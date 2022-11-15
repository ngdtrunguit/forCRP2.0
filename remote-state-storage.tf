terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.30"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "52948927-413b-4dab-8037-1499505c03b8"
  tenant_id       = "6f2aaa26-87fe-4a48-a779-49d686893e4c"
  clientId        = "c93a32de-17f7-4a67-86f0-d766647a3bbd"
  clientSecret    = "K5Lc_4XrY9w~CCfQW5th6SULFRQtIh_mKO"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "tfstatetrungnprojectcrp2"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true

  tags = {
    environment = "LAB-CRP2"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate-aks"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "tfstate-helm" {
  name                  = "tfstate-helm"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}