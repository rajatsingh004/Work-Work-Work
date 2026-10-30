# TLS Certificate Renewal Runbook

## Preparation

Inventory certificates by hostname, environment, issuer, expiry, deployment target, owner, and renewal mechanism. Verify domain control, certificate SANs, key algorithm, chain, and private-key handling. Stage a valid replacement before the current certificate reaches the renewal window.

## Change

1. Raise the authorized change and notify owners of affected services.
2. Export or snapshot the current configuration without exporting private key material into tickets.
3. Install the replacement through the approved secret/certificate manager.
4. Validate listener binding, SNI, trust chain, hostname, expiry, and representative client compatibility.
5. Monitor handshake errors and application health; retain the prior valid certificate until the rollback window closes.
6. Remove obsolete certificate material through the approved lifecycle process.

## Verification commands

```sh
openssl s_client -connect app.example.com:443 -servername app.example.com </dev/null
openssl s_client -connect app.example.com:443 -servername app.example.com </dev/null 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
```

Track progress by environment and owner. Do not publish the original internal domain inventory or certificate exports.
