# Recreated Platform Architecture

These diagrams are new, generalized views recreated from the workstreams represented in this repository. They do not reproduce internal network layouts, account boundaries, DNS zones, or customer architecture.

## Infrastructure delivery path

```mermaid
flowchart LR
  Dev[Engineer / change request] --> Jenkins[Jenkins pipeline]
  Jenkins --> Checks[Tests + SonarQube + Checkmarx]
  Checks --> Artifact[Versioned build artifact]
  Artifact --> Deploy[CodeDeploy]
  Jenkins --> TG[Terragrunt live stack]
  TG --> TF[Reusable Terraform modules]
  TF --> VPC[Multi-AZ VPC]
  TF --> ALB[HTTPS Application Load Balancer]
  TF --> ASG[Mixed-instance Auto Scaling Group]
  ALB --> ASG
  ASG --> App[Demo application]
  Deploy --> ASG
  App --> Signals[Logs / metrics / health checks]
```

## EKS progressive delivery and workload secrets

```mermaid
flowchart LR
  User[Client] --> Gateway[Ingress / Istio gateway]
  Gateway --> Stable[Stable service]
  Gateway --> Candidate[Canary or preview service]
  Rollout[Argo Rollouts] -->|weight / promotion| Gateway
  Rollout --> Stable
  Rollout --> Candidate
  Pod[Application pod] --> CSI[Secrets Store CSI volume]
  CSI --> SM[AWS Secrets Manager]
  SA[Kubernetes service account] --> IRSA[OIDC workload identity]
  IRSA --> SM
```

The three-farm 98/1/1 Istio experiment is a separate explicit routing example; it is not controlled by the Argo Rollouts flow above.

## Operations and recovery loop

```mermaid
flowchart LR
  Metrics[CloudWatch / application metrics] --> Alarm[Alert]
  Alarm --> Triage[Runbook triage]
  Triage --> Decide{Capacity or fault?}
  Decide -->|capacity| Scale[ASG / ECS scaling workflow]
  Decide -->|service fault| Recover[Rollback / restore / failover]
  Scale --> Verify[Health and SLO verification]
  Recover --> Verify
  Verify --> Review[Incident notes and follow-up actions]
```

See [Terraform](terraform/README.md), [Terragrunt](terragrunt/README.md), [delivery](../delivery/README.md), and [operations](../operations/README.md) for the implementation examples.
