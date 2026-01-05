# GitHub Repository Configuration
# Manages repository settings, secrets, environments

# Repository settings
resource "github_repository" "main" {
  name        = var.github_repo
  description = "Able monorepo"
  visibility  = "public"

  # Merge settings
  allow_squash_merge          = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  delete_branch_on_merge      = true

  # Features
  has_issues   = true
  has_projects = false
  has_wiki     = false

  # Security
  vulnerability_alerts = true
}

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

# Branch protection for main branch
resource "github_branch_protection" "main" {
  repository_id = var.github_repo
  pattern       = "main"

  # Require PR with at least 1 approval
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
  }

  # Require status checks to pass
  required_status_checks {
    strict   = true # Require branch to be up to date
    contexts = ["Lint and Build"]
  }

  # Allow force pushes and deletions only for admins
  allows_force_pushes = false
  allows_deletions    = false

  # Allow admins to bypass (needed for solo maintainer workflow)
  enforce_admins = false
}
