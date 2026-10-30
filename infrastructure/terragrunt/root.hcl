remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket       = "demo-example-terraform-state"
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

inputs = {
  environment = "demo"
  tags = {
    Project     = "platform-engineering-lab"
    Environment = "demo"
    ManagedBy   = "Terragrunt"
  }
}
