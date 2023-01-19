output "private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}


output "capability" {
  value = var.capability
}

output "environment" {
  value = var.environment
}

