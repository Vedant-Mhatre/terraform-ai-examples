# Terraform AI Examples (AWS)

[![Stars](https://img.shields.io/github/stars/Vedant-Mhatre/terraform-ai-examples?style=social)](https://github.com/Vedant-Mhatre/terraform-ai-examples/stargazers)
[![Examples Quality](https://github.com/Vedant-Mhatre/terraform-ai-examples/actions/workflows/examples-quality.yml/badge.svg)](https://github.com/Vedant-Mhatre/terraform-ai-examples/actions/workflows/examples-quality.yml)
[![Docs Portal](https://img.shields.io/badge/docs-live-0ea5e9)](https://blog.vmhatre.com/terraform-ai-examples/docs/)

Production-style AWS Terraform examples with architecture diagrams, system-design sizing math, incident runbooks, and cost estimation tooling.

If this repository helps your learning or projects, star it: [Star `terraform-ai-examples`](https://github.com/Vedant-Mhatre/terraform-ai-examples).

## Why This Repo (Instead of Just Asking ChatGPT/Claude)

AI assistants generate snippets quickly, but learners and teams usually need more than snippets:
- well-structured, end-to-end example directories
- architecture + code + validation in one place
- system-design sizing math (capacity, latency, backlog, growth)
- incident handling playbooks for failure scenarios
- explicit cost and safety guardrails
- repeatable quality checks in CI

Detailed rationale: [`docs/why-this-repo.md`](docs/why-this-repo.md).

## Transparency Note

I have not yet live-deployed all examples end-to-end myself in AWS.  
Current verification status is tracked here: [`TESTING_STATUS.md`](TESTING_STATUS.md).

## Start In 5 Minutes

1. Open the docs portal: [https://blog.vmhatre.com/terraform-ai-examples/docs/](https://blog.vmhatre.com/terraform-ai-examples/docs/)
2. Run quality checks:

```bash
make validate
```

3. Run a cost sizing estimate (no AWS deployment required):

```bash
python3 scripts/estimate_costs.py --example ecs-gpu-inference-service --tfvars examples/ai/ecs-gpu-inference-service/terraform.tfvars.example
```

## Example Catalog

| Path | Domain | Difficulty | Estimated Cost Risk | Primary Outcome |
| --- | --- | --- | --- | --- |
| `examples/platform/hardened-terraform-state-backend` | Platform | Beginner | Low | Secure remote state + locking baseline |
| `examples/security/cross-account-terraform-deploy-role` | Security | Intermediate | Low | Safe multi-account Terraform delivery |
| `examples/data/event-driven-ingestion-pipeline` | Data | Intermediate | Medium | Async ingestion with DLQ + alarming |
| `examples/ai/ecs-gpu-inference-service` | AI Serving | Advanced | High | GPU inference service on ECS EC2 |
| `examples/ai/sagemaker-distributed-training` | AI Training | Advanced | Very High | Multi-node distributed model training |

## Learning Paths

- Platform Engineer track: state backend -> cross-account role -> ingestion pipeline
- ML Platform track: state backend -> ECS GPU inference -> SageMaker training
- Structured paths: [`docs/learning-paths.md`](docs/learning-paths.md)

## How To Use

1. Pick one example directory.
2. Copy `terraform.tfvars.example` to `terraform.tfvars` where provided.
3. Run:

```bash
terraform init
terraform plan
terraform apply
```

4. Follow `Validation Steps`, `System Design Sizing`, and `Incident Simulation` in each README.

## Docs Portal

- Live portal: [https://blog.vmhatre.com/terraform-ai-examples/docs/](https://blog.vmhatre.com/terraform-ai-examples/docs/)
- Source: `docs/`
- Deployment workflow: `.github/workflows/docs-pages.yml`

## Repo Quality Guardrails

- Structural and Terraform validation: `scripts/validate_examples.sh`
- CI workflow: `.github/workflows/examples-quality.yml`
- Contribution quality bar: [`docs/quality-bar.md`](docs/quality-bar.md)
- Convenience command: `make validate`

## Incident and Cost Tooling

- Incident playbooks: `docs/incidents/`
- Cost estimator script: `scripts/estimate_costs.py`
- Cost estimator guide: [`docs/cost-estimator.md`](docs/cost-estimator.md)
- Sizing formulas cheat sheet: [`docs/sizing-cheatsheet.md`](docs/sizing-cheatsheet.md)

## Growth Assets

- Promotion pack templates: [`docs/promo/launch-pack.md`](docs/promo/launch-pack.md)
- Distribution checklist: [`docs/promo/distribution-checklist.md`](docs/promo/distribution-checklist.md)
- Changelog: [`CHANGELOG.md`](CHANGELOG.md)

## Optional Further Reading

- Teaching playbook (draft guidance): [`docs/teaching-playbook.md`](docs/teaching-playbook.md)
- Production checklist (validate in your environment): [`docs/production-readiness-checklist.md`](docs/production-readiness-checklist.md)

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). New examples should be based on [`examples/_template`](examples/_template).

## License

MIT (`LICENSE`).
