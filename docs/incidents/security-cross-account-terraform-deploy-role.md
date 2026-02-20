# Incident Runbook: Cross-Account Deploy Role

## Scenario

Deployment pipeline suddenly fails to assume target-account role, or unexpected principal can assume role due to trust-policy drift.

## Blast Radius

- Planned releases blocked across one or more accounts.
- Security exposure if unauthorized principal assumption succeeds.
- Increased operational risk from emergency credential workarounds.

## Detection Signals

- STS `AccessDenied` errors from CI.
- CloudTrail events show assume-role attempts from unknown principals.
- Unexpected success/failure pattern after IAM changes.

## Triage Steps (0-15 min)

1. Check CloudTrail for failed/successful assume-role events.
2. Inspect current trust policy and compare with known-good baseline.
3. Verify `external_id` value used by CI still matches role condition.
4. Confirm CI principal ARN has not changed during pipeline migration.

## Stabilization Actions (15-60 min)

1. Restore last known-good trust policy.
2. Rotate and re-sync external ID between CI and target account.
3. Temporarily disable suspicious principal access while investigating.
4. Validate assumption from approved principal with explicit STS call.

## Root Cause Patterns

- Principal ARN changes after CI platform migration.
- External ID drift between secrets manager and IAM condition.
- Broad trust policy edits for debugging not reverted.
- Overly restrictive scoped policy denies required actions.

## Permanent Fixes

- Manage trust policy as code only (no console edits).
- Add automated checks for trusted principal + external ID constraints.
- Alert on assume-role attempts by unknown principals.
- Implement periodic access review for deploy roles.
