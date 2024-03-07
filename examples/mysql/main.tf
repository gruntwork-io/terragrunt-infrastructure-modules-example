terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "mysql" {
  source = "../../modules/mysql"

  name              = var.name
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  storage_type      = "standard"

  master_username = var.master_username
  master_password = var.master_password

  # Do NOT copy this into product code. We only set this param to true here so that the automated tests can clean up.
  skip_final_snapshot = true
}