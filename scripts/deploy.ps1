# AWS Cloud Security Framework - Deployment Script

# Set AWS profile
$env:AWS_PROFILE = "default"

# Navigate to Terraform directory
Set-Location -Path "..\terraform"

# Initialize Terraform
Write-Host "Initializing Terraform..." -ForegroundColor Green
terraform init

# Validate Terraform configuration
Write-Host "Validating Terraform configuration..." -ForegroundColor Green
terraform validate

if ($LASTEXITCODE -eq 0) {
    # Plan Terraform changes
    Write-Host "Planning Terraform changes..." -ForegroundColor Green
    terraform plan -out=tfplan

    # Ask for confirmation before applying
    $confirmation = Read-Host "Do you want to apply these changes? (y/n)"
    if ($confirmation -eq 'y') {
        # Apply Terraform changes
        Write-Host "Applying Terraform changes..." -ForegroundColor Green
        terraform apply tfplan
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Deployment completed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Deployment failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "Deployment cancelled." -ForegroundColor Yellow
    }
} else {
    Write-Host "Terraform validation failed!" -ForegroundColor Red
}