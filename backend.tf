# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "caltuco-project-1"
    dynamodb_table = "project-1-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    profile        = "caltuco_aws"
    region         = "us-east-1"
  }
}
