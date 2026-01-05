# Secrets Manager for application secrets

# Anthropic API Key
resource "aws_secretsmanager_secret" "anthropic_api_key" {
  name        = "${var.project_name}/${var.environment}/anthropic-api-key"
  description = "Anthropic API key for the chat functionality"

  tags = {
    Name = "${var.project_name}-${var.environment}-anthropic-api-key"
  }
}

# Set the secret value if provided
resource "aws_secretsmanager_secret_version" "anthropic_api_key" {
  count         = var.anthropic_api_key != "" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.anthropic_api_key.id
  secret_string = var.anthropic_api_key
}

output "anthropic_secret_arn" {
  value       = aws_secretsmanager_secret.anthropic_api_key.arn
  description = "ARN of the Anthropic API key secret"
}
