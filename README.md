# AWS Cloud Security Framework

This project implements a comprehensive security framework for AWS cloud environments, following best practices and compliance requirements.

## Components

### IAM Module
- Secure user management with least privilege principles
- MFA enforcement
- Password policies
- Admin and read-only user groups

### Security Groups Module
- Layered network security
- Restricted access to sensitive resources
- Bastion host configuration for secure access

### WAF Module
- Web application firewall protection
- Rate limiting for API endpoints
- Protection against OWASP Top 10 vulnerabilities

### Shield Module
- DDoS protection for critical resources
- Automatic notification of attacks
- Integration with CloudWatch for monitoring

### GuardDuty Module
- Continuous threat monitoring
- Automated notifications for suspicious activities
- Integration with CloudWatch Events

### CloudTrail Module
- Comprehensive API activity logging
- Log file integrity validation
- Multi-region audit trail
- Integration with CloudWatch for alerting

### AWS Config Module
- Continuous compliance monitoring
- Security best practice rules
- Automated notifications for non-compliant resources

## Deployment

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- An S3 bucket for Terraform state (optional)

### Deployment Steps

1. Clone the repository
2. Update the `terraform.tfvars` file with your specific configuration
3. Initialize Terraform:
```bash
terraform init

4. Review the planned changes:
```bash
terraform plan
 ```

5. Apply the changes:
```bash
terraform apply
 ```

## Compliance
This framework helps meet requirements for:

- NIST Cybersecurity Framework
- CIS AWS Foundations Benchmark
- GDPR
- HIPAA
- PCI DSS
## Maintenance
Regular maintenance tasks:

1. Review IAM users and permissions
2. Monitor GuardDuty findings
3. Address AWS Config non-compliant resources
4. Update WAF rules as new threats emerge
5. Review security group rules periodically
6. Analyze CloudTrail logs for suspicious activities
## Contributing
Contributions to improve the security framework are welcome. Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request with a detailed description of changes

### 8. Update Compliance Mapping

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
| Detect | Anomalies and Events | GuardDuty, CloudTrail |
| Detect | Continuous Monitoring | AWS Config, GuardDuty, CloudTrail |
| Respond | Response Planning | CloudWatch Events, SNS |
| Recover | Recovery Planning | Shield Advanced |

## CIS AWS Foundations Benchmark

| CIS Control | AWS Service/Module |
|-------------|-------------------|
| 1.1 - Avoid the use of the root account | IAM |
| 1.2 - Ensure MFA is enabled for the root account | IAM, AWS Config |
| 1.3 - Ensure credentials unused for 90 days are disabled | IAM |
| 1.4 - Ensure access keys are rotated every 90 days | IAM |
| 2.1 - Ensure CloudTrail is enabled in all regions | CloudTrail |
| 2.2 - Ensure CloudTrail log file validation is enabled | CloudTrail |
| 3.1 - Ensure a log metric filter and alarm exist for unauthorized API calls | GuardDuty, CloudTrail |
| 4.1 - Ensure no security groups allow ingress from 0.0.0.0/0 to port 22 | Security Groups, AWS Config |
| 4.2 - Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389 | Security Groups, AWS Config |

## GDPR

| GDPR Requirement | AWS Service/Module |
|------------------|-------------------|
| Access Control | IAM, Security Groups |
| Data Protection | WAF, Security Groups |
| Security Monitoring | GuardDuty, AWS Config, CloudTrail |
| Breach Notification | GuardDuty, CloudWatch Events, SNS |

## HIPAA

| HIPAA Safeguard | AWS Service/Module |
|-----------------|-------------------|
| Access Controls | IAM, Security Groups |
| Audit Controls | AWS Config, CloudTrail |
| Integrity Controls | WAF, Shield |
| Transmission Security | Security Groups, WAF |