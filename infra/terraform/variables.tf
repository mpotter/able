variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use (SSO profile name)"
  type        = string
  default     = "able"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "able"
}

variable "db_master_username" {
  description = "Master username for Aurora"
  type        = string
  default     = "able_admin"
}

variable "domain_name" {
  description = "Domain name for the application (optional)"
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization or username"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "able"
}

variable "create_github_oidc" {
  description = "Whether to create the GitHub OIDC provider (set to false if it already exists in your account)"
  type        = bool
  default     = true
}

variable "anthropic_api_key" {
  description = "Anthropic API key for the chat functionality"
  type        = string
  sensitive   = true
  default     = ""
}
