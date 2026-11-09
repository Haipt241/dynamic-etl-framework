# How to Use the Plug-and-Play Integration Package Upsert System

A comprehensive guide for using the generic plug-and-play ETL integration system.

## 🚀 Quick Start Guide

### 1. Simple Entry Point (Recommended)

```bash
# Set environment variables
export EtaniClientID="BIGOLESHOECOMPANY_CLIENT1518"
export EtaniOrganisationID="7232"
export XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43"
export xeroblue_client_id="your-client-id"
export xeroblue_client_secret="your-client-secret"

# Run any integration
python run_integration.py --integration XEROBLUE

# Run specific endpoints
python run_integration.py --integration XEROBLUE --endpoints Organisations,Accounts

# Run single endpoint
python run_integration.py --integration XEROBLUE --endpoint Organisations

# Debug mode
python run_integration.py --integration XEROBLUE --debug
```

### 2. Generic Orchestrator (Programmatic)

```python
from IntegrationPackageUpsert import create_package_upsert

# Configuration
config = {
    'rate_limit': 60,
    'timeout_seconds': 900,
    'debug': True
}

# Create and run any integration using generic orchestrator
orchestrator = create_package_upsert('XEROBLUE', config)
result = orchestrator.run()

print(f"Status: {result['status']}")
print(f"Records: {result.get('total_records_processed', 0)}")
```

### 3. Direct Integration Usage

```python
from integrations.xeroblue_integration_enhanced import XeroBlueIntegrationEnhanced

# Create integration instance with business logic
integration = XeroBlueIntegrationEnhanced(config)

# Run full sync directly
result = integration.run_full_sync()

# Or run single endpoint
result = integration.extract_api_response('Organisations')
```

## 🔧 Environment Setup

### Required Environment Variables (BIGOLESHOECOMPANY Example)

Based on the comprehensive test configuration:

```bash
# Core ETL Configuration
export DB_Destination="EVA"
export JOB_ID="1"
export JOB_RUN_ID="7232"
export TRIGGER_TYPE="MANUAL"

# Client and Organization Configuration
export EtaniClientID="BIGOLESHOECOMPANY_CLIENT1518"
export EtaniOrganisationID="7232"

# XeroBlue API Configuration
export XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43"
export xeroblue_client_id="7D624AC6AEAA49CAA480DC684FCAA0C4"
export xeroblue_client_secret="REDACTED"

# Azure File Share Configuration (for token storage)
export AZ_FILE_SHARE="etanissis"
export AZ_FILE_SHARE_KEY="REDACTED"
export FILE_SHARE_NAME="xeroblue-pydw-refreshtoken"
```

### Token File Naming Convention

The system automatically generates token file names based on your configuration:

```bash
# Token file format: {EtaniClientID}_{EtaniOrganisationID}.txt
# Example: BIGOLESHOECOMPANY_CLIENT1518_7232.txt

# The file should exist in Azure File Share at:
# {AZ_FILE_SHARE}/{FILE_SHARE_NAME}/{TOKEN_FILE}
# Example: etanissis/xeroblue-pydw-refreshtoken/BIGOLESHOECOMPANY_CLIENT1518_7232.txt
```

### Environment File Template

Create a `.env` file:

```bash
# .env file for BIGOLESHOECOMPANY
DB_Destination=EVA
JOB_ID=1
JOB_RUN_ID=7232
TRIGGER_TYPE=MANUAL
EtaniClientID=BIGOLESHOECOMPANY_CLIENT1518
EtaniOrganisationID=7232
XeroTenantID=865512af-e7d8-4d42-8568-73084279eb43
xeroblue_client_id=7D624AC6AEAA49CAA480DC684FCAA0C4
xeroblue_client_secret=REDACTED
AZ_FILE_SHARE=etanissis
AZ_FILE_SHARE_KEY=REDACTED
FILE_SHARE_NAME=xeroblue-pydw-refreshtoken
```

## 🧪 Testing and Validation

### 1. Comprehensive System Test

```bash
# Test with BIGOLESHOECOMPANY real credentials
python test_comprehensive_integration.py --mode bigoleshoe

# Test with mock credentials (interface testing)
python test_comprehensive_integration.py --mode mock

# Test interface compliance only
python test_comprehensive_integration.py --mode interface-only --verbose
```

### 2. Simple Entry Point Tests

```bash
# Test environment and show integration info
python run_integration.py --integration XEROBLUE --info-only

# Test single endpoint processing
python run_integration.py --integration XEROBLUE --endpoint Organisations --debug

# Test with custom rate limiting
python run_integration.py --integration XEROBLUE --rate-limit 30 --timeout 600
```

