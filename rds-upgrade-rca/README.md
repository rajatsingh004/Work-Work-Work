# RDS Upgrade Readiness and RCA

## Context

The source RCA reviewed lower-environment issues during a managed MySQL-compatible database upgrade and challenged the choice of an in-place upgrade when blue/green or snapshot-restore approaches were available. Application packages had changed around the same period, making infrastructure and application changes harder to isolate. The database upgrade exposed parameter compatibility concerns, including time-zone and case-sensitivity settings.

## Decision framework

1. **Prefer an isolated target** when application compatibility and rollback risk justify it. Blue/green creates a candidate environment for validation before switchover; snapshot restore is useful when a controlled clone and recovery point are the main needs.
2. **Use in-place only with a documented reason**, supported engine path, tested backup/restore, planned downtime, and explicit rollback constraints. A database major-version upgrade may not have a true in-place rollback.
3. **Separate variables:** hold application packages and database configuration steady where possible, or record each independently so failures are attributable.
4. **Validate parameters and schema:** compare parameter groups, extensions, collation/case behavior, time zone, SQL modes, connection limits, and query plans.

## Pre-change checklist

- Confirm engine and target compatibility, deprecated parameters, and replication/failover behavior.
- Restore a representative backup and run application smoke, migration, and read/write tests.
- Capture database latency, connection usage, replication lag, error rates, and backup status.
- Coordinate application teams on package freeze, migration order, test data, and sign-off criteria.
- Define a go/no-go checkpoint, monitoring owner, customer communication, and recovery decision tree.

## Incident review structure

Document impact in service terms, timeline, detection, change sequence, technical trigger, contributing factors, mitigation, recovery, and corrective actions. Separate human decisions from system conditions. Actions should improve preflight compatibility checks, parameter-group diffs, release coordination, test coverage, and observability.

## Lessons retained

- Obtain application-team sanity checks before and after the database change.
- Prefer a reversible deployment pattern where supported and validate its cutover mechanics in advance.
- Review parameter-group deltas explicitly; do not assume the target inherits compatible settings.
- Treat pre-production upgrade behavior as a signal requiring remediation before production, not as a rehearsal checkbox.

The public version removes database names, account/service identifiers, internal incident links, and unapproved impact figures.
