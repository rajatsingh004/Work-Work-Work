terraform {
  source = "../../../../../terraform/modules/alb"
}
include "root" { path = find_in_parent_folders("root.hcl") }

inputs = {
  name                 = "demo-web-prod"
  vpc_id               = "vpc-0abcdef0123456789"
  vpc_cidr             = "10.90.0.0/16"
  subnet_ids           = ["subnet-0abcdef0123456789", "subnet-0123456789abcdef0"]
  allowed_client_cidrs = ["203.0.113.0/24"]
  certificate_arn      = "arn:aws:acm:us-east-1:000000000000:certificate/example-prod-certificate"
  target_port          = 8080
  health_check_path    = "/health"
  internal             = false
  deletion_protection  = true
}
