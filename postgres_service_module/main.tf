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
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "postgres_zone" {
  name                  = "postgres.prod"
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
}


resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                   = var.service_name
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  version                = "12"
  delegated_subnet_id    = var.private_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres_dns.id
  administrator_login    = var.username
  administrator_password = var.password
  zone                   = "1"

  storage_mb = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres_zone]

}
resource "azurerm_postgresql_flexible_server_configuration" "postgres" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  value     = "off"
}
