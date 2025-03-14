# General AWS Configuration
aws_region  = "us-east-1"
aws_profile = "default"

# VPC Configuration
vpc_id = "vpc-12345678"

# IAM Configuration
admin_users    = ["admin1", "admin2"]
readonly_users = ["readonly1", "readonly2"]
enable_mfa     = true

# Security Groups Configuration
allowed_ips = ["203.0.113.0/24", "198.51.100.0/24"]

# WAF Configuration
alb_arn             = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/abcdef123456"
api_gateway_id      = "abcdef123"
enable_rate_limiting = true

# Shield Configuration
enable_shield_advanced = true
shield_protected_resources = [
  "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/abcdef123456",
  "arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5"
]

# GuardDuty Configuration
enable_guardduty = true
guardduty_notification_email = "security@example.com"

# AWS Config Configuration
enable_config = true
config_s3_bucket_name = "my-org-aws-config-logs"