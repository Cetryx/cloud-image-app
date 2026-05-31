# 1. Description

This repository contains the Terraform definition for the first part of the `cloud-image-app` Azure infrastructure.

The current setup creates the base resources that are needed for storing application data and secrets:

- an Azure Resource Group
- an Azure Storage Account
- a private Blob container for images
- a private Blob container for Terraform remote state
- an Azure Key Vault
- RBAC assignments for the currently authenticated Azure identity

The infrastructure is deployed to the `swedencentral` Azure region by default. Resource names are generated from the project name, the deployment variant, and a random suffix so that globally unique Azure resources such as Storage Accounts and Key Vaults can be created reliably.

The current Terraform files prepare names for an App Service Plan and Web App, but no App Service resource is defined yet because `terraform/appservice.tf` is empty.
