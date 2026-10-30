# Centralized Audit Logging

## Context
Operators need reliable evidence of who changed critical infrastructure, what changed, and when. Audit data must remain available across account or cluster boundaries with appropriate access and retention.

## Engineering challenge
Logs are useful only when collection is complete, identities and timestamps are interpretable, access is controlled, and retention meets investigation needs. Pipelines can silently lose events under load or misconfiguration.

## Approach
1. Define event sources and the questions security and operations teams must answer.
2. Enable source audit events and forward them through an authenticated, encrypted pipeline.
3. Separate ingestion, storage, and query permissions; restrict changes to retention and destinations.
4. Monitor coverage, delivery lag, dropped events, and destination capacity.
5. Set retention/deletion rules with security, legal, and privacy stakeholders.
6. Validate with controlled test events and review access periodically.

## Risk controls
Protect integrity, restrict destructive access, minimize sensitive payloads, alert on collection gaps, and change-control retention settings.

## Verification and learning
Trace a known test action end-to-end, confirm identity/time fields, and demonstrate unauthorized users cannot alter or access the archive. No proprietary SIEM procedures or exported audit data are included.
