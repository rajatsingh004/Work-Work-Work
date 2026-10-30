terraform {
  source = "../../../../../terraform/modules/codedeploy"
}
include "root" { path = find_in_parent_folders("root.hcl") }
dependency "deploy_role" {
  config_path = "../code-deploy-role"
  mock_outputs = { role_arn = "arn:aws:iam::000000000000:role/demo-prod-codedeploy-role" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}
dependency "asg" {
  config_path = "../asg"
  mock_outputs = { asg_name = "demo-web-prod" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}
inputs = {
  application_name = "demo-web"
  deployment_group_name = "demo-web-prod"
  service_role_arn = dependency.deploy_role.outputs.role_arn
  autoscaling_group_names = [dependency.asg.outputs.asg_name]
  deployment_type = "IN_PLACE"
  deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  ec2_tag_filters = { Environment = "prod", Product = "demo" }
}
