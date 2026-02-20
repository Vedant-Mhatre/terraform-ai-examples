# SageMaker Distributed Training

![SageMaker Distributed Training](../assets/diagrams/sagemaker-distributed-training.svg)

## Problem It Solves

Manage reproducible distributed training definitions while keeping execution controlled and cost-aware.

## Why Teams Use It

- Need repeatable training definitions in Git.
- Need spot strategy and checkpoint recovery.
- Need private networking and IAM control.

## Primary Tradeoffs

- Training cost can spike quickly with GPU size/count.
- Operational complexity around job tuning and retries.

## Source

- Terraform: `examples/ai/sagemaker-distributed-training`
- Incident runbook: [SageMaker Incident](../incidents/ai-sagemaker-distributed-training.md)

## Validation Focus

- Pipeline creation and execution path
- Checkpoint and artifact output
- Runtime/max-wait guardrails
