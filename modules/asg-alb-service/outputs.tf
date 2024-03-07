output "url" {
  value = "http://${aws_lb.webserver_example.dns_name}:${var.alb_port}"
}

output "alb_dns_name" {
  value = aws_lb.webserver_example.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.webserver_example.name
}

output "asg_security_group_id" {
  value = aws_security_group.asg.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
