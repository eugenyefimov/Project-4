output "trail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = var.enable_cloudtrail ? aws_cloudtrail.main[0].arn : null
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group for CloudTrail"
  value       = var.enable_cloudtrail ? aws_cloudwatch_log_group.cloudtrail_logs[0].name : null
}