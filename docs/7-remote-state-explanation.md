# 7. Remote State Explanation

Terraform state stores the mapping between the Terraform configuration and the real Azure resources. Without state, Terraform cannot reliably know which Azure resources it already manages.

This project is configured to store Terraform state remotely in Azure Blob Storage instead of only keeping it as a local `terraform.tfstate` file.

The remote backend is configured in `terraform/backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloud-image-app-tf"
    storage_account_name = "stcloudimgtfu94m0d"
    container_name       = "tfstate"
    key                  = "cloud-image-app.tfstate"
    use_azuread_auth     = true
  }
}
```

The state file is stored as a Blob named `cloud-image-app.tfstate` in the `tfstate` container.

Using remote state has several advantages:

- the state is not tied to one local machine
- the state can be reused by future Terraform runs
- Azure Blob Storage can provide locking behavior during Terraform operations
- access can be controlled through Azure RBAC

Because the backend uses `use_azuread_auth = true`, the user or service principal running Terraform must have the required permissions on the Storage Account or Blob container.

The `tfstate` container is also defined in the Terraform configuration. This means the backend storage must already exist before Terraform can initialize against it. In practice, this usually requires a bootstrap step:

1. Create the backend Resource Group, Storage Account, and container once.
2. Run `terraform init` so Terraform can connect to the remote backend.
3. Run `terraform plan` and `terraform apply` for the main infrastructure.

Local state files are ignored by Git through `.gitignore`, so the source repository should contain the Terraform configuration but not the actual state.
