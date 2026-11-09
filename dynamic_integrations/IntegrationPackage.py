"""
Dynamic Integration Package Orchestrator

This module provides a unified, dynamic orchestrator for any integration package 
that can handle both INSERT and UPSERT operations seamlessly.

Key Features:
- Dynamic operation mode (INSERT, UPSERT, or AUTO-detect)
- Unified interface combining both INSERT and UPSERT capabilities
- Generic orchestrator that works with any integration
- Standardized interface for all integrations  
- Common error handling and logging
- Plug-and-play architecture
- Completely integration-agnostic

Usage:
    from IntegrationPackage import create_integration_package
    
    # Create and run any integration with auto-detection
    orchestrator = create_integration_package(integration_instance, operation_mode='AUTO')
    
    # For INSERT operations
    result = orchestrator.run_initialization()
    
    # For UPSERT operations  
    result = orchestrator.run()
    
    # For specific operation mode
    orchestrator = create_integration_package(integration_instance, operation_mode='INSERT')
    result = orchestrator.run_initialization()
"""

import os
import sys
import time
import logging
from typing import Dict, Any, Optional, List, Union
from datetime import datetime
from enum import Enum

# Import path utilities for dynamic path resolution
try:
    from ..path_utils import setup_project_paths
except ImportError:
    try:
        from path_utils import setup_project_paths
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

# Import our integration-agnostic managers and base classes
try:
    from .cms_manager import CMSManager
    from .sql_object_manager import SQLObjectManagerOrchestrator, SQLObjectConfig
    from .base_integration import BaseIntegration, IntegrationRegistry, IntegrationCapability, validate_integration_interface
except ImportError:
    # Fallback for when running as standalone script
    try:
        from cms_manager import CMSManager
        from sql_object_manager import SQLObjectManagerOrchestrator, SQLObjectConfig
        from base_integration import BaseIntegration, IntegrationRegistry, IntegrationCapability, validate_integration_interface
    except ImportError:
        # Final fallback - try to import from parent directories
        try:
            from dynamic_integrations.cms_manager import CMSManager
            from dynamic_integrations.sql_object_manager import SQLObjectManagerOrchestrator, SQLObjectConfig
            from dynamic_integrations.base_integration import BaseIntegration, IntegrationRegistry, IntegrationCapability, validate_integration_interface
        except ImportError:
            raise ImportError("Could not import required modules. Please ensure the project structure is correct.")


class OperationMode(Enum):
    """Enumeration for operation modes"""
    INSERT = "INSERT"
    UPSERT = "UPSERT" 
    AUTO = "AUTO"


