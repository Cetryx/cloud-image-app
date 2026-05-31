output "resource_group_name" {
  description = "Name of the project resource group."
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = azurerm_storage_account.main.name
}

output "storage_container_name" {
  description = "Name of the image blob container."
  value       = azurerm_storage_container.images.name
}

output "tfstate_container_name" {
  description = "Name of the Terraform remote state container."
  value       = azurerm_storage_container.tfstate.name
}

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.main.name
}