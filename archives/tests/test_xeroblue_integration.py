"""
Test script for XeroBlue integration with specific configuration
"""

import os
import sys
import traceback
from typing import Dict, Any

# Add the current directory to Python path for imports

# Set up test environment variables
def setup_test_environment():
    """Set up environment variables for testing"""
    
    # Test configuration from user
    test_config = {
        'DB_Destination': 'EVA',
        'JOB_ID': '1',
        'JOB_RUN_ID': '7232',
        'TRIGGER_TYPE': 'MANUAL',
        'EtaniClientID': 'BIGOLESHOECOMPANY_CLIENT1518',
        'EtaniOrganisationID': '7232',
        'XeroTenantID': '865512af-e7d8-4d42-8568-73084279eb43'
    }
    
    # Set environment variables
    for key, value in test_config.items():
        os.environ[key] = str(value)
        print(f"Set {key}={value}")
    
    # Additional required environment variables (these would need to be set externally)
    required_vars = [
        'xeroblue_client_id',
        'xeroblue_client_secret', 
        'AZ_FILE_SHARE',
        'AZ_FILE_SHARE_KEY'
    ]
    
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    if missing_vars:
        print(f"\\n⚠️  Warning: Missing environment variables: {missing_vars}")
        print("These need to be set externally for full testing")
        return False
    
    return True

def test_xeroblue_integration_setup():
    """Test XeroBlue integration initialization"""
    
    print("\\n=== Testing XeroBlue Integration Setup ===")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        # Test configuration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        # Create integration instance
        integration = XeroBlueIntegration(config)
        
        print(f"✅ Integration created successfully")
        print(f"   - Name: {integration.integration_name}")
        print(f"   - Table Prefix: {integration.table_prefix}")
        print(f"   - Rate Limit: {integration.rate_limit}")
        print(f"   - XeroTenantID: {integration.xero_tenant_id}")
        
        # Test endpoint list
        endpoints = integration.get_endpoints_list()
        print(f"   - Available Endpoints: {len(endpoints)}")
        print(f"   - Sample Endpoints: {endpoints[:5]}")
        
        # Test URL building
        test_url = integration.build_api_url("Organisations")
        print(f"   - Sample URL: {test_url}")
        
        # Test auth headers
        test_headers = integration.get_auth_headers("test_token")
        print(f"   - Auth Headers: {list(test_headers.keys())}")
        
        return integration
        
    except Exception as e:
        print(f"❌ Integration setup failed: {str(e)}")
        traceback.print_exc()
        return None

def test_token_manager():
    """Test token manager functionality"""
    
    print("\\n=== Testing Token Manager ===")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        from implementations.BaseTokenManager import BaseTokenManager
        
        # Create integration
        config = {'rate_limit': 60}
        integration = XeroBlueIntegration(config)
        
        # Create token manager
        token_file_name = "BIGOLESHOECOMPANY_CLIENT1518_7232.txt"  # Based on client and org IDs
        token_manager = BaseTokenManager(integration, token_file_name)
        
        print(f"✅ Token manager created")
        print(f"   - Token file: {token_file_name}")
        print(f"   - File path: {token_manager.get_token_file_path()}")
        
        # Test token refresh params
        refresh_params = integration.get_token_refresh_params()
        print(f"   - Refresh URL: {refresh_params.get('token_url')}")
        
        return token_manager
        
    except Exception as e:
        print(f"❌ Token manager setup failed: {str(e)}")
        traceback.print_exc()
        return None

def test_orchestrator():
    """Test the main orchestrator"""
    
    print("\\n=== Testing Package Upsert Orchestrator ===")
    
    try:
        from IntegrationPackageUpsert import create_package_upsert
        
        # Configuration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True,
            'max_retries': 3
        }
        
        # Create orchestrator
        orchestrator = create_package_upsert('XEROBLUE', config)
        
        print(f"✅ Orchestrator created successfully")
        print(f"   - Integration: {orchestrator.integration_api.integration_name}")
        print(f"   - Client ID: {orchestrator.etani_client_id}")
        print(f"   - Organization ID: {orchestrator.etani_org_id}")
        print(f"   - DB Destination: {orchestrator.db_destination}")
        
        return orchestrator
        
    except Exception as e:
        print(f"❌ Orchestrator setup failed: {str(e)}")
        traceback.print_exc()
        return None

