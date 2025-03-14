# AWS Cloud Security Framework - Compliance Mapping

This document maps the security controls implemented in this framework to common compliance standards.

## NIST Cybersecurity Framework

| NIST Function | NIST Category | AWS Service/Module |
|---------------|---------------|-------------------|
| Identify | Asset Management | AWS Config |
| Identify | Governance | IAM |
| Protect | Access Control | IAM, Security Groups |
| Protect | Data Security | Security Groups, WAF |
| Protect | Protective Technology | WAF, Shield |
| Detect | Anomalies and Events | GuardDuty |
| Detect | Continuous Monitoring | AWS Config, GuardDuty |
| Respond | Response Planning | CloudWatch Events, SNS |
| Recover | Recovery Planning | Shield Advanced |

## CIS AWS Foundations Benchmark

| CIS Control | AWS Service/Module |
|-------------|-------------------|
| 1.1 - Avoid the use of the root account | IAM |
| 1.2 - Ensure MFA is enabled for the root account | IAM, AWS Config |
| 1.3 - Ensure credentials unused for 90 days are disabled | IAM |
| 1.4 - Ensure access keys are rotated every 90 days | IAM |
| 2.1 - Ensure CloudTrail is enabled in all regions | (Not covered - could be added) |
| 2.2 - Ensure CloudTrail log file validation is enabled | (Not covered - could be added) |
| 3.1 - Ensure a log metric filter and alarm exist for unauthorized API calls | GuardDuty |
| 4.1 - Ensure no security groups allow ingress from 0.0.0.0/0 to port 22 | Security Groups, AWS Config |
| 4.2 - Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389 | Security Groups, AWS Config |

## GDPR

| GDPR Requirement | AWS Service/Module |
|------------------|-------------------|
| Access Control | IAM, Security Groups |
| Data Protection | WAF, Security Groups |
| Security Monitoring | GuardDuty, AWS Config |
| Breach Notification | GuardDuty, CloudWatch Events, SNS |

## HIPAA

| HIPAA Safeguard | AWS Service/Module |
|-----------------|-------------------|
| Access Controls | IAM, Security Groups |
| Audit Controls | AWS Config |
| Integrity Controls | WAF, Shield |
| Transmission Security | Security Groups, WAF |

## PCI DSS

| PCI Requirement | AWS Service/Module |
|-----------------|-------------------|
| Requirement 1: Install and maintain a firewall configuration | Security Groups, WAF |
| Requirement 2: Do not use vendor-supplied defaults | IAM |
| Requirement 6: Develop and maintain secure systems | WAF |
| Requirement 10: Track and monitor access | GuardDuty, AWS Config |
| Requirement 11: Regularly test security systems | AWS Config |