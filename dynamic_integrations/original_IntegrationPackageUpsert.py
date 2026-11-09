"""
Generic Integration Package Upsert Orchestrator

This module provides a generic orchestrator for any integration package.
It handles the common workflow patterns while delegating integration-specific
logic to the individual integration classes.

Key Features:
- Generic orchestrator that works with any integration
- Standardized interface for all integrations  
- Common error handling and logging
- Plug-and-play architecture

Usage:
    from IntegrationPackageUpsert import create_package_upsert
    
    # Create and run any integration
    config = {'rate_limit': 60}
    orchestrator = create_package_upsert('XEROBLUE', config)
    result = orchestrator.run()
"""

import os
import sys
import time
import logging
from typing import Dict, Any, Optional, List
from datetime import datetime

# Add path for imports

class IntegrationPackageUpsert:
    """
    Generic Integration Package Orchestrator
    
    This class provides a standardized interface for running any integration.
    It delegates ALL integration-specific logic to the integration class itself.
    The orchestrator just coordinates the workflow.
    """
    
    def __init__(self, integration_instance, config: Optional[Dict[str, Any]] = None):
        """
        Initialize the generic orchestrator
        
        Args:
            integration_instance: The specific integration class instance (must have standardized interface)
            config: Optional configuration dictionary
        """
        self.integration = integration_instance
        self.config = config or {}
        self.setup_logging()
        
        # Execution tracking
        self.start_time = time.time()
        self.execution_id = f"{self.integration.integration_name}_{int(self.start_time)}"
    
    def setup_logging(self):
        """Setup logging for the orchestrator"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(f"Orchestrator.{self.integration.integration_name}")
    
    def validate_integration(self) -> bool:
        """
        Validate that the integration instance has the required standardized interface
        
        Required interface for any integration:
        - integration_name: str attribute
        - validate_configuration(): bool method
        - run_full_sync(endpoint_list): Dict method
        
        Returns:
            bool: True if integration is valid, False otherwise
        """
        required_attributes = ['integration_name']
        required_methods = ['validate_configuration', 'run_full_sync']
        
        # Check required attributes
        missing_attributes = []
        for attr in required_attributes:
            if not hasattr(self.integration, attr):
                missing_attributes.append(attr)
        
        # Check required methods
        missing_methods = []
        for method in required_methods:
            if not hasattr(self.integration, method) or not callable(getattr(self.integration, method)):
                missing_methods.append(method)
        
        if missing_attributes or missing_methods:
            self.logger.error(f"Integration interface validation failed:")
            if missing_attributes:
                self.logger.error(f"  Missing attributes: {missing_attributes}")
            if missing_methods:
                self.logger.error(f"  Missing methods: {missing_methods}")
            return False
        
        self.logger.info(f"Integration {self.integration.integration_name} interface validated successfully")
        return True
    
    def run(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """
        Run the integration orchestrator - the main entry point
        
        This method coordinates the workflow but delegates all business logic
        to the integration class itself.
        
        Args:
            endpoint_list: Optional list of specific endpoints to process
            
        Returns:
            Dict containing execution results
        """
        self.logger.info(f"Starting Generic Integration Orchestrator")
        self.logger.info(f"Integration: {self.integration.integration_name}")
        self.logger.info(f"Execution ID: {self.execution_id}")
        
        try:
            # Step 1: Validate integration interface
            self.logger.info("Step 1: Validating integration interface...")
            if not self.validate_integration():
                return self._create_error_result('Integration interface validation failed')
            
            # Step 2: Let integration validate its own configuration
            self.logger.info("Step 2: Validating integration configuration...")
            if not self.integration.validate_configuration():
                return self._create_error_result('Integration configuration validation failed')
            
            # Step 3: Run the integration (all business logic handled by integration)
            self.logger.info(f"Step 3: Running {self.integration.integration_name} integration...")
            result = self.integration.run_full_sync(endpoint_list)
            
            # Step 4: Add orchestrator metadata
            end_time = time.time()
            orchestrator_metadata = {
                'execution_id': self.execution_id,
                'orchestrator_duration': end_time - self.start_time,
                'integration_name': self.integration.integration_name,
                'orchestrator_version': '2.0.0',
                'workflow_steps': ['interface_validation', 'config_validation', 'integration_execution']
            }
            
            # Merge orchestrator metadata with integration results
            if isinstance(result, dict):
                result.update(orchestrator_metadata)
            else:
                result = orchestrator_metadata
                result['integration_result'] = result
            
            # Step 5: Log summary
            self._log_orchestrator_summary(result)
            
            self.logger.info(f"Generic Integration Orchestrator completed successfully")
            return result
            
        except Exception as e:
            error_msg = f"Orchestrator execution failed: {str(e)}"
            self.logger.error(error_msg)
            return self._create_error_result(error_msg, exception=e)
    
    def run_single_endpoint(self, endpoint: str) -> Dict[str, Any]:
        """
        Run a single endpoint through the integration
        
        Args:
            endpoint: The endpoint to process
            
        Returns:
            Dict containing execution results for the endpoint
        """
        self.logger.info(f"Running single endpoint: {endpoint}")
        
        try:
            # Validate integration interface
            if not self.validate_integration():
                return self._create_error_result(f'Integration interface validation failed for endpoint {endpoint}')
            
            # Check if integration has extract_api_response method for single endpoint processing
            if hasattr(self.integration, 'extract_api_response'):
                self.logger.info(f"Using extract_api_response method for endpoint {endpoint}")
                result = self.integration.extract_api_response(endpoint)
            else:
                # Fallback to run_full_sync with single endpoint
                self.logger.info(f"Using run_full_sync method for endpoint {endpoint}")
                result = self.integration.run_full_sync([endpoint])
            
            # Add orchestrator metadata
            if isinstance(result, dict):
                result.update({
                    'execution_id': self.execution_id,
                    'single_endpoint_mode': True,
                    'processed_endpoint': endpoint
                })
            
            self.logger.info(f"Single endpoint {endpoint} completed with status: {result.get('status', 'unknown')}")
            return result
            
        except Exception as e:
            error_msg = f"Single endpoint {endpoint} failed: {str(e)}"
            self.logger.error(error_msg)
            return self._create_error_result(error_msg, endpoint=endpoint, exception=e)
    
    def get_integration_info(self) -> Dict[str, Any]:
        """
        Get information about the current integration
        
        Returns:
            Dict containing integration metadata
        """
        info = {
            'integration_name': getattr(self.integration, 'integration_name', 'Unknown'),
            'integration_class': self.integration.__class__.__name__,
            'execution_id': self.execution_id,
            'orchestrator_version': '2.0.0'
        }
        
        # Add optional integration information if available
        optional_attributes = [
            ('get_endpoints_list', 'available_endpoints'),
            ('config', 'config'),
            ('table_prefix', 'table_prefix'),
            ('rate_limit', 'rate_limit')
        ]
        
        for attr_name, info_key in optional_attributes:
            if hasattr(self.integration, attr_name):
                attr_value = getattr(self.integration, attr_name)
                if callable(attr_value):
                    try:
                        info[info_key] = attr_value()
                    except:
                        info[info_key] = "Error retrieving value"
                else:
                    info[info_key] = attr_value
        
        return info
    
    def _create_error_result(self, error_message: str, endpoint: str = None, exception: Exception = None) -> Dict[str, Any]:
        """Create standardized error result"""
        result = {
            'status': 'failed',
            'error': error_message,
            'execution_id': self.execution_id,
            'integration_name': getattr(self.integration, 'integration_name', 'Unknown'),
            'orchestrator_duration': time.time() - self.start_time
        }
        
        if endpoint:
            result['endpoint'] = endpoint
            
        if exception:
            result['exception_type'] = type(exception).__name__
            
        return result
    
    def _log_orchestrator_summary(self, result: Dict[str, Any]):
        """Log orchestrator execution summary"""
        self.logger.info("=" * 80)
        self.logger.info(f"Generic Integration Orchestrator - Execution Summary")
        self.logger.info("=" * 80)
        self.logger.info(f"Integration: {self.integration.integration_name}")
        self.logger.info(f"Execution ID: {self.execution_id}")
        self.logger.info(f"Status: {result.get('status', 'unknown')}")
        self.logger.info(f"Orchestrator Duration: {result.get('orchestrator_duration', 0):.2f}s")
        
        # Log integration-specific results if available
        if 'duration_seconds' in result:
            self.logger.info(f"Integration Duration: {result.get('duration_seconds', 0):.2f}s")
        
        if 'total_endpoints' in result:
            self.logger.info(f"Endpoints: {result.get('successful_endpoints', 0)}/{result.get('total_endpoints', 0)} successful")
        
        if 'total_records_processed' in result:
            self.logger.info(f"Records Processed: {result.get('total_records_processed', 0)}")
        
        if result.get('status') == 'failed':
            self.logger.error(f"Failure Reason: {result.get('error', 'Unknown error')}")
        
        self.logger.info("=" * 80)

def create_package_upsert(integration_name: str, config: Optional[Dict[str, Any]] = None) -> IntegrationPackageUpsert:
    """
    Factory function to create an integration orchestrator for any integration
    
    This factory function instantiates the appropriate integration class and
    wraps it in the generic orchestrator.
    
    Args:
        integration_name: Name of the integration (e.g., 'XEROBLUE', 'MYOB', etc.)
        config: Optional configuration dictionary
        
    Returns:
        IntegrationPackageUpsert instance configured for the specified integration
        
    Raises:
        ValueError: If integration_name is not supported
        ImportError: If integration module cannot be imported
    """
    integration_name = integration_name.upper()
    
    try:
        if integration_name == 'XEROBLUE':
            from integrations.xeroblue_integration_enhanced import XeroBlueIntegrationEnhanced
            integration_instance = XeroBlueIntegrationEnhanced(config)
            
        elif integration_name == 'MYOB':
            # Template for future integrations
            # from integrations.myob_integration import MyobIntegration
            # integration_instance = MyobIntegration(config)
            raise ValueError(f"MYOB integration not yet implemented")
            
        elif integration_name == 'XERO_CUSTOM':
            # Template for future integrations
            # from integrations.xero_custom_integration import XeroCustomIntegration
            # integration_instance = XeroCustomIntegration(config)
            raise ValueError(f"XERO_CUSTOM integration not yet implemented")
            
        else:
            raise ValueError(f"Unsupported integration: {integration_name}. Supported integrations: XEROBLUE")
        
        # Validate integration instance has required interface before creating orchestrator
        required_methods = ['validate_configuration', 'run_full_sync']
        missing_methods = [method for method in required_methods if not hasattr(integration_instance, method)]
        
        if missing_methods:
            raise ValueError(f"Integration {integration_name} missing required methods: {missing_methods}")
        
        if not hasattr(integration_instance, 'integration_name'):
            raise ValueError(f"Integration {integration_name} missing required attribute: integration_name")
        
        return IntegrationPackageUpsert(integration_instance, config)
        
    except ImportError as e:
        raise ImportError(f"Could not import {integration_name} integration: {str(e)}")
    except Exception as e:
        raise Exception(f"Failed to create {integration_name} integration: {str(e)}")

def main():
    """
    Example usage of the generic integration orchestrator
    """
    try:
        # Example configuration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        # Create and run XeroBlue integration using the generic orchestrator
        print("\\n" + "="*60)
        print("Generic Integration Orchestrator - Example Usage")
        print("="*60)
        
        print("Creating XeroBlue integration orchestrator...")
        orchestrator = create_package_upsert('XEROBLUE', config)
        
        # Show integration info
        info = orchestrator.get_integration_info()
        print(f"\\nIntegration Info:")
        for key, value in info.items():
            print(f"  {key}: {value}")
        
        # Run full sync (the orchestrator delegates everything to the integration)
        print("\\nRunning full synchronization...")
        result = orchestrator.run()
        
        # Show results
        print(f"\\nExecution completed with status: {result.get('status')}")
        print(f"Execution ID: {result.get('execution_id')}")
        
        return 0 if result.get('status') in ['completed', 'completed_with_errors'] else 1
        
    except Exception as e:
        print(f"\\nFailed to run integration orchestrator: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1

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
    Entry point for direct execution
    """
    exit_code = main()
    exit(exit_code)