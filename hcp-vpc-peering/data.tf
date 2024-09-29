# To get vpc_id output from aws-vpc-network workspace
data "terraform_remote_state" "vault_admin" {
  backend = "remote"
  config = {
    organization = "HelloCloud-7"
    workspaces = {
      name = "aws-vpc-network"
    }
  }
}

# to get account id where vpc exist
data "aws_vpc" "vpc" {
  id = data.terraform_remote_state.vault_admin.outputs.vpc_id
}

# to get region where vpc exist
data "aws_arn" "vpc_arn" {
  arn = data.aws_vpc.vpc.arn
}

# all private subnets - return id list
data "aws_subnets" "private_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vault_admin.outputs.vpc_id]
  }

  filter {
    name   = "tag:Name"      # Second condition: filter by the 'Name' tag of the subnet
    values = ["${var.prefix}_private*"]       # Match subnets with names starting with 'test'
  }
}

# each private subnet detail
data "aws_subnet" "private_subnets" {
  for_each = toset(data.aws_subnets.private_subnet_ids.ids)
  id = each.key
}

data "hcp_hvn" "hvn" {
  hvn_id = var.hvn_id
}

# all db subnets - return id list
data "aws_subnets" "db_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vault_admin.outputs.vpc_id]
  }

  filter {
    name   = "tag:Name"      # Second condition: filter by the 'Name' tag of the subnet
    values = ["${var.prefix}_db*"]       # Match subnets with names starting with 'test'
  }
}

# each db subnet detail
data "aws_subnet" "db_subnets" {
  for_each = toset(data.aws_subnets.db_subnet_ids.ids)
  id = each.key
}

data "aws_route_table" "private_rt" {
  subnet_id = data.aws_subnets.private_subnet_ids.ids[0]
}

data "aws_route_table" "db_rt" {
  subnet_id = data.aws_subnets.db_subnet_ids.ids[0]
}