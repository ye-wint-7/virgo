# This resource enables a new secrets engine at the given path.
resource "vault_mount" "kvv2" {
  path = "kvv2"
  type = "kv-v2"
  options = {
    version = "2"
  }
  description = "KV Version 2 secret engine mount "
}

# Writes a KV-V2 secret to a given path in Vault.
resource "vault_kv_secret_v2" "example" {
  mount               = vault_mount.kvv2.path
  name                = "unsecret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      foo                         = "bar",
      dynamic_provider_credential = "true",
      add_new_key_value           = "add_new"
    }
  )
}
