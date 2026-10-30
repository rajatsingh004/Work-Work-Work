# Lambda Decommissioning Procedure

## Discovery and approval

1. Inventory the function, owner, code version, triggers, destinations, layers, environment variables, IAM role, VPC config, and downstream dependencies.
2. Review invocation metrics over a period that includes expected batch/seasonal work. No recent invocation does not prove a function is unused.
3. Ask the owner to confirm retirement and identify replacement behavior or data-retention requirements.
4. Raise an approved change with a recovery owner and rollback window.

## Backup and disablement

- Export the deployment package and IaC definition to an access-controlled, encrypted backup location.
- Record configuration metadata while redacting secret values. Do not include environment variables containing secrets in screenshots or tickets.
- Disable triggers or reduce traffic first where possible, then observe for unexpected invocations or downstream errors.
- Delete only after approval and after preserving code/configuration needed for restoration.

## Rollback

Restore the function from the reviewed package and IaC, restore required permissions/secrets from their authoritative stores, re-enable triggers, and validate a controlled invocation. Confirm downstream health before closing the change.
