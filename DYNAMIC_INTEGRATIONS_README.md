# Dynamic Integrations - User Guide

The Dynamic Integrations system allows you to create and run automated integrations with any system. The workflow consists of 5 main steps:

## 📋 Process Overview

1. **Generate SQL** - Create SQL files from schema
2. **Execute SQL** - Run SQL to create tables/views in database  
3. **Update Config** - Update config with specific parameters
4. **Generate Integration** - Create Python integration file from config
5. **Run Integration** - Execute integration to sync data

---

## 🗂️ Directory Structure

```
dynamic_integrations/
├── generator/
│   ├── config/           # Config files for integrations
│   │   ├── qbo_config.json
│   │   ├── xero_config.json
│   │   └── simpro_config.json
│   ├── generate.py       # Generate SQL files
│   ├── sql_executor.py   # Execute SQL files
│   └── generator.py      # Generate integration scripts
├── generated_integrations/
│   ├── qbo/
│   │   ├── run_qbo_integration.py
│   │   ├── schemas/
│   │   └── sql/
│   ├── xero/
│   └── simpro/
└── examples/
    └── quick_*_example.py
```

---

## 1️⃣ Generate SQL Files

Create SQL files (CREATE TABLE, VIEW, etc.) from schema configuration.

### Usage:

```bash
# Generate SQL for QBO from schema file
python dynamic_integrations/generator/generator.py /path/to/qbo_schema.json --sql --force

# Generate SQL for Xero from schema file  
python dynamic_integrations/generator/generator.py /path/to/xero_schema.json --sql --force

# Generate SQL without force (keep existing files)
python dynamic_integrations/generator/generator.py /path/to/schema.json --sql
```

### Parameters:
- Schema file path (required, first argument)
- `--sql`: Generate SQL files
- `--force`: Overwrite existing files (optional)

### Output:
- Creates `generated_integrations/{integration}/sql/` directory
- Contains `.sql` files to create tables, views, procedures

---

## 2️⃣ Execute SQL Files

Run the generated SQL files to create database structure.

### Usage:

```bash
# Execute all SQL for QBO
python sql_executor.py --integration qbo --section all

# Execute SQL with specific client-id and org-id
python sql_executor.py --integration qbo --client-id 2013 --org-id 7035 --section all

# Execute SQL for Xero
python sql_executor.py --integration xero --section all

# Execute specific section
python sql_executor.py --integration qbo --section tables
python sql_executor.py --integration qbo --section views
```

### Options:
- `--integration`: Integration name (required)
- `--section`: Section to execute (all, tables, views, procedures)
- `--client-id`: Specific client ID (optional)
- `--org-id`: Specific organization ID (optional)

---

## 3️⃣ Update Config (Manual)

Update config files with specific parameters for each client/environment.

### Usage:

```bash
# Update config for QBO with parameters
python update_config.py --integration qbo \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789

# Update config for Xero
python update_config.py --integration xero \
  --param EtaniClientID=TESTCLIENT \
  --param XeroTenantID=abc-123-def \
  --param DB_Destination=EVA

# Update with multiple parameters
python update_config.py --integration qbo \
  --param EtaniClientID=CLIENT123 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=456789 \
  --param DB_Destination=DW \
  --param TRIGGER_TYPE=MANUAL \
  --param Reset_Mode=false

# Dry run to see what will be updated
python update_config.py --integration qbo \
  --param EtaniClientID=CLIENT123 \
  --dry-run

# Restore config from backup
python update_config.py --integration qbo --restore
```

### Common Parameters:
- `EtaniClientID`: Client identifier (required)
- `EtaniOrganisationID`: Organisation ID (required)  
- `RealmID`: QBO Realm ID (for QBO)
- `XeroTenantID`: Xero Tenant ID (for Xero)
- `DB_Destination`: Target database (EVA, DW, EVADW)
- `TRIGGER_TYPE`: Trigger type (MANUAL, SCHEDULED)
- `Reset_Mode`: Reset data flag (true/false)

---

## 4️⃣ Generate Integration Scripts

Create Python integration file from updated config.

### Usage:

```bash
# Generate integration script from schema file
python dynamic_integrations/generator/generator.py /path/to/qbo_schema.json --dynamic-integration-file --force

# Generate for Xero
python dynamic_integrations/generator/generator.py /path/to/xero_schema.json --dynamic-integration-file --force

# Generate without force (keep existing files)
python dynamic_integrations/generator/generator.py /path/to/schema.json --dynamic-integration-file
```

### Parameters:
- Schema file path (required, first argument)
- `--dynamic-integration-file`: Generate integration script
- `--force`: Overwrite existing files (optional)

### Output:
- Creates `generated_integrations/{integration}/run_{integration}_integration.py`
- This file contains logic to sync data from API to database

---

## 5️⃣ Run Dynamic Integration

Execute integration to sync data. This is the universal command that can run any integration.

### 🖥️ Run Directly (Local)

```bash
# Run QBO integration with parameters
python run_dynamic_integration.py --integration qbo \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789

# Run Xero integration
python run_dynamic_integration.py --integration xero \
  --param EtaniClientID=TESTCLIENT \
  --param XeroTenantID=abc-123-def \
  --param DB_Destination=EVA

# Run new integration (Simpro)
python run_dynamic_integration.py --integration simpro \
  --param EtaniClientID=CLIENT123 \
  --param SimproApiKey=your_api_key \
  --param SimproBaseUrl=https://api.simpro.com

# Dry run (only update config, don't run integration)
python run_dynamic_integration.py --integration qbo \
  --param EtaniClientID=CLIENT123 \
  --dry-run

# Restore config from backup
python run_dynamic_integration.py --integration qbo --restore
```

### 🐳 Run with Docker

Run integration in Docker container with environment variables:

```bash
# Build image (if not already built)
docker build -t etl-packages .

# Run QBO integration in Docker
docker run --rm \
  -e EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  -e EtaniOrganisationID=7035 \
  -e RealmID=123456789 \
  -e DB_Destination=EVA \
  -e TRIGGER_TYPE=MANUAL \
  etl-packages \
  python run_dynamic_integration.py --integration qbo \
    --param EtaniClientID=$EtaniClientID \
    --param EtaniOrganisationID=$EtaniOrganisationID \
    --param RealmID=$RealmID \
    --param DB_Destination=$DB_Destination \
    --param TRIGGER_TYPE=$TRIGGER_TYPE

# Run Xero integration in Docker
docker run --rm \
  -e EtaniClientID=TESTCLIENT \
  -e XeroTenantID=abc-123-def \
  -e DB_Destination=DW \
  etl-packages \
  python run_dynamic_integration.py --integration xero \
    --param EtaniClientID=$EtaniClientID \
    --param XeroTenantID=$XeroTenantID \
    --param DB_Destination=$DB_Destination

# Run with docker-compose
docker-compose run --rm app \
  python run_dynamic_integration.py --integration qbo \
    --param EtaniClientID=CLIENT123 \
    --param RealmID=456789
```

### Docker Environment Variables

When running with Docker, you can set environment variables and pass them to the script:

```bash
# Set environment variables
export EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013
export EtaniOrganisationID=7035
export RealmID=123456789
export DB_Destination=EVA

# Run with env vars
docker run --rm \
  -e EtaniClientID \
  -e EtaniOrganisationID \
  -e RealmID \
  -e DB_Destination \
  etl-packages \
  python run_dynamic_integration.py --integration qbo \
    --param EtaniClientID=$EtaniClientID \
    --param EtaniOrganisationID=$EtaniOrganisationID \
    --param RealmID=$RealmID \
    --param DB_Destination=$DB_Destination
```

---

## 🔧 Advanced Options

### Auto-Discovery Integration Scripts

The `run_dynamic_integration.py` script automatically finds integration scripts in:
```
generated_integrations/{integration}/*_integration.py
```

If multiple files exist, it will use the first one found.

### Parameter Matching

Script matches parameters in this order:
1. Exact match with `env_var` name in config
2. Match with config key (uppercase)  
3. Match with config key (lowercase)

### Backup & Restore

Each time config is updated, script automatically creates backup:
```
{integration}_config.json.backup
```

Restore with:
```bash
python run_dynamic_integration.py --integration qbo --restore
```

---

## 📚 Complete Examples

### QBO Integration Flow

```bash
# 1. Generate SQL
python dynamic_integrations/generator/generator.py /path/to/qbo_schema.json --sql --force

# 2. Execute SQL  
python sql_executor.py --integration qbo --section all

# 3. Update config
python update_config.py --integration qbo \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789

# 4. Generate integration
python dynamic_integrations/generator/generator.py /path/to/qbo_schema.json --dynamic-integration-file --force

# 5. Run integration
python run_dynamic_integration.py --integration qbo \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789
```

### New Integration (Simpro)

```bash
# 1. Generate SQL
python dynamic_integrations/generator/generator.py /path/to/simpro_schema.json --sql --force

# 2. Execute SQL
python sql_executor.py --integration simpro --section all

# 3. Update config
python update_config.py --integration simpro \
  --param EtaniClientID=CLIENT123 \
  --param EtaniOrganisationID=456 \
  --param SimproApiKey=your_api_key

# 4. Generate integration
python dynamic_integrations/generator/generator.py /path/to/simpro_schema.json --dynamic-integration-file --force

# 5. Run integration with Simpro parameters
python run_dynamic_integration.py --integration simpro \
  --param EtaniClientID=CLIENT123 \
  --param EtaniOrganisationID=456 \
  --param SimproApiKey=your_api_key \
  --param SimproBaseUrl=https://api.simpro.com \
  --param DB_Destination=EVA
```

---

## ⚠️ Important Notes

1. **Config files**: Must exist in `dynamic_integrations/generator/config/` before running
2. **Database connection**: Ensure correct connection string in sql_executor
3. **Python path**: Integration scripts need access to `dynamic_integrations` module
4. **Parameters**: Parameter names must match config definition in `env_vars_config`
5. **Docker**: Ensure environment variables are passed correctly to container

---

## 🚨 Troubleshooting

### Error "Config file not found"
```bash
# Check if config file exists
ls dynamic_integrations/generator/config/{integration}_config.json
```

### Error "Integration folder not found"  
```bash
# Check integration directory
ls dynamic_integrations/generated_integrations/{integration}/
```

### Error "No integration script found"
```bash
# Regenerate integration script
python dynamic_integrations/generator/generator.py /path/to/schema.json --dynamic-integration-file --force
```

### Error "ModuleNotFoundError: No module named 'dynamic_integrations'"
```bash
# Run from project root, or set PYTHONPATH
export PYTHONPATH=/path/to/etl-packages:$PYTHONPATH
```