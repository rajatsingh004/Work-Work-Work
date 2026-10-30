# Jenkins HA and Shared Controller Migration

The source work covered a high-availability Jenkins implementation and consolidating separate backend/frontend controllers into a shared delivery service. The recorded target used a controller recovery path, EC2 fleet agents, and EFS-backed shared workspace storage; production pipelines used On-Demand workers while non-production work could use Spot. A failure exercise stopped one Jenkins instance and verified the replacement could resume service. The work also included a phased move of more than 165 pipelines, grouped by application and build/deploy technology.

The public design focuses on platform choices and migration safeguards without reproducing employer host names, SCM repositories, credential IDs, plugin inventory, application names, cost tables, or pipeline secrets.

## Historical planning estimate (anonymized)

The source proposal priced a five-instance EC2 worker/controller footprint, five small EBS volumes, a 731-GB EFS filesystem, and two load balancers at approximately **$1,632.95/month** based on the rates captured in that planning document. This is a historical estimate, not a measured bill or current AWS quote. It excludes workload variability and may not reflect the final deployed architecture; recalculate from current regional pricing and actual storage/traffic before using it for a decision.

## Architecture principles

- Treat controller state (jobs, credentials references, plugin versions, configuration, and build metadata) as recoverable state; keep build work on disposable agents.
- Prefer configuration as code and a tested plugin baseline. Pin and review upgrades in a staging controller.
- Keep executors off the controller. Use isolated, short-lived or patched agents with least-privilege network and cloud identities.
- Back up controller configuration and required state to an encrypted, access-controlled destination; test restoration on a separate controller.
- Design for single active controller unless the selected architecture explicitly supports shared-state active/active operation. A second VM is not HA by itself.

## Consolidation sequence

1. Inventory jobs, plugins, shared libraries, agents, credential references, SCM webhooks, build dependencies, and release permissions.
2. Define controller ownership, agent pools, plugin support, backup/restore, maintenance, and access model.
3. Migrate representative non-production jobs and validate branch/tag checkout, artifact flow, scanners, deploy status, and notifications. The source plan covered S3 publishing, Lambda deploys, scripted jobs, Terraform/Terragrunt, CodeDeploy, Android, Go, Docker, Ant/Maven, and npm workflows; inventory and validate each class separately.
4. Freeze new jobs on legacy controllers, migrate in waves, compare outputs, then move webhook/deployment ownership.
5. Keep a rollback path until the new controller has passed recovery and operating checks.

## Recovery checks

Restore controller config and plugin set, reconnect a clean agent, verify credentials references resolve from the secret backend, run a non-production pipeline, and confirm audit/build records. Keep the backup isolated from the controller's runtime identity.
