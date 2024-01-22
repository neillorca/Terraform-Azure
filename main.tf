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

resource "azurerm_subnet" "mtc-subnet" {
  name                 = "mtc-subnet"
  resource_group_name  = azurerm_resource_group.mtc-rg.name
  virtual_network_name = azurerm_virtual_network.mtc-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "mtc-sg" {
  name                = "mtc-sg"
  location            = azurerm_resource_group.mtc-rg.location
  resource_group_name = azurerm_resource_group.mtc-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "mtc-dev-rule" {
  name                        = "mtc-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "72.14.201.149/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.mtc-rg.name
  network_security_group_name = azurerm_network_security_group.mtc-sg.name
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

#-------
#terraform fmt
#terraform plan
#terraform apply -auto-approve
#terraform state list
