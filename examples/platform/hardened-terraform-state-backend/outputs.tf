output "state_bucket_name" {
  description = "Terraform state bucket name."
  value       = aws_s3_bucket.state.bucket
}

output "dynamodb_lock_table_name" {
  description = "DynamoDB table name used for state locking."
  value       = aws_dynamodb_table.locks.name
}

output "kms_key_arn" {
  description = "KMS key ARN used to encrypt state objects."
  value       = aws_kms_key.state.arn
}

output "backend_hcl_snippet" {
  description = "Paste this into backend config for other stacks."
  value       = <<-EOT
    bucket         = "${aws_s3_bucket.state.bucket}"
    key            = "envs/prod/terraform.tfstate"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.locks.name}"
    encrypt        = true
    kms_key_id     = "${aws_kms_key.state.arn}"
  EOT
}
