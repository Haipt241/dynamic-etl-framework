#!/usr/bin/env python3
"""
Debug Invoice Transformation - Simple test to see what's going wrong
"""

import os
import sys
import pandas as pd

# Add the package directory to Python path

# Set minimal environment variables for testing
os.environ['DB_Destination'] = 'DW'
os.environ['JOB_ID'] = '1'
os.environ['JOB_RUN_ID'] = '9999'
os.environ['EtaniClientID'] = 'TESTCLIENT_CLIENT9999'
os.environ['EtaniOrganisationID'] = '9999'
os.environ['XeroTenantID'] = 'test-tenant-id'

def test_invoice_debug():
    """Debug invoice transformation to see actual output"""
    print("🐞 DEBUG: Testing Invoice Transformation")
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create minimal config to avoid database calls
        config = {'test_mode': True, 'skip_cms': True}
        integration = XeroblueIntegration(config)
        
        # Create simple test invoice data
        test_data = pd.DataFrame([{
            'InvoiceID': 'test-invoice-123',
            'Type': 'ACCREC',
            'Contact': {'ContactID': 'contact-123', 'Name': 'Test Customer'},
            'DateString': '2025-01-01',
            'Status': 'AUTHORISED',
            'SubTotal': 1000.00,
            'Total': 1100.00,
            'UpdatedDateUTC': '/Date(1738284586966)/',
            'LineItems': [
                {
                    'LineItemID': 'line-1',
                    'Description': 'Professional Services',
                    'Quantity': 10,
                    'UnitAmount': 100.00,
                    'LineAmount': 1000.00,
                    'AccountCode': '200',
                    'TaxType': 'OUTPUT',
                    'Tracking': [
                        {
                            'TrackingCategoryID': 'track-cat-1',
                            'Name': 'Department',
                            'TrackingOptionID': 'track-opt-1',
                            'Option': 'Consulting'
                        },
                        {
                            'TrackingCategoryID': 'track-cat-2',
                            'Name': 'Project',
                            'TrackingOptionID': 'track-opt-2',
                            'Option': 'Project Alpha'
                        }
                    ]
                }
            ]
        }])
        
        print(f"📊 Input data columns: {list(test_data.columns)}")
        print(f"📊 Input data shape: {test_data.shape}")
        
        # Test individual methods first
        print(f"\\n🔍 Testing individual transformation methods:")
        first_record = test_data.iloc[0].to_dict()
        
        # Test base data creation
        base_data = integration._create_base_record_data(first_record, 'invoices', 1)
        print(f"   Base data keys: {list(base_data.keys())}")
        
        # Test lineitem extraction
        line_item = first_record['LineItems'][0]
        lineitem_data = integration._extract_lineitem_fields(line_item)
        print(f"   LineItem data keys: {list(lineitem_data.keys())}")
        
        # Test tracking extraction
        print(f"\\n🔍 DEBUG: Testing _safe_get method:")
        tracking_from_safe_get = integration._safe_get(line_item, 'Tracking', [])
        print(f"   _safe_get result: {tracking_from_safe_get}")
        print(f"   _safe_get type: {type(tracking_from_safe_get)}")
        
        tracking_data = integration._extract_tracking_categories(line_item)
        print(f"   Tracking data keys: {list(tracking_data.keys())}")
        print(f"   Tracking data values: {tracking_data}")
        
        # Debug: Check what's in the line item
        print(f"\\n🔍 LineItem content:")
        print(f"   Tracking field exists: {'Tracking' in line_item}")
        print(f"   Tracking field type: {type(line_item.get('Tracking', 'MISSING'))}")
        print(f"   Tracking field value: {line_item.get('Tracking', 'MISSING')}")
        
        # Test transformation directly
        transformed_data = integration._transform_lineitems_data(test_data, 'invoices')
        
        print(f"\\n📊 Output data columns: {list(transformed_data.columns)}")
        print(f"📊 Output data shape: {transformed_data.shape}")
        
        if len(transformed_data) > 0:
            first_row = transformed_data.iloc[0]
            print(f"\\n🔍 First row sample values:")
            for col in ['InvoiceId', 'LineItem_Description', 'LineItem_TrackingCategory1_CategoryName', 'LineItem_TrackingCategory2_CategoryName']:
                print(f"   {col}: {first_row.get(col, 'MISSING')}")
            
            # Check if tracking categories are working
            print(f"\\n🔍 All tracking-related columns:")
            tracking_cols = [col for col in transformed_data.columns if 'TrackingCategory' in col]
            for col in tracking_cols:
                print(f"   {col}: {first_row.get(col, 'MISSING')}")
        
        return True
        
    except Exception as e:
        print(f"❌ Debug test failed: {str(e)}")
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

if __name__ == "__main__":
    test_invoice_debug()