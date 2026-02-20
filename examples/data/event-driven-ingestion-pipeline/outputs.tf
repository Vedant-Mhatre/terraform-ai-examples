output "raw_bucket_name" {
  description = "Bucket where producers upload raw data files."
  value       = aws_s3_bucket.raw.bucket
}

output "processed_bucket_name" {
  description = "Bucket where Lambda writes processed payloads."
  value       = aws_s3_bucket.processed.bucket
}

output "events_queue_url" {
  description = "SQS queue URL for raw object events."
  value       = aws_sqs_queue.events.id
}

output "dlq_queue_url" {
  description = "Dead-letter queue URL for failed events."
  value       = aws_sqs_queue.dlq.id
}

output "processor_lambda_name" {
  description = "Lambda function that processes ingestion events."
  value       = aws_lambda_function.processor.function_name
}
