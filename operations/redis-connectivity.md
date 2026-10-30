# Managed Cache Connectivity Troubleshooting

General-purpose procedure for application timeouts or connection failures to a managed Redis-compatible cache.

1. Confirm impact, recent deploy/config changes, cache endpoint, TLS mode, port, and client timeout settings.
2. From an approved in-network diagnostic pod, test DNS resolution and TCP/TLS reachability to the current endpoint. Do not expose cache credentials in command history.
3. Check security-group/network-policy paths, subnet routes, peering/VPN/TGW route symmetry, and DNS resolver configuration.
4. Review cache engine events, connection count, rejected connections, CPU, memory, evictions, network throughput, and failover/maintenance events.
5. Verify client pool limits, TLS trust, authentication secret version, connection reuse, and retry/backoff behavior.
6. Do not restart or fail over solely to clear a symptom. Follow the managed service procedure and evaluate data/availability impact first.
7. Confirm recovery with application-level requests and monitor reconnect storms, latency, and error rate.

Escalate with timestamped sanitized client-side error, endpoint type (not the real hostname), relevant metrics, and network path summary.
