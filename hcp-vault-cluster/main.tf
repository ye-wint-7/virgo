resource "hcp_hvn" "virgo" {
  hvn_id         = "virgo"
  cloud_provider = "aws"
  region         = "ap-southeast-1"
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_vault_cluster" "virgo_vault_cluster" {
  cluster_id      = "virgo-vault-cluster"
  hvn_id          = hcp_hvn.virgo.hvn_id
  tier            = "starter_small"
  public_endpoint = true
}