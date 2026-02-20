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

## System Design Sizing

Assume:
- peak ingest rate (`lambda`) = 500 events/sec
- average steady ingest = 300 events/sec
- average Lambda processing time = 300 ms
- effective per-worker service rate (`mu`) ~= `1 / 0.3` = `3.33 events/sec`

Concurrency math:
- required concurrency for peak ~= `lambda / mu` = `500 / 3.33` ~= `150`
- if actual concurrency is 100, max throughput ~= `100 * 3.33` ~= `333 events/sec`

Backlog growth math:
- backlog growth/sec = `lambda - throughput` = `500 - 333 = 167 events/sec`
- one hour backlog at that deficit ~= `167 * 3600` ~= `601,200 events`

Drain-time math:
- if backlog is 601,200 and post-peak throughput advantage is 100 events/sec
- drain time ~= `601,200 / 100` ~= `6,012 sec` (~100 min)

Storage growth intuition:
- if average raw object is 200 KB and 5M events/month
- raw bucket growth ~= `5,000,000 * 200 KB` ~= `953 GB/month` (before compression/lifecycle)

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
