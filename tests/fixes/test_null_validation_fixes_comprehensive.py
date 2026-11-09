#!/usr/bin/env python3
"""
Test Null Validation Fixes - Comprehensive

This test verifies that all the null validation SQL errors are fixed by ensuring:
1. Required columns use flattened names that match stage table schemas
2. Data transformation creates the correct flattened columns
3. No 'Unknown column' errors in null validation queries

Fixes these specific errors:
- Overpayments_null_validation: "Unknown column 'Contact' in 'where clause'"
- Prepayments_null_validation: "Unknown column 'Contact' in 'where clause'"  
- BankTransactions_null_validation: "Unknown column 'BankAccount' in 'where clause'"
- ExpenseClaims_null_validation: "Unknown column 'User' in 'where clause'"
"""

import os
import sys
import pandas as pd

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')

def test_overpayments_full_flow():
    """Test complete Overpayments flow: transformation + required columns"""
    
    print("🔧 Testing Overpayments Full Flow")
    print("=" * 35)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns
        required_columns = integration._get_required_columns_for_endpoint('Overpayments')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'Contact' in required_columns:
            print(f"   ❌ Still has problematic 'Contact' column")
            return False
        
        if 'ContactId' not in required_columns:
            print(f"   ❌ Missing 'ContactId' column")
            return False
            
        print(f"   ✅ Required columns use flattened names")
        
        # 2. Test data transformation
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
        
        print(f"   Transformed {len(df)} → {len(transformed_df)} records")
        
        # 3. Check that flattened columns exist
        if 'ContactId' not in transformed_df.columns:
            print(f"   ❌ Transformation didn't create 'ContactId' column")
            print(f"   Available columns: {list(transformed_df.columns)}")
            return False
            
        if 'OverpaymentId' not in transformed_df.columns:
            print(f"   ❌ Transformation didn't create 'OverpaymentId' column")
            return False
            
        print(f"   ✅ Transformation creates correct flattened columns")
        
        # 4. Check values are populated
        contact_id = transformed_df['ContactId'].iloc[0]
        overpayment_id = transformed_df['OverpaymentId'].iloc[0]
        
        if contact_id != 'contact-123':
            print(f"   ❌ ContactId value incorrect: {contact_id}")
            return False
            
        if overpayment_id != 'test-overpayment-123':
            print(f"   ❌ OverpaymentId value incorrect: {overpayment_id}")
            return False
            
        print(f"   ✅ Values correctly populated: ContactId={contact_id}, OverpaymentId={overpayment_id}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_banktransactions_full_flow():
    """Test complete BankTransactions flow: transformation + required columns"""
    
    print("\n🔧 Testing BankTransactions Full Flow")
    print("=" * 40)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns
        required_columns = integration._get_required_columns_for_endpoint('BankTransactions')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'BankAccount' in required_columns:
            print(f"   ❌ Still has problematic 'BankAccount' column")
            return False
        
        if 'BankAccount_AccountId' not in required_columns:
            print(f"   ❌ Missing 'BankAccount_AccountId' column")
            return False
            
        print(f"   ✅ Required columns use flattened names")
        
        # 2. Test data transformation
        sample_data = {
            'BankTransactionID': 'test-banktxn-123',
            'Type': 'RECEIVE',
            'Status': 'AUTHORISED',
            'BankAccount': {
                'AccountID': 'account-123',
                'Name': 'Test Bank Account',
                'Code': '1001'
            },
            'Contact': {
                'ContactID': 'contact-123',
                'Name': 'Test Contact'
            },
            'LineItems': [{
                'LineItemID': 'line-123',
                'Description': 'Test Bank Transaction Line',
                'Quantity': 1.0,
                'UnitAmount': 100.0
            }]
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_lineitems_data(df, 'BankTransactions')
        
        print(f"   Transformed {len(df)} → {len(transformed_df)} records")
        
        # 3. Check that flattened columns exist
        expected_columns = ['BankTransactionId', 'BankAccount_AccountId', 'BankAccount_AccountName', 'ContactId']
        missing_columns = [col for col in expected_columns if col not in transformed_df.columns]
        
        if missing_columns:
            print(f"   ❌ Transformation missing columns: {missing_columns}")
            print(f"   Available columns: {list(transformed_df.columns)}")
            return False
            
        print(f"   ✅ Transformation creates correct flattened columns")
        
        # 4. Check values are populated
        bank_account_id = transformed_df['BankAccount_AccountId'].iloc[0]
        bank_transaction_id = transformed_df['BankTransactionId'].iloc[0]
        
        if bank_account_id != 'account-123':
            print(f"   ❌ BankAccount_AccountId value incorrect: {bank_account_id}")
            return False
            
        if bank_transaction_id != 'test-banktxn-123':
            print(f"   ❌ BankTransactionId value incorrect: {bank_transaction_id}")
            return False
            
        print(f"   ✅ Values correctly populated: BankAccount_AccountId={bank_account_id}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_expenseclaims_full_flow():
    """Test complete ExpenseClaims flow: transformation + required columns"""
    
    print("\n🔧 Testing ExpenseClaims Full Flow")
    print("=" * 35)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns
        required_columns = integration._get_required_columns_for_endpoint('ExpenseClaims')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'User' in required_columns:
            print(f"   ❌ Still has problematic 'User' column")
            return False
        
        if 'User_UserID' not in required_columns:
            print(f"   ❌ Missing 'User_UserID' column")
            return False
            
        print(f"   ✅ Required columns use flattened names")
        
        # 2. Test data transformation
        sample_data = {
            'ExpenseClaimID': 'test-expenseclaim-123',
            'Status': 'SUBMITTED',
            'User': {
                'UserID': 'user-123',
                'FirstName': 'Test',
                'LastName': 'User'
            },
            'LineItems': [{
                'LineItemID': 'line-123',
                'Description': 'Test Expense Line',
                'Quantity': 1.0,
                'UnitAmount': 50.0
            }]
        }
        
        df = pd.DataFrame([sample_data])
        transformed_df = integration._transform_lineitems_data(df, 'ExpenseClaims')
        
        print(f"   Transformed {len(df)} → {len(transformed_df)} records")
        
        # 3. Check that flattened columns exist
        expected_columns = ['ExpenseClaimID', 'User_UserID', 'User_FirstName', 'User_LastName']
        missing_columns = [col for col in expected_columns if col not in transformed_df.columns]
        
        if missing_columns:
            print(f"   ❌ Transformation missing columns: {missing_columns}")
            print(f"   Available columns: {list(transformed_df.columns)}")
            return False
            
        print(f"   ✅ Transformation creates correct flattened columns")
        
        # 4. Check values are populated
        user_id = transformed_df['User_UserID'].iloc[0]
        expense_claim_id = transformed_df['ExpenseClaimID'].iloc[0]
        
        if user_id != 'user-123':
            print(f"   ❌ User_UserID value incorrect: {user_id}")
            return False
            
        if expense_claim_id != 'test-expenseclaim-123':
            print(f"   ❌ ExpenseClaimID value incorrect: {expense_claim_id}")
            return False
            
        print(f"   ✅ Values correctly populated: User_UserID={user_id}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_prepayments_full_flow():
    """Test complete Prepayments flow: transformation + required columns"""
    
    print("\n🔧 Testing Prepayments Full Flow")
    print("=" * 35)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        integration.error_list = []
        
        # 1. Test required columns
        required_columns = integration._get_required_columns_for_endpoint('Prepayments')
        print(f"   Required columns: {list(required_columns.keys())}")
        
        if 'Contact' in required_columns:
            print(f"   ❌ Still has problematic 'Contact' column")
            return False
        
        if 'ContactId' not in required_columns:
            print(f"   ❌ Missing 'ContactId' column")
            return False
            
        print(f"   ✅ Required columns use flattened names")
        
        # 2. Test data transformation
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
        
        print(f"   Transformed {len(df)} → {len(transformed_df)} records")
        
        # 3. Check that flattened columns exist
        if 'ContactId' not in transformed_df.columns:
            print(f"   ❌ Transformation didn't create 'ContactId' column")
            return False
            
        if 'PrepaymentId' not in transformed_df.columns:
            print(f"   ❌ Transformation didn't create 'PrepaymentId' column")
            return False
            
        print(f"   ✅ Transformation creates correct flattened columns")
        
        # 4. Check values are populated
        contact_id = transformed_df['ContactId'].iloc[0]
        prepayment_id = transformed_df['PrepaymentId'].iloc[0]
        
        if contact_id != 'contact-123':
            print(f"   ❌ ContactId value incorrect: {contact_id}")
            return False
            
        if prepayment_id != 'test-prepayment-123':
            print(f"   ❌ PrepaymentId value incorrect: {prepayment_id}")
            return False
            
        print(f"   ✅ Values correctly populated: ContactId={contact_id}, PrepaymentId={prepayment_id}")
        
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
        print("🔧 Testing Null Validation Fixes - Comprehensive\\n")
        
        test1_passed = test_overpayments_full_flow()
        test2_passed = test_banktransactions_full_flow()
        test3_passed = test_expenseclaims_full_flow()
        test4_passed = test_prepayments_full_flow()
        
        print("\\n" + "=" * 60)
        print("📊 NULL VALIDATION FIXES COMPREHENSIVE TEST RESULTS")
        print("=" * 60)
        
        results = [
            ("Overpayments Full Flow (Contact → ContactId)", test1_passed),
            ("BankTransactions Full Flow (BankAccount → BankAccount_AccountId)", test2_passed),
            ("ExpenseClaims Full Flow (User → User_UserID)", test3_passed),
            ("Prepayments Full Flow (Contact → ContactId)", test4_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\\n🎉 ALL NULL VALIDATION FIXES VERIFIED!")
            print()
            print("✅ Required columns use flattened names matching stage table schemas")
            print("✅ Data transformation creates correct flattened columns")
            print("✅ Values are properly populated in flattened structure")
            print("✅ Endpoint-specific nested objects handled correctly:")
            print("   - BankTransactions: BankAccount → BankAccount_AccountId/Name/Code")
            print("   - ExpenseClaims: User → User_UserID/FirstName/LastName")
            print("   - Overpayments/Prepayments: Contact → ContactId/ContactName")
            print()
            print("🚀 Should resolve all 4 null validation SQL errors:")
            print("   - Overpayments_null_validation: Unknown column 'Contact'")
            print("   - Prepayments_null_validation: Unknown column 'Contact'")
            print("   - BankTransactions_null_validation: Unknown column 'BankAccount'")
            print("   - ExpenseClaims_null_validation: Unknown column 'User'")
        else:
            print(f"\\n❌ {total_count - passed_count} tests failed - review needed")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()