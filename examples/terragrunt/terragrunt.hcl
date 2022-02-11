
locals {
  aws_region               = "us-east-1"
  account_id               = "123456879"
  environment              = "dev"
  tf_state_bucket_name     = "${local.org_prefix}-tfstate-${local.project}"
  tf_state_key_prefix      = "tf-state-${local.project}"
  tf_state_lock_table_name = "tf-state-${local.project}-locks"
  org_prefix               = "contoso"
  org_tld                  = "contoso.com"

}

## WS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<PROVIDER
provider "aws" {
  region = "${local.aws_region}"
  allowed_account_ids = ["${local.account_id}"]
}
PROVIDER
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.tf_state_bucket_name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = local.tf_state_lock_table_name
    encrypt        = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
