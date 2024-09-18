variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}

variable "vault_admin_policy" {
  type        = string
  description = "Admin policy of Vault"
}

variable "jwt_auth_role_name" {
  type        = string
  description = "Role name of jwt auth method"
}

variable "tfc_organization_name" {
  type        = string
  description = "Organization Name"
}

variable "tfc_project_name" {
  type        = string
  description = "Project Name"
}