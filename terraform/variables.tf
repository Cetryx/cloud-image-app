variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID."
}

variable "location" {
  type        = string
  description = "Azure region for all project resources."
  default     = "swedencentral"
}

variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "cloud-image-app"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
}

variable "variant" {
  type        = string
  description = "Deployment variant. We use tf for Terraform-created resources."
  default     = "tf"
}