variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "cluster_name" {
  description = "What to name the Consul cluster and all of its associated resources"
}

variable "num_servers" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
}

variable "num_clients" {
  description = "The number of Consul client nodes to deploy. You typically run the Consul client alongside your apps, so set this value to however many Instances make sense for your app code."
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  default     = ""
}
