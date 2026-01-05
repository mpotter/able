output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.loadbalancer.alb_dns_name
}

output "app_url" {
  description = "Application URL"
  value       = "https://${aws_route53_record.app.name}"
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = module.database.cluster_endpoint
}
