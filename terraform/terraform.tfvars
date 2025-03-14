# AWS Cloud Security Framework - Configuration Values
# This file contains all the configuration values for the security framework.
# Update these values according to your AWS environment before deployment.

# General AWS Configuration
# These settings determine which AWS region and profile to use for deployment.
aws_region  = "us-east-1"  # AWS region where resources will be deployed
aws_profile = "default"    # AWS CLI profile to use for authentication

# VPC Configuration
# The security framework will be deployed within this existing VPC.
vpc_id = "vpc-0abc123def456789a"  # Your existing VPC ID

# IAM Configuration
# These settings control the IAM users and their permissions.
# Admin users will have full administrative access.
# Read-only users will have read-only access to all resources.
admin_users    = ["secadmin", "cloudadmin"]  # Admin users to create
readonly_users = ["auditor", "developer"]    # Read-only users to create
enable_mfa     = true                        # Enforce MFA for all users

# Security Groups Configuration
# These IP ranges will be allowed to access the bastion host.
allowed_ips = [
  "10.0.0.0/24",     # Corporate office network
  "192.168.1.0/24"   # VPN network
]

# WAF Configuration
# The Web Application Firewall will protect these resources.
# WAF provides protection against common web exploits and attacks.
alb_arn             = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/main-alb/abc123def456"
api_gateway_id      = "abcd1234ef"  # API Gateway ID to protect with WAF
enable_rate_limiting = true         # Enable rate limiting in WAF

# Shield Configuration
# AWS Shield Advanced provides enhanced DDoS protection.
# Protected resources will receive additional DDoS mitigation.
enable_shield_advanced = true  # Enable AWS Shield Advanced
shield_protected_resources = [
  "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/main-alb/abc123def456",
  "arn:aws:cloudfront::123456789012:distribution/EDFDVBD6EXAMPLE"
]

# GuardDuty Configuration
# GuardDuty provides continuous security monitoring and threat detection.
# Findings will be sent to the specified email address.
enable_guardduty = true
guardduty_notification_email = "security-alerts@example.com"

# AWS Config Configuration
# AWS Config continuously monitors and records your AWS resource configurations.
# Non-compliant resources will trigger notifications.
enable_config = true
config_s3_bucket_name = "example-org-aws-config-logs-123456789012"  # Globally unique bucket name
config_notification_email = "compliance@example.com"

# Add these variables to your existing terraform.tfvars file

# CloudTrail Configuration
# CloudTrail provides audit logging for all API calls in your AWS account.
enable_cloudtrail = true
cloudtrail_bucket_name = "example-org-cloudtrail-logs-123456789012"  # Globally unique bucket name
enable_log_validation = true
is_multi_region_trail = true