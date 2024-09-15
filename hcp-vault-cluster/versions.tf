terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.96.0"
    }
  }
}

provider "hcp" {
  # client_id and client_secret value is setup as environment variable in Hashicorp Terraform workspace
  #client_id     = "service-principal-key-client-id"
  #client_secret = "service-principal-key-client-secret"
}