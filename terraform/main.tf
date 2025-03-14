# AWS Cloud Security Framework - Main Terraform Configuration

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Configure Terraform backend (optional)
# terraform {
#   backend "s3" {
#     bucket = "your-terraform-state-bucket"
#     key    = "security-framework/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# IAM Module - Identity and Access Management
module "iam" {
  source = "./modules/iam"
  
  admin_users    = var.admin_users
  readonly_users = var.readonly_users
  enable_mfa     = var.enable_mfa
}

# Security Groups Module - Network Security
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id      = var.vpc_id
  allowed_ips = var.allowed_ips
}

# WAF Module - Web Application Firewall
module "waf" {
  source = "./modules/waf"
  
  alb_arn             = var.alb_arn
  api_gateway_id      = var.api_gateway_id
  enable_rate_limiting = var.enable_rate_limiting
}

# Shield Module - DDoS Protection
module "shield" {
  source = "./modules/shield"
  
  enable_advanced     = var.enable_shield_advanced
  protected_resources = var.shield_protected_resources
}

# GuardDuty Module - Threat Detection
module "guardduty" {
  source = "./modules/guardduty"
  
  enable_guardduty         = var.enable_guardduty
  notification_email       = var.guardduty_notification_email
}

# AWS Config Module - Compliance Monitoring
module "config" {
  source = "./modules/config"
  
  s3_bucket_name      = var.config_s3_bucket_name
  enable_config       = var.enable_config
  notification_email  = var.config_notification_email
}