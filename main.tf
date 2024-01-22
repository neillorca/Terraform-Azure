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

resource "azurerm_virtual_network" "mtc-vn" {
  name                = "mtc-network"
  resource_group_name = azurerm_resource_group.mtc-rg.name
  location            = azurerm_resource_group.mtc-rg.location
  address_space       = ["10.123.0.0/16"]

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

#-------

# terraform state list
# terraform state show azurerm_resource_group.mtc-rg
# terraform show

#-------

#terraform state list
#terraform plan -destroy
#terraform apply -destroy

