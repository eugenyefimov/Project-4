variable "enable_cloudtrail" {
  description = "Enable CloudTrail for audit logging"
  type        = bool
  default     = true
}

variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "enable_log_validation" {
  description = "Enable log file validation for CloudTrail"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Enable CloudTrail for all regions"
  type        = bool
  default     = true
}