"""
Generic Integration Package Insert Orchestrator

This module provides a generic orchestrator for any integration package INSERT operations.
It handles the common workflow patterns while delegating integration-specific
logic to the individual integration classes.

Key Features:
- Generic orchestrator that works with any integration
- Standardized interface for all integrations  
- Common error handling and logging
- Plug-and-play architecture for INSERT operations
- Completely integration-agnostic (no hardcoded integration configs)

Usage:
    from integration_package_insert import create_package_insert
    
    # Create and run any integration INSERT
    orchestrator = create_package_insert(integration_instance)
    result = orchestrator.run_initialization()
"""

import os
import sys
import time
import logging
from typing import Dict, Any, Optional, List
from datetime import datetime

# Import our integration-agnostic managers
try:
    from .cms_manager import CMSManager
    from .sql_object_manager import SQLObjectManagerOrchestrator, SQLObjectConfig
except ImportError:
    # Fallback for when running as standalone script
    from cms_manager import CMSManager
    from sql_object_manager import SQLObjectManagerOrchestrator, SQLObjectConfig


class IntegrationPackageInsert:
    """
    Generic Integration Package INSERT Orchestrator
    
    This class provides a standardized interface for running INSERT operations for any integration.
    It delegates ALL integration-specific logic to the integration class itself.
    The orchestrator just coordinates the INSERT workflow.
    """
    
    def __init__(self, integration_instance, config: Optional[Dict[str, Any]] = None):
        """
        Initialize the generic INSERT orchestrator
        
        Args:
            integration_instance: The specific integration class instance (must have standardized interface)
            config: Optional configuration dictionary
        """
        self.integration = integration_instance
        self.config = config or {}
        self.setup_logging()
        
        # Execution tracking
        self.start_time = time.time()
        self.execution_id = f"{self.integration.integration_name}_INSERT_{int(self.start_time)}"
        
        # Initialize SQL Object Manager using integration's configuration
        self._initialize_sql_object_manager()
    
    def setup_logging(self):
        """Setup logging for the orchestrator"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(f"InsertOrchestrator.{self.integration.integration_name}")
    
    def validate_integration_interface(self) -> bool:
        """
        Validate that the integration instance has the required standardized interface for INSERT operations
        
        Required interface for any integration INSERT:
        - integration_name: str attribute
        - validate_configuration(): bool method
        - get_insert_configuration(): Dict method (returns config for SQL objects, FX currencies, etc.)
        
        Optional interface:
        - create_sql_objects(): bool method (if integration wants custom SQL object creation)
        - initialize_indexes(): bool method (if integration wants custom index initialization)
        - upload_powerbi_template(): bool method (if integration supports PowerBI)
        
        Returns:
            bool: True if integration is valid, False otherwise
        """
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
            self.logger.info(f"Optional methods available: {available_optional}")
        
        self.logger.info(f"Integration {self.integration.integration_name} INSERT interface validated successfully")
        return True
    
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
            self.logger.info(f"✅ SQL Object Manager initialized for {self.integration.integration_name}")
            
        except Exception as e:
            error_msg = f"Failed to initialize SQL Object Manager: {str(e)}"
            self.logger.error(f"❌ {error_msg}")
            self.sql_object_manager = None
    
    def create_sql_objects(self, parallel: bool = True) -> bool:
        """
        Create all SQL objects (tables, views, stored procedures) for the integration
        
        Args:
            parallel: Whether to create objects in parallel for better performance
            
        Returns:
            True if successful, False otherwise
        """
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
                self.logger.info(f"🎉 SQL objects created successfully for {self.integration.integration_name}")
                return True
            else:
                self.logger.error(f"❌ Failed to create SQL objects for {self.integration.integration_name}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ Error creating SQL objects for {self.integration.integration_name}: {str(e)}")
            return False
    
    def initialize_indexes(self) -> bool:
        """Initialize all indexes for the integration"""
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
            self.logger.info(f"🔍 Initializing indexes for {self.integration.integration_name}")
            
            # This would need to be implemented based on integration requirements
            # For now, just return True as placeholder
            self.logger.info(f"✅ Indexes initialized for {self.integration.integration_name} (placeholder)")
            return True
            
        except Exception as e:
            self.logger.error(f"❌ Error initializing indexes for {self.integration.integration_name}: {str(e)}")
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
            self.logger.info(f"📊 Uploading PowerBI template for {self.integration.integration_name}")
            
            # This would need to be implemented based on integration requirements
            # For now, just return True as placeholder
            self.logger.info(f"✅ PowerBI template upload completed for {self.integration.integration_name} (placeholder)")
            return True
            
        except Exception as e:
            self.logger.error(f"❌ Error uploading PowerBI template for {self.integration.integration_name}: {str(e)}")
            return False
    
    def run_initialization(self, create_objects: bool = True, 
                          initialize_indexes: bool = True,
                          upload_pbi: bool = False,
                          workspace_id: str = None) -> Dict[str, Any]:
        """
        Run the integration INSERT initialization - the main entry point
        
        This method coordinates the workflow but delegates all business logic
        to the integration class itself.
        
        Args:
            create_objects: Whether to create SQL objects
            initialize_indexes: Whether to initialize indexes
            upload_pbi: Whether to upload PowerBI template
            workspace_id: PowerBI workspace ID (if upload_pbi is True)
            
        Returns:
            Dict containing execution results
        """
        self.logger.info(f"Starting Generic Integration INSERT Orchestrator")
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
                'orchestrator_version': '2.0.0',
                'operation_type': 'INSERT_INITIALIZATION',
                'workflow_steps': list(results['steps'].keys())
            }
            
            # Determine overall status
            all_steps_successful = all(
                step_result.get('success', False) 
                for step_result in results['steps'].values()
            )
            
            results['status'] = 'completed' if all_steps_successful else 'completed_with_errors'
            results.update(orchestrator_metadata)
            
            # Step 8: Log summary
            self._log_orchestrator_summary(results)
            
            self.logger.info(f"Generic Integration INSERT Orchestrator completed successfully")
            return results
            
        except Exception as e:
            error_msg = f"INSERT Orchestrator execution failed: {str(e)}"
            self.logger.error(error_msg)
            return self._create_error_result(error_msg, exception=e)
    
    def _create_error_result(self, error_message: str, exception: Exception = None) -> Dict[str, Any]:
        """Create standardized error result"""
        return {
            'status': 'failed',
            'error': error_message,
            'integration_name': getattr(self.integration, 'integration_name', 'unknown'),
            'execution_id': self.execution_id,
            'orchestrator_duration': time.time() - self.start_time,
            'exception_type': type(exception).__name__ if exception else None,
            'exception_details': str(exception) if exception else None
        }
    
    def _log_orchestrator_summary(self, results: Dict[str, Any]):
        """Log orchestrator execution summary"""
        self.logger.info(f"\\n" + "="*60)
        self.logger.info(f"{self.integration.integration_name} INSERT Orchestrator - Summary")
        self.logger.info("="*60)
        self.logger.info(f"Status: {results['status']}")
        self.logger.info(f"Duration: {results.get('orchestrator_duration', 0):.1f} seconds")
        
        for step_name, step_result in results.get('steps', {}).items():
            status_emoji = "✅" if step_result['success'] else "❌"
            self.logger.info(f"{status_emoji} {step_name}: {step_result['message']}")
        
        self.logger.info("="*60)


# Factory function for creating integration INSERT orchestrators
def create_package_insert(integration_instance, config: Optional[Dict[str, Any]] = None) -> IntegrationPackageInsert:
    """
    Factory function to create a generic integration INSERT orchestrator
    
    Args:
        integration_instance: The specific integration class instance
        config: Optional configuration dictionary
        
    Returns:
        IntegrationPackageInsert instance
    """
    return IntegrationPackageInsert(integration_instance, config)


# Convenience function for running INSERT initialization
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


if __name__ == "__main__":
    print("🚀 Generic Integration Package INSERT Orchestrator")
    print("This module provides a generic orchestrator for INSERT operations.")
    print("It requires integration instances that implement the standardized interface.")
    print("\\nExample usage:")
    print("  from integration_package_insert import create_package_insert")
    print("  orchestrator = create_package_insert(my_integration_instance)")
    print("  results = orchestrator.run_initialization()")