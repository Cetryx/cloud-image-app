# 5. Repository Content

The repository is organized into three main areas:

- `terraform/`
- `scripts/`
- `docs/`

The `terraform` folder contains the infrastructure definition:

- `provider.tf` defines the Terraform version, required providers, Azure provider configuration, and current Azure identity data source.
- `variables.tf` defines configurable input values such as subscription, tenant, region, project name, environment, and variant.
- `main.tfvars` contains local variable values for the deployment environment.
- `locals.tf` defines shared naming rules and common tags.
- `random.tf` creates a random suffix for globally unique Azure resource names.
- `rg.tf` creates the Resource Group.
- `storage.tf` creates the Storage Account.
- `container.tf` creates the image and Terraform state Blob containers and assigns Blob permissions.
- `keyvault.tf` creates the Key Vault and assigns secret-management permissions.
- `backend.tf` configures the Azure Storage remote backend.
- `outputs.tf` exposes important deployment outputs.
- `appservice.tf` is currently empty and can be used later for App Service resources.

The `scripts` folder contains helper scripts:

- `set-path.ps1` adds the Terraform executable path to the current terminal session.
- `init.ps1` changes into the Terraform folder and runs `terraform init`.
- `plan.ps1` formats, validates, and plans the Terraform deployment.
- `apply.ps1` formats, validates, and applies the Terraform deployment.

The `docs` folder contains the project documentation split by topic.

The `.gitignore` excludes local Terraform state, local Terraform directories, crash logs, override files, and variable files.
