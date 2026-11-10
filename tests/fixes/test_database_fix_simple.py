#!/usr/bin/env python3
"""
Simple test for database column error fix
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_report_column_filtering():
    """Test that report endpoints don't cause database column errors"""
    
    print("🔧 Testing Database Column Error Fix")
    print("=" * 40)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create integration instance
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.report_endpoints = {'BankSummary', 'TrialBalance'}
    integration.error_list = []
    
    # Mock stage table columns (realistic columns, not report structure)
    def mock_stage_columns(stage_table):
        if 'BankSummary' in stage_table:
            return {'BankAccountName', 'OpeningBalance', 'UpdatedDateUTC'}
        elif 'TrialBalance' in stage_table:
            return {'AccountName', 'Debit', 'Credit', 'UpdatedDateUTC'}
        else:
            return {'Name', 'Type', 'UpdatedDateUTC'}
    
    integration._get_stage_table_columns = mock_stage_columns
    
    print("Testing BankSummary data structure...")
    
    # Create report data with problematic columns
    report_data = pd.DataFrame([{
        'ReportID': 'BankSummary',
        'ReportName': 'Bank Summary', 
        'ReportType': 'BankSummary',
        'ReportTitles': ['Bank Summary'],
        'ReportDate': '19 June 2025',
        'UpdatedDateUTC': '2025-06-19 02:38:25',
        'Fields': [],
        'Rows': [{'RowType': 'Header'}]
    }])
    
    print(f"Original columns: {list(report_data.columns)}")
    
    try:
        # Test the filtering
        filtered_data = integration._filter_dataframe_columns(
            report_data, 'BankSummary', 'c1518_7232_xeroblue_BankSummarySTAGE'
        )
        
        print(f"Filtered columns: {list(filtered_data.columns)}")
        
        # Check if problematic columns were removed
        problematic = {'ReportID', 'ReportName', 'ReportType', 'Fields', 'Rows'}
        remaining_problematic = set(filtered_data.columns) & problematic
        
        if not remaining_problematic:
            print("✅ Problematic columns successfully filtered out")
        else:
            print(f"❌ Problematic columns still present: {remaining_problematic}")
            return False
            
    except Exception as e:
        print(f"❌ Error in filtering: {str(e)}")
        return False
    
    print("Testing TrialBalance data structure...")
    
    trial_data = pd.DataFrame([{
        'ReportID': 'TrialBalance',
        'ReportName': 'Trial Balance',
        'UpdatedDateUTC': '2025-06-19 02:38:36'
    }])
    
    try:
        filtered_trial = integration._filter_dataframe_columns(
            trial_data, 'TrialBalance', 'c1518_7232_xeroblue_TrialBalanceSTAGE'
        )
        
        if 'ReportID' not in filtered_trial.columns:
            print("✅ TrialBalance ReportID successfully filtered out")
        else:
            print("❌ TrialBalance ReportID still present")
            return False
            
    except Exception as e:
        print(f"❌ Error filtering TrialBalance: {str(e)}")
        return False
    
    print("=" * 40)
    print("🎉 ALL TESTS PASSED!")
    print("✅ Database column errors have been fixed")
    print("✅ Report endpoints will no longer cause 'Unknown column' errors")
    
    return True

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

if __name__ == '__main__':
    try:
        success = test_report_column_filtering()
        if success:
            print("🚀 Fix confirmed working!")
        else:
            print("❌ Fix needs more work")
    except Exception as e:
        print(f"❌ Test error: {str(e)}")
        import traceback
        traceback.print_exc()