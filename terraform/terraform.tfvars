# AWS Cloud Security Framework - Configuration Values

# General AWS Configuration
aws_region  = "us-east-1"
aws_profile = "default"

# VPC Configuration
vpc_id = "vpc-12345678" # Replace with your VPC ID

# IAM Configuration
admin_users    = ["admin1", "admin2"]
readonly_users = ["readonly1", "readonly2"]
enable_mfa     = true

# Security Groups Configuration
allowed_ips = ["203.0.113.0/24", "198.51.100.0/24"] # Replace with your allowed IPs

# WAF Configuration
alb_arn             = "" # Replace with your ALB ARN
api_gateway_id      = "" # Replace with your API Gateway ID
enable_rate_limiting = true

# Shield Configuration
enable_shield_advanced = true
shield_protected_resources = [] # Add resources to protect

# GuardDuty Configuration
enable_guardduty = true
guardduty_notification_email = "security@example.com" # Replace with your email

# AWS Config Configuration
enable_config = true
config_s3_bucket_name = "my-aws-config-logs" # Replace with your bucket name
config_notification_email = "security@example.com" # Replace with your email