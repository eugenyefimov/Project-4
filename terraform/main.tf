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
  
  enable_guardduty    = var.enable_guardduty
  notification_email  = var.guardduty_notification_email
}

# AWS Config Module - Compliance Monitoring
module "config" {
  source = "./modules/config"
  
  s3_bucket_name      = var.config_s3_bucket_name
  enable_config       = var.enable_config
  notification_email  = var.config_notification_email
}

# Outputs
output "security_groups" {
  description = "Security groups created by the framework"
  value = {
    web     = module.security_groups.web_sg_id
    app     = module.security_groups.app_sg_id
    db      = module.security_groups.db_sg_id
    bastion = module.security_groups.bastion_sg_id
  }
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.waf.web_acl_arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

output "config_recorder_id" {
  description = "ID of the AWS Config recorder"
  value       = module.config.recorder_id
}