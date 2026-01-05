# Dev environment configuration
environment = "dev"

# Common settings (same across environments)
aws_region   = "us-east-1"
project_name = "able"
domain_name  = "getwafer.com"

# GitHub OIDC (only create once, shared across environments)
github_org         = "mpotter"
github_repo        = "able"
create_github_oidc = false  # Already exists

# Database
db_master_username = "able_admin"
