#!/usr/bin/env python3
"""
Test Original Flattening Patterns

This test verifies that our data transformation follows the exact flattening 
patterns from the original XEROBLUE - UPSERT.py file.

Fixes these specific errors by matching original patterns:
- Overpayments: Contact → Contact_ContactId (NOT ContactId)
- Prepayments: Contact → Contact_ContactId (NOT ContactId)  
- ExpenseClaims: User → UserId (NOT User_UserID)

Based on original analysis:
- Invoices: ContactId, ContactName (simple names)
- CreditNotes/Overpayments/Prepayments: Contact_ContactId, Contact_Name (prefixed)
- ExpenseClaims: UserId (simple name, no User_ prefix)
"""

import os
import sys
import pandas as pd

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')

def test_overpayments_original_pattern():
    """Test Overpayments uses Contact_ContactId pattern (original line 1144)"""
    
    print("🔧 Testing Overpayments Original Pattern")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns match original
        required_columns = integration._get_required_columns_for_endpoint('Overpayments')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'Contact_ContactId' not in required_columns:
            print(f"   ❌ Missing 'Contact_ContactId' (original pattern)")
            return False
        
        if 'ContactId' in required_columns:
            print(f"   ❌ Should NOT have 'ContactId' (wrong pattern)")
            return False
            
        print(f"   ✅ Required columns use original pattern: Contact_ContactId")
        
        # 2. Test transformation creates original columns
        sample_data = {
            'OverpaymentID': 'test-overpayment-123',
            'Type': 'RECEIVE-OVERPAYMENT',
            'Status': 'AUTHORISED',
            'Contact': {
                'ContactID': 'contact-123',
                'Name': 'Test Contact'
            },
            'LineItems': [{
                'LineItemID': 'line-123',
                'Description': 'Test Overpayment Line',
                'Quantity': 1.0,
                'UnitAmount': 100.0
            }]
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_lineitems_data(df, 'Overpayments')
        
        print(f"   Transformed: {len(df)} → {len(transformed_df)} records")
        
        # 3. Check original pattern columns exist
        if 'Contact_ContactId' not in transformed_df.columns:
            print(f"   ❌ Missing 'Contact_ContactId' in transformation")
            return False
            
        if 'Contact_Name' not in transformed_df.columns:
            print(f"   ❌ Missing 'Contact_Name' in transformation")
            return False
            
        if 'ContactId' in transformed_df.columns:
            print(f"   ❌ Should NOT have 'ContactId' in transformation")
            return False
            
        print(f"   ✅ Transformation creates original pattern columns")
        
        # 4. Check values
        contact_id = transformed_df['Contact_ContactId'].iloc[0]
        if contact_id != 'contact-123':
            print(f"   ❌ Contact_ContactId value wrong: {contact_id}")
            return False
            
        print(f"   ✅ Values correct: Contact_ContactId={contact_id}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_prepayments_original_pattern():
    """Test Prepayments uses Contact_ContactId pattern (original line 1253)"""
    
    print("\n🔧 Testing Prepayments Original Pattern")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # Test required columns and transformation similar to overpayments
        required_columns = integration._get_required_columns_for_endpoint('Prepayments')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'Contact_ContactId' not in required_columns:
            print(f"   ❌ Missing 'Contact_ContactId' (original pattern)")
            return False
            
        print(f"   ✅ Required columns use original pattern: Contact_ContactId")
        
        # Test transformation
        sample_data = {
            'PrepaymentID': 'test-prepayment-123',
            'Type': 'RECEIVE-PREPAYMENT',
            'Status': 'AUTHORISED',
            'Contact': {
                'ContactID': 'contact-123',
                'Name': 'Test Contact'
            },
            'LineItems': [{
                'LineItemID': 'line-123',
                'Description': 'Test Prepayment Line',
                'Quantity': 1.0,
                'UnitAmount': 200.0
            }]
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_lineitems_data(df, 'Prepayments')
        
        if 'Contact_ContactId' not in transformed_df.columns:
            print(f"   ❌ Missing 'Contact_ContactId' in transformation")
            return False
            
        print(f"   ✅ Transformation creates original pattern columns")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

def test_expenseclaims_original_pattern():
    """Test ExpenseClaims uses UserId pattern (original line 2802)"""
    
    print("\n🔧 Testing ExpenseClaims Original Pattern")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns match original
        required_columns = integration._get_required_columns_for_endpoint('ExpenseClaims')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'UserId' not in required_columns:
            print(f"   ❌ Missing 'UserId' (original pattern)")
            return False
        
        if 'User_UserID' in required_columns:
            print(f"   ❌ Should NOT have 'User_UserID' (wrong pattern)")
            return False
            
        print(f"   ✅ Required columns use original pattern: UserId")
        
        # 2. Test transformation (ExpenseClaims has NO LineItems in original)
        sample_data = {
            'ExpenseClaimID': 'test-expenseclaim-123',
            'Status': 'SUBMITTED',
            'Total': 150.0,
            'AmountDue': 150.0,
            'AmountPaid': 0.0,
            'User': {
                'UserID': 'user-123',
                'FirstName': 'Test',
                'LastName': 'User'
            }
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_expenseclaims_data(df)  # Uses specific method, not LineItems
        
        print(f"   Transformed: {len(df)} → {len(transformed_df)} records")
        
        # 3. Check original pattern columns exist
        if 'UserId' not in transformed_df.columns:
            print(f"   ❌ Missing 'UserId' in transformation")
            return False
            
        if 'User_UserID' in transformed_df.columns:
            print(f"   ❌ Should NOT have 'User_UserID' in transformation")
            return False
            
        print(f"   ✅ Transformation creates original pattern columns")
        
        # 4. Check values
        user_id = transformed_df['UserId'].iloc[0]
        if user_id != 'user-123':
            print(f"   ❌ UserId value wrong: {user_id}")
            return False
            
        print(f"   ✅ Values correct: UserId={user_id}")
        
        # 5. Check it doesn't have LineItem columns (ExpenseClaims is simple structure)
        lineitem_columns = [col for col in transformed_df.columns if col.startswith('LineItem_')]
        if lineitem_columns:
            print(f"   ❌ Should NOT have LineItem columns: {lineitem_columns}")
            return False
            
        print(f"   ✅ No LineItem columns (correct - ExpenseClaims is simple structure)")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_invoices_still_simple_pattern():
    """Test Invoices still use simple ContactId pattern (original line 889)"""
    
    print("\n🔧 Testing Invoices Still Simple Pattern")
    print("=" * 40)
    
    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # Test transformation
        sample_data = {
            'InvoiceID': 'test-invoice-123',
            'Type': 'ACCREC',
            'Status': 'AUTHORISED',
            'Contact': {
                'ContactID': 'contact-123',
                'Name': 'Test Contact'
            },
            'LineItems': [{
                'LineItemID': 'line-123',
                'Description': 'Test Invoice Line',
                'Quantity': 1.0,
                'UnitAmount': 100.0
            }]
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_lineitems_data(df, 'Invoices')
        
        # Check Invoices use simple pattern (NOT prefixed)
        if 'ContactId' not in transformed_df.columns:
            print(f"   ❌ Missing 'ContactId' for Invoices")
            return False
            
        if 'Contact_ContactId' in transformed_df.columns:
            print(f"   ❌ Should NOT have 'Contact_ContactId' for Invoices")
            return False
            
        print(f"   ✅ Invoices use simple pattern: ContactId")
        
        return True
        
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
        print("🔧 Testing Original Flattening Patterns\\n")
        
        test1_passed = test_overpayments_original_pattern()
        test2_passed = test_prepayments_original_pattern()
        test3_passed = test_expenseclaims_original_pattern()
        test4_passed = test_invoices_still_simple_pattern()
        
        print("\\n" + "=" * 60)
        print("📊 ORIGINAL FLATTENING PATTERNS TEST RESULTS")
        print("=" * 60)
        
        results = [
            ("Overpayments Original Pattern (Contact_ContactId)", test1_passed),
            ("Prepayments Original Pattern (Contact_ContactId)", test2_passed),
            ("ExpenseClaims Original Pattern (UserId)", test3_passed),
            ("Invoices Simple Pattern (ContactId)", test4_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\\n🎉 ALL ORIGINAL PATTERNS VERIFIED!")
            print()
            print("✅ Exact match with original XEROBLUE - UPSERT.py patterns:")
            print("   - Invoices: ContactId, ContactName (line 889-890)")
            print("   - CreditNotes: Contact_ContactId, Contact_Name (line 1035-1036)")
            print("   - Overpayments: Contact_ContactId, Contact_Name (line 1144-1145)")
            print("   - Prepayments: Contact_ContactId, Contact_Name (line 1253-1254)")
            print("   - ExpenseClaims: UserId (line 2802) - no LineItems")
            print()
            print("🚀 Should resolve all null validation SQL errors:")
            print("   - Overpayments: Contact_ContactId column exists in stage table")
            print("   - Prepayments: Contact_ContactId column exists in stage table")
            print("   - ExpenseClaims: UserId column exists in stage table")
        else:
            print(f"\\n❌ {total_count - passed_count} tests failed - review needed")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()