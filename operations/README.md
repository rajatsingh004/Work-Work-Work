# Operations, Runbooks, and Change Controls

The source repo had alert-response SOPs for ALB, EC2, ECS, search clusters, SQS, EventBridge, and target groups; runbook requirements for 4xx/5xx, Redis connectivity, search reindex/restore, scale-up, and rollback; plus certificate renewal, load testing, and Lambda decommissioning material. This section keeps those operational disciplines as generalized public runbooks.

## Runbooks

- [Alert response](alert-response.md): triage signals, validate scope, mitigate, communicate, and capture evidence.
- [Web 5xx and unhealthy target triage](web-5xx-triage.md): correlate load balancer, workload, dependency, and scaling signals before mitigation.
- [Search cluster reindexing](search-reindexing.md): capacity preflight, throttled reindex, alias cutover, and rollback.
- [Managed cache connectivity](redis-connectivity.md): DNS, network, TLS, client pool, and service-health checks.
- [Unused resource review](unused-resource-review.md): validate ownership and dependencies before retiring billed resources.
- [Load-test readiness](load-testing.md): application/infra readiness, test stages, safety limits, and post-test cleanup.
- [Certificate renewal](certificate-renewal.md): inventory, staged renewal, validation, rollback, and expiry monitoring.
- [Lambda retirement](lambda-retirement.md): invocation/ownership review, backup, trigger inventory, decommission, and rollback.
- [Jenkins HA and shared delivery](../delivery/jenkins-ha.md): controller/agent lifecycle, backup, recovery, and safe migration.

The examples use `example.com` and demo names. They do not include internal escalation contacts, runbook screenshots, production endpoints, ticket links, or account-specific thresholds.
