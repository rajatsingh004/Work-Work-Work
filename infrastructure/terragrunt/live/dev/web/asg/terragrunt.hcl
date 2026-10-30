terraform {
  source = "../../../../../terraform/modules/asg"
}

include "root" { path = find_in_parent_folders("root.hcl") }

dependency "alb" {
  config_path = "../alb"
  mock_outputs = {
    security_group_id = "sg-0123456789abcdef0"
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:000000000000:targetgroup/demo/0123456789abcdef"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  name                  = "demo-web-dev"
  vpc_id                = "vpc-0123456789abcdef0"
  subnet_ids            = ["subnet-0123456789abcdef0", "subnet-0abcdef0123456789"]
  alb_security_group_id = dependency.alb.outputs.security_group_id
  target_group_arns     = [dependency.alb.outputs.target_group_arn]
  ami_id                = "ami-0123456789abcdef0"
  instance_type_priority = ["m7i.large", "m6i.large"]
  min_size              = 2
  max_size              = 6
  desired_capacity      = 2
  on_demand_base_capacity = 2
  on_demand_percentage  = 100
  tags = {
    Name        = "demo-web-dev"
    Product     = "demo"
    Component   = "web"
    Environment = "dev"
    Os          = "Linux"
  }
}
