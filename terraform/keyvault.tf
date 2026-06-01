# Key Vault uses Azure RBAC so permissions are managed consistently with other Azure resources.
resource "azurerm_key_vault" "main" {
  name                = local.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled    = true
  public_network_access_enabled = true

  soft_delete_retention_days = 90
  purge_protection_enabled   = false

  tags = local.common_tags
}

# No storage connection string secret is created here because Terraform would store secret values in state.
# Later application access should prefer managed identity and RBAC where possible.

# The current Azure identity needs this role to manage secrets during setup and later testing.
resource "azurerm_role_assignment" "current_user_key_vault_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
