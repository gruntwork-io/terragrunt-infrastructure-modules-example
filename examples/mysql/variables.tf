# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "master_username" {
  description = "The username for the master user of the DB. We recommend setting this via an env var: export TF_VAR_master_username=xxx."
  type        = string
  sensitive   = true
}

variable "master_password" {
  description = "The password for the master user of the DB. We recommend setting this via an env var: export TF_VAR_master_password=xxx."
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the DB"
  type        = string
  default     = "mysql-example"
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}
