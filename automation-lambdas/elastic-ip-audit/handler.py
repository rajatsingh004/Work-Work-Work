"""Report unassociated Elastic IPs; optionally notify, never releases addresses."""
from __future__ import annotations

import json
import os
from datetime import datetime, timezone

import boto3


def handler(event, context):
    ec2 = boto3.client("ec2")
    sns = boto3.client("sns") if os.getenv("SNS_TOPIC_ARN") else None
    addresses = []
    for page in ec2.get_paginator("describe_addresses").paginate():
        addresses.extend(page.get("Addresses", []))
    unused = [
        {"allocation_id": row.get("AllocationId"), "public_ip": row.get("PublicIp"),
         "domain": row.get("Domain"), "name": next(
             (t["Value"] for t in row.get("Tags", []) if t["Key"] == "Name"), "")}
        for row in addresses if not row.get("AssociationId")
    ]
    report = {"checked_at": datetime.now(timezone.utc).isoformat(),
              "region": os.getenv("AWS_REGION", "unknown"), "unused_count": len(unused),
              "unused_addresses": unused}
    if sns and unused:
        sns.publish(TopicArn=os.environ["SNS_TOPIC_ARN"],
                    Subject="Demo account: unassociated Elastic IP review",
                    Message=json.dumps(report, indent=2))
    return report
