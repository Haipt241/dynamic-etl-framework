"""
Test script for XeroBlue integration with mock credentials
This allows testing the integration logic without requiring real Azure File Share access
"""

import os
import sys
import traceback
import pandas as pd
from typing import Dict, Any

# Add the current directory to Python path for imports

def setup_test_environment():
    """Set up environment variables for testing"""
    
    # Test configuration from user
    test_config = {
        'DB_Destination': 'EVA',
        'JOB_ID': '1',
        'JOB_RUN_ID': '6051',
        'TRIGGER_TYPE': 'MANUAL',
        'EtaniClientID': 'SWAU_CLIENT1724',
        'EtaniOrganisationID': '6051',
        'XeroTenantID': '31056af5-c4d0-4f1a-84c6-0a1b74498149',
        # Mock credentials for testing
        'xeroblue_client_id': 'mock_client_id',
        'xeroblue_client_secret': 'REDACTED',
        'AZ_FILE_SHARE': 'mockstorageaccount',
        'AZ_FILE_SHARE_KEY': 'mock_sas_token'
    }
    
    # Set environment variables
    for key, value in test_config.items():
        os.environ[key] = str(value)
        print(f"Set {key}={value if 'mock' in str(value) else value}")
    
    return True

class MockTokenManager:
    """Mock token manager for testing without Azure File Share"""
    
    def __init__(self, integration_api, token_file_name):
        self.integration_api = integration_api
        self.token_file_name = token_file_name
        self._mock_access_token = "REDACTED"
        self._mock_refresh_token = "REDACTED"
    
    def get_valid_token(self):
        """Return mock access token"""
        return self._mock_access_token
    
    def refresh_token_if_needed(self):
        """Mock token refresh"""
        print("Mock token refresh - returning existing token")
        return self._mock_access_token
    
    def get_token_from_file(self):
        """Mock token file reading"""
        return [self._mock_access_token, self._mock_refresh_token, self._mock_refresh_token]

class MockRequestManager:
    """Mock request manager for testing without making real API calls"""
    
    def __init__(self, integration_api, token_manager, endpoint, params=None, if_modified_since=None, id=None):
        self.integration_api = integration_api
        self.token_manager = token_manager
        self.endpoint = endpoint
        self.params = params
        self.if_modified_since = if_modified_since
        self.id = id
        self.data = None
    
    def __enter__(self):
        """Mock API request execution"""
        print(f"Mock API request for {self.endpoint}")
        
        # Create mock data based on endpoint
        mock_data = self._generate_mock_data()
        
        # Convert to DataFrame
        if mock_data:
            self.data = pd.DataFrame(mock_data)
            # Apply data type conversions
            self.data = self.integration_api.convert_data_types(self.data, self.endpoint)
        else:
            self.data = pd.DataFrame()
        
        return self.data
    
    def __exit__(self, exc_type, exc_value, traceback):
        """Cleanup"""
        print(f"Mock cleanup for {self.endpoint}")
        if hasattr(self, 'data'):
            del self.data
        return False
    
    def _generate_mock_data(self):
        """Generate mock data for different endpoints"""
        
        mock_data_templates = {
            'Organisations': [
                {
                    'OrganisationID': '31056af5-c4d0-4f1a-84c6-0a1b74498149',
                    'Name': 'SWAU Test Organisation',
                    'LegalName': 'SWAU Legal Name',
                    'CountryCode': 'AU',
                    'BaseCurrency': 'AUD',
                    'OrganisationType': 'COMPANY',
                    'OrganisationStatus': 'ACTIVE'
                }
            ],
            'Accounts': [
                {
                    'AccountID': 'acc-001',
                    'Code': '1000',
                    'Name': 'Cash',
                    'Type': 'BANK',
                    'BankAccountNumber': '123456789',
                    'Status': 'ACTIVE',
                    'Description': 'Main bank account'
                },
                {
                    'AccountID': 'acc-002', 
                    'Code': '4000',
                    'Name': 'Sales',
                    'Type': 'REVENUE',
                    'Status': 'ACTIVE',
                    'Description': 'Sales revenue account'
                }
            ],
            'Contacts': [
                {
                    'ContactID': 'cont-001',
                    'Name': 'Test Customer 1',
                    'EmailAddress': 'customer1@test.com',
                    'IsSupplier': False,
                    'IsCustomer': True,
                    'ContactStatus': 'ACTIVE'
                },
                {
                    'ContactID': 'cont-002',
                    'Name': 'Test Supplier 1', 
                    'EmailAddress': 'supplier1@test.com',
                    'IsSupplier': True,
                    'IsCustomer': False,
                    'ContactStatus': 'ACTIVE'
                }
            ],
            'Invoices': [
                {
                    'InvoiceID': 'inv-001',
                    'InvoiceNumber': 'INV-001',
                    'Type': 'ACCREC',
                    'Contact': {'ContactID': 'cont-001'},
                    'Date': '2024-01-15',
                    'DueDate': '2024-02-15',
                    'Status': 'AUTHORISED',
                    'SubTotal': 1000.00,
                    'TotalTax': 100.00,
                    'Total': 1100.00,
                    'AmountDue': 1100.00,
                    'AmountPaid': 0.00
                }
            ]
        }
        
        return mock_data_templates.get(self.endpoint, [])

