# AWS Account Decommissioning

## Objective

Retire an account only after workloads, identities, data, backups, integrations, and audit evidence have a named disposition. Account closure is the final step after a controlled dependency and retention review.

## Sequence

1. Confirm business owner, closure date, account purpose, environment, and approved change.
2. Inventory resources, users/roles, service integrations, DNS, certificates, backups, logs, encryption keys, budgets, and support plans.
3. Identify data that must move to an archive account, be retained, or be deleted under policy; validate restores before deleting source data.
4. Notify stakeholders and stop new deployments/automation targeting the account.
5. Remove cross-account trust and external integrations after dependencies are migrated.
6. Disable workloads in stages, observe for missed dependencies, and collect final CloudTrail/config evidence.
7. Revoke human/automation access and use the approved account-closure process.
8. Verify closure and document retained backup/log locations and ownership.

Never publish account inventories, identity lists, data locations, encryption key IDs, or internal ticket references.
