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
  description = "Azure region for the Terraform remote state resources."
  default     = "swedencentral"
}
