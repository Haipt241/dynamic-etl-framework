# Dynamic Integration System - Setup Guide

## 📋 Overview

This guide walks you through setting up a new dynamic integration from scratch, from API documentation to running live data synchronization.

## 🚀 Quick Start Process

### Step 1: Create Sample Data File
**Purpose**: Provide input data for schema generation based on API documentation

#### 1.1 Gather API Information
From your API documentation, collect:
- **API Endpoints**: List of available endpoints (e.g., `/customers`, `/orders`, `/products`)
- **Authentication**: Auth type and credential format
- **Sample Requests**: Example API calls with parameters
- **Sample Responses**: JSON response examples from each endpoint
- **Data Structures**: Nested objects, arrays, field types

#### 1.2 Create Sample Data Files
Create sample data files in directory: `dynamic_integrations/sample_data/your_integration/`

```bash
# Create sample directory for your integration
mkdir -p dynamic_integrations/sample_data/your_integration
```

Create one or more `.text` files with raw API documentation content:

**Example files**:
- `dynamic_integrations/sample_data/shopify/products.text`
- `dynamic_integrations/sample_data/shopify/customers.text`
- `dynamic_integrations/sample_data/shopify/orders.text`

**Content format** - Raw copy paste from API documentation:
```
API Base URL: https://api.shopify.com/admin/api/2023-10

Authentication: X-Shopify-Access-Token header

GET /products.json
Response:
{
  "products": [
    {
      "id": 632910392,
      "title": "IPod Nano - 8GB", 
      "handle": "ipod-nano",
      "created_at": "2024-01-15T10:30:00-05:00",
      "updated_at": "2024-01-15T10:30:00-05:00"
    }
  ]
}

GET /customers.json  
Response:
{
  "customers": [
    {
      "id": 207119551,
      "email": "bob.norman@mail.example.com",
      "created_at": "2024-01-15T11:30:00-05:00"
    }
  ]
}
```

**Important**:
- Files must have `.text` extension
- No JSON structure needed - just raw copy paste
- Can split into multiple files or put all in one file
- System auto-discovers all `.text` files in directory

💡 **Reference existing samples**: Check `dynamic_integrations/sample_data/` for examples from other integrations.

### Step 2: Generate Schema File
**Purpose**: Create schema configuration from sample data

#### 2.1 Run Schema Extractor
```bash
# Navigate to project root directory
cd etl-packages

# Generate schema from sample directory
python dynamic_integrations/schema_extractor.py \
  dynamic_integrations/sample_data/your_integration \
  --base-info-source "https://docs.example.com/api/reference" \
  --entities all
```

#### 2.2 Command Arguments
- **endpoints_source** - Path to directory containing `.text` sample files (required)
- `--base-info-source` - URL to API documentation for base integration info
- `--entities` - Number of entities to extract ("all" or integer, default: all)
- `--endpoints-only` - Only extract endpoints without creating full schemas

#### 2.3 Review Generated Schema
⚠️ **IMPORTANT**: Always review the generated schema file:

1. **Open**: `dynamic_integrations/generated_integrations/your_integration/schemas/your_integration_schema.json`
2. **Verify**: Check against API documentation
3. **Adjust**: Manual edits for:
   - Field data types
   - Primary key identification (`is_primary_key: true`)
   - Incremental sync parameters (`incremental_sync`)
   - Authentication details
   - Pagination configuration

📖 **Schema Configuration Guide**: See [dynamic_integrations/SCHEMA_CONFIGURATION_GUIDE.md](dynamic_integrations/SCHEMA_CONFIGURATION_GUIDE.md) for detailed field explanations.

### Step 3: Generate SQL and Integration Files
**Purpose**: Create database objects and integration code

#### 3.1 Generate SQL Files
```bash
# Generate all SQL components
python dynamic_integrations/generator.py \
  dynamic_integrations/generated_integrations/your_integration/schemas/your_integration_schema.json \
  --sql

# Or add one of these options to generate specific component only:
# --stage      (stage tables only)
# --prod       (production tables only)  
# --procedure  (stored procedures only)
# --view       (view tables only)

# Example: Generate only stored procedures
python dynamic_integrations/generator.py \
  dynamic_integrations/generated_integrations/your_integration/schemas/your_integration_schema.json \
  --procedure
```

#### 3.2 Generate Integration File
```bash
# Generate dynamic integration Python file
python dynamic_integrations/generator.py \
  dynamic_integrations/generated_integrations/your_integration/schemas/your_integration_schema.json \
  --dynamic-integration-file
```

#### 3.3 Generator Arguments
- **schema_file** - Path to schema JSON file (required, positional argument)
- `--sql` - Generate all SQL files (tables, procedures, views)
- `--stage` - Generate stage tables only
- `--prod` - Generate production tables only  
- `--procedure` - Generate stored procedures only
- `--view` - Generate view tables only
- `--dynamic-integration-file` - Generate Python integration class file
- `--integration-name` - Custom integration name (optional)
- `--force` - Force overwrite existing files

### Step 4: Run Integration
**Purpose**: Execute live data synchronization

#### 4.1 Choose Your Mode

