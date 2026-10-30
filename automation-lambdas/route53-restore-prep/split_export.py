"""Split a Route 53 record export into bounded UPSERT batches for review.

This tool prepares change files only; it never calls ChangeResourceRecordSets.
All record-set fields are retained so aliases and routing policies are not lost.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path


def extract_sets(data: object) -> list[dict]:
    if isinstance(data, list) and data and isinstance(data[0], dict):
        sets = data[0].get("ResourceRecordSets")
    elif isinstance(data, dict):
        sets = data.get("ResourceRecordSets")
    else:
        sets = None
    if not isinstance(sets, list):
        raise ValueError("expected a Route 53 export containing ResourceRecordSets")
    if any(not isinstance(record, dict) for record in sets):
        raise ValueError("each ResourceRecordSet must be a JSON object")
    return sets


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("--output-dir", type=Path, default=Path("change-batches"))
    parser.add_argument("--batch-size", type=int, default=100)
    parser.add_argument("--comment", default="Prepared from reviewed example.com zone export")
    args = parser.parse_args()
    if not 1 <= args.batch_size <= 1000:
        parser.error("batch-size must be between 1 and 1000")
    records = extract_sets(json.loads(args.input.read_text(encoding="utf-8")))
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for start in range(0, len(records), args.batch_size):
        chunk = records[start:start + args.batch_size]
        payload = {"Comment": args.comment, "Changes": [
            {"Action": "UPSERT", "ResourceRecordSet": record} for record in chunk
        ]}
        path = args.output_dir / f"change-batch-{start // args.batch_size + 1:03d}.json"
        path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"Prepared {len(records)} records in {(len(records) + args.batch_size - 1) // args.batch_size} reviewed batches")


if __name__ == "__main__":
    main()
