# VPC and Domain Migration: Public Addressing to Private Network Design

## Engineering objective

Move workloads that had been placed in public address space toward private subnet placement, while changing the associated service-domain strategy from an externally exposed namespace to a split between public customer endpoints and private internal services. The work required coordination across networking, application owners, DNS, edge paths, and deployment automation.

The source planning work began with inventory: map addresses to cloud resources, identify the applications hosted there, and assign an application and infrastructure owner before designing a target. The scale included hundreds of externally visible subdomains, with ownership and usage validation required before any DNS retirement.

## Migration sequence

1. **Inventory and classify:** map CIDRs to ENIs, load balancers, instances, databases, DNS records, and application owners. Identify unused/dormant records separately from active dependencies.
2. **Design target network:** define a non-overlapping private CIDR, multi-AZ public/private/database subnets, route tables, NAT egress, VPC endpoints, flow logs, and any Transit Gateway or site-to-site VPN routing.
3. **Provision in parallel:** create the target VPC and shared network controls with Terraform/Terragrunt. Validate routes, DNS resolution, security groups, NACLs, endpoints, and observability before moving workloads.
4. **Migrate workload by workload:** build a dependency map, test connectivity and IAM, move stateless services first, and use replication or application-specific migration for stateful services.
5. **Transition DNS:** lower TTLs in advance, validate ownership and certificate coverage, move internal services to private hosted zones/VPN-reachable names, and retain controlled public entry points for customer-facing services.
6. **Cut over and observe:** shift traffic in stages, compare application health and network telemetry, retain the source path through an agreed rollback window, then remove obsolete public exposure after owner sign-off.

## Risk and control model

- No CIDR reuse until overlaps with peered networks, VPNs, and partner routes have been checked.
- Route, resolver, firewall, and security-group validation occurs before application cutover.
- DNS TTL reduction does not guarantee immediate cache expiry; use explicit rollback records and monitor both old/new targets.
- Keep internet-facing resources limited to the intended edge tier; internal admin tools use private reachability and identity-aware access.
- Every record/resource retirement requires owner confirmation, usage evidence, and a reversible change where feasible.

## Validation and learning

Test application-to-dependency paths, inbound/outbound routes, private DNS, certificates, egress controls, and monitoring from representative client subnets. Track cutovers and ownership gaps in a migration register. The source plan also included an internal/public domain split; public names below are represented with `example.com` and internal names with `corp.example.com`.

This is a generalized case study. It retains the architecture and sequencing decisions while omitting actual CIDRs, VPC/subnet IDs, domains, account references, and architecture diagrams.
