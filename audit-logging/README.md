# Database Audit Logging and Retention Design

## Requirement captured

The source security request called for records of successful connections, failed connections, and disconnects with user identity, plus a one-year retention period. The lifecycle proposal kept recent logs in the standard storage tier for 30 days and then moved older data to an archival tier. The scope included managed MySQL-compatible databases and auditability discussions for managed cache/search/document data services.

## Design decisions

1. Map the audit question to each engine's actual event support. Do not treat general/slow query logs as a substitute for authentication or administrative audit events.
2. Enable only required log classes to avoid excessive volume and sensitive query payload capture.
3. Forward logs to a centralized destination with encryption, source identity, delivery monitoring, and controlled access.
4. Apply retention with lifecycle rules: hot searchable period for operational response, archival period for compliance, and expiry only after the approved retention window.
5. Monitor collection health and configuration drift; a log source silently disabled is a control failure.

## Validation

Generate controlled success/failure/disconnect events in a non-production database. Verify event identity, timestamp, source, delivery lag, searchability, lifecycle transition, access boundaries, and restore/read access to archived objects. Confirm the chosen engine/version supports the selected audit mechanism and estimate log volume before production rollout.

## Operational controls

Protect the log archive from modification/deletion by workload roles, separate security-audit readers from database operators, and review access. Redact or avoid sensitive query values where supported. Keep account identifiers, actual database endpoints, exported logs, and internal architecture details private.
