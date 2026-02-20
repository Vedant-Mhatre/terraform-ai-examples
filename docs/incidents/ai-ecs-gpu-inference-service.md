# Incident Runbook: ECS GPU Inference Service

## Scenario

Inference latency spikes and 5xx errors increase after a traffic burst. ALB target health drops because new tasks remain in `PENDING` due to insufficient GPU capacity.

## Blast Radius

- Customer-facing inference endpoint degraded or unavailable.
- Downstream systems depending on model responses become delayed.
- Cost may increase if autoscaling thrashes.

## Detection Signals

- ALB target unhealthy count rises.
- ECS service events show placement failures.
- CloudWatch metrics: elevated `HTTPCode_Target_5XX_Count`, increased latency.

## Triage Steps (0-15 min)

1. Check ECS service events and running/pending task counts.
2. Verify ASG desired/max and current in-service GPU instances.
3. Confirm launch template AMI/instance type still valid and capacity obtainable in selected AZs.
4. Validate application health endpoint behavior on current tasks.

## Stabilization Actions (15-60 min)

1. Temporarily increase ASG max and desired capacity if quotas allow.
2. Reduce ECS deployment minimum healthy percent pressure if rollout is stuck.
3. Shift traffic weighting (if available) to a backup endpoint/model tier.
4. If capacity is constrained, switch to a fallback smaller model on non-GPU path.

## Root Cause Patterns

- ASG max too low for burst profile.
- Spot/On-Demand capacity unavailable in selected subnets/AZs.
- Health check path too strict during model warm-up.
- Container start time exceeds deployment assumptions.

## Permanent Fixes

- Add capacity headroom policy for known traffic windows.
- Add startup grace and readiness strategy for model warm-up.
- Add latency and pending-task alarms with runbook links.
- Test failure injection quarterly (GPU host drain, delayed startup).
