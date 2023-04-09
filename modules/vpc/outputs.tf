output "vpc_id" {
    value = module.vpc.vpc_id
  
}

output "azs" {

    value = module.vpc.azs
  
}

output "public_ids" {

    value = module.vpc.public_subnets
  
}

output "private_ids" {

    value = module.vpc.private_subnets
  
}