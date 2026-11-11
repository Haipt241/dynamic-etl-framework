#!/usr/bin/env python3
"""
Test script to verify column mappings implementation in xeroblue_integration.py
Validates that proper column mappings are being applied per endpoint following original XEROBLUE - UPSERT.py patterns
"""

import pandas as pd
import sys
import os

# Add the project root to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

try:
    from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
except ImportError:
    print("❌ Could not import XeroblueIntegration. Ensure the module is in the correct location.")
    sys.exit(1)

def test_accounts_transformation():
    """Test Accounts endpoint column mapping"""
    print("🧪 Testing Accounts transformation...")
    
    # Sample Accounts data matching Xero API response
    sample_data = pd.DataFrame([
        {
            'AccountID': 'ac123-456',
            'Code': '200',
            'Name': 'Sales',
            'Status': 'ACTIVE',
            'Type': 'REVENUE',
            'TaxType': 'OUTPUT',
            'Class': 'REVENUE',
            'Description': 'Sales revenue account',
            'SystemAccount': 'DEBTORS',
            'EnablePaymentsToAccount': True,
            'ShowInExpenseClaims': False,
            'BankAccountNumber': '12345',
            'BankAccountType': 'BANK',
            'CurrencyCode': 'AUD',
            'ReportingCode': 'REV',
            'ReportingCodeName': 'Revenue',
            'HasAttachments': False,
            'UpdatedDateUTC': '2024-06-26T10:30:00Z',
            'AddToWatchlist': False,
        }
    ])
    
    # Create integration instance
    integration = XeroblueIntegration({})
    
    # Transform the data
    transformed_data = integration._transform_accounts_data(sample_data)
    
    # Verify key fields are present and correctly mapped
    expected_columns = [
        'AccountID', 'Code', 'Name', 'Status', 'Type', 'TaxType', 'Class',
        'Description', 'SystemAccount', 'EnablePaymentsToAccount', 'ShowInExpenseClaims',
        'BankAccountNumber', 'BankAccountType', 'CurrencyCode', 'ReportingCode',
        'ReportingCodeName', 'HasAttachments', 'UpdatedDateUTC', 'AddToWatchlist'
    ]
    
    missing_columns = set(expected_columns) - set(transformed_data.columns)
    if missing_columns:
        print(f"❌ Missing columns in Accounts transformation: {missing_columns}")
        return False
    
    # Verify data types
    first_row = transformed_data.iloc[0]
    if not isinstance(first_row['EnablePaymentsToAccount'], bool):
        print("❌ EnablePaymentsToAccount should be boolean")
        return False
    
    if not isinstance(first_row['ShowInExpenseClaims'], bool):
        print("❌ ShowInExpenseClaims should be boolean") 
        return False
        
    print("✅ Accounts transformation successful")
    return True

def test_invoices_transformation():
    """Test Invoices endpoint column mapping with LineItems"""
    print("🧪 Testing Invoices transformation with LineItems...")
    
    # Sample Invoices data with LineItems
    sample_data = pd.DataFrame([
        {
            'InvoiceID': 'inv123-456',
            'Type': 'ACCREC',
            'Contact': {'ContactID': 'cont123', 'Name': 'Test Customer'},
            'DateString': '2024-06-26',
            'DueDateString': '2024-07-26',
            'LineAmountTypes': 'Exclusive',
            'InvoiceNumber': 'INV-001',
            'Reference': 'Ref123',
            'BrandingThemeID': 'brand123',
            'Url': 'https://example.com/invoice',
            'CurrencyCode': 'AUD',
            'CurrencyRate': 1.0,
            'Status': 'AUTHORISED',
            'SentToContact': True,
            'SubTotal': 100.0,
            'TotalTax': 10.0,
            'Total': 110.0,
            'TotalDiscount': 0.0,
            'HasAttachments': False,
            'AmountDue': 110.0,
            'AmountPaid': 0.0,
            'CISDeduction': 0.0,
            'AmountCredited': 0.0,
            'UpdatedDateUTC': '2024-06-26T10:30:00Z',
            'RepeatingInvoiceID': '',
            'LineItems': [
                {
                    'LineItemID': 'li123',
                    'Description': 'Test Product',
                    'Quantity': 1.0,
                    'UnitAmount': 100.0,
                    'ItemCode': 'PROD001',
                    'AccountCode': '200',
                    'TaxType': 'OUTPUT',
                    'TaxAmount': 10.0,
                    'LineAmount': 100.0,
                    'DiscountRate': 0.0,
                    'DiscountAmount': 0.0,
                    'Tracking': [
                        {
                            'TrackingCategoryID': 'tc123',
                            'Name': 'Department',
                            'TrackingOptionID': 'to123',
                            'Option': 'Sales'
                        }
                    ]
                }
            ],
            'CreditNotes': [{'CreditNoteID': 'cn123'}],
            'Prepayments': [{'PrepaymentID': 'pp123'}],
            'Payments': [{'PaymentID': 'pay123'}],
            'Overpayments': [{'OverpaymentID': 'op123'}]
        }
    ])
    
    # Create integration instance
    integration = XeroblueIntegration({})
    
    # Transform the data
    transformed_data = integration._transform_lineitems_data(sample_data, 'Invoices')
    
    # Verify key fields are present
    expected_columns = [
        'Id', 'InvoiceId', 'Type', 'ContactId', 'ContactName', 'Date', 'DueDate',
        'LineAmountTypes', 'InvoiceNumber', 'Reference', 'Status', 'SubTotal', 'Total',
        'LineItem_LineItemId', 'LineItem_Description', 'LineItem_Quantity', 'LineItem_UnitAmount',
        'LineItem_AccountCode', 'LineItem_TaxType', 'LineItem_TaxAmount', 'LineItem_LineAmount',
        'LineItem_TrackingCategory1_CategoryId', 'LineItem_TrackingCategory1_CategoryName',
        'LineItem_TrackingCategory1_OptionID', 'LineItem_TrackingCategory1_OptionName',
        'CreditNoteIds', 'PrepaymentIds', 'PaymentIds', 'OverpaymentIds'
    ]
    
    missing_columns = set(expected_columns) - set(transformed_data.columns)
    if missing_columns:
        print(f"❌ Missing columns in Invoices transformation: {missing_columns}")
        return False
    
    # Verify LineItem was processed
    if len(transformed_data) != 1:
        print(f"❌ Expected 1 row (1 LineItem), got {len(transformed_data)}")
        return False
    
    first_row = transformed_data.iloc[0]
    
    # Verify LineItem fields
    if first_row['LineItem_Description'] != 'Test Product':
        print("❌ LineItem_Description mapping failed")
        return False
    
    # Verify tracking categories
    if first_row['LineItem_TrackingCategory1_CategoryName'] != 'Department':
        print("❌ Tracking category mapping failed")
        return False
    
    # Verify concatenated IDs
    if first_row['CreditNoteIds'] != 'cn123':
        print("❌ CreditNoteIds concatenation failed")
        return False
        
    print("✅ Invoices transformation successful")
    return True

