variable "region" {
  description = "AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment tag, for example dev/staging/prod."
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Resource name prefix."
  type        = string
  default     = "gpu-infer"
}

variable "vpc_id" {
  description = "Existing VPC ID for ECS and ALB."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnets for ECS GPU instances/tasks."
  type        = list(string)
}

variable "container_image" {
  description = "Inference image URI (typically ECR)."
  type        = string
}

variable "container_port" {
  description = "Application port exposed by the container."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "ALB health check endpoint path."
  type        = string
  default     = "/healthz"
}

variable "alb_allowed_cidrs" {
  description = "CIDRs allowed to hit the public ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN. If set, ALB serves HTTPS and HTTP redirects to HTTPS."
  type        = string
  default     = ""
}

variable "alb_ssl_policy" {
  description = "SSL policy for ALB HTTPS listener when certificate is configured."
  type        = string
  default     = "ELBSecurityPolicy-FS-2018-06"
}

variable "gpu_instance_type" {
  description = "EC2 instance type for GPU worker nodes."
  type        = string
  default     = "g5.xlarge"
}

variable "gpus_per_task" {
  description = "Number of GPUs reserved per task container."
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "Task CPU units."
  type        = number
  default     = 4096
}

variable "task_memory" {
  description = "Task memory (MiB)."
  type        = number
  default     = 16384
}

variable "asg_min_size" {
  description = "ASG minimum size for GPU hosts."
  type        = number
  default     = 1
}

variable "asg_desired_size" {
  description = "ASG desired size for GPU hosts."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "ASG maximum size for GPU hosts."
  type        = number
  default     = 4
}

variable "service_desired_count" {
  description = "Initial ECS service task count."
  type        = number
  default     = 1
}

variable "service_min_count" {
  description = "ECS service minimum tasks for autoscaling."
  type        = number
  default     = 1
}

variable "service_max_count" {
  description = "ECS service maximum tasks for autoscaling."
  type        = number
  default     = 8
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period."
  type        = number
  default     = 30
}

variable "cpu_target_utilization" {
  description = "Target CPU utilization for ECS service autoscaling."
  type        = number
  default     = 60
}

variable "model_bucket_arn" {
  description = "Optional model bucket ARN readable by task role."
  type        = string
  default     = ""
}
