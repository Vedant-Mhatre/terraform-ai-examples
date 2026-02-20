variable "region" {
  description = "AWS region for backend resources."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Prefix for state backend resource names."
  type        = string
  default     = "terraform-state"
}

variable "force_destroy" {
  description = "Allow destroying bucket with objects. Keep false in real environments."
  type        = bool
  default     = false
}

variable "state_key_arn_principals" {
  description = "IAM principal ARNs allowed to use this KMS key for Terraform state encryption."
  type        = list(string)
  default     = []
}

variable "lock_table_name" {
  description = "Optional explicit DynamoDB table name for state locking."
  type        = string
  default     = ""
}
