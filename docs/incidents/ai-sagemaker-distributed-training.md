# Incident Runbook: SageMaker Distributed Training

## Scenario

Pipeline execution starts but training fails repeatedly with intermittent interruption or timeout; checkpoints are missing/incomplete and reruns restart from scratch.

## Blast Radius

- Missed model delivery timeline.
- Increased spend due to repeated partial runs.
- Experiment reproducibility becomes unreliable.

## Detection Signals

- Pipeline execution status `Failed`.
- Training logs show repeated interruption without successful checkpoint writes.
- Artifact bucket lacks recent checkpoint/object growth.

## Triage Steps (0-15 min)

1. Inspect SageMaker pipeline execution and failed step details.
2. Check CloudWatch logs for training container errors.
3. Verify output/checkpoint S3 permissions and paths.
4. Confirm instance quotas/capacity for chosen GPU family.

## Stabilization Actions (15-60 min)

1. Reduce `instance_count` temporarily to get one successful baseline run.
2. Increase `max_wait_seconds` and/or relax overly aggressive runtime limits.
3. Run on On-Demand temporarily if spot interruptions are extreme.
4. Validate checkpoint write path with a short controlled test run.

## Root Cause Patterns

- Wrong S3 prefix permissions for checkpoints.
- Spot interruption rate too high for runtime profile.
- Runtime limits lower than actual training needs.
- Training container writes checkpoint path inconsistently.

## Permanent Fixes

- Add pipeline alarms on failed executions and prolonged runtimes.
- Add preflight quota/capacity checks in CI before launching runs.
- Enforce checkpoint write/read contract in container integration tests.
- Document per-model baseline runtime and safe spot strategy.
