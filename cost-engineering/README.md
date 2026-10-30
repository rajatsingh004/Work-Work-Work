# Cloud Cost Engineering

The source work combined recurring cost review with concrete actions across compute, managed databases, search/cache clusters, storage, backups, CloudWatch ingestion, and savings commitments. This public version keeps the categories and decision logic while replacing application/resource names with generic labels.

## Workstreams represented

### Utilization and lifecycle

- Review stopped and under-utilized instances before resizing or retirement.
- Remove confirmed-unused Elastic IPs, EBS volumes, AMIs, alarms, and target groups only after ownership and dependency checks.
- Right-size search and cache node counts based on load, redundancy, and recovery requirements.
- Apply S3 lifecycle transitions for backups/logs after validating restore and retention obligations.

### Compute and database architecture

- Evaluate Graviton migration using application/toolchain compatibility checks and staged replacement rather than assuming binary compatibility.
- Assess RDS right-sizing against utilization, failover capacity, maintenance headroom, and performance baselines.
- Compare reserved capacity or Compute Savings Plans with on-demand usage, steady-state demand, and commitment flexibility.
- Revisit commitment decisions at expiry rather than renewing by default.

### Example outcomes from anonymized work log

Two lower-environment RDS right-sizing changes were recorded at approximately **$116/month** and **$208/month** estimated run-rate reduction respectively. These are historical estimates from an anonymized source log, not a current bill or independently revalidated savings claim. Other recorded workstreams included unused-resource cleanup, search/cache scaling, storage lifecycle, log-ingestion review, and a Graviton migration.

## Operating model

1. Build a baseline with consistent tags, cost categories, utilization metrics, and workload ownership.
2. Separate candidate identification from implementation; an optimizer recommendation is not approval to change production.
3. Assign risk, owner, expected savings, dependency checks, validation, and rollback for every change.
4. Implement in a low-risk window and compare normalized spend against traffic/usage and performance.
5. Track realized savings and reliability impact; review trends monthly and commitments before renewal.

Do not publish raw bills, account IDs, product/service identifiers, internal ticket references, or architecture diagrams. Historical estimates need context and owner approval before being presented as a personal result.
