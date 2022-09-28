resource "aws_kms_key" "this" {
  count = var.is_enabled ? 1 : 0

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
  count = var.is_enabled ? 1 : 0

  name          = var.name
  target_key_id = aws_kms_key.this[0].key_id
}

resource "local_file" "this" {
  count = var.enable_sops ? 1 : 0 && var.is_enabled ? 1 : 0

  content         = <<EOF
creation_rules:
  - kms: ${aws_kms_key.this[count.index].arn}
EOF
  filename        = var.sops_file
  file_permission = "0600"
}

resource "aws_kms_replica_key" "this" {
  count = var.replica_is_enabled ? 1 : 0

  enabled                            = var.replica_is_enabled
  description                        = var.replica_description
  deletion_window_in_days            = var.replica_deletion_window_in_days
  bypass_policy_lockout_safety_check = var.replica_bypass_policy_lockout_safety_check
  primary_key_arn                    = var.primary_key_arn
  policy                             = var.replica_policy
}
