# Random suffix is used because Storage Account and Key Vault names must be globally unique.
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
