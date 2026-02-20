# Terraform AI Examples (AWS)

Production-style Terraform examples for AWS workloads that teams actually run, including GPU-heavy AI training/inference and non-AI infrastructure patterns.

## What Changed

This repository was rebuilt to remove outdated VPC/EC2 tutorial stacks and replace them with practical scenarios focused on:
- security baselines
- cost-aware architecture
- platform operations
- AI/ML GPU workloads

## Repository Layout

| Path | Use Case |
| --- | --- |
| `examples/ai/sagemaker-distributed-training` | Multi-node GPU training with SageMaker, spot support, checkpointing, VPC isolation |
| `examples/ai/ecs-gpu-inference-service` | ECS on EC2 GPU inference service behind ALB with autoscaling |
| `examples/platform/hardened-terraform-state-backend` | Encrypted and locked S3 + DynamoDB backend for Terraform state |
| `examples/data/event-driven-ingestion-pipeline` | S3 -> SQS -> Lambda pipeline with DLQ and operational alarms |
| `examples/security/cross-account-terraform-deploy-role` | Cross-account IAM role pattern for CI/CD Terraform deployments |

## Quick Start

1. Pick one example directory.
2. Copy `terraform.tfvars.example` to `terraform.tfvars` where provided.
3. Run:

```bash
terraform init
terraform plan
terraform apply
```

## Guardrails

- AI examples can be expensive (especially GPU instance families like `g5`, `p4`, `p5`).
- Most examples include controls (min/max scaling, explicit variables, optional execution switches).
- Always start with `terraform plan` and review cost impact before `apply`.

## Recommended Usage Pattern

- Keep each example in its own state file/workspace.
- Use the `hardened-terraform-state-backend` example first, then migrate other examples to remote state.
- Wire these examples into a CI pipeline using the `cross-account-terraform-deploy-role` pattern.

## License

MIT (`LICENSE`).
