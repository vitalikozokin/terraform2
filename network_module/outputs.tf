output "public_subnet" {
  description = "output the public subnet"
  value = azurerm_subnet.subnet_public
}

output "private_subnet" {
  description = "output the private subnet"
  value = azurerm_subnet.subnet_private
}

output "public_nsg" {
  description = "output public nsg"
  value = azurerm_network_security_group.security_group["public"]
}

output "private_nsg" {
  description = "output private nsg"
  value = azurerm_network_security_group.security_group["private"]
}

output "virtual_net" {
  description = "output virtual network"
  value = azurerm_virtual_network.vnet
}
