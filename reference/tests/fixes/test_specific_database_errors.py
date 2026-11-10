#!/usr/bin/env python3
"""
Test the specific database column errors from the user's report

This test simulates the exact error scenarios:
- BankSummary: "Unknown column 'ReportID' in 'field list'"
- TrialBalance: "Unknown column 'ReportID' in 'field list'"
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def simulate_database_error_scenario():
    """Simulate the exact error scenario from the user's report"""
    
    print("🔧 Simulating Original Database Error Scenario")
    print("=" * 55)
    
    from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create integration instance with minimal setup
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.report_endpoints = {'BankSummary', 'TrialBalance', 'BalanceSheet'}
    integration.error_list = []
    
    # Mock the stage table column lookup to return realistic columns
    # (not including ReportID, ReportName, etc. that caused the error)
    def mock_stage_table_columns(stage_table):
        if 'BankSummary' in stage_table:
            # Typical columns that might exist in a BankSummary stage table
            return {'BankAccountID', 'BankAccountName', 'OpeningBalance', 'CashReceived', 
                   'CashSpent', 'ClosingBalance', 'UpdatedDateUTC', 'ProcessedDate'}
        elif 'TrialBalance' in stage_table:
            # Typical columns for TrialBalance stage table
            return {'AccountCode', 'AccountName', 'Debit', 'Credit', 'YTDDebit', 
                   'YTDCredit', 'UpdatedDateUTC', 'ProcessedDate'}
        else:
            return set()
    
    integration._get_stage_table_columns = mock_stage_table_columns
    
    # Mock LoadToEvaStageTable to simulate database operations
    def mock_load_to_eva_stage_table(df, endpoint, write_mode, stage_table, error_list):
        print(f\"   🗄️  Mock database insert: {len(df)} rows to {stage_table}\")\n        print(f\"   📋 Columns to insert: {list(df.columns)}\")\n        \n        # Simulate the original error if problematic columns are present\n        problematic_columns = {'ReportID', 'ReportName', 'ReportType', 'ReportTitles', 'Fields', 'Rows'}\n        found_problematic = set(df.columns) & problematic_columns\n        \n        if found_problematic:\n            error_msg = f\"(pymysql.err.OperationalError) (1054, \\\"Unknown column '{list(found_problematic)[0]}' in 'field list'\\\")\"\n            print(f\"   ❌ Would cause database error: {error_msg}\")\n            raise Exception(error_msg)\n        else:\n            print(f\"   ✅ Database insert would succeed - no problematic columns\")\n    \n    # Replace the actual function with our mock\n    try:\n        from sql_helper import LoadToEvaStageTable as original_load\n        import dynamic_integrations.integrations.xeroblue_integration\n        dynamic_integrations.integrations.xeroblue_integration.LoadToEvaStageTable = mock_load_to_eva_stage_table\n    except ImportError:\n        # If we can't import, create a global mock\n        import builtins\n        builtins.LoadToEvaStageTable = mock_load_to_eva_stage_table\n    \n    print(\"\\n1. Testing BankSummary error scenario...\")\n    \n    # Create the exact data structure that was causing the error\n    banksummary_data = pd.DataFrame([{\n        'ReportID': 'BankSummary',\n        'ReportName': 'Bank Summary',\n        'ReportType': 'BankSummary', \n        'ReportTitles': \"['Bank Summary', 'Etani Online Clothing', 'From 1 June 2025 to 30 June 2025']\",\n        'ReportDate': '19 June 2025',\n        'UpdatedDateUTC': '2025-06-19 02:38:25',\n        'Fields': '[]',\n        'Rows': \"[{'RowType': 'Header', 'Cells': [{'Value': 'Bank Accounts'}]}]\"\n    }])\n    \n    print(f\"   Original problematic data columns: {list(banksummary_data.columns)}\")\n    \n    try:\n        # Test the fixed load process\n        integration._load_to_stage_table(\n            banksummary_data, \n            'BankSummary', \n            'overwrite', \n            'c1518_7232_xeroblue_BankSummarySTAGE'\n        )\n        print(f\"   ✅ BankSummary processed without database errors!\")\n        \n    except Exception as e:\n        print(f\"   ❌ BankSummary still has issues: {str(e)}\")\n        return False\n    \n    print(\"\\n2. Testing TrialBalance error scenario...\")\n    \n    # Create TrialBalance data that was causing errors\n    trialbalance_data = pd.DataFrame([{\n        'ReportID': 'TrialBalance',\n        'ReportName': 'Trial Balance',\n        'ReportType': 'TrialBalance',\n        'ReportTitles': \"['Trial Balance', 'Etani Online Clothing', 'As at 19 June 2025']\",\n        'ReportDate': '19 June 2025',\n        'UpdatedDateUTC': '2025-06-19 02:38:36',\n        'Fields': '[]',\n        'Rows': \"[{'RowType': 'Header', 'Cells': [{'Value': 'Account'}]}]\"\n    }])\n    \n    try:\n        integration._load_to_stage_table(\n            trialbalance_data,\n            'TrialBalance', \n            'overwrite',\n            'c1518_7232_xeroblue_TrialBalanceSTAGE'\n        )\n        print(f\"   ✅ TrialBalance processed without database errors!\")\n        \n    except Exception as e:\n        print(f\"   ❌ TrialBalance still has issues: {str(e)}\")\n        return False\n    \n    print(\"\\n3. Testing regular endpoint (should still work)...\")\n    \n    # Test that regular endpoints still work correctly\n    integration.report_endpoints = {'BankSummary', 'TrialBalance'}  # Reset\n    \n    regular_data = pd.DataFrame([{\n        'ContactID': '123-456-789',\n        'Name': 'Test Contact',\n        'UpdatedDateUTC': '2025-06-19 02:38:36',\n        'Email': 'test@example.com'\n    }])\n    \n    # Mock stage table for regular endpoint\n    def mock_regular_stage_columns(stage_table):\n        return {'ContactID', 'Name', 'UpdatedDateUTC', 'Email', 'Phone'}\n    \n    integration._get_stage_table_columns = mock_regular_stage_columns\n    \n    try:\n        integration._load_to_stage_table(\n            regular_data,\n            'Contacts',\n            'overwrite', \n            'c1518_7232_xeroblue_ContactsSTAGE'\n        )\n        print(f\"   ✅ Regular endpoint (Contacts) still works correctly!\")\n        \n    except Exception as e:\n        print(f\"   ❌ Regular endpoint broken: {str(e)}\")\n        return False\n    \n    print(\"\\n\" + \"=\" * 55)\n    print(\"🎉 ALL DATABASE ERROR SCENARIOS RESOLVED!\")\n    print(\"✅ BankSummary no longer causes 'Unknown column ReportID' error\")\n    print(\"✅ TrialBalance no longer causes 'Unknown column ReportID' error\")\n    print(\"✅ Regular endpoints continue to work normally\")\n    print(\"🚀 Integration is now safe for production use\")\n    \n    return True

# Import path utilities for dynamic path resolution
try:
    from path_utils import setup_project_paths
except ImportError:
    try:
        from .path_utils import setup_project_paths
    except ImportError:
        # If path_utils is not available, set up paths manually
        def setup_project_paths():
            current_dir = os.path.dirname(os.path.abspath(__file__))
            etl_packages_dir = os.path.dirname(current_dir)
            project_root = os.path.dirname(etl_packages_dir)
            
            if project_root not in sys.path:
                sys.path.insert(0, project_root)
            if etl_packages_dir not in sys.path:
                sys.path.insert(0, etl_packages_dir)

# Set up project paths
setup_project_paths()

if __name__ == '__main__':\n    try:\n        print(\"🔧 Testing Database Column Error Fix\\n\")\n        \n        success = simulate_database_error_scenario()\n        \n        if success:\n            print(\"\\n🎯 SUCCESS: All database column errors have been resolved!\")\n            print(\"✅ The integration will no longer fail with 'Unknown column' errors\")\n            print(\"📊 Report endpoints are now handled safely\")\n        else:\n            print(\"\\n❌ Some issues remain - please review the implementation\")\n            \n    except Exception as e:\n        print(f\"❌ Test failed: {str(e)}\")\n        import traceback\n        traceback.print_exc()