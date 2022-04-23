# Complete Plan Example

```
data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "kms-sops" {
  source                             = "adamwshero/kms/aws"
  version                            = "~> 1.1.4"
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
