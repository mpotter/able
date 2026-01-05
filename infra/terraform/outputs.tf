# Consolidated outputs

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "ECS cluster name"
}

output "database_connection_string" {
  value       = "postgresql://${var.db_master_username}:<password>@${aws_rds_cluster.main.endpoint}:5432/able"
  description = "Database connection string template (replace <password> with actual)"
  sensitive   = true
}
