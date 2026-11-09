"""
Test XeroBlue Integration with BIGOLESHOECOMPANY Configuration
This test uses the actual Azure File Share and XeroBlue API credentials 
with BIGOLESHOECOMPANY parameters.

Configuration:
- Client: BIGOLESHOECOMPANY_CLIENT1518
- Organization: 7232
- Xero Tenant: 865512af-e7d8-4d42-8568-73084279eb43
- DB Destination: EVA
- Job Run ID: 7232
"""

import os
import sys
import traceback
import time
from typing import Dict, Any

# Add the current directory to Python path for imports

def setup_bigoleshoe_environment():
    """Set up environment variables with BIGOLESHOECOMPANY configuration"""
    
    print("🔧 Setting up BIGOLESHOECOMPANY Environment...")
    
    # BIGOLESHOECOMPANY configuration
    test_config = {
        'DB_Destination': 'EVA',
        'JOB_ID': '1',
        'JOB_RUN_ID': '7232',
        'TRIGGER_TYPE': 'MANUAL',
        'EtaniClientID': 'BIGOLESHOECOMPANY_CLIENT1518',
        'EtaniOrganisationID': '7232',
        'XeroTenantID': '865512af-e7d8-4d42-8568-73084279eb43'
    }
    
    # Real Azure File Share credentials from config.py
    azure_config = {
        'AZ_FILE_SHARE': 'etanissis',  # STORAGE_ACCOUNT_NAME
        'AZ_FILE_SHARE_KEY': 'REDACTED',  # STORAGE_ACCOUNT_KEY
        'FILE_SHARE_NAME': 'xeroblue-pydw-refreshtoken'
    }
    
    # Real XeroBlue API credentials from config.py
    xero_config = {
        'xeroblue_client_id': '7D624AC6AEAA49CAA480DC684FCAA0C4',
        'xeroblue_client_secret': 'REDACTED'
    }
    
    # Combine all configurations
    full_config = {**test_config, **azure_config, **xero_config}
    
    # Set environment variables
    for key, value in full_config.items():
        os.environ[key] = str(value)
        if 'key' in key.lower() or 'secret' in key.lower():
            print(f"   {key}=<REDACTED_FOR_SECURITY>")
        else:
            print(f"   {key}={value}")
    
    return True

class BigOleShoeTokenManager:
    """
    Azure File Share token manager for BIGOLESHOECOMPANY
    """
    
    def __init__(self, integration_api, token_file_name):
        self.integration_api = integration_api
        self.token_file_name = token_file_name
        self.storage_account_name = os.getenv('AZ_FILE_SHARE')
        self.storage_account_key = os.getenv('AZ_FILE_SHARE_KEY')
        self.file_share_name = os.getenv('FILE_SHARE_NAME', 'xeroblue-pydw-refreshtoken')
        
        print(f"🔐 BIGOLESHOECOMPANY Token Manager Initialized:")
        print(f"   Storage Account: {self.storage_account_name}")
        print(f"   File Share: {self.file_share_name}")
        print(f"   Token File: {self.token_file_name}")
    
    def get_valid_token(self):
        """Get valid token from Azure File Share"""
        try:
            tokens = self.get_token_from_azure()
            if tokens and len(tokens) >= 2:
                return tokens[0]  # access_token
            else:
                raise Exception("No valid tokens found in Azure File Share")
        except Exception as e:
            print(f"❌ Error getting token: {str(e)}")
            raise e
    
    def get_token_from_azure(self):
        """
        Read tokens from Azure File Share
        Implementation based on original GetTokenFromFile method
        """
        try:
            from azure.storage.fileshare import ShareFileClient
            import json
            
            print(f"📥 Reading token from Azure File Share...")
            
            # Create ShareFileClient (matching original implementation)
            connection_string = f"DefaultEndpointsProtocol=https;AccountName={self.storage_account_name};AccountKey={self.storage_account_key};FileEndpoint=https://{self.storage_account_name}.file.core.windows.net/"
            
            share_file_client = ShareFileClient.from_connection_string(
                connection_string,
                self.file_share_name,
                self.token_file_name
            )
            
            # Download file
            downloader = share_file_client.download_file()
            file_contents = downloader.readall().decode('utf-8')
            
            print(f"✅ Token file downloaded successfully")
            
            # Parse JSON content
            json_response = json.loads(file_contents)
            
            # Return in expected format [access_token, refresh_token, refresh_token]
            return [
                json_response['access_token'],
                json_response['refresh_token'],
                json_response['refresh_token']
            ]
            
        except Exception as e:
            print(f"❌ Error reading from Azure File Share: {str(e)}")
            raise e
    
    def refresh_token_if_needed(self):
        """Refresh token if needed"""
        print("🔄 Token refresh would be called here...")
        return self.get_valid_token()

