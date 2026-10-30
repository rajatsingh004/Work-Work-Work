# Search Cluster Reindexing Runbook

This runbook generalizes the source search scale-up and reindexing work. It applies to an Elasticsearch/OpenSearch-style cluster; confirm the exact APIs and recovery behavior for the deployed engine/version.

## Before the change

- Confirm the index, source/target mapping, aliases, shard/replica plan, disk headroom, cluster health, and current ingestion lag.
- Check snapshots are recent and that a restore has been tested. Confirm the target capacity can hold source and destination indices at once.
- Record baseline search latency, error rate, indexing throughput, JVM/heap pressure, CPU, storage, and unassigned shards.
- Plan a maintenance/change window, application owner, query validation, rollback path, and pause threshold.

## Reindex sequence

1. Provision or scale capacity and wait for all expected nodes to join and cluster health to stabilize.
2. Create a versioned destination index with reviewed mappings/settings. Do not copy unsafe dynamic mappings blindly.
3. Start reindex with throttling and task monitoring appropriate to the engine. Avoid unbounded concurrent reindex jobs.
4. Monitor task completion, rejections, disk watermarks, heap pressure, replicas, and application SLOs. Pause or throttle on sustained pressure.
5. Compare document counts, representative queries, aggregations, mappings, and freshness. Verify incremental writes are accounted for.
6. Switch the application alias through an atomic change where supported, then monitor read/write paths and error rates.
7. Retain the source index through the rollback window. Delete it only after owner sign-off and snapshot verification.

## Rollback

If validation fails, restore the alias to the previous index, confirm writes remain consistent, and scale down only after cluster health returns to baseline. Record task IDs and why the change was reverted. Never remove the source index as part of the initial cutover.
