# Terraform AI Examples

Opinionated AWS Terraform examples designed for three outcomes:
- learn core infrastructure patterns quickly
- teach teams with structured material
- adapt examples into real production stacks

## Start Here

1. Read [Why This Repo](why-this-repo.md).
2. Pick a path in [Learning Paths](learning-paths.md).
3. Run one example and complete its `Validation Steps`.
4. Review its corresponding incident runbook in [Incident Runbooks](incidents/ai-ecs-gpu-inference-service.md).

## What Makes This Repo Different

- Full example directories, not snippet-only answers.
- Architecture diagrams, validation steps, and cleanup procedures.
- Incident playbooks for likely real-world failures.
- Cost estimation tooling and spend guardrails.
- CI checks to keep quality from drifting.

## Practical Disclaimer

This repository is designed as practical learning material and starting points. Validate every pattern in your own AWS account and constraints before production use.

## Quick Commands

```bash
make validate
python3 scripts/estimate_costs.py --help
```

## Related Docs

- [Example Catalog](example-catalog.md)
- [Cost Estimation Guide](cost-estimator.md)
- [Production Readiness Checklist](production-readiness-checklist.md)
