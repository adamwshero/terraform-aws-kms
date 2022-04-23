locals {
  account     = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  region      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  sso_admin   = "arn:aws:iam::{accountid}:role/my_trusted_role"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.1.4"
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
  multi_region                       = false
  enable_sops                        = true
  sops_file                          = "${get_terragrunt_dir()}/.sops.yaml"
  prevent_destroy                    = false
  lifecycle = {
    prevent_destroy = true
  }

  policy = templatefile("${get_terragrunt_dir()}/policy.json.tpl", {
    sso_admin = local.account_vars.locals.sso_admin
  })
  tags = {
    Environment        = local.env.locals.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
