output "sagemaker_execution_role_arn" {
  description = "IAM role used by SageMaker training jobs."
  value       = aws_iam_role.sagemaker_execution.arn
}

output "artifact_bucket_name" {
  description = "S3 bucket where model output and checkpoints are stored."
  value       = aws_s3_bucket.artifacts.bucket
}

output "training_job_name" {
  description = "Training job name (when enabled)."
  value       = var.enable_training_job ? aws_sagemaker_training_job.distributed[0].name : local.computed_job_name
}
