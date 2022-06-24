terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "production" {
  name = "production"
  location = "canadacentral"
}

module "network_details" {
  source = "./network_module"
  resource_group_name = azurerm_resource_group.production.name
  resource_group_location = azurerm_resource_group.production.location
  vnet_name = "virtual_network"
  network_address = "192.168.1.0/24"
  public_subnet = "192.168.1.0/25"
  private_subnet = "192.168.1.128/25"

}

module "load_balancer_creation" {
  source = "./lb_module"
  resource_group_name = azurerm_resource_group.production.name
  resource_group_location = azurerm_resource_group.production.location
  load_balancer_name = "load-balancer"
  sku_type = "Standard"
  backend_pool_name = "backend-pool"
}

module "postgres_service" {
  source = "./postgres_service_module"
  resource_group_name = azurerm_resource_group.production.name
  resource_group_location = azurerm_resource_group.production.location
  dns_zone_name = "postgres.service.postgres.database.azure.com"
  virtual_network_id = module.network_details.virtual_net.id
  private_subnet_id = module.network_details.private_subnet.id
  service_name = "postgres-service-prod"
  username = "postgres"
  password = "P0$tgres2022"
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.names
  name                  = each.value
  location              = azurerm_resource_group.production.location
  resource_group_name   = azurerm_resource_group.production.name
  network_interface_ids = [azurerm_network_interface.network_interface[each.value].id]
  size                  = "Standard_D2s_v3"
  admin_username        = "ubuntu"
  admin_password        = "B0Otc@mp13062022"

  os_disk {
    name                 = "${each.value}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = each.key
  disable_password_authentication = false

}

resource "azurerm_network_interface" "network_interface" {
  for_each = var.names
  name = "${each.value}-net-interface"
  location = azurerm_resource_group.production.location
  resource_group_name = azurerm_resource_group.production.name

  ip_configuration {
    name = "${each.value}-configuration"
    subnet_id = module.network_details.public_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_associate" {
  for_each = var.names
  backend_address_pool_id = module.load_balancer_creation.loab_balancer_backend_pool.id
  ip_configuration_name = "${each.value}-configuration"
  network_interface_id = azurerm_network_interface.network_interface[each.value].id
}

resource "azurerm_network_interface_nat_rule_association" "rule_to_interface" {
  ip_configuration_name = "web1-configuration"
  nat_rule_id = module.load_balancer_creation.nat_rule.id
  network_interface_id = azurerm_network_interface.network_interface["web1"].id
}