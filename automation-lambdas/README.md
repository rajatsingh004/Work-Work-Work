# AWS Lambda Automation

The source work included one-off operational automations and event-driven scaling helpers. This folder turns those into reviewable Python projects: Lambda handlers for event-driven workflows and bounded command-line utilities for operations that can exceed Lambda runtime limits. AWS examples use boto3's default credential provider chain (Lambda execution role in AWS, AWS SSO/role credentials for development); no static access keys or real account/resource identifiers are embedded.

## Projects

| Path | Original workflow represented | Inputs and outputs |
|---|---|---|
| [asg-scaling](asg-scaling/) | Change one or more Auto Scaling Groups, report the resulting settings, and optionally start a Step Functions workflow | JSON `scale_operations`; optional SNS and Step Functions ARNs via environment |
| [ecs-scaling](ecs-scaling/) | Set ECS service desired counts and Application Auto Scaling bounds, then notify/orchestrate follow-up | JSON `scale_operations`; optional SNS/Step Functions |
| [capacity-watch](capacity-watch/) | Inspect ASG/ECS capacity and trigger a follow-up workflow when work is pending | Resource names and thresholds from event/environment |
| [ami-archive](ami-archive/) | Store AMIs in S3, wait for archive completion, and optionally restore them | CSV of AMI IDs; bucket supplied at runtime |
| [permission-set-inventory](permission-set-inventory/) | Inventory IAM Identity Center permission sets, assignments, accounts, and principals into CSV | IAM Identity Center instance and identity store IDs from environment |
| [security-group-backup](security-group-backup/) | Export selected security-group rules to JSON and optionally upload an encrypted backup to S3 | Input file of security-group IDs; bucket supplied at runtime |
| [route53-restore-prep](route53-restore-prep/) | Convert exported Route 53 records into bounded UPSERT change batches for review | Export JSON; output batches are not automatically submitted |

## Operational model

- Keep execution roles scoped to the specific resources and actions required.
- Validate event shape and bounds before calling write APIs.
- Enable Lambda retries/DLQs only with idempotency understood; cap Step Functions execution fan-out.
- Send structured logs and avoid logging secret values or sensitive record contents.
- Store backup artifacts in a versioned, encrypted bucket with lifecycle and restore tests.
- Treat generated CSV/JSON as potentially sensitive inventory and control access/retention.

Each project has its own README and sample event. These are portfolio implementations derived from operational automation patterns, with safer configuration boundaries and failure handling.
