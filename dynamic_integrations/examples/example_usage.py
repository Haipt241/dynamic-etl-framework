"""
Example Usage of the Plug-and-Play ETL Integration System

This file demonstrates how to use the new package upsert system with different integrations.
"""

import os
import sys
from typing import Dict, Any

# Add the current directory to Python path for imports

from IntegrationPackageUpsert import PackageUpsertOrchestrator, create_package_upsert
from integrations.xeroblue_integration import XeroBlueIntegration

def example_xeroblue_usage():
    """
    Example: Using XeroBlue integration directly
    """
    print("=== XeroBlue Integration Example ===")
    
    try:
        # Configuration for XeroBlue
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'max_retries': 3,
            'debug': True
        }
        
        # Create XeroBlue integration instance
        xeroblue_integration = XeroBlueIntegration(config)
        
        # Create orchestrator
        orchestrator = PackageUpsertOrchestrator(xeroblue_integration, config)
        
        # Run the ETL process
        result = orchestrator.execute_full_sync()
        
        print(f"XeroBlue ETL Result: {result['status']}")
        print(f"Processed {result['total_records_processed']} records")
        print(f"Successful endpoints: {result['successful_endpoints']}")
        
        if result['failed_endpoints']:
            print(f"Failed endpoints: {result['failed_endpoints']}")
        
        return result
        
    except Exception as e:
        print(f"XeroBlue ETL failed: {str(e)}")
        return None

def example_factory_usage():
    """
    Example: Using the factory function for dynamic integration loading
    """
    print("\\n=== Factory Pattern Example ===")
    
    try:
        # Configuration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900
        }
        
        # Use factory to create orchestrator
        orchestrator = create_package_upsert('XEROBLUE', config)
        
        # Run ETL
        result = orchestrator.execute_full_sync()
        
        print(f"Factory ETL Result: {result['status']}")
        return result
        
    except Exception as e:
        print(f"Factory ETL failed: {str(e)}")
        return None

def example_environment_based_usage():
    """
    Example: Using environment variable to determine integration type
    """
    print("\\n=== Environment-Based Example ===")
    
    try:
        # Get integration type from environment (with fallback)
        integration_type = os.getenv('INTEGRATION_TYPE', 'XEROBLUE')
        
        print(f"Using integration type: {integration_type}")
        
        # Configuration
        config = {
            'rate_limit': int(os.getenv('API_RATE_LIMIT', '60')),
            'timeout_seconds': int(os.getenv('API_TIMEOUT', '900')),
            'debug': os.getenv('DEBUG', 'false').lower() == 'true'
        }
        
        # Create and run
        orchestrator = create_package_upsert(integration_type, config)
        result = orchestrator.execute_full_sync()
        
        print(f"Environment-based ETL Result: {result['status']}")
        return result
        
    except Exception as e:
        print(f"Environment-based ETL failed: {str(e)}")
        return None

def example_single_endpoint_test():
    """
    Example: Testing a single endpoint
    """
    print("\\n=== Single Endpoint Test ===")
    
    try:
        from implementations.BaseRequestManager import BaseRequestManager
        from implementations.BaseTokenManager import BaseTokenManager
        from integrations.xeroblue_integration import XeroBlueIntegration
        
        # Create integration
        config = {'rate_limit': 60, 'timeout_seconds': 900}
        integration = XeroBlueIntegration(config)
        
        # Create token manager
        token_file = "test_client_test_org.txt"
        token_manager = BaseTokenManager(integration, token_file)
        
        # Test single endpoint
        endpoint = "Organisations"
        
        print(f"Testing endpoint: {endpoint}")
        
        # Create request manager and make call
        with BaseRequestManager(integration, token_manager, endpoint) as data:
            if data is not None and not data.empty:
                print(f"Successfully retrieved {len(data)} records from {endpoint}")
                print(f"Columns: {list(data.columns)}")
                return data
            else:
                print(f"No data returned from {endpoint}")
                return None
                
    except Exception as e:
        print(f"Single endpoint test failed: {str(e)}")
        return None

def validate_system_setup():
    """
    Validate that the system is properly set up
    """
    print("=== System Validation ===")
    
    required_env_vars = [
        'EtaniClientID',
        'EtaniOrganisationID',
        'XeroTenantID',
        'xeroblue_client_id',
        'xeroblue_client_secret',
        'AZ_FILE_SHARE',
        'AZ_FILE_SHARE_KEY'
    ]
    
    missing_vars = []
    for var in required_env_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"⚠️  Missing environment variables: {missing_vars}")
        print("Please set these variables before running the ETL process.")
        return False
    else:
        print("✅ All required environment variables are set")
        return True

def show_integration_capabilities():
    """
    Show what integrations are available and their capabilities
    """
    print("\\n=== Available Integrations ===")
    
    try:
        from integrations import AVAILABLE_INTEGRATIONS
        
        for name, integration_class in AVAILABLE_INTEGRATIONS.items():
            print(f"\\nIntegration: {name}")
            
            # Create instance to show capabilities
            try:
                config = {'rate_limit': 60}
                instance = integration_class(config)
                
                print(f"  - Name: {instance.integration_name}")
                print(f"  - Table Prefix: {instance.table_prefix}")
                print(f"  - Rate Limit: {instance.rate_limit} calls/minute")
                print(f"  - Endpoints: {len(instance.get_endpoints_list())} available")
                print(f"  - Sample Endpoints: {instance.get_endpoints_list()[:5]}")
                
            except Exception as e:
                print(f"  - Error creating instance: {str(e)}")
    
    except Exception as e:
        print(f"Error loading integrations: {str(e)}")

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
    """
    Main execution - run examples based on command line arguments
    """
    import sys
    
    # Show system capabilities
    show_integration_capabilities()
    
    # Validate setup
    if not validate_system_setup():
        print("\\n❌ System validation failed. Please fix environment setup.")
        sys.exit(1)
    
    # Run examples based on command line argument
    if len(sys.argv) > 1:
        example_type = sys.argv[1].lower()
        
        if example_type == 'direct':
            result = example_xeroblue_usage()
        elif example_type == 'factory':
            result = example_factory_usage()
        elif example_type == 'env':
            result = example_environment_based_usage()
        elif example_type == 'single':
            result = example_single_endpoint_test()
        else:
            print(f"Unknown example type: {example_type}")
            print("Available types: direct, factory, env, single")
            sys.exit(1)
    else:
        print("\\n=== Running All Examples ===")
        
        # Run all examples
        example_xeroblue_usage()
        example_factory_usage()
        example_environment_based_usage()
        example_single_endpoint_test()
    
    print("\\n✅ Examples completed!")