**INSERT Mode (Initial Setup)**:
```bash
python run_dynamic_integration.py \
  --integration your_integration \
  --mode insert \
  --param EtaniClientID=YOUR_CLIENT_ID \
  --param EtaniOrganisationID=YOUR_ORG_ID \
  --param YourAPIKey=your_api_credentials
```

**UPSERT Mode (Incremental Updates)**:
```bash
python run_dynamic_integration.py \
  --integration your_integration \
  --mode upsert \
  --param EtaniClientID=YOUR_CLIENT_ID \
  --param EtaniOrganisationID=YOUR_ORG_ID \
  --param YourAPIKey=your_api_credentials
```

📖 **Integration Execution Guide**: See [RUN_DYNAMIC_INTEGRATION_GUIDE.md](RUN_DYNAMIC_INTEGRATION_GUIDE.md) for detailed command examples and mode differences.

## 🛠️ Directory Structure

After completing all steps, your integration will have:

```
dynamic_integrations/generated_integrations/your_integration/
├── schemas/
│   ├── your_integration_schema.json     # Main schema configuration
│   └── entities/                        # Individual endpoint schemas
│       ├── customers_schema.json
│       └── orders_schema.json
├── sql/                                 # Database scripts
│   ├── your_integration_tables.sql      # CREATE TABLE statements
│   ├── your_integration_procedures.sql  # Stored procedures
│   └── your_integration_views.sql       # Views for reporting
├── your_integration_integration.py      # Python integration class
└── README.md                           # Integration-specific documentation
```

## ✅ Validation Checklist

### Before Running Integration:
- [ ] Sample file contains realistic API responses
- [ ] Schema file reviewed and matches API documentation
- [ ] Primary keys identified with `is_primary_key: true`
- [ ] Incremental sync configured for UPSERT-capable endpoints
- [ ] SQL files generated successfully
- [ ] Integration file generated successfully
- [ ] API credentials configured properly

### After Running Integration:
- [ ] Data appears in stage tables
- [ ] Production tables populated via stored procedures
- [ ] No errors in logs
- [ ] Record counts match expectations
- [ ] UPSERT mode working for incremental updates

## 🔧 Common File Examples

### Sample File Template
```json
{
  "integration_name": "shopify",
  "api_base_url": "https://your-shop.myshopify.com/admin/api/2023-10",
  "authentication": {
    "type": "api_key",
    "header": "X-Shopify-Access-Token",
    "format": "{token}"
  },
  "endpoints": [
    {
      "name": "Products",
      "path": "/products.json",
      "sample_response": {
        "products": [
          {
            "id": 632910392,
            "title": "IPod Nano - 8GB",
            "handle": "ipod-nano",
            "created_at": "2024-01-15T10:30:00-05:00",
            "updated_at": "2024-01-15T10:30:00-05:00"
          }
        ]
      }
    }
  ]
}
```

### Schema Configuration Example
```json
{
  "integration_name": "shopify",
  "api_config": {
    "base_url": "https://your-shop.myshopify.com/admin/api/2023-10/",
    "authentication": {
      "type": "api_key",
      "header": "X-Shopify-Access-Token"
    }
  },
  "endpoints": [
    {
      "name": "Products",
      "api_details": {
        "path": "/products.json",
        "query_parameters": {
          "incremental_sync": {
            "timestamp_field": "updated_at_min",
            "timestamp_format": "YYYY-MM-DDTHH:mm:ss+00:00"
          }
        }
      },
      "fields": [
        {
          "api_name": "id",
          "db_column": "ProductID",
          "data_type": "BIGINT",
          "is_primary_key": true
        }
      ]
    }
  ]
}
```

## 📞 Support

- **Schema Configuration**: [dynamic_integrations/SCHEMA_CONFIGURATION_GUIDE.md](dynamic_integrations/SCHEMA_CONFIGURATION_GUIDE.md)
- **Integration Execution**: [RUN_DYNAMIC_INTEGRATION_GUIDE.md](RUN_DYNAMIC_INTEGRATION_GUIDE.md)
- **Troubleshooting**: Check log files and error messages for specific guidance

## 🔄 Workflow Summary

```
API Docs → Sample File → Schema Generation → Review & Edit → SQL/Integration Generation → Test Run → Production
    ↓           ↓              ↓                ↓                    ↓                      ↓           ↓
   Manual    Manual        Automated        Manual            Automated            Manual      Scheduled
```

Start with good sample data, generate and review your schema, then let the system handle the rest!

## 💡 Pro Tips

### Sample File Best Practices:
- Include realistic data with actual field types and formats
- Cover edge cases (null values, empty arrays, nested objects)
- Include multiple record examples for better schema detection
- Add comments explaining complex data structures

### Schema Review Guidelines:
- Always set `is_primary_key: true` for unique identifiers
- Configure `incremental_sync` for endpoints with modification timestamps
- Use appropriate SQL data types (BIGINT for IDs, NVARCHAR for text, etc.)
- Test timestamp formats match API requirements exactly

### Testing Strategy:
- Start with INSERT mode to validate full pipeline
- Test UPSERT mode with small data sets first
- Monitor logs for authentication and API rate limit issues
- Verify data accuracy by spot-checking records

