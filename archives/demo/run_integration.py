#!/usr/bin/env python3
"""
Simple Entry Point for Plug-and-Play ETL System

This script demonstrates how to use the generic integration orchestrator 
with any integration. It serves as a simple, clean entry point that 
replaces the monolithic scripts.

Usage:
    # Run XeroBlue integration with default settings
    python run_integration.py --integration XEROBLUE

    # Run with custom endpoint list
    python run_integration.py --integration XEROBLUE --endpoints Organisations,Accounts

    # Run single endpoint
    python run_integration.py --integration XEROBLUE --endpoint Organisations

    # Run with custom config
    python run_integration.py --integration XEROBLUE --rate-limit 30 --debug

Environment Variables Required:
    - EtaniClientID: Client identifier
    - EtaniOrganisationID: Organisation identifier  
    - XeroTenantID: Xero tenant ID (for XeroBlue)
    - xeroblue_client_id: Xero client ID
    - xeroblue_client_secret: Xero client secret
"""

import os
import sys
import argparse
import json
from typing import Optional, List

# Add path for imports

# Import the generic orchestrator
from IntegrationPackageUpsert import create_package_upsert

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Run any ETL integration using the plug-and-play system",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    
    parser.add_argument(
        '--integration',
        required=True,
        choices=['XEROBLUE', 'MYOB', 'XERO_CUSTOM'],
        help='Integration to run'
    )
    
    parser.add_argument(
        '--endpoints',
        help='Comma-separated list of endpoints to process (default: all)'
    )
    
    parser.add_argument(
        '--endpoint',
        help='Single endpoint to process (alternative to --endpoints)'
    )
    
    parser.add_argument(
        '--rate-limit',
        type=int,
        default=60,
        help='API rate limit (calls per minute, default: 60)'
    )
    
    parser.add_argument(
        '--timeout',
        type=int,
        default=900,
        help='API timeout in seconds (default: 900)'
    )
    
    parser.add_argument(
        '--debug',
        action='store_true',
        help='Enable debug logging'
    )
    
    parser.add_argument(
        '--config-file',
        help='Path to JSON configuration file'
    )
    
    parser.add_argument(
        '--info-only',
        action='store_true',
        help='Only show integration info, do not run'
    )
    
    return parser.parse_args()

def load_config_file(config_file_path: str) -> dict:
    """Load configuration from JSON file"""
    try:
        with open(config_file_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading config file {config_file_path}: {e}")
        sys.exit(1)

def build_config(args) -> dict:
    """Build configuration dictionary from arguments"""
    config = {
        'rate_limit': args.rate_limit,
        'timeout_seconds': args.timeout,
        'debug': args.debug
    }
    
    # Load config file if provided
    if args.config_file:
        file_config = load_config_file(args.config_file)
        config.update(file_config)
    
    return config

def validate_environment(integration_name: str):
    """Validate required environment variables"""
    print("Validating environment variables...")
    
    # Common required variables
    required_vars = ['EtaniClientID', 'EtaniOrganisationID']
    
    # Integration-specific variables
    if integration_name == 'XEROBLUE':
        required_vars.extend([
            'XeroTenantID',
            'xeroblue_client_id',
            'xeroblue_client_secret'
        ])
    
    missing_vars = []
    for var in required_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"❌ Missing required environment variables: {missing_vars}")
        print("\\nPlease set the following environment variables:")
        for var in missing_vars:
            print(f"  export {var}=<value>")
        sys.exit(1)
    
    print("✅ Environment validation passed")
    
    # Show current environment values (masked for security)
    print("\\nCurrent environment:")
    for var in required_vars:
        value = os.getenv(var, '')
        if 'secret' in var.lower() or 'key' in var.lower():
            masked_value = f"{value[:4]}...{value[-4:]}" if len(value) > 8 else "***"
            print(f"  {var}: {masked_value}")
        else:
            print(f"  {var}: {value}")

def main():
    """Main entry point"""
    args = parse_arguments()
    
    print("=" * 80)
    print("Plug-and-Play ETL System - Simple Entry Point")
    print("=" * 80)
    print(f"Integration: {args.integration}")
    
    try:
        # Validate environment
        validate_environment(args.integration)
        
        # Build configuration
        config = build_config(args)
        print(f"\\nConfiguration: {json.dumps(config, indent=2)}")
        
        # Create orchestrator
        print(f"\\nCreating {args.integration} integration orchestrator...")
        orchestrator = create_package_upsert(args.integration, config)
        
        # Show integration info
        info = orchestrator.get_integration_info()
        print(f"\\nIntegration Information:")
        for key, value in info.items():
            if isinstance(value, list) and len(value) > 10:
                print(f"  {key}: [{len(value)} items]")
            else:
                print(f"  {key}: {value}")
        
        # Exit if info-only mode
        if args.info_only:
            print("\\n📋 Info-only mode - exiting without running integration")
            return 0
        
        # Determine endpoints to process
        endpoint_list = None
        if args.endpoint:
            # Single endpoint mode
            print(f"\\n🎯 Running single endpoint: {args.endpoint}")
            result = orchestrator.run_single_endpoint(args.endpoint)
        elif args.endpoints:
            # Multiple specific endpoints
            endpoint_list = [e.strip() for e in args.endpoints.split(',')]
            print(f"\\n🎯 Running specific endpoints: {endpoint_list}")
            result = orchestrator.run(endpoint_list)
        else:
            # All endpoints (default)
            print(f"\\n🚀 Running full synchronization...")
            result = orchestrator.run()
        
        # Show results
        print("\\n" + "=" * 80)
        print("EXECUTION SUMMARY")
        print("=" * 80)
        print(f"Status: {result.get('status', 'unknown')}")
        print(f"Execution ID: {result.get('execution_id', 'unknown')}")
        print(f"Integration: {result.get('integration_name', 'unknown')}")
        
        if 'duration_seconds' in result:
            print(f"Duration: {result['duration_seconds']:.2f} seconds")
        
        if 'total_endpoints' in result:
            print(f"Endpoints: {result.get('successful_endpoints', 0)}/{result.get('total_endpoints', 0)} successful")
        
        if 'total_records_processed' in result:
            print(f"Records Processed: {result.get('total_records_processed', 0)}")
        
        if result.get('status') == 'failed':
            print(f"\\n❌ Failure Reason: {result.get('error', 'Unknown error')}")
            return 1
        elif result.get('status') == 'completed_with_errors':
            print(f"\\n⚠️  Completed with errors")
            if 'errors' in result and result['errors']:
                print(f"Errors: {len(result['errors'])}")
                for error in result['errors'][:3]:  # Show first 3 errors
                    print(f"  - {error}")
            return 0
        else:
            print(f"\\n✅ Execution completed successfully")
            return 0
        
    except KeyboardInterrupt:
        print(f"\\n\\n⏹️  Execution interrupted by user")
        return 130
    except Exception as e:
        print(f"\\n\\n💥 Execution failed: {str(e)}")
        if args.debug:
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
    sys.exit(exit_code)