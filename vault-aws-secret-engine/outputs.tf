output "dev_role_cred_access_key" {
  value = data.vault_aws_access_credentials.dev_role_cred.access_key
  sensitive = true
}

output "dev_role_cred_secret_key" {
  value = data.vault_aws_access_credentials.dev_role_cred.secret_key
  sensitive = true
}