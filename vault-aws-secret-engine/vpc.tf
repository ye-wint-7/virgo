provider "aws" {
  access_key = data.vault_aws_access_credentials.dev_role_cred.access_key
  secret_key = data.vault_aws_access_credentials.dev_role_cred.secret_key
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name    = "dev_vpc"
    project = "virgo"
    env     = "dev"
  }
}