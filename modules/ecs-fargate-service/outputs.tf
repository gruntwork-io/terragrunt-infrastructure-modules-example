output "url" {
  value = "http://${aws_lb.ecs.dns_name}:${var.alb_port}"
}

output "alb_dns_name" {
  value = aws_lb.ecs.dns_name
}
