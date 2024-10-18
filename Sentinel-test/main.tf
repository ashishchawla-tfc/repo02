terraform {
  cloud {
    organization = "test-ash-dev"

    workspaces {
      name = "sentinel-test-012"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sentinel_rg" {
  name     = "sentinel-test-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "sentinel_vnet" {
  name                = "sentinel-test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name
}

resource "azurerm_subnet" "sentinel_subnet" {
  name                 = "sentinel-test-subnet"
  resource_group_name  = azurerm_resource_group.sentinel_rg.name
  virtual_network_name = azurerm_virtual_network.sentinel_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "sentinel_nic" {
  name                = "sentinel-test-nic"
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.sentinel_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  name                = "sentinel-test-vm"
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  location            = azurerm_resource_group.sentinel_rg.location
  size                = "Standard_B1s"

  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234!"

  network_interface_ids = [azurerm_network_interface.sentinel_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    source = "github"
  }
}

output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.ubuntu_vm.public_ip_address
}

