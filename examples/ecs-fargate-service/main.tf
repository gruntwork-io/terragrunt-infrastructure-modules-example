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

module "ecs_service" {
  source = "../../modules/ecs-fargate-service"

  name = var.name

  # Run the training/webapp Docker image from Docker Hub, a simple "Hello, World" web server
  container_definitions = jsonencode([{
    name      = var.name
    image     = "training/webapp"
    essential = true
    memory    = local.memory

    portMappings = [
      {
        containerPort = local.container_port
      }
    ]

    # If you set the PROVIDER environment variable, docker-training/webapp will return the text "Hello, <PROVIDER>!"
    Environment = [
      {
        name  = "PROVIDER"
        value = "World"
      }
    ]
  }])

  desired_count  = 2
  cpu            = 256
  memory         = local.memory
  container_port = local.container_port
  alb_port       = 80
}

locals {
  container_port = 5000
  memory         = 512
}