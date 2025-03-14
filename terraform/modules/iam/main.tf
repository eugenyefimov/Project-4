# IAM Module - Implements secure IAM policies and user management

# Create admin group
resource "aws_iam_group" "admin_group" {
  name = "Administrators"
}

# Create read-only group
resource "aws_iam_group" "readonly_group" {
  name = "ReadOnly"
}

# Attach admin policy to admin group
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach read-only policy to readonly group
resource "aws_iam_group_policy_attachment" "readonly_policy" {
  group      = aws_iam_group.readonly_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create admin users
resource "aws_iam_user" "admin_users" {
  for_each = toset(var.admin_users)
  name     = each.value
}

# Create readonly users
resource "aws_iam_user" "readonly_users" {
  for_each = toset(var.readonly_users)
  name     = each.value
}

# Add admin users to admin group
resource "aws_iam_user_group_membership" "admin_group_membership" {
  for_each = toset(var.admin_users)
  user     = each.value
  groups   = [aws_iam_group.admin_group.name]
  
  depends_on = [aws_iam_user.admin_users]
}

# Add readonly users to readonly group
resource "aws_iam_user_group_membership" "readonly_group_membership" {
  for_each = toset(var.readonly_users)
  user     = each.value
  groups   = [aws_iam_group.readonly_group.name]
  
  depends_on = [aws_iam_user.readonly_users]
}

# Create MFA policy if enabled
resource "aws_iam_policy" "require_mfa" {
  count       = var.enable_mfa ? 1 : 0
  name        = "RequireMFA"
  description = "Policy that enforces MFA usage"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfo"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:GetAccountSummary",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowManageOwnPasswords"
        Effect = "Allow"
        Action = [
          "iam:ChangePassword",
          "iam:GetUser"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "AllowManageOwnAccessKeys"
        Effect = "Allow"
        Action = [
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "AllowManageOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = [
          "arn:aws:iam::*:user/$${aws:username}",
          "arn:aws:iam::*:mfa/$${aws:username}"
        ]
      },
      {
        Sid    = "DenyAllExceptListedIfNoMFA"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Attach MFA policy to all users if enabled
resource "aws_iam_user_policy_attachment" "mfa_policy_attachment_admin" {
  for_each   = var.enable_mfa ? toset(var.admin_users) : []
  user       = each.value
  policy_arn = aws_iam_policy.require_mfa[0].arn
  
  depends_on = [aws_iam_user.admin_users, aws_iam_policy.require_mfa]
}

resource "aws_iam_user_policy_attachment" "mfa_policy_attachment_readonly" {
  for_each   = var.enable_mfa ? toset(var.readonly_users) : []
  user       = each.value
  policy_arn = aws_iam_policy.require_mfa[0].arn
  
  depends_on = [aws_iam_user.readonly_users, aws_iam_policy.require_mfa]
}

# Password policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
}