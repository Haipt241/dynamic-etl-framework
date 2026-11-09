#!/usr/bin/env python3
"""Minimal test of API parameter patterns without full initialization"""

import os
import sys

def test_api_parameters_only():
    """Test API parameter generation without full integration initialization"""
    
    print("🧪 Testing XeroBlue API Parameter Generation")
    print("=" * 50)
    
    # Import just the integration class
    from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create minimal config  
    config = {'rate_limit': 60}
    
    # Create instance but don't call full init
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    
    # Set minimal required attributes for get_endpoint_api_params method
    integration.config = config
    integration.integration_config = {'report_endpoints': {'BalanceSheet', 'BankStatement'}}
    integration.report_endpoints = integration.integration_config['report_endpoints']
    
    print("Testing API parameter patterns...")
    
    test_cases = [
        # Simple endpoints
        ('Organisations', None, None, 'Organisations', None),
        ('Accounts', None, None, 'Accounts', None),
        
        # Pagination endpoints
        ('Invoices', 1, None, 'Invoices', {'page': 1, 'pagesize': 100}),
        ('CreditNotes', 2, None, 'CreditNotes', {'page': 2, 'pagesize': 100}),
        
        # Offset-based
        ('Journals', None, 100, 'Journals', {'offset': 100}),
        
        # Special cases
        ('JournalsCash', None, 50, 'Journals', {'offset': 50, 'paymentsOnly': True}),
        ('InvoicesDraft', 1, None, 'Invoices', {'page': 1, 'pagesize': 100, 'Statuses': 'DRAFT,SUBMITTED'}),
        ('Contacts', 1, None, 'Contacts', {'includeArchived': True, 'page': 1, 'pagesize': 100}),
        
        # Report endpoints
        ('BalanceSheet', None, None, 'BalanceSheet', {'timeframe': 'MONTH', 'periods': 11}),
    ]
    
    passed = 0
    failed = 0
    
    for endpoint, page, offset, expected_endpoint, expected_params in test_cases:
        try:
            actual_endpoint, actual_params, if_modified_since = integration.get_endpoint_api_params(
                endpoint, page=page, offset=offset
            )
            
            # Check endpoint
            if actual_endpoint == expected_endpoint and actual_params == expected_params:
                print(f"  ✅ {endpoint}: PASSED")
                passed += 1
            else:
                print(f"  ❌ {endpoint}: FAILED")
                print(f"     Expected: endpoint='{expected_endpoint}', params={expected_params}")
                print(f"     Got:      endpoint='{actual_endpoint}', params={actual_params}")
                failed += 1
                
        except Exception as e:
            print(f"  ❌ {endpoint}: ERROR - {str(e)}")
            failed += 1
    
    print("\\n" + "=" * 50)
    print(f"Results: {passed} passed, {failed} failed")
    
    if failed == 0:
        print("🎉 ALL API PARAMETER TESTS PASSED!")
        print("✅ XeroBlue integration correctly implements all XeroRequestsManager patterns")
        return True
    else:
        print("❌ Some tests failed")
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
    test_api_parameters_only()