# CrowdStrike Fleet Rollout Pattern

The source material described endpoint protection on Linux hosts. This public version retains the engineering work involved in coordinating a security-agent rollout while removing internal host inventories, customer identifiers, download locations, and tenant-specific settings.

## Rollout design and engineering controls

1. Inventory supported operating systems and kernel/runtime compatibility; define a representative pilot ring.
2. Retrieve the signed vendor package from an approved artifact source and verify its signature/checksum before deployment.
3. Inject the tenant/customer identifier from a secrets manager at deployment time. Mark secret-bearing tasks as no-log and never store the identifier in Git or inventory. Use a narrowly scoped deploy role and encrypt any staged package/cache.
4. Deploy by rings (pilot, non-production, low-risk production, remaining fleet) with health and performance gates between rings. Use an idempotent configuration-management task, bounded retries, and a concurrency cap so a bad package cannot roll through the entire fleet.
5. Verify service state, sensor registration, policy assignment, heartbeat freshness, and expected telemetry through the vendor console/API. Installation success alone is not an acceptance signal.
6. Track exceptions with an owner, rationale, compensating control, and expiry. Reconcile intended inventory against enrolled and healthy sensor inventory.
7. Roll back or pause a ring if boot, CPU, network, application, or sensor-health signals cross agreed thresholds. Preserve package version, result, and sanitized failure reason for follow-up.

## Acceptance criteria

- Package signature/checksum validated against a trusted vendor source.
- Pilot host reboots and runs representative application/network checks without regression.
- Sensor reports healthy and receives the intended policy; telemetry arrives within the agreed heartbeat window.
- Deployment totals reconcile: eligible, successful, failed, excluded, and pending hosts.
- Monitoring and an owner-backed exception process exist before broad rollout.

The source materials described coordination across endpoint protection and operational teams. The public procedure retains rollout, validation, exception, and rollback controls while omitting tenant-console steps and organization-specific enrollment details.

## Operational evidence

Record package version/checksum, deployment scope, success/failure counts, unsupported hosts, exception owners, and the test evidence for detection/telemetry. Use sanitized totals only when they are approved for publication.

This repository intentionally does not include vendor tenant IDs, customer IDs, internal package repositories, host lists, proxy routes, policy exports, or incident response playbooks.
