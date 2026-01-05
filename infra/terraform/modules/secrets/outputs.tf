output "secret_arns" {
  description = "Map of secret names to ARNs"
  value       = { for k, v in aws_secretsmanager_secret.secrets : k => v.arn }
}

output "secret_ids" {
  description = "Map of secret names to IDs"
  value       = { for k, v in aws_secretsmanager_secret.secrets : k => v.id }
}
