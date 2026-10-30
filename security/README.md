# Security Engineering Portfolio

This section preserves the breadth of the source work across platform hardening, endpoint-protection rollout, privileged access, secure SDLC, account guardrails, and audit evidence. Operationally sensitive procedures have been recreated in a neutral lab context; raw internal access workflows, tenant identifiers, endpoint addresses, diagrams, and credentials are not published.

## Areas

- [CrowdStrike rollout engineering](crowdstrike/README.md): staged endpoint-agent deployment, telemetry coverage, exception handling, and rollback gates.
- [CyberArk privileged access](cyberark/README.md): onboarding and session-management concepts using least privilege and secret-safe workflows.
- [Checkmarx secure SDLC](checkmarx/README.md): SAST integration, quality gates, and remediation ownership in CI.
- [AWS Organizations guardrails](scp/README.md): service-protection policy pattern and safe rollout strategy.
- [Audit evidence](../database-operations/audit-logging/README.md): event coverage, retention, integrity, and validation.

## Publishing boundary

Do not place real PAM tenants, safe/account names, session gateways, connection strings, usernames, host/IP values, enrollment links, sensor/customer IDs, endpoint lists, internal scanner URLs, or policy exceptions in public files. Use the templates only with a tenant and endpoints you control.
