#### credits of this snippet of code 

#### https://www.bti360.com/creating-a-terraform-variable-hierarchy-with-terragrunt/
locals {
  root_deployments_dir       = get_parent_terragrunt_dir()
  relative_deployment_path   = path_relative_to_include()
  deployment_path_components = compact(split("/", local.relative_deployment_path))
  # Get a list of every path between root_deployments_directory and the path of
  # the deployment
  possible_config_dirs = [
    for i in range(0, length(local.deployment_path_components) + 1) :
    join("/", concat(
      [local.root_deployments_dir],
      slice(local.deployment_path_components, 0, i)
    ))
  ]
  # Generate a list of possible config files at every possible_config_dir
  # (support both .yml and .yaml)
  possible_config_paths = flatten([
    for dir in local.possible_config_dirs : [
      "${dir}/config.yml",
      "${dir}/config.yaml"
    ]
  ])
  # Load every YAML config file that exists into an HCL object
  file_configs = [
    for path in local.possible_config_paths :
    yamldecode(file(path)) if fileexists(path)
  ]
  # Merge the objects together, with deeper configs overriding higher configs
  merged_config = merge(local.file_configs...)
}
# Pass the merged config to terraform as variable values using TF_VAR_
# environment variables
inputs = local.merged_config




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
      aws = {
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
