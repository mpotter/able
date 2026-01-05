# Global Infrastructure - Shared resources across all environments

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "able-terraform-state-870915098538"
    key          = "able/global/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "terraform"
      Scope     = "global"
    }
  }
}

provider "github" {
  owner = var.github_org
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
