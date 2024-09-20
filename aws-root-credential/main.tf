module "iam_user_root_cred_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git?ref=v5.44.0"
  version = "5.44.0"
  
  name_prefix = "virgo-"
  path        = "/"
  description = "Vault Root Credential IAM USER Policy"

  policy = <<EOF
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
        "arn:aws:iam::${var.account_id}:user/${var.iam_user_name}"
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
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git?ref=v5.44.0"
  version = "5.44.0"

  name                          = var.iam_user_name
  policy_arns                   = [module.iam_policy.arn]
  force_destroy                 = true
  create_iam_access_key         = false
  create_iam_user_login_profile = false

  tags = {
    project = "virgo",
    env     = "dev"
  }
}