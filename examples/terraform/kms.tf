data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_AWSAdministratorAccess_.*"
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "kms-sops" {
  source              = "ashero/kms/aws"
  alias               = "alias/devops-sops"
  description         = "DevOps CMK for SOPS use."
  enable_key_rotation = false
  sops_file           = "${path.root}/db-credentials/kms.sops.yaml"
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
