"""Scale Auto Scaling Groups from a validated event and optionally fan out."""
from __future__ import annotations

import json
import os
from typing import Any

import boto3
from botocore.config import Config

AWS_CONFIG = Config(retries={"mode": "standard", "max_attempts": 8})
asg = boto3.client("autoscaling", config=AWS_CONFIG)
sns = boto3.client("sns", config=AWS_CONFIG)
sfn = boto3.client("stepfunctions", config=AWS_CONFIG)


def _positive_int(value: Any, field: str, allow_zero: bool = True) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise ValueError(f"{field} must be an integer")
    if value < (0 if allow_zero else 1):
        raise ValueError(f"{field} is outside the allowed range")
    return value


def _current(name: str) -> dict[str, int]:
    result = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[name])
    groups = result.get("AutoScalingGroups", [])
    if not groups:
        raise ValueError(f"Auto Scaling Group not found: {name}")
    group = groups[0]
    return {key: int(group[key]) for key in ("MinSize", "MaxSize", "DesiredCapacity")}


def lambda_handler(event: dict[str, Any], _context: Any) -> dict[str, Any]:
    operations = event.get("scale_operations")
    if not isinstance(operations, list) or not operations:
        raise ValueError("event.scale_operations must be a non-empty list")

    results: list[dict[str, Any]] = []
    for index, operation in enumerate(operations):
        if not isinstance(operation, dict):
            raise ValueError(f"scale_operations[{index}] must be an object")
        name = operation.get("auto_scaling_group")
        if not isinstance(name, str) or not name.strip():
            raise ValueError(f"scale_operations[{index}].auto_scaling_group is required")

        desired = _current(name)
        for event_key, aws_key in (("min_size", "MinSize"), ("max_size", "MaxSize"), ("desired_capacity", "DesiredCapacity")):
            if event_key in operation:
                desired[aws_key] = _positive_int(operation[event_key], event_key)

        if desired["min_size"] > desired["max_size"]:
            raise ValueError(f"min_size exceeds max_size for {name}")
        if not desired["min_size"] <= desired["desired_capacity"] <= desired["max_size"]:
            raise ValueError(f"desired_capacity must be between min_size and max_size for {name}")

        asg.update_auto_scaling_group(
            AutoScalingGroupName=name,
            MinSize=desired["min_size"],
            MaxSize=desired["max_size"],
            DesiredCapacity=desired["desired_capacity"],
        )
        results.append({"auto_scaling_group": name, **desired})

    summary = {"status": "accepted", "scale_operations": results}
    topic_arn = os.getenv("SNS_TOPIC_ARN")
    if topic_arn:
        sns.publish(TopicArn=topic_arn, Subject="ASG scaling request accepted", Message=json.dumps(summary))
    state_machine_arn = os.getenv("STEP_FUNCTION_ARN")
    if state_machine_arn:
        sfn.start_execution(stateMachineArn=state_machine_arn, input=json.dumps(summary))
    return {"statusCode": 200, "body": json.dumps(summary)}
