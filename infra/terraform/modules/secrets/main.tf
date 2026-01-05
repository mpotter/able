# Secrets Module - Secrets Manager

resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secrets

  name        = "${var.name_prefix}/${each.key}"
  description = each.value.description

  tags = {
    Name = "${var.name_prefix}-${each.key}"
  }
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = { for k, v in var.secrets : k => v if v.value != null }

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.value

  lifecycle {
    ignore_changes = [secret_string]
  }
}
