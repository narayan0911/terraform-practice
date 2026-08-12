terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mishra_rg"
    storage_account_name = "mishrastorage"
    container_name       = "tfstate"
    key                  = "monolithic.tfstate"
    }
  }
  provider "azurerm" {
    features {}
  }


