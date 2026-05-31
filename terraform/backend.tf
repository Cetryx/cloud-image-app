terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloud-image-app-tf"
    storage_account_name = "stcloudimgtfu94m0d"
    container_name       = "tfstate"
    key                  = "cloud-image-app.tfstate"
    use_azuread_auth     = true
  }
}