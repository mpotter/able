variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}

variable "security_group_id" {
  description = "External security group ID for ECS tasks (required if use_external_security_group is true)"
  type        = string
  default     = null
}

variable "use_external_security_group" {
  description = "Whether to use an external security group (must be true if security_group_id is provided)"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "Target group ARN for load balancer"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "Task CPU units"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Task memory in MB"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "environment_variables" {
  description = "Environment variables for container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets for container (from Secrets Manager)"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "secrets_arns" {
  description = "ARNs of secrets the task can access"
  type        = list(string)
  default     = []
}

# Note: Container health check removed - using ALB target group health check instead
