terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.30"
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

  subscription_id = "52948927-413b-4dab-8037-1499505c03b8"
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = "6f2aaa26-87fe-4a48-a779-49d686893e4c"
}