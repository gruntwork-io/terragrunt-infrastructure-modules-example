# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The Lambda runtime to use. Must be one of the values in: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  type        = string
}

variable "source_dir" {
  description = "The directory where your source code is stored. This will be zipped up as the Lambda deployment package."
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "route_key" {
  description = "The HTTP (V2) API Gateway route key that can be used to send requests to this function: e.g., $default or GET /foo."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "memory" {
  description = "The amount of memory, in MB, to assign to the function. This also determines the CPU available. See: https://docs.aws.amazon.com/lambda/latest/dg/configuration-function-common.html#configuration-memory-console."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The amount of time, in seconds, your function has to run. Max is 900 seconds (15 min)."
  type        = number
  default     = 3
}