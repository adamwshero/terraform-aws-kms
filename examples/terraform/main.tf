locals {
  account_id = "12345679810"
}
data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "primary-kms-sops" {
  is_enabled                         = true
  name                               = "alias/devops"
  description                        = "Used for managing devops-maintained encrypted data."
  deletion_window_in_days            = 7
  enable_key_rotation                = false
  key_usage                          = "ENCRYPT_DECRYPT"
  customer_master_key_spec           = "SYMMETRIC_DEFAULT"
  bypass_policy_lockout_safety_check = false
  multi_region                       = true

  policy = templatefile("${path.module}/kms-primary.json.tpl", {
    iam_role_arn = data.aws_iam_roles.roles.arns
    account_id   = local.account_id
  })

  // SOPS Config
  enable_sops_primary = true
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
