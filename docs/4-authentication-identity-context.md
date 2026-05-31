# 4. Authentication / Identity Context

Terraform uses the Azure identity that is active in the local Azure CLI or environment when the Terraform command runs.

The configuration reads this identity through:

```hcl
data "azurerm_client_config" "current" {}
```

This data source provides the current tenant ID and object ID. The tenant ID is used when creating the Key Vault, and the object ID is used for RBAC role assignments.

The currently authenticated identity receives two roles:

- `Storage Blob Data Contributor` on the Storage Account
- `Key Vault Secrets Officer` on the Key Vault

These assignments allow the identity running Terraform to work with Blob data and manage Key Vault secrets after the resources are created.

The Azure provider is configured with:

- `subscription_id`
- `tenant_id`

These values are provided through `terraform/main.tfvars`. Because `*.tfvars` files are ignored by Git, sensitive or environment-specific values should stay local and should not be committed.

The backend configuration uses Azure AD authentication:

```hcl
use_azuread_auth = true
```

This means access to the remote Terraform state is controlled by Azure identity and RBAC instead of storage account access keys.
