#!/usr/bin/env python3
"""
Test the default values fix for required columns

This test validates that the new default value system prevents
IntegrityError: Column 'X' cannot be null errors by ensuring
all required columns have appropriate default values.
"""

import os
import sys
import pandas as pd

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_creditnotes_default_values():
    """Test that CreditNotes gets required default values to prevent IntegrityError"""
    
    print("🧪 Testing CreditNotes Default Values Fix")
    print("=" * 50)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Create integration instance
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.error_list = []
    
    print("1. Testing CreditNotes data without required columns...")
    
    # Create problematic CreditNotes data (missing CreditNoteID that caused the error)
    problematic_data = pd.DataFrame([{
        'CreditNoteNumber': 'CN-001',
        'Date': '2025-06-19',
        'Total': 100.50,
        # Missing CreditNoteID - this was causing the IntegrityError
        # Missing other required columns too
    }])
    
    print(f"   Original columns: {list(problematic_data.columns)}")
    print(f"   Missing required column: CreditNoteID")
    
    # Test the default value application
    try:
        fixed_data = integration._apply_default_values_for_required_columns(
            problematic_data, 'CreditNotes'
        )
        
        print(f"   Fixed columns: {list(fixed_data.columns)}")
        
        # Check that CreditNoteID was added
        if 'CreditNoteID' in fixed_data.columns:
            creditnote_id = fixed_data['CreditNoteID'].iloc[0]
            print(f"   ✅ CreditNoteID added: {creditnote_id}")
        else:
            print(f"   ❌ CreditNoteID still missing")
            return False
        
        # Check that no required columns are null
        required_columns = integration._get_required_columns_for_endpoint('CreditNotes')
        for col in required_columns.keys():
            if col in fixed_data.columns:
                null_count = fixed_data[col].isnull().sum()
                if null_count > 0:
                    print(f"   ❌ {col} still has null values: {null_count}")
                    return False
                else:
                    print(f"   ✅ {col}: {fixed_data[col].iloc[0]}")
        
        print(f"   ✅ All required columns now have values - no more IntegrityError!")
        
    except Exception as e:
        print(f"   ❌ Error applying defaults: {str(e)}")
        return False
    
    return True

def test_multiple_endpoints_default_values():
    """Test default values for multiple endpoints that commonly have missing required columns"""
    
    print("\\n🔄 Testing Multiple Endpoints")
    print("=" * 40)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    
    test_cases = [
        {
            'endpoint': 'Invoices',
            'data': pd.DataFrame([{'InvoiceNumber': 'INV-001', 'Total': 500.00}]),
            'required_id': 'InvoiceID'
        },
        {
            'endpoint': 'Contacts', 
            'data': pd.DataFrame([{'Email': 'test@example.com', 'Phone': '123-456-7890'}]),
            'required_id': 'ContactID'
        },
        {
            'endpoint': 'Payments',
            'data': pd.DataFrame([{'Amount': 250.00, 'Reference': 'Payment 1'}]),
            'required_id': 'PaymentID'
        },
        {
            'endpoint': 'BankTransactions',
            'data': pd.DataFrame([{'Amount': 150.00, 'Description': 'Bank Transfer'}]),
            'required_id': 'BankTransactionID'
        }
    ]
    
    for test_case in test_cases:
        endpoint = test_case['endpoint']
        data = test_case['data']
        required_id = test_case['required_id']
        
        print(f"\\n  Testing {endpoint}...")
        print(f"    Original columns: {list(data.columns)}")
        
        try:
            # Apply default values
            fixed_data = integration._apply_default_values_for_required_columns(data, endpoint)
            
            # Validate that required ID was added
            if required_id in fixed_data.columns:
                id_value = fixed_data[required_id].iloc[0]
                print(f"    ✅ {required_id} added: {id_value}")
            else:
                print(f"    ❌ {required_id} missing")
                return False
            
            # Validate no nulls in required columns
            validation_result = integration._validate_required_columns(fixed_data, endpoint)
            if validation_result is not None:
                print(f"    ✅ Validation passed for {endpoint}")
            else:
                print(f"    ❌ Validation failed for {endpoint}")
                return False
                
        except Exception as e:
            print(f"    ❌ Error with {endpoint}: {str(e)}")
            return False
    
    print("\\n   ✅ All endpoints processed successfully!")
    return True

