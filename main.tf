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
  source_address_prefix       = "112.207.178.254/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.mtc-rg.name
  network_security_group_name = azurerm_network_security_group.mtc-sg.name
}

resource "azurerm_subnet_network_security_group_association" "mtc-sga" {
  subnet_id                 = azurerm_subnet.mtc-subnet.id
  network_security_group_id = azurerm_network_security_group.mtc-sg.id
}

resource "azurerm_public_ip" "mtc-ip" {
  name                = "mtc-ip"
  resource_group_name = azurerm_resource_group.mtc-rg.name
  location            = azurerm_resource_group.mtc-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "mtc-nic" {
  name                = "mtc-nic"
  location            = azurerm_resource_group.mtc-rg.location
  resource_group_name = azurerm_resource_group.mtc-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mtc-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mtc-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "mtc-vm" {
  name                  = "mtc-vm"
  location              = azurerm_resource_group.mtc-rg.location
  resource_group_name   = azurerm_resource_group.mtc-rg.name
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.mtc-nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/mtcazurekey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

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

#-------
#terraform fmt
#terraform plan
#terraform apply -auto-approve
#terraform state list

#-------

#ssh-keygen -t rsa

#ssh -i ~/.ssh/mtcazurekey adminuser@4.194.161.63