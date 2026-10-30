# Web 5xx and Unhealthy Target Triage

Use this sequence for a rise in HTTP 5xx responses or unhealthy targets behind a load balancer. Replace `app.example.com` with the approved demo hostname in a lab.

## Triage order

1. Establish scope and time window: affected routes, regions/AZs, client segments, deployment changes, and current error/latency rates.
2. Separate edge and application failures: inspect load balancer target health, listener/rule selection, connection errors, target response codes, and application logs.
3. Check instance/container readiness, CPU/memory, disk, thread/connection pools, queue depth, and dependency latency.
4. Compare desired vs healthy capacity. Confirm health-check path, protocol, timeout, matcher, grace period, and whether unhealthy hosts are actually replaced by the scaling group.
5. Check service discovery, DNS answers/TTL, TLS/SNI, connection saturation, and downstream health before restarting workloads.
6. If correlated with a deployment, stop further rollout and use the deployment system's tested rollback. If capacity constrained, scale in a controlled step and watch the same signals.
7. Verify recovery from an independent client and compare error rate, latency, healthy target count, and saturation against the pre-incident baseline.

## Scale-up decision inputs

Scale only after correlating sustained CPU/memory/network or connection saturation with traffic and queue growth. Confirm a scale-up will help the bottleneck, capacity/quota is available, the application is horizontally scalable, and dependencies can absorb the additional load. Choose a measured increment; do not scale based on a single noisy data point.

## Close-out evidence

Capture sanitized timeline, trigger, affected component, metric evidence, change/rollback, recovery verification, and follow-up owners. Do not include request payloads, credentials, internal hostnames, or customer details.
