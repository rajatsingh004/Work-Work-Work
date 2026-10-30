# Security Group Backup

This preserves the original backup flow: read a supplied list of security-group IDs, retrieve ingress and egress rules from EC2, write one JSON snapshot per group, and optionally upload the snapshots to S3. It uses the default credential chain, paginates requests in bounded batches, and fails when an input ID was not found instead of silently reporting a complete backup.

```sh
pip install boto3
python backup.py --ids-file security-group-ids.example.txt --output-dir ./snapshots
python backup.py --ids-file ./authorized-ids.txt --bucket <encrypted-backup-bucket>
```

The source and resulting snapshots contain network policy details. Keep real snapshots private, encrypt the destination, and grant only read access to the required security groups and write access to the backup prefix.
