# 1. Description

This repository contains the Terraform definition for the first part of the `cloud-image-app` Azure infrastructure.

The current setup creates the base resources that are needed for storing application data and secrets:

- an Azure Resource Group
- an Azure Storage Account
- a private Blob container for images
- an Azure Key Vault
- a user-assigned managed identity for the application
- an App Service Plan
- a Linux Web App
- RBAC assignments for the currently authenticated Azure identity
- RBAC assignments for the application managed identity

The infrastructure is deployed to the `swedencentral` Azure region by default. Resource names are generated from the project name, the deployment variant, and a random suffix so that globally unique Azure resources such as Storage Accounts and Key Vaults can be created reliably.

The Web App is connected to a user-assigned managed identity. This prepares the application to access Azure Storage and Key Vault through Azure RBAC instead of using hardcoded connection strings.

Terraform remote state is stored in a separate backend Storage Account that is created by the `bootstrap` configuration.
