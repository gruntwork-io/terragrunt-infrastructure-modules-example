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

module "service" {
  source = "../../modules/asg-alb-service"

  name          = var.name
  instance_type = "t3.micro"
  min_size      = 2
  max_size      = 4
  server_port   = 8080
  alb_port      = 80
}