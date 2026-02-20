# System Design Sizing Cheatsheet

Use these formulas to reason about capacity before changing Terraform variables.

## Core Formulas

- Throughput capacity: `capacity_rps = workers * rps_per_worker`
- Required workers: `workers = ceil(target_rps / rps_per_worker)`
- Backlog growth: `growth_per_sec = arrival_rate - service_rate`
- Drain time: `drain_seconds = backlog / (service_rate - arrival_rate_after_peak)`
- Monthly storage growth: `growth_bytes = events_per_month * avg_payload_bytes`
- Error budget count: `allowed_failures = total_requests * (1 - SLO)`

## Example Mapping

### ECS GPU Inference

- `workers` => ECS tasks
- `rps_per_worker` => requests per task at target GPU utilization
- `workers` must fit GPU hosts: `hosts >= ceil((workers * gpus_per_task)/gpus_per_host)`

### SageMaker Distributed Training

- Training instance-hours/run: `instance_count * run_hours`
- Monthly instance-hours: `instance_hours_per_run * runs_per_month`
- Compute budget estimate: `effective_hourly * monthly_instance_hours`

### Event-Driven Ingestion

- Service rate ~= `concurrency / avg_processing_seconds`
- If `arrival_rate > service_rate`, queue backlog grows linearly
- Tune concurrency/timeouts to keep `ApproximateAgeOfOldestMessage` bounded

### Terraform State Backend

- New state data/month ~= `applies_per_month * avg_state_size`
- Lock contention risk increases with overlapping applies on same state key

### Cross-Account Deploy Role

- STS calls/month ~= `pipelines * runs_per_day * 30`
- Error budget for assume-role failures: `calls_per_month * (1 - success_slo)`

## Recommendation

Treat these calculations as first-pass design checks, then validate with real metrics after deployment.
