# Cross-Account Terraform Deploy Role

![Cross-Account Deploy Role](../assets/diagrams/cross-account-terraform-deploy-role.svg)

## Problem It Solves

Let centralized CI/CD deploy into target accounts without sharing long-lived credentials.

## Why Teams Use It

- Clean separation between build and workload accounts.
- Better auditability and blast-radius control.
- Explicit trust constraints with external IDs.

## Primary Tradeoffs

- IAM policy scoping can be complex.
- Misconfigured trust can block deployments or overexpose access.

## Source

- Terraform: `examples/security/cross-account-terraform-deploy-role`
- Incident runbook: [Cross-Account Role Incident](../incidents/security-cross-account-terraform-deploy-role.md)

## Validation Focus

- Assume-role success from trusted principal
- Assume-role denial from untrusted principal
- External ID enforcement