class IntegrationPackage:
    """
    Dynamic Integration Package Orchestrator
    
    This class provides a unified interface for running both INSERT and UPSERT operations
    for any integration. It automatically detects the operation mode or allows explicit 
    specification. All integration-specific logic is delegated to the integration class.
    """
    
    def __init__(self, integration_instance, operation_mode: Union[str, OperationMode] = OperationMode.AUTO, 
                 config: Optional[Dict[str, Any]] = None):
        """
        Initialize the dynamic integration orchestrator
        
        Args:
            integration_instance: The specific integration class instance (must inherit from BaseIntegration)
            operation_mode: Operation mode - 'INSERT', 'UPSERT', or 'AUTO' for auto-detection
            config: Optional configuration dictionary
        """
        # Validate that integration instance follows the required interface
        if not isinstance(integration_instance, BaseIntegration):
            raise ValueError(f"Integration instance must inherit from BaseIntegration. "
                           f"Got: {type(integration_instance)}")
        
        self.integration = integration_instance
        self.config = config or {}
        
        # Handle operation mode
        if isinstance(operation_mode, str):
            operation_mode = OperationMode(operation_mode.upper())
        self.operation_mode = operation_mode
        
        # Setup logging first (needed for auto-detection)
        self.setup_logging()
        
        # Auto-detect operation mode if requested
        if self.operation_mode == OperationMode.AUTO:
            self.operation_mode = self._detect_operation_mode()
        
        # Execution tracking
        self.start_time = time.time()
        self.execution_id = self._generate_execution_id()
        
        # Initialize SQL Object Manager if INSERT mode
        if self.operation_mode == OperationMode.INSERT:
            self._initialize_sql_object_manager()
        else:
            self.sql_object_manager = None
    
    def setup_logging(self):
        """Setup logging for the orchestrator"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(f"IntegrationPackage.{self.integration.integration_name}.{self.operation_mode.value}")
    
    def _generate_execution_id(self) -> str:
        """Generate execution ID based on operation mode"""
        timestamp = int(self.start_time)
        if self.operation_mode == OperationMode.INSERT:
            return f"{self.integration.integration_name}_INSERT_{timestamp}"
        else:
            return f"{self.integration.integration_name}_UPSERT_{timestamp}"
    
    def _detect_operation_mode(self) -> OperationMode:
        """
        Auto-detect operation mode based on integration capabilities
        
        Returns:
            OperationMode: Detected operation mode
        """
        capabilities = self.integration.capabilities
        
        if capabilities == IntegrationCapability.INSERT:
            self.logger.info("Auto-detected operation mode: INSERT (integration supports INSERT only)")
            return OperationMode.INSERT
        elif capabilities == IntegrationCapability.UPSERT:
            self.logger.info("Auto-detected operation mode: UPSERT (integration supports UPSERT only)")
            return OperationMode.UPSERT
        elif capabilities == IntegrationCapability.BOTH:
            # Both available - default to UPSERT for backward compatibility
            self.logger.info("Auto-detected operation mode: UPSERT (integration supports both INSERT and UPSERT)")
            return OperationMode.UPSERT
        else:
            # Fallback - should not happen with proper BaseIntegration implementation
            self.logger.warning("Unknown integration capabilities - defaulting to UPSERT")
            return OperationMode.UPSERT
    
    # ===================================================================================
    # VALIDATION METHODS (Unified from both classes)
    # ===================================================================================
    
    def validate_integration_interface(self) -> bool:
        """
        Validate that the integration instance has the required standardized interface
        based on the operation mode
        
        Returns:
            bool: True if integration is valid, False otherwise
        """
        if self.operation_mode == OperationMode.INSERT:
            return self._validate_insert_interface()
        else:
            return self._validate_upsert_interface()
    
    def _validate_insert_interface(self) -> bool:
        """Validate INSERT interface requirements"""
        required_attributes = ['integration_name']
        required_methods = ['validate_configuration', 'get_insert_configuration']
        optional_methods = ['create_sql_objects', 'initialize_indexes', 'upload_powerbi_template']
        
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
            self.logger.error(f"Integration INSERT interface validation failed:")
            if missing_attributes:
                self.logger.error(f"  Missing attributes: {missing_attributes}")
            if missing_methods:
                self.logger.error(f"  Missing methods: {missing_methods}")
            return False
        
        # Log optional methods availability
        available_optional = []
        for method in optional_methods:
            if hasattr(self.integration, method) and callable(getattr(self.integration, method)):
                available_optional.append(method)
        
        if available_optional:
            self.logger.info(f"Optional INSERT methods available: {available_optional}")
        
        self.logger.info(f"Integration {self.integration.integration_name} INSERT interface validated successfully")
        return True
    
    def _validate_upsert_interface(self) -> bool:
        """Validate UPSERT interface requirements"""
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
            self.logger.error(f"Integration UPSERT interface validation failed:")
            if missing_attributes:
                self.logger.error(f"  Missing attributes: {missing_attributes}")
            if missing_methods:
                self.logger.error(f"  Missing methods: {missing_methods}")
            return False
        
        self.logger.info(f"Integration {self.integration.integration_name} UPSERT interface validated successfully")
        return True
    
    # ===================================================================================
    # INSERT OPERATION METHODS (From IntegrationPackageInsert)
    # ===================================================================================
    
    def _initialize_sql_object_manager(self):
        """Initialize SQL Object Manager using integration's configuration"""
        try:
            # Get insert configuration from the integration
            insert_config = self.integration.get_insert_configuration()
            
            sql_config = SQLObjectConfig(
                integration_name=insert_config['integration_name'],
                client_id=insert_config['client_id'],
                organisation_id=insert_config['organisation_id'],
                legacy_client_id=insert_config['legacy_client_id'],
                base_currency=insert_config.get('base_currency', 'AUD'),
                fx_currencies=insert_config.get('fx_currencies', ['AUD', 'USD', 'EUR'])
            )
            
            self.sql_object_manager = SQLObjectManagerOrchestrator(sql_config, insert_config.get('error_list', []))
            self.logger.info(f"[OK] SQL Object Manager initialized for {self.integration.integration_name}")
            
        except Exception as e:
            error_msg = f"Failed to initialize SQL Object Manager: {str(e)}"
            self.logger.error(f"[ERROR] {error_msg}")
            self.sql_object_manager = None
    
    def create_sql_objects(self, parallel: bool = True) -> bool:
        """
        Create all SQL objects (tables, views, stored procedures) for the integration
        
        Args:
            parallel: Whether to create objects in parallel for better performance
            
        Returns:
            True if successful, False otherwise
        """
        if self.operation_mode != OperationMode.INSERT:
            self.logger.warning("create_sql_objects is only available in INSERT mode")
            return False
        
        # Check if integration has custom SQL object creation
        if hasattr(self.integration, 'create_sql_objects') and callable(getattr(self.integration, 'create_sql_objects')):
            self.logger.info(f"Using integration-specific SQL object creation for {self.integration.integration_name}")
            try:
                return self.integration.create_sql_objects(parallel=parallel)
            except Exception as e:
                self.logger.error(f"Integration-specific SQL object creation failed: {str(e)}")
                return False
        
        # Use generic SQL object manager
        if not self.sql_object_manager:
            self.logger.error("SQL Object Manager not initialized")
            return False
        
        try:
            insert_config = self.integration.get_insert_configuration()
            
            self.logger.info(f"🔨 Creating SQL Objects for {self.integration.integration_name}")
            self.logger.info(f"   Client: {insert_config['client_id']}")
            self.logger.info(f"   Organization: {insert_config['organisation_id']}")
            self.logger.info(f"   Legacy Client: {insert_config['legacy_client_id']}")
            self.logger.info(f"   Parallel: {parallel}")
            
            # Create all SQL objects
            results = self.sql_object_manager.create_all_objects(parallel=parallel)
            
            # Validate creation
            success, validation_details = self.sql_object_manager.validate_creation(results)
            
            if success:
                self.logger.info(f"[SUCCESS] SQL objects created successfully for {self.integration.integration_name}")
                return True
            else:
                self.logger.error(f"[ERROR] Failed to create SQL objects for {self.integration.integration_name}")
                return False
                
        except Exception as e:
            self.logger.error(f"[ERROR] Error creating SQL objects for {self.integration.integration_name}: {str(e)}")
            return False
    
    def initialize_indexes(self) -> bool:
        """Initialize all indexes for the integration"""
        if self.operation_mode != OperationMode.INSERT:
            self.logger.warning("initialize_indexes is primarily for INSERT mode")
        
        # Check if integration has custom index initialization
        if hasattr(self.integration, 'initialize_indexes') and callable(getattr(self.integration, 'initialize_indexes')):
            self.logger.info(f"Using integration-specific index initialization for {self.integration.integration_name}")
            try:
                return self.integration.initialize_indexes()
            except Exception as e:
                self.logger.error(f"Integration-specific index initialization failed: {str(e)}")
                return False
        
        # Use generic index initialization
        try:
            self.logger.info(f"[DEBUG] Initializing indexes for {self.integration.integration_name}")
            
            # This would need to be implemented based on integration requirements
            # For now, just return True as placeholder
            self.logger.info(f"[OK] Indexes initialized for {self.integration.integration_name} (placeholder)")
            return True
            
        except Exception as e:
            self.logger.error(f"[ERROR] Error initializing indexes for {self.integration.integration_name}: {str(e)}")
            return False
    
    def upload_powerbi_template(self, workspace_id: str = None) -> bool:
        """Upload PowerBI template for the integration"""
        # Check if integration has custom PowerBI upload
        if hasattr(self.integration, 'upload_powerbi_template') and callable(getattr(self.integration, 'upload_powerbi_template')):
            self.logger.info(f"Using integration-specific PowerBI upload for {self.integration.integration_name}")
            try:
                if workspace_id:
                    return self.integration.upload_powerbi_template(workspace_id)
                else:
                    return self.integration.upload_powerbi_template()
            except Exception as e:
                self.logger.error(f"Integration-specific PowerBI upload failed: {str(e)}")
                return False
        
        # Generic PowerBI upload (placeholder)
        try:
            self.logger.info(f"[DATA] Uploading PowerBI template for {self.integration.integration_name}")
            
            # This would need to be implemented based on integration requirements
            # For now, just return True as placeholder
            self.logger.info(f"[OK] PowerBI template upload completed for {self.integration.integration_name} (placeholder)")
            return True
            
        except Exception as e:
            self.logger.error(f"[ERROR] Error uploading PowerBI template for {self.integration.integration_name}: {str(e)}")
            return False
    
    def run_initialization(self, create_objects: bool = True, 
                          initialize_indexes: bool = True,
                          upload_pbi: bool = False,
                          workspace_id: str = None) -> Dict[str, Any]:
        """
        Run the integration INSERT initialization - main entry point for INSERT operations
        
        Args:
            create_objects: Whether to create SQL objects
            initialize_indexes: Whether to initialize indexes
            upload_pbi: Whether to upload PowerBI template
            workspace_id: PowerBI workspace ID (if upload_pbi is True)
            
        Returns:
            Dict containing execution results
        """
        if self.operation_mode != OperationMode.INSERT:
            return self._create_error_result(f'run_initialization is only available in INSERT mode (current mode: {self.operation_mode.value})')
        
        self.logger.info(f"Starting Dynamic Integration INSERT Orchestrator")
        self.logger.info(f"Integration: {self.integration.integration_name}")
        self.logger.info(f"Execution ID: {self.execution_id}")
        
        try:
            # Step 1: Validate integration interface
            self.logger.info("Step 1: Validating integration INSERT interface...")
            if not self.validate_integration_interface():
                return self._create_error_result('Integration INSERT interface validation failed')
            
            # Step 2: Let integration validate its own configuration
            self.logger.info("Step 2: Validating integration configuration...")
            if not self.integration.validate_configuration():
                return self._create_error_result('Integration configuration validation failed')
            
            # Step 3: Initialize results tracking
            results = {
                'integration': self.integration.integration_name,
                'operation_mode': self.operation_mode.value,
                'status': 'in_progress',
                'steps': {}
            }
            
            # Step 4: Create SQL Objects
            if create_objects:
                self.logger.info("Step 4: Creating SQL Objects...")
                sql_success = self.create_sql_objects(parallel=True)
                results['steps']['sql_objects'] = {
                    'success': sql_success,
                    'message': 'SQL objects created successfully' if sql_success else 'Failed to create SQL objects'
                }
            
            # Step 5: Initialize Indexes
            if initialize_indexes:
                self.logger.info("Step 5: Initializing Indexes...")
                index_success = self.initialize_indexes()
                results['steps']['indexes'] = {
                    'success': index_success,
                    'message': 'Indexes initialized successfully' if index_success else 'Failed to initialize indexes'
                }
            
            # Step 6: Upload PowerBI Template (optional)
            if upload_pbi:
                self.logger.info("Step 6: Uploading PowerBI Template...")
                pbi_success = self.upload_powerbi_template(workspace_id)
                results['steps']['powerbi'] = {
                    'success': pbi_success,
                    'message': 'PowerBI template uploaded successfully' if pbi_success else 'Failed to upload PowerBI template'
                }
            
            # Step 7: Add orchestrator metadata
            end_time = time.time()
            orchestrator_metadata = {
                'execution_id': self.execution_id,
                'orchestrator_duration': end_time - self.start_time,
                'integration_name': self.integration.integration_name,
                'orchestrator_version': '3.0.0',
                'operation_type': 'INSERT_INITIALIZATION',
                'workflow_steps': list(results['steps'].keys()),
                'operation_mode': self.operation_mode.value
            }
            
            # Determine overall status
            all_steps_successful = all(
                step_result.get('success', False) 
                for step_result in results['steps'].values()
            )
            
            results['status'] = 'completed' if all_steps_successful else 'completed_with_errors'
            results.update(orchestrator_metadata)
            
            # Step 8: Log summary
            self._log_insert_summary(results)
            
            self.logger.info(f"Dynamic Integration INSERT Orchestrator completed successfully")
            return results
            
        except Exception as e:
            error_msg = f"INSERT Orchestrator execution failed: {str(e)}"
            self.logger.error(error_msg)
            return self._create_error_result(error_msg, exception=e)

        finally:
            # CRITICAL: Cleanup database connections before exit
            # This releases MySQL connections immediately and allows Aurora ACUs to scale down
            try:
                from sql_helper import cleanup_all_connections
                cleanup_all_connections()
            except Exception as cleanup_err:
                # Silent failure - don't prevent script exit
                print(f"[WARNING] Warning: Connection cleanup failed in run_initialization: {cleanup_err}")

    # ===================================================================================
    # UPSERT OPERATION METHODS (From IntegrationPackageUpsert)
    # ===================================================================================
    
    def run(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """
        Run the integration orchestrator - main entry point for UPSERT operations
        
        Args:
            endpoint_list: Optional list of specific endpoints to process
            
        Returns:
            Dict containing execution results
        """
        if self.operation_mode == OperationMode.INSERT:
            self.logger.warning("run() method typically used for UPSERT operations. Consider using run_initialization() for INSERT operations.")
        
        self.logger.info(f"Starting Dynamic Integration UPSERT Orchestrator")
        self.logger.info(f"Integration: {self.integration.integration_name}")
        self.logger.info(f"Execution ID: {self.execution_id}")
        
        try:
            # Step 1: Validate integration interface
            self.logger.info("Step 1: Validating integration interface...")
            if not self.validate_integration_interface():
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
                'orchestrator_version': '3.0.0',
                'operation_mode': self.operation_mode.value,
                'workflow_steps': ['interface_validation', 'config_validation', 'integration_execution']
            }
            
            # Merge orchestrator metadata with integration results
            if isinstance(result, dict):
                result.update(orchestrator_metadata)
            else:
                result = orchestrator_metadata
                result['integration_result'] = result
            
            # Step 5: Log summary
            self._log_upsert_summary(result)
            
            self.logger.info(f"Dynamic Integration UPSERT Orchestrator completed successfully")
            return result
            
        except Exception as e:
            error_msg = f"UPSERT Orchestrator execution failed: {str(e)}"
            self.logger.error(error_msg)
            return self._create_error_result(error_msg, exception=e)

        finally:
            # CRITICAL: Cleanup database connections before exit
            # This releases MySQL connections immediately and allows Aurora ACUs to scale down
            try:
                from sql_helper import cleanup_all_connections
                cleanup_all_connections()
            except Exception as cleanup_err:
                # Silent failure - don't prevent script exit
                print(f"[WARNING] Warning: Connection cleanup failed in run: {cleanup_err}")

    def run_single_endpoint(self, endpoint: str) -> Dict[str, Any]:
        """
        Run a single endpoint through the integration
        
        Args:
            endpoint: The endpoint to process
            
        Returns:
            Dict containing execution results for the endpoint
        """
        if self.operation_mode == OperationMode.INSERT:
            self.logger.warning("run_single_endpoint is typically used for UPSERT operations")
        
        self.logger.info(f"Running single endpoint: {endpoint}")
        
        try:
            # Validate integration interface
            if not self.validate_integration_interface():
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
                    'operation_mode': self.operation_mode.value,
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
            'operation_mode': self.operation_mode.value,
            'orchestrator_version': '3.0.0'
        }
        
        # Add optional integration information if available
        optional_attributes = [
            ('get_endpoints_list', 'available_endpoints'),
            ('config', 'config'),
            ('table_prefix', 'table_prefix'),
            ('rate_limit', 'rate_limit'),
            ('get_insert_configuration', 'insert_configuration')
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
    
    # ===================================================================================
    # UTILITY METHODS
    # ===================================================================================
    
    def _create_error_result(self, error_message: str, endpoint: str = None, exception: Exception = None) -> Dict[str, Any]:
        """Create standardized error result"""
        result = {
            'status': 'failed',
            'error': error_message,
            'execution_id': self.execution_id,
            'integration_name': getattr(self.integration, 'integration_name', 'Unknown'),
            'operation_mode': self.operation_mode.value,
            'orchestrator_duration': time.time() - self.start_time,
            'orchestrator_version': '3.0.0'
        }
        
        if endpoint:
            result['endpoint'] = endpoint
            
        if exception:
            result['exception_type'] = type(exception).__name__
            result['exception_details'] = str(exception)
            
        return result
    
    def _log_insert_summary(self, results: Dict[str, Any]):
        """Log INSERT orchestrator execution summary"""
        self.logger.info(f"\\n" + "="*60)
        self.logger.info(f"{self.integration.integration_name} INSERT Orchestrator - Summary")
        self.logger.info("="*60)
        self.logger.info(f"Status: {results['status']}")
        self.logger.info(f"Duration: {results.get('orchestrator_duration', 0):.1f} seconds")
        
        for step_name, step_result in results.get('steps', {}).items():
            status_emoji = "[OK]" if step_result['success'] else "[ERROR]"
            self.logger.info(f"{status_emoji} {step_name}: {step_result['message']}")
        
        self.logger.info("="*60)
    
    def _log_upsert_summary(self, result: Dict[str, Any]):
        """Log UPSERT orchestrator execution summary"""
        self.logger.info("=" * 80)
        self.logger.info(f"Dynamic Integration UPSERT Orchestrator - Execution Summary")
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


# ===================================================================================
# FACTORY FUNCTIONS
# ===================================================================================

def create_integration_package(integration_instance, operation_mode: Union[str, OperationMode] = OperationMode.AUTO,
                               config: Optional[Dict[str, Any]] = None) -> IntegrationPackage:
    """
    Factory function to create a dynamic integration orchestrator
    
    Args:
        integration_instance: The specific integration class instance
        operation_mode: Operation mode - 'INSERT', 'UPSERT', or 'AUTO' for auto-detection
        config: Optional configuration dictionary
        
    Returns:
        IntegrationPackage instance
    """
    return IntegrationPackage(integration_instance, operation_mode, config)


def create_package_insert(integration_instance, config: Optional[Dict[str, Any]] = None) -> IntegrationPackage:
    """
    Factory function to create a INSERT-specific integration orchestrator
    (Backward compatibility with original IntegrationPackageInsert)
    
    Args:
        integration_instance: The specific integration class instance
        config: Optional configuration dictionary
        
    Returns:
        IntegrationPackage instance configured for INSERT operations
    """
    return IntegrationPackage(integration_instance, OperationMode.INSERT, config)


def create_package_upsert(integration_instance: Union[BaseIntegration, str], config: Optional[Dict[str, Any]] = None) -> IntegrationPackage:
    """
    Factory function to create an UPSERT integration orchestrator for any integration
    
    This function is now truly integration-agnostic - it accepts any integration
    instance that inherits from BaseIntegration. No hardcoded integration logic needed!
    
    Args:
        integration_instance: Either:
            - BaseIntegration instance (new recommended approach)
            - str: Integration name for backward compatibility (uses registry)
        config: Optional configuration dictionary
        
    Returns:
        IntegrationPackage instance configured for UPSERT operations
        
    Raises:
        ValueError: If integration doesn't support UPSERT or invalid instance
        TypeError: If integration_instance is not the right type
    """
    # Handle backward compatibility with string names
    if isinstance(integration_instance, str):
        integration_name = integration_instance.upper()
        
        # Try to use the registry first
        if IntegrationRegistry.is_registered(integration_name):
            integration_instance = IntegrationRegistry.create_integration(integration_name, config)
        else:
            # Fallback to legacy hardcoded logic for backward compatibility
            integration_instance = _create_legacy_integration(integration_name, config)
    
    # Validate that we have a proper BaseIntegration instance
    if not isinstance(integration_instance, BaseIntegration):
        raise TypeError(f"Integration instance must inherit from BaseIntegration. "
                       f"Got: {type(integration_instance)}")
    
    # Validate that integration supports UPSERT operations
    if not integration_instance.supports_upsert():
        available_caps = integration_instance.capabilities.value
        raise ValueError(f"Integration '{integration_instance.integration_name}' does not support UPSERT operations. "
                        f"Available capabilities: {available_caps}")
    
    # Create orchestrator with UPSERT mode
    return IntegrationPackage(integration_instance, OperationMode.UPSERT, config)


def _create_legacy_integration(integration_name: str, config: Optional[Dict[str, Any]] = None) -> BaseIntegration:
    """
    Legacy integration creation for backward compatibility
    
    This function contains the old hardcoded logic and should eventually be
    replaced by proper integration registration.
    
    Args:
        integration_name: Name of the integration
        config: Configuration dictionary
        
    Returns:
        BaseIntegration instance
        
    Raises:
        ValueError: If integration is not supported
        ImportError: If integration module cannot be imported
    """
    integration_name = integration_name.upper()
    
    try:
        if integration_name == 'XEROBLUE':
            # Try to import and create XeroBlue integration
            try:
                from .integrations.xeroblue_integration import XeroblueIntegration
            except ImportError:
                try:
                    from integrations.xeroblue_integration import XeroblueIntegration
                except ImportError:
                    # Try alternative paths using dynamic resolution
                    try:
                        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
                    except ImportError:
                        raise ImportError("Could not import XeroblueIntegration. Please ensure the integration module is available.")
            
            return XeroblueIntegration(config)
            
        elif integration_name == 'MYOB':
            # Template for future integrations
            raise ValueError(f"MYOB integration not yet implemented. "
                           f"Please register the integration with IntegrationRegistry.register()")
            
        elif integration_name == 'XERO_CUSTOM':
            # Template for future integrations
            raise ValueError(f"XERO_CUSTOM integration not yet implemented. "
                           f"Please register the integration with IntegrationRegistry.register()")
            
        else:
            available_integrations = IntegrationRegistry.list_integrations()
            if available_integrations:
                available_str = f"Available registered integrations: {available_integrations}"
            else:
                available_str = "No integrations registered. Use IntegrationRegistry.register() to add integrations."
            
            raise ValueError(f"Unsupported integration: {integration_name}. {available_str}")
        
    except ImportError as e:
        raise ImportError(f"Could not import {integration_name} integration: {str(e)}")
    except Exception as e:
        raise Exception(f"Failed to create {integration_name} integration: {str(e)}")


# ===================================================================================
# CONVENIENCE FUNCTIONS
# ===================================================================================

def run_integration_insert_initialization(integration_instance,
                                        create_objects: bool = True,
                                        initialize_indexes: bool = True,
                                        upload_pbi: bool = False,
                                        workspace_id: str = None,
                                        config: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """
    Convenience function to run INSERT initialization for any integration
    
    Args:
        integration_instance: The specific integration class instance
        create_objects: Whether to create SQL objects
        initialize_indexes: Whether to initialize indexes  
        upload_pbi: Whether to upload PowerBI template
        workspace_id: PowerBI workspace ID
        config: Optional configuration dictionary
        
    Returns:
        Dictionary with initialization results
    """
    orchestrator = create_package_insert(integration_instance, config)
    return orchestrator.run_initialization(
        create_objects=create_objects,
        initialize_indexes=initialize_indexes,
        upload_pbi=upload_pbi,
        workspace_id=workspace_id
    )


def run_integration_upsert(integration_name: str,
                          endpoint_list: Optional[List[str]] = None,
                          config: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """
    Convenience function to run UPSERT operations for any integration
    
    Args:
        integration_name: Name of the integration (e.g., 'XEROBLUE')
        endpoint_list: Optional list of specific endpoints to process
        config: Optional configuration dictionary
        
    Returns:
        Dictionary with execution results
    """
    orchestrator = create_package_upsert(integration_name, config)
    return orchestrator.run(endpoint_list)


# ===================================================================================
# INTEGRATION REGISTRY FUNCTIONS
# ===================================================================================

def register_integration(name: str, integration_class: type) -> None:
    """
    Register an integration class for name-based lookup
    
    This allows new integrations to be added without modifying IntegrationPackage.py
    
    Args:
        name: Integration name (e.g., 'MYOB', 'QUICKBOOKS')
        integration_class: Class that inherits from BaseIntegration
        
    Example:
        from my_integrations import MyobIntegration
        register_integration('MYOB', MyobIntegration)
        
        # Now you can use:
        orchestrator = create_package_upsert('MYOB', config)
    """
    IntegrationRegistry.register(name, integration_class)


def list_registered_integrations() -> List[str]:
    """
    List all registered integration names
    
    Returns:
        List[str]: Registered integration names
    """
    return IntegrationRegistry.list_integrations()


def is_integration_registered(name: str) -> bool:
    """
    Check if an integration is registered
    
    Args:
        name: Integration name to check
        
    Returns:
        bool: True if registered, False otherwise
    """
    return IntegrationRegistry.is_registered(name)


def create_integration_from_registry(name: str, config: Optional[Dict[str, Any]] = None) -> BaseIntegration:
    """
    Create an integration instance from the registry
    
    Args:
        name: Integration name
        config: Configuration dictionary
        
    Returns:
        BaseIntegration: Integration instance
        
    Raises:
        ValueError: If integration is not registered
    """
    return IntegrationRegistry.create_integration(name, config)


# Initialize legacy registrations for backward compatibility
def _initialize_legacy_registrations():
    """Initialize registrations for existing integrations"""
    try:
        # Register XeroBlue if available
        try:
            from .integrations.xeroblue_integration import XeroblueIntegration
            register_integration('XEROBLUE', XeroblueIntegration)
        except ImportError:
            try:
                from integrations.xeroblue_integration import XeroblueIntegration
                register_integration('XEROBLUE', XeroblueIntegration)
            except ImportError:
                pass  # XeroBlue not available
        
        # Add other integrations here as they become available
        
    except Exception:
        pass  # Ignore errors during initialization


# Initialize legacy registrations when module is imported
_initialize_legacy_registrations()


# ===================================================================================
# MAIN FUNCTION FOR TESTING
# ===================================================================================

def main():
    """
    Example usage of the dynamic integration orchestrator
    """
    try:
        # Example configuration
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        print("\\n" + "="*80)
        print("Dynamic Integration Package Orchestrator - Example Usage")
        print("="*80)
        
        # Example 1: Auto-detect operation mode
        print("\\n1. Creating XeroBlue integration with auto-detection...")
        orchestrator_auto = create_package_upsert('XEROBLUE', config)
        
        # Show integration info
        info = orchestrator_auto.get_integration_info()
        print(f"\\nIntegration Info:")
        for key, value in info.items():
            print(f"  {key}: {value}")
        
        # Example 2: Explicit UPSERT mode
        print("\\n2. Running UPSERT operation...")
        result = orchestrator_auto.run()
        
        # Show results
        print(f"\\nExecution completed with status: {result.get('status')}")
        print(f"Execution ID: {result.get('execution_id')}")
        print(f"Operation Mode: {result.get('operation_mode')}")
        
        return 0 if result.get('status') in ['completed', 'completed_with_errors'] else 1
        
    except Exception as e:
        print(f"\\nFailed to run dynamic integration orchestrator: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    """
    Entry point for direct execution
    """
    print("[START] Dynamic Integration Package Orchestrator")
    print("This module provides a unified orchestrator for both INSERT and UPSERT operations.")
    print("It supports auto-detection of operation mode and works with any integration.")
    print("\\nExample usage:")
    print("  # Auto-detect mode")
    print("  from IntegrationPackage import create_integration_package")
    print("  orchestrator = create_integration_package(my_integration_instance)")
    print("  result = orchestrator.run()  # or orchestrator.run_initialization()")
    print()
    print("  # Explicit mode")
    print("  orchestrator = create_integration_package(my_integration_instance, 'INSERT')")
    print("  result = orchestrator.run_initialization()")
    print()
    
    # Run example if called directly
    exit_code = main()
    exit(exit_code)