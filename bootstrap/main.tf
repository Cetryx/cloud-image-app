terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}

data "azurerm_client_config" "current" {}

locals {
  resource_group_name  = "rg-cloud-image-app-tfstate"
  storage_account_name = "stcloudimgtfstateu94m0d"
  container_name       = "tfstate"

  common_tags = {
    project     = "cloud-image-app"
    environment = "dev"
    variant     = "tf"
    created_by  = "terraform-bootstrap"
    part        = "remote-state"
  }
}

resource "azurerm_resource_group" "state" {
  name     = local.resource_group_name
  location = var.location

  tags = local.common_tags
}

resource "azurerm_storage_account" "state" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  # Versioning helps recover previous Terraform state versions if the state blob is overwritten accidentally.
  blob_properties {
    versioning_enabled = true
  }

  tags = local.common_tags
}

# The current deployment identity needs Blob Data permissions to create and use the remote state container.
resource "azurerm_role_assignment" "current_user_storage_blob_data_contributor" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_container" "tfstate" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"

  depends_on = [
    azurerm_role_assignment.current_user_storage_blob_data_contributor
  ]
}

output "backend_config" {
  description = "Backend configuration used by the main Terraform project."
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    storage_account_name = azurerm_storage_account.state.name
    container_name       = azurerm_storage_container.tfstate.name
    key                  = "cloud-image-app.tfstate"
    use_azuread_auth     = true
  }
}
