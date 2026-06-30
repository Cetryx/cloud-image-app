# The images container is private because uploaded files should not be publicly accessible by default.
resource "azurerm_storage_container" "images" {
  name                  = local.storage_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

# The current Azure identity gets Blob Data permissions for manual validation and local testing.
resource "azurerm_role_assignment" "current_user_storage_blob_data_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
