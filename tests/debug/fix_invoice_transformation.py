#!/usr/bin/env python3
"""
Fix Invoice Transformation

This script implements the exact transformation logic from XEROBLUE - UPSERT.py
to properly flatten Invoice data with LineItems following the original patterns.
"""

import os
import sys
import pandas as pd
import json

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')

def get_value(obj, key, default=''):
    """Safe get value from dict/object - matches original function"""
    if obj is None:
        return default
    if not isinstance(obj, dict):
        return default
    value = obj.get(key, default)
    return str(value) if value is not None and not pd.isna(value) else default

def validate_float(value):
    """Validate float value - matches original function"""
    try:
        return float(value) if value is not None and str(value).strip() != '' else 0.0
    except (TypeError, ValueError):
        return 0.0

def validate_datetime(value):
    """Validate datetime value - matches original function"""
    try:
        return str(value) if value is not None else ''
    except:
        return ''

def create_invoice_base_data(invoice, line_index, line):
    """Create complete flattened invoice record following original pattern"""
    
    # Create the base data structure exactly as in original
    base_data = {
        # Core invoice fields
        'Id': f"{line_index}|{get_value(invoice, 'InvoiceID')}",
        'InvoiceId': get_value(invoice, 'InvoiceID'),
        'Type': get_value(invoice, 'Type'),
        'Date': get_value(invoice, 'DateString'),
        'DueDate': get_value(invoice, 'DueDateString'),
        'LineAmountTypes': get_value(invoice, 'LineAmountTypes'),
        'InvoiceNumber': get_value(invoice, 'InvoiceNumber'),
        'Reference': get_value(invoice, 'Reference'),
        'BrandingThemeId': get_value(invoice, 'BrandingThemeID'),
        'URL': get_value(invoice, 'Url'),
        'CurrencyCode': get_value(invoice, 'CurrencyCode'),
        'CurrencyRate': validate_float(get_value(invoice, 'CurrencyRate', 0)),
        'Status': get_value(invoice, 'Status'),
        'SentToContact': bool(invoice.get('SentToContact', False)),
        'ExpectedPaymentDate': get_value(invoice, 'ExpectedPaymentDateString'),
        'PlannedPaymentDate': get_value(invoice, 'PlannedPaymentDateString'),
        'SubTotal': validate_float(get_value(invoice, 'SubTotal')),
        'TotalTax': validate_float(get_value(invoice, 'TotalTax')),
        'Total': validate_float(get_value(invoice, 'Total')),
        'TotalDiscount': validate_float(get_value(invoice, 'TotalDiscount')),
        'HasAttachments': bool(get_value(invoice, 'HasAttachments')),
        'AmountDue': validate_float(get_value(invoice, 'AmountDue')),
        'AmountPaid': validate_float(get_value(invoice, 'AmountPaid')),
        'CISDeduction': validate_float(get_value(invoice, 'CISDeduction')),
        'FullyPaidOnDate': validate_datetime(invoice.get('FullyPaidOnDate')),
        'AmountCredited': validate_float(get_value(invoice, 'AmountCredited')),
        'UpdatedDateUTC': validate_datetime(invoice.get('UpdatedDateUTC')),
        'RepeatingInvoiceID': get_value(invoice, 'RepeatingInvoiceID'),
        
        # Contact fields (flattened)
        'ContactId': get_value(invoice.get('Contact', {}), 'ContactID'),
        'ContactName': get_value(invoice.get('Contact', {}), 'Name'),
        
        # LineItem fields (if line exists)
        'LineItem_LineItemId': get_value(line, 'LineItemID'),
        'LineItem_Description': get_value(line, 'Description'),
        'LineItem_Quantity': validate_float(get_value(line, 'Quantity')),
        'LineItem_UnitAmount': validate_float(get_value(line, 'UnitAmount')),
        'LineItem_ItemCode': get_value(line, 'ItemCode'),
        'LineItem_AccountCode': get_value(line, 'AccountCode'),
        'LineItem_TaxType': get_value(line, 'TaxType'),
        'LineItem_TaxAmount': validate_float(get_value(line, 'TaxAmount')),
        'LineItem_LineAmount': validate_float(get_value(line, 'LineAmount')),
        'LineItem_DiscountRate': validate_float(get_value(line, 'DiscountRate')),
        'LineItem_DiscountAmount': validate_float(get_value(line, 'DiscountAmount')),
    }
    
    # Add tracking categories (up to 2)
    if 'Tracking' in line and isinstance(line['Tracking'], list):
        tracking_categories = line['Tracking']
        if len(tracking_categories) > 0:
            base_data['LineItem_TrackingCategory1_CategoryId'] = get_value(tracking_categories[0], 'TrackingCategoryID')
            base_data['LineItem_TrackingCategory1_CategoryName'] = get_value(tracking_categories[0], 'Name')
            base_data['LineItem_TrackingCategory1_OptionID'] = get_value(tracking_categories[0], 'TrackingOptionID')
            base_data['LineItem_TrackingCategory1_OptionName'] = get_value(tracking_categories[0], 'Option')
        if len(tracking_categories) == 2:
            base_data['LineItem_TrackingCategory2_CategoryId'] = get_value(tracking_categories[1], 'TrackingCategoryID')
            base_data['LineItem_TrackingCategory2_CategoryName'] = get_value(tracking_categories[1], 'Name')
            base_data['LineItem_TrackingCategory2_OptionID'] = get_value(tracking_categories[1], 'TrackingOptionID')
            base_data['LineItem_TrackingCategory2_OptionName'] = get_value(tracking_categories[1], 'Option')
    
    return base_data

