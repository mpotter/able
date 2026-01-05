variable "name_prefix" {
  description = "Prefix for secret names"
  type        = string
}

variable "secrets" {
  description = "Map of secrets to create (metadata only)"
  type = map(object({
    description = string
  }))
  default = {}
}

variable "secret_values" {
  description = "Map of secret values to set (key must match secrets map)"
  type        = map(string)
  default     = {}
  sensitive   = true
}
