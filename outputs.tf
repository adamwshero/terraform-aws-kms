output "kms_key_arn" {
  description = "Arn of the Customer Managed Key (CMK)"
  value       = var.is_enabled ? aws_kms_key.this[0].arn : "[INFO] KMS Key Not Enabled: No Output."
}

output "kms_key_id" {
  description = "Id of the Customer Managed Key (CMK)"
  value       = var.is_enabled ? aws_kms_key.this[0].key_id : "[INFO] KMS Key Not Enabled: No Output."
}

output "replica_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the replica key. The key ARNs of related multi-Region keys differ only in the Region value."
  value       = var.replica_is_enabled ? aws_kms_replica_key.this[0].arn : "[INFO] Replica KMS Key Not Enabled: No Output."
}

output "replica_kms_key_id" {
  description = "The key ID of the replica key. Related multi-Region keys have the same key ID."
  value       = var.replica_is_enabled ? aws_kms_replica_key.this[0].arn : "[INFO] Replica KMS Key Not Enabled: No Output."
}
output "primary_kms_sops_file" {
  description = "Output of the newly created KMS SOPS file."
  value       = var.enable_sops_primary ? local_file.sops_primary[0].content : "[INFO] Primary SOPS Not Enabled: No Output."
}

output "replica_kms_sops_file" {
  description = "Output of the newly created KMS SOPS file."
  value       = var.enable_sops_replica ? local_file.sops_replica[0].content : "[INFO] Replica SOPS Not Enabled: No Output."
}

output "kms_grant_id" {
  description = "Id of the Customer Managed Key (CMK) grant."
  value       = var.grant_is_enabled ? aws_kms_grant.this[0].grant_id : "[INFO] KMS Grant Not Enabled: No Output."
}

output "kms_grant_token" {
  description = "Token of the Customer Managed Key (CMK) grant."
  value       = var.grant_is_enabled ? "[SENSIIVE] Grant token can be retrieved from the state file :-) ." : "[INFO] KMS Grant Not Enabled: No Output."
}