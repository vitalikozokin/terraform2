variable "subnets" {
  description = "map of subnets of the network"
  type        = map
  default = {
    public = "public"
    private = "private"
  }
}

variable "resource_group_location" {
  description = "location of resource group that contain the network resources"
  type = string
}

variable "resource_group_name" {
  description = "name of resource group that contain the network resources"
  type = string
}

variable "vnet_name" {
  description = "virtual network name"
  type = string
}

variable "public_subnet" {
  description = "public subnet mask with prefix, example 192.168.1.0/25 "
  type = string
}

variable "private_subnet" {
  description = "private subnet mask with prefix, example 192.168.1.0/25 "
  type = string
}

variable "network_address" {
  description = "network address"
  type = string
}

variable "subnets_security_rules" {
  description = "rules of all security groups"
  type        = map(any)
  default = {
    public_ssh = {
      type                       = "public"
      name                       = "allow SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "79.178.217.173"
      destination_address_prefix = "192.168.1.4"

    }

    allow_port_8080 = {
      type                       = "public"
      name                       = "allow 8080"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.1.0/25"

    }
    private_ssh = {
      type                       = "private"
      name                       = "allow SSH"
      priority                   = 115
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "192.168.1.0/25"
      destination_address_prefix = "192.168.1.132"

    }

    allow_5432 = {
      type                       = "private"
      name                       = "allow 5432"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "5432"
      source_address_prefix      = "192.168.1.0/25"
      destination_address_prefix = "192.168.1.132"

    }

    deny_all = {
      type                       = "private"
      name                       = "deny all ports"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.1.132"
    }
  }
}