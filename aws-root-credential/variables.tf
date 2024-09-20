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