variable "region" {
  description = "AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Prefix for all resources."
  type        = string
  default     = "ingestion"
}

variable "alarm_topic_arn" {
  description = "Optional SNS topic ARN for DLQ alarms."
  type        = string
  default     = ""
}

variable "lambda_timeout_seconds" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 60
}

variable "lambda_memory_mb" {
  description = "Lambda memory allocation in MB."
  type        = number
  default     = 512
}

variable "raw_bucket_force_destroy" {
  description = "Allow destroy with objects for raw bucket (use true only for ephemeral envs)."
  type        = bool
  default     = false
}

variable "processed_bucket_force_destroy" {
  description = "Allow destroy with objects for processed bucket (use true only for ephemeral envs)."
  type        = bool
  default     = false
}
