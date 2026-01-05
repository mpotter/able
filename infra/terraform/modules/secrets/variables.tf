variable "name_prefix" {
  description = "Prefix for secret names"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to create"
  type = map(object({
    description = string
    value       = optional(string)
  }))
  default = {}
}
