# General AWS Configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

# VPC Configuration
variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

# IAM Configuration
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

# Security Groups Configuration
variable "allowed_ips" {
  description = "List of allowed IP addresses for security groups"
  type        = list(string)
  default     = []
}

# WAF Configuration
variable "alb_arn" {
  description = "ARN of the Application Load Balancer to protect with WAF"
  type        = string
  default     = ""
}

variable "api_gateway_id" {
  description = "ID of the API Gateway to protect with WAF"
  type        = string
  default     = ""
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting in WAF"
  type        = bool
  default     = true
}

# Shield Configuration
variable "enable_shield_advanced" {
  description = "Enable AWS Shield Advanced"
  type        = bool
  default     = true
}

variable "shield_protected_resources" {
  description = "List of resources to protect with Shield Advanced"
  type        = list(string)
  default     = []
}

# GuardDuty Configuration
variable "enable_guardduty" {
  description = "Enable AWS GuardDuty"
  type        = bool
  default     = true
}

variable "guardduty_notification_email" {
  description = "Email address for GuardDuty notifications"
  type        = string
  default     = ""
}

# AWS Config Configuration
variable "enable_config" {
  description = "Enable AWS Config"
  type        = bool
  default     = true
}

variable "config_s3_bucket_name" {
  description = "S3 bucket name for AWS Config logs"
  type        = string
}