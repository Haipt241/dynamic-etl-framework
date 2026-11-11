#!/usr/bin/env python3
"""
Integration-Agnostic Example

This example demonstrates the new truly integration-agnostic approach where
you can create any integration without modifying IntegrationPackage.py.

Key Features Demonstrated:
1. Creating custom integrations by inheriting from BaseIntegration
2. Registration system for name-based lookup
3. Plug-and-play architecture
4. Both instance-based and name-based orchestrator creation
"""

import os
import sys
from typing import Dict, Any, Optional, List

# Add path

# Import the new integration-agnostic components
from dynamic_integrations import (
    BaseIntegration,
    IntegrationCapability,
    create_integration_package,
    create_package_upsert,
    register_integration,
    list_registered_integrations,
    OperationMode
)

# ===================================================================================
# EXAMPLE 1: Creating a Simple UPSERT-Only Integration
# ===================================================================================

class SimpleApiIntegration(BaseIntegration):
    """
    Example of a simple integration that only supports UPSERT operations
    
    This could be for any API - Salesforce, HubSpot, etc.
    """
    
    @property
    def integration_name(self) -> str:
        return "SIMPLE_API"
    
    @property
    def capabilities(self) -> IntegrationCapability:
        return IntegrationCapability.UPSERT
    
    def validate_configuration(self) -> bool:
        """Validate that we have required configuration"""
        required_keys = ['api_key', 'base_url']
        for key in required_keys:
            if key not in self.config:
                print(f"❌ Missing required config: {key}")
                return False
        return True
    
    def run_full_sync(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """Simulate API synchronization"""
        print(f"🔄 Running SIMPLE_API sync...")
        print(f"   API Key: {self.config.get('api_key', 'N/A')}")
        print(f"   Base URL: {self.config.get('base_url', 'N/A')}")
        print(f"   Endpoints: {endpoint_list or 'all'}")
        
        # Simulate processing
        import time
        time.sleep(1)
        
        return {
            'status': 'completed',
            'integration_name': self.integration_name,
            'total_endpoints': len(endpoint_list) if endpoint_list else 5,
            'successful_endpoints': len(endpoint_list) if endpoint_list else 5,
            'total_records_processed': 1250,
            'duration_seconds': 1.0
        }

# ===================================================================================
# EXAMPLE 2: Creating a Full-Featured Integration (INSERT + UPSERT)
# ===================================================================================

class AdvancedIntegration(BaseIntegration):
    """
    Example of a full-featured integration that supports both INSERT and UPSERT
    
    This demonstrates how to implement all optional methods for maximum functionality.
    """
    
    @property
    def integration_name(self) -> str:
        return "ADVANCED_SYSTEM"
    
    @property
    def capabilities(self) -> IntegrationCapability:
        return IntegrationCapability.BOTH
    
    def validate_configuration(self) -> bool:
        """Comprehensive configuration validation"""
        required_keys = ['client_id', 'organisation_id', 'api_credentials']
        for key in required_keys:
            if key not in self.config:
                print(f"❌ Missing required config: {key}")
                return False
        
        print(f"✅ Configuration validated for {self.integration_name}")
        return True
    
    # INSERT interface implementation
    def get_insert_configuration(self) -> Dict[str, Any]:
        """Configuration for INSERT operations"""
        return {
            'integration_name': self.integration_name,
            'client_id': self.config['client_id'],
            'organisation_id': self.config['organisation_id'],
            'legacy_client_id': f"LEGACY_{self.config['client_id']}",
            'base_currency': 'USD',
            'fx_currencies': ['USD', 'EUR', 'GBP', 'AUD'],
            'error_list': []
        }
    
    def create_sql_objects(self, parallel: bool = True) -> bool:
        """Custom SQL object creation"""
        print(f"🔨 Creating SQL objects for {self.integration_name} (parallel={parallel})")
        print("   - Creating tables...")
        print("   - Creating views...")
        print("   - Creating stored procedures...")
        
        # Simulate SQL object creation
        import time
        time.sleep(2)
        
        print("✅ SQL objects created successfully")
        return True
    
    def initialize_indexes(self) -> bool:
        """Custom index initialization"""
        print(f"🔍 Initializing indexes for {self.integration_name}")
        print("   - Creating primary indexes...")
        print("   - Creating foreign key indexes...")
        print("   - Creating performance indexes...")
        
        # Simulate index creation
        import time
        time.sleep(1)
        
        print("✅ Indexes initialized successfully")
        return True
    
    def upload_powerbi_template(self, workspace_id: str = None) -> bool:
        """Custom PowerBI template upload"""
        print(f"📊 Uploading PowerBI template for {self.integration_name}")
        if workspace_id:
            print(f"   Workspace ID: {workspace_id}")
        
        # Simulate PowerBI upload
        import time
        time.sleep(1)
        
        print("✅ PowerBI template uploaded successfully")
        return True
    
    # UPSERT interface implementation
    def run_full_sync(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """Advanced synchronization with detailed logging"""
        available_endpoints = self.get_endpoints_list()
        endpoints_to_process = endpoint_list or available_endpoints
        
        print(f"🚀 Running {self.integration_name} full synchronization")
        print(f"   Available endpoints: {available_endpoints}")
        print(f"   Processing endpoints: {endpoints_to_process}")
        
        # Simulate processing each endpoint
        processed_records = 0
        successful_endpoints = 0
        
        for endpoint in endpoints_to_process:
            print(f"   📈 Processing {endpoint}...")
            # Simulate processing time
            import time
            time.sleep(0.5)
            
            records = 100 + (len(endpoint) * 10)  # Simulate variable record counts
            processed_records += records
            successful_endpoints += 1
            print(f"      ✅ {records} records processed")
        
        return {
            'status': 'completed',
            'integration_name': self.integration_name,
            'total_endpoints': len(endpoints_to_process),
            'successful_endpoints': successful_endpoints,
            'total_records_processed': processed_records,
            'duration_seconds': len(endpoints_to_process) * 0.5,
            'endpoint_details': {ep: 100 + (len(ep) * 10) for ep in endpoints_to_process}
        }
    
    def extract_api_response(self, endpoint: str) -> Dict[str, Any]:
        """Extract single endpoint with detailed response"""
        print(f"🎯 Extracting single endpoint: {endpoint}")
        
        # Simulate API call
        import time
        time.sleep(0.3)
        
        records = 100 + (len(endpoint) * 10)
        
        return {
            'status': 'completed',
            'endpoint': endpoint,
            'records_processed': records,
            'integration_name': self.integration_name,
            'extraction_time': 0.3
        }
    
    def get_endpoints_list(self) -> List[str]:
        """Return available endpoints"""
        return ['customers', 'orders', 'products', 'invoices', 'payments', 'reports']

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

# ===================================================================================
# EXAMPLE 3: INSERT-Only Integration (e.g., Data Warehouse Setup)
# ===================================================================================

class DataWarehouseSetup(BaseIntegration):
    """
    Example of an INSERT-only integration for setting up data warehouse infrastructure
    """
    
    @property
    def integration_name(self) -> str:
        return "DATA_WAREHOUSE"
    
    @property
    def capabilities(self) -> IntegrationCapability:
        return IntegrationCapability.INSERT
    
    def validate_configuration(self) -> bool:
        """Validate data warehouse configuration"""
        required_keys = ['warehouse_name', 'client_id', 'organisation_id']
        for key in required_keys:
            if key not in self.config:
                print(f"❌ Missing required config: {key}")
                return False
        return True
    
    def get_insert_configuration(self) -> Dict[str, Any]:
        """Configuration for data warehouse setup"""
        return {
            'integration_name': self.integration_name,
            'client_id': self.config['client_id'],
            'organisation_id': self.config['organisation_id'],
            'legacy_client_id': f"DW_{self.config['client_id']}",
            'base_currency': self.config.get('base_currency', 'USD'),
            'fx_currencies': self.config.get('fx_currencies', ['USD', 'EUR']),
            'error_list': []
        }

# ===================================================================================
# DEMONSTRATION FUNCTIONS
# ===================================================================================

def demonstrate_simple_integration():
    """Demonstrate the simple API integration"""
    print("\\n" + "="*80)
    print("DEMONSTRATION 1: Simple UPSERT-Only Integration")
    print("="*80)
    
    # Configuration
    config = {
        'api_key': 'REDACTED',
        'base_url': 'https://api.example.com/v2',
        'rate_limit': 100
    }
    
    # Create integration instance
    simple_integration = SimpleApiIntegration(config)
    print(f"Created integration: {simple_integration}")
    print(f"Capabilities: {simple_integration.capabilities.value}")
    print(f"Supports UPSERT: {simple_integration.supports_upsert()}")
    print(f"Supports INSERT: {simple_integration.supports_insert()}")
    
    # Method 1: Use integration instance directly (new approach)
    print("\\n📦 Method 1: Using integration instance directly")
    orchestrator = create_package_upsert(simple_integration)
    result = orchestrator.run(endpoint_list=['customers', 'orders'])
    print(f"Result: {result['status']} - {result['total_records_processed']} records")
    
    # Method 2: Register and use by name
    print("\\n📦 Method 2: Register integration and use by name")
    register_integration('SIMPLE_API', SimpleApiIntegration)
    orchestrator2 = create_package_upsert('SIMPLE_API', config)
    result2 = orchestrator2.run(endpoint_list=['products'])
    print(f"Result: {result2['status']} - {result2['total_records_processed']} records")

def demonstrate_advanced_integration():
    """Demonstrate the advanced full-featured integration"""
    print("\\n" + "="*80)
    print("DEMONSTRATION 2: Advanced Full-Featured Integration")
    print("="*80)
    
    # Configuration
    config = {
        'client_id': 'ADVANCED_CLIENT_001',
        'organisation_id': 'ORG_12345',
        'api_credentials': {'username': 'demo', 'password': 'REDACTED'},
        'base_currency': 'EUR',
        'fx_currencies': ['EUR', 'USD', 'GBP']
    }
    
    # Create integration instance
    advanced_integration = AdvancedIntegration(config)
    print(f"Created integration: {advanced_integration}")
    print(f"Capabilities: {advanced_integration.capabilities.value}")
    
    # Demonstrate INSERT operations
    print("\\n🔨 INSERT Operations Demonstration")
    orchestrator_insert = create_integration_package(advanced_integration, OperationMode.INSERT)
    insert_result = orchestrator_insert.run_initialization(
        create_objects=True,
        initialize_indexes=True,
        upload_pbi=True,
        workspace_id="demo-workspace-123"
    )
    print(f"INSERT Result: {insert_result['status']}")
    
    # Demonstrate UPSERT operations
    print("\\n🔄 UPSERT Operations Demonstration")
    orchestrator_upsert = create_integration_package(advanced_integration, OperationMode.UPSERT)
    upsert_result = orchestrator_upsert.run(endpoint_list=['customers', 'orders', 'products'])
    print(f"UPSERT Result: {upsert_result['status']} - {upsert_result['total_records_processed']} records")
    
    # Demonstrate single endpoint processing
    print("\\n🎯 Single Endpoint Demonstration")
    single_result = orchestrator_upsert.run_single_endpoint('invoices')
    print(f"Single endpoint result: {single_result['records_processed']} records")

def demonstrate_data_warehouse_setup():
    """Demonstrate the INSERT-only data warehouse setup"""
    print("\\n" + "="*80)
    print("DEMONSTRATION 3: INSERT-Only Data Warehouse Setup")
    print("="*80)
    
    # Configuration
    config = {
        'warehouse_name': 'CLIENT_DW_001',
        'client_id': 'DW_CLIENT_001',
        'organisation_id': 'DW_ORG_001',
        'base_currency': 'AUD'
    }
    
    # Create integration instance
    dw_integration = DataWarehouseSetup(config)
    print(f"Created integration: {dw_integration}")
    print(f"Capabilities: {dw_integration.capabilities.value}")
    print(f"Supports INSERT: {dw_integration.supports_insert()}")
    print(f"Supports UPSERT: {dw_integration.supports_upsert()}")
    
    # This integration only supports INSERT, so UPSERT will fail
    print("\\n❌ Attempting UPSERT (should fail)")
    try:
        orchestrator = create_package_upsert(dw_integration)
        print("This should not print!")
    except ValueError as e:
        print(f"✅ Expected error: {e}")
    
    # Use INSERT mode (will work)
    print("\\n✅ Using INSERT mode (should work)")
    orchestrator = create_integration_package(dw_integration, OperationMode.INSERT)
    result = orchestrator.run_initialization(create_objects=False)  # Skip actual creation for demo
    print(f"INSERT Result: {result['status']}")

def demonstrate_registry_system():
    """Demonstrate the integration registry system"""
    print("\\n" + "="*80)
    print("DEMONSTRATION 4: Integration Registry System")
    print("="*80)
    
    # Register all our integrations
    register_integration('SIMPLE_API', SimpleApiIntegration)
    register_integration('ADVANCED_SYSTEM', AdvancedIntegration)
    register_integration('DATA_WAREHOUSE', DataWarehouseSetup)
    
    # List registered integrations
    registered = list_registered_integrations()
    print(f"📋 Registered integrations: {registered}")
    
    # Create integrations by name
    configs = {
        'SIMPLE_API': {'api_key': 'test', 'base_url': 'https://test.com'},
        'ADVANCED_SYSTEM': {'client_id': 'test', 'organisation_id': 'test', 'api_credentials': {}},
        'DATA_WAREHOUSE': {'warehouse_name': 'test', 'client_id': 'test', 'organisation_id': 'test'}
    }
    
    for integration_name in registered:
        print(f"\\n🏭 Creating {integration_name} from registry...")
        config = configs.get(integration_name, {})
        
        try:
            orchestrator = create_package_upsert(integration_name, config)
            print(f"✅ {integration_name}: {orchestrator.operation_mode.value} mode")
        except ValueError as e:
            print(f"ℹ️  {integration_name}: {e}")

def main():
    """Run all demonstrations"""
    print("🚀 Integration-Agnostic Dynamic Orchestrator Demonstrations")
    print("This example shows how to create integrations without modifying IntegrationPackage.py")
    
    # Run demonstrations
    demonstrate_simple_integration()
    demonstrate_advanced_integration()
    demonstrate_data_warehouse_setup()
    demonstrate_registry_system()
    
    print("\\n" + "="*80)
    print("🎉 ALL DEMONSTRATIONS COMPLETED!")
    print("="*80)
    print("\\nKey Takeaways:")
    print("1. ✅ Create any integration by inheriting from BaseIntegration")
    print("2. ✅ No need to modify IntegrationPackage.py for new integrations")
    print("3. ✅ Use integration instances directly (recommended)")
    print("4. ✅ Or register integrations for name-based lookup")
    print("5. ✅ Support INSERT-only, UPSERT-only, or both operations")
    print("6. ✅ Automatic capability detection and validation")
    print("7. ✅ Fully plug-and-play architecture")
    
    print("\\n📚 Next Steps:")
    print("- Create your own integration by inheriting from BaseIntegration")
    print("- Implement the required methods for your integration type")
    print("- Use create_integration_package() with your integration instance")
    print("- Optionally register your integration for name-based access")

if __name__ == "__main__":
    main()