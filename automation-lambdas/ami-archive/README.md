# EC2 AMI Archive and Restore

This Python utility preserves the source workflow: read AMI IDs from CSV, call the EC2 store-image task to archive images in an S3 bucket, track task progress, and optionally request restoration. It writes a timestamped result per AMI and continues the batch after an individual failure.

```sh
python -m venv .venv && . .venv/bin/activate
pip install boto3
python archive_restore.py --input amis.example.csv --bucket <archive-bucket> --output results.csv
# Add --restore only when restoration is explicitly intended.
```

The identity must have the documented EC2 image-store/restore actions and access to the archive bucket. Configure encryption, versioning, lifecycle, and restore permissions on the bucket. The polling loop is bounded; review service quotas and storage costs before processing large inventories.
