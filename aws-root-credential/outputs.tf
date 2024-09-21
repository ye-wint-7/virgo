output "policy_id" {
  description = "The policy ID"
  value       = module.iam_user_root_cred_policy.id
}

output "policy_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = module.iam_user_root_cred_policy.arn
}

output "policy_description" {
  description = "The description of the policy"
  value       = module.iam_user_root_cred_policy.description
}

output "policy_name" {
  description = "The name of the policy"
  value       = module.iam_user_root_cred_policy.name
}

output "policy_path" {
  description = "The path of the policy in IAM"
  value       = module.iam_user_root_cred_policy.path
}

output "policy" {
  description = "The policy document"
  value       = module.iam_user_root_cred_policy.policy
}

output "iam_user_name" {
  value = module.iam_user_root_cred.iam_user_name
}

output "iam_user_arn" {
  value = module.iam_user_root_cred.iam_user_arn
}


output "iam_user_access_key" {
  value = module.iam_user_root_cred.iam_access_key_id
}

output "iam_user_secret_key" {
  value     = module.iam_user_root_cred.iam_access_key_secret
  sensitive = false
}


