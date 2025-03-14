provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

module "iam" {
  source = "./modules/iam"
  
  # Variables for IAM module
  admin_users = var.admin_users
  readonly_users = var.readonly_users
  enable_mfa = var.enable_mfa
}

module "security_groups" {
  source = "./modules/security_groups"
  
  # Variables for Security Groups module
  vpc_id = var.vpc_id
  allowed_ips = var.allowed_ips
}

module "waf" {
  source = "./modules/waf"
  
  # Variables for WAF module
  alb_arn = var.alb_arn
  api_gateway_id = var.api_gateway_id
  enable_rate_limiting = var.enable_rate_limiting
}

module "shield" {
  source = "./modules/shield"
  
  # Variables for Shield module
  enable_advanced = var.enable_shield_advanced
  protected_resources = var.shield_protected_resources
}

module "guardduty" {
  source = "./modules/guardduty"
  
  # Variables for GuardDuty module
  enable_guardduty = var.enable_guardduty
  notification_email = var.guardduty_notification_email
}

module "config" {
  source = "./modules/config"
  
  # Variables for AWS Config module
  s3_bucket_name = var.config_s3_bucket_name
  enable_config = var.enable_config
}