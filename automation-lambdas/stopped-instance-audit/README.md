# Stopped instance inventory

Scheduled, paginated inventory for stopped EC2 instances. The source work included reviewing stopped compute as part of cloud cost analysis; this Lambda provides the inventory and owner metadata so that operations can decide whether to restart, retain, snapshot, or retire each instance.

The handler has no mutating EC2 calls and makes no cost-saving claim. Use an execution role with `ec2:DescribeInstances` only. Add an independently reviewed notification or export destination if the report must be retained.
