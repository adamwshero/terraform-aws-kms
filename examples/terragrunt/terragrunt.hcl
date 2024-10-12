locals {
  account     = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  region      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  sso_admin   = "arn:aws:iam::{accountid}:role/my_trusted_role"
  account_id  = "12345678910"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.2.0"
}

inputs = {
  is_enabled                         = true
  name                               = "alias/devops"
  description                        = "Used for managing devops-maintained encrypted data."
  deletion_window_in_days            = 7
  enable_key_rotation                = false
  key_usage                          = "ENCRYPT_DECRYPT"
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  bypass_policy_lockout_safety_check = false
  multi_region                       = true

  policy = templatefile("${get_terragrunt_dir()}/kms-primary.json.tpl", {
    sso_admin  = local.sso_admin
    account_id = local.account_id
  })

  // SOPS Config
  enable_sops_primary = true
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  // Grant Config
  grant_is_enabled      = true
  grant_name            = "test-grant"
  grantee_principal     = local.env_vars.locals.sso_administrator_role_arn_fqdn
  retiring_principal    = local.env_vars.locals.sso_administrator_role_arn_fqdn
  operations            = ["Encrypt", "Decrypt", "GenerateDataKey"]
  grant_creation_tokens = [base64encode("Token 1"), base64encode("Token 2")]
  retire_on_delete      = true

  encryption_context_equals = {
    Department = "Platform Engineering"
  }

  tags = {
    Environment        = local.env.locals.env
    Owner              = "Platform Engineering"
    CreatedByTerraform = true
  }
}
