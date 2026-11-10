#!/usr/bin/env python3
"""
Simple Test for Null Row Filtering Fix
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')

def test_basic_null_filtering():
    """Test basic null filtering functionality"""
    
    print("🧪 Testing Basic Null Filtering")
    print("=" * 35)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create minimal integration instance
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.error_list = []
        integration.etani_organisation_id = '7232'
        
        print("1. Testing CreditNotes filtering...")
        
        # Simple test data 
        test_data = pd.DataFrame([
            {
                'CreditNoteNumber': 'CN-001',
                'Type': 'CREDITNOTE',
                'Status': 'AUTHORISED',
                'Contact': 'Test Contact',
                'CreditNoteID': None  # Null - should be filtered out
            },
            {
                'CreditNoteNumber': 'CN-002', 
                'Type': 'CREDITNOTE',
                'Status': 'AUTHORISED',
                'Contact': 'Test Contact 2',
                'CreditNoteID': 'valid-id-123'  # Valid - should be kept
            }
        ])
        
        print(f"   Input: {len(test_data)} rows")
        
        # Apply filtering
        filtered = integration._filter_rows_with_null_required_columns(test_data, 'CreditNotes')
        
        print(f"   Output: {len(filtered)} rows")
        
        if len(filtered) == 1 and filtered['CreditNoteID'].iloc[0] == 'valid-id-123':
            print("   ✅ Filtering works correctly")
            return True
        else:
            print("   ❌ Filtering failed")
            return False
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

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
    success = test_basic_null_filtering()
    if success:
        print("\n🎉 NULL FILTERING TEST PASSED!")
        print("✅ IntegrityError prevention working")
    else:
        print("\n❌ NULL FILTERING TEST FAILED!")