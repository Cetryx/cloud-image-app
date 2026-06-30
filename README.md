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
- an Azure Key Vault
- a user-assigned managed identity for the application
- an App Service Plan
- a Linux Web App
- RBAC role assignments for the currently authenticated Azure identity
- RBAC role assignments for the application managed identity

The Web App is prepared as the application hosting layer. It uses a user-assigned managed identity so the application can access Azure resources through RBAC instead of hardcoded secrets.

Terraform remote state is stored in a separate backend Storage Account created by the `bootstrap` configuration.

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
|   |-- 7-remote-state-explanation.md
|   `-- 8-part-ii-application-and-deployment.md
|-- app/
|   |-- app.py
|   |-- requirements.txt
|   |-- static/
|   `-- templates/
|-- bootstrap/
|   |-- README.md
|   |-- main.tf
|   |-- variables.tf
|   `-- terraform.tfvars.example
|-- scripts/
|   |-- init.ps1
|   |-- plan.ps1
|   |-- apply.ps1
|   |-- deploy-app.ps1
|   |-- set-spn-env.example.ps1
|   `-- set-path.ps1
|-- pipelines/
|   |-- infrastructure.yml
|   `-- app-deploy.yml
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

## Service Principal Usage

For local development, this project can be run with `az login`. For automation or pipeline usage, Terraform can authenticate with an Azure Service Principal instead.

The repository contains the template:

```powershell
.\scripts\set-spn-env.example.ps1
```

Create a local copy and fill in the real Service Principal values:

```powershell
Copy-Item .\scripts\set-spn-env.example.ps1 .\scripts\set-spn-env.ps1
```

Then run it in the current terminal session before running Terraform:

```powershell
.\scripts\set-spn-env.ps1
```

The local `scripts/set-spn-env.ps1` file is excluded by `.gitignore` because it contains `ARM_CLIENT_SECRET`.

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

2. Bootstrap the remote state storage if it does not exist yet:

```powershell
cd .\bootstrap
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
terraform init
terraform apply -var-file="terraform.tfvars"
cd ..
```

3. If the backend already existed and the backend configuration changed, migrate the state:

```powershell
cd .\terraform
terraform init -migrate-state
cd ..
```

For a fresh setup, initialize Terraform through the project script:

```powershell
.\scripts\init.ps1
```

4. Check the Terraform plan:

```powershell
.\scripts\plan.ps1
```

5. Apply the Terraform deployment:

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

Important: The Storage Account and container for the remote state must exist before `terraform init` can run successfully. If the backend does not exist yet, run the Terraform configuration in the `bootstrap` folder once before `.\scripts\init.ps1`.

More details are documented in `docs/7-remote-state-explanation.md`.

## Part II Application Deployment

The test application is stored in the `app` folder. It provides:

- Web Page 1 (`/`) to show all blobs/files in the Storage Account container with download links
- Web Page 2 (`/upload`) to upload a file or image

Manual deployment to Azure App Service:

```powershell
.\scripts\deploy-app.ps1
```

Azure DevOps pipeline YAML files are stored in the `pipelines` folder. Before using them, replace `<YOUR_SELF_HOSTED_AGENT_POOL_NAME>` with the real self-hosted Azure DevOps agent pool name.

More details are documented in `docs/8-part-ii-application-and-deployment.md`.
