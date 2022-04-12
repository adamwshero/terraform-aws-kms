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

Terraform module to create Amazon Customer Managed Key (CMK) for use with [Mozilla SOPS](https://github.com/mozilla/sops).

[Amazon Key Management Service (KMS)](https://aws.amazon.com/kms/) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. AWS KMS is a secure and resilient service that uses hardware security modules that have been validated under FIPS 140-2, or are in the process of being validated, to protect your keys. AWS KMS is integrated with AWS CloudTrail to provide you with logs of all key usage to help meet your regulatory and compliance needs.

## Examples

Look at our [Terraform example](latest/examples/terraform/) where you can get a better context of usage for both Terraform. The Terragrunt example can be viewed directly from GitHub.


## Usage

You can create a customer managed key (CMK) for use with the [Mozilla SOPS](https://github.com/mozilla/sops) tool. The module will create the CMK and also create a kms-sops.yaml for you to use with the SOPS tool for encrypting and decrypting files.

### Terraform Example

```
module "kms-sops" {

    source = "adamwshero/kms/aws"
    version = "~> 1.1.0"

    alias                    = "alias/devops-sops"
    description              = "DevOps CMK for SOPS use."
    deletion_window_in_days  = 7
    enable_key_rotation      = false
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    multi_region             = false
    sops_file                = "${path.root}/path-to-file/kms.sops.yaml"
    policy = jsonencode(
        {
        "Version" : "2012-10-17",
        "Id" : "1",
        "Statement" : [
            {
            "Sid" : "GrantAccessToCMK",
            "Effect" : "Allow",
            "Principal" : {
                "AWS" : "arn:aws:iam::{accountid}:role/my_trusted_role"
            },
            "Action" : "kms:*",
            "Resource" : "*"
            }
        ]
    })
    tags = {
        application              = "my-service"
        environment              = "dev"
        last_modified_by         = "devops.hero@company.com"
        team_name                = "devops"
    }
}
```

### Terragrunt Example

```
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
  source = "git@github.com:adamwshero/terraform-aws-kms.git//?ref=1.1.0"
}

inputs = {
  alias                    = "alias/devops-sops"
  description              = "DevOps CMK for SOPS use."
  deletion_window_in_days  = 7
  enable_key_rotation      = false
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  multi_region             = false
  sops_file                = "${get_terragrunt_dir()}/.sops.yaml"

  policy = templatefile("${get_terragrunt_dir()}/kms-policy.json.tpl", {
    sso_admin = local.sso_admin
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
| [aws_ksm_key.rsm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Available Inputs

| KMS Property        | Variable                   | Data Type   |
| --------------------| ---------------------------| ------------|
| Alias               | `alias`                    | String      |
| Description         | `description`              | String      |
| Deletion Window     | `deletion_window_in_days`  | number      |
| Enable Key Rotation | `enable_key_rotation`      | bool        |
| Key Usage           | `key_usage`                | string      |
| Key Spec            | `customer_master_key_spec`| string      |
| Local SOPS File     | `sops_file`                | string      |
| Multi-Region        | `multi_region`             | bool        |
| Policy              | `policy`                   | map(string) |
| Tags                | `tags`                     | map(string) |

## Outputs

| Name      | Description                      |
|-----------|----------------------------------|
| CMK Arn   | Arn of the customer managed key. |
| CMK Id    | Id of the customer managed key.  |
| SOPS File | Contents of the SOPS file.       |
