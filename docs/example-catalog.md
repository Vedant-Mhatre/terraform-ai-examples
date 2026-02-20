# Example Catalog

## Platform

### Hardened Terraform State Backend
- Source: `examples/platform/hardened-terraform-state-backend`
- Focus: S3 state encryption, lock table, TLS enforcement
- Difficulty: Beginner
- Cost risk: Low
- Incident runbook: [State Backend Incident](incidents/platform-hardened-terraform-state-backend.md)

### Cross-Account Terraform Deploy Role
- Source: `examples/security/cross-account-terraform-deploy-role`
- Focus: multi-account trust, external IDs, scoped deployment policy
- Difficulty: Intermediate
- Cost risk: Low
- Incident runbook: [Cross-Account Role Incident](incidents/security-cross-account-terraform-deploy-role.md)

## Data

### Event-Driven Ingestion Pipeline
- Source: `examples/data/event-driven-ingestion-pipeline`
- Focus: S3 -> SQS -> Lambda with DLQ and alarming
- Difficulty: Intermediate
- Cost risk: Medium
- Incident runbook: [Ingestion Pipeline Incident](incidents/data-event-driven-ingestion-pipeline.md)

## AI

### ECS GPU Inference Service
- Source: `examples/ai/ecs-gpu-inference-service`
- Focus: GPU hosts on ECS EC2, ALB, autoscaling
- Difficulty: Advanced
- Cost risk: High
- Incident runbook: [ECS GPU Incident](incidents/ai-ecs-gpu-inference-service.md)

### SageMaker Distributed Training
- Source: `examples/ai/sagemaker-distributed-training`
- Focus: distributed training pipeline, spot strategy, checkpointing
- Difficulty: Advanced
- Cost risk: Very High
- Incident runbook: [SageMaker Incident](incidents/ai-sagemaker-distributed-training.md)

## Suggested Execution Order

1. `hardened-terraform-state-backend`
2. `cross-account-terraform-deploy-role`
3. `event-driven-ingestion-pipeline`
4. `ecs-gpu-inference-service`
5. `sagemaker-distributed-training`
