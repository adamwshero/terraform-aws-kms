output "arn" {
  description = "Arn of the Customer Managed Key (CMK)"
  value       = aws_kms_key.this.arn
}
output "key_id" {
  description = "Id of the Customer Managed Key (CMK)"
  value       = aws_kms_key.this.key_id
}
output "sops_file" {
  description = "Output of the newly created KMS SOPS file."
  value       = <<EOF
---
creation_rules:
  - kms: ${aws_kms_key.this.arn}
EOF
}
