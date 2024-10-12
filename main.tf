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

resource "aws_kms_replica_key" "this" {
  count = var.replica_is_enabled ? 1 : 0

  enabled                            = var.replica_is_enabled
  description                        = var.replica_description
  deletion_window_in_days            = var.replica_deletion_window_in_days
  bypass_policy_lockout_safety_check = var.replica_bypass_policy_lockout_safety_check
  primary_key_arn                    = var.primary_key_arn
  policy                             = var.replica_policy
}

resource "aws_kms_grant" "this" {
  count = var.grant_is_enabled ? 1 : 0

  name                = var.grant_name
  key_id              = aws_kms_key.this[0].key_id
  grantee_principal   = var.grantee_principal
  operations          = var.operations
  retiring_principal  = var.retiring_principal
  retire_on_delete    = var.retire_on_delete
  grant_creation_tokens   = var.grant_creation_tokens
  constraints {
      encryption_context_equals = var.encryption_context_equals
      encryption_context_subset = var.encryption_context_subset
    }
}

resource "local_file" "sops_primary" {
  count = var.enable_sops_primary ? 1 : 0 

  content         = <<-EOF
creation_rules:
  - kms: ${aws_kms_key.this[0].arn}
EOF
  filename        = var.sops_file
  file_permission = "0600"
}

resource "local_file" "sops_replica" {
  count = var.enable_sops_replica ? 1 : 0

  content         = <<-EOF
creation_rules:
  - kms: ${aws_kms_replica_key.this[0].arn}
EOF
  filename        = var.sops_file
  file_permission = "0600"
}
