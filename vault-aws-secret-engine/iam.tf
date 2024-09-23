resource "aws_iam_user" "vault_admin" {
  name = "vault-admin"
  path = "/"

  tags = {
    Name = "vault-admin"
  }
}

data "aws_iam_policy_document" "vault_admin_policy" {
  statement {
    effect    = "Allow"
    actions   = [
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
    ]
    resources = ["arn:aws:iam::${var.account_id}:user/vault-*"]
  }
}

resource "aws_iam_policy" "vault_admin_policy" {
  name        = "vault-admin-policy"
  path        = "/"
  description = "Policy for the Vault Admin"
  policy = data.aws_iam_policy_document.vault_admin_policy.json
}

resource "aws_iam_user_policy_attachment" "vault_admin_policy_attach" {
  user       = aws_iam_user.vault_admin.name
  policy_arn = aws_iam_policy.vault_admin_policy.arn
}

resource "aws_iam_access_key" "vault_admin_access_key" {
  user    = aws_iam_user.vault_admin.name
}