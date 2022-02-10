###########
# KMS Vars
###########
variable "alias" {
  description = "Friendly name for the KMS key."
  type        = string
  default     = ""
}
variable "deletion_window_in_days" {
  description = "Number of days to wait before deletion."
  type        = string
  default     = "7"
}
variable "description" {
  description = "A useful description for the KMS key."
  type        = string
  default     = ""
}
variable "enable_key_rotation" {
  description = "Enables or disables key rotation."
  type        = bool
  default     = false
}
variable "policy" {
  description = "IAM policy for this KMS key."
}
variable "tags" {
  description = "Tags associated with this resource."
}
############
# SOPS Vars
############
variable "sops_file" {
  description = "Name of the encrypted file to get secrets from."
  type        = string
  default     = ""
}
