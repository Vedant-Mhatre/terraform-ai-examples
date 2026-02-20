variable "region" {
  description = "AWS region for this stack."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag (for example: dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Prefix used for resource names."
  type        = string
  default     = "fm-train"
}

variable "vpc_id" {
  description = "Existing VPC ID where SageMaker ENIs should be attached."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the training job."
  type        = list(string)
}

variable "training_image_uri" {
  description = "ECR URI for the training container image."
  type        = string
}

variable "s3_training_data_uri" {
  description = "S3 prefix containing training data. Example: s3://my-datasets/fm/train/"
  type        = string
}

variable "training_job_name" {
  description = "Explicit SageMaker training job name."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "GPU instance type for training."
  type        = string
  default     = "ml.g5.12xlarge"
}

variable "instance_count" {
  description = "Number of nodes for distributed training."
  type        = number
  default     = 2
}

variable "volume_size_gb" {
  description = "EBS volume per training instance (GB)."
  type        = number
  default     = 400
}

variable "max_runtime_seconds" {
  description = "Hard timeout for the training job runtime."
  type        = number
  default     = 14400
}

variable "use_spot_instances" {
  description = "Whether to use managed spot training for cost reduction."
  type        = bool
  default     = true
}

variable "max_wait_seconds" {
  description = "Total wait time including spot interruptions."
  type        = number
  default     = 21600
}

variable "enable_training_job" {
  description = "Set true to create/launch the training job. Default false avoids accidental spend."
  type        = bool
  default     = false
}

variable "hyperparameters" {
  description = "Hyperparameters passed to the container."
  type        = map(string)
  default = {
    epochs            = "3"
    per_device_bs     = "8"
    gradient_accum    = "4"
    learning_rate     = "2e-5"
    save_steps        = "500"
    logging_steps     = "50"
  }
}

variable "model_artifact_bucket_name" {
  description = "Optional pre-existing bucket name for model output/checkpoints. Leave empty to create one."
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "Optional KMS key ARN for output encryption."
  type        = string
  default     = ""
}
