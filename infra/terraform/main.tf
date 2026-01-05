terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "able-terraform-state-870915098538"
    key          = "state/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    # profile configured via -backend-config or AWS_PROFILE env var
  }
}

provider "aws" {
  region = var.aws_region
  # profile configured via AWS_PROFILE env var (not set in CI, uses OIDC credentials)

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
