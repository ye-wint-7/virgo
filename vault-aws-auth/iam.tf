#########################################################
############### create vault-auth-admin ################# 
resource "aws_iam_user" "lb" {
  name = var.vault_auth_iam_user_name
  path = "/"
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}

data "aws_iam_policy_document" "vault_auth_policy" {
  statement {
    sid    = "VaultAWSAuthMethod"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "vault-auth-policy"
  user   = aws_iam_user.lb.name
  policy = data.aws_iam_policy_document.vault_auth_policy.json
}

#########################################################
############### role to assumed by ec2 ################## 
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "EC2-assumed-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "EC2-assumed-role-instance-profile"
  role = aws_iam_role.ec2_role.id
}