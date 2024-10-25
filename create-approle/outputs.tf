output "aws_approle_role_id" {
  value = vault_approle_auth_backend_role.aws_approle.role_id
  sensitive = true
}

output "aws_approle_secret_id" {
  value = vault_approle_auth_backend_role_secret_id.secret_id.secret_id
  sensitive = true
}