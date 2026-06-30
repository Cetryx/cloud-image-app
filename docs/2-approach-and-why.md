# 2. Approach and Why

The project uses Terraform to describe Azure infrastructure as code. The configuration is split into small files by responsibility so that each infrastructure concern is easy to find and maintain.

The deployment approach is:

1. Configure the Azure provider with the subscription and tenant from `main.tfvars`.
2. Create a Resource Group as the parent container for the project resources.
3. Generate a short random suffix for globally unique resource names.
4. Create a Storage Account with secure defaults such as TLS 1.2 and disabled public nested item access.
5. Create a private Blob container for application images.
6. Create a Key Vault with Azure RBAC authorization enabled.
7. Create a user-assigned managed identity for the application.
8. Create an App Service Plan and Linux Web App.
9. Assign the current Azure identity the permissions needed to manage Blob data and Key Vault secrets.
10. Assign the application managed identity the permissions needed to access Blob data and Key Vault secrets.

Reusable naming and tagging rules are kept in `locals.tf`. This keeps the resource files shorter and makes naming consistent across the project.

Terraform commands are wrapped by PowerShell scripts in the `scripts` folder:

- `init.ps1` runs `terraform init`
- `plan.ps1` runs `terraform fmt`, `terraform validate`, and `terraform plan`
- `apply.ps1` runs `terraform fmt`, `terraform validate`, and `terraform apply`

The scripts first add the local Terraform installation path to the current terminal session by using `set-path.ps1`.

## Approach and Reasoning

For the first part of the project, I wanted to understand the required Azure resources step by step before adding the application part. I therefore started with the basic infrastructure that will later be needed for the project.

The first resource I created with Terraform was the resource group. Also the suffix `-tf` was used for the Terraform-created resources, because I previously tested some resources manually in Azure with the suffix `-az`. This helped me to separate manually created resources from infrastructure created through Terraform and to learn the terraform applications by doing both.

A storage account was created, because the later application will need a place to store uploaded images or files. Inside the storage account I created the private blob container `images-tf`. This container is intended for the application data in the next project part. I chose a private container because uploaded files should not be publicly accessible by default. Access should later be controlled through the application and Azure permissions.

I also created a Key Vault, because the project requires the use of a Key Vault for sensitive data in later parts. For this first part, I only prepared the Key Vault and the required access model. I decided to use Azure role-based access control instead of classic Key Vault access policies, because RBAC is a more centralized and modern way to manage permissions in Azure.

I deliberately did not store the storage account connection string as a Key Vault secret through Terraform at this point. The reason is that secrets created through Terraform can also appear in the Terraform state file. Since the state can contain sensitive values, I wanted to avoid putting a real storage connection string into the state. For the next part of the project, I want to use managed identity and RBAC where possible, so the application can access Azure resources without hardcoding secrets in the application code.

For the application hosting layer, I added an App Service Plan and a Linux Web App. The Web App uses a user-assigned managed identity instead of a system-assigned identity. I chose a user-assigned managed identity because it is a separate Azure resource and can be managed independently from the Web App. The identity receives RBAC permissions for Storage and Key Vault, so the application can later access these resources without storing credentials in the application code.

Another part of my approach was setting up a remote Terraform state. At the beginning, Terraform used a local state file. I then separated the backend setup into a dedicated `bootstrap` Terraform configuration. This bootstrap configuration creates the Storage Account and `tfstate` container that the main Terraform project uses as its AzureRM backend. This means the Terraform state is stored in Azure instead of only on my local machine. I chose this because remote state is more suitable for a DevOps workflow and later pipeline usage.

For the remote state, the bootstrap configuration creates a separate private container named `tfstate`. The state file is stored there as `cloud-image-app.tfstate`. I also assigned the `Storage Blob Data Contributor` role to the current deployment identity, so Terraform can read and write the state through Azure RBAC. The backend uses Azure AD authentication instead of storing a storage account access key in the backend configuration.
