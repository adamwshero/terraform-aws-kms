#################
# KMS Alias Vars
#################
variable "name" {
  description = "(Optional) The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string
  default     = ""
}

###############
# KMS Key Vars
###############
variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
  type        = number
  default     = 7
}
variable "customer_master_key_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}
variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = ""
}
variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to false."
  type        = bool
  default     = false
}
variable "key_usage" {
  description = "Specifies the intended use of the key."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}
variable "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region or regional."
  type        = bool
  default     = false
}
variable "policy" {
  description = "A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used."
  type        = string
  default     = ""
}
variable "tags" {
  description = "A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
}

############
# SOPS Vars
############
variable "sops_file" {
  description = "Name of the encrypted file to get secrets from."
  type        = string
  default     = ""
}

variable "enable_sops" {
  description = "Enables or disables SOPS file creation. Only creates CMK if false."
  type        = bool
  default     = true
}

