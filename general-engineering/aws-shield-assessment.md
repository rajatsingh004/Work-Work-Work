# AWS Shield and DDoS Protection Assessment

## Decision inputs

Inventory public entry points (CloudFront, Route 53, load balancers, Global Accelerator, and public IPs), understand application-layer traffic patterns, define incident ownership, and identify response/availability objectives.

Compare baseline managed protections with the additional detection, response, and cost model of an advanced protection subscription. Evaluate eligibility and current AWS service support before making a recommendation. Include WAF rules and origin protection in the design; a subscription alone does not replace application security controls.

## Operating plan

- Maintain an approved protected-resource inventory and owner.
- Define how to engage AWS DDoS Response Team support if included in the chosen service plan.
- Review attack signals, health metrics, and Shield/WAF findings with the application team.
- Test communication and mitigation decisions without generating unsafe traffic.
- Review cost, resource coverage, and response readiness periodically.

This is a framework, not an account-specific protection map. Verify current AWS Shield feature support and pricing directly before adoption.
