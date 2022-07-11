generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
    profile = "${get_env("TF_VAR_AWS_PROFILE")}"
    region  = "${get_env("TF_VAR_AWS_REGION")}"
}
EOF
}

#formating hcl files
terraform {

  after_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["terragrunt", "hclfmt"]
    run_on_error = true
  }
}

generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_version = ">= 0.14"
    required_providers {
      azurerm = {
        source  = "hashicorp/aws"
        version = ">= 4.22.0"
        }
      }
    }
EOF
}


remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "caltuco-project-1"

    key     = "${path_relative_to_include()}/terraform.tfstate"
    profile = get_env("TF_VAR_AWS_PROFILE")
    region  = get_env("TF_VAR_AWS_REGION")

    encrypt        = true
    dynamodb_table = "project-1-table"
  }
}
