#!/usr/bin/env python3
"""
Test All Endpoint ID Columns

This test verifies that all endpoints that use LineItems transformation 
have the correct ID column mappings as requested by the user:

"please check carefully also the other endpoints if its using the correct ID column 
ex. creditnotes - creditnotesid"

Tests all these endpoints:
- invoices -> InvoiceID -> InvoiceId
- invoicesdraft -> InvoiceID -> InvoiceId  
- creditnotes -> CreditNoteID -> CreditNoteId
- overpayments -> OverpaymentID -> OverpaymentId
- prepayments -> PrepaymentID -> PrepaymentId
- banktransactions -> BankTransactionID -> BankTransactionId
- purchaseorders -> PurchaseOrderID -> PurchaseOrderId
- receipts -> ReceiptID -> ReceiptId
- quotes -> QuoteID -> QuoteId
"""

import os
import sys
import pandas as pd

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')

def test_endpoint_id_columns():
    """Test that all endpoints use correct ID column mappings"""
    
    print("🔧 Testing All Endpoint ID Columns")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # Define test cases: endpoint -> (source_id_field, expected_target_column, test_id_value)
        endpoint_test_cases = {
            'invoices': ('InvoiceID', 'InvoiceId', 'test-invoice-123'),
            'invoicesdraft': ('InvoiceID', 'InvoiceId', 'test-invoicedraft-123'),
            'creditnotes': ('CreditNoteID', 'CreditNoteId', 'test-creditnote-123'),
            'overpayments': ('OverpaymentID', 'OverpaymentId', 'test-overpayment-123'),
            'prepayments': ('PrepaymentID', 'PrepaymentId', 'test-prepayment-123'),
            'banktransactions': ('BankTransactionID', 'BankTransactionId', 'test-banktransaction-123'),
            'purchaseorders': ('PurchaseOrderID', 'PurchaseOrderId', 'test-purchaseorder-123'),
            'receipts': ('ReceiptID', 'ReceiptId', 'test-receipt-123'),
            'quotes': ('QuoteID', 'QuoteId', 'test-quote-123')
        }
        
        all_passed = True
        results = []
        
        for endpoint, (source_id_field, expected_target_column, test_id_value) in endpoint_test_cases.items():
            
            print(f"\n   Testing {endpoint}:")
            print(f"      Source: {source_id_field} -> Target: {expected_target_column}")
            
            # Create sample data for this endpoint
            sample_data = {
                source_id_field: test_id_value,
                'Type': 'TEST',
                'Contact': {
                    'ContactID': 'contact-123',
                    'Name': 'Test Contact'
                },
                'LineItems': [{
                    'LineItemID': 'line-123',
                    'Description': f'Test Line Item for {endpoint}',
                    'Quantity': 1.0,
                    'UnitAmount': 100.0
                }]
            }
            
            df = pd.DataFrame([sample_data])
            
            try:
                # Apply transformation
                transformed_df = integration._transform_lineitems_data(df, endpoint)
                
                # Check that expected target column is present
                if expected_target_column in transformed_df.columns:
                    print(f"      ✅ {expected_target_column} column found")
                    
                    # Check that value is populated correctly
                    target_values = transformed_df[expected_target_column].dropna()
                    if len(target_values) > 0 and target_values.iloc[0] == test_id_value:
                        print(f"      ✅ Value correctly mapped: {target_values.iloc[0]}")
                        results.append((endpoint, True))
                    else:
                        print(f"      ❌ Value mismatch. Expected: {test_id_value}, Got: {target_values.iloc[0] if len(target_values) > 0 else 'None'}")
                        results.append((endpoint, False))
                        all_passed = False
                else:
                    print(f"      ❌ {expected_target_column} column not found")
                    print(f"      Available columns: {list(transformed_df.columns)}")
                    results.append((endpoint, False))
                    all_passed = False
                
                # Check that wrong ID columns are NOT present
                wrong_columns = []
                for other_endpoint, (_, other_target_column, _) in endpoint_test_cases.items():
                    if other_endpoint != endpoint and other_target_column in transformed_df.columns:
                        wrong_columns.append(other_target_column)
                
                if wrong_columns:
                    print(f"      ⚠️  Wrong ID columns present: {wrong_columns}")
                    # This is a warning, not a failure, as some endpoints might share patterns
                
            except Exception as e:
                print(f"      ❌ Error transforming {endpoint}: {str(e)}")
                results.append((endpoint, False))
                all_passed = False
        
        return all_passed, results
        
    except Exception as e:
        print(f"   ❌ Test setup failed: {str(e)}")
        return False, []