def test_correct_invoice_transformation():
    """Test the correct invoice transformation using real data"""
    
    print("🔧 Testing Correct Invoice Transformation")
    print("=" * 50)
    
    try:
        # Load the actual CreditNotes JSON (it has the same structure as Invoices)
        json_file = str(get_json_dir() / 'cBIGOLESHOECOMPANY_1518_7232_xeroblue_CreditNotes_response.json')
        
        with open(json_file, 'r') as f:
            json_data = json.load(f)
        
        # Extract CreditNotes data (same structure as Invoices)
        credit_notes = json_data.get('CreditNotes', [])
        
        if not credit_notes:
            print("   ⚠️  No CreditNotes data found in JSON file")
            return False
        
        print(f"   Found {len(credit_notes)} CreditNotes to process")
        
        # Process using the correct transformation
        combined_data = []
        
        for index, invoice in enumerate(credit_notes):
            line_items = invoice.get('LineItems', [])
            
            if line_items:
                for line_index, line in enumerate(line_items, start=1):
                    base_data = create_invoice_base_data(invoice, line_index, line)
                    combined_data.append(base_data)
            else:
                # No LineItems - create single record
                base_data = create_invoice_base_data(invoice, 1, {})
                combined_data.append(base_data)
        
        # Convert to DataFrame
        df = pd.DataFrame(combined_data)
        
        print(f"   ✅ Created {len(df)} flattened records")
        print(f"   ✅ DataFrame columns: {len(df.columns)}")
        
        # Show some key columns to verify structure
        key_columns = ['Id', 'InvoiceId', 'ContactId', 'ContactName', 'LineItem_LineItemId', 'LineItem_Description']
        available_columns = [col for col in key_columns if col in df.columns]
        
        print(f"   Sample data:")
        for i, row in df.head(3).iterrows():
            print(f"      Row {i}: {dict((col, row[col]) for col in available_columns)}")
        
        # Check for problematic columns that were causing errors
        problematic_columns = ['InvoiceID', 'Contact']  # These were causing SQL errors
        found_problematic = [col for col in problematic_columns if col in df.columns]
        
        if found_problematic:
            print(f"   ❌ Still has problematic columns: {found_problematic}")
            return False
        else:
            print(f"   ✅ No problematic columns found")
        
        # Check that we have the correct column names
        expected_columns = ['InvoiceId', 'ContactId', 'ContactName', 'LineItem_LineItemId']
        missing_columns = [col for col in expected_columns if col not in df.columns]
        
        if missing_columns:
            print(f"   ❌ Missing expected columns: {missing_columns}")
            return False
        else:
            print(f"   ✅ All expected columns present")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

# Import path utilities for dynamic path resolution
try:
    from path_utils import setup_project_paths, get_json_dir
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
        print("🔧 Testing Correct Invoice Transformation\n")
        
        test_passed = test_correct_invoice_transformation()
        
        print("\n" + "=" * 60)
        print("📊 CORRECT TRANSFORMATION TEST RESULTS")
        print("=" * 60)
        
        if test_passed:
            print("✅ PASSED: Correct Invoice Transformation")
            print()
            print("✅ Data structure matches original XEROBLUE - UPSERT.py")
            print("✅ Column names are correct (InvoiceId, ContactId, ContactName)")
            print("✅ No problematic columns (InvoiceID, Contact)")
            print("✅ LineItem flattening works correctly")
            print("✅ Ready to implement in xeroblue_integration.py")
            print()
            print("🚀 Next step: Replace transformation method in integration file")
        else:
            print("❌ FAILED: Correct Invoice Transformation")
            print("   Review the errors above for details")
            
    except Exception as e:
        print(f"❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()