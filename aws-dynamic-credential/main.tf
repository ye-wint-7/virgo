# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
# provider "aws" {
#   region = var.aws_region
# }

# Discovery URL of terraform
data "tls_certificate" "tfc_certificate" {
  url = "https://${var.tfc_hostname}"
}

# openid provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

# iam-role for dynamic credential
# using AssumeRoleWithWebIdentity trust relationship
resource "aws_iam_role" "tfc_aws_role" {
  name = "tfc-aws-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "${var.tfc_hostname}:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
       },
       "StringLike": {
         "${var.tfc_hostname}:sub": "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

# aws policy for dynamic credential role
# giving iam full access role
resource "aws_iam_policy" "tfc_aws_policy" {
  name        = "tfc-aws-policy"
  description = "TFC run policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "iam:*",
            "organizations:DescribeAccount",
            "organizations:DescribeOrganization",
            "organizations:DescribeOrganizationalUnit",
            "organizations:DescribePolicy",
            "organizations:ListChildren",
            "organizations:ListParents",
            "organizations:ListPoliciesForTarget",
            "organizations:ListRoots",
            "organizations:ListPolicies",
            "organizations:ListTargetsForPolicy"
        ],
        "Resource": "*"
    }
]
}
EOF
}

# poilcy attachment to role
resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_aws_role.name
  policy_arn = aws_iam_policy.tfc_aws_policy.arn
}