## 1.2.0 (October 11, 2024)

FEATURE:
  * Add functionality to create KMS Grants

## 1.2.0 (September 28, 2022)

CHORE:
  * Simplified Terraform example for IAM policy
  * Improved README
  * Improved Terragrunt & Terraform basic and complete examples

ENHANCEMENT: (BREAKING CHANGES!!)
  * Set default for `is_enabled` to false so we can create optionally create replicas.
  * Set default for `enable_sops` to false to meet user expectations and norms around added functionality.
  * Renamed variable `enable_sops` to `enable_sops_primary`.
  * Added variable `enable_sops_replica`.

FEATURE:
  * Can create a KMS Key Replica of a multi-region primary key.
  * Can optionally incorporate SOPS file creation with either a replica or primary key.

## 1.1.5 (August 29, 2022)

CHORE:

  * Improved README
  * Improved examples

## 1.1.4 (April 23, 2022)

ENHANCEMENT:

  * Added support for `is_enabled` property.
  * Added support for `bypass_policy_lockout_safety_check` property.

CHORE:

  * Added default KMS policy to example since removing this causes a great risk to losing access to the key [as per this support document](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html).

## 1.1.3 (April 22, 2022)

BUG:

  * Removed lifecycle policy for alias and key as there is no way to paramaterize [this "known limitation" with Terraform. (Issue #22544)](https://github.com/hashicorp/terraform/issues/22544). User can set this outside of the module. (see examples)

## 1.1.2 (April 22, 2022)

BUG:

  * Set default for KMS policy to "" so that a default policy is created if none is provided.

CHORE:
  * Renamed aws_kms_alias property for `name` from "alias" to "name" which is less confusing.

ENHANCEMENT:

  * Improved input tables in README.
  * Added option to disable/enable SOPS file creation.

## 1.1.1 (April 13, 2022)

CHORE:

  * Improved input table in README.
  * Set a data type for the policy variable.
  * Added sops_file provider documentation in README

## 1.1.0 (March 7, 2022)

BREAK/FIX:

  * Added 'type' for tag to be map(string)

ENHANCEMENT:

  * Added customer_master_key_spec input.

CHORE:

  * Updated readme to be more descriptive.
  * Updated examples.

## 1.0.9 (February 24, 2022)

CHORE:

  * Using best practices with resource aliases.

## 1.0.8 (February 11, 2022)

ENHANCEMENT:

  * Improved readme links to examples.

## 1.0.7 (February 11, 2022)

ENHANCEMENT:

  * Improved Terraform & Terragrunt examples.

## 1.0.6 (February 10, 2022)

CHORE:

  * Fix links for examples.

## 1.0.5 (February 10, 2022)

ENHANCEMENT:

  * Add example link for Terragrunt.

## 1.0.4 (February 10, 2022)

ENHANCEMENT:

  * Add latest tag badge to readme.

## 1.0.3 (February 10, 2022)

ENHANCEMENT:

  * Added input for multi-region
  * Added input for key rotation
  * Added input for deletion window
  * Added input for key usage
  * Updated README
  * Updated examples

## 1.0.2 (February 10, 2022)

ENHANCEMENT:

  * Added descriptions to outputs.
  * Updated README

## 1.0.1 (February 10, 2022)

ENHANCEMENT:

  * Updated documentation

## 1.0.0 (February 10, 2022)

INITIAL:

  * Initial module creation