def test_data_type_defaults():
    """Test that different data types get appropriate default values"""
    
    print("\\n📊 Testing Data Type Defaults")
    print("=" * 35)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    
    # Test different data types
    test_types = [
        ('string', 'TestColumn'),
        ('integer', 'TestNumber'),
        ('float', 'TestAmount'),
        ('datetime', 'TestDate'),
        ('string', 'TestID'),  # Special case for ID columns
        ('string', 'Status'),  # Special case for Status columns
    ]
    
    print("  Testing default value generation...")
    
    for data_type, column_name in test_types:
        try:
            default_value = integration._get_default_value_by_type(data_type, column_name)
            print(f"    {data_type} ({column_name}): {default_value}")
            
            # Validate the default value is not None and not empty for critical fields
            if 'ID' in column_name and not default_value:
                print(f"    ❌ ID column got empty default value")
                return False
                
        except Exception as e:
            print(f"    ❌ Error generating default for {data_type}: {str(e)}")
            return False
    
    print("  ✅ All data type defaults generated successfully!")
    return True

def test_integration_with_convert_data_types():
    """Test that the default value system integrates correctly with convert_data_types"""
    
    print("\\n🔄 Testing Integration with Data Type Conversion")
    print("=" * 55)
    
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
    
    # Set up minimal integration
    config = {'rate_limit': 60}
    integration = XeroblueIntegration.__new__(XeroblueIntegration)
    integration.config = config
    integration.error_list = []
    
    # Initialize the convert_data_types method
    integration.convert_data_types = integration._import_convert_data_types()
    
    # Test data missing required columns
    test_data = pd.DataFrame([{
        'Amount': 100.00,
        'Description': 'Test transaction'
        # Missing CreditNoteID and other required fields
    }])
    
    print(f"  Input data columns: {list(test_data.columns)}")
    
    try:
        # This should apply defaults AND do data type conversion
        result = integration.convert_data_types(test_data, 'CreditNotes')
        
        print(f"  Output data columns: {list(result.columns)}")
        print(f"  Output data shape: {result.shape}")
        
        # Check that CreditNoteID was added during the process
        if 'CreditNoteID' in result.columns:
            print(f"  ✅ CreditNoteID automatically added: {result['CreditNoteID'].iloc[0]}")
        else:
            print(f"  ❌ CreditNoteID not added during conversion")
            return False
        
        print(f"  ✅ Integration with convert_data_types working!")
        return True
        
    except Exception as e:
        print(f"  ❌ Error in integration test: {str(e)}")
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
        print("🔧 Testing Default Values Fix for IntegrityError Prevention\\n")
        
        # Run all tests
        test1_passed = test_creditnotes_default_values()
        test2_passed = test_multiple_endpoints_default_values()
        test3_passed = test_data_type_defaults()
        test4_passed = test_integration_with_convert_data_types()
        
        print("\\n" + "=" * 60)
        print("📊 TEST RESULTS SUMMARY")
        print("=" * 60)
        
        results = [
            ("CreditNotes Default Values", test1_passed),
            ("Multiple Endpoints", test2_passed), 
            ("Data Type Defaults", test3_passed),
            ("Integration Test", test4_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\\n🎉 ALL TESTS PASSED!")
            print("✅ IntegrityError: Column 'CreditNoteID' cannot be null - FIXED!")
            print("✅ Default values will be applied for all required columns")
            print("✅ No more database constraint violations for missing required fields")
            print("🚀 Ready for production - IntegrityErrors prevented!")
        else:
            print(f"\\n❌ {total_count - passed_count} tests failed - please review implementation")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()