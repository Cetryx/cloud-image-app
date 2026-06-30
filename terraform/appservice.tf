# A user-assigned managed identity is used so the app identity is a separate Azure resource.
resource "azurerm_user_assigned_identity" "app" {
  name                = local.managed_identity_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

resource "azurerm_service_plan" "main" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = local.common_tags
}

resource "azurerm_linux_web_app" "main" {
  name                = local.web_app_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  key_vault_reference_identity_id                = azurerm_user_assigned_identity.app.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  site_config {
    always_on        = false
    app_command_line = "gunicorn --bind=0.0.0.0 --timeout 600 app:app"

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    AZURE_STORAGE_ACCOUNT_NAME          = azurerm_storage_account.main.name
    AZURE_STORAGE_CONTAINER_NAME        = azurerm_storage_container.images.name
    AZURE_KEY_VAULT_NAME                = azurerm_key_vault.main.name
    AZURE_CLIENT_ID                     = azurerm_user_assigned_identity.app.client_id
    SCM_DO_BUILD_DURING_DEPLOYMENT      = "true"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }

  logs {
    application_logs {
      file_system_level = "Information"
    }
  }

  tags = local.common_tags
}

# The app identity needs Blob Data permissions so the app can read and write uploaded images.
resource "azurerm_role_assignment" "app_storage_blob_data_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

# The app identity can read Key Vault secrets through Azure RBAC without using access policies.
resource "azurerm_role_assignment" "app_key_vault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}