def test_single_endpoint_simulation():
    """Simulate testing a single endpoint without making actual API calls"""
    
    print("\\n=== Testing Single Endpoint (Simulation) ===")
    
    try:
        from integrations.xeroblue_integration import XeroBlueIntegration
        from implementations.BaseRequestManager import BaseRequestManager
        from implementations.BaseTokenManager import BaseTokenManager
        import pandas as pd
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900}
        integration = XeroBlueIntegration(config)
        
        # Create token manager
        token_file_name = "BIGOLESHOECOMPANY_CLIENT1518_7232.txt"
        token_manager = BaseTokenManager(integration, token_file_name)
        
        # Test endpoint configuration
        endpoint = "Organisations"
        endpoint_config = integration.get_endpoint_mapping(endpoint)
        
        print(f"✅ Endpoint configuration retrieved")
        print(f"   - Endpoint: {endpoint}")
        print(f"   - Config: {endpoint_config}")
        
        # Test URL building
        api_url = integration.build_api_url(endpoint)
        print(f"   - API URL: {api_url}")
        
        # Test response parsing (with mock data)
        mock_response = {
            "Organisations": [
                {
                    "OrganisationID": "test-id",
                    "Name": "Test Organisation",
                    "LegalName": "Test Legal Name",
                    "CountryCode": "AU"
                }
            ]
        }
        
        parsed_data = integration.parse_api_response(mock_response, endpoint)
        print(f"   - Parsed data: {len(parsed_data)} records")
        
        # Test data type conversion
        df = pd.DataFrame(parsed_data)
        converted_df = integration.convert_data_types(df, endpoint)
        print(f"   - DataFrame created: {converted_df.shape}")
        print(f"   - Columns: {list(converted_df.columns)}")
        
        return True
        
    except Exception as e:
        print(f"❌ Endpoint simulation failed: {str(e)}")
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

def validate_configuration():
    """Validate that all required configuration is present"""
    
    print("\\n=== Validating Configuration ===")
    
    # Required environment variables
    required_vars = {
        'EtaniClientID': os.getenv('EtaniClientID'),
        'EtaniOrganisationID': os.getenv('EtaniOrganisationID'),
        'XeroTenantID': os.getenv('XeroTenantID'),
        'DB_Destination': os.getenv('DB_Destination')
    }
    
    # Optional but recommended
    optional_vars = {
        'xeroblue_client_id': os.getenv('xeroblue_client_id'),
        'xeroblue_client_secret': os.getenv('xeroblue_client_secret'),
        'AZ_FILE_SHARE': os.getenv('AZ_FILE_SHARE'),
        'AZ_FILE_SHARE_KEY': os.getenv('AZ_FILE_SHARE_KEY')
    }
    
    print("Required Variables:")
    all_required_present = True
    for var, value in required_vars.items():
        if value:
            print(f"   ✅ {var}={value}")
        else:
            print(f"   ❌ {var}=<missing>")
            all_required_present = False
    
    print("\\nOptional Variables (needed for full functionality):")
    for var, value in optional_vars.items():
        if value:
            print(f"   ✅ {var}=<present>")
        else:
            print(f"   ⚠️  {var}=<missing>")
    
    return all_required_present

def run_comprehensive_test():
    """Run all tests in sequence"""
    
    print("🧪 Starting Comprehensive XeroBlue Integration Test")
    print("=" * 60)
    
    # Setup environment
    setup_complete = setup_test_environment()
    
    # Validate configuration
    config_valid = validate_configuration()
    
    if not config_valid:
        print("\\n❌ Configuration validation failed. Cannot proceed with tests.")
        return False
    
    # Test integration setup
    integration = test_xeroblue_integration_setup()
    if not integration:
        return False
    
    # Test token manager
    token_manager = test_token_manager()
    if not token_manager:
        return False
    
    # Test orchestrator
    orchestrator = test_orchestrator()
    if not orchestrator:
        return False
    
    # Test endpoint simulation
    endpoint_test = test_single_endpoint_simulation()
    if not endpoint_test:
        return False
    
    print("\\n" + "=" * 60)
    print("🎉 All tests completed successfully!")
    print("\\n📋 Test Summary:")
    print("   ✅ Environment setup")
    print("   ✅ Configuration validation")
    print("   ✅ XeroBlue integration initialization")
    print("   ✅ Token manager setup")
    print("   ✅ Orchestrator creation")
    print("   ✅ Endpoint simulation")
    
    if not setup_complete:
        print("\\n⚠️  Note: Some credentials are missing for full API testing")
        print("   To run with real API calls, set:")
        print("   - xeroblue_client_id")
        print("   - xeroblue_client_secret") 
        print("   - AZ_FILE_SHARE")
        print("   - AZ_FILE_SHARE_KEY")
    
    return True

if __name__ == "__main__":
    """
    Main test execution
    """
    try:
        success = run_comprehensive_test()
        
        if success:
            print("\\n✅ XeroBlue integration is ready for use!")
            print("\\n🚀 To run the actual ETL process:")
            print("   python IntegrationPackageUpsert.py")
            print("\\n   or")
            print("\\n   from IntegrationPackageUpsert import create_package_upsert")
            print("   orchestrator = create_package_upsert('XEROBLUE', config)")
            print("   result = orchestrator.execute_full_sync()")
        else:
            print("\\n❌ Tests failed. Please fix issues before proceeding.")
            sys.exit(1)
            
    except Exception as e:
        print(f"\\n💥 Test execution failed: {str(e)}")
        traceback.print_exc()
        sys.exit(1)