output "hvn_id" {
  description = "HCP HVN ID"
  value       = hcp_hvn.virgo.id
}

output "vault_id" {
  description = "HCP Vault Cluster ID"
  value       = hcp_vault_cluster.virgo_vault_cluster.id
}

output "vault_namespace" {
  description = "HCP Vault Cluster Namespace"
  value       = hcp_vault_cluster.virgo_vault_cluster.namespace
}

output "vault_public_endpoint_url" {
  description = "HCP Vault Cluster vault_public_endpoint_url"
  value       = hcp_vault_cluster.virgo_vault_cluster.vault_public_endpoint_url
}

output "vault_version" {
  description = "HCP Vault Cluster vault_version"
  value       = hcp_vault_cluster.virgo_vault_cluster.vault_version
}
output "vault_private_endpoint_url" {
  description = "HCP Vault Cluster vault_public_endpoint_url"
  value       = hcp_vault_cluster.virgo_vault_cluster.vault_private_endpoint_url
}

output "vault_admin_token" {
  description = "The Vault cluster admin token resource generates an admin-level token for the HCP Vault cluster."
  value       = hcp_vault_cluster_admin_token.vault_admin_token.token
  sensitive   = true
}