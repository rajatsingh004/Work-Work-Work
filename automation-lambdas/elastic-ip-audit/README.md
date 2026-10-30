# Unassociated Elastic IP audit

This scheduled Lambda inventories Elastic IPs and reports addresses without an association. It reflects the cost-control workflow from the source portfolio while deliberately remaining read-only: it does not release an address because ownership and recovery impact must be checked first.

## Operation

1. Trigger on a schedule (for example, EventBridge once per day).
2. Grant the execution role `ec2:DescribeAddresses`; add `sns:Publish` only when notifications are enabled.
3. Set `SNS_TOPIC_ARN` to an approved alert topic, or omit it to return the report only.
4. Review age, tags, allocation association, and service owner before any separately approved release.

The function uses the Lambda execution role through the AWS SDK default credential chain. Run separately in each account/region or orchestrate through an approved cross-account role. No address is modified.
