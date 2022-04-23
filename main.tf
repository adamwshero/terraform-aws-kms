resource "aws_kms_key" "this" {
  is_enabled                         = var.is_enabled
  description                        = var.description
  deletion_window_in_days            = var.deletion_window_in_days
  customer_master_key_spec           = var.customer_master_key_spec
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  enable_key_rotation                = var.enable_key_rotation
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  policy                             = var.policy
  tags                               = var.tags
}

resource "aws_kms_alias" "this" {
  name          = var.name
  target_key_id = aws_kms_key.this.key_id
}

resource "local_file" "this" {
  content         = <<EOF
creation_rules:
  - kms: ${aws_kms_key.this.arn}
EOF
  count           = var.enable_sops ? 1 : 0
  filename        = var.sops_file
  file_permission = "0600"
}