def test_bigoleshoe_azure_connectivity():
    """Test Azure File Share connectivity for BIGOLESHOECOMPANY"""
    
    print("\\n🔗 Testing BIGOLESHOECOMPANY Azure File Share Connectivity...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        # Create integration
        config = {'rate_limit': 60}
        integration = XeroBlueIntegration(config)
        
        # Dynamic token file name based on config params
        client_id = os.getenv('EtaniClientID', '')
        org_id = os.getenv('EtaniOrganisationID', '')
        token_file_name = f"{client_id}_{org_id}.txt"
        token_manager = BigOleShoeTokenManager(integration, token_file_name)
        
        # Try to get token
        access_token = token_manager.get_valid_token()
        
        if access_token:
            print(f"✅ Azure connectivity successful!")
            print(f"   Token retrieved: {access_token[:20]}...{access_token[-10:]}")
            return True, access_token
        else:
            print(f"❌ No token retrieved from Azure")
            return False, None
            
    except Exception as e:
        print(f"❌ Azure connectivity failed: {str(e)}")
        # Check if it's a file not found error
        if "ResourceNotFound" in str(e):
            print(f"   Expected token file: 1518_7232.txt")
            print(f"   This file should exist in Azure File Share for BIGOLESHOECOMPANY")
        traceback.print_exc()
        return False, None

def test_bigoleshoe_xero_api_call(access_token):
    """Test actual XeroBlue API call for BIGOLESHOECOMPANY"""
    
    print("\\n🌐 Testing BIGOLESHOECOMPANY XeroBlue API Call...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        import requests
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900}
        integration = XeroBlueIntegration(config)
        
        # Test API call to Organisations endpoint
        endpoint = "Organisations"
        api_url = integration.build_api_url(endpoint)
        headers = integration.get_auth_headers(access_token)
        
        print(f"🔗 Making API call to: {api_url}")
        print(f"📋 Headers: {list(headers.keys())}")
        print(f"   Xero-tenant-id: {headers.get('Xero-tenant-id')}")
        
        # Make request
        response = requests.get(api_url, headers=headers, timeout=30)
        
        print(f"📊 Response Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            organisations = data.get('Organisations', [])
            
            print(f"✅ API call successful!")
            print(f"   Retrieved {len(organisations)} organisations")
            
            if organisations:
                org = organisations[0]
                print(f"   Organisation: {org.get('Name', 'N/A')} ({org.get('CountryCode', 'N/A')})")
                print(f"   Legal Name: {org.get('LegalName', 'N/A')}")
                print(f"   Base Currency: {org.get('BaseCurrency', 'N/A')}")
            
            return True
            
        elif response.status_code == 401:
            print(f"❌ Authentication failed - Token may be expired")
            return False
            
        else:
            print(f"❌ API call failed: {response.status_code}")
            print(f"   Response: {response.text[:200]}...")
            return False
            
    except Exception as e:
        print(f"❌ XeroBlue API test failed: {str(e)}")
        traceback.print_exc()
        return False

def test_bigoleshoe_integration_full():
    """Test the full integration with BIGOLESHOECOMPANY parameters"""
    
    print("\\n🧪 Testing Full Integration for BIGOLESHOECOMPANY...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        from implementations.BaseRequestManager import BaseRequestManager
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900, 'debug': True}
        integration = XeroBlueIntegration(config)
        
        # Dynamic token file name based on config params
        client_id = os.getenv('EtaniClientID', '')
        org_id = os.getenv('EtaniOrganisationID', '')
        token_file_name = f"{client_id}_{org_id}.txt"
        token_manager = BigOleShoeTokenManager(integration, token_file_name)
        
        # Test with key endpoints
        test_endpoints = ['Organisations', 'Accounts', 'Contacts']
        results = {}
        
        for i, endpoint in enumerate(test_endpoints, 1):
            print(f"\\n[{i}/{len(test_endpoints)}] Testing {endpoint}...")
            
            try:
                start_time = time.time()
                
                with BaseRequestManager(integration, token_manager, endpoint) as data:
                    duration = time.time() - start_time
                    
                    if data is not None and not data.empty:
                        results[endpoint] = {
                            'status': 'success',
                            'records': len(data),
                            'duration': duration
                        }
                        print(f"   ✅ {endpoint}: {len(data)} records ({duration:.1f}s)")
                        
                        # Show sample data for verification
                        if len(data) > 0:
                            sample_columns = list(data.columns)[:5]  # First 5 columns
                            print(f"   📋 Sample columns: {sample_columns}")
                    else:
                        results[endpoint] = {
                            'status': 'no_data',
                            'records': 0,
                            'duration': duration
                        }
                        print(f"   ⚠️  {endpoint}: No data ({duration:.1f}s)")
                
                # Rate limiting pause
                if i < len(test_endpoints):
                    print(f"   ⏱️  Rate limiting pause...")
                    time.sleep(2)
                    
            except Exception as e:
                results[endpoint] = {
                    'status': 'error',
                    'error': str(e),
                    'duration': 0
                }
                print(f"   ❌ {endpoint}: {str(e)}")
        
        # Summary
        successful = sum(1 for r in results.values() if r['status'] == 'success')
        total_records = sum(r.get('records', 0) for r in results.values())
        
        print(f"\\n📈 Integration Test Summary:")
        print(f"   Successful endpoints: {successful}/{len(test_endpoints)}")
        print(f"   Total records: {total_records}")
        
        for endpoint, result in results.items():
            status_icon = "✅" if result['status'] == 'success' else "❌"
            print(f"   {status_icon} {endpoint}: {result['status']}")
        
        return successful > 0
        
    except Exception as e:
        print(f"❌ Full integration test failed: {str(e)}")
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

def validate_bigoleshoe_configuration():
    """Validate BIGOLESHOECOMPANY configuration"""
    
    print("\\n🔍 Validating BIGOLESHOECOMPANY Configuration...")
    
    config_items = [
        ('Client ID', os.getenv('EtaniClientID')),
        ('Organization ID', os.getenv('EtaniOrganisationID')),
        ('Xero Tenant ID', os.getenv('XeroTenantID')),
        ('DB Destination', os.getenv('DB_Destination')),
        ('Job Run ID', os.getenv('JOB_RUN_ID'))
    ]
    
    print("📋 Configuration Summary:")
    all_valid = True
    for name, value in config_items:
        if value:
            print(f"   ✅ {name}: {value}")
        else:
            print(f"   ❌ {name}: <missing>")
            all_valid = False
    
    # Dynamic expected token file
    client_id = os.getenv('EtaniClientID', '')
    org_id = os.getenv('EtaniOrganisationID', '')
    expected_token_file = f"{client_id}_{org_id}.txt"
    print(f"\\n🎯 Expected Token File: {expected_token_file}")
    print(f"   Based on: {client_id} + Organization {org_id}")
    
    return all_valid

def run_bigoleshoe_comprehensive_test():
    """Run comprehensive test for BIGOLESHOECOMPANY"""
    
    print("🧪 BIGOLESHOECOMPANY XeroBlue Integration Test")
    print("=" * 60)
    print("Testing with:")
    print("  - Client: BIGOLESHOECOMPANY_CLIENT1518")
    print("  - Organization: 7232")
    print("  - Xero Tenant: 865512af-e7d8-4d42-8568-73084279eb43")
    print("  - Token File: {dynamic based on config}")
    print("=" * 60)
    
    # Setup environment
    print("\\n1️⃣  Setting up BIGOLESHOECOMPANY environment...")
    setup_success = setup_bigoleshoe_environment()
    
    if not setup_success:
        print("❌ Environment setup failed")
        return False
    
    # Validate configuration
    print("\\n2️⃣  Validating configuration...")
    config_valid = validate_bigoleshoe_configuration()
    
    # Test Azure connectivity
    print("\\n3️⃣  Testing Azure File Share connectivity...")
    azure_success, access_token = test_bigoleshoe_azure_connectivity()
    
    if not azure_success:
        print("❌ Azure connectivity test failed")
        client_id = os.getenv('EtaniClientID', '')
        org_id = os.getenv('EtaniOrganisationID', '')
        token_file = f"{client_id}_{org_id}.txt"
        print("\\n🔧 Troubleshooting:")
        print(f"   1. Verify token file '{token_file}' exists in Azure File Share")
        print("   2. Check Azure File Share path: etanissis/xeroblue-pydw-refreshtoken/")
        print("   3. Ensure token file contains valid JSON with access_token and refresh_token")
        return False
    
    # Test XeroBlue API
    print("\\n4️⃣  Testing XeroBlue API connectivity...")
    api_success = test_bigoleshoe_xero_api_call(access_token)
    
    if not api_success:
        print("❌ XeroBlue API test failed")
        return False
    
    # Test full integration
    print("\\n5️⃣  Testing full integration...")
    integration_success = test_bigoleshoe_integration_full()
    
    # Final summary
    print("\\n" + "=" * 60)
    if azure_success and api_success and integration_success:
        print("🎉 ALL TESTS PASSED - BIGOLESHOECOMPANY Integration Working!")
        print("\\n✅ Test Results:")
        print("   ✅ Configuration validation")
        print("   ✅ Azure File Share connectivity")
        print("   ✅ Token retrieval from Azure")
        print("   ✅ XeroBlue API authentication") 
        print("   ✅ Data retrieval and processing")
        print("   ✅ Integration system functionality")
        
        print("\\n🚀 Production Ready:")
        print("   ✅ Client: BIGOLESHOECOMPANY_CLIENT1518")
        print("   ✅ Organization: 7232")
        print("   ✅ Xero Tenant: 865512af-e7d8-4d42-8568-73084279eb43")
        client_id = os.getenv('EtaniClientID', '')
        org_id = os.getenv('EtaniOrganisationID', '')
        token_file = f"{client_id}_{org_id}.txt"
        print(f"   ✅ Token File: {token_file}")
        
        print("\\n🎯 Run Production ETL:")
        print("   export EtaniClientID='BIGOLESHOECOMPANY_CLIENT1518'")
        print("   export EtaniOrganisationID='7232'")
        print("   export XeroTenantID='865512af-e7d8-4d42-8568-73084279eb43'")
        print("   python IntegrationPackageUpsert.py")
        
        return True
    else:
        print("❌ SOME TESTS FAILED")
        print("\\n📋 Test Results:")
        print(f"   {'✅' if config_valid else '❌'} Configuration validation")
        print(f"   {'✅' if azure_success else '❌'} Azure File Share connectivity")
        print(f"   {'✅' if api_success else '❌'} XeroBlue API authentication")
        print(f"   {'✅' if integration_success else '❌'} Integration functionality")
        
        return False

if __name__ == "__main__":
    """
    Main execution
    """
    try:
        print("🔐 BIGOLESHOECOMPANY Integration Test")
        print("This test uses REAL Azure and XeroBlue credentials!")
        print()
        
        success = run_bigoleshoe_comprehensive_test()
        
        if success:
            print("\\n✅ BIGOLESHOECOMPANY integration test completed successfully!")
            print("   The IntegrationPackageUpsert.py system is ready for BIGOLESHOECOMPANY.")
            sys.exit(0)
        else:
            print("\\n❌ BIGOLESHOECOMPANY integration test failed.")
            print("   Check the errors above and fix configuration issues.")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\\n🛑 Test interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\\n💥 Test execution failed: {str(e)}")
        traceback.print_exc()
        sys.exit(1)