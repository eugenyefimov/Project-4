variable "s3_bucket_name" {
  description = "S3 bucket name for AWS Config logs"
  type        = string
}

variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "notification_email" {
  description = "Email address for AWS Config notifications"
  type        = string
  default     = ""
}