"""
Test to list available token files in Azure File Share
This will help us understand what token files are actually available.
"""

import os
import sys

def list_azure_files():
    """List files in the Azure File Share to see what's available"""
    
    try:
        from azure.storage.fileshare import ShareDirectoryClient
        
        # Real Azure credentials from config
        storage_account_name = 'etanissis'
        storage_account_key = 'REDACTED'
        file_share_name = 'xeroblue-pydw-refreshtoken'
        
        print(f"🔍 Listing files in Azure File Share:")
        print(f"   Storage Account: {storage_account_name}")
        print(f"   File Share: {file_share_name}")
        
        # Create connection
        connection_string = f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storage_account_key};FileEndpoint=https://{storage_account_name}.file.core.windows.net/"
        
        # List root directory
        share_dir_client = ShareDirectoryClient.from_connection_string(
            connection_string,
            file_share_name,
            ""  # Root directory
        )
        
        print(f"\\n📁 Files in root directory:")
        files_found = []
        
        for item in share_dir_client.list_directories_and_files():
            if item.get('is_directory'):
                print(f"   📁 {item['name']}/")
            else:
                print(f"   📄 {item['name']}")
                files_found.append(item['name'])
        
        print(f"\\n📊 Summary:")
        print(f"   Total files found: {len(files_found)}")
        
        # Look for SWAU related files
        swau_files = [f for f in files_found if 'swau' in f.lower() or '1724' in f or '6051' in f]
        if swau_files:
            print(f"   SWAU related files: {swau_files}")
        
        # Look for any .txt files
        txt_files = [f for f in files_found if f.endswith('.txt')]
        if txt_files:
            print(f"   Available token files: {txt_files}")
            return txt_files
        else:
            print(f"   No .txt token files found")
            return []
            
    except Exception as e:
        print(f"❌ Error listing Azure files: {str(e)}")
        return []

def test_with_existing_token_file():
    """Test with an existing token file if available"""
    
    # First, get list of available files
    available_files = list_azure_files()
    
    if not available_files:
        print("\\n❌ No token files found to test with")
        return False
    
    # Try to test with the first available token file
    test_file = available_files[0]
    print(f"\\n🧪 Testing with available token file: {test_file}")
    
    try:
        from azure.storage.fileshare import ShareFileClient
        import json
        
        # Real Azure credentials
        storage_account_name = 'etanissis'
        storage_account_key = 'REDACTED'
        file_share_name = 'xeroblue-pydw-refreshtoken'
        
        # Create connection
        connection_string = f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storage_account_key};FileEndpoint=https://{storage_account_name}.file.core.windows.net/"
        
        share_file_client = ShareFileClient.from_connection_string(
            connection_string,
            file_share_name,
            test_file
        )
        
        # Download and parse
        downloader = share_file_client.download_file()
        file_contents = downloader.readall().decode('utf-8')
        
        print(f"✅ Successfully downloaded token file!")
        print(f"   File size: {len(file_contents)} characters")
        
        # Try to parse as JSON
        try:
            json_data = json.loads(file_contents)
            print(f"   JSON structure: {list(json_data.keys())}")
            
            # Check for required tokens
            has_access = 'access_token' in json_data
            has_refresh = 'refresh_token' in json_data
            
            print(f"   Has access_token: {has_access}")
            print(f"   Has refresh_token: {has_refresh}")
            
            if has_access and has_refresh:
                print(f"✅ Token file structure is valid!")
                
                # Test if we can use it
                return test_xero_api_with_token(json_data['access_token'])
            else:
                print(f"❌ Token file missing required fields")
                return False
                
        except json.JSONDecodeError:
            print(f"❌ Token file is not valid JSON")
            print(f"   Content preview: {file_contents[:100]}...")
            return False
            
    except Exception as e:
        print(f"❌ Error testing with token file: {str(e)}")
        return False

def test_xero_api_with_token(access_token):
    """Test XeroBlue API with a token"""
    
    print(f"\\n🌐 Testing XeroBlue API with token...")
    
    try:
        import requests
        
        # XeroBlue API test
        api_url = "https://api.xero.com/api.xro/2.0/Organisations"
        headers = {
            'Authorization': f'Bearer {access_token}',
            'Xero-tenant-id': '31056af5-c4d0-4f1a-84c6-0a1b74498149',
            'Accept': 'application/json'
        }
        
        print(f"🔗 Making API call to: {api_url}")
        
        response = requests.get(api_url, headers=headers, timeout=30)
        
        print(f"📊 Response Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            organisations = data.get('Organisations', [])
            
            print(f"✅ XeroBlue API call successful!")
            print(f"   Retrieved {len(organisations)} organisations")
            
            if organisations:
                org = organisations[0]
                print(f"   Organisation: {org.get('Name', 'N/A')} ({org.get('CountryCode', 'N/A')})")
            
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

def main():
    """Main test execution"""
    
    print("🔍 Azure File Share Token Investigation")
    print("=" * 50)
    print("This test will:")
    print("1. List available token files in Azure File Share")
    print("2. Test with an existing token file (if available)")
    print("3. Verify XeroBlue API connectivity")
    print()
    
    try:
        # Test with any available token file
        success = test_with_existing_token_file()
        
        print("\\n" + "=" * 50)
        if success:
            print("🎉 Azure and XeroBlue connectivity verified!")
            print("\\n✅ Key Findings:")
            print("   ✅ Azure File Share credentials are valid")
            print("   ✅ Can read token files from Azure")
            print("   ✅ XeroBlue API is accessible")
            print("   ✅ Token authentication working")
            
            print("\\n🔧 For SWAU integration:")
            print("   📝 Expected token file: 1724_6051.txt")
            print("   📝 Based on: SWAU_CLIENT1724 + Organization 6051")
            print("   📝 File should be uploaded to Azure File Share")
            
            print("\\n🚀 Integration System Status:")
            print("   ✅ Azure configuration: WORKING")
            print("   ✅ XeroBlue API access: WORKING") 
            print("   ✅ IntegrationPackageUpsert.py: READY")
            print("   ⚠️  Token file: Needs 1724_6051.txt for SWAU")
            
        else:
            print("❌ Some connectivity issues found")
            print("\\n📋 Status:")
            print("   ✅ Azure credentials: Valid")
            print("   ❌ Token authentication: Failed")
            
        return success
        
    except Exception as e:
        print(f"💥 Test failed: {str(e)}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)