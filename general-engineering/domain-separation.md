# Public and Internal DNS Separation

The source domain strategy aimed to reduce exposure of internal tools by separating public customer-facing names from private internal services. It also identified dormant records and unclear ownership as domain-takeover and attack-surface risks.

## Target model

- Public services use a deliberately managed public zone such as `example.com` with only approved ingress endpoints.
- Internal tools use a private namespace such as `corp.example.com`, served through private hosted zones and reachable through approved corporate connectivity.
- Resolver forwarding, VPN/network access, certificate issuance, and service authentication are designed together.
- Every record has an owner, purpose, environment, target, and review date.

## Migration controls

Inventory records and dependencies; verify ownership and usage; lower TTL before planned cutover; create and validate the private zone; migrate consumers; validate certificates and split-horizon behavior; retain rollback records; then remove stale public records after approval. A DNS name being internal does not replace authentication or authorization.

No real domain inventory, resolver endpoints, VPN route maps, or hosted-zone exports are included.
