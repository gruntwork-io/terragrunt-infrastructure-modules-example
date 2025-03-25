variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}

variable "secrets" {
  description = "List of secrets to create. Each secret is an object with name and optional description."
  type = list(object({
    name        = string
    description = optional(string)
  }))
}
