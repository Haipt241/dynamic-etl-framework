# Repository Cleanup Plan

## Executive Summary

**Problem**: Repository has 106 Python files in root, 27 markdown files, and countless one-off scripts making it impossible to identify the actual dynamic ETL system.

**Solution**: Archive obsolete files, clearly identify core system, create simple entry point documentation.

---

## Core Dynamic ETL System (KEEP)

### Main Entry Point
- **`run_dynamic_integration.py`** - Universal CLI for running ANY integration (INSERT or UPSERT mode)

### Core System
```
dynamic_integrations/
├── IntegrationPackage.py          # Main orchestrator (integration-agnostic)
├── base_integration.py            # Abstract base class all integrations inherit from
├── cms_manager.py                 # CMS API client
├── sql_executor.py                # Executes generated SQL files
├── generator/                     # Schema → SQL + Python generator
│   ├── integration_dynamic.py     # Dynamic integration generator
│   ├── unified_sql_generator.py   # SQL generation engine
│   ├── auth_manager.py            # OAuth/auth handling
│   └── config/                    # Integration config files
├── etl/                           # Core ETL engine
│   ├── data_extraction.py         # API data extraction
│   ├── data_transformation.py     # Data transformation
│   └── extractors/                # Extraction modules
└── generated_integrations/        # Auto-generated integrations
    ├── qbo/                       # QuickBooks
    ├── fyi/                       # FYI
    ├── karbon_hq/                 # Karbon
    ├── simpro/                    # SimPro
    └── ... (20+ integrations)
```

### Infrastructure
- `sql_helper.py` - Database abstraction with AWS/Azure connection pooling
- `config.py` - Configuration management
- `utils.py` - Shared utilities
- `query_monitoring_client.py` - Query performance tracking
- `container_monitoring_client.py` - Container monitoring
- `common_token_manager.py` - OAuth token management

### Legacy (Still Active)
- `XEROBLUE - INSERT.py` - Legacy Xero initial load (still modified recently)
- `XEROBLUE - UPSERT.py` - Legacy Xero sync (still modified recently)
- `IntegrationPackageUpsert.py` - Old orchestrator (may be imported by legacy scripts)

### Configuration
- `requirements.txt`
- `docker-compose.yml`
- `Dockerfile_api`
- `Dockerfile_dynamic`
- `.env` (local only)
- `.vscode/launch.json`

### Documentation (Keep in Root)
- `README.md` - Main repository readme
- `CLAUDE.md` - Claude Code guidance
- `DYNAMIC_INTEGRATIONS_README.md` - Dynamic system user guide

---

## Files to Archive (MOVE)

### Category 1: One-Off Maintenance Scripts (50+ files)
**Archive to: `archives/maintenance_scripts/`**

```
analyze_error_patterns.py
bulk_update_views_batch.py
check_and_grant_kill_permissions.py
check_and_kill_view_processes.py
check_and_run_etl.py
check_aws_stored_procs.py
check_azure_views*.py (3 files)
check_databases.py
check_foreignexchange_table.py
check_mysql_version.py
diagnose_stage_table_issue.py
find_all_rownumber_views.py
find_evadb_locations.py
find_nested_delimiter_issues.py
find_sourceid_case_issues.py
fix_all_remaining_case_issues.py
fix_audit_table_references.py
fix_definer_and_delimiters.py
fix_delimiters.py
fix_foreignexchange_references.py
fix_journalscash_aliases.py
fix_remaining_alias_cases.py
fix_remaining_journals_issues.py
fix_sourceid_case.py
fix_sourceid_in_table_defs.py
fix_table_alias_case.py
fix_view_table_references.py
grant_self_connection_admin.py
recreate_views.py
remove_all_evadb_references.py
remove_evadb_prefixes.py
restore_evadb_for_azure.py
restore_evadb_prefixes.py
revert_delimiters.py
revert_sourceid_to_mixedcase.py
update_swau_transactionsblend_views.py
update_unused_view.py
update_unused_view_fast.py
validate_*.py (10+ files)
verify_specific_view.py
```

### Category 2: Test/Debug Scripts
**Archive to: `archives/test_scripts/`**

```
test_aws_connection.py
test_aws_sql_helper.py
test_aws_sql_helper_quick.py
test_conditional_behavior.py
test_delimiter_issue.py
test_execute_multiple_sqlscripts.py
test_fxviews_conditional.py
test_secret_retrieval.py
test_sql_error_logging.py
test_sql_syntax.py
test_stored_proc_execution.py
test_update_single_view.py
```

### Category 3: Legacy SQL Object Creators
**Archive to: `archives/legacy_sql/`**

```
create_dynamic_sqlobjects.py
create_dynamic_sqlobjects_for_client.py
create_dynamic_sqlobjects_for_missing_obj.py
sql_object_scripts.py
```

### Category 4: Legacy ETL Scripts (Not Recently Modified)
**Archive to: `archives/legacy_etl/`**

```
QBO - UPSERT.py                    # Old QuickBooks (replaced by dynamic)
MYOB - UPSERT.py                   # Old MYOB
XPM - UPSERT.py                    # Old XPM
main.py                            # Old MYOB AccountRight
XEROBLUE - RECONCILIATION.py       # Reconciliation module (check if still used)
```

### Category 5: AWS/Azure Migration Documentation
**Archive to: `archives/migration_docs/`**

