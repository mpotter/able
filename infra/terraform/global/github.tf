# GitHub Repository Configuration
# Manages repository settings, secrets, environments

resource "github_repository_environment" "dev" {
  repository  = var.github_repo
  environment = "dev"
}

resource "github_repository_environment" "prod" {
  repository  = var.github_repo
  environment = "prod"

  reviewers {
    users = [data.github_user.current.id]
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

data "github_user" "current" {
  username = var.github_org
}

# Store AWS role ARN as a secret for GitHub Actions
resource "github_actions_secret" "aws_role_arn" {
  repository      = var.github_repo
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = aws_iam_role.github_actions.arn
}
