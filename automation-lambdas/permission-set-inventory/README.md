# IAM Identity Center Permission-Set Inventory

This adapts the original inventory utility that combined `sso-admin`, AWS Organizations, and Identity Store data into a timestamped CSV. It uses paginated APIs, bounded SDK retries, concurrent permission-set processing, and resolves each assignment to a user or group name where possible.

Required environment: `SSO_INSTANCE_ARN`, `IDENTITY_STORE_ID`, and an AWS region. Use an AWS SSO profile locally or a role in the execution environment. The output includes account and identity inventory, so treat it as sensitive: write to an encrypted location, limit access, and define retention. The read-only role needs only Organizations account listing, SSO Admin list/describe/tag/assignment reads, and Identity Store user/group reads.
