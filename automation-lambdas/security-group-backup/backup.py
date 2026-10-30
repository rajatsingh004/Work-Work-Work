"""Export selected EC2 security group configuration to JSON and optional S3."""
from __future__ import annotations

import argparse
import json
import logging
from datetime import datetime, timezone
from pathlib import Path

import boto3
from botocore.config import Config


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ids-file", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, default=Path("security-group-backup"))
    parser.add_argument("--bucket", help="Optional encrypted S3 backup bucket")
    parser.add_argument("--prefix", default="security-group-snapshots")
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    ec2 = boto3.client("ec2", config=Config(retries={"mode": "standard", "max_attempts": 8}))
    s3 = boto3.client("s3")
    ids = [line.strip() for line in args.ids_file.read_text().splitlines() if line.strip() and not line.startswith("#")]
    if not ids:
        parser.error("IDs file contains no security group IDs")
    args.output_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    found_ids: set[str] = set()
    for offset in range(0, len(ids), 100):
        response = ec2.describe_security_groups(GroupIds=ids[offset:offset + 100])
        for group in response.get("SecurityGroups", []):
            found_ids.add(group["GroupId"])
            payload = {
                "captured_at_utc": stamp,
                "group_id": group["GroupId"],
                "group_name": group.get("GroupName", ""),
                "description": group.get("Description", ""),
                "vpc_id": group.get("VpcId", ""),
                "inbound_rules": group.get("IpPermissions", []),
                "outbound_rules": group.get("IpPermissionsEgress", []),
                "tags": group.get("Tags", []),
            }
            file_path = args.output_dir / f"{group['GroupId']}-{stamp}.json"
            file_path.write_text(json.dumps(payload, indent=2, default=str) + "\n", encoding="utf-8")
            if args.bucket:
                key = f"{args.prefix}/{file_path.name}"
                s3.upload_file(str(file_path), args.bucket, key,
                               ExtraArgs={"ServerSideEncryption": "aws:kms"})
                logging.info("Uploaded snapshot to s3://%s/%s", args.bucket, key)
    missing = sorted(set(ids) - found_ids)
    if missing:
        raise RuntimeError(f"Some requested groups were not returned: {', '.join(missing)}")


if __name__ == "__main__":
    main()
