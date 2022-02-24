resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  key_usage               = var.key_usage
  multi_region            = var.multi_region
  policy                  = var.policy
  tags                    = var.tags
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_kms_alias" "this" {
  name          = var.alias
  target_key_id = aws_kms_key.this.key_id
  lifecycle {
    prevent_destroy = true
  }
}
resource "local_file" "this" {
  content         = <<EOF
creation_rules:
  - kms: ${aws_kms_key.this.arn}
EOF
  filename        = var.sops_file
  file_permission = "0600"
}
