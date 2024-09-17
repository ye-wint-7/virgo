output "jwt_role_name" {
  value = vault_jwt_auth_backend_role.jwt_admin_role.role_name
}

output "openid_claims" {
  value = vault_jwt_auth_backend_role.jwt_admin_role.bound_claims.sub
}