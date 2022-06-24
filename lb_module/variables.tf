variable "resource_group_location" {
  description = "location of resource group that contain the network resources"
  type = string
}

variable "resource_group_name" {
  description = "name of resource group that contain the network resources"
  type = string
}

variable "sku_type" {
  description = "select sku Standard or Basic"
  type = string
}

variable "backend_pool_name" {
  description = "name of the backend pool in the load balancer"
  type = string
}

variable "load_balancer_name" {
  description = "name of the load balancer"
  type = string
}