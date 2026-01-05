variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "alarm_email" {
  description = "Email address for alarm notifications"
  type        = string
  default     = ""
}

# ECS Monitoring
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to monitor"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service to monitor"
  type        = string
}

# ALB Monitoring
variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB (from aws_lb.arn_suffix)"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group"
  type        = string
}

# RDS Monitoring
variable "db_cluster_identifier" {
  description = "RDS cluster identifier"
  type        = string
}

# Thresholds
variable "ecs_cpu_threshold" {
  description = "CPU utilization threshold for ECS alarm (%)"
  type        = number
  default     = 80
}

variable "ecs_memory_threshold" {
  description = "Memory utilization threshold for ECS alarm (%)"
  type        = number
  default     = 80
}

variable "alb_5xx_threshold" {
  description = "5xx error count threshold for ALB alarm"
  type        = number
  default     = 10
}

variable "rds_cpu_threshold" {
  description = "CPU utilization threshold for RDS alarm (%)"
  type        = number
  default     = 80
}

variable "rds_connections_threshold" {
  description = "Database connections threshold"
  type        = number
  default     = 50
}
