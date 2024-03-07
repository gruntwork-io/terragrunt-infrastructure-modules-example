# ECS Fargate Service Module

This is an example of how to use Terraform/OpenTofu to deploy an [ECS Fargate Service](https://aws.amazon.com/ecs/) with an 
[Application Load Balancer (ALB)](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/) in front of 
it. See the [root README](/README.md) for instructions on how to run this example code. 

Note: This code is meant solely as a simple demonstration of how to lay out your files and folders with 
[Terragrunt](https://github.com/gruntwork-io/terragrunt) in a way that keeps your [Terraform](https://www.terraform.io)
and [OpenTofu](https://opentofu.org/) code DRY. This is not production-ready code, so use at your own risk.
