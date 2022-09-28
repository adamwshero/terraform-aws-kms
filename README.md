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

Terraform module to create Amazon Customer Managed Key (CMK) including optional use with [Mozilla SOPS](https://github.com/mozilla/sops).

[Amazon Key Management Service (KMS)](https://aws.amazon.com/kms/) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. AWS KMS is a secure and resilient service that uses hardware security modules that have been validated under FIPS 140-2, or are in the process of being validated, to protect your keys. AWS KMS is integrated with AWS CloudTrail to provide you with logs of all key usage to help meet your regulatory and compliance needs.

## Examples

Look at our [Terraform example](latest/examples/terraform/) where you can get a better context of usage for both Terraform. The Terragrunt example can be viewed directly from GitHub.


## Usage

You can create a customer managed key (CMK) for use with the [Mozilla SOPS](https://github.com/mozilla/sops) tool. The module will create the CMK and gives you an option to also create a kms-sops.yaml for you to use with the SOPS tool for encrypting and decrypting files.

### Terraform Example with optional SOPS file and lifecycle policy.

```
module "kms-sops" {
  source                             = "adamwshero/kms/aws"
  version                            = "~> 1.1.6"
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
  sops_file                          = file("${path.module}/.sops.yaml")

  policy = jsonencode(
    {
      "Sid" : "Enable IAM policies",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Version" : "2012-10-17",
      "Id" : "1",
      "Statement" : [
        {
          "Sid" : "Account Permissions",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "${data.aws_iam_roles.roles.arns}"
          },
          "Action" : "kms:*",
          "Resource" : "*"
        }
      ]
    }
  )

  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
```

### Terragrunt Example with optional SOPS file and lifecycle policy.

```
locals {
  account     = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  region      = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  environment = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
  sso_admin   = "arn:aws:iam::{accountid}:role/my_trusted_role"
  account_id  = "12345679810"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "git@github.com:adamwshero/terraform-aws-kms.git//.?ref=1.1.6"
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

  policy = templatefile("${get_terragrunt_dir()}/policy.json.tpl", {
    sso_admin = local.sso_admin
    account_id = local.account_id
  })

  tags = {
    Environment        = local.env.locals.env
    Owner              = "DevOps"
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

| Name | Type |
|------|------|
| [aws_kms_key.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_alias.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [sops_file.rsm](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | resource |


## Available Inputs

| Name                | Resource    |  Variable                  | Data Type    | Default             | Required?
| --------------------| ------------|----------------------------| -------------|---------------------|----------
| Alias               |aws_kms_alias| `alias`                    | `string`     | `""`                | No
| Description         | aws_kms_key | `description`              | `string`     | `""`                | No
| Deletion Window     | aws_kms_key | `deletion_window_in_days`  | `number`     | `7`                 | No
| Enable Key Rotation | aws_kms_key | `enable_key_rotation`      | `bool`       | `false`             | No
| Key Usage           | aws_kms_key | `key_usage`                | `string`     | `ENCRYPT_DECRYPT`   | No
| Key Spec            | aws_kms_key | `customer_master_key_spec` | `string`     | `SYMMETRIC_DEFAULT` | No
| Multi-Region        | aws_kms_key | `multi_region`             | `bool`       | `false`             | No
| Policy              | aws_kms_key | `policy`                   | `string`     | `""`                | No
| Tags                | aws_kms_key | `tags`                     | `map(string)`| `""`                | No
| Local SOPS File     | sops_file   | `sops_file`                | `string`     | `""`                | Yes
| Enable SOPS File    | sops_file   | `enable_sops`              | `string`     | `true`              | No

## Predetermined Inputs

| Name                | Resource    |  Property                 | Data Type    | Default                 | Required?
| --------------------| ------------|---------------------------| -------------|-------------------------|----------
| Target KMS Key Id   |aws_kms_alias| `target_key_id`           | `string`     |`aws_kms_key.this.key.id`| Yes
| SOPS File Creation  | sops_file   | `creation_rules`          | `string`     | `aws_kms_key.this.arn`  | Yes
| SOPS File Permission| sops_file   | `file_permission`         | `string`     | `0600`                  | Yes

## Outputs

| Name      | Description                      |
|-----------|----------------------------------|
| CMK Arn   | Arn of the customer managed key. |
| CMK Id    | Id of the customer managed key.  |
| SOPS File | Contents of the SOPS file.       |
