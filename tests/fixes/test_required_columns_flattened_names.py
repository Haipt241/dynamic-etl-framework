#!/usr/bin/env python3
"""
Test Required Columns Use Flattened Names

This test verifies that the required columns definitions use the correct 
flattened column names that match the actual stage table schemas.

Fixes the errors:
- "Unknown column 'Contact' in 'where clause'" → should be 'ContactId'
- "Unknown column 'BankAccount' in 'where clause'" → should be 'BankAccount_AccountId'  
- "Unknown column 'User' in 'where clause'" → should be 'User_UserID'

These errors occurred in null validation queries for Overpayments, Prepayments, 
BankTransactions, and ExpenseClaims endpoints.
"""

import os
import sys

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')

def test_overpayments_required_columns():
    """Test that Overpayments required columns use flattened names"""
    
    print("🔧 Testing Overpayments Required Columns")
    print("=" * 40)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        
        required_columns = integration._get_required_columns_for_endpoint('Overpayments')
        
        print(f"   Required columns: {list(required_columns.keys())}")
        
        # Check that old problematic column is NOT present
        if 'Contact' in required_columns:
            print(f"   ❌ Still has problematic 'Contact' column")
            return False
        else:
            print(f"   ✅ No 'Contact' column (good)")
        
        # Check that correct flattened columns ARE present
        expected_columns = ['OverpaymentId', 'Type', 'Status', 'ContactId']
        missing_columns = [col for col in expected_columns if col not in required_columns]
        
        if missing_columns:
            print(f"   ❌ Missing expected columns: {missing_columns}")
            return False
        else:
            print(f"   ✅ All expected flattened columns present: {expected_columns}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

def test_prepayments_required_columns():
    """Test that Prepayments required columns use flattened names"""
    
    print("\n🔧 Testing Prepayments Required Columns")
    print("=" * 40)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        
        required_columns = integration._get_required_columns_for_endpoint('Prepayments')
        
        print(f"   Required columns: {list(required_columns.keys())}")
        
        # Check that old problematic column is NOT present
        if 'Contact' in required_columns:
            print(f"   ❌ Still has problematic 'Contact' column")
            return False
        else:
            print(f"   ✅ No 'Contact' column (good)")
        
        # Check that correct flattened columns ARE present
        expected_columns = ['PrepaymentId', 'Type', 'Status', 'ContactId']
        missing_columns = [col for col in expected_columns if col not in required_columns]
        
        if missing_columns:
            print(f"   ❌ Missing expected columns: {missing_columns}")
            return False
        else:
            print(f"   ✅ All expected flattened columns present: {expected_columns}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

def test_banktransactions_required_columns():
    """Test that BankTransactions required columns use flattened names"""
    
    print("\n🔧 Testing BankTransactions Required Columns")
    print("=" * 45)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        
        required_columns = integration._get_required_columns_for_endpoint('BankTransactions')
        
        print(f"   Required columns: {list(required_columns.keys())}")
        
        # Check that old problematic column is NOT present
        if 'BankAccount' in required_columns:
            print(f"   ❌ Still has problematic 'BankAccount' column")
            return False
        else:
            print(f"   ✅ No 'BankAccount' column (good)")
        
        # Check that correct flattened columns ARE present
        expected_columns = ['BankTransactionId', 'Type', 'Status', 'BankAccount_AccountId']
        missing_columns = [col for col in expected_columns if col not in required_columns]
        
        if missing_columns:
            print(f"   ❌ Missing expected columns: {missing_columns}")
            return False
        else:
            print(f"   ✅ All expected flattened columns present: {expected_columns}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

def test_expenseclaims_required_columns():
    """Test that ExpenseClaims required columns use flattened names"""
    
    print("\n🔧 Testing ExpenseClaims Required Columns")
    print("=" * 40)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        
        required_columns = integration._get_required_columns_for_endpoint('ExpenseClaims')
        
        print(f"   Required columns: {list(required_columns.keys())}")
        
        # Check that old problematic column is NOT present
        if 'User' in required_columns:
            print(f"   ❌ Still has problematic 'User' column")
            return False
        else:
            print(f"   ✅ No 'User' column (good)")
        
        # Check that correct flattened columns ARE present
        expected_columns = ['ExpenseClaimID', 'Status', 'User_UserID']
        missing_columns = [col for col in expected_columns if col not in required_columns]
        
        if missing_columns:
            print(f"   ❌ Missing expected columns: {missing_columns}")
            return False
        else:
            print(f"   ✅ All expected flattened columns present: {expected_columns}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        return False

def test_all_problematic_endpoints():
    """Test all endpoints that had null validation errors"""
    
    print("\n🔧 Testing All Problematic Endpoints")
    print("=" * 40)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        integration = XeroblueIntegration.__new__(XeroblueIntegration)
        integration.config = {}
        
        # Test all problematic endpoints
        problematic_columns = {
            'Overpayments': ['Contact'],
            'Prepayments': ['Contact'], 
            'BankTransactions': ['BankAccount'],
            'ExpenseClaims': ['User']
        }
        
        all_passed = True
        
        for endpoint, bad_columns in problematic_columns.items():
            required_columns = integration._get_required_columns_for_endpoint(endpoint)
            
            for bad_column in bad_columns:
                if bad_column in required_columns:
                    print(f"   ❌ {endpoint} still has problematic '{bad_column}' column")
                    all_passed = False
                else:
                    print(f"   ✅ {endpoint} no longer has '{bad_column}' column")
        
        return all_passed
        
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
        print("🔧 Testing Required Columns Use Flattened Names\n")
        
        test1_passed = test_overpayments_required_columns()
        test2_passed = test_prepayments_required_columns()
        test3_passed = test_banktransactions_required_columns()
        test4_passed = test_expenseclaims_required_columns()
        test5_passed = test_all_problematic_endpoints()
        
        print("\n" + "=" * 60)
        print("📊 REQUIRED COLUMNS FLATTENED NAMES TEST RESULTS")
        print("=" * 60)
        
        results = [
            ("Overpayments Required Columns", test1_passed),
            ("Prepayments Required Columns", test2_passed),
            ("BankTransactions Required Columns", test3_passed),
            ("ExpenseClaims Required Columns", test4_passed),
            ("All Problematic Endpoints", test5_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\n🎉 ALL REQUIRED COLUMNS FIXED!")
            print()
            print("✅ Overpayments: Contact → ContactId")
            print("✅ Prepayments: Contact → ContactId")
            print("✅ BankTransactions: BankAccount → BankAccount_AccountId")
            print("✅ ExpenseClaims: User → User_UserID")
            print("✅ All ID columns use flattened names (OverpaymentId, PrepaymentId, BankTransactionId)")
            print()
            print("🚀 Should resolve null validation SQL errors:")
            print("   - 'Unknown column Contact in where clause'")
            print("   - 'Unknown column BankAccount in where clause'")
            print("   - 'Unknown column User in where clause'")
        else:
            print(f"\n❌ {total_count - passed_count} tests failed - review needed")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()