# Managed database audit logging: design and rollout

This runbook generalizes an audit-logging planning effort across managed MySQL-compatible, PostgreSQL, and SQL Server databases. The work focused on selecting auditable events, balancing evidence requirements against database overhead and log volume, applying engine-specific configuration through parameter groups or native audit features, and preparing rollback and monitoring before production rollout.

## Coverage decisions

For connection accountability, capture successful connection/authentication and disconnect identity where the engine exposes them. Add statement or object-level auditing only where the threat model or compliance requirement needs it; indiscriminate query logging can expose sensitive data and increase CPU, I/O, and storage use. Define who can read logs, how they are searched, how integrity is protected, and a retention schedule before enabling capture.

Managed cache audit evidence is not interchangeable with relational database audit records. Specify required event classes first, then determine which service events, engine logs, network telemetry, and application identity records are available for the exact cache offering. Document coverage gaps explicitly; do not claim that connection or metrics logs prove every data command.

The source requirement used one year of retention, with the first 30 days searchable in the standard tier and older evidence moved to archival storage. Treat those as policy inputs to validate with the data owner and applicable retention rules; test retrieval and restoration from archive.

## Engine-specific implementation notes

### PostgreSQL / RDS PostgreSQL

- Use a custom DB parameter group. Evaluate `log_connections` and `log_disconnections`; choose `log_statement` or an audit extension only for the required event scope.
- Enable PostgreSQL log export to CloudWatch Logs and define retention/export controls there.
- Verify parameter apply type and reboot impact in a non-production instance. Reuse an existing custom group only after confirming its effective values.
- Compare connection events and application behavior before/after. A broad statement policy can produce high volume and expose query literals.

### MySQL-compatible RDS / Aurora MySQL

- Confirm engine version and the supported audit mechanism for that exact service/version. Do not assume a generic `server_audit_*` parameter exists on every RDS MySQL flavor; supported engines and parameter names differ.
- Configure the custom parameter/option group and event classes required (for example connection, query, or table events), then export the relevant engine logs.
- Measure write latency, CPU, log volume, and storage during a representative workload. Roll back to the previous group if the agreed thresholds are exceeded.

### SQL Server

- Define server and database audit specifications for the exact principal and event scope; select an approved audit target and retention path.
- Validate generated records, access controls, and storage lifecycle; ensure the audit destination itself cannot be modified by the audited role.
- Disable the database and server specifications in the planned rollback, then verify normal database behavior.

## Change sequence and evidence

1. Inventory engines, versions, parameter groups, log exports, audit events, owners, and required retention.
2. Take and verify a recoverable backup; capture baseline CPU, memory, latency, I/O, and log volume.
3. Build the parameter/option group or native audit specification in a lower environment; exercise representative connection and query cases.
4. Review a change plan with maintenance window, expected restart, alert thresholds, evidence destination, and rollback steps.
5. Apply in a staged batch. Check audit records, CloudWatch delivery, database health, and application SLOs.
6. Configure retention and archival transitions; periodically test access and retrieval from both tiers.
7. Record effective settings and evidence without storing query data, credentials, or customer identifiers in this portfolio.

## Rollback

Re-associate the recorded prior parameter/option group or disable the audit specification, applying a restart only when the engine requires it. Preserve already collected evidence according to policy. Confirm application health and record why rollback was triggered.

## Operational controls

Monitor CPU, memory, storage, write/read latency, log ingest lag, bytes ingested, retention cost, and missing log intervals. Restrict log access to approved audit roles; avoid exporting secrets or personal data. Engine-specific commands and settings must be checked against the exact managed-engine release before execution.
