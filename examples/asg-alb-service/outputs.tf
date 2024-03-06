output "url" {
  value = module.service.url
}

output "alb_dns_name" {
  value = module.service.alb_dns_name
}

output "asg_name" {
  value = module.service.asg_name
}

output "asg_security_group_id" {
  value = module.service.asg_security_group_id
}

output "alb_security_group_id" {
  value = module.service.alb_security_group_id
}
