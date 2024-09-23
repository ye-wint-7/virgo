variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "iam_user_name" {
  description = "IAM User Name"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}

variable "vault_aws_backend_path" {
  description = "Vault backend path of aws secret engine"
  type        = string
}

variable "vault_aws_backend_role_name" {
  description = "Vault AWS backend role name"
  type        = string
}