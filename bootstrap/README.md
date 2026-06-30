# Terraform Bootstrap

This folder contains the one-time Terraform configuration for the remote state backend.

The main Terraform project stores its state in Azure Blob Storage. That Storage Account and container must exist before the main project can run `terraform init`, so this bootstrap configuration creates only the remote-state resources:

- Resource Group `rg-cloud-image-app-tfstate`
- Storage Account `stcloudimgtfstateu94m0d`
- private Blob container `tfstate`
- Blob Data role assignment for the current deployment identity

The bootstrap configuration keeps its own local state. It should be run rarely, normally only when the project is set up for the first time.

Run from this folder:

```powershell
Copy-Item .\terraform.tfvars.example .\terraform.tfvars
terraform init
terraform apply -var-file="terraform.tfvars"
```

After bootstrap, run the main project from the repository root:

```powershell
.\scripts\init.ps1
.\scripts\plan.ps1
.\scripts\apply.ps1
```
