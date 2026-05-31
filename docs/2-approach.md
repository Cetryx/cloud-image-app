# 2. Approach

The project uses Terraform to describe Azure infrastructure as code. The configuration is split into small files by responsibility so that each infrastructure concern is easy to find and maintain.

The deployment approach is:

1. Configure the Azure provider with the subscription and tenant from `main.tfvars`.
2. Create a Resource Group as the parent container for the project resources.
3. Generate a short random suffix for globally unique resource names.
4. Create a Storage Account with secure defaults such as TLS 1.2 and disabled public nested item access.
5. Create private Blob containers for application images and Terraform state.
6. Create a Key Vault with Azure RBAC authorization enabled.
7. Assign the current Azure identity the permissions needed to manage Blob data and Key Vault secrets.

Reusable naming and tagging rules are kept in `locals.tf`. This keeps the resource files shorter and makes naming consistent across the project.

Terraform commands are wrapped by PowerShell scripts in the `scripts` folder:

- `init.ps1` runs `terraform init`
- `plan.ps1` runs `terraform fmt`, `terraform validate`, and `terraform plan`
- `apply.ps1` runs `terraform fmt`, `terraform validate`, and `terraform apply`

The scripts first add the local Terraform installation path to the current terminal session by using `set-path.ps1`.
