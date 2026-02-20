output "sagemaker_execution_role_arn" {
  description = "IAM role used by SageMaker training jobs."
  value       = aws_iam_role.sagemaker_execution.arn
}

output "artifact_bucket_name" {
  description = "S3 bucket where model output and checkpoints are stored."
  value       = aws_s3_bucket.artifacts.bucket
}

output "pipeline_name" {
  description = "SageMaker pipeline name for distributed training."
  value       = aws_sagemaker_pipeline.distributed_training.pipeline_name
}

output "start_execution_command" {
  description = "Run this command to trigger a pipeline execution."
  value       = "aws sagemaker start-pipeline-execution --pipeline-name ${aws_sagemaker_pipeline.distributed_training.pipeline_name}"
}
