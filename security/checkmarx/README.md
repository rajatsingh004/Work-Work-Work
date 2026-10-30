# Checkmarx SAST in CI/CD

The source CI/CD requirements included Checkmarx as a security gate alongside unit tests and SonarQube. The sample pipeline in [`delivery/Jenkinsfile`](../../delivery/Jenkinsfile) runs SAST before artifact publication and deployment; a failing scan prevents release.

## Integration choices

- Keep Checkmarx tenant URL, API token, project identity, and thresholds in Jenkins configuration/credentials.
- Pin the scanner CLI or plugin version on the build agent and keep command flags aligned with that version.
- Scan the same source revision that will be packaged and deploy immutable artifacts from that revision.
- Fail the gate on the agreed severity thresholds; document approved suppressions with an owner and expiry.
- Publish scan IDs and summaries as build metadata, not source code or secret values.
- Route findings to a named engineering owner and measure remediation age.

## Gate and release flow

The pipeline checks out an immutable commit, builds and tests it, runs SAST and quality analysis, publishes the exact artifact from that revision, and only then allows deployment. Production requires a human approval. The gate should fail on agreed blocking severities, while an exception carries rationale, owner, expiry, and a linked risk decision. Treat a scan timeout or unavailable scanner as a failed/held gate for protected branches rather than silently skipping analysis.

The sample [`checkmarx-scan.sh`](../../delivery/checkmarx-scan.sh) expects a preinstalled `cx` CLI and injects the token through Jenkins credentials. Tenant URLs, project identifiers, tokens, internal scan history, and screenshots are intentionally not present. CLI flags must be checked against the selected product version.

`delivery/checkmarx-scan.sh` is a thin wrapper around a pinned `cx` CLI installation; confirm the exact flags supported by your selected Checkmarx release before enabling the gate.
