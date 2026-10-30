# DNS Change and IPv6 Enablement Runbook

Generalized from domain migration and DNS issue investigation work. Use `example.com` and a non-production zone for a lab.

## Inventory and readiness

1. Identify authoritative zones, record owners, resolver paths, TTLs, certificates, load balancers, clients, and dependencies.
2. Classify each record as public customer traffic, private service discovery, administrative access, or obsolete. Verify ownership before changing or deleting it.
3. For IPv6, verify the application, load balancer/listener, subnet route tables, security controls, firewall, upstream provider, monitoring, and client paths all support IPv6 end to end. An AAAA record alone does not make a service dual-stack.
4. Record current answers and TTLs, define rollback records, and lower TTL in advance where appropriate. Account for resolver caching beyond the advertised TTL.

## Controlled change

- Enable IPv6 on the target path and verify route propagation, security-group/NACL behavior, health checks, and source-address logging.
- Test A and AAAA resolution separately from representative internal and external networks.
- Test TLS/SNI, redirects, application health, and client behavior over IPv4 and IPv6.
- Publish or update the AAAA record only after the path passes health checks. Monitor both protocol families during the observation window.
- Roll back the AAAA record or listener path if error rate, reachability, or security signals breach the agreed threshold.

## Domain separation

Keep internal service names in private DNS/resolver paths and public endpoints at the intended edge. Validate certificates and application callbacks before switching names. Do not publish raw zone exports; they reveal internal naming and service relationships.
