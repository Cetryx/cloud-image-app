# 7. Remote State Explanation

Terraform state stores the mapping between the Terraform configuration and the real Azure resources. Without state, Terraform cannot reliably know which Azure resources it already manages.

This project is configured to store Terraform state remotely in Azure Blob Storage instead of only keeping it as a local `terraform.tfstate` file.

The remote backend is configured in `terraform/backend.tf`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloud-image-app-tfstate"
    storage_account_name = "stcloudimgtfstateu94m0d"
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

The `tfstate` container is defined in the separate `bootstrap` Terraform configuration. This means the backend storage can be created before the main Terraform project initializes against it. In practice, this requires a bootstrap step when the project is set up for the first time.

The bootstrap configuration is:

```text
bootstrap/
|-- README.md
|-- main.tf
|-- variables.tf
`-- terraform.tfvars.example
```

The bootstrap configuration creates a dedicated backend Resource Group, Storage Account, Blob container, and the required Blob Data role assignment. Its state remains local because it only manages the remote-state foundation. The main Terraform project then stores its state in the Storage Account created by the bootstrap step.

The setup order is:

1. Run `az login`.
2. Run the Terraform configuration in the `bootstrap` folder.
3. Run `terraform init` or `terraform init -migrate-state` for the main Terraform project so Terraform can connect to the remote backend.
4. Run `terraform plan` and `terraform apply` for the main infrastructure.

After bootstrap, the normal scripts can be used:

1. Run `.\scripts\init.ps1`.
2. Run `.\scripts\plan.ps1`.
3. Run `.\scripts\apply.ps1`.

Local state files are ignored by Git through `.gitignore`, so the source repository should contain the Terraform configuration but not the actual state.
