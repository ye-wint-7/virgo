provider "aws" {
  region = "ap-southeast-1"
}

module "iam_user_root_cred_policy" {
  source = "./modules/iam-policy"

  name        = "vault_root_cred_policy"
  path        = "/"
  description = "Vault Root Credential IAM USER Policy"
  policy      = <<EOF
{
  "Statement": [
    {
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::${var.account_id}:user/vault-*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF

  tags = {
    project = "virgo",
    env     = "dev"
  }
}

module "iam_user_root_cred" {
  source = "./modules/iam-user"

  name                          = var.iam_user_name
  policy_arns                   = [module.iam_user_root_cred_policy.arn]
  force_destroy                 = true
  create_iam_access_key         = true
  create_iam_user_login_profile = false

  tags = {
    project = "virgo",
    env     = "dev"
  }
}

resource "vault_aws_secret_backend" "aws_dev" {
  access_key = module.iam_user_root_cred.iam_access_key_id
  secret_key = module.iam_user_root_cred.iam_access_key_secret
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

data "vault_aws_access_credentials" "aws_dev_role_creds" {
  backend = vault_aws_secret_backend.aws_dev.path
  role    = vault_aws_secret_backend_role.aws_dev_role.name
}