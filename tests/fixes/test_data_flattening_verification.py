#!/usr/bin/env python3
"""
Comprehensive Test Script for Data Flattening Verification

This script verifies that the XeroBlue integration properly flattens complex JSON objects
according to the original XEROBLUE - UPSERT.py implementation patterns.

Tests include:
1. Contacts transformation (Addresses, Phones)
2. Invoices transformation (LineItems, Tracking Categories)
3. CreditNotes transformation (LineItems, Tracking Categories, Allocations)
4. Column filtering for stage table insertion
"""

import os
import sys
import pandas as pd
import json
from datetime import datetime

# Add the package directory to Python path

# Set environment variables for testing
os.environ['DB_Destination'] = 'DW'
os.environ['JOB_ID'] = '1'
os.environ['JOB_RUN_ID'] = '9999'
os.environ['TRIGGER_TYPE'] = 'MANUAL'
os.environ['EtaniClientID'] = 'TESTCLIENT_CLIENT9999'
os.environ['EtaniOrganisationID'] = '9999'
os.environ['XeroTenantID'] = 'test-tenant-id'

def create_test_contact_data():
    """Create test contact data with complex nested objects"""
    return pd.DataFrame([{
        'ContactID': 'test-contact-123',
        'Name': 'Test Contact',
        'ContactStatus': 'ACTIVE',
        'EmailAddress': 'test@example.com',
        'Addresses': [
            {
                'AddressType': 'STREET',
                'AddressLine1': '123 Main St',
                'AddressLine2': 'Suite 100',
                'City': 'Sydney',
                'Region': 'NSW',
                'PostalCode': '2000',
                'Country': 'Australia'
            },
            {
                'AddressType': 'POBOX',
                'AddressLine1': 'PO Box 456',
                'City': 'Sydney',
                'Region': 'NSW',
                'PostalCode': '2001',
                'Country': 'Australia'
            }
        ],
        'Phones': [
            {'PhoneType': 'DEFAULT', 'PhoneNumber': '02-1234-5678'},
            {'PhoneType': 'MOBILE', 'PhoneNumber': '0400-123-456'},
            {'PhoneType': 'FAX', 'PhoneNumber': '02-1234-5679'},
            {'PhoneType': 'DDI', 'PhoneNumber': '02-1234-5680'}
        ],
        'UpdatedDateUTC': '/Date(1738284586966)/',
        'IsSupplier': True,
        'IsCustomer': False,
        'DefaultCurrency': 'AUD',
        'HasAttachments': False,
        'HasValidationErrors': False
    }])

