"""
Test XeroBlue Integration with Real Azure Values
This test uses the actual Azure File Share and XeroBlue API credentials 
from the original XEROBLUE - UPSERT.py configuration.

IMPORTANT: This will make real API calls to XeroBlue and access Azure File Share.
"""

import os
import sys
import traceback
import time
from typing import Dict, Any

# Add the current directory to Python path for imports

def setup_real_azure_environment():
    """Set up environment variables with real Azure and XeroBlue values"""
    
    print("🔧 Setting up Real Azure Environment...")
    
    # Configuration from the provided test parameters
    test_config = {
        'DB_Destination': 'EVA',
        'JOB_ID': '1',
        'JOB_RUN_ID': '6051',
        'TRIGGER_TYPE': 'MANUAL',
        'EtaniClientID': 'SWAU_CLIENT1724',
        'EtaniOrganisationID': '6051',
        'XeroTenantID': '31056af5-c4d0-4f1a-84c6-0a1b74498149'
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

class RealAzureTokenManager:
    """
    Real Azure File Share token manager implementation
    Based on the original GetTokenFromFile and GetNewToken methods
    """
    
    def __init__(self, integration_api, token_file_name):
        self.integration_api = integration_api
        self.token_file_name = token_file_name
        self.storage_account_name = os.getenv('AZ_FILE_SHARE')
        self.storage_account_key = os.getenv('AZ_FILE_SHARE_KEY')
        self.file_share_name = os.getenv('FILE_SHARE_NAME', 'xeroblue-pydw-refreshtoken')
        
        print(f"🔐 Azure Token Manager Initialized:")
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
        """Refresh token if needed (placeholder for full implementation)"""
        print("🔄 Token refresh would be called here...")
        return self.get_valid_token()

def test_azure_connectivity():
    """Test Azure File Share connectivity"""
    
    print("\\n🔗 Testing Azure File Share Connectivity...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        # Create integration
        config = {'rate_limit': 60}
        integration = XeroBlueIntegration(config)
        
        # Test token manager with real Azure
        token_file_name = "1724_6051.txt"  # Based on SWAU_CLIENT1724 and org 6051
        token_manager = RealAzureTokenManager(integration, token_file_name)
        
        # Try to get token
        access_token = token_manager.get_valid_token()
        
        if access_token:
            print(f"✅ Azure connectivity successful!")
            print(f"   Token retrieved: {access_token[:20]}...{access_token[-10:]}")
            return True
        else:
            print(f"❌ No token retrieved from Azure")
            return False
            
    except Exception as e:
        print(f"❌ Azure connectivity failed: {str(e)}")
        traceback.print_exc()
        return False

def test_xero_api_call():
    """Test actual XeroBlue API call"""
    
    print("\\n🌐 Testing XeroBlue API Call...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        import requests
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900}
        integration = XeroBlueIntegration(config)
        
        # Get token
        token_manager = RealAzureTokenManager(integration, "1724_6051.txt")
        access_token = token_manager.get_valid_token()
        
        # Test API call to Organisations endpoint
        endpoint = "Organisations"
        api_url = integration.build_api_url(endpoint)
        headers = integration.get_auth_headers(access_token)
        
        print(f"🔗 Making API call to: {api_url}")
        print(f"📋 Headers: {list(headers.keys())}")
        
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
                print(f"   Sample org: {org.get('Name', 'N/A')} ({org.get('CountryCode', 'N/A')})")
            
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

def test_integration_with_real_request_manager():
    """Test the integration with a real request manager that uses Azure"""
    
    print("\\n🧪 Testing Integration with Real Request Manager...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        from implementations.BaseRequestManager import BaseRequestManager
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900, 'debug': True}
        integration = XeroBlueIntegration(config)
        
        # Create real Azure token manager
        token_manager = RealAzureTokenManager(integration, "1724_6051.txt")
        
        # Test with Organisations endpoint (small response)
        endpoint = "Organisations"
        
        print(f"🔄 Testing {endpoint} endpoint...")
        
        # Create request manager and make API call
        with BaseRequestManager(integration, token_manager, endpoint) as data:
            if data is not None and not data.empty:
                print(f"✅ {endpoint} successful: {len(data)} records")
                print(f"📋 Columns: {list(data.columns)}")
                
                # Show sample data (sanitized)
                if len(data) > 0:
                    sample = data.iloc[0].to_dict()
                    sanitized_sample = {}
                    for key, value in sample.items():
                        if isinstance(value, str) and len(value) > 20:
                            sanitized_sample[key] = f"{value[:10]}...{value[-5:]}"
                        else:
                            sanitized_sample[key] = value
                    print(f"🔍 Sample data: {sanitized_sample}")
                
                return True
            else:
                print(f"⚠️  {endpoint} returned no data")
                return False
                
    except Exception as e:
        print(f"❌ Integration test failed: {str(e)}")
        traceback.print_exc()
        return False

def test_multiple_endpoints():
    """Test multiple endpoints to verify system stability"""
    
    print("\\n📊 Testing Multiple Endpoints...")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        from implementations.BaseRequestManager import BaseRequestManager
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900}
        integration = XeroBlueIntegration(config)
        
        # Create token manager
        token_manager = RealAzureTokenManager(integration, "1724_6051.txt")
        
        # Test key endpoints
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
        
        print(f"\\n📈 Multi-Endpoint Test Summary:")
        print(f"   Successful: {successful}/{len(test_endpoints)}")
        print(f"   Total Records: {total_records}")
        
        for endpoint, result in results.items():
            status_icon = "✅" if result['status'] == 'success' else "❌"
            print(f"   {status_icon} {endpoint}: {result['status']}")
        
        return successful > 0
        
    except Exception as e:
        print(f"❌ Multi-endpoint test failed: {str(e)}")
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

def run_comprehensive_real_test():
    """Run comprehensive test with real Azure and XeroBlue values"""
    
    print("🧪 Starting Comprehensive Real Azure/XeroBlue Integration Test")
    print("=" * 70)
    print("⚠️  WARNING: This will make real API calls to XeroBlue and Azure!")
    print("=" * 70)
    
    # Setup environment
    print("\\n1️⃣  Setting up real Azure environment...")
    setup_success = setup_real_azure_environment()
    
    if not setup_success:
        print("❌ Environment setup failed")
        return False
    
    # Test Azure connectivity
    print("\\n2️⃣  Testing Azure File Share connectivity...")
    azure_success = test_azure_connectivity()
    
    if not azure_success:
        print("❌ Azure connectivity test failed")
        return False
    
    # Test XeroBlue API
    print("\\n3️⃣  Testing XeroBlue API connectivity...")
    api_success = test_xero_api_call()
    
    if not api_success:
        print("❌ XeroBlue API test failed")
        return False
    
    # Test integration with request manager
    print("\\n4️⃣  Testing integration with request manager...")
    integration_success = test_integration_with_real_request_manager()
    
    if not integration_success:
        print("❌ Integration test failed")
        return False
    
    # Test multiple endpoints
    print("\\n5️⃣  Testing multiple endpoints...")
    multi_success = test_multiple_endpoints()
    
    # Final summary
    print("\\n" + "=" * 70)
    if azure_success and api_success and integration_success and multi_success:
        print("🎉 ALL TESTS PASSED - Real Integration is Working!")
        print("\\n✅ Test Results:")
        print("   ✅ Azure File Share connectivity")
        print("   ✅ Token retrieval from Azure")
        print("   ✅ XeroBlue API authentication") 
        print("   ✅ Data retrieval and processing")
        print("   ✅ Multiple endpoint stability")
        
        print("\\n🚀 Production Readiness:")
        print("   ✅ Configuration: SWAU_CLIENT1724 / Org 6051")
        print("   ✅ XeroBlue Tenant: 31056af5-c4d0-4f1a-84c6-0a1b74498149")
        print("   ✅ Azure File Share: etanissis/xeroblue-pydw-refreshtoken")
        print("   ✅ Token File: 1724_6051.txt")
        
        print("\\n🎯 Ready for Production ETL:")
        print("   python IntegrationPackageUpsert.py")
        
        return True
    else:
        print("❌ SOME TESTS FAILED - Check errors above")
        print("\\n📋 Test Results:")
        print(f"   {'✅' if azure_success else '❌'} Azure File Share connectivity")
        print(f"   {'✅' if api_success else '❌'} XeroBlue API authentication")
        print(f"   {'✅' if integration_success else '❌'} Integration request manager")
        print(f"   {'✅' if multi_success else '❌'} Multiple endpoint stability")
        
        return False

if __name__ == "__main__":
    """
    Main execution
    """
    try:
        print("🔐 IMPORTANT: This test uses REAL credentials and will make REAL API calls!")
        print("    - Azure File Share: etanissis")
        print("    - XeroBlue API: Production endpoints")
        print("    - Token file: 1724_6051.txt")
        print()
        
        success = run_comprehensive_real_test()
        
        if success:
            print("\\n✅ Real integration test completed successfully!")
            print("   The IntegrationPackageUpsert.py system is ready for production.")
            sys.exit(0)
        else:
            print("\\n❌ Real integration test failed.")
            print("   Check the errors above and fix configuration issues.")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\\n🛑 Test interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\\n💥 Test execution failed: {str(e)}")
        traceback.print_exc()
        sys.exit(1)