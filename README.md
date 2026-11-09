# Etani Dynamic ETL System

**Extract, Transform, Load data from business platforms to MySQL databases.**

## 🚀 Quick Start

### Main Entry Point

```bash
# Run dynamic integration (recommended)
python run_dynamic_integration.py --integration {name} --mode {insert|upsert} --param KEY=VALUE
```

### Example: Insert Mode (Initial Setup)
```bash
python run_dynamic_integration.py --integration fyi --mode insert \
  --param EtaniClientID=CLIENT_123 \
  --param EtaniOrganisationID=7035 \
  --param AccessID=your-access-id \
  --param AccessSecret=your-secret
```

### Example: Upsert Mode (Incremental Sync)
```bash
python run_dynamic_integration.py --integration fyi --mode upsert \
  --param EtaniClientID=CLIENT_123 \
  --param EtaniOrganisationID=7035 \
  --param AccessID=your-access-id \
  --param AccessSecret=your-secret
```

### Database-Driven Mode (Lambda-Friendly) 🆕

**Automatic parameter fetching from database** - No need to specify integration name or credentials manually!

#### Prerequisites: Setup Service Table (One-time)

**⚠️ First-time setup required:** Run this SQL script to enable database-driven mode:

```bash
# Execute the service integration mapping setup
mysql -h <host> -u <username> -p vibedb_cms < MYSQL_SP_Revisions/setup_service_integration_mapping.sql
```

**What this does:**
- Adds `integration_name` column to `vibedb_cms.service` table
- Populates 19 service records with integration mappings
- Enables org-id → integration auto-discovery

#### Usage (After Setup)

```bash
# Insert Mode - Auto-detects integration and fetches all parameters
python run_dynamic_integration.py --org-id 7102 --mode insert

# Upsert Mode - Perfect for scheduled Lambda executions
python run_dynamic_integration.py --org-id 7102 --mode upsert
```

**How it works:**
1. **Auto-Discovery**: Queries `vibedb_cms.client_service` table using org-id
2. **Service Mapping**: Automatically maps service_id → integration name (e.g., service 62 → tidywork)
3. **Parameter Extraction**: Fetches API credentials from `Details` JSON column
4. **Zero Configuration**: No manual parameter passing required

**Benefits:**
- **Lambda-Ready**: Perfect for serverless scheduled executions
- **Self-Contained**: All configuration stored in database
- **Maintainable**: Add new org without code changes
- **Secure**: Credentials stored centrally in database

**Example with different org-ids:**
```bash
python run_dynamic_integration.py --org-id 7102 --mode upsert  # TidyWork
python run_dynamic_integration.py --org-id 1234 --mode upsert  # Auto-detects integration
python run_dynamic_integration.py --org-id 5678 --mode insert  # Full setup
```

**Verify setup:**
```bash
# Check if integration_name column exists and is populated
python check_service_table_structure.py
```

---

## 📦 What This System Does

1. **INSERT Mode**: Creates database objects (tables, views, procedures) and loads initial data
2. **UPSERT Mode**: Incrementally syncs new/changed data from APIs to existing database

### Supported Integrations

- **QuickBooks** (qbo)
- **Xero** (payroll_au, payroll_nz, xeroproject)
- **FYI** (fyi)
- **Karbon HQ** (karbon_hq)
- **SimPro** (simpro)
- **MYOB** (myob_detailed, dq_myobar)
- **Shopify** (shopify)
- **Deputy** (deputy)
- **Cin7** (cin7, cin7_dear)
- **Unleashed** (unleashed)
- **WorkflowMax** (wfm)
- **And more...**

---

## 🏗️ System Architecture

