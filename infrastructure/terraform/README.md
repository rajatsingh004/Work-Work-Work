# Terraform Modules

The source repo contained separate Terraform examples for an ALB, mixed-instance EC2 Auto Scaling Group, CloudFront, CodeDeploy, IAM roles, and Kubernetes access management. The public layout keeps those concerns separated and replaces environment-bound IDs with typed inputs.

## Modules

| Module | Design focus | Entry point |
|---|---|---|
| `modules/alb` | Internet/internal ALB, restricted ingress, HTTPS listener, HTTP-to-HTTPS redirect, target health checks | [main.tf](modules/alb/main.tf) |
| `modules/asg` | IAM instance profile, hardened launch template, mixed instance overrides, health checks, target-group attachment | [main.tf](modules/asg/main.tf) |
| `modules/iam-role` | Service-principal trust policy and explicit attached policies | [main.tf](modules/iam-role/main.tf) |
| `modules/codedeploy` | Deployment group, rollback events, deployment strategy and autoscaling association | [main.tf](modules/codedeploy/main.tf) |
| `modules/cloudfront` | Private S3 origin using Origin Access Control, HTTPS viewer policy, cache/origin policy inputs, WAF association | [README.md](modules/cloudfront/README.md) |
| `modules/eks-access` | Namespace-scoped Kubernetes RBAC and EKS access entry pattern | [README.md](modules/eks-access/README.md) |

## Engineering notes from the source implementation

- The original ALB example redirected port 80 to 443 while its HTTPS listener was commented out. The public module creates both listeners and accepts the certificate ARN as an input.
- The EC2 example generated an SSH private key in Terraform and wrote it to Secrets Manager; that private material would also reside in Terraform state. The public ASG example uses SSM-oriented instance access and intentionally creates no SSH key.
- Account IDs, VPC/subnet IDs, AMI IDs, certificate ARNs, bucket names, tags, and role names are caller-supplied examples.
- Access-management logic has been reframed around explicit read/write role resources; namespace creation is a native Kubernetes resource rather than a local-exec side effect.

## Usage

The live environment examples are under [`../terragrunt`](../terragrunt/README.md). Before applying, set current region-appropriate AMIs and capacity, inspect IAM trust/policy boundaries, configure remote state, and run `terraform init`, `validate`, and `plan` in a sandbox. These modules are portfolio code and have not been applied to an AWS account from this repository.
