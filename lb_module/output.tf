output "loab_balancer_backend_pool" {
  description = "load balancer back end pool"
  value = azurerm_lb_backend_address_pool.backend_pool
}

output "nat_rule" {
  value = azurerm_lb_nat_rule.ssh
}