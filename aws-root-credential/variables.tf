variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "aws_access_key_id" {
  description = "AWS region"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS region"
  type        = string
}

variable "iam_user_name" {
  description = "IAM User Name"
  type        = string
}

variable "account_id" {
  description = "Account ID"
  type        = string
}