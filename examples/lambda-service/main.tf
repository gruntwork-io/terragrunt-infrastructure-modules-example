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

module "lambda_service" {
  source = "../../modules/lambda-service"

  name       = var.name
  runtime    = "nodejs20.x"
  source_dir = "${path.module}/src"
  handler    = "index.handler"
  route_key  = "GET /"
}