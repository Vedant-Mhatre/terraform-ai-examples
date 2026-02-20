# Cost Estimator

This repo includes a simple monthly cost estimator to help learners compare variable choices before deployment.

## Why It Exists

Cloud pricing changes often and varies by region/discounts. The script is not a billing source of truth. It is a planning aid that helps answer:
- "Which variables drive most of the cost?"
- "What happens if I scale this up/down?"
- "Is this safe for dev vs prod budgets?"

## Script

- Path: `scripts/estimate_costs.py`
- Command:

```bash
python3 scripts/estimate_costs.py --example ecs-gpu-inference-service --tfvars examples/ai/ecs-gpu-inference-service/terraform.tfvars.example
```

## Supported Examples

- `ecs-gpu-inference-service`
- `sagemaker-distributed-training`
- `event-driven-ingestion-pipeline`
- `hardened-terraform-state-backend`
- `cross-account-terraform-deploy-role`

## Useful Flags

```bash
# Override assumed run-hours for training jobs
python3 scripts/estimate_costs.py \
  --example sagemaker-distributed-training \
  --tfvars examples/ai/sagemaker-distributed-training/terraform.tfvars.example \
  --training-hours-per-month 120

# Override event volume assumptions
python3 scripts/estimate_costs.py \
  --example event-driven-ingestion-pipeline \
  --tfvars examples/data/event-driven-ingestion-pipeline/terraform.tfvars.example \
  --events-per-month 5000000
```

## Recommendation

Use the script for early planning, then validate with AWS Pricing Calculator for final budget decisions.
