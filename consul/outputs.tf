output "num_servers" {
  value = "${module.consul.num_servers}"
}

output "asg_name_servers" {
  value = "${module.consul.asg_name_servers}"
}

output "launch_config_name_servers" {
  value = "${module.consul.launch_config_name_servers}"
}

output "iam_role_arn_servers" {
  value = "${module.consul.iam_role_arn_servers}"
}

output "iam_role_id_servers" {
  value = "${module.consul.iam_role_id_servers}"
}

output "security_group_id_servers" {
  value = "${module.consul.security_group_id_servers}"
}

output "num_clients" {
  value = "${module.consul.num_clients}"
}

output "asg_name_clients" {
  value = "${module.consul.asg_name_clients}"
}

output "launch_config_name_clients" {
  value = "${module.consul.launch_config_name_clients}"
}

output "iam_role_arn_clients" {
  value = "${module.consul.iam_role_arn_clients}"
}

output "iam_role_id_clients" {
  value = "${module.consul.iam_role_id_clients}"
}

output "security_group_id_clients" {
  value = "${module.consul.security_group_id_clients}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "consul_servers_cluster_tag_key" {
  value = "${module.consul.consul_servers_cluster_tag_key}"
}

output "consul_servers_cluster_tag_value" {
  value = "${module.consul.consul_servers_cluster_tag_value}"
}
