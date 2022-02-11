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
  source = "git@github.com:adamwshero/terraform-aws-kms.git//?ref=1.0.7"
}

inputs = {
  alias                   = "alias/devops-sops"
  description             = "DevOps CMK for SOPS use."
  deletion_window_in_days = 7
  enable_key_rotation     = false
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false
  sops_file               = "${get_terragrunt_dir()}/.sops.yaml"

  policy = templatefile("${get_terragrunt_dir()}/kms-policy.json.tpl", {
    sso_admin = local.sso_admin
  })
  tags = {
    Environment        = local.env.locals.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
