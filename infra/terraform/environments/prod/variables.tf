variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "able"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "getwafer.com"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.1.0.0/16"  # Different CIDR for prod
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
  default     = true
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/api/health"
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "able"
}

variable "db_master_username" {
  description = "Database master username"
  type        = string
  default     = "able_admin"
}

variable "db_min_capacity" {
  description = "Database minimum ACUs"
  type        = number
  default     = 0.5
}

variable "db_max_capacity" {
  description = "Database maximum ACUs"
  type        = number
  default     = 8  # Higher max for prod
}

variable "ecs_cpu" {
  description = "ECS task CPU units"
  type        = string
  default     = "512"  # More CPU for prod
}

variable "ecs_memory" {
  description = "ECS task memory in MB"
  type        = string
  default     = "1024"  # More memory for prod
}

variable "ecs_desired_count" {
  description = "ECS desired task count"
  type        = number
  default     = 2  # Multiple instances for prod
}

variable "anthropic_api_key" {
  description = "Anthropic API key"
  type        = string
  sensitive   = true
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
  default     = ""
}
