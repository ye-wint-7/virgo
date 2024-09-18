
# Step (1) - Enable the JWT Auth Backend
# Step (2) - Configure Trust with HCP Terraform
resource "vault_jwt_auth_backend" "jwt" {
  description        = "JWT auth backend for Dynamic Provider Credential"
  path               = "jwt"
  oidc_discovery_url = var.tfc_hostname
  bound_issuer       = var.tfc_hostname
}

# Step (3) - Create a Vault Policy
resource "vault_policy" "admin_policy" {
  name = "admin-policy"

  policy = var.vault_admin_policy
}

# Step (4) - Create a JWT Auth Role
resource "vault_jwt_auth_backend_role" "jwt_admin_role" {
  backend        = vault_jwt_auth_backend.jwt.path
  role_name      = var.jwt_auth_role_name
  token_policies = [vault_policy.admin_policy.name]

  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:*:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}