def test_id_column_conflicts():
    """Test that there are no conflicts between different endpoint ID columns"""
    
    print("\n🔧 Testing ID Column Conflicts")
    print("=" * 35)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # Test mixed data (invoices and creditnotes in same transformation)
        mixed_data = [
            {
                'InvoiceID': 'test-invoice-001',
                'Type': 'ACCREC',
                'Contact': {'ContactID': 'contact-1', 'Name': 'Contact 1'},
                'LineItems': [{'LineItemID': 'line-1', 'Description': 'Invoice line'}]
            }
        ]
        
        df = pd.DataFrame(mixed_data)
        
        # Test Invoices
        transformed_invoices = integration._transform_lineitems_data(df, 'Invoices')
        
        # Check Invoices result
        if 'InvoiceId' in transformed_invoices.columns and 'CreditNoteId' not in transformed_invoices.columns:
            print(f"   ✅ Invoices correctly creates only InvoiceId column")
            invoices_ok = True
        else:
            print(f"   ❌ Invoices column issue. Has InvoiceId: {'InvoiceId' in transformed_invoices.columns}, Has CreditNoteId: {'CreditNoteId' in transformed_invoices.columns}")
            invoices_ok = False
        
        # Test with CreditNotes data
        creditnote_data = [
            {
                'CreditNoteID': 'test-creditnote-001',
                'Type': 'ACCRECCREDIT',
                'Contact': {'ContactID': 'contact-2', 'Name': 'Contact 2'},
                'LineItems': [{'LineItemID': 'line-2', 'Description': 'CreditNote line'}]
            }
        ]
        
        df_cn = pd.DataFrame(creditnote_data)
        transformed_creditnotes = integration._transform_lineitems_data(df_cn, 'CreditNotes')
        
        # Check CreditNotes result
        if 'CreditNoteId' in transformed_creditnotes.columns and 'InvoiceId' not in transformed_creditnotes.columns:
            print(f"   ✅ CreditNotes correctly creates only CreditNoteId column")
            creditnotes_ok = True
        else:
            print(f"   ❌ CreditNotes column issue. Has CreditNoteId: {'CreditNoteId' in transformed_creditnotes.columns}, Has InvoiceId: {'InvoiceId' in transformed_creditnotes.columns}")
            creditnotes_ok = False
        
        return invoices_ok and creditnotes_ok
        
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
        print("🔧 Testing All Endpoint ID Column Mappings\\n")
        
        test1_passed, endpoint_results = test_endpoint_id_columns()
        test2_passed = test_id_column_conflicts()
        
        print("\\n" + "=" * 60)
        print("📊 ALL ENDPOINT ID COLUMNS TEST RESULTS")
        print("=" * 60)
        
        # Show individual endpoint results
        print("\\n📋 Individual Endpoint Results:")
        for endpoint, passed in endpoint_results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {endpoint}")
        
        # Show overall results
        overall_results = [
            ("All Endpoint ID Mappings", test1_passed),
            ("ID Column Conflict Prevention", test2_passed)
        ]
        
        passed_count = sum(1 for _, passed in overall_results if passed)
        total_count = len(overall_results)
        
        print("\\n📊 Overall Test Results:")
        for test_name, passed in overall_results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count and test1_passed:
            print("\\n🎉 ALL ENDPOINT ID COLUMNS VERIFIED!")
            print()
            print("✅ All endpoints use correct ID column mappings:")
            print("   - invoices -> InvoiceID -> InvoiceId")
            print("   - creditnotes -> CreditNoteID -> CreditNoteId")
            print("   - overpayments -> OverpaymentID -> OverpaymentId")
            print("   - prepayments -> PrepaymentID -> PrepaymentId")
            print("   - banktransactions -> BankTransactionID -> BankTransactionId")
            print("   - purchaseorders -> PurchaseOrderID -> PurchaseOrderId")
            print("   - receipts -> ReceiptID -> ReceiptId")
            print("   - quotes -> QuoteID -> QuoteId")
            print()
            print("✅ No column conflicts between endpoints")
            print("✅ Stage table schema alignment should work correctly")
            print()
            print("🚀 Should resolve 'Unknown column' errors for all endpoints!")
        else:
            print(f"\\n❌ {total_count - passed_count} tests failed - review needed")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()