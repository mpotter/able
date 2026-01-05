# Shared configuration across all environments
aws_region   = "us-east-1"
project_name = "able"
domain_name  = "getwafer.com"

# GitHub OIDC (shared, only created once)
github_org         = "mpotter"
github_repo        = "able"
create_github_oidc = false  # Already exists

# Database
db_master_username = "able_admin"
