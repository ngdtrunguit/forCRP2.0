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
