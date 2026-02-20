# Cross-Account Terraform Deploy Role

Provision a target-account IAM role that centralized CI/CD can assume safely for Terraform deployments.

## Architecture

![Cross Account Deploy Role Architecture](./architecture.svg)

## What You'll Learn

- How to structure cross-account Terraform trust relationships.
- How to enforce `external_id` and strict trusted principals.
- How to choose between broad admin and scoped policy modes.

## Real-World Use Case

Common in organizations with centralized CI but isolated workload accounts. This approach lets platform teams govern deployment access while keeping account boundaries clear.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Validation Steps

1. Confirm role output:

```bash
terraform output deploy_role_arn
```

2. Review generated provider assume-role snippet:

```bash
terraform output assume_role_snippet
```

3. From the trusted account, call STS assume-role with the correct external ID and confirm access works.

## System Design Sizing

Assume:
- 10 deployment pipelines
- each runs 30 times/day across environments
- one STS assume-role call per run

STS call volume:
- daily assume-role calls = `10 * 30 = 300`
- monthly calls (~30d) = `300 * 30 = 9,000`

Session-duration tradeoff:
- current max session duration default in this example: 1 hour
- shorter sessions reduce credential blast window but increase refresh frequency

Blast-radius sizing:
- risk grows with number of trusted principals and number of target accounts
- rough exposure score (simplified) ~= `trusted_principals * target_accounts`
- keep trusted principal set minimal and scoped per environment boundary

Failure-budget style check:
- if deployment SLO allows 99.9% successful assumes, monthly error budget ~= `9,000 * 0.001 = 9 failed assumptions`
- alert if failed assumes exceed this threshold in a month

## Incident Simulation

- Runbook: `../../../docs/incidents/security-cross-account-terraform-deploy-role.md`

## Cost and Safety

- Estimated cost risk: low (IAM-only pattern).
- Main risk is security misconfiguration, not infrastructure spend.
- Built-in guardrails: explicit trusted principals, mandatory external ID, optional scoped policy mode.

## Cleanup

```bash
terraform destroy
```

## Next Improvements

- Add policy boundaries and session tag enforcement.
- Add CloudTrail detection for unexpected assume-role attempts.
- Restrict scoped actions further by resource ARNs per environment.