```
run_dynamic_integration.py         # ⭐ MAIN ENTRY POINT - Start here!
│
├── dynamic_integrations/          # Core dynamic ETL system
│   ├── IntegrationPackage.py      # Main orchestrator (integration-agnostic)
│   ├── base_integration.py        # Base class for all integrations
│   │
│   ├── generator/                 # Schema → SQL + Python generator
│   │   ├── integration_dynamic.py # Integration code generator
│   │   ├── unified_sql_generator.py # SQL generator
│   │   ├── auth_manager.py        # OAuth/authentication
│   │   └── config/                # Integration configs
│   │
│   ├── etl/                       # ETL engine
│   │   ├── data_extraction.py     # API data extraction
│   │   ├── data_transformation.py # Data transformation
│   │   └── extractors/            # Extraction modules
│   │
│   └── generated_integrations/    # Auto-generated integrations
│       ├── qbo/                   # QuickBooks
│       ├── fyi/                   # FYI
│       ├── karbon_hq/             # Karbon
│       └── ... (20+ integrations)
│
├── sql_helper.py                  # Database abstraction layer
├── config.py                      # Configuration management
└── utils.py                       # Shared utilities
```

---

## 📝 INSERT vs UPSERT

### INSERT Mode
**Purpose**: Initial setup and full data load

**Steps**:
1. Updates configuration with your parameters
2. Executes SQL files to create database objects
3. Runs full data extraction from API

**When to use**: First-time integration setup or complete data refresh

### UPSERT Mode
**Purpose**: Incremental data synchronization

**Steps**:
1. Updates configuration with your parameters
2. Validates existing database objects
3. Extracts only new/changed data based on timestamp

**When to use**: Regular scheduled updates to sync changes

---

## 🔧 Configuration

### Environment Variables

```bash
# Database selection
USE_AWS_DB=True              # Use AWS RDS Aurora (True) or Azure MySQL (False)
DB_Destination=DW            # Target database: DW, EVA, EVADW

# AWS credentials (when USE_AWS_DB=True)
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=ap-northeast-3

# Query monitoring (optional)
QUERY_MONITORING_ENABLED=true
ETL_API_URL=https://apidev.vibecfo.au/api/etl
ETL_API_KEY=your-api-key

# Integration parameters (passed via --param)
EtaniClientID=...            # Required: Client identifier
EtaniOrganisationID=...      # Required: Organization ID
# ... integration-specific parameters
```

---

## 🐳 Docker

### Build Image
```bash
docker build -t etani-etl-dynamic:latest -f Dockerfile_dynamic .
```

### Run Container
```bash
docker run --rm \
  -e USE_AWS_DB=True \
  -e DB_Destination=DW \
  -e EtaniClientID=CLIENT_123 \
  -e EtaniOrganisationID=7035 \
  etani-etl-dynamic:latest \
  python run_dynamic_integration.py --integration fyi --mode upsert \
    --param EtaniClientID=$EtaniClientID \
    --param EtaniOrganisationID=$EtaniOrganisationID
```

---

## 🧪 Testing

```bash
# Run all tests
pytest tests/

# Run specific test
pytest tests/test_consolidated_cms_functionality.py
```

---

## 📚 Documentation

- **[DYNAMIC_INTEGRATIONS_README.md](DYNAMIC_INTEGRATIONS_README.md)** - Complete user guide for dynamic integrations
- **[CLAUDE.md](CLAUDE.md)** - Developer guidance for Claude Code
- **[docs/](docs/)** - Additional guides and documentation

---

## 🆕 Adding New Integrations

The system is **integration-agnostic**. Add new integrations without modifying core code:

1. Create schema JSON: `dynamic_integrations/generator/config/{integration}_schema.json`
2. Generate SQL: `python dynamic_integrations/generator.py schema.json --sql --force`
3. Generate integration: `python dynamic_integrations/generator.py schema.json --dynamic-integration-file --force`
4. Run: `python run_dynamic_integration.py --integration {name} --mode insert`

See `dynamic_integrations/INTEGRATION_AGNOSTIC_GUIDE.md` for details.

---

## 🐛 Troubleshooting

### Connection Issues
- Check `USE_AWS_DB` environment variable
- Verify AWS credentials or Azure connection string
- Ensure security groups allow connections

### Integration Failures
- Check logs: `logs/sql_errors/`
- Verify required parameters via `--param`
- Check organization status in CMS

### Token Issues
- OAuth tokens stored in `token/{ClientID}_{OrgID}.txt`
- Check Azure File Share connectivity
- Remove stale lock files if needed

---

## 👥 Support

- **Issues**: Report in GitHub issues
- **Documentation**: See `docs/` folder
- **Development**: See `CLAUDE.md` for architectural guidance
