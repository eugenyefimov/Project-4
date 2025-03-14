variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for security groups"
  type        = list(string)
  default     = []
}