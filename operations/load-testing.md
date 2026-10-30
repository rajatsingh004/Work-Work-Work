# New Application Load-Test Readiness

## Before the test

- Confirm owner, objective, success criteria, expected request mix, concurrency/ramp profile, duration, and approved target environment.
- Validate the test client can generate the planned load without becoming the bottleneck.
- Baseline application latency/errors and infrastructure CPU, memory, network, connection pools, autoscaling, and dependency saturation.
- Confirm data safety, rate limits, downstream consent, backup/recovery, dashboards, alert routing, and a stop authority.
- Estimate expected cost and ensure quotas/capacity are available.

## Test stages

1. Smoke test at low concurrency.
2. Ramp gradually while confirming traffic shape and telemetry.
3. Hold target load long enough to observe steady state and autoscaling behavior.
4. Run approved stress/soak stages only if the service remains within stop thresholds.
5. Reduce traffic, confirm queues drain and resources recover, and check for leaked test data/resources.

## Stop conditions

Abort for error/latency thresholds, resource saturation, data integrity risk, unexpected external traffic, dependency degradation, or operator request. Preserve dashboards and test configuration before cleanup.

## Deliverables

Record environment, build, workload profile, assumptions, results, bottleneck, scaling behavior, cost signal, and remediation owners. Do not publish customer names, live endpoints, raw traces, or internal test-window details.
