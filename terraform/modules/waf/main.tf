# WAF Module - Implements AWS Web Application Firewall protections

# Create an IP set for rate limiting
resource "aws_wafv2_ip_set" "rate_limit_ip_set" {
  name               = "rate-limit-ip-set"
  description        = "IP set for rate limiting"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = []
}

# Create a WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name        = "main-web-acl"
  description = "Main WAF Web ACL"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # SQL Injection Rule
  rule {
    name     = "SQLiRule"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRule"
      sampled_requests_enabled   = true
    }

    override_action {
      none {}
    }
  }

  # Common Vulnerabilities and Exposures Rule
  rule {
    name     = "CVERule"
    priority = 2

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CVERule"
      sampled_requests_enabled   = true
    }

    override_action {
      none {}
    }
  }

  # OWASP Top 10 Rule
  rule {
    name     = "OWASPRule"
    priority = 3

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "OWASPRule"
      sampled_requests_enabled   = true
    }

    override_action {
      none {}
    }
  }

  # Rate Limiting Rule (if enabled)
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      name     = "RateLimitRule"
      priority = 4

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = 1000
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimitRule"
        sampled_requests_enabled   = true
      }
    }
  }

  # Geo-restriction Rule
  rule {
    name     = "GeoRestrictionRule"
    priority = 5

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["RU", "CN", "IR", "KP"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GeoRestrictionRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "MainWebACL"
    sampled_requests_enabled   = true
  }
}

# Associate WAF with ALB if ALB ARN is provided
resource "aws_wafv2_web_acl_association" "alb_association" {
  count        = var.alb_arn != "" ? 1 : 0
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# Associate WAF with API Gateway if API Gateway ID is provided
resource "aws_wafv2_web_acl_association" "api_gateway_association" {
  count        = var.api_gateway_id != "" ? 1 : 0
  resource_arn = "arn:aws:apigateway:${data.aws_region.current.name}::/restapis/${var.api_gateway_id}/stages/prod"
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# Get current region
data "aws_region" "current" {}

# Create CloudWatch logging for WAF
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn
}

# Create CloudWatch log group for WAF logs
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/waf/logs"
  retention_in_days = 90
}