### 3. Programmatic Validation

```python
from IntegrationPackageUpsert import create_package_upsert

# Validate integration interface
config = {'rate_limit': 60, 'debug': True}
orchestrator = create_package_upsert('XEROBLUE', config)

# Check integration compliance
is_valid = orchestrator.validate_integration()
print(f"Interface compliance: {is_valid}")

# Get integration information
info = orchestrator.get_integration_info()
print(f"Available endpoints: {len(info.get('available_endpoints', []))}")

# Test configuration validation
config_valid = orchestrator.integration.validate_configuration()
print(f"Configuration valid: {config_valid}")
```

## 📋 Configuration Options

### Integration Configuration (BIGOLESHOECOMPANY-tested)

```python
config = {
    # API Settings (tested with BIGOLESHOECOMPANY)
    'rate_limit': 60,                    # XeroBlue: 60 calls/minute
    'timeout_seconds': 900,              # 15 minutes timeout
    'debug': True,                       # Enable debug logging
    
    # Error Handling
    'max_retries': 3,                    # API retry attempts
    'continue_on_error': True,           # Continue if endpoint fails
    'fail_on_token_error': True,         # Stop if token refresh fails
    
    # Processing Settings
    'save_responses': True,              # Save API responses locally
    'validate_data_types': True,         # Apply data type conversions
    
    # Database Settings
    'database_timeout': 300,             # Database operation timeout
    'batch_size': 1000,                  # Records per database batch
}
```

### XeroBlue Specific Settings

```python
# XeroBlue tested configuration
xeroblue_config = {
    'rate_limit': 60,                    # Xero API limit: 60/minute
    'timeout_seconds': 900,              # Long timeout for large datasets
    'include_reports': False,            # Include report endpoints
    'include_attachments': False,        # Include attachment endpoints
    'apply_rate_limiting': True,         # Automatic rate limiting
    'token_refresh_threshold': 300,      # Refresh token 5 mins before expiry
}
```

### Azure File Share Configuration

```python
# Azure configuration (from BIGOLESHOECOMPANY test)
azure_config = {
    'storage_account': 'etanissis',
    'account_key': 'REDACTED',
    'file_share_name': 'xeroblue-pydw-refreshtoken',
    'connection_timeout': 30,
    'retry_attempts': 3
}
```

## 🔄 Plug-and-Play Architecture

### How It Works

```
┌─────────────────────────────────────────────────────────┐
│                 Generic Orchestrator                    │
│              (IntegrationPackageUpsert)                │
├─────────────────────────────────────────────────────────┤
│ 1. Validates integration interface                      │
│ 2. Validates configuration                              │
│ 3. Runs integration (delegates ALL business logic)     │
│ 4. Adds orchestrator metadata                          │
│ 5. Logs execution summary                              │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│            Integration Class                            │
│        (XeroBlueIntegrationEnhanced)                   │
├─────────────────────────────────────────────────────────┤
│ • Contains ALL business logic                           │
│ • Handles API requests and transformations             │
│ • Manages database operations                          │
│ • Implements standardized interface:                   │
│   - validate_configuration()                           │
│   - run_full_sync(endpoint_list)                      │
│   - extract_api_response(endpoint)                     │
└─────────────────────────────────────────────────────────┘
```

### Standard Integration Interface

Every integration must implement:

```python
class MyIntegration:
    # Required attributes
    integration_name: str = "MY_INTEGRATION"
    
    # Required methods
    def validate_configuration(self) -> bool:
        """Validate configuration and environment"""
        pass
    
    def run_full_sync(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """Run full synchronization"""
        pass
    
    # Optional methods for enhanced functionality
    def extract_api_response(self, endpoint: str) -> Dict[str, Any]:
        """Process single endpoint"""
        pass
    
    def get_endpoints_list(self) -> List[str]:
        """Get available endpoints"""
        pass
```

## 🚀 Production Usage Examples

### 1. BIGOLESHOECOMPANY Production Run

```bash
#!/bin/bash
# production_run_bigoleshoe.sh

# Set BIGOLESHOECOMPANY environment
export EtaniClientID="BIGOLESHOECOMPANY_CLIENT1518"
export EtaniOrganisationID="7232"
export XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43"
export xeroblue_client_id="7D624AC6AEAA49CAA480DC684FCAA0C4"
export xeroblue_client_secret="REDACTED"
export AZ_FILE_SHARE="etanissis"
export AZ_FILE_SHARE_KEY="REDACTED"
export FILE_SHARE_NAME="xeroblue-pydw-refreshtoken"

# Run ETL with production settings
python run_integration.py \
    --integration XEROBLUE \
    --rate-limit 60 \
    --timeout 900 \
    2>&1 | tee /var/log/etl/bigoleshoe_$(date +%Y%m%d_%H%M%S).log
```

