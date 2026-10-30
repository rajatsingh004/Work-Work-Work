# AWS Organizations Guardrails: SCP and Tag Policy Rationalization

The source work reviewed a set of overlapping Service Control Policies and proposed consolidating duplicates, retaining Control Tower baseline guardrails, moving tag-value governance into Tag Policies where appropriate, and keeping enforcement in SCPs. The proposed control families covered root access protection, encryption, region boundaries, expensive instance classes, console MFA, deletion/modification restrictions, IAM credential creation, and required resource tags. This folder includes a security-service protection example plus generic tag-policy and tag-enforcement examples.

## Rationalization approach

1. Inventory policies by OU/account attachment, action coverage, exceptions, and owner; identify duplicate or superseded controls.
2. Retain platform-managed Control Tower guardrails rather than cloning them under a second name.
3. Separate tag-value normalization (Tag Policy) from hard deny enforcement (SCP). Tag Policies alone do not prevent all untagged-resource creation.
4. Define baseline tags such as `Name`, `Product`, `Environment`, `Component`, and `Owner`; add service-specific tags for website, operating system, data classification, or purpose only where applicable.
5. Review deny controls for encryption, allowed regions, root use, console MFA, resource deletion/modification, IAM user/access-key creation, and expensive instance types. Provide narrowly scoped automation and break-glass exceptions with audit.
6. Test in a sandbox OU, inspect CloudTrail denied events, validate infrastructure-as-code roles and service-linked roles, then roll out in stages with an owner and rollback path.

The sample [`tag-governance-scp.example.json`](tag-governance-scp.example.json) demonstrates missing-tag deny statements for EC2 and S3. It is intentionally limited and illustrative; action-level tag-on-create support and EC2 multi-resource behavior must be validated against current AWS authorization documentation before attachment. Do not attach a sample SCP directly to a production organization.

## Safe rollout

1. Validate actions against the current AWS Service Authorization Reference.
2. Test in an isolated organizational unit with representative delegated-admin and automation roles.
3. Check policy size limits and simulate expected allow/deny behavior.
4. Preserve a break-glass recovery path, record exceptions, and review them on a schedule.
5. Attach in stages and monitor CloudTrail for denied operations.

See [`deny-security-controls.json`](deny-security-controls.json) and [`tag-policy.example.json`](tag-policy.example.json). SCPs set a maximum permission boundary; they do not grant permissions by themselves. Review the deny list with service owners before attachment.
