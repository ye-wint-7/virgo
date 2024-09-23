
resource "vault_aws_secret_backend" "aws_dev" {
  access_key = aws_iam_access_key.vault_admin_access_key.id
  secret_key = aws_iam_access_key.vault_admin_access_key.secret
  region = var.region
  path =  var.vault_aws_backend_path
  default_lease_ttl_seconds = 900
  max_lease_ttl_seconds = 1800
}

resource "vault_aws_secret_backend_role" "aws_dev_role" {
  backend = vault_aws_secret_backend.aws_dev.path
  name    = var.vault_aws_backend_role_name
  credential_type = "iam_user"
  policy_arns = ["arn:aws:iam::aws:policy/AmazonVPCFullAccess"]
}

data "vault_aws_access_credentials" "dev_role_cred" {
  backend = vault_aws_secret_backend.aws_dev.path
  role    = vault_aws_secret_backend_role.aws_dev_role.name
}