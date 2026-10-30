terraform {
  source = "../../../../../terraform/modules/iam-role"
}
include "root" { path = find_in_parent_folders("root.hcl") }
inputs = {
  name = "demo-prod-codedeploy-role"
  principal_type = "Service"
  principal_identifiers = ["codedeploy.amazonaws.com"]
  policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"]
}
