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

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "getwafer.com"
}

variable "github_org" {
  description = "GitHub organization/user"
  type        = string
  default     = "mpotter"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "able"
}
