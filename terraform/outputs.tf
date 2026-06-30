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

output "key_vault_name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.main.name
}

output "managed_identity_name" {
  description = "Name of the user-assigned managed identity."
  value       = azurerm_user_assigned_identity.app.name
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan."
  value       = azurerm_service_plan.main.name
}

output "web_app_name" {
  description = "Name of the Linux Web App."
  value       = azurerm_linux_web_app.main.name
}
