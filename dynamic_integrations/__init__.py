"""
Dynamic Integration Package

This package provides a unified, dynamic orchestrator for integration operations
that can handle both INSERT and UPSERT operations seamlessly.

Main Components:
- IntegrationPackage: Dynamic orchestrator class
- BaseIntegration: Base interface for all integrations
- IntegrationRegistry: Registry for managing integrations
- cms_manager: CMS management utilities
- sql_object_manager: SQL object management utilities
- integrations/: Integration-specific implementations

Usage:
    from etl_packages.dynamic_integrations import create_integration_package, BaseIntegration
    
    # New recommended approach - integration-agnostic
    class MyIntegration(BaseIntegration):
        # Implementation here
        pass
    
    my_integration = MyIntegration(config)
    orchestrator = create_integration_package(my_integration)
    
    # Or register integration for name-based lookup
    from etl_packages.dynamic_integrations import register_integration
    register_integration('MYINTEGRATION', MyIntegration)
    
    # Then use by name
    orchestrator = create_package_upsert('MYINTEGRATION', config)
"""

from .IntegrationPackage import (
    IntegrationPackage,
    OperationMode,
    create_integration_package,
    create_package_insert,
    create_package_upsert,
    run_integration_insert_initialization,
    run_integration_upsert,
    register_integration,
    list_registered_integrations,
    is_integration_registered,
    create_integration_from_registry
)

from .base_integration import (
    BaseIntegration,
    IntegrationCapability,
    IntegrationRegistry,
    validate_integration_interface,
    get_integration_capabilities
)

from .singleton_manager import SingletonManager

__version__ = "3.0.0"
__author__ = "Etani ETL Team"

# Expose main classes and functions
__all__ = [
    # Core orchestrator
    'IntegrationPackage',
    'OperationMode', 
    'create_integration_package',
    'create_package_insert',
    'create_package_upsert',
    'run_integration_insert_initialization',
    'run_integration_upsert',
    
    # Base integration interface
    'BaseIntegration',
    'IntegrationCapability',
    'IntegrationRegistry',
    'validate_integration_interface',
    'get_integration_capabilities',
    
    # Registry functions
    'register_integration',
    'list_registered_integrations',
    'is_integration_registered',
    'create_integration_from_registry',
    
    # Singleton manager
    'SingletonManager'
]