```
AWS_CONNECTION_POOLING_README.md
AWS_CREDENTIALS_OPTIONS.md
AWS_MIGRATION_COMPLETE.md
AWS_MIGRATION_DOCS.zip
AWS_QUICK_REFERENCE.md
AWS_SQL_HELPER_GUIDE.md
AZURE_GRANT_INSTRUCTIONS.md
BOTH_JOURNAL_PROCEDURES_FIX_SUMMARY.md
CASE_SENSITIVITY_FIXES.md
CONDITIONAL_EVADB_SOLUTION.md
DEFINER_FIX_SUMMARY.md
ERROR_FIXES_SUMMARY.md
FINAL_CASE_FIX_SUMMARY.md
LATEST_ERROR_ANALYSIS.md
SOURCEID_ALIAS_FIX_SUMMARY.md
SUMMARY_OF_CHANGES.md
```

### Category 6: Integration-Specific Docs
**Move to: `docs/`**

```
DEPLOYMENT_CHECKLIST.md
DYNAMIC_INTEGRATION_SETUP_GUIDE.md
ETL_PROJECT_IMPLEMENTATION_GUIDE.md
How-To-Use-IntegrationPackageUpsert.md
QBO_ENDPOINT_REVIEW.md
RUN_DYNAMIC_INTEGRATION_GUIDE.md
S3_UPLOAD_TOOL_README.md
SQL_ERROR_LOGGING_README.md
SQL_VIEWS_OPTIMIZER_README.md
```

### Category 7: Token Files & Locks
**Archive to: `archives/old_tokens/`**

```
token/*.txt (all old token files)
*.txt.lock (all lock files in root)
```

### Category 8: Example/Demo Files
**Keep in: `dynamic_integrations/examples/`** (already there)

```
example_*.py files in root → Move to dynamic_integrations/examples/
```

### Category 9: Utility Scripts to Keep (Move to utils/)
**Create `utils/` folder for:**

```
get_aws_password.py
get_aws_secret.py
upload_token_to_s3.py
s3_upload_tool.py
setup_aws_sp_container_logs.py
rename_token_file.py
```

### Category 10: SQL Scripts
**Move to: `sql_scripts/`**

```
apply_qbo_schema_updates.sql
execute_qbo_schema_updates.py
grant_kill_permissions.sql
kill_commands.sql
sp_dynamic_xeroblue_invoices.sql
```

### Category 11: Miscellaneous
**Archive to: `archives/misc/`**

```
*.pem files (SSL certificates - should be in config)
*.crt files
*.zip files
*.txt files (bulk results, processes to kill, etc.)
*.csv files
manifest.mf
readme.txt
path_utils.py (check if used)
```

---

## Cleanup Actions

### Step 1: Create Archive Structure
```bash
mkdir -p archives/maintenance_scripts
mkdir -p archives/test_scripts
mkdir -p archives/legacy_sql
mkdir -p archives/legacy_etl
mkdir -p archives/migration_docs
mkdir -p archives/old_tokens
mkdir -p archives/misc
mkdir -p docs
mkdir -p utils
mkdir -p sql_scripts
```

### Step 2: Move Files (Preserve Git History)
```bash
git mv [files] archives/[category]/
```

### Step 3: Create Clear Entry Point Documentation
- Update README.md with clear "Getting Started"
- Show how to run INSERT vs UPSERT
- Show how to add new integrations

### Step 4: Test
- Run existing integrations to ensure nothing breaks
- Verify imports still work
- Check Docker builds

---

## After Cleanup: Clean Repository Structure

```
etl-packages/
├── run_dynamic_integration.py          # ⭐ MAIN ENTRY POINT
├── sql_helper.py                       # Database abstraction
├── config.py                           # Configuration
├── utils.py                            # Shared utilities
├── requirements.txt                    # Dependencies
├── docker-compose.yml                  # Docker setup
├── Dockerfile_dynamic                  # Dynamic integration image
├── Dockerfile_api                      # API image
│
├── README.md                           # ⭐ START HERE
├── CLAUDE.md                           # Claude Code guidance
├── DYNAMIC_INTEGRATIONS_README.md      # User guide
│
├── XEROBLUE - INSERT.py                # Legacy Xero (still used)
├── XEROBLUE - UPSERT.py                # Legacy Xero (still used)
├── IntegrationPackageUpsert.py         # Legacy orchestrator
│
├── dynamic_integrations/               # ⭐ CORE SYSTEM
│   ├── IntegrationPackage.py           # Main orchestrator
│   ├── base_integration.py             # Base class
│   ├── generator/                      # Schema → Code generator
│   ├── etl/                            # ETL engine
│   └── generated_integrations/         # Auto-generated integrations
│
├── integrations/                       # Legacy integration implementations
├── implementations/                    # Implementation-specific code
├── interfaces/                         # Interface definitions
│
├── tests/                              # Test suite
├── docs/                               # Documentation
├── utils/                              # Utility scripts
├── sql_scripts/                        # SQL scripts
├── archives/                           # Archived files
│   ├── maintenance_scripts/
│   ├── test_scripts/
│   ├── legacy_sql/
│   ├── legacy_etl/
│   ├── migration_docs/
│   └── misc/
│
├── token/                              # OAuth tokens (runtime)
├── logs/                               # Log files (runtime)
└── .vscode/                            # VS Code config
```

---

## Success Criteria

✅ Root directory has <20 Python files
✅ Can immediately identify main entry point
✅ Clear separation: core system, legacy, archives
✅ All tests still pass
✅ Docker builds still work
✅ Documentation clearly explains INSERT vs UPSERT
✅ Easy to onboard new developers
