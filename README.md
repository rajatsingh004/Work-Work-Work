# DevOps Engineering Case Studies

Generalized engineering narratives about platform reliability, cloud operations, and security. Each case study focuses on problem framing, decisions, risk controls, verification, and operational follow-up.

These examples are intentionally anonymized. They omit company/customer names, internal ticket references, account identifiers, hostnames, private network ranges, and detailed architecture diagrams. Quantitative outcomes are excluded unless independently approved. These are engineering narratives, not copies of internal runbooks.

## Case studies

| Folder | Theme | Skills demonstrated |
|---|---|---|
| [migration](migration/README.md) | Container platform migration | Discovery, sequencing, traffic shifting, rollback planning |
| [disaster-recovery](disaster-recovery/README.md) | Recovery readiness | RTO/RPO, dependency mapping, restore validation, exercises |
| [rds-upgrade-rca](rds-upgrade-rca/README.md) | Managed database upgrade and incident learning | Compatibility, change control, observability, RCA |
| [audit-logging](audit-logging/README.md) | Centralized audit logging | Coverage, integrity, retention, access control |
| [cost-optimization](cost-optimization/README.md) | Cloud cost optimization | Baselines, utilization, guardrails, continuous review |

## Reading these case studies

Each write-up distinguishes the generalized scenario from the approach and verification plan. It avoids claiming a specific implementation or measured result where details are not available. Adapt the patterns to your environment and validate them against current vendor guidance.

## Public portfolio hygiene

Keep customer data, internal identifiers, secrets, unapproved financial figures, proprietary diagrams, and organization-specific operational access procedures out of this repository. Sensitive source procedures are not reproduced here.