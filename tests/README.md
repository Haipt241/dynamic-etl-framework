# Tests Directory

This directory contains all test files for the ETL project, organized by category for better maintainability.

## Directory Structure

### 📋 `/integration/`
Tests that verify the complete integration functionality across multiple components:
- `test_comprehensive_integration.py` - Comprehensive integration testing
- `test_full_integration_functionality.py` - Full system functionality tests
- `test_integration_agnostic_architecture.py` - Architecture integration tests
- `test_qbo_integration.py` - QuickBooks Online integration tests
- `test_real_endpoint_execution.py` - Real API endpoint execution tests
- `test_xeroblue_integration.py` - XeroBlue integration tests
- `test_unified_orchestrator.py` - Unified system orchestrator tests
- `test_unified_system_comprehensive.py` - Comprehensive system tests
- `test_cms_integration_agnostic.py` - CMS integration agnostic tests
- `test_insert_integration.py` - INSERT operation integration tests
- `test_integration_insert_agnostic.py` - Integration-agnostic INSERT tests

### 🔧 `/fixes/`
Tests that verify specific bug fixes and improvements:
- `test_textclause_and_creditnotes_fixes.py` - **CRITICAL** TextClause and CreditNotes column fixes
- `test_all_endpoint_id_columns.py` - **CRITICAL** Endpoint ID column mapping verification
- `test_fixed_transformation.py` - Data transformation fixes
- `test_complete_integrityerror_fix.py` - IntegrityError resolution tests
- `test_data_flattening_verification.py` - JSON flattening verification
- `test_database_fix_simple.py` - Database connectivity fixes
- `test_date_comparison_fix.py` - Date comparison logic fixes
- `test_default_values_fix.py` - Default value handling fixes
- `test_final_integrityerror_verification.py` - Final IntegrityError verification
- `test_invoices_schema_fix.py` - Invoice schema alignment fixes
- `test_nested_data_fix.py` - Nested data structure fixes
- `test_null_row_filtering_fix.py` - NULL value filtering fixes
- `test_organisationid_fix.py` - Organisation ID handling fixes
- `test_report_column_fix.py` - Report endpoint column fixes
- `test_simple_null_filtering.py` - Simple NULL filtering tests
- `test_sp_execution_protection.py` - Stored procedure execution protection
- `test_specific_database_errors.py` - Specific database error handling
- `test_stage_table_name_fix.py` - Stage table naming fixes

### 🔍 `/debug/`
Development and debugging tests:
- `test_accounts_endpoint_debug.py` - Accounts endpoint debugging
- `test_api_params_only.py` - API parameter testing
- `test_minimal.py` - Minimal test cases
- `test_orchestrator_simple.py` - Simple orchestrator tests
- `test_table_name_construction.py` - Table name construction tests
- `test_xeroblue_api_patterns.py` - XeroBlue API pattern tests
- `test_xeroblue_simple.py` - Simple XeroBlue tests
- `debug_invoice_transformation.py` - Invoice transformation debugging
- `fix_invoice_transformation.py` - Invoice transformation fixes
- `quick_test.py` - Quick development tests
- `simple_table_name_test.py` - Simple table name tests

### 🧪 `/unit/`
Unit tests for individual components:
- `test_convert_data_types.py` - Data type conversion tests

## Running Tests

### Run All Tests
```bash
cd "/home/jepilor/etl 1.0/etl_packages"
python -m pytest tests/ -v
```

### Run Specific Categories
```bash
# Integration tests
python -m pytest tests/integration/ -v

# Fix verification tests
python -m pytest tests/fixes/ -v

# Debug tests
python -m pytest tests/debug/ -v

# Unit tests
python -m pytest tests/unit/ -v
```

### Run Individual Tests
```bash
# Critical fixes
python tests/fixes/test_textclause_and_creditnotes_fixes.py
python tests/fixes/test_all_endpoint_id_columns.py

# Integration tests
python tests/integration/test_xeroblue_integration.py
```

## Critical Tests

The following tests verify the most recent critical fixes:

1. **`tests/fixes/test_textclause_and_creditnotes_fixes.py`**
   - Verifies TextClause SQL error fix
   - Verifies CreditNotes use CreditNoteId instead of InvoiceId
   - Verifies Invoices still work correctly

2. **`tests/fixes/test_all_endpoint_id_columns.py`**
   - Verifies all endpoints use correct ID column mappings
   - Tests: invoices, creditnotes, overpayments, prepayments, banktransactions, purchaseorders, receipts, quotes

## Test Dependencies

Tests require the following environment setup:
```bash
export EtaniClientID='c1518'
export EtaniOrganisationID='7232'
```

## Notes

- Tests use data from `/json/` directory for realistic scenarios
- Integration tests may require database connectivity
- Debug tests are for development purposes and may have relaxed assertions
- Fix tests should ALWAYS pass in production

## Recent Fixes Verified

✅ **TextClause Error Fixed**: `_get_stage_table_columns` method no longer double-calls `text()`
✅ **CreditNotes Column Fixed**: Uses `CreditNoteId` instead of `InvoiceId` 
✅ **All Endpoint ID Mappings**: Correct source field → target column mappings for all endpoints
✅ **Stage Table Schema Alignment**: Proper column filtering and validation