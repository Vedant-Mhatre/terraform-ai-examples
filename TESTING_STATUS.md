# Testing Status

Last updated: February 20, 2026

This file tracks what has been validated by the maintainer.

## Meaning of Status

- `Static validation`: `terraform init -backend=false` + `terraform validate` passed.
- `Live deployment by maintainer`: example has been actually applied in AWS and verified end-to-end by the maintainer.

## Current Status

| Example | Static validation | Live deployment by maintainer | Notes |
| --- | --- | --- | --- |
| `examples/platform/hardened-terraform-state-backend` | Yes | No (in progress) | Use as learning/reference pattern; validate in your account before production. |
| `examples/security/cross-account-terraform-deploy-role` | Yes | No (in progress) | IAM trust and external ID behavior should be tested in your org setup. |
| `examples/data/event-driven-ingestion-pipeline` | Yes | No (in progress) | Event volume and retries depend on your payload profile. |
| `examples/ai/ecs-gpu-inference-service` | Yes | No (in progress) | GPU capacity/quotas and startup latency vary by account/region. |
| `examples/ai/sagemaker-distributed-training` | Yes | No (in progress) | Training runtime/cost highly workload-dependent. |

## Maintainer Plan

1. Deploy cheapest safe configuration for each example in a dedicated AWS account.
2. Capture evidence (commands, outputs, screenshots, key metrics).
3. Promote each example row from `No` to `Yes` only after full end-to-end verification.
4. Document gotchas and exact cost observed for each tested run.