### 2. Docker Production Deployment

```yaml
# docker-compose.production.yml
version: '3.8'
services:
  bigoleshoe-etl:
    image: etanietl.azurecr.io/plug-and-play-etl:latest
    environment:
      - EtaniClientID=BIGOLESHOECOMPANY_CLIENT1518
      - EtaniOrganisationID=7232
      - XeroTenantID=865512af-e7d8-4d42-8568-73084279eb43
      - AZ_FILE_SHARE=etanissis
      - FILE_SHARE_NAME=xeroblue-pydw-refreshtoken
    env_file:
      - bigoleshoe_secrets.env  # Contains sensitive credentials
    command: >
      python run_integration.py 
      --integration XEROBLUE 
      --rate-limit 60 
      --timeout 900
    volumes:
      - ./logs:/var/log/etl
    restart: unless-stopped
```

### 3. Scheduled Cron Job

```bash
# Add to crontab: crontab -e
# Run BIGOLESHOECOMPANY ETL every 4 hours
0 */4 * * * /opt/etl/production_run_bigoleshoe.sh
```

## 📊 Monitoring and Logs

### Success Output Example (BIGOLESHOECOMPANY)

```
================================================================================
Plug-and-Play ETL System - Simple Entry Point
================================================================================
Integration: XEROBLUE
✅ Environment validation passed

Current environment:
  EtaniClientID: BIGOLESHOECOMPANY_CLIENT1518
  EtaniOrganisationID: 7232
  XeroTenantID: 865512af-e7d8-4d42-8568-73084279eb43

Creating XEROBLUE integration orchestrator...

Integration Information:
  integration_name: XEROBLUE
  integration_class: XeroBlueIntegrationEnhanced
  execution_id: XEROBLUE_1749109525
  orchestrator_version: 2.0.0
  available_endpoints: [34 items]
  rate_limit: 60

🚀 Running full synchronization...

============================================================
XeroBlue Integration - Full Sync
============================================================
✅ Configuration validation passed

Processing 34 endpoints...

[1/34] Processing Organisations...
=== Processing Organisations ===
Stage Table: c1518_7232_xeroblue_OrganisationsSTAGE  
Retrieved 1 records from Xero API
✅ Organisations completed: 1 staged, 1 in production

[2/34] Processing Accounts...
=== Processing Accounts ===
Retrieved 156 records from Xero API
✅ Accounts completed: 156 staged, 156 in production

...

============================================================
XeroBlue Integration - Execution Summary
============================================================
Status: completed
Duration: 287.5 seconds
Endpoints: 34/34 successful
Records Processed: 2,847
============================================================

================================================================================
EXECUTION SUMMARY
================================================================================
Status: completed
Execution ID: XEROBLUE_1749109525
Integration: XEROBLUE
Duration: 287.82 seconds
Endpoints: 34/34 successful
Records Processed: 2,847

✅ Execution completed successfully
```

### Error Handling Example

```
❌ Missing required environment variables: ['xeroblue_client_secret']

Please set the following environment variables:
  export xeroblue_client_secret=<value>

💥 Execution failed: Integration interface validation failed

Expected token file: BIGOLESHOECOMPANY_CLIENT1518_7232.txt
This file should exist in Azure File Share: etanissis/xeroblue-pydw-refreshtoken/
```

## 🔧 Advanced Usage

### 1. Custom Configuration Files

```bash
# Create custom config file
cat > bigoleshoe_config.json << EOF
{
    "rate_limit": 30,
    "timeout_seconds": 1200,
    "debug": true,
    "save_responses": true,
    "include_reports": false
}
EOF

# Use custom config
python run_integration.py \
    --integration XEROBLUE \
    --config-file bigoleshoe_config.json
```

### 2. Adding New Integrations

```python
# Step 1: Create new integration class
class MyNewIntegration:
    integration_name = "MYNEW"
    
    def validate_configuration(self) -> bool:
        # Implement configuration validation
        return True
    
    def run_full_sync(self, endpoint_list=None) -> Dict[str, Any]:
        # Implement full synchronization logic
        return {'status': 'completed'}

# Step 2: Register in factory function
# Add to IntegrationPackageUpsert.py create_package_upsert()
elif integration_name == 'MYNEW':
    from integrations.mynew_integration import MyNewIntegration
    integration_instance = MyNewIntegration(config)

# Step 3: Use it
python run_integration.py --integration MYNEW
```

### 3. Custom Entry Points

