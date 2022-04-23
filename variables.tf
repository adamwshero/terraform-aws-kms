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
variable "is_enabled" {
  description = "(Optional) Specifies whether the key is enabled. Defaults to true."
  type        = bool
  default     = true
}
variable "description" {
  description = "(Optional) The description of the key as viewed in AWS console."
  type        = string
  default     = ""
}
variable "deletion_window_in_days" {
  description = "(Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30. If the KMS key is a multi-Region primary key with replicas, the waiting period begins when the last of its replica keys is deleted. Otherwise, the waiting period begins immediately."
  type        = number
  default     = 7
}
variable "customer_master_key_spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT. For help with choosing a key spec, see the [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}
variable "bypass_policy_lockout_safety_check" {
  description = "(Optional) A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the Default Key Policy section in the [AWS KMS Developer Guide](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html). The default value is false."
  type        = bool
  default     = false
}

variable "enable_key_rotation" {
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
  type        = bool
  default     = false
}
variable "key_usage" {
  description = "(Optional) Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}
variable "multi_region" {
  description = "(Optional) Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false."
  type        = bool
  default     = false
}
variable "policy" {
  description = "(Optional) A valid policy JSON document. Although this is a key policy, not an IAM policy, an aws_iam_policy_document, in the form that designates a principal, can be used. For more information about building policy documents with Terraform, see the [AWS KMS Policy Guide](https://docs.aws.amazon.com/kms/latest/developerguide/determining-access-key-policy.html)."
  type        = string
  default     = ""
}
variable "tags" {
  description = "(Optional) A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
}

############
# SOPS Vars
############
variable "sops_file" {
  description = "(Required) name of the file and path to the encrypted file."
  type        = string
  default     = ""
}

variable "enable_sops" {
  description = "(Optional) Enables or disables SOPS file creation. Only creates CMK if false."
  type        = bool
  default     = true
}

