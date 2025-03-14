# CloudTrail Module - Implements AWS CloudTrail for audit logging

# Create S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  count  = var.enable_cloudtrail ? 1 : 0
  bucket = var.cloudtrail_bucket_name
  force_destroy = true
}

# S3 bucket policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  count  = var.enable_cloudtrail ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_logs[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${var.cloudtrail_bucket_name}"
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${var.cloudtrail_bucket_name}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Create CloudTrail
resource "aws_cloudtrail" "main" {
  count                         = var.enable_cloudtrail ? 1 : 0
  name                          = "security-framework-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs[0].id
  include_global_service_events = true
  is_multi_region_trail         = var.is_multi_region_trail
  enable_log_file_validation    = var.enable_log_validation
  
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}

# Create SNS topic for CloudTrail notifications
resource "aws_sns_topic" "cloudtrail_alarms" {
  count = var.enable_cloudtrail ? 1 : 0
  name  = "cloudtrail-security-alarms"
}

# Create CloudWatch Log Group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  count = var.enable_cloudtrail ? 1 : 0
  name  = "/aws/cloudtrail/security-framework"
  retention_in_days = 90
}