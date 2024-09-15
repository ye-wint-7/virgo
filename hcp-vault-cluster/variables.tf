variable "hvn_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "hvn_cidr_block" {
  type    = string
  default = "172.25.16.0/20"
}

variable "hcp_vault_cluster_tier" {
  type    = string
  default = "dev"
}

variable "hcp_vault_cluster_public_endpoint" {
  type = bool
}