# CyberArk Privileged Access Integration Pattern

The source collection included CyberArk Privilege Cloud onboarding, credential reconciliation, and Linux/Windows session-access material. Those organization-specific SOPs and connector details remain private. This recreated overview demonstrates the engineering and control points without publishing a real tenant URL, safe structure, username, server address, PSM gateway, or login procedure.

## Privileged-access lifecycle

1. Define identity source, approver, safe/vault ownership, account classification, and checkout/session policy.
2. Onboard an account through the approved API or console using an automation identity with narrowly scoped permissions.
3. Store API credentials and certificates in an approved secret store; retrieve them at runtime and prevent command/log output from exposing secret material.
4. Use a managed session proxy (PSM/PSMP) for interactive access; prohibit direct public SSH/RDP paths and local credential copies.
5. Reconcile managed credentials only through the platform's supported workflow, with a maintenance window and tested rollback.
6. Review session recordings, access logs, failed reconciliations, and orphaned accounts; remove temporary access after the task.

## Safe lab contract

For a self-owned test tenant, use `https://tenant.example.com`, a disposable test safe, and non-production accounts. Generate short-lived tokens from the supported authentication method, keep them out of shell history, and revoke them after testing. Consult current CyberArk vendor documentation for API versions and exact request schemas.

The source PowerShell snippets were not copied because they contained tenant-specific authentication and account-management details. The public case study focuses on the controls and operational design decisions.
