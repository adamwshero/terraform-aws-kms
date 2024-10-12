#################
# KMS Alias Vars
#################
variable "name" {
  description = "(Optional) The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string
  default     = null
}

###############
# KMS Key Vars
###############
variable "is_enabled" {
  description = "(Optional) Specifies whether the key is enabled. Defaults to true."
  type        = bool
  default     = false
}

variable "description" {
  description = "(Optional) The description of the key as viewed in AWS console."
  type        = string
  default     = null
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
  default     = null
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
  default     = null
}

variable "enable_sops_replica" {
  description = "(Optional) Enables or disables SOPS file creation. Skips creating the sops file if false."
  type        = bool
  default     = false
}

variable "enable_sops_primary" {
  description = "(Optional) Enables or disables SOPS file creation. Skips creating the sops file if false."
  type        = bool
  default     = false
}

#######################
# KMS Key Replica Vars
#######################
variable "replica_is_enabled" {
  description = "(Optional) Specifies whether the replica key is enabled. Disabled KMS keys cannot be used in cryptographic operations. The default value is `false`."
  type        = bool
  default     = false
}

variable "replica_description" {
  description = "value"
  type        = string
  default     = null
}

variable "replica_deletion_window_in_days" {
  description = "(Optional) The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`."
  type        = number
  default     = 30
}

variable "replica_bypass_policy_lockout_safety_check" {
  description = "(Optional) A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately. For more information, refer to the scenario in the Default Key Policy section in the AWS Key Management Service Developer Guide. The default value is `false`."
  type        = bool
  default     = false
}

variable "primary_key_arn" {
  description = "(Required) The ARN of the multi-Region primary key to replicate. The primary key must be in a different AWS Region of the same AWS Partition. You can create only one replica of a given primary key in each AWS Region."
  type        = string
  default     = null
}

variable "replica_policy" {
  description = "(Optional) The key policy to attach to the KMS key. If you do not specify a key policy, AWS KMS attaches the default key policy to the KMS key. For more information about building policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
  default     = null
}

#################
# KMS Grant Vars
#################
variable "grant_is_enabled" {
  description = "(Optional) Specifies whether the grant is enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "grant_name" {
  description = "(Optional, Forces new resources) A friendly name for identifying the grant."
  type        = string
  default     = null
}

variable "grantee_principal" {
  description = "(Optional, Forces new resources) The Arn of the IAM role you wish to use as the grantee."
  type        = string
  default     = null
}

variable "operations" {
  description = "(Required, Forces new resources) A list of operations that the grant permits. The permitted values are: `Decrypt`, `Encrypt`, `GenerateDataKey`, `GenerateDataKeyWithoutPlaintext`, `ReEncryptFrom`, `ReEncryptTo`, `Sign`, `Verify`, `GetPublicKey`, `CreateGrant`, `RetireGrant`, `DescribeKey`, `GenerateDataKeyPair`, or `GenerateDataKeyPairWithoutPlaintext`."
  type        = list
  default     = []
}

variable "retiring_principal" {
  description = "(Optional, Forces new resources) The principal that is given permission to retire the grant by using RetireGrant operation in ARN format. Note that due to eventual consistency issues around IAM principals, terraform's state may not always be refreshed to reflect what is true in AWS."
  type        = string
  default     = null
}

variable "encryption_context_equals" {
  description = "(Optional, Forces new resources) A structure that you can use to allow certain operations in the grant only when the desired encryption context is present. "
  type        = map(string)
  default     = null
}

variable "encryption_context_subset" {
  description = "(Optional, Forces new resources) A structure that you can use to allow certain operations in the grant only when the desired encryption context is present. "
  type        = map(string)
  default     = null
}

variable "grant_creation_tokens" {
  description = "(Optional, Forces new resources) A list of grant tokens to be used when creating the grant."
  type        = list
  default     = []
}

variable "retire_on_delete" {
  description = "(Defaults to false, Forces new resources) If set to false (the default) the grants will be revoked upon deletion, and if set to true the grants will try to be retired upon deletion. Note that retiring grants requires special permissions, hence why we default to revoking grants."
  type        = bool
  default     = false
}