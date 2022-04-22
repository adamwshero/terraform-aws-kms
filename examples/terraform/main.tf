data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "kms-sops" {
  source                   = "adamwshero/kms/aws"
  version                  = "~> 1.1.2"
  alias                    = "alias/devops-sops"
  description              = "DevOps CMK for SOPS use."
  deletion_window_in_days  = 7
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"
  enable_key_rotation      = false
  multi_region             = false
  sops_file                = "${path.root}/path-to-file/cmk.sops.yaml"
  enable_sops              = true
  lifecycle = {
    prevent_destroy = true
  }

  policy = jsonencode(
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
  })
  tags = {
    Environment        = local.env
    Owner              = "DevOps"
    CreatedByTerraform = true
  }
}
