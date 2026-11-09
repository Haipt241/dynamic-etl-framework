#!/usr/bin/env python3
"""
Example: Running Xero Blue Integration with Dynamic Orchestrator

This script demonstrates how to use the new dynamic IntegrationPackage
orchestrator to run Xero Blue integrations in different modes.
"""

import os
import sys
import logging
from typing import Dict, Any

# Add the etl_packages to path

# Import the dynamic orchestrator
from dynamic_integrations import (
    create_integration_package,
    create_package_upsert,
    create_package_insert,
    OperationMode,
    run_integration_upsert,
    run_integration_insert_initialization
)

# Import the Xero Blue integration class
from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration

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

def setup_logging():
    """Setup logging configuration"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('xeroblue_dynamic_example.log')
        ]
    )

def get_xeroblue_config() -> Dict[str, Any]:
    """
    Get Xero Blue configuration
    
    You should replace these with your actual environment variables or config
    """
    return {
        'rate_limit': 60,
        'timeout_seconds': 900,
        'debug': True,
        'parallel_execution': True,
        
        # These should come from environment variables in production
        'client_id': os.getenv('EtaniClientID', 'BIGOLESHOECOMPANY_CLIENT1518'),
        'organisation_id': os.getenv('EtaniOrganisationID', '5393'),
        'xero_tenant_id': os.getenv('XeroTenantID', ''),
        'job_id': os.getenv('JOB_ID', '0'),
        'job_run_id': os.getenv('JOB_RUN_ID', '0'),
        'trigger_type': os.getenv('TRIGGER_TYPE', 'MANUAL'),
        'db_destination': os.getenv('DB_Destination', 'DW')
    }

def example_1_auto_detect_mode():
    """
    Example 1: Auto-detect operation mode
    
    The orchestrator will automatically detect whether to use INSERT or UPSERT
    based on the integration's available methods.
    """
    print("\n" + "="*80)
    print("EXAMPLE 1: Auto-Detect Operation Mode")
    print("="*80)
    
    try:
        # Get configuration
        config = get_xeroblue_config()
        
        # Create Xero Blue integration instance
        xeroblue_integration = XeroblueIntegration(config)
        
        # Create orchestrator with auto-detection
        orchestrator = create_integration_package(
            integration_instance=xeroblue_integration,
            operation_mode=OperationMode.AUTO  # This is the default
        )
        
        # Get integration info to see what was detected
        info = orchestrator.get_integration_info()
        print(f"Auto-detected operation mode: {info.get('operation_mode')}")
        print(f"Integration: {info.get('integration_name')}")
        print(f"Available endpoints: {len(info.get('available_endpoints', []))}")
        
        # Run the integration (method depends on detected mode)
        if info.get('operation_mode') == 'INSERT':
            print("\nRunning INSERT initialization...")
            result = orchestrator.run_initialization(
                create_objects=True,
                initialize_indexes=True,
                upload_pbi=False
            )
        else:
            print("\nRunning UPSERT synchronization...")
            result = orchestrator.run()
        
        # Display results
        print(f"\nExecution completed:")
        print(f"  Status: {result.get('status')}")
        print(f"  Execution ID: {result.get('execution_id')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        
        return result
        
    except Exception as e:
        print(f"❌ Example 1 failed: {str(e)}")
        return None

def example_2_explicit_upsert_mode():
    """
    Example 2: Explicit UPSERT mode
    
    Explicitly specify UPSERT mode and run specific endpoints.
    """
    print("\n" + "="*80)
    print("EXAMPLE 2: Explicit UPSERT Mode")
    print("="*80)
    
    try:
        # Get configuration
        config = get_xeroblue_config()
        
        # Create Xero Blue integration instance
        xeroblue_integration = XeroblueIntegration(config)
        
        # Create orchestrator with explicit UPSERT mode
        orchestrator = create_integration_package(
            integration_instance=xeroblue_integration,
            operation_mode=OperationMode.UPSERT
        )
        
        print(f"Operation mode: {orchestrator.operation_mode.value}")
        
        # Run specific endpoints only
        specific_endpoints = ['contacts', 'accounts', 'invoices']
        print(f"Running specific endpoints: {specific_endpoints}")
        
        result = orchestrator.run(endpoint_list=specific_endpoints)
        
        # Display results
        print(f"\nExecution completed:")
        print(f"  Status: {result.get('status')}")
        print(f"  Execution ID: {result.get('execution_id')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        print(f"  Endpoints processed: {result.get('total_endpoints', 0)}")
        print(f"  Records processed: {result.get('total_records_processed', 0)}")
        
        return result
        
    except Exception as e:
        print(f"❌ Example 2 failed: {str(e)}")
        return None

def example_3_explicit_insert_mode():
    """
    Example 3: Explicit INSERT mode
    
    Explicitly specify INSERT mode for setting up new client infrastructure.
    """
    print("\n" + "="*80)
    print("EXAMPLE 3: Explicit INSERT Mode")
    print("="*80)
    
    try:
        # Get configuration
        config = get_xeroblue_config()
        
        # Create Xero Blue integration instance
        xeroblue_integration = XeroblueIntegration(config)
        
        # Create orchestrator with explicit INSERT mode
        orchestrator = create_integration_package(
            integration_instance=xeroblue_integration,
            operation_mode=OperationMode.INSERT
        )
        
        print(f"Operation mode: {orchestrator.operation_mode.value}")
        
        # Run INSERT initialization
        result = orchestrator.run_initialization(
            create_objects=True,      # Create SQL tables, views, stored procedures
            initialize_indexes=True,  # Initialize database indexes
            upload_pbi=False,        # Skip PowerBI template upload for this example
            workspace_id=None
        )
        
        # Display results
        print(f"\nINSERT initialization completed:")
        print(f"  Status: {result.get('status')}")
        print(f"  Execution ID: {result.get('execution_id')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        
        # Show step results
        for step_name, step_result in result.get('steps', {}).items():
            status_emoji = "✅" if step_result['success'] else "❌"
            print(f"  {status_emoji} {step_name}: {step_result['message']}")
        
        return result
        
    except Exception as e:
        print(f"❌ Example 3 failed: {str(e)}")
        return None

def example_4_backward_compatibility():
    """
    Example 4: Backward compatibility with original functions
    
    Shows how existing code can continue to work with the new orchestrator.
    """
    print("\n" + "="*80)
    print("EXAMPLE 4: Backward Compatibility")
    print("="*80)
    
    try:
        # Get configuration
        config = get_xeroblue_config()
        
        # Method 1: Using the original create_package_upsert function
        print("Method 1: Original create_package_upsert function")
        orchestrator_upsert = create_package_upsert('XEROBLUE', config)
        print(f"  Created UPSERT orchestrator: {orchestrator_upsert.operation_mode.value}")
        
        # Method 2: Using convenience function for UPSERT
        print("\nMethod 2: Convenience function for UPSERT")
        result_upsert = run_integration_upsert(
            integration_name='XEROBLUE',
            endpoint_list=['contacts'],  # Just run contacts for quick example
            config=config
        )
        print(f"  UPSERT result status: {result_upsert.get('status')}")
        
        # Method 3: Using convenience function for INSERT (would need integration instance)
        print("\nMethod 3: Convenience function for INSERT")
        xeroblue_integration = XeroblueIntegration(config)
        
        # Note: This would actually create SQL objects - use with caution
        result_insert = run_integration_insert_initialization(
            integration_instance=xeroblue_integration,
            create_objects=False,     # Set to False for this example
            initialize_indexes=False, # Set to False for this example
            upload_pbi=False
        )
        print(f"  INSERT result status: {result_insert.get('status')}")
        
        return {
            'upsert_result': result_upsert,
            'insert_result': result_insert
        }
        
    except Exception as e:
        print(f"❌ Example 4 failed: {str(e)}")
        return None

def example_5_single_endpoint():
    """
    Example 5: Running a single endpoint
    
    Shows how to process just one endpoint for testing or debugging.
    """
    print("\n" + "="*80)
    print("EXAMPLE 5: Single Endpoint Processing")
    print("="*80)
    
    try:
        # Get configuration
        config = get_xeroblue_config()
        
        # Create Xero Blue integration instance
        xeroblue_integration = XeroblueIntegration(config)
        
        # Create orchestrator
        orchestrator = create_integration_package(
            integration_instance=xeroblue_integration,
            operation_mode=OperationMode.UPSERT
        )
        
        # Run single endpoint
        endpoint = 'contacts'
        print(f"Processing single endpoint: {endpoint}")
        
        result = orchestrator.run_single_endpoint(endpoint)
        
        # Display results
        print(f"\nSingle endpoint processing completed:")
        print(f"  Endpoint: {result.get('processed_endpoint')}")
        print(f"  Status: {result.get('status')}")
        print(f"  Execution ID: {result.get('execution_id')}")
        
        return result
        
    except Exception as e:
        print(f"❌ Example 5 failed: {str(e)}")
        return None

def main():
    """
    Main function to run all examples
    """
    print("🚀 Xero Blue Dynamic Integration Orchestrator Examples")
    print("=" * 80)
    
    # Setup logging
    setup_logging()
    
    # Check if we have basic configuration
    config = get_xeroblue_config()
    if not config.get('client_id'):
        print("⚠️  Warning: No EtaniClientID found in environment variables")
        print("   Some examples may fail without proper configuration")
        print("   Set environment variables: EtaniClientID, EtaniOrganisationID, etc.")
    
    results = {}
    
    # Run examples (comment out any you don't want to run)
    
    # Example 1: Auto-detect mode
    results['auto_detect'] = example_1_auto_detect_mode()
    
    # Example 2: Explicit UPSERT
    results['explicit_upsert'] = example_2_explicit_upsert_mode()
    
    # Example 3: Explicit INSERT (creates SQL objects - use with caution)
    # results['explicit_insert'] = example_3_explicit_insert_mode()
    
    # Example 4: Backward compatibility
    results['backward_compat'] = example_4_backward_compatibility()
    
    # Example 5: Single endpoint
    results['single_endpoint'] = example_5_single_endpoint()
    
    # Summary
    print("\n" + "="*80)
    print("EXECUTION SUMMARY")
    print("="*80)
    
    for example_name, result in results.items():
        if result:
            status = result.get('status', 'unknown')
            status_emoji = "✅" if status in ['completed', 'completed_with_errors'] else "❌"
            print(f"{status_emoji} {example_name}: {status}")
        else:
            print(f"❌ {example_name}: failed")
    
    print("\n🎉 All examples completed!")
    print("\nNext steps:")
    print("1. Review the logs in 'xeroblue_dynamic_example.log'")
    print("2. Check the execution results for each example")
    print("3. Adapt the configuration for your specific use case")
    print("4. Use the appropriate mode (INSERT for new clients, UPSERT for data sync)")

if __name__ == "__main__":
    """
    Entry point for running examples
    
    Usage:
        # Run all examples
        python example_xeroblue_dynamic.py
        
        # Or run from the etl_packages directory
        cd /home/jepilor/etl\ 1.0/etl_packages
        python example_xeroblue_dynamic.py
    """
    main()