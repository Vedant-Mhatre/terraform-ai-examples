# Terraform AI Examples (AWS)

Opinionated, production-style Terraform examples for AWS. Built for engineers who want to learn quickly and still ship patterns that hold up in real environments.

## Why This Repo (Instead of Just Asking ChatGPT/Claude)

AI assistants can generate snippets fast, but they usually miss repository-level quality. This repo is useful because it provides:
- complete, runnable example directories (not isolated snippets)
- architecture diagrams + Terraform code + usage docs together
- explicit cost, risk, and operational guardrails
- teaching-focused structure: learning goals, validation steps, and extensions
- CI quality checks so examples stay maintainable over time

Detailed rationale: [`docs/why-this-repo.md`](docs/why-this-repo.md).

## Docs Portal

- GitHub Pages portal: [https://vedant-mhatre.github.io/terraform-ai-examples/](https://vedant-mhatre.github.io/terraform-ai-examples/)
- Source files for the portal live in `docs/` and are deployed by `.github/workflows/docs-pages.yml`.

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
- Teaching/workshop track and weekly path planning: [`docs/learning-paths.md`](docs/learning-paths.md)

## How To Use

1. Pick one example directory.
2. Copy `terraform.tfvars.example` to `terraform.tfvars` where provided.
3. Run:

```bash
terraform init
terraform plan
terraform apply
```

4. Follow each example README’s `Validation Steps` section before moving on.

## Repo Quality Guardrails

- Structural checks and optional Terraform validation: `scripts/validate_examples.sh`
- CI workflow runs quality checks on push/PR: `.github/workflows/examples-quality.yml`
- Contribution quality bar: [`docs/quality-bar.md`](docs/quality-bar.md)
- Convenience command: `make validate`

## Incident and Cost Tooling

- Incident playbooks: `docs/incidents/` (one runbook per example)
- Cost estimator script: `scripts/estimate_costs.py`
- Cost estimation guide: [`docs/cost-estimator.md`](docs/cost-estimator.md)

## For Instructors / Team Leads

- Workshop-ready guide: [`docs/teaching-playbook.md`](docs/teaching-playbook.md)
- Production hardening checklist: [`docs/production-readiness-checklist.md`](docs/production-readiness-checklist.md)

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). New examples should be based on [`examples/_template`](examples/_template).

## License

MIT (`LICENSE`).
