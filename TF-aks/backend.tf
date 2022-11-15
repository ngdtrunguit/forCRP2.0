terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.30"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatetrungnprojectcrp2"
    container_name       = "tfstate-aks"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}