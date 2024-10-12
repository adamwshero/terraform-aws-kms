locals {
  account_id = "12345679810"
}
data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "primary-kms-sops" {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.2.0"

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
  sops_file           = "${path.module}/.sops.yaml"

  // Grant Config
  grant_is_enabled      = true
  grant_name            = "test-grant"
  grantee_principal     = local.env_vars.locals.sso_administrator_role_arn
  retiring_principal    = local.env_vars.locals.sso_administrator_role_arn
  operations            = ["Encrypt", "Decrypt", "GenerateDataKey"]
  grant_creation_tokens = [base64encode("Token 1"), base64encode("Token 2")]
  retire_on_delete      = true

  encryption_context_equals = {
    Department = "Platform Engineering"
  }

  tags = {
    Environment        = local.env
    Owner              = "Platform Engineering"
    CreatedByTerraform = true
  }
}
