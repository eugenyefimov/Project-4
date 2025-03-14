variable "enable_advanced" {
  description = "Enable AWS Shield Advanced"
  type        = bool
  default     = true
}

variable "protected_resources" {
  description = "List of resources to protect with Shield Advanced"
  type        = list(string)
  default     = []
}