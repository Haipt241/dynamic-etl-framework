"""
QBO Integration Template

Simple template that inherits from DynamicIntegration.
Only contains integration-specific customizations.

Replace placeholders:
- QBO - Integration name (e.g., "QBO", "Salesforce")
- qbo - Lowercase integration name
- QBO - Uppercase integration name
- __API_BASE_URL__ - API base URL
- __AUTH_TYPE__ - Authentication type
"""

import os
import sys
import json
from typing import Dict, List, Optional, Any

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from dynamic_integrations.generator.integration_dynamic import DynamicIntegration
from dynamic_integrations.generator.utils import Utils


class QBOIntegration(DynamicIntegration):
    """
    QBO Integration
    
    Inherits from DynamicIntegration and provides QBO-specific customizations.
    """
    
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        """Initialize QBO integration with schema-based configuration"""
        # Load integration-specific config for non-schema items
        integration_config = Utils.load_integration_config('QBO')
        
        # Base configuration for QBO - minimal, let schema handle the rest
        base_config = {
            'integration_name': 'qbo',
            'endpoints': [   'Account',
    'Customer',
    'Vendor',
    'Item',
    'Employee',
    'Class',
    'Department',
    'TaxCode',
    'PaymentMethod',
    'Term',
    'Currency',
    'Invoice',
    'Bill',
    'Payment',
    'BillPayment',
    'SalesReceipt',
    'Estimate',
    'PurchaseOrder',
    'JournalEntry',
    'CreditMemo',
    'VendorCredit',
    'Deposit',
    'Transfer',
    'RefundReceipt',
    'TimeActivity',
    'Preferences',
    'TaxRate',
    'TaxService',
    'ProfitAndLoss',
    'BalanceSheet',
    'CashFlow',
    'GeneralLedger',
    'TrialBalance',
    'AgedReceivables',
    'AgedPayables',
    'ClassSales',
    'DepartmentSales']
        }

        # Merge base config with integration config, then provided config
        merged_config = {**base_config, **integration_config, **(config or {})}

        # Initialize parent class
        super().__init__(merged_config)

        # Schema will be loaded automatically when needed via _extract_schema_config()
        # IMPORTANT: setup_configuration() MUST run BEFORE validate_configuration()
        self.setup_configuration()
        print(f"✅ QBO Integration initialized: {self.integration_name}")
    
    def validate_configuration(self) -> bool:
        """
        Validate the QBO integration configuration
        
        Validates configuration values that were set during setup_configuration().
        
        Returns:
            bool: True if configuration is valid, False otherwise
        """
        try:
            # First run parent class validation (auth credentials, etc.)
            if not super().validate_configuration():
                return False
            
            # Load integration-specific configuration
            config = Utils.load_integration_config('QBO')
            
            # Validate required attributes (set during setup_configuration)
            env_vars_config = config.get('env_vars_config', {})
            missing_attrs = []
            
            for attr_name, config_data in env_vars_config.items():
                if not hasattr(self, attr_name) or getattr(self, attr_name) is None:
                    missing_attrs.append(attr_name)
            
            if missing_attrs:
                print(f"Missing required configuration attributes: {missing_attrs}")
                return False
            
            # Validate attribute values using validation rules
            env_var_validations = config.get('env_var_validations', {})
            
            for env_var, validation_rule in env_var_validations.items():
                # Find corresponding attribute name
                attr_name = None
                for attr, conf in env_vars_config.items():
                    if conf.get('env_var') == env_var:
                        attr_name = attr
                        break
                
                if attr_name and hasattr(self, attr_name):
                    value = getattr(self, attr_name)
                    if value:
                        try:
                            # Convert string validation rule to function
                            validation_func = eval(validation_rule)
                            if not validation_func(str(value)):
                                print(f"Invalid {attr_name} format: {value}")
                                return False
                        except Exception as e:
                            print(f"Error validating {attr_name}: {e}")
                            return False
            
            return True
            
        except Exception as e:
            print(f"❌ Configuration validation failed: {str(e)}")
            return False
    
    def setup_configuration(self):
        """Setup QBO-specific configuration from config file"""
        # Load integration-specific configuration
        config = Utils.load_integration_config('QBO')
        
        # Get environment variables configuration from config
        env_vars_config = config.get('env_vars_config', {})
        
        # Set instance attributes from config defaults (prioritize env vars if available)
        for attr_name, config_data in env_vars_config.items():
            env_var = config_data.get('env_var')
            default_value = config_data.get('default_value')
            
            if env_var and default_value is not None:
                # Use environment variable if exists, otherwise use config default
                value = os.getenv(env_var, default_value)
                setattr(self, attr_name, value)
                
                # Log source of value for debugging (mask sensitive fields)
                source = 'environment' if os.getenv(env_var) else 'config default'

                # Sensitive fields that should be masked
                sensitive_fields = ['secret', 'password', 'token', 'key', 'credential']
                is_sensitive = any(field in attr_name.lower() for field in sensitive_fields)

                if is_sensitive and value:
                    # Mask sensitive values - show only first 4 and last 4 chars
                    if len(str(value)) > 12:
                        masked_value = f"{str(value)[:4]}...{str(value)[-4:]}"
                    else:
                        masked_value = "***"
                    print(f"📝 {attr_name}: {masked_value} (from {source}) [MASKED]")
                else:
                    print(f"📝 {attr_name}: {value} (from {source})")
        
        # Additional configuration logic for table prefixes (if applicable)
        try:
            if hasattr(self, 'etani_client_id') and hasattr(self, 'etani_organisation_id'):
                client_number = self.etani_client_id[self.etani_client_id.find('CLIENT') + len('CLIENT'):]
                if client_number:
                    self.table_prefix_eva = f'c{client_number}_{self.etani_organisation_id}_qbo_'
                    self.table_client_eva = f"c{client_number}_qbo_"
                    self.client_id_number = client_number
        except Exception as e:
            print(f"Warning: Could not generate table prefixes: {e}")
    
    @property
    def integration_name(self) -> str:
        """Return integration name"""
        return "QBO"
    
    # API-specific methods will be inserted here by LLM


