#!/usr/bin/env python3
"""
Test ClientID Population in Organisations Transformation
Verifies that the ClientID field is properly populated with the client number (1518)
"""

import pandas as pd
import sys
import os

# Set required environment variables for testing
os.environ['EtaniClientID'] = 'BIGOLESHOECOMPANY_CLIENT1518'
os.environ['EtaniOrganisationID'] = '7232'
os.environ['XeroTenantID'] = '865512af-e7d8-4d42-8568-73084279eb43'
os.environ['JOB_ID'] = '0'
os.environ['JOB_RUN_ID'] = '7232'
os.environ['TRIGGER_TYPE'] = 'MANUAL'
os.environ['DB_Destination'] = 'DW'

def test_clientid_population():
    """Test that ClientID is properly populated in organisations transformation"""
    print("🧪 Testing ClientID population in organisations transformation...")
    
    # Add the dynamic_integrations to path

    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Check that client_id_number is properly set
        print(f"✅ Integration client_id_number: '{integration.client_id_number}'")
        print(f"✅ Integration etani_client_id: '{integration.etani_client_id}'")
        
        # Create sample organisations data
        organisations_data = pd.DataFrame([{
            'APIKey': 'REDACTED',
            'Name': 'Etani Online Clothing',
            'LegalName': 'Etani Online Clothing',
            'PaysTax': True,
            'Version': 'AU',
            'BaseCurrency': 'AUD',
            'CountryCode': 'AU',
            'IsDemoCompany': False,
            'OrganisationStatus': 'ACTIVE',
            'RegistrationNumber': '',
            'TaxNumber': '',
            'FinancialYearEndDay': 30,
            'FinancialYearEndMonth': 6,
            'CreatedDateUTC': '/Date(1516756671000)/',
            'OrganisationEntityType': 'COMPANY',
            'Timezone': 'AUSEASTERNSTANDARDTIME',
            'Edition': 'BUSINESS',
            'Class': 'IGNITE',
            'LineOfBusiness': 'Retail Clothing',
            'ShortCode': '!XPnnc',
            'Addresses': [],
            'Phones': [],
            'ExternalLinks': [],
            'PaymentTerms': {}
        }])
        
        # Transform the data
        result = integration._transform_organisations_data(organisations_data)
        
        if not result.empty:
            print(f"✅ Transformation successful: {len(result)} records generated")
            print(f"✅ Generated {len(result.columns)} columns")
            
            # Check ClientID field specifically
            if 'ClientID' in result.columns:
                client_id_value = result['ClientID'].iloc[0]
                print(f"✅ ClientID field found: '{client_id_value}'")
                
                # Verify it's the correct value (should be "BIGOLESHOECOMPANY_CLIENT1518")
                if client_id_value == 'BIGOLESHOECOMPANY_CLIENT1518':
                    print("🎉 ClientID correctly populated with 'BIGOLESHOECOMPANY_CLIENT1518'")
                    return True
                else:
                    print(f"❌ ClientID incorrect: expected 'BIGOLESHOECOMPANY_CLIENT1518', got '{client_id_value}'")
                    return False
            else:
                print("❌ ClientID field missing from transformation result")
                print(f"Available columns: {list(result.columns)}")
                return False
        else:
            print("❌ Transformation returned empty result")
            return False
            
    except Exception as e:
        print(f"❌ Error testing ClientID population: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_all_organisations_columns():
    """Test that all expected columns are present in organisations transformation"""
    print("\n🧪 Testing all organisations columns...")

    try:
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create integration instance
        config = {'test_mode': True}
        integration = XeroblueIntegration(config)
        
        # Create sample organisations data
        organisations_data = pd.DataFrame([{
            'APIKey': 'REDACTED',
            'Name': 'Etani Online Clothing',
            'LegalName': 'Etani Online Clothing',
            'PaysTax': True,
            'Version': 'AU',
            'BaseCurrency': 'AUD',
            'CountryCode': 'AU',
            'IsDemoCompany': False,
            'OrganisationStatus': 'ACTIVE',
            'RegistrationNumber': '',
            'TaxNumber': '',
            'FinancialYearEndDay': 30,
            'FinancialYearEndMonth': 6,
            'CreatedDateUTC': '/Date(1516756671000)/',
            'OrganisationEntityType': 'COMPANY',
            'Timezone': 'AUSEASTERNSTANDARDTIME',
            'Edition': 'BUSINESS',
            'Class': 'IGNITE',
            'LineOfBusiness': 'Retail Clothing',
            'ShortCode': '!XPnnc',
            'Addresses': [],
            'Phones': [],
            'ExternalLinks': [],
            'PaymentTerms': {}
        }])
        
        # Transform the data
        result = integration._transform_organisations_data(organisations_data)
        
        # Expected columns from original XEROBLUE - UPSERT.py
        expected_base_columns = [
            'ShortCode', 'APIKey', 'Name', 'LegalName', 'PaysTax', 'Version', 
            'BaseCurrency', 'CountryCode', 'IsDemoCompany', 'OrganisationStatus', 
            'RegistrationNumber', 'TaxNumber', 'FinancialYearEndDay', 'FinancialYearEndMonth',
            'CreatedDateUTC', 'OrganisationEntityType', 'Timezone', 'Edition', 'Class',
            'LineOfBusiness', 'PeriodLockDate', 'EndOfYearLockDate', 'ClientID', 'OrganisationID'
        ]
        
        print(f"✅ Expected base columns: {len(expected_base_columns)}")
        print(f"✅ Generated columns: {len(result.columns)}")
        
        # Check for missing base columns
        missing_columns = [col for col in expected_base_columns if col not in result.columns]
        extra_columns = [col for col in result.columns if col not in expected_base_columns]
        
        if missing_columns:
            print(f"❌ Missing columns: {missing_columns}")
        else:
            print("✅ All expected base columns present")
            
        if extra_columns:
            print(f"✅ Additional columns (address/phone flattening): {len(extra_columns)}")
            print(f"   Examples: {extra_columns[:5]}{'...' if len(extra_columns) > 5 else ''}")
        
        # Show key column values
        print(f"\n📋 Key Column Values:")
        for col in ['ClientID', 'OrganisationID', 'Name', 'ShortCode']:
            if col in result.columns:
                value = result[col].iloc[0]
                print(f"   {col}: '{value}'")
            else:
                print(f"   {col}: MISSING")
        
        return len(missing_columns) == 0
        
    except Exception as e:
        print(f"❌ Error testing organisations columns: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Run ClientID verification tests"""
    print("🔍 ClientID Verification Test")
    print("=" * 40)
    
    tests = [
        test_clientid_population,
        test_all_organisations_columns
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
            print()
        except Exception as e:
            print(f"❌ Test failed with exception: {str(e)}")
            import traceback
            traceback.print_exc()
    
    print("=" * 40)
    print(f"📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 ClientID verification tests passed!")
        print("✅ ClientID properly populated with client number")
        return True
    else:
        print("❌ Some ClientID verification tests failed")
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
    success = main()
    sys.exit(0 if success else 1)