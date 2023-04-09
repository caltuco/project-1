include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//eks"
}

inputs = {

    cluster_name = "testapp"
    vpc_id = dependency.vpc.outputs.vpc_id
    vpc_azs = dependency.vpc.outputs.azs
    public_subnets_ids = dependency.vpc.outputs.public_ids
    private_subnets_ids = dependency.vpc.outputs.private_ids


}