resource "aws_kms_key" "key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  policy                  = var.policy
  tags                    = var.tags
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_kms_alias" "alias" {
  name          = var.alias
  target_key_id = aws_kms_key.key.key_id
  lifecycle {
    prevent_destroy = true
  }
}
resource "local_file" "sops_file" {
  content         = <<EOF
creation_rules:
  - kms: ${aws_kms_key.key.arn}
EOF
  filename        = var.sops_file
  file_permission = "0600"
}
