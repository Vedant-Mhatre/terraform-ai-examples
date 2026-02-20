# Incident Runbook: Hardened Terraform State Backend

## Scenario

Terraform operations fail with lock contention or state read/write access errors after IAM/backend changes.

## Blast Radius

- Infrastructure deployment pipeline blocks across multiple teams.
- Risk of manual state surgery if lock handling is mishandled.
- Potential drift if teams bypass remote state controls.

## Detection Signals

- `Error acquiring the state lock` during plan/apply.
- AccessDenied on S3 state objects or DynamoDB lock table.
- Sudden increase in failed CI Terraform jobs.

## Triage Steps (0-15 min)

1. Identify whether issue is lock contention vs permission failure.
2. Inspect DynamoDB lock item and confirm active owner/process.
3. Validate recent IAM/KMS policy changes affecting backend access.
4. Confirm state bucket and lock table names still match backend config.

## Stabilization Actions (15-60 min)

1. If stale lock confirmed, release lock carefully with team coordination.
2. Roll back problematic IAM/KMS policy changes.
3. Pause concurrent pipelines touching the same state workspace.
4. Validate backend snippet consistency across affected repositories.

## Root Cause Patterns

- Interrupted Terraform process leaves stale lock.
- Over-scoped policy refactor accidentally removes backend permissions.
- Multiple environments share same backend key path.
- Manual edits to backend config cause mismatch.

## Permanent Fixes

- Enforce unique `key` per environment/workspace.
- Add policy tests for backend access in CI.
- Add lock timeout/retry guidance in team runbooks.
- Add alerting on repeated lock failures.
