# Cloud Resource Tagging Standard

Consistent tags support ownership, cost attribution, change control, security review, automation, and decommissioning. The source standard used a purpose-oriented name plus product, component, environment, OS, and owner fields.

## Suggested keys

| Tag | Example value | Purpose |
|---|---|---|
| `Name` | `demo-prod-api` | Human-readable resource purpose |
| `Product` | `demo` | Cost and service ownership |
| `Component` | `api` | Technical component grouping |
| `Environment` | `prod` | Lifecycle and policy scope |
| `Owner` | `team-platform` | Responsible group, not an individual's email |
| `ManagedBy` | `terraform` | Change ownership and drift triage |
| `DataClassification` | `internal` | Data handling context where appropriate |

Use a consistent case convention and validate required tags in CI or policy controls. Propagate tags to instances and volumes from launch templates. Define exceptions and remediation ownership; do not let missing tags block critical recovery without a break-glass path.