def test_overpayments_transformation():
    """Test Overpayments endpoint column mapping with Allocations"""
    print("🧪 Testing Overpayments transformation with Allocations...")
    
    # Sample Overpayments data with LineItems and Allocations
    sample_data = pd.DataFrame([
        {
            'OverpaymentID': 'op123-456',
            'DateString': '2024-06-26',
            'Type': 'RECEIVE-OVERPAYMENT',
            'RemainingCredit': 50.0,
            'Contact': {'ContactID': 'cont123', 'Name': 'Test Customer'},
            'Status': 'AUTHORISED',
            'SubTotal': 100.0,
            'TotalTax': 10.0,
            'Total': 110.0,
            'LineAmountTypes': 'Exclusive',
            'CurrencyCode': 'AUD',
            'CurrencyRate': 1.0,
            'UpdatedDateUTC': '2024-06-26T10:30:00Z',
            'HasAttachments': False,
            'Payments': '',
            'LineItems': [
                {
                    'LineItemID': 'li123',
                    'Description': 'Overpayment item',
                    'Quantity': 1.0,
                    'UnitAmount': 100.0,
                    'ItemCode': 'OVER001',
                    'AccountCode': '200',
                    'TaxType': 'OUTPUT',
                    'TaxAmount': 10.0,
                    'LineAmount': 100.0,
                    'DiscountRate': 0.0
                }
            ],
            'Allocations': [
                {
                    'Amount': 60.0,
                    'Date': '2024-06-26',
                    'Invoice': {
                        'InvoiceID': 'inv123',
                        'InvoiceNumber': 'INV-001'
                    }
                }
            ]
        }
    ])
    
    # Create integration instance
    integration = XeroblueIntegration({})
    
    # Transform the data
    transformed_data = integration._transform_lineitems_data(sample_data, 'Overpayments')
    
    # Verify key fields are present
    expected_columns = [
        'Id', 'OverpaymentId', 'Type', 'Contact_ContactId', 'Contact_Name',
        'Date', 'Status', 'SubTotal', 'Total', 'RemainingCredit',
        'LineItem_LineItemId', 'LineItem_Description', 'LineItem_Quantity',
        'Allocation1_AppliedAmount', 'Allocation1_Date', 'Allocation1_InvoiceId', 'Allocation1_InvoiceNumber'
    ]
    
    missing_columns = set(expected_columns) - set(transformed_data.columns)
    if missing_columns:
        print(f"❌ Missing columns in Overpayments transformation: {missing_columns}")
        return False
    
    first_row = transformed_data.iloc[0]
    
    # Verify Contact flattening
    if first_row['Contact_ContactId'] != 'cont123':
        print("❌ Contact_ContactId mapping failed")
        return False
    
    # Verify Allocations processing
    if first_row['Allocation1_AppliedAmount'] != 60.0:
        print("❌ Allocation1_AppliedAmount mapping failed")
        return False
    
    if first_row['Allocation1_InvoiceId'] != 'inv123':
        print("❌ Allocation1_InvoiceId mapping failed")
        return False
        
    print("✅ Overpayments transformation successful")
    return True

