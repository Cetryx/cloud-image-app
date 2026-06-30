locals {
  resource_group_name = "rg-${var.project_name}-${var.variant}"

  storage_account_name   = "stcloudimg${var.variant}${random_string.suffix.result}"
  storage_container_name = "images-${var.variant}"

  key_vault_name = "kv-cloud-img-${var.variant}-${random_string.suffix.result}"

  managed_identity_name = "id-${var.project_name}-${var.variant}"
  app_service_plan_name = "asp-${var.project_name}-${var.variant}"
  web_app_name          = "app-cloud-img-${var.variant}-${random_string.suffix.result}"

  common_tags = {
    project     = var.project_name
    environment = var.environment
    variant     = var.variant
    created_by  = "terraform"
    part        = "part-1"
  }
}
