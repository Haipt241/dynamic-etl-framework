#!/usr/bin/env python3
"""
Test OrganisationID Fix for Integer Default Values

This test validates that OrganisationID now gets proper integer default values
using etani_organisation_id instead of string defaults.
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_organisationid_fix():
    """Test that OrganisationID gets proper integer default values"""
    
    print("🧪 Testing OrganisationID Fix")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance with minimal config
        config = {'rate_limit': 60, 'apply_default_values': True}
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = config
        integration.error_list = []
        
        # Set the etani_organisation_id that should be used
        integration.etani_organisation_id = '7232'
        
        print("1. Testing OrganisationID data type mapping...")
        required_columns = integration._get_required_columns_for_endpoint('Organisations')
        org_id_type = required_columns.get('OrganisationID')
        print(f"   OrganisationID data type: {org_id_type}")
        
        if org_id_type == 'integer':
            print("   ✅ OrganisationID correctly mapped as integer")
        else:
            print(f"   ❌ OrganisationID incorrectly mapped as {org_id_type}")
            return False
        
        print("2. Testing default value generation for OrganisationID...")
        default_value = integration._get_default_value_by_type('integer', 'OrganisationID')
        print(f"   Generated default value: {default_value} (type: {type(default_value).__name__})")
        
        if isinstance(default_value, int) and default_value == 7232:
            print("   ✅ OrganisationID gets correct integer default from etani_organisation_id")
        else:
            print(f"   ❌ OrganisationID default is wrong: {default_value}")
            return False
        
        print("3. Testing full default value application...")
        # Create test data without OrganisationID
        test_data = pd.DataFrame([{
            'Name': 'Test Organisation',
            'ShortCode': 'TEST'
            # Missing OrganisationID - should be added with default
        }])
        
        print(f"   Original data columns: {list(test_data.columns)}")
        
        # Apply default values
        fixed_data = integration._apply_default_values_for_required_columns(test_data, 'Organisations')
        
        print(f"   Fixed data columns: {list(fixed_data.columns)}")
        
        if 'OrganisationID' in fixed_data.columns:
            org_id_value = fixed_data['OrganisationID'].iloc[0]
            print(f"   OrganisationID value: {org_id_value} (type: {type(org_id_value).__name__})")
            
            # Check if it's any integer type (int, numpy int64, pandas int, etc.)
            if str(type(org_id_value).__name__) in ['int', 'int64', 'Int64'] and int(org_id_value) == 7232:
                print("   ✅ OrganisationID correctly added with etani_organisation_id value")
            else:
                print(f"   ❌ OrganisationID has wrong value: {org_id_value} (expected 7232)")
                return False
        else:
            print("   ❌ OrganisationID not added to data")
            return False
        
        print("4. Testing other ID columns...")
        # Test CreditNoteID default
        creditnote_default = integration._get_default_value_by_type('string', 'CreditNoteID')
        print(f"   CreditNoteID default: {creditnote_default} (type: {type(creditnote_default).__name__})")
        
        if isinstance(creditnote_default, int):
            print("   ✅ CreditNoteID gets integer default")
        else:
            print(f"   ❌ CreditNoteID gets non-integer default: {creditnote_default}")
            return False
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_string_default_prevention():
    """Test that string defaults like 'DEFAULT_OrganisationID_1750305753' are prevented"""
    
    print("\n🔍 Testing String Default Prevention")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance 
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.etani_organisation_id = '7232'
        
        print("1. Testing that OrganisationID no longer gets string defaults...")
        
        # Test the specific scenario that was failing
        test_data = pd.DataFrame([{
            'ShortCode': '!XPnnc',
            'APIKey': 'REDACTED',
            'Name': 'Etani Online Clothing'
            # Missing OrganisationID
        }])
        
        # Apply defaults - this should NOT generate 'DEFAULT_OrganisationID_1750305753'
        fixed_data = integration._apply_default_values_for_required_columns(test_data, 'Organisations')
        
        if 'OrganisationID' in fixed_data.columns:
            org_id_value = fixed_data['OrganisationID'].iloc[0]
            
            # Check that it's NOT a string starting with 'DEFAULT_'
            if isinstance(org_id_value, str) and org_id_value.startswith('DEFAULT_'):
                print(f"   ❌ Still generating string defaults: {org_id_value}")
                return False
            elif str(type(org_id_value).__name__) in ['int', 'int64', 'Int64']:
                print(f"   ✅ Now generating integer default: {org_id_value}")
                return True
            else:
                print(f"   ⚠️  Unexpected default type: {org_id_value} ({type(org_id_value)})")
                return False
        else:
            print("   ❌ OrganisationID not added")
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
    try:
        print("🔧 Testing OrganisationID Integer Default Fix\n")
        
        # Run tests
        test1_passed = test_organisationid_fix()
        test2_passed = test_string_default_prevention()
        
        print("\n" + "=" * 60)
        print("📊 TEST RESULTS SUMMARY")
        print("=" * 60)
        
        results = [
            ("OrganisationID Fix", test1_passed),
            ("String Default Prevention", test2_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\n🎉 ALL TESTS PASSED!")
            print("✅ OrganisationID now uses etani_organisation_id integer value")
            print("✅ No more 'DEFAULT_OrganisationID_1750305753' string errors")
            print("✅ IntegrityError for incorrect integer values - FIXED!")
            print("🚀 Ready for production - OrganisationID errors resolved!")
        else:
            print(f"\n❌ {total_count - passed_count} tests failed - please review implementation")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()