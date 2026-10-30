# AMD and Graviton Compute Migration

## AMI-based x86 migration

Capture a recoverable image/configuration baseline, stop or drain the instance according to workload requirements, change to a compatible AMD instance family, start and wait for health checks, then run application and dependency sanity tests. Maintain a rollback launch configuration until the workload has passed an observation window.

## Graviton migration

Graviton changes CPU architecture to Arm64 and requires application/runtime/library compatibility, not just an instance-family change. Use AWS Porting Advisor or equivalent compatibility analysis, rebuild images and dependencies for Arm64, and validate native libraries, agents, containers, and deployment tooling. Create a separate candidate fleet, deploy, run performance and functional tests, shift traffic, and maintain rollback capacity.

### Historical RDS sizing comparison from the planning material

The source planning sheet compared example RDS instance classes using the prices available when it was written. The values below are preserved as historical estimates to show the cost-review method; they are not current quotes or achieved savings.

| Example class | vCPU / memory | Historical monthly estimate | Comparable Arm class | Historical monthly estimate | Difference |
|---|---:|---:|---|---:|---:|
| `db.r5.large` | 2 / 16 GiB | $194.40 | `db.r6g.large` | $173.52 | $20.88 |
| `db.r5.xlarge` | 4 / 32 GiB | $388.80 | `db.r6g.xlarge` | $347.04 | $41.76 |
| `db.r5.12xlarge` | 48 / 384 GiB | $4,665.60 | `db.r6g.12xlarge` | $4,176.00 | $489.60 |

The original proposal discussed potential savings in a broader 15–20% range, but the specific examples above imply a smaller price-only difference. Actual economics depend on engine/version, region, licensing, storage, I/O, reserved pricing, workload performance, and the replacement class. Validate current supported engine versions and benchmark before changing production.

## Validation

Compare latency, throughput, error rate, CPU/memory, startup time, autoscaling behavior, and unit economics under representative load. Revisit AMIs, agents, and build pipelines that assume x86. The public example includes no specific instance inventory or account IDs.
