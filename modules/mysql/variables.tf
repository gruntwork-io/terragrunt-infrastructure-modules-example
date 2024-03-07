# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the DB"
  type        = string
}

variable "instance_class" {
  description = "The instance class of the DB (e.g. db.t2.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of space, in GB, to allocate for the DB"
  type        = number
}

variable "storage_type" {
  description = "The type of storage to use for the DB. Must be one of: standard, gp2, or io1."
  type        = string
}

variable "master_username" {
  description = "The username for the master user of the DB"
  type        = string
  sensitive   = true
}

variable "master_password" {
  description = "The password for the master user of the DB"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "skip_final_snapshot" {
  description = "If set to true, skip the final snapshot of the DB when it is being deleted. In production, this should always be false. Only set it to true for automated testing."
  type        = bool
  default     = false
}

variable "engine_version" {
  description = "The version of MySQL to run. https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.VersionMgmt.html"
  type        = string
  default     = "8.0.36"
}