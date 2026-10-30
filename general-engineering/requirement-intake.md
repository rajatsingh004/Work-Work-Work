# Infrastructure Requirement Intake

The source process replaced free-form email requirements with a structured intake. A complete request gathers enough detail to scope infrastructure, delivery, security, and operations before implementation.

## Request template

- **Summary and business outcome:** what capability is needed and why.
- **Service owner and environment:** responsible team, lifecycle, and criticality.
- **Application and runtime:** framework, version, artifact, build/test commands.
- **Traffic and availability:** expected request rate, latency, scaling, maintenance, RTO/RPO.
- **Network:** ingress/egress, DNS, certificates, dependent services, private/public access.
- **Data:** classification, storage, backup, retention, encryption, restore expectations.
- **Identity and security:** workload identity, human access, secret source, SAST/dependency checks, audit requirements.
- **Delivery:** SCM branch/tag, CI stages, deployment strategy, rollback, approvals.
- **Observability:** metrics, logs, traces, dashboards, alert ownership, SLOs.
- **Cost and capacity:** estimate, quota, cost owner, support tier.
- **Evidence and approvals:** architecture reference, security review, application sign-off.

Treat identifiers and architecture attachments as access-controlled artifacts; publish only an anonymized template.
