variable "global_tags" {
  type = map
  default = {
    Terraform   = "false"
    Environment = "staging"
  }
}


variable "project" {
  type = string
  default = ""
}


variable "cluster_name" {
    type = string
    description = "Name of kubernetes cluster"
  
}

variable "vpc_id" {
  type = string
  description = "vpc id where to deploy eks cluster"
  
}

variable "vpc_azs" {
  type = list
    
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "public_subnets_ids" {
  type = list(string)
}