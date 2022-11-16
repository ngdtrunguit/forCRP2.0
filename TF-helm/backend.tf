terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.15.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatetrungnprojectcrp2"
    container_name       = "tfstate-helm"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}