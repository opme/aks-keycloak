output "acr" {
  # FIXME: We should check which attributes are actually accessed
  # and have single outputs for those
  description = "Full azurerm_container_registry resource attribute output"
  value       = azurerm_container_registry.acr
}
