# 8. Part II - Application and Deployment

## Description

Part II adds a small test application and deployment pipeline setup on top of the Terraform infrastructure from Part I.

The application is a Flask web app that stores and displays files in the Azure Blob container created by Terraform. The app runs on Azure App Service and accesses Azure Storage through the user-assigned managed identity instead of using a storage account connection string.

The application provides two pages:

- Web Page 1 (`/`) shows all blobs/files in the Storage Account container and provides a download link for each file.
- Web Page 2 (`/upload`) provides a file upload form and stores the uploaded file in Azure Blob Storage.

## Approach

The infrastructure and application deployment are kept separate:

- Terraform creates and manages Azure infrastructure.
- The application is packaged and deployed separately to the existing App Service.

This separation keeps infrastructure changes explicit and avoids giving the app deployment pipeline more permissions than needed.

The application uses the Azure SDK for Python:

- `azure-identity`
- `azure-storage-blob`

Authentication is handled through `DefaultAzureCredential`. Locally, this can use the developer's `az login` session. In Azure App Service, it uses the configured user-assigned managed identity through the `AZURE_CLIENT_ID` app setting.

## Connections between resources

The resource flow is:

```text
Browser -> Flask Web App on App Service -> Azure Blob Storage
```

The browser never receives a storage account key or connection string. All storage operations go through the Flask application.

The Web App receives these app settings from Terraform:

- `AZURE_STORAGE_ACCOUNT_NAME`
- `AZURE_STORAGE_CONTAINER_NAME`
- `AZURE_KEY_VAULT_NAME`
- `AZURE_CLIENT_ID`

The user-assigned managed identity is connected to the Web App and receives:

- `Storage Blob Data Contributor` on the Storage Account
- `Key Vault Secrets User` on the Key Vault

## Authentication / Identity Context

No storage account connection string is stored in the repository or in Terraform-managed Key Vault secrets.

The app uses `DefaultAzureCredential`:

- Local development: Azure CLI user from `az login`
- Azure App Service: user-assigned managed identity

The managed identity is user-assigned rather than system-assigned, so it is a separate Azure resource and can be managed independently from the Web App.

## Repository Content

Part II adds:

```text
app/
|-- app.py
|-- requirements.txt
|-- static/
|   `-- style.css
`-- templates/
    |-- base.html
    |-- index.html
    `-- upload.html

pipelines/
|-- infrastructure.yml
`-- app-deploy.yml

scripts/
`-- deploy-app.ps1
```

## Terraform Definition

Terraform now prepares the App Service hosting layer:

- `azurerm_user_assigned_identity.app`
- `azurerm_service_plan.main`
- `azurerm_linux_web_app.main`
- app identity role assignment for Storage
- app identity role assignment for Key Vault

The Web App is configured for Python 3.11 and uses Gunicorn as the startup command.

## Pipeline YAML

The repository contains two Azure DevOps pipeline YAML files:

- `pipelines/infrastructure.yml`
- `pipelines/app-deploy.yml`

The infrastructure pipeline is intended for Terraform validation, plan, and optional apply. The apply step only runs if the pipeline variable `RUN_TERRAFORM_APPLY` is set to `true`.

The app deployment pipeline checks the installed Python version, installs Python dependencies, validates the Python app, and deploys the app package to Azure App Service.

Both pipelines use the self-hosted Azure DevOps agent pool:

```yaml
pool:
  name: "cloud-image-agent-pool"
```

The app deployment pipeline uses the Azure Resource Manager service connection `sc-cloud-image-app` for the Azure CLI deployment step.

The app deployment pipeline was executed successfully on the self-hosted agent.

## Agent Prerequisite

The Azure DevOps agent setup used for the successful pipeline run is:

- Azure DevOps organization: `alicodevops`
- Azure DevOps project: `cloud-image-app`
- Agent pool: `cloud-image-agent-pool`
- Agent VM: `vm-cloud-image-agent`
- Agent name: `vm-cloud-image-agent`
- Service connection: `sc-cloud-image-app`

The agent VM has these tools installed:

- Git
- Azure CLI
- Terraform
- Python 3.11
- PowerShell

The agent is registered once with Azure DevOps and runs as a Windows service. The VM should be stopped or removed after the project is no longer needed to avoid unnecessary cost.

## Deployment Script

The app can be deployed manually from the project root:

```powershell
.\scripts\deploy-app.ps1
```

The script packages the `app` folder into a zip file and deploys it to the Azure App Service with Azure CLI.

The deployed app URL is:

```text
https://app-cloud-img-tf-u94m0d.azurewebsites.net/
```

## Test Application

The test application is intentionally small:

- `/` lists blobs/files in the configured storage container.
- `/upload` displays a file upload form.
- `/download/<blob_name>` downloads a file through the application.
- `/health` returns a simple health check response.

This demonstrates that the App Service can use its managed identity to access Azure Blob Storage.

The following checks were completed:

- `/health` returned HTTP 200.
- `/` loaded successfully and displayed blob files.
- `/upload` accepted an uploaded file.
- the uploaded file appeared in the blob list.
- the download link returned HTTP 200.
