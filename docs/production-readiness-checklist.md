# Production Readiness Checklist

Use this before promoting any example-derived stack to production.

## Security

- IAM permissions are least-privilege and scoped.
- Encryption at rest and in transit is enabled where relevant.
- Public exposure is intentionally controlled and documented.
- Cross-account trust uses external IDs and explicit principals.

## Reliability

- Retry/dead-letter behavior is defined for async flows.
- Alarms exist for critical failure signals.
- State locking and backend durability are configured.
- Rollback or redeploy strategy is known.

## Cost

- Baseline monthly cost estimate is documented.
- Autoscaling bounds are set to sane min/max values.
- Expensive resource toggles are explicit (especially GPU workloads).
- Cleanup procedure is tested.

## Operability

- Validation steps are automated or documented clearly.
- Logs/metrics are enabled and retained appropriately.
- On-call runbook entries are created for key alarms.
- Incident runbook from `docs/incidents/` is reviewed and rehearsed.
- Team ownership for the stack is explicit.
