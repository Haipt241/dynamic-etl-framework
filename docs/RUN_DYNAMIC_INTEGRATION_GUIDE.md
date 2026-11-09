# Dynamic Integration Runner Guide

## Basic Usage

### INSERT Mode (Full Setup)
```bash
# Run specific integration - Complete setup with SQL execution
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode insert

# Run specific endpoint
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode insert --endpoint ENDPOINT_NAME

# Run with parameters
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode insert --param KEY=VALUE
```

### UPSERT Mode (Incremental Sync)
```bash
# Auto-detect timestamp from production tables
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode upsert

# Custom timestamp override
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode upsert --param time-from=2024-01-15T10:30:00

# With standard parameters
python run_dynamic_integration.py --integration INTEGRATION_NAME --mode upsert \
  --param EtaniClientID=CLIENT_ID \
  --param EtaniOrganisationID=ORG_ID
```

## Examples

### Karbon HQ Integration
```bash
python run_dynamic_integration.py --integration KARBON_HQ --mode insert \
  --param EtaniClientID=COMPANY_CLIENT1234 \
  --param EtaniOrganisationID=5678 \
  --param apiAccessKey=0ebd6906-b21f-4bc9-a739-676662e7bea7 \
  --param apiTenantAccessKey=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9

# Run specific endpoint
python run_dynamic_integration.py --integration KARBON_HQ --mode insert --endpoint Timesheets
```

### FYI Integration  

#### INSERT Mode
```bash
python run_dynamic_integration.py --integration FYI --mode insert \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2033 \
  --param EtaniOrganisationID=7160 \
  --param AccessID=60769807-d42b-4022-844e-efaa9a235a58 \
  --param AccessSecret=a33f6644259a2b590ea0d028c14f4425d48169140fe92e50ff223caf1a30bfb4
```

#### UPSERT Mode
```bash
# Auto-detect from production table EtlUpdateTime
python run_dynamic_integration.py --integration fyi --mode upsert \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param AccessID=60769807-d42b-4022-844e-efaa9a235a58 \
  --param AccessSecret=a33f6644259a2b590ea0d028c14f4425d48169140fe92e50ff223caf1a30bfb4

# With custom time-from parameter (bypasses database query)
python run_dynamic_integration.py --integration fyi --mode upsert \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param AccessID=60769807-d42b-4022-844e-efaa9a235a58 \
  --param AccessSecret=a33f6644259a2b590ea0d028c14f4425d48169140fe92e50ff223caf1a30bfb4 \
  --param time-from=2024-01-15T10:30:00
```

## Mode Differences

### INSERT Mode
- **Purpose**: Complete initial setup and full data load
- **Steps**: 
  1. Update configuration with parameters
  2. Execute SQL files to create database objects
  3. Run full data extraction
- **Use Case**: First-time integration setup or complete data refresh

### UPSERT Mode  
- **Purpose**: Incremental synchronization of existing data
- **Steps**:
  1. Update configuration with parameters
  2. Validate existing setup (assumes SQL objects already exist)
  3. Run incremental data extraction with timestamp filtering
- **Use Case**: Regular scheduled updates to sync only new/changed data

## Parameters

Parameters passed with `--param` are used to update integration configuration at runtime.

### Standard Parameters (All Integrations)
- `EtaniClientID` - Client identifier 
- `EtaniOrganisationID` - Organization ID number

### UPSERT-Specific Parameters
- `time-from` - Custom timestamp for incremental sync (ISO format: YYYY-MM-DDTHH:mm:ss)
  - **Priority 1**: Uses this custom timestamp if provided (bypasses database query)
  - **Priority 2**: Auto-detects from production table `EtlUpdateTime` if no custom timestamp
  - **Priority 3**: Falls back to full load if endpoint doesn't support incremental sync

### Integration-Specific Parameters

#### Karbon HQ
- `apiAccessKey` - Bearer token for API authentication
- `apiTenantAccessKey` - Tenant access key for dual-key auth

#### FYI
- `AccessID` - API access identifier
- `AccessSecret` - API access secret

## Incremental Sync Logic

### How UPSERT Mode Works

1. **Schema Check**: Verifies endpoint has `incremental_sync` configuration with `timestamp_field`
2. **Parameter Priority**:
   - Custom `time-from` parameter → Direct use (bypasses DB query)
   - Auto-detection → Queries `MAX(EtlUpdateTime)` from production table
   - No support → Falls back to full load
3. **Data Processing**:
   - Endpoints with primary key → TRUE UPSERT (UPDATE existing, INSERT new)
   - Endpoints without primary key → APPEND mode
4. **Timestamp Formatting**: Automatically formats timestamps according to schema `timestamp_format`

### Supported Timestamp Formats
- ISO format: `2024-01-15T10:30:00`
- ISO with timezone: `2024-01-15T10:30:00+00:00`
- Schema-specific formats (e.g., FYI: `YYYY-MM-DDTHH:mm:ss+00:00`)

## Help
```bash
python run_dynamic_integration.py --help
```