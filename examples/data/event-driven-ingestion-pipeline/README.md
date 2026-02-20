# Event-Driven Ingestion Pipeline

This example creates an ingestion path commonly used in data platforms:
- producers write to a raw S3 bucket
- S3 events fan into SQS
- Lambda processes events asynchronously
- failures land in DLQ with CloudWatch alarming

## Why This Is Useful

This pattern absorbs producer spikes, isolates retry behavior, and gives clear operational failure handling.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Upload a file into the raw bucket and validate that processed metadata appears in the processed bucket.

## Notes

- Replace the sample Lambda code with your transform/validation logic.
- Wire `alarm_topic_arn` to PagerDuty/Slack SNS integration for production.
