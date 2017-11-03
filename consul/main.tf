# ---------------------------------------------------------------------------------------------------------------------
# A SIMPLE EXAMPLE OF HOW DEPLOY THE CONSUL MODULE FROM THE TERRAFORM REGISTRY
# This is an example of how to use Terraform to deploy the Consul module from the Terraform registry.
#
# Note: This code is meant solely as a simple demonstration of how to lay out your files and folders with Terragrunt
# in a way that keeps your Terraform code DRY. This is not production-ready code, so use at your own risk.
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE MODULE
# This deploys the "root example" from the Consul module in the Terraform registry. Please note that this root example
# is optimized for demonstration and learning purposes, but not production deployment. See the module itself for
# details.
# ---------------------------------------------------------------------------------------------------------------------

module "consul" {
  # Ideally, we'd use a registry URL here like "hashicorp/consul/aws", but Registry URLs won't support versioning until
  # Terraform 0.11, so for now, we just fall back to a plain Git URL and use the ref param for versioning.
  source = "git@github.com:hashicorp/terraform-aws-consul.git?ref=v0.0.5"

  aws_region   = "${var.aws_region}"
  cluster_name = "${var.cluster_name}"

  num_servers = "${var.num_servers}"
  num_clients = "${var.num_clients}"

  ssh_key_name = "${var.ssh_key_name}"
}