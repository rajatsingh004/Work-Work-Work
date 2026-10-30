# Unused Cloud Resource Review

The source inventory called out unused target groups, security groups, load balancers, CloudFront distributions, and Elastic IPs. This workflow turns that cleanup activity into an auditable review rather than an automatic deletion job.

## Inventory and disposition

- **Target groups:** check listener rules, active targets, recent request/health metrics, deployment groups, and application owner.
- **Security groups:** inspect ENI attachments, references from other rules, launch templates, and service-managed ownership before removal.
- **Load balancers:** check DNS consumers, listeners, target health, access logs, CloudWatch metrics, and DNS TTL/owner confirmation.
- **CloudFront:** inspect aliases, origins, traffic, WAF, certificates, DNS references, and invalidation/decommission needs.
- **Elastic IPs:** verify association, NAT/instance ownership, allowlists, recovery requirements, and billing status.

For each candidate, record resource type, environment, owner, evidence period, last-use signal, dependencies, change approver, planned date, rollback/recreation method, and final result. Require owner approval and a quiet-period observation before deletion. Keep inventory reports access-controlled because resource topology can be sensitive.
