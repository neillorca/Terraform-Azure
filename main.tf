terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.88.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "mtc-rg" {
  name     = "mtc-resources"
  location = "Southeast Asia"
  tags = {
    environment = "dev"
  }
}

#terraform init
#terraform fmt
#terraform plan
#terraform apply
#az group list --output table
#git add .
#git commit -m "Creation of Resource Group"
#git push -u origin main

#-------

#git lfs track ".terraform/providers/registry.terraform.io/hashicorp/azurerm/3.88.0/windows_amd64/terraform-provider-azurerm_v3.88.0_x5.exe"

#git add .gitattributes
#git add ".terraform/providers/registry.terraform.io/hashicorp/azurerm/3.88.0/windows_amd64/terraform-provider-azurerm_v3.88.0_x5.exe"
#git commit -m "Use Git LFS to track large file"

#git push -u origin main
