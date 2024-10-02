resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_auth_backend_client" "aws" {
  backend    = vault_auth_backend.aws.path
  access_key = aws_iam_access_key.lb.id
  secret_key = aws_iam_access_key.lb.secret
}

resource "vault_policy" "db-policy" {
  name   = "db-policy"
  policy = <<EOT
  # Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}
# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}
path "db/" {
  capabilities = ["read","list"]
}
path "db/*" {
  capabilities = ["read","list"]
}
path "aws-dev/" {
  capabilities = ["read","list"]
}
path "aws-dev/*" {
  capabilities = ["read","list"]
}
EOT
}

resource "time_sleep" "wait_before_vault_aws_auth_backend_role" {
  depends_on      = [aws_iam_role.ec2_role]
  create_duration = "20s"
}


resource "vault_aws_auth_backend_role" "aws" {
  depends_on               = [time_sleep.wait_before_vault_aws_auth_backend_role]
  backend                  = vault_auth_backend.aws.path
  role                     = var.aws_auth_backend_role_name
  auth_type                = "iam"
  bound_iam_principal_arns = [aws_iam_role.ec2_role.arn]
  token_ttl                = 300
  token_max_ttl            = 600
  token_policies           = [vault_policy.db-policy.name]
}