# ---------------------------------------------------------------------------------------------------------------------
# USE THE DEFAULT VPC AND SUBNETS
# To keep this example simple, we use the default VPC and subnets, but in real-world code, you'll want to use a
# custom VPC.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}