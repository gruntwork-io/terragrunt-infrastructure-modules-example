# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the ECS service"
  type        = string
}

variable "container_definitions" {
  description = "The JSON container definitions for the ECS Task. See: https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html"
  type        = string
}

variable "desired_count" {
  description = "How many instances of the service to run"
  type        = number
}

variable "cpu" {
  description = "Number of CPU units to allocate for the service. Note: only certain cpu and memory combinations are allowed. See: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html"
  type        = number
}

variable "memory" {
  description = "The amount of memory, in MB, to allocate for the service. Note: only certain cpu and memory combinations are allowed. See: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html"
  type        = number
}

variable "container_port" {
  description = "The port the container listens on for HTTP requests"
  type        = number
}

variable "alb_port" {
  description = "The port the ALB listens on for HTTP requests"
  type        = number
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
