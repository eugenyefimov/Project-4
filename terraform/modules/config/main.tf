# AWS Config Module - Implements AWS Config for compliance monitoring

# Create S3 bucket for AWS Config logs
resource "aws_s3_bucket" "config_logs" {
  bucket = var.s3_bucket_name
}

# Enable versioning on S3 bucket
resource "aws_s3_bucket_versioning" "config_logs_versioning" {
  bucket = aws_s3_bucket.config_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption on S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "config_logs_encryption" {
  bucket = aws_s3_bucket.config_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create S3 bucket policy
resource "aws_s3_bucket_policy" "config_logs_policy" {
  bucket = aws_s3_bucket.config_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSConfigBucketPermissionsCheck"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}"
      },
      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Create IAM role for AWS Config
resource "aws_iam_role" "config_role" {
  name = "aws-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy for AWS Config
resource "aws_iam_role_policy_attachment" "config_policy_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

# Create AWS Config configuration recorder
resource "aws_config_configuration_recorder" "main" {
  name     = "main-config-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# Create AWS Config delivery channel
resource "aws_config_delivery_channel" "main" {
  name           = "main-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_logs.bucket
  s3_key_prefix  = "config"
  
  depends_on = [aws_config_configuration_recorder.main]
}

# Enable AWS Config recorder
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = var.enable_config
  
  depends_on = [aws_config_delivery_channel.main]
}

# Create AWS Config rules for security best practices

# Require encrypted EBS volumes
resource "aws_config_config_rule" "encrypted_volumes" {
  name        = "encrypted-volumes"
  description = "Checks whether EBS volumes are encrypted"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Ensure IAM users have MFA enabled
resource "aws_config_config_rule" "mfa_enabled" {
  name        = "mfa-enabled-for-iam-console-access"
  description = "Checks whether AWS Multi-Factor Authentication (MFA) is enabled for all IAM users"

  source {
    owner             = "AWS"
    source_identifier = "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for unrestricted SSH access
resource "aws_config_config_rule" "restricted_ssh" {
  name        = "restricted-ssh"
  description = "Checks whether security groups allow unrestricted SSH access"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for unrestricted RDP access
resource "aws_config_config_rule" "restricted_rdp" {
  name        = "restricted-rdp"
  description = "Checks whether security groups allow unrestricted RDP access"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_RDP_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for public S3 buckets
resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name        = "s3-bucket-public-read-prohibited"
  description = "Checks that your S3 buckets do not allow public read access"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for public S3 buckets (write)
resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  name        = "s3-bucket-public-write-prohibited"
  description = "Checks that your S3 buckets do not allow public write access"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for S3 bucket encryption
resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  name        = "s3-bucket-server-side-encryption-enabled"
  description = "Checks that your S3 buckets have server-side encryption enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Check for root account MFA
resource "aws_config_config_rule" "root_account_mfa_enabled" {
  name        = "root-account-mfa-enabled"
  description = "Checks whether the root user of your AWS account requires MFA"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Create SNS topic for AWS Config notifications
resource "aws_sns_topic" "config_notifications" {
  name = "aws-config-notifications"
}

# Create SNS subscription for email notifications if email is provided
resource "aws_sns_topic_subscription" "config_email_subscription" {
  count     = var.notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.config_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# Create CloudWatch event rule for non-compliant resources
resource "aws_cloudwatch_event_rule" "config_non_compliant" {
  name        = "config-non-compliant"
  description = "Capture AWS Config non-compliant resource changes"

  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail_type = ["Config Rules Compliance Change"]
    detail = {
      messageType    = ["ComplianceChangeNotification"]
      newEvaluationResult = {
        complianceType = ["NON_COMPLIANT"]
      }
    }
  })
}

# Create CloudWatch event target to send non-compliant notifications to SNS
resource "aws_cloudwatch_event_target" "config_non_compliant_to_sns" {
  rule      = aws_cloudwatch_event_rule.config_non_compliant.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.config_notifications.arn
}