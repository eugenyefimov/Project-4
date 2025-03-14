variable "enable_guardduty" {
  description = "Enable AWS GuardDuty"
  type        = bool
  default     = true
}

variable "notification_email" {
  description = "Email address for GuardDuty notifications"
  type        = string
  default     = ""
}