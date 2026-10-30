"""Observe ASG/ECS scaling state and notify/orchestrate when work is pending."""
from __future__ import annotations

import json
import os
from typing import Any

import boto3
from botocore.config import Config

cfg = Config(retries={"mode": "standard", "max_attempts": 8})
asg = boto3.client("autoscaling", config=cfg)
ecs = boto3.client("ecs", config=cfg)
sns = boto3.client("sns", config=cfg)
sfn = boto3.client("stepfunctions", config=cfg)


def lambda_handler(event: dict[str, Any], _context: Any) -> dict[str, Any]:
    observations = []
    for name in event.get("auto_scaling_groups", []):
        response = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[name])
        groups = response.get("AutoScalingGroups", [])
        if not groups:
            observations.append({"type": "asg", "name": name, "status": "not_found"})
            continue
        group = groups[0]
        pending = sum(i["LifecycleState"].startswith("Pending") for i in group.get("Instances", []))
        in_service = sum(i["LifecycleState"] == "InService" for i in group.get("Instances", []))
        observations.append({"type": "asg", "name": name, "pending": pending,
                             "in_service": in_service, "status": "scaling" if pending else "steady"})

    for name in event.get("ecs_clusters", []):
        response = ecs.describe_clusters(clusters=[name])
        clusters = response.get("clusters", [])
        if not clusters or clusters[0].get("status") != "ACTIVE":
            observations.append({"type": "ecs", "name": name, "status": "not_found_or_inactive"})
            continue
        cluster = clusters[0]
        pending = cluster.get("pendingTasksCount", 0)
        observations.append({"type": "ecs", "name": name, "pending": pending,
                             "running": cluster.get("runningTasksCount", 0),
                             "status": "scaling" if pending else "steady"})

    payload = {"observations": observations}
    if any(item.get("status") == "scaling" for item in observations):
        if topic := os.getenv("SNS_TOPIC_ARN"):
            sns.publish(TopicArn=topic, Subject="Capacity transition observed", Message=json.dumps(payload))
        if machine := os.getenv("STEP_FUNCTION_ARN"):
            sfn.start_execution(stateMachineArn=machine, input=json.dumps(payload))
    return {"statusCode": 200, "body": json.dumps(payload)}
