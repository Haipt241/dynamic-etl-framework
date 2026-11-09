#!/bin/bash

# Create AWS Secrets Manager secret for Xero OAuth credentials
# This script creates the secret with the current credentials from config files

echo "========================================================================"
echo "AWS Secrets Manager - Create Xero OAuth Secret"
echo "========================================================================"
echo ""

# Extract current credentials from config file
CLIENT_ID="7D624AC6AEAA49CAA480DC684FCAA0C4"
CLIENT_SECRET="REDACTED"
REGION="ap-northeast-3"
SECRET_NAME="etani/xero/oauth-app"

echo "📋 Secret Configuration:"
echo "   Secret Name: $SECRET_NAME"
echo "   Region: $REGION"
echo "   Client ID: ${CLIENT_ID:0:4}...${CLIENT_ID: -4} [MASKED]"
echo "   Client Secret: *** [MASKED]"
echo ""

# Create the secret
echo "🔐 Creating secret in AWS Secrets Manager..."
echo ""

aws secretsmanager create-secret \
  --name "$SECRET_NAME" \
  --description "Xero OAuth2 Application Credentials (shared across all Xero integrations: Accounting, Payroll AU/NZ, Projects, XPM)" \
  --secret-string "{
    \"client_id\": \"$CLIENT_ID\",
    \"client_secret\": \"$CLIENT_SECRET\",
    \"created_date\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\",
    \"rotation_schedule\": \"quarterly\",
    \"integrations\": [\"xeroblue\", \"payroll_au\", \"payroll_nz\", \"xeroproject\", \"xpm\"]
  }" \
  --region "$REGION" \
  --tags Key=Environment,Value=Production Key=Integration,Value=Xero Key=ManagedBy,Value=ETL

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Secret created successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Verify secret: aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION"
    echo "   2. Update config files to remove hardcoded credentials"
    echo "   3. Test: python dynamic_integrations/secrets_manager.py"
    echo ""
else
    echo ""
    echo "❌ Failed to create secret"
    echo ""
    echo "If secret already exists, update it instead:"
    echo "   aws secretsmanager put-secret-value --secret-id $SECRET_NAME --secret-string '{...}' --region $REGION"
    echo ""
fi

echo "========================================================================"
