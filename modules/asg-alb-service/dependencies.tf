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

data "aws_subnet" "default" {
  count = length(data.aws_subnets.default.ids)
  id    = data.aws_subnets.default.ids[count.index]
}

# ---------------------------------------------------------------------------------------------------------------------
# LOOK UP THE UBUNTU AMI ID
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
