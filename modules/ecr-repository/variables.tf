variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository. Valid values: MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}

variable "allowed_accounts" {
  description = "List of AWS account IDs that should have pull access to this repository."
  type        = list(string)
  default     = []
}

variable "replication_destinations" {
  description = <<-EOT
    List of replication destinations.
    Each destination is an object with:
      - region: AWS region (e.g., "us-west-2")
      - registry_id: AWS account ID of the destination registry.
  EOT
  type = list(object({
    region      = string
    registry_id = string
  }))
  default = []
}
