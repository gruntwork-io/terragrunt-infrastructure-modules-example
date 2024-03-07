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

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  name = var.name

  # Do NOT copy this into product code. We only set this param to true here so that the automated tests can clean up.
  force_destroy = true
}