terraform {
  source = "../../../../../terraform/modules/alb"
}

include "root" { path = find_in_parent_folders("root.hcl") }

inputs = {
  name                 = "demo-web-dev"
  vpc_id               = "vpc-0123456789abcdef0"
  vpc_cidr             = "10.40.0.0/16"
  subnet_ids           = ["subnet-0123456789abcdef0", "subnet-0abcdef0123456789"]
  allowed_client_cidrs = ["203.0.113.0/24"]
  certificate_arn      = "arn:aws:acm:us-east-1:000000000000:certificate/example-certificate-id"
  target_port          = 8080
  health_check_path    = "/health"
  internal             = false
  deletion_protection  = false
}
