aws_approle_policy    = <<EOT
path "aws-dev/*" {
  capabilities = ["read"]
}
EOT
