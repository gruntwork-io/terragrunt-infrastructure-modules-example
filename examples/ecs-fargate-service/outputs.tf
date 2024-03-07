output "url" {
  value = module.ecs_service.url
}

output "alb_dns_name" {
  value = module.ecs_service.alb_dns_name
}
