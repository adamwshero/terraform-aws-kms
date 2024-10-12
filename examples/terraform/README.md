## Basic Terraform Example (Primary KMS Only)

```
module "primary-kms" {
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

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```
## Complete Terraform Example (Primary KMS + SOPS)

```
module "complete-primary-kms-sops" {
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
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```
## Basic Terraform Example (Replica KMS Only)

```
module "replica-kms" {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.2.0"

  replica_is_enabled                         = true
  replica_description                        = "Used for managing devops-maintained encrypted data."
  replica_deletion_window_in_days            = 7
  replica_bypass_policy_lockout_safety_check = false
  primary_key_arn                            = "arn:aws:kms:us-east-1:111111111111:key/mrk-a111a111aaaa111111111111aaa1aaaa"

  replica_policy = templatefile("${path.module}/kms-replica.json.tpl", {
    iam_role_arn = data.aws_iam_roles.roles.arns
    account_id   = local.account_id
  })

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```
## Complete Terraform Example (Replica KMS + SOPS)

```
module "complete-replica-kms-sops" {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.2.0"

  replica_is_enabled                         = true
  replica_description                        = "Used for managing devops-maintained encrypted data."
  replica_deletion_window_in_days            = 7
  replica_bypass_policy_lockout_safety_check = false
  primary_key_arn                            = "arn:aws:kms:us-east-1:111111111111:key/mrk-a111a111aaaa111111111111aaa1aaaa"

  policy = templatefile("${path.module}/kms-replica.json.tpl", {
    iam_role_arn = data.aws_iam_roles.roles.arns
    account_id   = local.account_id
  })

  // SOPS Config
  enable_sops_replica = true
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```
## Complete Terragrunt Example (Primary KMS Key + SOPS + Grant)
```
module "complete-primary-kms-sops-grant" {
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
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```
