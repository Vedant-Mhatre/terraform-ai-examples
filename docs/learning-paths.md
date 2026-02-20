# Learning Paths

## Path 1: Platform Fundamentals (Recommended Start)

Goal: Build foundational Terraform habits that reduce real-world incidents.

1. `examples/platform/hardened-terraform-state-backend`
2. `examples/security/cross-account-terraform-deploy-role`
3. `examples/data/event-driven-ingestion-pipeline`

Expected outcomes:
- Understand remote state safety and locking.
- Ship Terraform across multiple accounts safely.
- Build event-driven systems with failure handling and alerting.

## Path 2: ML Platform / AI Infra

Goal: Move from secure baseline to real AI workload patterns.

1. `examples/platform/hardened-terraform-state-backend`
2. `examples/ai/ecs-gpu-inference-service`
3. `examples/ai/sagemaker-distributed-training`

Expected outcomes:
- Run GPU-backed inference services with controlled autoscaling.
- Set up distributed training jobs with spot and checkpointing.
- Understand where cost and reliability risks appear in AI infra.

## Suggested 4-Week Schedule

- Week 1: State backend + cross-account role
- Week 2: Ingestion pipeline + ops checks
- Week 3: GPU inference service
- Week 4: SageMaker distributed training + cost optimization review

## Study Method That Works

For each example:
1. Read `What You'll Learn` and architecture.
2. Run `terraform plan` and predict key resources before apply.
3. Apply and execute the README validation steps.
4. Tear down and document one production hardening improvement.
