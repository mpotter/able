# Prod Environment

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27"
    }
  }

  backend "s3" {
    bucket       = "able-terraform-state-870915098538"
    key          = "able/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Reference global outputs via data source
data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "able-terraform-state-870915098538"
    key    = "able/global/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

# ECS Security Group (created first to break circular dependency)
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.name_prefix}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = module.networking.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-ecs-tasks-sg"
  }
}

# Networking
module "networking" {
  source = "../../modules/networking"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  enable_nat_gateway = var.enable_nat_gateway
}

# Load Balancer
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  name_prefix       = local.name_prefix
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  certificate_arn   = data.terraform_remote_state.global.outputs.acm_certificate_arn
  container_port    = var.container_port
  health_check_path = var.health_check_path
}

# Database
module "database" {
  source = "../../modules/database"

  name_prefix             = local.name_prefix
  vpc_id                  = module.networking.vpc_id
  private_subnet_ids      = module.networking.private_subnet_ids
  allowed_security_groups = [aws_security_group.ecs_tasks.id]
  database_name           = var.database_name
  master_username         = var.db_master_username
  min_capacity            = var.db_min_capacity
  max_capacity            = var.db_max_capacity
  skip_final_snapshot     = false  # Keep final snapshot in prod
}

# Secrets
module "secrets" {
  source = "../../modules/secrets"

  name_prefix = "${var.project_name}/${var.environment}"
  secrets = {
    "anthropic-api-key" = {
      description = "Anthropic API Key"
    }
  }
  secret_values = {
    "anthropic-api-key" = var.anthropic_api_key
  }
}

# ECS
module "ecs" {
  source = "../../modules/ecs"

  name_prefix                 = local.name_prefix
  service_name                = "dotco"
  vpc_id                      = module.networking.vpc_id
  private_subnet_ids          = module.networking.private_subnet_ids
  alb_security_group_id       = module.loadbalancer.security_group_id
  security_group_id           = aws_security_group.ecs_tasks.id
  use_external_security_group = true
  target_group_arn            = module.loadbalancer.target_group_arn
  container_image       = "${data.terraform_remote_state.global.outputs.ecr_repository_url}:${var.environment}-latest"
  container_port        = var.container_port
  cpu                   = var.ecs_cpu
  memory                = var.ecs_memory
  desired_count         = var.ecs_desired_count
  health_check_path     = var.health_check_path

  environment_variables = [
    { name = "NODE_ENV", value = "production" },
    { name = "DATABASE_HOST", value = module.database.cluster_endpoint },
    { name = "DATABASE_NAME", value = module.database.database_name },
  ]

  secrets = [
    { name = "ANTHROPIC_API_KEY", valueFrom = module.secrets.secret_arns["anthropic-api-key"] },
    { name = "DATABASE_USERNAME", valueFrom = "${module.database.master_user_secret_arn}:username::" },
    { name = "DATABASE_PASSWORD", valueFrom = "${module.database.master_user_secret_arn}:password::" },
  ]

  secrets_arns = concat(
    values(module.secrets.secret_arns),
    [module.database.master_user_secret_arn]
  )
}

# DNS Records - prod gets the root domain and www
resource "aws_route53_record" "app" {
  zone_id = data.terraform_remote_state.global.outputs.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.loadbalancer.alb_dns_name
    zone_id                = module.loadbalancer.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.terraform_remote_state.global.outputs.route53_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.loadbalancer.alb_dns_name
    zone_id                = module.loadbalancer.alb_zone_id
    evaluate_target_health = true
  }
}
