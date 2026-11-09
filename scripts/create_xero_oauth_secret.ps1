# Create AWS Secrets Manager secret for Xero OAuth credentials
# PowerShell version for Windows

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "AWS Secrets Manager - Create Xero OAuth Secret" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Extract current credentials from config file
$CLIENT_ID = "7D624AC6AEAA49CAA480DC684FCAA0C4"
$CLIENT_SECRET = "REDACTED"
$REGION = "ap-northeast-3"
$SECRET_NAME = "etani/xero/oauth-app"

Write-Host "📋 Secret Configuration:"
Write-Host "   Secret Name: $SECRET_NAME"
Write-Host "   Region: $REGION"
Write-Host "   Client ID: $($CLIENT_ID.Substring(0,4))...$($CLIENT_ID.Substring($CLIENT_ID.Length-4)) [MASKED]"
Write-Host "   Client Secret: *** [MASKED]"
Write-Host ""

# Create secret JSON
$secretJson = @{
    client_id = $CLIENT_ID
    client_secret = $CLIENT_SECRET
    created_date = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
    rotation_schedule = "quarterly"
    integrations = @("xeroblue", "payroll_au", "payroll_nz", "xeroproject", "xpm")
} | ConvertTo-Json -Compress

# Create the secret
Write-Host "🔐 Creating secret in AWS Secrets Manager..." -ForegroundColor Yellow
Write-Host ""

try {
    aws secretsmanager create-secret `
        --name $SECRET_NAME `
        --description "Xero OAuth2 Application Credentials (shared across all Xero integrations: Accounting, Payroll AU/NZ, Projects, XPM)" `
        --secret-string $secretJson `
        --region $REGION `
        --tags Key=Environment,Value=Production Key=Integration,Value=Xero Key=ManagedBy,Value=ETL

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Secret created successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📝 Next steps:"
        Write-Host "   1. Verify secret: aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION"
        Write-Host "   2. Update config files to remove hardcoded credentials"
        Write-Host "   3. Test: python dynamic_integrations/secrets_manager.py"
        Write-Host ""
    }
}
catch {
    Write-Host ""
    Write-Host "❌ Failed to create secret" -ForegroundColor Red
    Write-Host ""
    Write-Host "If secret already exists, update it instead:"
    Write-Host "   aws secretsmanager put-secret-value --secret-id $SECRET_NAME --secret-string '$secretJson' --region $REGION"
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host "========================================================================"
