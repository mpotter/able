output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = aws_rds_cluster.main.endpoint
}

output "cluster_reader_endpoint" {
  description = "Cluster reader endpoint"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "master_user_secret_arn" {
  description = "ARN of the secret containing master credentials"
  value       = aws_rds_cluster.main.master_user_secret[0].secret_arn
}

output "database_name" {
  description = "Database name"
  value       = aws_rds_cluster.main.database_name
}

output "security_group_id" {
  description = "Aurora security group ID"
  value       = aws_security_group.aurora.id
}

output "cluster_identifier" {
  description = "RDS cluster identifier (for CloudWatch metrics)"
  value       = aws_rds_cluster.main.cluster_identifier
}
