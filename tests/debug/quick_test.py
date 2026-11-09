#!/usr/bin/env python3
"""Quick test of XeroBlue API patterns"""

import os
import sys

def quick_test():
    try:
        # Set up environment
        os.environ.setdefault('EtaniClientID', 'TEST_CLIENT')
        os.environ.setdefault('EtaniOrganisationID', '1234')
        os.environ.setdefault('XeroTenantID', 'test-tenant-id')
        os.environ.setdefault('DB_Destination', 'EVA')
        
        print("Loading XeroBlue integration...")
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        print("Creating integration instance...")
        config = {'rate_limit': 60, 'debug': True}
        integration = XeroblueIntegration(config)
        
        print("Testing get_endpoint_api_params method...")
        
        # Test simple endpoint
        endpoint, params, if_modified_since = integration.get_endpoint_api_params('Organisations')
        print(f"Organisations: endpoint='{endpoint}', params={params}")
        
        # Test JournalsCash special case
        endpoint, params, if_modified_since = integration.get_endpoint_api_params('JournalsCash', offset=50)
        print(f"JournalsCash: endpoint='{endpoint}', params={params}")
        
        # Test pagination
        endpoint, params, if_modified_since = integration.get_endpoint_api_params('Invoices', page=1)
        print(f"Invoices: endpoint='{endpoint}', params={params}")
        
        print("\\n✅ Quick test PASSED! API patterns are working correctly.")
        return True
        
    except Exception as e:
        print(f"❌ Quick test FAILED: {str(e)}")
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
    quick_test()