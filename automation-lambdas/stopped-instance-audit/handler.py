"""List stopped EC2 instances for owner review; does not start or terminate them."""
from __future__ import annotations

import os
from datetime import datetime, timezone

import boto3


def handler(event, context):
    ec2 = boto3.client("ec2")
    paginator = ec2.get_paginator("describe_instances")
    items = []
    for page in paginator.paginate(Filters=[{"Name": "instance-state-name", "Values": ["stopped"]} ]):
        for reservation in page.get("Reservations", []):
            for instance in reservation.get("Instances", []):
                tags = {t["Key"]: t["Value"] for t in instance.get("Tags", [])}
                items.append({"instance_id": instance["InstanceId"],
                              "instance_type": instance.get("InstanceType"),
                              "launch_time": instance.get("LaunchTime").isoformat() if instance.get("LaunchTime") else None,
                              "name": tags.get("Name", ""), "environment": tags.get("Environment", ""),
                              "owner": tags.get("Owner", "")})
    return {"checked_at": datetime.now(timezone.utc).isoformat(),
            "region": os.getenv("AWS_REGION", "unknown"), "stopped_count": len(items),
            "stopped_instances": items}
