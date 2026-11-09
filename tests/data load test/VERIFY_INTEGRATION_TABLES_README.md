# Integration Tables Verification Script

## Overview

`verify_integration_tables.py` is a dynamic verification script that validates production table data for **any** dynamic integration by comparing expected counts from the `lastrefreshdate` table against actual production table counts.

## Purpose

After running an integration in UPSERT or INSERT mode, use this script to:
- ✅ Verify all tables have expected data
- ✅ Identify missing tables
- ✅ Detect data mismatches (API vs Database)
- ✅ Generate detailed verification reports (JSON + console)

---

## 🤖 Claude AI Prompt Template

Use this prompt with Claude Code to run verification and get summary details:

### Basic Prompt

```
I need to verify the data load for [INTEGRATION_NAME] integration.

Please run the verification script located at:
tests/data load test/verify_integration_tables.py

Parameters:
- Integration: [INTEGRATION_NAME]
- Client ID: [CLIENT_ID]
- Organization ID: [ORG_ID]

After running, please provide:
1. Summary statistics (matching/mismatched/missing tables)
2. List of any issues found with details
3. Top 5 tables by row count
4. Overall assessment of data load success
```

### Example Usage

```
I need to verify the data load for dq_myobar integration.

Please run the verification script located at:
tests/data load test/verify_integration_tables.py

Parameters:
- Integration: dq_myobar
- Client ID: BIGOLESHOECOMPANY_CLIENT1906
- Organization ID: 1755241680

After running, please provide:
1. Summary statistics (matching/mismatched/missing tables)
2. List of any issues found with details
3. Top 5 tables by row count
4. Overall assessment of data load success
```

### Advanced Prompt (with JSON analysis)

```
I need a comprehensive verification report for [INTEGRATION_NAME] integration.

Step 1: Run verification script
- Script: tests/data load test/verify_integration_tables.py
- Integration: [INTEGRATION_NAME]
- Client ID: [CLIENT_ID]
- Organization ID: [ORG_ID]

Step 2: Analyze the generated JSON report and provide:
1. Summary statistics with percentages
2. Complete list of mismatched or missing tables
3. Top 10 tables by row count with match percentages
4. Data quality assessment (excellent/good/needs attention/critical)
5. Recommended actions if any issues found

Step 3: If there are mismatches:
- Identify which tables have data loss vs data gain
- Calculate total records affected
- Suggest next steps for investigation
```

---

## Usage

### Basic Syntax

```bash
# From project root
python "tests/data load test/verify_integration_tables.py" \
  --integration <integration_name> \
  --client-id <full_client_id> \
  --org-id <organization_id>

# From tests/data load test/ directory
python verify_integration_tables.py \
  --integration <integration_name> \
  --client-id <full_client_id> \
  --org-id <organization_id>
```

### Examples

**Verify DQ_MYOBAR:**
```bash
python "tests/data load test/verify_integration_tables.py" \
  --integration dq_myobar \
  --client-id BIGOLESHOECOMPANY_CLIENT1906 \
  --org-id 1755241680
```

**Verify QuickBooks (QBO):**
```bash
python "tests/data load test/verify_integration_tables.py" \
  --integration qbo \
  --client-id BIGOLESHOECOMPANY_CLIENT2013 \
  --org-id 7035
```

**Verify FYI:**
```bash
python "tests/data load test/verify_integration_tables.py" \
  --integration fyi \
  --client-id SOMECOMPANY_CLIENT1234 \
  --org-id 5678
```

**Verify Karbon HQ:**
```bash
python "tests/data load test/verify_integration_tables.py" \
  --integration karbon_hq \
  --client-id TESTCOMPANY_CLIENT9999 \
  --org-id 8888
```

## Parameters

| Parameter | Required | Description | Example |
|-----------|----------|-------------|---------|
| `--integration` | Yes | Integration name (lowercase) | `dq_myobar`, `qbo`, `fyi`, `karbon_hq` |
| `--client-id` | Yes | Full EtaniClientID | `BIGOLESHOECOMPANY_CLIENT1906` |
| `--org-id` | Yes | EtaniOrganisationID | `1755241680` |

## How It Works

1. **Queries LastRefreshDate Table**
   - Reads `c{clientNumber}_{integration}_lastrefreshdate` table
   - Extracts expected `TotalRowCount` for each endpoint

2. **Queries Production Tables**
   - Constructs production table names: `{firmcode}_client{number}_{integration}_{endpoint}`
   - Queries actual row count filtered by `OrganisationID`

3. **Compares & Reports**
   - Compares expected vs actual counts
   - Categorizes results: OK, MISMATCH, EMPTY, MISSING, ERROR
   - Generates console report + JSON file

## Output

### Console Report