```python
#!/usr/bin/env python3
# custom_bigoleshoe_runner.py

from IntegrationPackageUpsert import create_package_upsert

# BIGOLESHOECOMPANY specific configuration
BIGOLESHOE_CONFIG = {
    'rate_limit': 45,  # Slightly conservative
    'timeout_seconds': 1200,  # Longer timeout
    'debug': True,
    'save_responses': True
}

def run_bigoleshoe_etl():
    """Custom runner for BIGOLESHOECOMPANY"""
    print("🏢 BIGOLESHOECOMPANY ETL Starting...")
    
    orchestrator = create_package_upsert('XEROBLUE', BIGOLESHOE_CONFIG)
    
    # Run priority endpoints first
    priority_endpoints = ['Organisations', 'Accounts', 'Contacts']
    result1 = orchestrator.run(priority_endpoints)
    
    if result1.get('status') == 'completed':
        # Run remaining endpoints
        result2 = orchestrator.run()
        return result2
    else:
        return result1

if __name__ == "__main__":
    result = run_bigoleshoe_etl()
    print(f"Final status: {result.get('status')}")
```

## 🚨 Troubleshooting

### Common Issues and Solutions

#### 1. Token File Not Found
```
Error: ResourceNotFound - The specified resource does not exist
Expected: BIGOLESHOECOMPANY_CLIENT1518_7232.txt
Solution: 
- Verify token file exists in Azure File Share
- Check path: etanissis/xeroblue-pydw-refreshtoken/
- Ensure file contains valid JSON with access_token and refresh_token
```

#### 2. Authentication Errors
```
Error: 401 Unauthorized
Solutions:
- Check XeroTenantID matches the organization
- Verify xeroblue_client_id and xeroblue_client_secret
- Ensure token file is not expired
- Check if Xero app has necessary scopes
```

#### 3. Rate Limiting Issues
```
Behavior: Automatic waiting when rate limit reached
Configuration: Adjust rate_limit to be more conservative
Example: --rate-limit 30 (instead of 60)
```

#### 4. Database Connection Issues
```
Error: Failed to connect to database
Check:
- DB_Destination environment variable
- Database credentials and connectivity
- Network access from container/server
```

### Testing Commands

```bash
# Test environment setup
python run_integration.py --integration XEROBLUE --info-only

# Test single endpoint
python run_integration.py --integration XEROBLUE --endpoint Organisations

# Test with debug output
python run_integration.py --integration XEROBLUE --debug --endpoints Organisations,Accounts

# Run comprehensive test
python test_comprehensive_integration.py --mode bigoleshoe --verbose
```

## 📞 Support and Maintenance

### Health Check Commands

```bash
# Quick environment validation
python -c "
from IntegrationPackageUpsert import create_package_upsert
try:
    orchestrator = create_package_upsert('XEROBLUE', {'debug': True})
    print('✅ System healthy')
except Exception as e:
    print(f'❌ System issue: {e}')
"

# Validate specific configuration
python -c "
import os
config_items = [
    'EtaniClientID', 'EtaniOrganisationID', 'XeroTenantID',
    'xeroblue_client_id', 'xeroblue_client_secret',
    'AZ_FILE_SHARE', 'AZ_FILE_SHARE_KEY'
]
missing = [item for item in config_items if not os.getenv(item)]
if missing:
    print(f'❌ Missing: {missing}')
else:
    print('✅ All required env vars set')
"
```

### Maintenance Schedule

```bash
# Weekly token validation
0 2 * * 1 /opt/etl/scripts/validate_tokens.sh

# Daily health check
0 1 * * * /opt/etl/scripts/health_check.sh

# Monthly log cleanup
0 3 1 * * /opt/etl/scripts/cleanup_logs.sh
```

### Monitoring Alerts

Set up monitoring for:
- ETL execution failures
- Token expiration warnings
- Database connection issues
- API rate limit violations
- Long execution times (>30 minutes)

## 🔮 Migration from Legacy Systems

### From Monolithic XEROBLUE - UPSERT.py

```bash
# 1. Backup existing configuration
cp XEROBLUE\ -\ UPSERT.py XEROBLUE_UPSERT_backup.py

# 2. Extract environment variables from old script
grep -E "os.getenv|os.environ" XEROBLUE_UPSERT_backup.py

# 3. Create environment file with extracted variables
# 4. Test new system with same configuration
python run_integration.py --integration XEROBLUE --info-only

# 5. Run parallel for validation
python run_integration.py --integration XEROBLUE --endpoints Organisations,Accounts
```

The plug-and-play system maintains 100% compatibility with existing XEROBLUE functionality while providing improved modularity, error handling, and maintainability.