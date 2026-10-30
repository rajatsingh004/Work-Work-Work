# New AWS Account and Workload Onboarding

This is a recreated onboarding sequence based on the account-creation and product-onboarding SOP category in the source repository.

1. **Request and ownership:** record business purpose, environment, accountable owner, support contact, data classification, required regions, and expected monthly cost.
2. **Governance baseline:** place the account in the approved OU, apply Control Tower/SCP guardrails, enable centralized audit/security services, and establish break-glass ownership.
3. **Deployment identity:** create a short-lived role for Terraform/CI with least-privilege permissions and audited trust conditions. Avoid IAM user access keys.
4. **Network foundation:** allocate non-overlapping CIDRs, create multi-AZ subnets/routes/endpoints, configure DNS, egress, flow logs, and connectivity to shared services.
5. **Workload registration:** define tags, secrets/certificate ownership, logging/metrics, backup policy, alert routes, recovery objectives, and runbooks.
6. **Data onboarding:** for cross-account database or search restores, approve data classification and masking, use a controlled snapshot-copy role, restrict target access, and delete temporary copies on schedule.
7. **Delivery onboarding:** register repository/build identity, test/security gates, immutable artifact path, deployment role, approval policy, health checks, rollback, and ownership metadata.
8. **Readiness review:** validate cost estimate, quotas, encryption, restore, alerting, policy denials, and handover evidence before production traffic.

Each step has an owner and completion evidence. Organization-specific approval names, account IDs, and deployment URLs are intentionally replaced with generic values.
