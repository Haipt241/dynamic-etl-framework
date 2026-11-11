#!/usr/bin/env python3
"""Minimal test of API parameter patterns"""

import os
import sys

# Set required environment variables BEFORE importing anything
os.environ.setdefault('EtaniClientID', 'TEST_CLIENT123')
os.environ.setdefault('EtaniOrganisationID', '1234')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_api_parameters():
    """Test API parameter generation without full integration initialization"""
    
    print("🧪 Testing XeroBlue API Parameter Generation")
    print("=" * 50)
    
    # Import just the integration class
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create minimal config  
    config = {'rate_limit': 60}
    
    # Create instance but don't call full init
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    
    # Set minimal required attributes for get_endpoint_api_params method
    integration.config = config
    integration.integration_config = {'report_endpoints': {'BalanceSheet', 'BankStatement'}}
    integration.report_endpoints = integration.integration_config['report_endpoints']
    
    print("Testing key API parameter patterns...")
    
    # Test simple endpoint
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('Organisations')
    print(f"Organisations: endpoint='{endpoint}', params={params}")
    assert endpoint == 'Organisations' and params is None, "Simple endpoint failed"
    
    # Test JournalsCash special case  
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('JournalsCash', offset=50)
    print(f"JournalsCash: endpoint='{endpoint}', params={params}")
    expected_params = {'offset': 50, 'paymentsOnly': True}
    assert endpoint == 'Journals' and params == expected_params, "JournalsCash failed"
    
    # Test pagination
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('Invoices', page=1)
    print(f"Invoices: endpoint='{endpoint}', params={params}")
    expected_params = {'page': 1, 'pagesize': 100}
    assert endpoint == 'Invoices' and params == expected_params, "Invoices pagination failed"
    
    # Test Contacts with includeArchived
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('Contacts', page=1)
    print(f"Contacts: endpoint='{endpoint}', params={params}")
    expected_params = {'includeArchived': True, 'page': 1, 'pagesize': 100}
    assert endpoint == 'Contacts' and params == expected_params, "Contacts failed"
    
    # Test InvoicesDraft special case
    endpoint, params, if_modified_since = integration.get_endpoint_api_params('InvoicesDraft', page=1)
    print(f"InvoicesDraft: endpoint='{endpoint}', params={params}")
    expected_params = {'page': 1, 'pagesize': 100, 'Statuses': 'DRAFT,SUBMITTED'}
    assert endpoint == 'Invoices' and params == expected_params, "InvoicesDraft failed"
    
    print("\\n" + "=" * 50)
    print("🎉 ALL API PARAMETER TESTS PASSED!")
    print("✅ XeroBlue integration correctly implements XeroRequestsManager patterns")
    print("🔧 Ready for production testing with real API calls")
    
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
        test_api_parameters()
        print("\\n🚀 SUCCESS: XeroBlue API patterns validation completed!")
    except Exception as e:
        print(f"❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()