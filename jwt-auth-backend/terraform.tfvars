tfc_hostname          = "https://app.terraform.io"
jwt_auth_role_name    = "admin-role"
tfc_organization_name = "HelloCloud-7"
tfc_project_name      = "virgo"
vault_admin_policy    = <<EOT
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path
# List, create, update, and delete key/value secrets
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["read"]
}

path "aws-master-account/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "aws-master-account/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/policy/" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "kvv2/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT

