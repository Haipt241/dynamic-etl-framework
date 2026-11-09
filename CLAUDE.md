# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is Etani's ETL (Extract, Transform, Load) system for syncing data from various business platforms (Xero, QuickBooks, MYOB, FYI, Karbon HQ, etc.) to MySQL databases. The system supports both Azure MySQL and AWS RDS Aurora deployments with automatic connection pooling.

The project uses a **dynamic integration generator** that creates SQL objects and Python integration scripts from JSON schema configurations, enabling new integrations to be added without modifying core code.

## Development Commands

### Running Integrations Locally

**Legacy integrations (Xero/QBO):**
```bash
# Xero UPSERT
USE_AWS_DB=True DB_Destination="DW" JOB_ID=0 JOB_RUN_ID=0 TRIGGER_TYPE="MANUAL" \
  EtaniClientID="BIGOLESHOECOMPANY_CLIENT1518" EtaniOrganisationID="5393" \
  XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43" \
  python -u "XEROBLUE - UPSERT.py"

# QBO testing
python dynamic_integrations/examples/quick_qbo_example.py
```

**Dynamic integrations (recommended):**
```bash
# DATABASE-DRIVEN mode (Lambda-friendly - only provide org_id)
# Container fetches all parameters from vibedb_cms database
python run_dynamic_integration.py --org-id 7102 --mode upsert

# INSERT mode (initial setup with SQL execution)
python run_dynamic_integration.py --integration qbo --mode insert \
  --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
  --param EtaniOrganisationID=7035 \
  --param RealmID=123456789

# UPSERT mode (incremental sync with explicit parameters)
python run_dynamic_integration.py --integration fyi --mode upsert \
  --param EtaniClientID=CLIENT123 \
  --param EtaniOrganisationID=7035 \
  --param AccessID=xxx \
  --param AccessSecret=yyy
```

### Testing

```bash
# Run all tests
pytest tests/

# Run specific test file
pytest tests/test_consolidated_cms_functionality.py

# Quick SQL testing
python test_aws_sql_helper_quick.py
python test_sql_error_logging.py
```

### Docker

```bash
# Build and push dynamic integration image
./build_and_push_dynamic_image.sh

# Build legacy Xero/QBO image
docker build --build-arg AZURE_CLIENT_ID=xxx --build-arg AZURE_CLIENT_SECRET=yyy \
  -t etani-etl-python:latest -f ./Dockerfile_api . && \
  docker tag etani-etl-python:latest etanietl.azurecr.io/xero-etl-python:latest && \
  docker push etanietl.azurecr.io/xero-etl-python:latest

# Run with docker-compose
docker-compose run --rm app python run_dynamic_integration.py --integration qbo --mode insert
```

### Dynamic Integration Generator Workflow

```bash
# 1. Generate SQL from schema
python dynamic_integrations/generator/generator.py /path/to/schema.json --sql --force

# 2. Execute SQL to create database objects
python dynamic_integrations/sql_executor.py --integration qbo --section all

# 3. Update config with client-specific parameters
python update_config.py --integration qbo --param EtaniClientID=CLIENT123

# 4. Generate Python integration file
python dynamic_integrations/generator/generator.py /path/to/schema.json --dynamic-integration-file --force

# 5. Run the integration
python run_dynamic_integration.py --integration qbo --mode insert
```

## Architecture

### Core Components

**1. Dynamic Integration System (`dynamic_integrations/`)**
- **Base Interface:** `base_integration.py` - Abstract class defining the contract all integrations must implement (INSERT/UPSERT capabilities)
- **Registry:** `IntegrationPackage.py` - Integration-agnostic orchestrator that works with any BaseIntegration instance
- **Generator:** `generator/` - Creates SQL objects and Python integration scripts from JSON schemas
- **SQL Executor:** `sql_executor.py` - Executes generated SQL files to create tables, views, procedures
- **Generated Integrations:** `generated_integrations/{integration}/` - Auto-generated integration scripts and SQL

**2. Database Abstraction Layer**
- **sql_helper.py** - Core database helper with AWS/Azure connection pooling
  - Uses SQLAlchemy QueuePool for connection reuse (50-100x faster than creating new connections)
  - Supports both AWS RDS Aurora (via `USE_AWS_DB=True`) and Azure MySQL
  - AWS credentials retrieved from Secrets Manager or environment variables
  - Automatic retry logic with tenacity for transient failures
  - Cost tracking integration via global `cost_tracker` instance
  - Query monitoring integration via `QueryMonitoringClient`

**3. Legacy Integration Scripts**
- `XEROBLUE - UPSERT.py` - Xero full sync (legacy)
- `XEROBLUE - INSERT.py` - Xero initial load (legacy)
- `QBO - UPSERT.py` - QuickBooks sync (legacy)
- `main.py` - MYOB AccountRight integration (legacy)

**4. Supporting Infrastructure**
- **config.py** - Configuration management (credentials, connection strings)
- **utils.py** - Shared utilities (acronym generation, timestamp formatting)
- **query_monitoring_client.py** - Query performance tracking for optimization
- **container_monitoring_client.py** - Container execution monitoring
- **common_token_manager.py** - OAuth token management with Azure File Share storage

### Database Environments

The system supports multiple target databases via `DB_Destination` environment variable:
- **EVA** - Legacy Azure MySQL (being migrated away from)
- **EVADW** - Azure MySQL data warehouse
- **DW** - AWS RDS Aurora (recommended, uses connection pooling)

Client data is isolated by prefixing: `{ClientID}_{OrgID}_{Integration}_TableName`

Example: `BIGOLESHOECOMPANY_CLIENT1518_5393_XERO_Invoices`

### AWS RDS Aurora Connection Pooling

**Key Features:**
- Credentials stored in AWS Secrets Manager (`rds!cluster-44496612-3d03-451b-9749-88451f45fed7`)
- SQLAlchemy QueuePool maintains 10 persistent connections per integration
- Connection pool is per-FIRMCODE (extracted from `EtaniClientID` prefix before underscore)
- Automatic health checks and stale connection recycling (3600s timeout)
- Pool statistics available via `get_pool_status()`

**Usage Pattern:**
```python
# Initialize once at startup
from sql_helper import initialize_aws_engine
initialize_aws_engine(use_secrets_manager=True)

# Use throughout application
from sql_helper import read_aws_table, execute_aws_query
df = read_aws_table("SELECT * FROM table WHERE id = :id", params={'id': 123})
execute_aws_query("CALL sp_process(:param)", params={'param': 'value'})
```

### Integration Capabilities System

Integrations declare their capabilities via `IntegrationCapability` enum:
- **INSERT** - Initial data load only (requires `get_insert_configuration()`)
- **UPSERT** - Incremental sync only (requires `run_full_sync()`)
- **BOTH** - Supports both INSERT and UPSERT modes

The orchestrator (`IntegrationPackage`) validates capabilities and auto-detects which methods are required.

## Critical Implementation Details

### Adding New Integrations

**Never modify core orchestrator code.** Instead:

1. Create integration schema JSON in `dynamic_integrations/generator/config/{integration}_schema.json`
2. Run generator to create SQL and Python files
3. Your generated integration automatically inherits from `BaseIntegration`
4. The system discovers and runs it via `run_dynamic_integration.py`

See `INTEGRATION_AGNOSTIC_GUIDE.md` for the plug-and-play architecture.

### SQL Object Generation

The generator creates:
- **Stage tables** (`_STG` suffix) - Raw API data storage
- **Production tables** - Cleaned, transformed data
- **Views** - Business logic aggregations
- **Stored procedures** - Complex transformations (e.g., `sp_LoadFromSTG_{Table}`)

SQL objects use dynamic prefixes based on client: `{ClientID}_{OrgID}_{Integration}_`

### OAuth Token Management

Tokens stored in Azure File Share (`token/{ClientID}_{OrgID}.txt`) with file locking:
- `common_token_manager.py` - Handles Xero OAuth with refresh token rotation
- Lock files prevent concurrent token refreshes: `{ClientID}_{OrgID}.txt.lock`
- Automatic token refresh before expiry (3600s lifetime)

### Error Handling & Logging

**SQL Error Logging:**
- Errors logged to `logs/sql_errors/{timestamp}_{integration}.json`
- Contains query text, parameters, stack trace, database context
- Enables post-mortem debugging of production issues

**Query Performance Monitoring:**
- Optional integration with CMS Backend API (`ETL_API_URL`, `ETL_API_KEY`)
- Tracks execution time, rows examined, slow queries (>30s)
- AI-powered optimization suggestions via Claude

### Organization Status Management

Integrations check organization status before execution via CMS Manager:
- **Status 12** (Updating Data) - Allows normal execution
- **Status 16** (Resetting Data) - Requires `Reset_Mode=true` environment variable
- Prevents accidental data corruption during org setup/migration

### Cost Tracking

Dynamic integrations can track operation costs:
```python
from sql_helper import cost_tracker
cost_tracker = CostTracker(integration_name, client_id)
# Automatically tracks INSERT/UPDATE/SELECT/STORED_PROC operations
# Reports total cost at end: container_cost_usd
```

## Environment Variables

**Database Selection:**
- `USE_AWS_DB` - Set to `True` for AWS RDS Aurora (default: `False` = Azure MySQL)
- `DB_Destination` - Target database (`EVA`, `EVADW`, `DW`)

**AWS Configuration (when `USE_AWS_DB=True`):**
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret key
- `AWS_DEFAULT_REGION` - Default: `ap-northeast-3`

**Query Monitoring (optional):**
- `QUERY_MONITORING_ENABLED` - Enable query performance tracking
- `ETL_API_URL` - Backend API URL (e.g., `https://apidev.vibecfo.au/api/etl`)
- `ETL_API_KEY` - API key for monitoring

**Integration Parameters:**
- `EtaniClientID` - Client identifier (e.g., `BIGOLESHOECOMPANY_CLIENT1518`)
- `EtaniOrganisationID` - Organization ID number
- `XeroTenantID` - Xero tenant ID (for Xero integrations)
- `RealmID` - QuickBooks realm ID (for QBO integrations)
- `TRIGGER_TYPE` - `MANUAL` or `SCHEDULED`
- `Reset_Mode` - Set to `true` to bypass status 16 protection

## Important Patterns

### Database Engine Management

The system maintains per-FIRMCODE connection pools:
```python
# Engine is cached and reused across calls for same FIRMCODE
# FIRMCODE extracted from EtaniClientID: "BIGOLESHOECOMPANY_CLIENT1518" → "BIGOLESHOECOMPANY"
# Calling refresh_aws_engines_if_needed() when ClientID changes is critical
```

### Incremental Sync (UPSERT Mode)

Auto-detects last sync timestamp from production tables:
```python
# Priority 1: Custom --param time-from=2024-01-15T10:30:00
# Priority 2: Query MAX(EtlUpdateTime) from production table
# Priority 3: Full load if endpoint doesn't support incremental sync
```

### VS Code Launch Configurations

See `.vscode/launch.json` for pre-configured debug configurations:
- Xero INSERT/UPSERT with test clients
- Dynamic integration runner with MYOB example
- Environment variables pre-populated for quick testing

## File Organization

**Do not edit auto-generated files directly:**
- `dynamic_integrations/generated_integrations/{integration}/` - Regenerate via generator
- `sql_object_scripts.py` - Contains legacy SQL definitions (being phased out)
- `create_dynamic_sqlobjects_*.py` - Legacy SQL object creation scripts

**Key configuration files:**
- `requirements.txt` - Python dependencies (pandas, sqlalchemy, boto3, etc.)
- `docker-compose.yml` - Local Docker development setup
- `Dockerfile_dynamic` - Dynamic integration container image
- `.env` - Local environment variables (not committed)

## Common Issues

**Connection Pool Exhaustion:**
- Check pool status: `get_pool_status()`
- Ensure connections are properly closed in finally blocks
- Default pool size is 10 connections per FIRMCODE

**Token Refresh Failures:**
- Check Azure File Share connectivity
- Verify lock file cleanup (stale `.txt.lock` files)
- Token refresh requires valid `refresh_token` in parameters

**SQL Execution Timeouts:**
- Large table operations may need increased timeout
- Consider batch processing for bulk inserts
- Use stored procedures for complex transformations

**Generator Errors:**
- Ensure schema JSON validates against expected format
- Check `env_vars_config` section matches required parameters
- SQL files must be executed in order: tables → views → procedures
