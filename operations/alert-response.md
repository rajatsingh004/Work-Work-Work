# Infrastructure Alert Response Runbook

## Applies to

Load balancers and target groups, EC2/Auto Scaling, ECS, managed search/cache/database services, SQS, EventBridge rules, and serverless integrations.

## Triage sequence

1. Acknowledge the alert and identify the resource, environment, signal window, and change context.
2. Determine customer impact from service-level telemetry; do not infer impact from one infrastructure alarm alone.
3. Check recent deployments, instance/task lifecycle, target health, scaling activity, dependency health, and saturation.
4. Mitigate with the smallest reversible action. Preserve diagnostic evidence before restart/scale/rollback.
5. Confirm recovery through end-to-end health and sustained metrics, not only the alarm returning to OK.
6. Update stakeholders through the approved incident channel; maintain an owner and next update time.
7. Capture timeline, commands/actions, telemetry, recovery evidence, and follow-up work.

## Signal-specific checks

- **ALB/TG:** listener and target registration, health-check path/port, 4xx/5xx split, target response time, deregistration/drain, and security-group path.
- **EC2/ASG:** desired/min/max, pending/in-service/terminating counts, launch-template version, health-check cause, AZ capacity, and scaling policy history.
- **ECS:** service events, task placement failures, desired/running/pending counts, deployment circuit breaker, capacity-provider headroom, and container health.
- **Search/cache/database:** connection saturation, CPU/memory/storage, shard/replication health, queue depth, failover state, and recent parameter/config changes.
- **SQS/EventBridge/Lambda:** age-of-oldest-message, DLQ growth, rule target delivery, Lambda errors/throttles/concurrency, and downstream idempotency.

Escalate when customer impact is increasing, data integrity is uncertain, or a mitigation could cause irreversible data/resource changes.
