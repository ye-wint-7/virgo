resource "hcp_hvn" "virgo" {
  hvn_id         = "virgo"
  cloud_provider = "aws"
  region         = var.hvn_region
  cidr_block     = var.hvn_cidr_block
}

resource "hcp_vault_cluster" "virgo_vault_cluster" {
  cluster_id      = "virgo-vault-cluster"
  hvn_id          = hcp_hvn.virgo.hvn_id
  tier            = var.hcp_vault_cluster_tier
  public_endpoint = var.hcp_vault_cluster_public_endpoint
}