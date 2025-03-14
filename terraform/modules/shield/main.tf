# Shield Module - Implements AWS Shield DDoS protection

# Enable AWS Shield Advanced
resource "aws_shield_protection_group" "all_resources" {
  count                                     = var.enable_advanced ? 1 : 0
  protection_group_id                       = "all-resources"
  aggregation                               = "MAX"
  pattern                                   = "ALL"
  resource_type                             = "CLOUDFRONT_DISTRIBUTION"
  protection_group_arn                      = aws_shield_protection_group.all_resources[0].arn
}

# Create Shield Advanced protection for specific resources
resource "aws_shield_protection" "protected_resource" {
  for_each     = var.enable_advanced ? toset(var.protected_resources) : []
  name         = "shield-protection-${split("/", each.value)[1]}"
  resource_arn = each.value
}

# Create SNS topic for Shield notifications
resource "aws_sns_topic" "shield_notifications" {
  count = var.enable_advanced ? 1 : 0
  name  = "shield-notifications"
}

# Create CloudWatch alarm for DDoS events
resource "aws_cloudwatch_metric_alarm" "ddos_detected_alarm" {
  count               = var.enable_advanced ? 1 : 0
  alarm_name          = "ddos-attack-detected"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This alarm monitors for DDoS attacks"
  alarm_actions       = [aws_sns_topic.shield_notifications[0].arn]
}