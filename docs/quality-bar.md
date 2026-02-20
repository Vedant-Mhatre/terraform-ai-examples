# Example Quality Bar

A new or updated example should meet all items below.

## Required Files

- `README.md`
- `architecture.svg`
- `versions.tf`
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars.example`

## Required README Sections

- `Architecture`
- `What You'll Learn`
- `Real-World Use Case`
- `Usage`
- `Validation Steps`
- `Cost and Safety`
- `Cleanup`
- `Next Improvements`

## Engineering Standards

- Use modern provider and Terraform version constraints.
- Avoid hardcoded secrets and avoid defaulting to expensive resources unnecessarily.
- Include at least one operational safeguard (for example: DLQ, alarms, lock table, or policy constraints).
- Document meaningful failure modes and mitigation guidance.

## Validation

Run:

```bash
scripts/validate_examples.sh
```

CI enforces baseline checks via `.github/workflows/examples-quality.yml`.
