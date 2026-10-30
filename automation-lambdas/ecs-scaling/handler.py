"""Set ECS desired count and scalable-target bounds for a batch of services."""
from __future__ import annotations

import json
import os
from typing import Any

import boto3
from botocore.config import Config

cfg = Config(retries={"mode": "standard", "max_attempts": 8})
ecs = boto3.client("ecs", config=cfg)
scaling = boto3.client("application-autoscaling", config=cfg)
sns = boto3.client("sns", config=cfg)
sfn = boto3.client("stepfunctions", config=cfg)


def _count(operation: dict[str, Any], key: str) -> int:
    value = operation.get(key)
    if isinstance(value, bool) or not isinstance(value, int) or value < 0:
        raise ValueError(f"{key} must be a non-negative integer")
    return value


def lambda_handler(event: dict[str, Any], _context: Any) -> dict[str, Any]:
    operations = event.get("scale_operations")
    if not isinstance(operations, list) or not operations:
        raise ValueError("event.scale_operations must be a non-empty list")

    results = []
    for index, operation in enumerate(operations):
        if not isinstance(operation, dict):
            raise ValueError(f"scale_operations[{index}] must be an object")
        cluster, service = operation.get("cluster_name"), operation.get("service_name")
        if not all(isinstance(v, str) and v.strip() for v in (cluster, service)):
            raise ValueError("cluster_name and service_name are required strings")
        desired = _count(operation, "desired_count")
        minimum = _count(operation, "min_capacity")
        maximum = _count(operation, "max_capacity")
        if minimum > maximum or not minimum <= desired <= maximum:
            raise ValueError("require min_capacity <= desired_count <= max_capacity")

        service_response = ecs.describe_services(cluster=cluster, services=[service])
        services = service_response.get("services", [])
        if not services or services[0].get("status") != "ACTIVE":
            raise ValueError(f"ECS service is missing or not ACTIVE: {cluster}/{service}")

        resource_id = f"service/{cluster}/{service}"
        scaling.register_scalable_target(
            ServiceNamespace="ecs",
            ResourceId=resource_id,
            ScalableDimension="ecs:service:DesiredCount",
            MinCapacity=minimum,
            MaxCapacity=maximum,
        )
        ecs.update_service(cluster=cluster, service=service, desiredCount=desired)
        results.append({"cluster_name": cluster, "service_name": service,
                        "desired_count": desired, "min_capacity": minimum,
                        "max_capacity": maximum, "status": "accepted"})

    summary = {"status": "accepted", "scale_operations": results}
    if topic := os.getenv("SNS_TOPIC_ARN"):
        sns.publish(TopicArn=topic, Subject="ECS scaling request accepted", Message=json.dumps(summary))
    if machine := os.getenv("STEP_FUNCTION_ARN"):
        sfn.start_execution(stateMachineArn=machine, input=json.dumps(summary))
    return {"statusCode": 200, "body": json.dumps(summary)}
