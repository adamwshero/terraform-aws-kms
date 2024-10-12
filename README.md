[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

![Terraform](https://cloudarmy.io/tldr/images/tf_aws.jpg)
<br>
<br>
<br>
<br>
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/adamwshero/terraform-aws-kms?color=lightgreen&label=latest%20tag%3A&style=for-the-badge)
<br>
<br>
# terraform-aws-kms

Terraform module to create an Amazon KMS Key or Replica KMS key including optional integration with [Mozilla SOPS](https://github.com/mozilla/sops).

[Amazon Key Management Service (KMS)](https://aws.amazon.com/kms/) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. AWS KMS is a secure and resilient service that uses hardware security modules that have been validated under FIPS 140-2, or are in the process of being validated, to protect your keys. AWS KMS is integrated with AWS CloudTrail to provide you with logs of all key usage to help meet your regulatory and compliance needs.
<br>

## Module Capabilities
- (Optional) Create a primary KMS key in either single/multi-region.
- (Optional) Create a replica KMS key in a different region of the primary multi-region KMS key.
- (Optional) Create a corresponding SOPS file containing the primary KMS or replica KMS arn.
- (Optional) Create a KMS Grant including encryption constraints.
<br>

## Examples
Look at our complete [Terraform examples](latest/examples/terraform/) where you can get a better context of usage for various scenarios. The Terragrunt example can be viewed directly from GitHub.
<br>

## Assumptions
  * (Replica KMS Keys)
    * The primary KMS key you initially created was created as a multi-region KMS key.
<br>

## Usage
You can create a primary KMS key or a replica of a multi-region primary KMS key for use with the [Mozilla SOPS](https://github.com/mozilla/sops) tool. The module will create the key and gives you an option to also create a kms-sops.yaml for you to use with the SOPS tool for encrypting and decrypting files.
<br>

## Special Notes
* (Single/Multi-Region)
  * You may create a single region KMS key but please be aware that you will not be able to create a replica of that key. Only multi-region primary KMS keys can have replicas.
<br>

## Upcoming Improvements
* Add grant capability.
<br>

### Terraform Example with optional SOPS file.
```
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
  sops_file           = "${get_terragrunt_dir()}/.sops.yaml"

  // KMS Grants
  grant_is_enabled      = true
  grant_name            = "test-grant"
  grantee_principal     = local.sso_administrator_role_arn
  retiring_principal    = local.sso_administrator_role_arn
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
```

### Terragrunt Example with optional SOPS file.

```
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

  // KMS Grants
  grant_is_enabled      = true
  grant_name            = "test-grant"
  grantee_principal     = local.sso_administrator_role_arn
  retiring_principal    = local.sso_administrator_role_arn
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
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.67.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 
| <a name="requirement_terragrunt"></a> [terragrunt](#requirement\_terragrunt) | >= 0.28.0 |

## Providers
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.67.0 |

## Resources
| Name                                                                                                                   | Type     |
| ---------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_kms_key.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                 | resource |
| [aws_kms_alias.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)             | resource |
| [aws_kms_replica_key.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_kms_grant.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_grant)             | resource |
| [sops_file.rsm](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file)                   | resource |


## Available Inputs
| Name                  | Resource            | Variable                                     | Data Type    | Default             | Required?
| --------------------- | ------------------- |--------------------------------------------- | -------------|---------------------|----------
| Alias                 | aws_kms_alias       | `alias`                                      | `string`     | `null`              | No
| Description           | aws_kms_key         | `description`                                | `string`     | `null`              | No
| Deletion Window       | aws_kms_key         | `deletion_window_in_days`                    | `number`     | `7`                 | No
| Enable Key Rotation   | aws_kms_key         | `enable_key_rotation`                        | `bool`       | `false`             | No
| Key Usage             | aws_kms_key         | `key_usage`                                  | `string`     | `ENCRYPT_DECRYPT`   | No
| Bypass Policy Lockout | aws_kms_key         | `bypass_policy_lockout_safety_check`         | `bool`       | `false`             | No
| Key Spec              | aws_kms_key         | `customer_master_key_spec`                   | `string`     | `SYMMETRIC_DEFAULT` | No
| Multi-Region          | aws_kms_key         | `multi_region`                               | `bool`       | `false`             | No
| Policy                | aws_kms_key         | `policy`                                     | `string`     | `null`              | No
| Tags                  | aws_kms_key         | `tags`                                       | `map(string)`| `null`              | No
| Replica Enabled       | aws_kms_replica_key | `replica_is_enabled`                         | `map(string)`| `false`             | No
| Description           | aws_kms_replica_key | `replica_description`                        | `string`     | `null`              | No
| Deletion Window       | aws_kms_replica_key | `replica_deletion_window_in_days`            | `number`     | `7`                 | No
| Enable Key Rotation   | aws_kms_replica_key | `enable_key_rotation`                        | `bool`       | `false`             | No
| Bypass Policy Lockout | aws_kms_replica_key | `replica_bypass_policy_lockout_safety_check` | `bool`       | `false`             | No
| Primary Key Arn       | aws_kms_replica_key | `primary_key_arn`                            | `map(string)`| `null`              | Yes
| Replica Policy        | aws_kms_replica_key | `replica_policy`                             | `map(string)`| `null`              | No
| Enable KMS Grant      | aws_kms_grant       | `grant_is_enabled`                           | `bool`       | `false`             | No
| Grant Name            | aws_kms_grant       | `grant_name`                                 | `string`     | `null`              | No
| Grantee Principal     | aws_kms_grant       | `grantee_principal`                          | `string`     | `null`              | No
| Operations            | aws_kms_grant       | `operations`                                 | `list`       | `[]`                | No
| Retiring Principal    | aws_kms_grant       | `retiring_principal`                         | `string`     | `null`              | No
| Encryption Context    | aws_kms_grant       | `encryption_context_equals`                  | `map(string)`| `null`              | No
| Encryption Context    | aws_kms_grant       | `encryption_context_subset`                  | `map(string)`| `null`              | No
| Grant Tokens          | aws_kms_grant       | `grant_creation_tokens`                      | `list`       | `[]`                | No
| Retire On Delete      | aws_kms_grant       | `retire_on_delete`                           | `bool`       | `false`             | No
| Create Primary SOPS   | local_file          | `create_sops_primary`                        | `string`     | `false`             | No
| Create Replica SOPS   | local_file          | `create_sops_replica`                        | `string`     | `false`             | No
| SOPS File Path        | local_file          | `sops_file`                                  | `string`     | `null`              | No

## Predetermined Inputs
| Name                | Resource    |  Property                 | Data Type    | Default                 | Required?
| --------------------| ------------|---------------------------| -------------|-------------------------|----------
| Target KMS Key Id   |aws_kms_alias| `target_key_id`           | `string`     |`aws_kms_key.this.key.id`| Yes
| SOPS File Creation  | sops_file   | `creation_rules`          | `string`     | `aws_kms_key.this.arn`  | Yes
| SOPS File Permission| sops_file   | `file_permission`         | `string`     | `0600`                  | Yes

## Outputs
| Name                      | Description                                |
|-------------------------- | ------------------------------------------ |
| Primary KMS Key Arn       | Arn of the primary KMS key.                |
| Primary KMS Key Id        | Id of the primary KMS key.                 |
| Primary KMS Key SOPS File | Contents of the primary kms key SOPS file. |
| Replica KMS Key Arn       | Arn of the replica KMS key.                |
| Replica KMS Key Id        | Id of the replica KMS key.                 |
| KMS Grant Id              | Id of the KMS key grant.                   |
| KMS Grant Token           | Token of the KMS key grant. (sensitive)    |
| Replica KMS Key SOPS File | Contents of the replica kms key SOPS file. |
