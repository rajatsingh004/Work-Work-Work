# Cloud Platform Engineering Portfolio

This repository turns a body of hands-on infrastructure and operations work into reviewable, anonymized engineering artifacts. It covers cloud automation, Terraform/Terragrunt, Jenkins delivery, platform security, migration planning, auditability, cost governance, and production readiness.

The goal is to show how the work fits together: repeatable infrastructure modules are composed with Terragrunt, delivered through gated Jenkins pipelines, automated with event-driven Lambda functions, and supported by operational practices for security, recovery, and cost control.

> **Public portfolio note:** source materials were adapted for public use. Replaceable values use `example.com`, `demo`, or Terraform inputs. Real credentials, access tokens, private keys, AWS account/resource IDs, internal URLs, customer names, employee identities, ticket IDs, and proprietary diagrams are excluded. CyberArk and endpoint-security procedures are recreated as generic examples; no organization-specific access workflow is published.

## Project map

| Area | What it demonstrates | Entry point |
|---|---|---|
| AWS automation | ASG/ECS scaling orchestration, AMI archiving, IAM Identity Center inventory, security-group backup, and Route 53 restore preparation | [automation-lambdas](automation-lambdas/README.md) |
| Infrastructure as code | Reusable Terraform building blocks for ALB, ASG, IAM, CloudFront, CodeDeploy, and Kubernetes access | [infrastructure/terraform](infrastructure/terraform/README.md) |
| Environment composition | Terragrunt hierarchy, remote state, dependency outputs, and environment overlays | [infrastructure/terragrunt](infrastructure/terragrunt/README.md) |
| Delivery engineering | Parameterized Jenkins pipelines with source checkout, quality/security gates, deployment, health checks, and approvals | [delivery](delivery/README.md) |
| Security engineering | Generic endpoint protection rollout, privileged access workflows, SAST integration, SCP guardrails, and audit evidence | [security](security/README.md) |
| Migration | Public-to-private network planning, domain transition, Graviton migration, and staged workload movement | [migration](migration/README.md) |
| Disaster recovery | Recovery objectives, dependency mapping, backup/restore and failover exercises | [disaster-recovery](disaster-recovery/README.md) |
| Database operations | Audit-log coverage and managed database upgrade/RCA practices | [database-operations](database-operations/README.md) |
| Cost engineering | Rightsizing, schedule/retirement decisions, commitments, storage lifecycle, and verification | [cost-engineering](cost-engineering/README.md) |
| Operations | Runbook patterns for alert response, load testing, DNS/certificate changes, and decommissioning | [operations](operations/README.md) |
| Recreated architecture | New sanitized diagrams connecting IaC, CI/CD, EKS delivery, and operations workflows | [architecture](infrastructure/architecture.md) |
| Roadmap | Prioritized platform initiatives, distinguished from completed work | [platform roadmap](general-engineering/platform-roadmap.md) |

## Workstream coverage

| Source workstream | Public artifact(s) | Retained engineering substance |
|---|---|---|
| Lambda automation | [automation-lambdas](automation-lambdas/README.md) | ASG and ECS capacity orchestration, state notifications, AMI archive/restore, IAM Identity Center inventory, security-group snapshots, Route 53 recovery preparation, stopped-instance and unassociated-IP review |
| Terraform and Terragrunt | [modules](infrastructure/terraform/README.md), [environment composition](infrastructure/terragrunt/README.md) | ALB/TLS routing, mixed-instance ASG, instance identity, CloudFront origins and cache behavior, CodeDeploy wiring, VPC, EKS access, remote state and dependency graph |
| CI/CD and Jenkins | [delivery](delivery/README.md), [Jenkins HA](delivery/jenkins-ha.md) | Shared-controller availability design, EFS workspace strategy, On-Demand/Spot worker roles, phased migration of a large pipeline estate, build/test/quality/SAST/deployment stages |
| Security controls | [security](security/README.md) | Endpoint-agent rollout, privileged access lifecycle, Checkmarx SAST gates, SCP consolidation, encryption/tagging/region/MFA/deletion guardrail design |
| Platform/network change | [migration](migration/README.md), [Kubernetes platform repo](https://github.com/rajatsingh004/Kube-Work) | VPC public-to-private transition, internal/external domain split, EKS/Istio routing, progressive delivery and workload secrets |
| Reliability and data operations | [DR](disaster-recovery/README.md), [RDS RCA](rds-upgrade-rca/README.md), [audit logging](database-operations/audit-logging/README.md) | Recovery objectives, upgrade approach, database audit coverage/retention, performance impact, rollout and rollback planning |
| Cost and lifecycle | [cost engineering](cost-engineering/README.md), [resource review](operations/unused-resource-review.md), [general engineering](general-engineering/README.md) | stopped compute, unused target groups/security groups/load balancers/CloudFront/EIPs, database/cache/search sizing, storage lifecycle, commitment review, account retirement and Graviton compatibility |

The project pages distinguish source-derived work from newly authored public examples. Names and exact private settings are replaced, while workflows, technical decisions, failure modes, and validation criteria are retained where safe to share.

## Selected implementation details

### Event-driven automation

The Lambda examples use the AWS SDK default credential chain and environment configuration rather than embedded keys. Inputs are validated before changes are made. ASG/ECS changes produce an auditable result, optional SNS notifications, and optional Step Functions hand-off. Inventory and backup workflows paginate API responses, isolate per-resource failures, and write machine-readable output.

### Terraform and Terragrunt

Terraform examples expose account, region, network, identity, and naming choices as inputs. The modules illustrate ALB listeners and target groups, mixed-instance Auto Scaling, EC2 instance profiles, CloudFront origins, CodeDeploy associations, IAM roles, and Kubernetes namespace RBAC. Terragrunt examples show shared backend configuration, reusable module sources, environment-specific inputs, and explicit dependencies between ALB, ASG, and deployment resources.

Private module repository URLs and original environment values are replaced with local module paths and `example.com` references. The public examples should be reviewed and initialized in a sandbox before use; they are not a copy of a live production environment.

### CI/CD and supply-chain checks

The Jenkins examples model a deployment pipeline that can select branch/tag, environment, unit tests, SonarQube, Checkmarx, and deployment strategy. Production changes require an explicit approval gate. AWS authentication is supplied by the Jenkins credential provider or workload identity; no access key is stored in a Jenkinsfile. Artifacts are promoted between stages and deployment health is checked after rollout.

## Repository layout

```text
automation-lambdas/      Python Lambda handlers and input examples
infrastructure/          Terraform modules and Terragrunt live configuration
delivery/                Jenkinsfiles, shared pipeline patterns, quality gates
security/                CrowdStrike, CyberArk, Checkmarx, SCP and audit patterns
migration/                Network/domain/compute migration plans
disaster-recovery/       Recovery design and exercise material
database-operations/     Database audit logging and upgrade RCA
cost-engineering/         Cost review and optimization workflows
operations/              Runbooks and change/decommission checklists
```

## Review before applying

1. Pin provider, module, CLI, and container versions for your target environment.
2. Inspect IAM permissions and network exposure; use least privilege.
3. Configure remote Terraform state with encryption, access controls, and locking.
4. Run format, validation, plan, policy, and security checks in a sandbox.
5. Estimate ongoing cost, especially for NAT gateways, load balancers, managed databases, and retained backups.
6. Replace demo identifiers and test against a non-production account before any production adoption.

## Evidence and limits

The repository demonstrates patterns and artifacts, not an assertion that every included example was run against a public demo account. Case studies are generalized where the original evidence contained private operational context. No unapproved savings numbers or customer-impact metrics are claimed.
