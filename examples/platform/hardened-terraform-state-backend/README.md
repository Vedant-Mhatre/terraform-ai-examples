# Hardened Terraform State Backend

Create a secure shared backend for Terraform state with encryption, locking, versioning, and transport enforcement.

## Architecture

![Terraform State Backend Architecture](./architecture.svg)

## What You'll Learn

- How to build a production-grade remote state backend on AWS.
- Why KMS + versioning + lock tables matter for team workflows.
- How to produce backend config outputs for downstream stacks.

## Real-World Use Case

Every multi-person Terraform setup needs safe shared state. This pattern is typically the first platform baseline teams establish before scaling IaC across environments and accounts.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Validation Steps

1. Confirm state primitives were created:

```bash
terraform output state_bucket_name
terraform output dynamodb_lock_table_name
terraform output kms_key_arn
```

2. Inspect generated backend snippet:

```bash
terraform output backend_hcl_snippet
```

3. Attempt a second Terraform operation concurrently in another terminal to verify locking behavior.

## System Design Sizing

Assume:
- 5 Terraform stacks use this backend
- each stack runs 20 applies/day
- average state snapshot size = 2 MB
- each apply creates one new versioned state object

Request and growth math:
- applies/day total = `5 * 20 = 100`
- applies/month (~30d) = `100 * 30 = 3,000`
- new state data/month ~= `3,000 * 2 MB` ~= `6,000 MB` (~5.86 GB) before lifecycle pruning

Locking contention intuition:
- if average lock hold is 45 sec and apply starts are bursty
- shared single-key pipelines can queue quickly; separate keys/workspaces reduce contention sharply

Recovery sizing:
- with versioning enabled, rollback RTO is typically dominated by operator response time, not storage recovery
- target operational RTO for bad state writes: <= 15 minutes with clear runbook ownership

## Incident Simulation

- Runbook: `../../../docs/incidents/platform-hardened-terraform-state-backend.md`

## Cost and Safety

- Estimated cost risk: low.
- Main cost drivers: KMS requests and S3 object/version growth over time.
- Built-in guardrails: TLS-only S3 policy, versioning, lock table, KMS rotation.

## Cleanup

```bash
terraform destroy
```

Keep `force_destroy = false` for non-ephemeral environments to avoid accidental state loss.

## Next Improvements

- Add cross-region replication for state disaster recovery.
- Add IAM policy module for strict backend access boundaries.
- Add CloudTrail detection for unauthorized state access attempts.
