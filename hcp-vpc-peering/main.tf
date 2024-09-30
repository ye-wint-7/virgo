# hvn initiate vpc peering to aws
resource "hcp_aws_network_peering" "dev" {
  hvn_id          = var.hvn_id
  peering_id      = "hvn-to-vpc-peering"
  peer_vpc_id     = data.terraform_remote_state.vault_admin.outputs.vpc_id
  peer_account_id = data.aws_vpc.vpc.owner_id
  peer_vpc_region = data.aws_arn.vpc_arn.region
}

# aws accept vpc peering from hvn
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = hcp_aws_network_peering.dev.provider_peering_id
  auto_accept               = true
}

# adding route in hvn (for private subnets)
resource "hcp_hvn_route" "hvn-to-private" {
  for_each = data.aws_subnet.private_subnets
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = each.value.id
  destination_cidr = each.value.cidr_block
  target_link      = hcp_aws_network_peering.dev.self_link
}

# adding route in hvn (for db subnets)
resource "hcp_hvn_route" "hvn-to-db" {
  for_each = data.aws_subnet.db_subnets
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = each.value.id
  destination_cidr = each.value.cidr_block
  target_link      = hcp_aws_network_peering.dev.self_link
}

# adding route in aws private route table   
resource "aws_route" "private" {
  route_table_id            = data.aws_route_table.private_rt.id
  destination_cidr_block    = data.hcp_hvn.hvn.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
}

resource "aws_route" "db" {
  route_table_id            = data.aws_route_table.db_rt.id
  destination_cidr_block    = data.hcp_hvn.hvn.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id
}