# GuardDuty Module - Implements AWS GuardDuty threat detection

# Enable GuardDuty
resource "aws_guardduty_detector" "main" {
  enable                       = var.enable_guardduty
  finding_publishing_frequency = "SIX_HOURS"
}

# Create SNS topic for GuardDuty findings
resource "aws_sns_topic" "guardduty_findings" {
  count = var.enable_guardduty ? 1 : 0
  name  = "guardduty-findings"
}

# Create SNS subscription for email notifications
resource "aws_sns_topic_subscription" "guardduty_email_subscription" {
  count     = var.enable_guardduty && var.notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.guardduty_findings[0].arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Create CloudWatch event rule to capture GuardDuty findings
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  count       = var.enable_guardduty ? 1 : 0
  name        = "guardduty-findings"
  description = "Capture GuardDuty findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
  })
}

# Create CloudWatch event target to send findings to SNS
resource "aws_cloudwatch_event_target" "guardduty_findings_to_sns" {
  count     = var.enable_guardduty ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty_findings[0].name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.guardduty_findings[0].arn
}

# Create IAM role for CloudWatch events
resource "aws_iam_role" "guardduty_events_role" {
  count = var.enable_guardduty ? 1 : 0
  name  = "guardduty-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for CloudWatch events
resource "aws_iam_policy" "guardduty_events_policy" {
  count       = var.enable_guardduty ? 1 : 0
  name        = "guardduty-events-policy"
  description = "Policy for GuardDuty CloudWatch events"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = aws_sns_topic.guardduty_findings[0].arn
      }
    ]
  })
}

# Attach IAM policy to role
resource "aws_iam_role_policy_attachment" "guardduty_events_policy_attachment" {
  count      = var.enable_guardduty ? 1 : 0
  role       = aws_iam_role.guardduty_events_role[0].name
  policy_arn = aws_iam_policy.guardduty_events_policy[0].arn
}