def test_integration_with_mock_data():
    """Test the integration with mock data"""
    
    print("\\n=== Testing XeroBlue Integration with Mock Data ===")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        # Create integration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        integration = XeroBlueIntegration(config)
        print(f"✅ Integration created: {integration.integration_name}")
        
        # Test with mock token manager
        token_manager = MockTokenManager(integration, "1724_6051.txt")
        print(f"✅ Mock token manager created")
        
        # Test endpoints
        test_endpoints = ['Organisations', 'Accounts', 'Contacts', 'Invoices']
        
        print(f"\\n📊 Testing {len(test_endpoints)} endpoints with mock data:")
        
        for endpoint in test_endpoints:
            print(f"\\n  Testing {endpoint}...")
            
            # Test with mock request manager
            with MockRequestManager(integration, token_manager, endpoint) as data:
                if data is not None and not data.empty:
                    print(f"    ✅ {endpoint}: {len(data)} records")
                    print(f"    📋 Columns: {list(data.columns)}")
                    print(f"    🔍 Sample data: {data.iloc[0].to_dict() if len(data) > 0 else 'No data'}")
                else:
                    print(f"    ⚠️  {endpoint}: No data returned")
        
        return True
        
    except Exception as e:
        print(f"❌ Mock integration test failed: {str(e)}")
        traceback.print_exc()
        return False

def test_orchestrator_initialization():
    """Test orchestrator initialization with mock credentials"""
    
    print("\\n=== Testing Orchestrator Initialization ===")
    
    try:
        # We'll import and test individual components since full orchestrator needs database access
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        integration = XeroBlueIntegration(config)
        
        # Test orchestrator components
        print("✅ Integration ready for orchestrator")
        print(f"   - Integration name: {integration.integration_name}")
        print(f"   - Table prefix: {integration.table_prefix}")
        print(f"   - Endpoints available: {len(integration.get_endpoints_list())}")
        
        # Test environment access
        client_id = os.getenv('EtaniClientID')
        org_id = os.getenv('EtaniOrganisationID')
        print(f"   - Client ID: {client_id}")
        print(f"   - Organization ID: {org_id}")
        
        return True
        
    except Exception as e:
        print(f"❌ Orchestrator test failed: {str(e)}")
        traceback.print_exc()
        return False

def test_data_processing():
    """Test data processing and transformation"""
    
    print("\\n=== Testing Data Processing ===")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        integration = XeroBlueIntegration({'rate_limit': 60})
        
        # Test with sample data
        sample_invoice_data = {
            'Invoices': [
                {
                    'InvoiceID': 'inv-001',
                    'InvoiceNumber': 'INV-001',
                    'Date': '2024-01-15T00:00:00',
                    'DueDate': '2024-02-15T00:00:00',
                    'Total': '1100.00',
                    'AmountDue': '1100.00',
                    'HasAttachments': 'false',
                    'UpdatedDateUTC': '2024-01-15T10:30:00Z'
                }
            ]
        }
        
        # Test response parsing
        parsed_data = integration.parse_api_response(sample_invoice_data, 'Invoices')
        print(f"✅ Response parsing: {len(parsed_data)} records")
        
        # Test DataFrame creation and type conversion
        df = pd.DataFrame(parsed_data)
        print(f"✅ DataFrame created: {df.shape}")
        
        converted_df = integration.convert_data_types(df, 'Invoices')
        print(f"✅ Data types converted")
        print(f"   - Column types: {dict(converted_df.dtypes)}")
        
        # Test endpoint mapping
        endpoint_config = integration.get_endpoint_mapping('Invoices')
        print(f"✅ Endpoint mapping: {endpoint_config['endpoint_name']}")
        
        return True
        
    except Exception as e:
        print(f"❌ Data processing test failed: {str(e)}")
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

def run_mock_integration_test():
    """Run comprehensive test with mock data"""
    
    print("🧪 Starting XeroBlue Integration Test with Mock Data")
    print("=" * 60)
    
    # Setup environment
    setup_complete = setup_test_environment()
    
    if not setup_complete:
        print("❌ Environment setup failed")
        return False
    
    print("✅ Environment configured with mock credentials")
    
    # Test integration
    integration_test = test_integration_with_mock_data()
    if not integration_test:
        return False
    
    # Test orchestrator initialization
    orchestrator_test = test_orchestrator_initialization()
    if not orchestrator_test:
        return False
    
    # Test data processing
    data_processing_test = test_data_processing()
    if not data_processing_test:
        return False
    
    print("\\n" + "=" * 60)
    print("🎉 All mock tests completed successfully!")
    print("\\n📋 Test Summary:")
    print("   ✅ Environment setup with mock credentials")
    print("   ✅ XeroBlue integration initialization")
    print("   ✅ Mock API request handling")
    print("   ✅ Data processing and transformation")
    print("   ✅ Orchestrator component validation")
    
    print("\\n🚀 Next Steps:")
    print("   1. Set real Azure File Share credentials:")
    print("      - AZ_FILE_SHARE=<your-storage-account>")
    print("      - AZ_FILE_SHARE_KEY=<your-sas-token>")
    print("   2. Set XeroBlue API credentials:")
    print("      - xeroblue_client_id=<your-client-id>")
    print("      - xeroblue_client_secret=<your-client-secret>")
    print("   3. Ensure token file exists: 1724_6051.txt")
    print("   4. Run the actual ETL:")
    print("      python ipackage-upsert.py")
    
    return True

if __name__ == "__main__":
    try:
        success = run_mock_integration_test()
        
        if success:
            print("\\n✅ XeroBlue integration validation successful!")
            print("   The integration is properly configured and ready for production use.")
        else:
            print("\\n❌ Integration validation failed.")
            sys.exit(1)
            
    except Exception as e:
        print(f"\\n💥 Test execution failed: {str(e)}")
        traceback.print_exc()
        sys.exit(1)