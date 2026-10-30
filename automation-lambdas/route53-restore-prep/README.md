# Route 53 Restore Preparation

The source utility split a large exported hosted-zone record set into smaller UPSERT batches. This version retains the complete record-set JSON (including alias and routing-policy fields), validates the export shape, allows an explicit safe batch size, and writes reviewable Route 53 change-batch documents.

```sh
python split_export.py route53-example.com-export.json --batch-size 100
```

The script deliberately does not submit changes. Review names, aliases, TTLs, health checks, and routing policy; compare the intended change against the target hosted zone; then use a separately controlled change workflow. Do not publish real DNS exports.
