# Event-Driven Ingestion Pipeline

Build a buffered ingestion pipeline with S3 events, SQS decoupling, Lambda processing, DLQ handling, and failure alarming.

## Architecture

![Event Driven Ingestion Architecture](./architecture.svg)

## What You'll Learn

- How to decouple ingestion with queue-based buffering.
- How to design retry and DLQ behavior for safer async processing.
- How to add operational visibility with targeted CloudWatch alarms.

## Real-World Use Case

Used in data platforms where producers send files in unpredictable bursts. This pattern smooths spikes, isolates failures, and preserves ingest durability.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Validation Steps

1. Confirm outputs:

```bash
terraform output raw_bucket_name
terraform output processed_bucket_name
terraform output processor_lambda_name
```

2. Upload a sample object to the raw bucket:

```bash
aws s3 cp ./sample.json "s3://$(terraform output -raw raw_bucket_name)/events/sample.json"
```

3. Validate a processed payload appears in the processed bucket under `processed/`.

4. Simulate a failure path and verify DLQ/alarm behavior.

## Incident Simulation

- Runbook: `../../../docs/incidents/data-event-driven-ingestion-pipeline.md`

## Cost and Safety

- Estimated cost risk: medium (cost scales with event volume and Lambda invocations).
- Main cost drivers: Lambda duration, SQS requests, and S3 storage growth.
- Built-in guardrails: DLQ, visibility timeout sizing, optional alarm topic.

## Cleanup

```bash
terraform destroy
```

## Next Improvements

- Add schema validation and quarantined object bucket for invalid payloads.
- Add idempotency keys to avoid duplicate downstream processing.
- Add SQS age-of-oldest-message alarm for backlog detection.
