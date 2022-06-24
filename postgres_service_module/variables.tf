variable "resource_group_location" {
  description = "location of resource group that contain the network resources"
  type = string
}

variable "resource_group_name" {
  description = "name of resource group that contain the network resources"
  type = string
}

variable "virtual_network_id" {
  description = "id of the virtual network"
  type = string
}

variable "private_subnet_id" {
  description = "id of the private subnet"
  type = string
}

variable "dns_zone_name" {
  description = "dns zone name of postgres service"
  type = string
}

variable "service_name" {
  description = "name of the service you can choose any name"
  type = string
}

variable "username" {
  description = "the user name of database"
  type = string
}

variable "password" {
  description = "password for the database"
  type = string
}