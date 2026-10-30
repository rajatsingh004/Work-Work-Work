"""Archive EC2 AMIs to S3 and optionally restore completed archive tasks.

Uses the AWS default credential chain. Input CSV header: AMI_ID. The caller
must provide an archive bucket and an output CSV. The bounded poll loop avoids
the unbounded wait present in the original operational script.
"""
from __future__ import annotations

import argparse
import csv
import logging
import time
from datetime import datetime, timezone
from pathlib import Path

import boto3
from botocore.config import Config

LOG = logging.getLogger("ami_archive")
RETRY_CONFIG = Config(retries={"mode": "standard", "max_attempts": 8})


def archive_and_restore(ami_id: str, bucket: str, restore: bool, poll_seconds: int,
                        max_attempts: int, ec2) -> dict[str, str]:
    try:
        started = ec2.create_store_image_task(ImageId=ami_id, Bucket=bucket)
        object_key = started["ObjectKey"]
        task_state = "InProgress"
        for attempt in range(max_attempts):
            time.sleep(poll_seconds)
            results = ec2.describe_store_image_tasks(ImageIds=[ami_id]).get("StoreImageTaskResults", [])
            if not results:
                raise RuntimeError("archive task result was not returned")
            task = results[0]
            task_state = task.get("StoreTaskState", "Unknown")
            LOG.info("AMI %s archive progress=%s state=%s", ami_id,
                     task.get("ProgressPercentage", 0), task_state)
            if task_state == "Completed":
                break
            if task_state in {"Failed", "Cancelled"}:
                raise RuntimeError(f"archive task ended in {task_state}")
        else:
            raise TimeoutError(f"archive task did not finish after {max_attempts} checks")

        restored_id = ""
        if restore:
            restored_id = ec2.create_restore_image_task(
                ObjectKey=object_key, Bucket=bucket,
                Name=f"restored-{ami_id}-{datetime.now(timezone.utc):%Y%m%d%H%M%S}",
            )["ImageId"]
        return {"ami_id": ami_id, "object_key": object_key, "archive_state": task_state,
                "restored_ami_id": restored_id, "error": ""}
    except Exception as exc:  # preserve per-image progress in batch runs
        LOG.exception("AMI archive/restore failed for %s", ami_id)
        return {"ami_id": ami_id, "object_key": "", "archive_state": "failed",
                "restored_ami_id": "", "error": str(exc)}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True, help="CSV containing AMI_ID column")
    parser.add_argument("--bucket", required=True, help="S3 bucket configured for AMI archive")
    parser.add_argument("--output", type=Path, default=Path("ami-archive-results.csv"))
    parser.add_argument("--restore", action="store_true", help="Restore each successfully archived AMI")
    parser.add_argument("--poll-seconds", type=int, default=30)
    parser.add_argument("--max-attempts", type=int, default=120)
    args = parser.parse_args()
    if args.poll_seconds < 1 or args.max_attempts < 1:
        parser.error("poll interval and maximum attempts must be positive")

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    ec2 = boto3.client("ec2", config=RETRY_CONFIG)
    with args.input.open(newline="", encoding="utf-8") as stream:
        ami_ids = [row["AMI_ID"].strip() for row in csv.DictReader(stream) if row.get("AMI_ID", "").strip()]
    if not ami_ids:
        parser.error("input CSV contains no AMI_ID rows")

    fields = ["ami_id", "object_key", "archive_state", "restored_ami_id", "error"]
    with args.output.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        for ami_id in ami_ids:
            writer.writerow(archive_and_restore(ami_id, args.bucket, args.restore,
                                                args.poll_seconds, args.max_attempts, ec2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