def test_taxrates_transformation():
    """Test TaxRates endpoint column mapping"""
    print("🧪 Testing TaxRates transformation...")
    
    # Sample TaxRates data with TaxComponents
    sample_data = pd.DataFrame([
        {
            'Id': 'tax123',
            'TaxType': 'OUTPUT',
            'Name': 'GST on Income',
            'Status': 'ACTIVE',
            'ReportTaxType': 'OUTPUT',
            'CanApplyToAssets': True,
            'CanApplyToEquity': False,
            'CanApplyToExpenses': False,
            'CanApplyToLiabilities': False,
            'CanApplyToRevenue': True,
            'DisplayTaxRate': 10.0,
            'EffectiveRate': 10.0,
            'TaxComponents': [
                {
                    'Name': 'GST',
                    'Rate': 10.0,
                    'IsNonRecoverable': False,
                    'IsCompound': False,
                    'Aggregate': 'SUM'
                }
            ]
        }
    ])
    
    # Create integration instance
    integration = XeroblueIntegration({})
    
    # Transform the data
    transformed_data = integration._transform_taxrates_data(sample_data)
    
    # Verify key fields are present
    expected_columns = [
        'Id', 'TaxType', 'Name', 'Status', 'ReportTaxType',
        'CanApplyToAssets', 'CanApplyToEquity', 'CanApplyToExpenses', 
        'CanApplyToLiabilities', 'CanApplyToRevenue', 'DisplayTaxRate', 'EffectiveRate',
        'TaxComponent_Name', 'TaxComponent_Rate', 'TaxComponents_IsNonRecoverable',
        'TaxComponent_IsCompound', 'TaxComponentAggregate'
    ]
    
    missing_columns = set(expected_columns) - set(transformed_data.columns)
    if missing_columns:
        print(f"❌ Missing columns in TaxRates transformation: {missing_columns}")
        return False
    
    first_row = transformed_data.iloc[0]
    
    # Verify TaxComponent flattening
    if first_row['TaxComponent_Name'] != 'GST':
        print("❌ TaxComponent_Name mapping failed")
        return False
    
    if first_row['TaxComponent_Rate'] != 10.0:
        print("❌ TaxComponent_Rate mapping failed")
        return False
        
    print("✅ TaxRates transformation successful")
    return True

def test_trackingcategories_transformation():
    """Test TrackingCategories endpoint column mapping"""
    print("🧪 Testing TrackingCategories transformation...")
    
    # Sample TrackingCategories data with Options
    sample_data = pd.DataFrame([
        {
            'TrackingCategoryID': 'tc123',
            'Name': 'Department',
            'Status': 'ACTIVE',
            'Options': [
                {
                    'TrackingOptionID': 'to123',
                    'Name': 'Sales',
                    'Status': 'ACTIVE'
                },
                {
                    'TrackingOptionID': 'to124',
                    'Name': 'Marketing',
                    'Status': 'ACTIVE'
                }
            ]
        }
    ])
    
    # Create integration instance
    integration = XeroblueIntegration({})
    
    # Transform the data
    transformed_data = integration._transform_trackingcategories_data(sample_data)
    
    # Verify key fields are present
    expected_columns = [
        'Id', 'TrackingCategoryId', 'Name', 'Status',
        'TrackingOptionId', 'OptionName', 'OptionStatus'
    ]
    
    missing_columns = set(expected_columns) - set(transformed_data.columns)
    if missing_columns:
        print(f"❌ Missing columns in TrackingCategories transformation: {missing_columns}")
        return False
    
    # Should create 2 rows (one per option)
    if len(transformed_data) != 2:
        print(f"❌ Expected 2 rows (2 Options), got {len(transformed_data)}")
        return False
    
    first_row = transformed_data.iloc[0]
    
    # Verify Option flattening
    if first_row['OptionName'] != 'Sales':
        print("❌ OptionName mapping failed")
        return False
    
    if first_row['TrackingOptionId'] != 'to123':
        print("❌ TrackingOptionId mapping failed")
        return False
        
    print("✅ TrackingCategories transformation successful")
    return True

def main():
    """Run all column mapping tests"""
    print("🔍 Testing Column Mappings Implementation")
    print("="*50)
    
    tests = [
        test_accounts_transformation,
        test_invoices_transformation,
        test_overpayments_transformation,
        test_taxrates_transformation,
        test_trackingcategories_transformation
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
            else:
                print()
        except Exception as e:
            print(f"❌ Test failed with exception: {str(e)}")
            import traceback
            traceback.print_exc()
        print()
    
    print("="*50)
    print(f"📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All column mapping tests passed!")
        print("✅ Column mappings are correctly implemented per endpoint")
        return True
    else:
        print("❌ Some column mapping tests failed")
        print("🔧 Please review the failed transformations")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)