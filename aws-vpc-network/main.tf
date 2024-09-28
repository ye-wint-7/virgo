data "aws_caller_identity" "whoami" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# using VAULT BACKED, reading creds and putting back to aws provider is not required 
# because setting env variable know which aws secret engine backend role need to be used 
# data "vault_aws_access_credentials" "dev_role" {
#   backend = "aws-dev"
#   role    = "aws-dev-role"
# }

# provider "aws" {
#   access_key = data.vault_aws_access_credentials.dev_role.access_key
#   secret_key = data.vault_aws_access_credentials.dev_role.secret_key
# }

#############################################################
#################### VPC ####################################

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name    = "${var.prefix}_vpc"
    project = "virgo"
    env     = "dev"
  }
}

#############################################################
#################### public subnet ##########################
resource "aws_subnet" "dev_public_subnet" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_cidr_block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}_public_subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.prefix}_public_rt"
  }
}

resource "aws_route_table_association" "dev_public_rta" {
  count          = length(var.public_cidr_block)
  subnet_id      = aws_subnet.dev_public_subnet[count.index].id
  route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.prefix}_igw"
  }
}

resource "aws_route" "dev_igw_route" {
  route_table_id         = aws_route_table.dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}

##############################################################
#################### private subnet ##########################
resource "aws_subnet" "dev_private_subnet" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}_private_subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_route_table" "dev_private_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.prefix}_private_rt"
  }
}

resource "aws_route_table_association" "dev_private_rta" {
  count          = length(var.private_cidr_block)
  subnet_id      = aws_subnet.dev_private_subnet[count.index].id
  route_table_id = aws_route_table.dev_private_rt.id
}

resource "aws_eip" "dev_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "dev_ngw" {
  allocation_id = aws_eip.dev_eip.id
  subnet_id     = aws_subnet.dev_public_subnet[0].id

  tags = {
    Name = "${var.prefix}_net_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.dev_igw]
}

resource "aws_route" "dev_private_ngw_route" {
  route_table_id         = aws_route_table.dev_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.dev_ngw.id
}

##############################################################
#################### db subnet ###############################

resource "aws_subnet" "dev_db_subnet" {
  count             = length(var.db_cidr_block)
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.db_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}_db_subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_route_table" "dev_db_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${var.prefix}_db_rt"
  }
}

resource "aws_route_table_association" "dev_db_rta" {
  count          = length(var.db_cidr_block)
  subnet_id      = aws_subnet.dev_db_subnet[count.index].id
  route_table_id = aws_route_table.dev_db_rt.id
}

resource "aws_route" "dev_db_ngw_route" {
  route_table_id         = aws_route_table.dev_db_rt.id
  gateway_id             = aws_nat_gateway.dev_ngw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_db_subnet_group" "dev_db_subnet_group" {
  name       = "dev_db_subnet_group"
  subnet_ids = aws_subnet.dev_db_subnet[*].id

  tags = {
    Name = "${var.prefix}_DB_Subnet_Group"
  }
}