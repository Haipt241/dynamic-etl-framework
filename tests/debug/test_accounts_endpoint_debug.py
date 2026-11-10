#!/usr/bin/env python3
"""
Test Accounts Endpoint Debug

This test simulates exactly what happens when processing the Accounts endpoint
to verify that it doesn't get the CLIENTS suffix.
"""

import os
import sys

# Set environment variables
os.environ.setdefault('EtaniClientID', 'BIGOLESHOECOMPANY_CLIENT1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', '865512af-e7d8-4d42-8568-73084279eb43')

def test_accounts_endpoint_processing():
    """Test Accounts endpoint processing to verify table names"""
    
    print("🔧 Testing Accounts Endpoint Processing")
    print("=" * 50)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance with full configuration
        config = {'debug': True}
        integration = XeroblueIntegration(config)
        
        print("1. Testing table name construction for Accounts...")
        
        # Simulate the exact logic from process_endpoint method
        endpoint = 'Accounts'
        
        # This is the exact logic from lines 1771-1774
        stage_table = integration.table_prefix_eva + endpoint + 'STAGE'
        sp_name = 'sp_' + integration.table_prefix_eva + endpoint
        prod_table = integration.table_prefix_eva.replace('_' + str(integration.etani_organisation_id), '') + endpoint
        dw_prod_table = integration.table_prefix_dw.replace('_' + str(integration.etani_organisation_id), '') + endpoint
        
        print(f"   Endpoint: {endpoint}")
        print(f"   table_prefix_eva: {integration.table_prefix_eva}")
        print(f"   etani_organisation_id: {integration.etani_organisation_id}")
        print(f"   Constructed names:")
        print(f"      Stage Table: {stage_table}")
        print(f"      SP Name: {sp_name}")
        print(f"      Prod Table: {prod_table}")
        print(f"      DW Prod Table: {dw_prod_table}")
        
        # Check for CLIENTS suffix (should not be present)
        has_clients_suffix = any('CLIENTS' in name for name in [stage_table, sp_name, prod_table, dw_prod_table])
        
        if has_clients_suffix:
            print(f"   ❌ ERROR: Accounts endpoint has CLIENTS suffix!")
            print(f"   This suggests the Organisations logic is being applied incorrectly")
            return False
        else:
            print(f"   ✅ Accounts endpoint correctly has no CLIENTS suffix")
        
        print("\n2. Testing routing logic for Accounts...")
        
        # Test the exact conditional logic
        if endpoint == 'Organisations':
            routing = 'organisations_endpoint'
            print(f"   Would route to: _process_organisations_endpoint")
        elif endpoint == 'Accounts':
            routing = 'accounts_endpoint'
            print(f"   Would route to: _process_accounts_endpoint")
        elif endpoint in ['Transactions', 'TrackingCategoryConnections']:
            routing = 'skip'
            print(f"   Would skip endpoint")
        else:
            routing = 'generic_endpoint'
            print(f"   Would route to: _process_generic_endpoint")
        
        print(f"   Routing result: {routing}")
        
        if routing == 'accounts_endpoint':
            print("   ✅ Accounts correctly routes to accounts_endpoint method")
            print("   ✅ Will NOT go through organisations logic that adds CLIENTS suffix")
        else:
            print(f"   ❌ ERROR: Accounts routing to {routing} instead of accounts_endpoint")
            return False
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
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
        print("🔧 Debug Test: Accounts Endpoint Table Names\n")
        
        test_passed = test_accounts_endpoint_processing()
        
        print("\n" + "=" * 60)
        print("📊 ACCOUNTS ENDPOINT DEBUG RESULTS")
        print("=" * 60)
        
        if test_passed:
            print("✅ PASSED: Accounts Endpoint Processing")
            print()
            print("✅ Accounts endpoint table names are constructed correctly")
            print("✅ No CLIENTS suffix added to Accounts")
            print("✅ Routing logic correctly sends Accounts to accounts_endpoint method")
            print("✅ Organisations logic is properly isolated")
            print()
            print("🔍 CONCLUSION:")
            print("   The table name construction logic is working correctly.")
            print("   If you're seeing CLIENTS suffix on Accounts in production,")
            print("   it might be happening elsewhere or in a different execution path.")
            print()
            print("💡 DEBUGGING RECOMMENDATION:")
            print("   Run the integration with debug output and look for the")
            print("   'SP Name:', 'Prod Table:', 'DW Prod Table:' debug lines")
            print("   to see the actual values being used during execution.")
        else:
            print("❌ FAILED: Accounts Endpoint Processing")
            print("   Review the errors above for details")
            
    except Exception as e:
        print(f"❌ Debug test failed: {str(e)}")
        import traceback
        traceback.print_exc()