# 6. Terraform Definition

The Terraform configuration defines the Azure base infrastructure for the project.

## Provider and backend

`provider.tf` requires Terraform `>= 1.6.0` and uses:

- `hashicorp/azurerm` with version `~> 4.0`
- `hashicorp/random` with version `~> 3.6`

The Azure provider receives the subscription and tenant from input variables.

`backend.tf` configures remote state in Azure Blob Storage:

- Resource Group: `rg-cloud-image-app-tf`
- Storage Account: `stcloudimgtfu94m0d`
- Container: `tfstate`
- State key: `cloud-image-app.tfstate`
- Authentication: Azure AD

## Input variables

The main input variables are:

- `subscription_id`
- `tenant_id`
- `location`
- `project_name`
- `environment`
- `variant`

The default location is `swedencentral`. The default project name is `cloud-image-app`, and the default variant is `tf`.

## Locals

`locals.tf` builds resource names and tags from the variables and the generated random suffix.

Common tags are applied to the main resources:

- `project`
- `environment`
- `variant`
- `created_by`
- `part`

## Resources

The current Terraform resources are:

- `random_string.suffix`
- `azurerm_resource_group.main`
- `azurerm_storage_account.main`
- `azurerm_storage_container.images`
- `azurerm_storage_container.tfstate`
- `azurerm_key_vault.main`
- `azurerm_role_assignment.current_user_storage_blob_data_contributor`
- `azurerm_role_assignment.current_user_key_vault_secrets_officer`

The Storage Account is configured as `StorageV2`, uses Standard LRS replication, requires TLS 1.2, and prevents nested items from being public.

The image container and state container are both private.

The Key Vault uses the Standard SKU, enables RBAC authorization, allows public network access, keeps soft-deleted vaults for 90 days, and has purge protection disabled.

## Outputs

The outputs expose the names of important resources:

- Resource Group
- Storage Account
- image Blob container
- Terraform state container
- Key Vault
