# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the ASG. This name is also used to namespace all the other resources created by this module."
  type        = string
  default     = "asg-alb-example"
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}
