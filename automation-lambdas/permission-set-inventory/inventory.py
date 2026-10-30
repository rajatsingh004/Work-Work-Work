"""Export IAM Identity Center permission set assignments to CSV.

Authentication comes from boto3's default credential chain. Set SSO_INSTANCE_ARN
and IDENTITY_STORE_ID in the environment; no account/user data is hard-coded.
"""
from __future__ import annotations

import csv
import logging
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone

import boto3
from botocore.config import Config

LOG = logging.getLogger("permission_set_inventory")
CFG = Config(retries={"mode": "standard", "max_attempts": 10})
REGION = os.getenv("AWS_REGION") or os.getenv("AWS_DEFAULT_REGION")
INSTANCE_ARN = os.environ["SSO_INSTANCE_ARN"]
IDENTITY_STORE_ID = os.environ["IDENTITY_STORE_ID"]
sso = boto3.client("sso-admin", region_name=REGION, config=CFG)
org = boto3.client("organizations", region_name=REGION, config=CFG)
identity = boto3.client("identitystore", region_name=REGION, config=CFG)


def pages(client, operation: str, **kwargs):
    paginator = client.get_paginator(operation)
    for page in paginator.paginate(**kwargs):
        yield page


def resolve_principal(kind: str, principal_id: str) -> str:
    try:
        if kind == "USER":
            return identity.describe_user(IdentityStoreId=IDENTITY_STORE_ID, UserId=principal_id).get("UserName", principal_id)
        return identity.describe_group(IdentityStoreId=IDENTITY_STORE_ID, GroupId=principal_id).get("DisplayName", principal_id)
    except identity.exceptions.ResourceNotFoundException:
        LOG.warning("Identity Center principal could not be resolved: type=%s id=%s", kind, principal_id)
        return principal_id


def inventory_one(permission_set_arn: str, accounts: list[dict]) -> list[dict[str, str]]:
    detail = sso.describe_permission_set(InstanceArn=INSTANCE_ARN, PermissionSetArn=permission_set_arn)["PermissionSet"]
    tags = sso.list_tags_for_resource(InstanceArn=INSTANCE_ARN, ResourceArn=permission_set_arn).get("Tags", [])
    tag_text = ";".join(f"{tag['Key']}={tag['Value']}" for tag in tags)
    rows = []
    for account in accounts:
        assignments = pages(sso, "list_account_assignments", InstanceArn=INSTANCE_ARN,
                            AccountId=account["Id"], PermissionSetArn=permission_set_arn)
        for page in assignments:
            for assignment in page.get("AccountAssignments", []):
                principal_type = assignment["PrincipalType"]
                principal = resolve_principal(principal_type, assignment["PrincipalId"])
                rows.append({
                    "permission_set_name": detail.get("Name", ""),
                    "permission_set_arn": permission_set_arn,
                    "description": detail.get("Description", ""),
                    "created_at_utc": detail.get("CreatedDate", datetime.now(timezone.utc)).isoformat(),
                    "account_name": account["Name"],
                    "principal_type": principal_type,
                    "principal_name": principal,
                    "principal_id": assignment["PrincipalId"],
                    "tags": tag_text,
                })
    return rows


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    accounts = [account for page in pages(org, "list_accounts") for account in page.get("Accounts", [])]
    permission_sets = [arn for page in pages(sso, "list_permission_sets", InstanceArn=INSTANCE_ARN)
                       for arn in page.get("PermissionSets", [])]
    output = f"permission-set-inventory-{datetime.now(timezone.utc):%Y%m%dT%H%M%SZ}.csv"
    fields = ["permission_set_name", "permission_set_arn", "description", "created_at_utc",
              "account_name", "principal_type", "principal_name", "principal_id", "tags"]
    rows: list[dict[str, str]] = []
    with ThreadPoolExecutor(max_workers=min(5, max(1, len(permission_sets)))) as pool:
        futures = {pool.submit(inventory_one, arn, accounts): arn for arn in permission_sets}
        for future in as_completed(futures):
            arn = futures[future]
            try:
                rows.extend(future.result())
            except Exception:
                LOG.exception("Failed to inventory permission set %s", arn)
    with open(output, "w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)
    LOG.info("Wrote %d assignment rows to %s", len(rows), output)


if __name__ == "__main__":
    main()
