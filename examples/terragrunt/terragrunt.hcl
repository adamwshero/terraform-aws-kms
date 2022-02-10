locals {
  account   = "123456789"
  region    = "us-east-1"
  env       = "dev"
  sso_admin = "arn:aws:iam::{accountid}:role/my_trusted_role"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "ashero/kms/aws"
}

inputs = {
  alias               = "alias/devops-sops"
  description         = "DevOps CMK for SOPS use."
  enable_key_rotation = false
  tags                = local.tags
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  policy = templatefile("${get_terragrunt_dir()}/kms-policy.json.tpl", {
    sso_admin = local.sso_admin
  })
  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
