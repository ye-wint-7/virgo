data "tfe_workspace" "my_workspace" {
  organization = var.org_name
  name         = var.workspace_name
}
# The following variables must be set to allow runs
# to authenticate to AWS.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable


########################################################################
#################### Dynamic Provider Credential #######################
resource "tfe_variable" "tfc_vault_addr" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_ADDR"
  value        = var.vault_addr
  category     = "env"
  sensitive    = true
  description  = "The address of the Vault instance runs will access."
}

resource "tfe_variable" "tfc_vault_namespace" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_NAMESPACE"
  value        = var.vault_namespace
  category     = "env"
  description  = "Namespace that contains the AWS Secrets Engine."
}

resource "tfe_variable" "enable_vault_provider_auth" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  description  = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_role" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_RUN_ROLE"
  value        = var.vault_run_role
  category     = "env"
  description  = "The Vault role runs will use to authenticate."
}

########################################################################
########################## AWS #########################################
resource "tfe_variable" "aws_region" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "AWS_REGION"
  value        = "ap-southeast-1"
  category     = "env"
}