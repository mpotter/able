variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for database"
  type        = list(string)
}

variable "allowed_security_groups" {
  description = "Security groups allowed to connect to database"
  type        = list(string)
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "able"
}

variable "master_username" {
  description = "Master username"
  type        = string
  default     = "able_admin"
}

variable "engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "16.4"
}

variable "min_capacity" {
  description = "Minimum ACUs for serverless"
  type        = number
  default     = 0.5
}

variable "max_capacity" {
  description = "Maximum ACUs for serverless"
  type        = number
  default     = 4
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = true
}
