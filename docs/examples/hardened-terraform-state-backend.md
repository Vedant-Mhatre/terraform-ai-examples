# Hardened Terraform State Backend

![Hardened State Backend](../assets/diagrams/hardened-terraform-state-backend.svg)

## Problem It Solves

Provide a safe shared Terraform backend for teams, with encryption, lock protection, and transport controls.

## Why Teams Use It

- Avoid state corruption from concurrent writes.
- Improve confidentiality/integrity of state data.
- Standardize backend config across stacks.

## Primary Tradeoffs

- Requires up-front platform setup before feature stacks.
- Needs governance to prevent over-broad state access.

## Source

- Terraform: `examples/platform/hardened-terraform-state-backend`
- Incident runbook: [State Backend Incident](../incidents/platform-hardened-terraform-state-backend.md)

## Validation Focus

- Locking behavior under concurrent operations
- KMS and bucket security controls
- Backend snippet consumption by other stacks
