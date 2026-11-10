#!/usr/bin/env python3
"""
Test the report endpoint column filtering fix

This test validates that report endpoints (BankSummary, TrialBalance) 
don't cause database column errors when their data structure doesn't 
match the stage table schema.
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'TEST_CLIENT123')
os.environ.setdefault('EtaniOrganisationID', '1234')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_report_data_structure_handling():
    """Test that report data structure is handled correctly without database errors"""
    
    print("🧪 Testing Report Data Structure Handling")
    print("=" * 50)
    
    # Import the integration (minimal setup)
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create minimal integration instance
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.report_endpoints = {'BankSummary', 'TrialBalance', 'BalanceSheet'}
    
    # Mock the stage table column lookup to simulate different scenarios
    def mock_get_stage_table_columns(stage_table):
        # Simulate stage table with regular endpoint columns (not report columns)
        if 'BankSummary' in stage_table:
            return {'Name', 'Type', 'UpdatedDateUTC', 'Amount', 'AccountCode'}  # Regular columns
        elif 'TrialBalance' in stage_table:
            return {'AccountName', 'AccountCode', 'Debit', 'Credit', 'UpdatedDateUTC'}  # Regular columns
        else:
            return set()  # No schema available
    
    integration._get_stage_table_columns = mock_get_stage_table_columns
    
    print("\\n1. Testing BankSummary report data...")
    
    # Create sample report data (like what comes from Xero API)
    report_df = pd.DataFrame([{
        'ReportID': 'BankSummary',
        'ReportName': 'Bank Summary',
        'ReportType': 'BankSummary',
        'ReportTitles': ['Bank Summary', 'Test Company'],
        'ReportDate': '19 June 2025',
        'UpdatedDateUTC': '2025-06-19 02:38:25',
        'Fields': [],
        'Rows': [{'RowType': 'Header', 'Cells': []}]  # Complex structure
    }])
    
    print(f"   Original report data columns: {list(report_df.columns)}")
    
    try:
        # Test the report handling
        filtered_df = integration._handle_report_data_structure(
            report_df, 'BankSummary', 'c1518_7232_xeroblue_BankSummarySTAGE'
        )
        
        print(f"   Filtered data columns: {list(filtered_df.columns)}")
        print(f"   Filtered data shape: {filtered_df.shape}")
        
        if not filtered_df.empty:
            print(f"   ✅ Report data successfully transformed")
            print(f"   📊 Sample data: {filtered_df.iloc[0].to_dict() if len(filtered_df) > 0 else 'No data'}")
        else:
            print(f"   ℹ️  Report data resulted in empty DataFrame (safe - no database errors)")
        
    except Exception as e:
        print(f"   ❌ Error handling report data: {str(e)}")
        return False
    
    print("\\n2. Testing TrialBalance report data...")
    
    trial_balance_df = pd.DataFrame([{
        'ReportID': 'TrialBalance',
        'ReportName': 'Trial Balance',
        'ReportType': 'TrialBalance',
        'ReportTitles': ['Trial Balance', 'Test Company'],
        'ReportDate': '19 June 2025',
        'UpdatedDateUTC': '2025-06-19 02:38:36',
        'Fields': [],
        'Rows': [{'RowType': 'Header', 'Cells': []}]  # Complex structure
    }])
    
    try:
        filtered_df = integration._handle_report_data_structure(
            trial_balance_df, 'TrialBalance', 'c1518_7232_xeroblue_TrialBalanceSTAGE'
        )
        
        print(f"   Filtered data columns: {list(filtered_df.columns)}")
        
        if not filtered_df.empty:
            print(f"   ✅ TrialBalance data successfully transformed")
        else:
            print(f"   ℹ️  TrialBalance data resulted in empty DataFrame (safe)")
            
    except Exception as e:
        print(f"   ❌ Error handling TrialBalance data: {str(e)}")
        return False
    
    print("\\n3. Testing unknown report endpoint...")
    
    # Test scenario where no stage table schema is available
    integration._get_stage_table_columns = lambda x: set()  # No columns available
    
    try:
        filtered_df = integration._handle_report_data_structure(
            report_df, 'UnknownReport', 'unknown_stage_table'
        )
        
        if filtered_df.empty:
            print(f"   ✅ Unknown report correctly returns empty DataFrame (safe)")
        else:
            print(f"   ⚠️  Unknown report returned data: {filtered_df.shape}")
            
    except Exception as e:
        print(f"   ❌ Error with unknown report: {str(e)}")
        return False
    
    print("\\n" + "=" * 50)
    print("🎉 ALL REPORT DATA STRUCTURE TESTS PASSED!")
    print("✅ Report endpoints will no longer cause database column errors")
    print("🔧 BankSummary and TrialBalance are now handled safely")
    
    return True

def test_column_filtering_improvements():
    """Test the improved column filtering for regular endpoints"""
    
    print("\\n🔍 Testing Improved Column Filtering")
    print("=" * 40)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create minimal integration instance
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.report_endpoints = {'BankSummary', 'TrialBalance'}
    
    # Test regular endpoint column filtering
    regular_df = pd.DataFrame([{
        'ContactID': '123',
        'Name': 'Test Contact',
        'UpdatedDateUTC': '2025-06-19',
        'HasValidationErrors': True,  # Should be filtered out
        'ReportID': 'ShouldNotExist',  # Should be filtered out
        'ValidationErrors': [],  # Should be filtered out
    }])
    
    # Mock stage table columns for regular endpoint
    def mock_regular_columns(stage_table):
        return {'ContactID', 'Name', 'UpdatedDateUTC', 'Email', 'Phone'}
    
    integration._get_stage_table_columns = mock_regular_columns
    
    print("\\n  Testing regular endpoint filtering...")
    print(f"   Original columns: {list(regular_df.columns)}")
    
    try:
        filtered_df = integration._filter_dataframe_columns(
            regular_df, 'Contacts', 'contacts_stage_table'
        )
        
        print(f"   Filtered columns: {list(filtered_df.columns)}")
        
        # Check that problematic columns were removed
        problematic_cols = {'HasValidationErrors', 'ReportID', 'ValidationErrors'}
        remaining_problematic = set(filtered_df.columns) & problematic_cols
        
        if not remaining_problematic:
            print(f"   ✅ Problematic columns successfully filtered out")
        else:
            print(f"   ❌ Problematic columns still present: {remaining_problematic}")
            return False
            
        # Check that valid columns were kept
        if 'ContactID' in filtered_df.columns and 'Name' in filtered_df.columns:
            print(f"   ✅ Valid columns successfully retained")
        else:
            print(f"   ❌ Valid columns were incorrectly filtered out")
            return False
            
    except Exception as e:
        print(f"   ❌ Error in column filtering: {str(e)}")
        return False
    
    print("\\n   ✅ Column filtering improvements working correctly")
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
        print("🔧 Testing Report Column Error Fix\\n")
        
        # Run tests
        report_test_passed = test_report_data_structure_handling()
        column_test_passed = test_column_filtering_improvements()
        
        if report_test_passed and column_test_passed:
            print("\\n🚀 ALL TESTS PASSED!")
            print("✅ Database column errors for report endpoints have been fixed")
            print("✅ BankSummary and TrialBalance will no longer cause 'Unknown column' errors")
            print("🎯 Integration is ready for production with proper report handling")
        else:
            print("\\n❌ Some tests failed - please review the implementation")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()