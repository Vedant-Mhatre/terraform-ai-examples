variable "region" {
  description = "AWS region for IAM resources (IAM is global but provider still needs a region)."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "prod"
}

variable "name_prefix" {
  description = "Prefix for IAM role and policy names."
  type        = string
  default     = "terraform-deploy"
}

variable "trusted_principal_arns" {
  description = "IAM principal ARNs (usually CI/CD roles in another account) allowed to assume this deploy role."
  type        = list(string)
}

variable "external_id" {
  description = "External ID required when assuming the role."
  type        = string
}

variable "max_session_duration_seconds" {
  description = "Maximum role session duration in seconds."
  type        = number
  default     = 3600
}

variable "allow_admin_access" {
  description = "Set true to attach AdministratorAccess. Keep false for scoped policy mode."
  type        = bool
  default     = false
}

variable "state_bucket_arn" {
  description = "Optional Terraform state bucket ARN to include explicit access for."
  type        = string
  default     = ""
}

variable "lock_table_arn" {
  description = "Optional DynamoDB lock table ARN to include explicit access for."
  type        = string
  default     = ""
}
