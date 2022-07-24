include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_terragrunt_dir()}/../../../modules//vpc"
}

inputs = {


  name_vpc = "vpc1"

}