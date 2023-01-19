# get a VNet RG
# Get Resources from a Resource Group
data "azurerm_resources" "vnetrg" {
  resource_group_name = local.vnet-rg
}



# Get a virtual network within the resource group
data "azurerm_virtual_network" "vnet" {
  name                = "${lookup(var.vnet_map, local.vnet_derivate)}"
  resource_group_name = data.azurerm_resources.vnetrg.resource_group_name
  #depends_on = [
  #azurerm_resource_group.myrg
}

# Deploying resources for Web
#Get the subnet in the VNET
data "azurerm_subnet" "subnet" {
  name                 = local.websub_name
  resource_group_name  = data.azurerm_resources.vnetrg.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}


# Create RG
resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = "UK South"
}

#Create a new NIC using exiting manual VNET & Subnet

resource "azurerm_network_interface" "nic" {
  #for_each            = local.web_deploy_data_map
  name                = "tf-nic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  #for_each                        = local.web_deploy_data_map
  name                            = "sequence"#${each.value.deployment.app_name}-${each.value.deployment.capability}-vm"
  resource_group_name             = azurerm_resource_group.myrg.name
  location                        = azurerm_resource_group.myrg.location
  size                            = "Standard_B1ms"
  admin_username                  = local.admin_username
  admin_password                  = "Azurepassword@12345"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