def main():
    """Main function for standalone execution with orchestrator"""
    print(f"🚀 QBO Integration - Standalone Execution")
    print("-" * 55)
    
    try:
        # Import the dynamic orchestrator
        from dynamic_integrations import create_package_upsert

        # Configuration for integration
        config = {
            'rate_limit': 100,
            'debug': True,
        }
        
        print(f"Creating QBO integration instance...")
        integration = QBOIntegration(config)
        
        # Validate configuration
        is_valid = integration.validate_configuration()
        print(f"Configuration valid: {is_valid}")
        
        if not is_valid:
            print("❌ Configuration invalid")
            if hasattr(integration, 'error_list') and integration.error_list:
                for error in integration.error_list:
                    print(f"  - {error}")
            return
        
        print(f"✅ Integration created: {integration.integration_name}")
        if hasattr(integration, 'capabilities'):
            print(f"   Capabilities: {integration.capabilities.value}")
            print(f"   Supports UPSERT: {integration.supports_upsert()}")
        
        # Get available endpoints
        endpoints = integration.get_endpoints_list()
        print(f"   Available endpoints ({len(endpoints)}): {', '.join(endpoints[:5])}{'...' if len(endpoints) > 5 else ''}")
        
        print("Creating integration orchestrator...")
        orchestrator = create_package_upsert(integration)
        
        # Get orchestrator info
        info = orchestrator.get_integration_info()
        print(f"✅ Orchestrator created for: {info.get('integration_name')}")
        print(f"   Operation mode: {info.get('operation_mode')}")
        print(f"   Execution ID: {orchestrator.execution_id}")
        
        # Run integration
        print(f"\n🔄 Running QBO integration...")
        result = orchestrator.run()

        # Show results
        print(f"\n📊 Results:")
        print(f"  Status: {result.get('status')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        print(f"  Execution ID: {result.get('execution_id')}")
        
        if result.get('status') == 'completed':
            print(f"✅ QBO Integration completed successfully!")
            
            # Show endpoint results
            endpoint_results = result.get('endpoint_results', {})
            if endpoint_results:
                print(f"\n📋 QBO Endpoint Results:")
                for endpoint_name, endpoint_result in endpoint_results.items():
                    if endpoint_result.get('status') == 'completed':
                        records = endpoint_result.get('records_processed', 0)
                        print(f"  ✅ {endpoint_name}: {records} records processed")
        else:
            print(f"❌ QBO Integration failed or completed with errors")
            
            # Show detailed errors
            print(f"\n🔍 DETAILED QBO ERROR ANALYSIS:")
            print("=" * 50)
            
            # Main error
            main_error = result.get('error', 'Unknown error')
            print(f"📋 Main Error: {main_error}")
            
            # Endpoint-specific errors
            endpoint_results = result.get('endpoint_results', {})
            if endpoint_results:
                print(f"\n📊 QBO Endpoint-Specific Errors:")
                for endpoint_name, endpoint_result in endpoint_results.items():
                    if endpoint_result.get('status') != 'completed':
                        print(f"\n  🔴 {endpoint_name.upper()} ENDPOINT:")
                        print(f"     Status: {endpoint_result.get('status', 'unknown')}")
                        if endpoint_result.get('error'):
                            print(f"     Error: {endpoint_result.get('error')}")
        
    except Exception as e:
        print(f"❌ QBO Integration execution failed: {str(e)}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()
