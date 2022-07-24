variable "global_tags" {
  type = map
  default = {
    Terraform   = "false"
    Environment = "staging"
  }
}

variable "name_vpc" {
  type = string
    default = ""
  
}

variable "project" {
  type = string
  default = ""
}