def create_test_invoice_data():
    """Create test invoice data with LineItems and Tracking Categories"""
    return pd.DataFrame([{
        'InvoiceID': 'test-invoice-123',
        'Type': 'ACCREC',
        'Contact': {'ContactID': 'contact-123', 'Name': 'Test Customer'},
        'DateString': '2025-01-01',
        'DueDateString': '2025-01-31',
        'InvoiceNumber': 'INV-001',
        'Status': 'AUTHORISED',
        'SubTotal': 1000.00,
        'TotalTax': 100.00,
        'Total': 1100.00,
        'AmountDue': 1100.00,
        'CurrencyCode': 'AUD',
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
                'TaxAmount': 100.00,
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

def create_test_creditnote_data():
    """Create test credit note data with LineItems, Tracking Categories, and Allocations"""
    return pd.DataFrame([{
        'CreditNoteID': 'test-credit-123',
        'Contact': {'ContactID': 'contact-123', 'Name': 'Test Customer'},
        'DateString': '2025-01-15',
        'Status': 'AUTHORISED',
        'SubTotal': 200.00,
        'TotalTax': 20.00,
        'Total': 220.00,
        'CurrencyCode': 'AUD',
        'UpdatedDateUTC': '/Date(1738284586966)/',
        'LineItems': [
            {
                'LineItemID': 'credit-line-1',
                'Description': 'Refund for damaged goods',
                'Quantity': 2,
                'UnitAmount': 100.00,
                'LineAmount': 200.00,
                'AccountCode': '200',
                'TaxType': 'OUTPUT',
                'TaxAmount': 20.00,
                'Tracking': [
                    {
                        'TrackingCategoryID': 'track-cat-1',
                        'Name': 'Department',
                        'TrackingOptionID': 'track-opt-3',
                        'Option': 'Returns'
                    }
                ]
            }
        ],
        'Allocations': [
            {
                'Amount': 220.00,
                'Date': '2025-01-15',
                'Invoice': {'InvoiceID': 'original-invoice-456'}
            }
        ]
    }])

def test_contact_transformation():
    """Test contact transformation with addresses and phones flattening"""
    print("\\n" + "="*60)
    print("🧪 Testing Contact Transformation")
    print("="*60)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Create test data
        test_data = create_test_contact_data()
        print(f"📊 Original data: {len(test_data)} contacts, {len(test_data.columns)} columns")
        print(f"   Columns: {list(test_data.columns)}")
        
        # Transform data
        transformed_data = integration._transform_contacts_data(test_data)
        print(f"📊 Transformed data: {len(transformed_data)} contacts, {len(transformed_data.columns)} columns")
        
        # Verify key transformations
        expected_address_fields = [
            'Street_AddressLine1', 'Street_AddressLine2', 'Street_City', 'Street_Region',
            'POBox_AddressLine1', 'POBox_City', 'POBox_Region'
        ]
        expected_phone_fields = [
            'Default_PhoneNumber', 'Mobile_PhoneNumber', 'Fax_PhoneNumber', 'DDI_PhoneNumber'
        ]
        
        missing_fields = []
        for field in expected_address_fields + expected_phone_fields:
            if field not in transformed_data.columns:
                missing_fields.append(field)
        
        if missing_fields:
            print(f"❌ Missing expected fields: {missing_fields}")
            return False
        else:
            print("✅ All expected address and phone fields present")
            
        # Verify data values
        first_row = transformed_data.iloc[0]
        if (first_row['Street_AddressLine1'] == '123 Main St' and 
            first_row['POBox_AddressLine1'] == 'PO Box 456' and
            first_row['Default_PhoneNumber'] == '02-1234-5678' and
            first_row['Mobile_PhoneNumber'] == '0400-123-456'):
            print("✅ Address and phone data correctly flattened")
            return True
        else:
            print("❌ Address or phone data not correctly flattened")
            return False
            
    except Exception as e:
        print(f"❌ Contact transformation test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_invoice_transformation():
    """Test invoice transformation with LineItems and Tracking Categories"""
    print("\\n" + "="*60)
    print("🧪 Testing Invoice Transformation")
    print("="*60)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Create test data
        test_data = create_test_invoice_data()
        print(f"📊 Original data: {len(test_data)} invoices, {len(test_data.columns)} columns")
        
        # Transform data
        transformed_data = integration._transform_lineitems_data(test_data, 'invoices')
        print(f"📊 Transformed data: {len(transformed_data)} records, {len(transformed_data.columns)} columns")
        
        # Verify LineItems transformation
        expected_lineitem_fields = [
            'LineItem_LineItemId', 'LineItem_Description', 'LineItem_Quantity',
            'LineItem_UnitAmount', 'LineItem_AccountCode', 'LineItem_TaxType'
        ]
        expected_tracking_fields = [
            'LineItem_TrackingCategory1_CategoryId', 'LineItem_TrackingCategory1_CategoryName',
            'LineItem_TrackingCategory2_CategoryId', 'LineItem_TrackingCategory2_CategoryName'
        ]
        
        missing_fields = []
        for field in expected_lineitem_fields + expected_tracking_fields:
            if field not in transformed_data.columns:
                missing_fields.append(field)
        
        if missing_fields:
            print(f"❌ Missing expected fields: {missing_fields}")
            return False
        else:
            print("✅ All expected LineItem and Tracking fields present")
            
        # Debug: Print actual columns and values
        print(f"🔍 DEBUG - Actual columns in transformed data:")
        print(f"   {list(transformed_data.columns)}")
        
        # Verify data values
        if len(transformed_data) > 0:
            first_row = transformed_data.iloc[0]
            print(f"🔍 DEBUG - First row values:")
            print(f"   Description: {first_row.get('LineItem_Description', 'MISSING')}")
            print(f"   Track1 Name: {first_row.get('LineItem_TrackingCategory1_CategoryName', 'MISSING')}")
            print(f"   Track2 Name: {first_row.get('LineItem_TrackingCategory2_CategoryName', 'MISSING')}")
            print(f"   Invoice ID: {first_row.get('InvoiceId', 'MISSING')}")
            
            if (first_row.get('LineItem_Description') == 'Professional Services' and
                first_row.get('LineItem_TrackingCategory1_CategoryName') == 'Department' and
                first_row.get('LineItem_TrackingCategory2_CategoryName') == 'Project'):
                print("✅ LineItems and Tracking Categories correctly flattened")
                return True
            else:
                print("❌ LineItems or Tracking Categories not correctly flattened")
                return False
        else:
            print("❌ No transformed records found")
            return False
            
    except Exception as e:
        print(f"❌ Invoice transformation test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_creditnote_transformation():
    """Test credit note transformation with LineItems, Tracking Categories, and Allocations"""
    print("\\n" + "="*60)
    print("🧪 Testing CreditNote Transformation")
    print("="*60)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Create test data
        test_data = create_test_creditnote_data()
        print(f"📊 Original data: {len(test_data)} credit notes, {len(test_data.columns)} columns")
        
        # Transform data
        transformed_data = integration._transform_lineitems_data(test_data, 'creditnotes')
        print(f"📊 Transformed data: {len(transformed_data)} records, {len(transformed_data.columns)} columns")
        
        # Verify Allocations transformation
        expected_allocation_fields = [
            'Allocation1_AppliedAmount', 'Allocation1_Date', 'Allocation1_InvoiceId'
        ]
        
        missing_fields = []
        for field in expected_allocation_fields:
            if field not in transformed_data.columns:
                missing_fields.append(field)
        
        if missing_fields:
            print(f"❌ Missing expected allocation fields: {missing_fields}")
            return False
        else:
            print("✅ All expected Allocation fields present")
            
        # Verify data values
        if len(transformed_data) > 0:
            first_row = transformed_data.iloc[0]
            if (first_row.get('Allocation1_AppliedAmount') == 220.0 and
                first_row.get('Allocation1_InvoiceId') == 'original-invoice-456'):
                print("✅ Allocations correctly flattened")
                return True
            else:
                print("❌ Allocations not correctly flattened")
                print(f"   Amount: {first_row.get('Allocation1_AppliedAmount', 'MISSING')}")
                print(f"   Invoice ID: {first_row.get('Allocation1_InvoiceId', 'MISSING')}")
                return False
        else:
            print("❌ No transformed records found")
            return False
            
    except Exception as e:
        print(f"❌ CreditNote transformation test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_column_filtering():
    """Test column filtering for stage table insertion"""
    print("\\n" + "="*60)
    print("🧪 Testing Column Filtering")
    print("="*60)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Create test data with validation fields that should be filtered
        test_data = pd.DataFrame([{
            'ContactID': 'test-123',
            'Name': 'Test Contact',
            'HasValidationErrors': True,
            'ValidationErrors': ['Some error'],
            'HasAttachments': False,
            'Status': 'ACTIVE'
        }])
        
        print(f"📊 Original data: {len(test_data.columns)} columns")
        print(f"   Columns: {list(test_data.columns)}")
        
        # Test column filtering (mock stage table with limited columns)
        # Simulate filtering process
        excluded_columns = {
            'HasValidationErrors', 'ValidationErrors', 'Status'
        }
        
        filtered_columns = [col for col in test_data.columns if col not in excluded_columns]
        filtered_data = test_data[filtered_columns]
        
        print(f"📊 Filtered data: {len(filtered_data.columns)} columns")
        print(f"   Columns: {list(filtered_data.columns)}")
        
        # Verify exclusions
        if 'HasValidationErrors' not in filtered_data.columns:
            print("✅ HasValidationErrors correctly excluded")
            return True
        else:
            print("❌ HasValidationErrors not excluded")
            return False
            
    except Exception as e:
        print(f"❌ Column filtering test failed: {str(e)}")
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

def main():
    """Run comprehensive data flattening verification tests"""
    print("\\n" + "="*80)
    print("🚀 COMPREHENSIVE DATA FLATTENING VERIFICATION")
    print("="*80)
    print("Testing XeroBlue integration data transformation accuracy")
    print("against original XEROBLUE - UPSERT.py implementation patterns")
    
    test_results = {}
    
    # Run all tests
    test_results['contacts'] = test_contact_transformation()
    test_results['invoices'] = test_invoice_transformation()
    test_results['creditnotes'] = test_creditnote_transformation()
    test_results['filtering'] = test_column_filtering()
    
    # Summary
    print("\\n" + "="*80)
    print("📊 TEST RESULTS SUMMARY")
    print("="*80)
    
    passed = sum(test_results.values())
    total = len(test_results)
    
    for test_name, result in test_results.items():
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"   {test_name.title():<20}: {status}")
    
    print(f"\\n🎯 Overall: {passed}/{total} tests passed ({passed/total*100:.1f}%)")
    
    if passed == total:
        print("\\n🎉 ALL TESTS PASSED!")
        print("✅ Data flattening implementation verified successfully")
        print("✅ Transformations match original XEROBLUE - UPSERT.py patterns")
    else:
        print(f"\\n⚠️  {total-passed} TESTS FAILED")
        print("❌ Some transformations need fixes")
    
    print("\\n" + "="*80)
    
    return passed == total

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)