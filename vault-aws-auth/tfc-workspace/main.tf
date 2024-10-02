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

############################################################################
#################### Vault Backed Dynamic Credential #######################
resource "tfe_variable" "tfc_vault_backed_aws_auth" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_BACKED_AWS_AUTH"
  value        = "true"
  category     = "env"
  description  = "Enable Vault backed aws authentication for Vault"
}

resource "tfe_variable" "tfc_vault_backed_aws_auth_type" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_BACKED_AWS_AUTH_TYPE"
  value        = "iam_user"
  category     = "env"
  description  = "Vault backed aws authentication type"
}

resource "tfe_variable" "enable_vault_backed_aws_run_vault_role" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE"
  value        = var.vault_aws_secret_engine_role
  category     = "env"
  description  = "Which role will be used under AWS Secret Engine"
}

resource "tfe_variable" "tfc_vault_backed_aws_mount_path" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "TFC_VAULT_BACKED_AWS_MOUNT_PATH"
  value        = var.vault_aws_secret_engine_path
  category     = "env"
  description  = "What is the path of AWS Secret Engine"
}

########################################################################
########################## AWS #########################################
resource "tfe_variable" "aws_region" {
  workspace_id = data.tfe_workspace.my_workspace.id
  key          = "AWS_REGION"
  value        = "ap-southeast-1"
  category     = "env"
}