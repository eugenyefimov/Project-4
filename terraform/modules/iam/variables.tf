variable "admin_users" {
  description = "List of admin users to create"
  type        = list(string)
  default     = []
}

variable "readonly_users" {
  description = "List of read-only users to create"
  type        = list(string)
  default     = []
}

variable "enable_mfa" {
  description = "Enable MFA for IAM users"
  type        = bool
  default     = true
}