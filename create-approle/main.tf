resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_policy" "aws_approle" {
  name = "aws-approle-policy"

  policy = var.aws_approle_policy
}

resource "vault_approle_auth_backend_role" "aws_approle" {
  backend = vault_auth_backend.approle.path
  role_name = "aws-approle"
  token_policies = [ vault_policy.aws_approle.name ]
  token_ttl = 300
  token_max_ttl = 900
}
