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