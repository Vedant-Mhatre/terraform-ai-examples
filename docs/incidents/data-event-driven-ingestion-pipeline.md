# Incident Runbook: Event-Driven Ingestion Pipeline

## Scenario

SQS backlog and DLQ messages grow quickly. New data files arrive in raw bucket, but processed bucket output lags significantly.

## Blast Radius

- Data freshness SLO is violated.
- Downstream analytics/ML features operate on stale data.
- Potential data loss risk if retries are exhausted without replay strategy.

## Detection Signals

- SQS `ApproximateAgeOfOldestMessage` increasing.
- DLQ visible messages > 0 alarm firing.
- Lambda error/throttle rates increasing.

## Triage Steps (0-15 min)

1. Check Lambda error logs and identify dominant failure class.
2. Confirm queue depth, receive count, and DLQ movement.
3. Validate recent deploys to handler logic and IAM policies.
4. Confirm raw bucket notifications still target the expected queue.

## Stabilization Actions (15-60 min)

1. Increase Lambda concurrency/memory if bottleneck is compute-bound.
2. Pause noisy producers if ingestion storm is unbounded.
3. Hotfix processor for malformed payload handling and deploy quickly.
4. Replay DLQ messages after bug fix and verify idempotency.

## Root Cause Patterns

- Non-idempotent processor logic causing repeated failures.
- Poison payloads not quarantined separately.
- Timeout/memory settings too low for payload size distribution.
- Queue visibility timeout misaligned with handler runtime.

## Permanent Fixes

- Add schema validation + quarantine bucket path.
- Add age-of-oldest-message and failure-rate alarms.
- Add load tests with realistic burst patterns.
- Add replay tooling with safety checks.
