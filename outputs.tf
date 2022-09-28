output "kms_key_arn" {
  description = "Arn of the Customer Managed Key (CMK)"
  value       = var.is_enabled ? aws_kms_key.this[0].arn : "[INFO] KMS Key Skipped."
}
output "kms_key_id" {
  description = "Id of the Customer Managed Key (CMK)"
  value       = var.is_enabled ? aws_kms_key.this[0].key_id : "[INFO] KMS Key Skipped."
}

output "replica_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the replica key. The key ARNs of related multi-Region keys differ only in the Region value."
  value       = var.replica_is_enabled ? aws_kms_replica_key.this[0].arn : "[INFO] Replica KMS Key Skipped."
}

output "replica_kms_key_id" {
  description = "The key ID of the replica key. Related multi-Region keys have the same key ID."
  value       = var.replica_is_enabled ? aws_kms_replica_key.this[0].arn : "[INFO] Replica KMS Key Skipped."
}
output "primary_kms_sops_file" {
  description = "Output of the newly created KMS SOPS file."
  value       = var.enable_sops_primary ? local_file.sops_primary[0].content : "[INFO] Primary SOPS Skipped."
}

output "replica_kms_sops_file" {
  description = "Output of the newly created KMS SOPS file."
  value       = var.enable_sops_replica ? local_file.sops_replica[0].content : "[INFO] Replica SOPS Skipped."
}
