terraform {
  source = "../../../../terraform/modules/vpc"
}

include "root" { path = find_in_parent_folders("root.hcl") }

inputs = {
  name = "demo-preprod-network"
  cidr = "10.80.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.80.1.0/24", "10.80.2.0/24", "10.80.3.0/24"]
  private_subnets = ["10.80.11.0/24", "10.80.12.0/24", "10.80.13.0/24"]
  database_subnets = ["10.80.21.0/24", "10.80.22.0/24", "10.80.23.0/24"]
  single_nat_gateway = true
  tags = {
    Product = "demo"
    Environment = "preprod"
    ManagedBy = "Terragrunt"
  }
}
