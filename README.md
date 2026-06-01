# Cloud and DevOps Engineering

## Cloud Image App

## Project Name

`cloud-image-app`

## Goal of Part I

Part I creates the basic Azure infrastructure for a Cloud Image App with Terraform.

The current setup creates:

- an Azure Resource Group
- an Azure Storage Account
- a private Blob container for images
- a private Blob container for Terraform remote state
- an Azure Key Vault
- RBAC role assignments for the currently authenticated Azure identity

App Service resources are not created yet. `terraform/appservice.tf` is currently empty and can be added in a later project part.

## Folder Structure

```text
.
|-- docs/
|   |-- 1-description.md
|   |-- 2-approach-and-why.md
|   |-- 3-connections-between-resources.md
|   |-- 4-authentication-identity-context.md
|   |-- 5-repository-content.md
|   |-- 6-terraform-definition.md
|   `-- 7-remote-state-explanation.md
|-- scripts/
|   |-- init.ps1
|   |-- plan.ps1
|   |-- apply.ps1
|   `-- set-path.ps1
|-- terraform/
|   |-- backend.tf
|   |-- provider.tf
|   |-- variables.tf
|   |-- main.tfvars.example
|   |-- locals.tf
|   |-- rg.tf
|   |-- storage.tf
|   |-- container.tf
|   |-- keyvault.tf
|   |-- random.tf
|   |-- outputs.tf
|   `-- appservice.tf
|-- .gitignore
`-- README.md
```

## Prerequisites

Before running the Terraform definition, the following prerequisites must be available:

- Azure account or Azure for Students subscription
- Azure CLI installed
- Terraform installed
- PowerShell or VS Code terminal
- Azure login completed with `az login`
- `terraform/main.tfvars` created locally from `terraform/main.tfvars.example`

Azure login must be completed before running Terraform:

```powershell
az login
```

After login, check that the correct subscription is selected:

```powershell
az account show
```

If required, set the subscription manually:

```powershell
az account set --subscription "<subscription-id>"
```

## Local Variables

The file `terraform/main.tfvars` contains local values such as the subscription ID and tenant ID. This file must not be committed to the Git repository.

The repository therefore includes the template file `terraform/main.tfvars.example`. A new user creates their own local `main.tfvars` from this template:

```powershell
Copy-Item .\terraform\main.tfvars.example .\terraform\main.tfvars
```

After creating the file, at least these values must be updated in `terraform/main.tfvars`:

- `subscription_id`
- `tenant_id`

`main.tfvars` is excluded by `.gitignore` because it contains local and environment-specific values.

## How to Run Terraform

Terraform commands are executed through the PowerShell scripts in the `scripts` folder. The commands are started from the project root folder.

Run order:

1. Log in to Azure:

```powershell
az login
```

2. Initialize Terraform:

```powershell
.\scripts\init.ps1
```

3. Check the Terraform plan:

```powershell
.\scripts\plan.ps1
```

4. Apply the Terraform deployment:

```powershell
.\scripts\apply.ps1
```

The scripts automatically switch into the `terraform` folder and run the Terraform commands there.

## Remote State

This project uses Terraform remote state in Azure Blob Storage. The backend configuration is defined in `terraform/backend.tf`.

The state is stored in the `tfstate` container as the Blob `cloud-image-app.tfstate`. Backend access uses Azure AD authentication:

```hcl
use_azuread_auth = true
```

Important: The Storage Account and container for the remote state must exist before `terraform init` can run successfully. If the backend does not exist yet, it must be prepared or bootstrapped once.

More details are documented in `docs/7-remote-state-explanation.md`.