```
======================================================================
        DQ_MYOBAR Production Tables Verification
======================================================================

Client: BIGOLESHOECOMPANY_CLIENT1906
Org ID: 1755241680
Integration: DQ_MYOBAR
Refresh Date Table: c1906_dq_myobar_lastrefreshdate

----------------------------------------------------------------------
SUMMARY:
  [OK] Matching Tables: 46/47 (97.9%)
  [ERROR] Missing Tables: 1

----------------------------------------------------------------------
ISSUES DETECTED:

[ERROR] c1906_dq_myobar_etl_overall
    Status: Table does not exist in database
    Expected table: bigoleshoecompany_client1906_dq_myobar_etl_overall

----------------------------------------------------------------------
SUCCESSFUL ENDPOINTS (Top 10 by row count):

 1. [OK] c1906_dq_myobar_journaltransaction: 27767 / 27767 rows (100.0%)
 2. [OK] c1906_dq_myobar_jobregister   :  8936 /  8936 rows (100.0%)
 3. [OK] c1906_dq_myobar_accountregister:  8920 /  8920 rows (100.0%)
...
```

### JSON Report

File: `verification_report_{INTEGRATION}_{timestamp}.json`

```json
{
  "timestamp": "2026-01-12T14:27:01.123456",
  "client_id": "BIGOLESHOECOMPANY_CLIENT1906",
  "org_id": "1755241680",
  "integration": "dq_myobar",
  "summary": {
    "total_endpoints": 47,
    "matching_tables": 46,
    "mismatched_tables": 0,
    "missing_tables": 1,
    "empty_tables": 0,
    "error_count": 0
  },
  "details": [
    {
      "endpoint": "c1906_dq_myobar_account",
      "table_name": "bigoleshoecompany_client1906_dq_myobar_account",
      "expected_count": 274,
      "actual_count": 274,
      "difference": 0,
      "status": "OK",
      "match_percentage": 100.0,
      "last_refresh": "2026-01-12 11:47:16",
      "error_message": null
    }
  ]
}
```

## Status Codes

| Status | Description |
|--------|-------------|
| `OK` | Expected count matches actual count (100% match) |
| `MISMATCH` | Actual count ≠ expected count (data loss or gain) |
| `EMPTY` | Table exists but has 0 rows |
| `MISSING` | Production table doesn't exist in database |
| `ERROR` | Query failed or database error |

## Requirements

- AWS RDS Aurora connection (`USE_AWS_DB=True`)
- `sql_helper.py` with `eva_main_engine` initialized
- LastRefreshDate table must exist: `c{clientNumber}_{integration}_lastrefreshdate`
- Production tables must follow naming convention: `{firmcode}_client{number}_{integration}_{endpoint}`

## Supported Integrations

Works with **all** dynamic integrations that have a `lastrefreshdate` table:
- dq_myobar (MYOB Business)
- qbo (QuickBooks Online)
- fyi (FYI)
- karbon_hq (Karbon HQ)
- simpro (SimPro)
- shopify (Shopify)
- deputy (Deputy)
- cin7 (Cin7)
- cin7_dear (Dear Inventory)
- unleashed (Unleashed)
- wfm (WorkflowMax)
- myob_detailed (MYOB Detailed)
- keypay (KeyPay)
- tidywork (TidyWork)
- vinsight (Vinsight)
- payroll_au (Xero Payroll AU)
- payroll_nz (Xero Payroll NZ)
- xeroproject (Xero Projects)
- hubspot (HubSpot)
- jobman (JobMan)

## Troubleshooting

**Error: "Could not extract client number"**
- Ensure `--client-id` follows format: `FIRMCODE_CLIENT{number}`
- Example: `BIGOLESHOECOMPANY_CLIENT1906` ✅
- Example: `CLIENT1906` ❌

**Error: "Error querying lastrefreshdate table"**
- Verify table exists: `c{clientNumber}_{integration}_lastrefreshdate`
- Check database connection (AWS RDS Aurora)
- Ensure integration has been run at least once (creates lastrefreshdate table)

**All tables show MISSING:**
- Check table naming convention
- Verify production tables exist in database
- Ensure `--integration` name matches actual integration name (lowercase)

## Exit Codes

- `0` - Verification completed successfully
- `1` - Error during execution (invalid parameters, database connection failure)

## Examples with Results

### All Tables OK (100% Success)

```bash
$ python "tests/data load test/verify_integration_tables.py" \
    --integration qbo \
    --client-id ACME_CLIENT2013 \
    --org-id 7035

SUMMARY:
  [OK] Matching Tables: 25/25 (100.0%)
```

### With Data Mismatch

```bash
$ python "tests/data load test/verify_integration_tables.py" \
    --integration dq_myobar \
    --client-id BIGOLESHOECOMPANY_CLIENT1906 \
    --org-id 1755241680

SUMMARY:
  [OK] Matching Tables: 46/47 (97.9%)
  [WARNING] Mismatched Tables: 1

ISSUES DETECTED:

[WARNING] c1906_dq_myobar_payrollcategory
    Expected (API): 68 rows
    Actual (DB):    1 row
    Difference:     -67 rows (98.5% loss)
    Match %:        1.5%
    Last Sync:      2026-01-12 11:47:16
```

## Notes

- Script automatically handles table name mapping between lastrefreshdate format and production format
- Queries are filtered by `OrganisationID` to isolate client data
- Safe to run multiple times (read-only operations)
- Supports large datasets (tested with 27,000+ rows)

## Related Scripts

- `run_dynamic_integration.py` - Run integrations (INSERT/UPSERT)
- `dynamic_integrations/sql_executor.py` - Execute SQL object creation
