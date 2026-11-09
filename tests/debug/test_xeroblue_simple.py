#!/usr/bin/env python3
"""
Simple test for XeroBlue API Patterns Implementation
"""

import os
import sys

def test_api_patterns():
    """Test basic API parameter patterns"""
    
    # Set up environment
    os.environ.setdefault('EtaniClientID', 'TEST_CLIENT')
    os.environ.setdefault('EtaniOrganisationID', '1234')
    os.environ.setdefault('XeroTenantID', 'test-tenant-id')
    os.environ.setdefault('DB_Destination', 'EVA')
    
    # Import the integration
    from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
    
    config = {'rate_limit': 60, 'debug': True}
    integration = XeroblueIntegration(config)
    
    print("🧪 Testing XeroBlue API Parameter Patterns")
    print("=" * 60)
    
    # Test simple endpoints
    print("\\n1. Testing simple endpoints (no params):")
    simple_endpoints = ['Organisations', 'Accounts', 'BankTransfers', 'Currencies']
    
    for endpoint in simple_endpoints:
        actual_endpoint, params, if_modified_since = integration.get_endpoint_api_params(endpoint)
        print(f"   {endpoint}: endpoint='{actual_endpoint}', params={params}")
        
        # Validate
        if actual_endpoint != endpoint or params is not None:
            print(f"   ❌ FAILED: Expected no params for {endpoint}")
            return False
    
    print("   ✅ Simple endpoints: PASSED")
    
    # Test pagination endpoints
    print("\\n2. Testing pagination endpoints:")
    
    # Invoices with pagination
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('Invoices', page=1)
    expected_params = {'page': 1, 'pagesize': 100}
    print(f"   Invoices page 1: params={params}")
    if params != expected_params:
        print(f"   ❌ FAILED: Expected {expected_params}, got {params}")
        return False
    
    # JournalsCash special case
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('JournalsCash', offset=50)
    expected_endpoint = 'Journals'
    expected_params = {'offset': 50, 'paymentsOnly': True}
    print(f"   JournalsCash: endpoint='{endpoint}', params={params}")
    if endpoint != expected_endpoint or params != expected_params:
        print(f"   ❌ FAILED: Expected endpoint='{expected_endpoint}', params={expected_params}")
        return False
    
    # InvoicesDraft special case
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('InvoicesDraft', page=1)
    expected_endpoint = 'Invoices'
    expected_params = {'page': 1, 'pagesize': 100, 'Statuses': 'DRAFT,SUBMITTED'}
    print(f"   InvoicesDraft: endpoint='{endpoint}', params={params}")
    if endpoint != expected_endpoint or params != expected_params:
        print(f"   ❌ FAILED: Expected endpoint='{expected_endpoint}', params={expected_params}")
        return False
    
    # Contacts with includeArchived
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('Contacts', page=1)
    expected_params = {'includeArchived': True, 'page': 1, 'pagesize': 100}
    print(f"   Contacts: params={params}")
    if params != expected_params:
        print(f"   ❌ FAILED: Expected {expected_params}, got {params}")
        return False
    
    print("   ✅ Pagination endpoints: PASSED")
    
    # Test special report endpoints
    print("\\n3. Testing report endpoints:")
    
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('BalanceSheet')
    expected_params = {'timeframe': 'MONTH', 'periods': 11}
    print(f"   BalanceSheet: params={params}")
    if params != expected_params:
        print(f"   ❌ FAILED: Expected {expected_params}, got {params}")
        return False
    
    print("   ✅ Report endpoints: PASSED")
    
    print("\\n" + "=" * 60)
    print("🎉 ALL TESTS PASSED!")
    print("✅ XeroBlue API patterns are correctly implemented")
    print("✅ Ready for production testing")
    
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
        success = test_api_patterns()
        if success:
            print("\\n🚀 Test completed successfully!")
        else:
            print("\\n❌ Test failed!")
    except Exception as e:
        print(f"❌ Test error: {str(e)}")
        import traceback
        traceback.print_exc()