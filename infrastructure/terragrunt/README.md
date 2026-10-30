# Terragrunt Environment Composition

The source repo used one shared remote-state file, a reusable VPC unit, and a production web stack composed of ALB, ASG, CodeDeploy IAM role, and CodeDeploy. Terragrunt dependencies passed the ALB name into the ASG and CodeDeploy role/ASG outputs into the deployment unit. Jenkins accepted lifecycle actions and ran Terragrunt in a selected working directory.

This public example keeps that hierarchy and dependency graph while replacing the original private module-repository URLs, environment labels, accounts, CIDRs, subnet IDs, AMIs, certificates, role names, tags, and SCM configuration. The state bucket/table values are placeholders that must be created and access-controlled in a sandbox account.

```text
infrastructure/terragrunt/
  root.hcl
  live/dev/web/{alb,asg,code-deploy-role,code-deploy}/terragrunt.hcl
  live/prod/web/{...}
  Jenkinsfile
```

## Workflow

- The sample Jenkinsfile assumes the repository is checked out at workspace root, then runs `terragrunt run --all plan` across the selected `dev` or `prod` web stack.
- Apply one unit at a time for the first environment; verify each dependency output before continuing.
- Require change approval for production apply/destroy; never let a public Jenkins parameter expose arbitrary auto-approved destruction.
- Keep Terraform state encrypted, locked, versioned, and inaccessible to application workloads.

Run from a disposable AWS account after selecting valid local module versions and setting required values. No source path points to a private repository.
