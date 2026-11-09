#!/usr/bin/env python3
"""
Dynamic Integration Runner

Unified entry point for running dynamic integrations with INSERT and UPSERT modes.

INSERT Mode: Simplified workflow (Update Config → Execute SQL → Run Integration Direct)
UPSERT Mode: Run integration sync only (assumes setup already done)

Usage:
    # INSERT - Full setup with simplified workflow
    python run_dynamic_integration.py --integration qbo --mode insert \
      --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
      --param EtaniOrganisationID=7035 \
      --param RealmID=123456789

    # UPSERT - Auto-detect timestamp (recommended)
    python run_dynamic_integration.py --integration fyi --mode upsert \
      --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
      --param EtaniOrganisationID=7035

    # UPSERT - With custom timestamp override
    python run_dynamic_integration.py --integration fyi --mode upsert \
      --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \
      --param EtaniOrganisationID=7035 \
      --param modified_on_gte=2024-01-15T10:30:00
"""

import argparse
import os
import sys
import json
import time
from pathlib import Path
from typing import Dict, List, Optional, Any

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import required modules
from dynamic_integrations.sql_executor import SQLExecutor
from dynamic_integrations.secrets_manager import set_xero_oauth_env_vars
import config


class IntegrationWorkflowOrchestrator:
    """
    Orchestrates the simplified integration workflow for both INSERT and UPSERT modes
    """

    def __init__(self, integration_name: str, mode: str, parameters: Dict[str, Any], is_exist_client: bool = False, ignore_sql: bool = False, legacy_client_id: str = None):
        """
        Initialize workflow orchestrator

        Args:
            integration_name: Name of integration (e.g., 'qbo', 'jobman')
            mode: 'insert' or 'upsert'
            parameters: Dictionary of parameters (EtaniClientID, EtaniOrganisationID, etc.)
            is_exist_client: Skip production table creation if True
            ignore_sql: Skip SQL execution during insert mode if True
            legacy_client_id: Legacy client ID for SQL view naming (optional)
        """
        self.integration_name = integration_name.lower()
        self.mode = mode.lower()
        self.is_exist_client = is_exist_client
        self.ignore_sql = ignore_sql
        self.parameters = parameters
        self.legacy_client_id = legacy_client_id
        
        # Extract refresh_token from parameters for runtime use
        self.refresh_token = None
        for key, value in self.parameters.items():
            if 'refresh_token' in key.lower():
                self.refresh_token = value
                break

        # Set up paths using absolute paths
        current_dir = Path(__file__).parent
        self.integration_dir = current_dir / "dynamic_integrations" / "generated_integrations" / self.integration_name
        self.schema_file = self.integration_dir / "schemas" / f"{self.integration_name}_schema.json"
        self.sql_dir = self.integration_dir / "sql"
        self.config_file = current_dir / "dynamic_integrations" / "generator" / "config" / f"{self.integration_name}_config.json"

        print(f"[START] Integration Workflow Orchestrator initialized")
        print(f"[PACKAGE] Integration: {self.integration_name}")
        print(f"[CONFIG] Mode: {self.mode}")
        print(f"[DATA] Parameters: {list(self.parameters.keys())}")

    def validate_required_parameters(self) -> Dict[str, Any]:
        """
        Validate that --param arguments contain all required_env_vars from integration config

        Returns:
            Dict with validation result: {'valid': bool, 'missing': list, 'error': str}
        """
        try:
            # Check if validation is enabled
            if not getattr(config, 'ENABLE_REQUIRED_PARAMS_CHECK', True):
                return {'valid': True, 'skipped': True}

            # Load integration config
            if not self.config_file.exists():
                return {'valid': False, 'error': f'Integration config not found: {self.config_file}'}

            with open(self.config_file, 'r') as f:
                integration_config = json.load(f)

            required_vars = integration_config.get('required_env_vars', [])
            env_vars_config = integration_config.get('env_vars_config', {})

            # Create mapping from env_var to config key for better user experience
            env_var_to_config_key = {}
            for config_key, config_data in env_vars_config.items():
                env_var = config_data.get('env_var', '')
                if env_var:
                    env_var_to_config_key[env_var] = config_key

            # Check for missing required parameters in --param arguments OR environment variables
            missing_params = []
            missing_config_keys = []
            for required_var in required_vars:
                # Use config key for display, but check for env_var (uppercase) in parameters
                config_key = env_var_to_config_key.get(required_var, required_var)
                # Check BOTH parameters dict AND environment variables (for Secrets Manager support)
                if required_var not in self.parameters and not os.getenv(required_var):
                    missing_params.append(required_var)
                    missing_config_keys.append(config_key)

            # Return validation result
            if missing_params:
                return {
                    'valid': False,
                    'missing': missing_params,
                    'missing_config_keys': missing_config_keys,
                    'message': f"Missing required parameters: {', '.join(missing_config_keys)}"
                }

            # Create display list for success message
            success_keys = []
            for required_var in required_vars:
                config_key = env_var_to_config_key.get(required_var, required_var)
                success_keys.append(config_key)

            print(f"[OK] All required parameters provided: {', '.join(success_keys)}")
            return {'valid': True}

        except Exception as e:
            return {'valid': False, 'error': f'Validation error: {str(e)}'}

    def run(self) -> Dict[str, Any]:
        """
        Run the complete integration workflow based on mode

        Returns:
            Dict containing execution results
        """
        start_time = time.time()

        try:
            # Step 0: Validate required parameters
            print("\n[SEARCH] Step 0: Validating required parameters...")
            validation_result = self.validate_required_parameters()

            if not validation_result["valid"]:
                if validation_result.get("skipped"):
                    print("[WARNING] Required parameters validation is DISABLED")
                else:
                    raise Exception(f"Required parameters validation failed: {validation_result.get('message', validation_result.get('error'))}")

            # Step 1: Update configuration (common for both INSERT and UPSERT)
            print("\n[CONFIG] Step 1: Updating configuration with parameters...")
            config_result = self._update_configuration()

            if not config_result["success"]:
                raise Exception(f"Configuration update failed: {config_result['error']}")

            # Step 2: Run mode-specific workflow
            if self.mode == "insert":
                result = self._run_insert_mode()
            elif self.mode == "upsert":
                result = self._run_upsert_mode()
            else:
                raise ValueError(f"Invalid mode: {self.mode}. Must be 'insert' or 'upsert'")

            execution_time = time.time() - start_time
            result["execution_time"] = execution_time
            result["status"] = "success"

            print(f"[OK] {self.mode.upper()} workflow completed successfully in {execution_time:.2f} seconds")
            return result

        except Exception as e:
            execution_time = time.time() - start_time
            error_result = {
                "status": "error",
                "error": str(e),
                "execution_time": execution_time,
                "mode": self.mode,
                "integration": self.integration_name
            }
            return error_result

    def _run_insert_mode(self) -> Dict[str, Any]:
        """
        Run INSERT mode: Execute SQL + Run integration directly
        (Config update already done in main run() method)

        Steps:
        1. Execute SQL to create database objects (using existing SQL files)
        2. Run integration sync directly (without IntegrationPackage)

        Returns:
            Dict containing results from each step
        """
        print(f"[ACTION] Running INSERT-specific steps for {self.integration_name}")
        results = {"steps": {}}

        # Step 1: Execute SQL (using existing SQL files) - Skip if ignore_sql is True
        if self.ignore_sql:
            print("\n⏩ Step 2: Skipping SQL execution (ignore_sql=True)")
            execution_result = {"success": True, "skipped": True, "reason": "ignore_sql flag enabled"}
        else:
            print("\n[DATABASE] Step 2: Executing SQL to create database objects...")
            execution_result = self._execute_sql()

        results["steps"]["sql_execution"] = execution_result

        if not execution_result["success"]:
            errors = execution_result.get("errors", [execution_result.get("error", "Unknown error")])
            error_details = "; ".join(errors) if isinstance(errors, list) else str(errors)
            raise Exception(f"SQL execution failed: {error_details}")

        # Step 2: Run integration sync directly (without IntegrationPackage)
        print("\n[SYNC] Step 3: Running integration sync directly...")
        sync_result = self._run_integration_direct()
        results["steps"]["integration_sync"] = sync_result

        if not sync_result["success"]:
            raise Exception(f"Integration sync failed: {sync_result['error']}")

        return results

    def _run_upsert_mode(self) -> Dict[str, Any]:
        """
        Run UPSERT mode: Run integration sync with incremental loading
        (Config update already done in main run() method)

        Steps:
        1. Validate existing setup
        2. Run integration sync with UPSERT flag (incremental params built in ETL layer)

        Returns:
            Dict containing sync results
        """
        print(f"[SYNC] Running UPSERT-specific steps for {self.integration_name}")

        # Validate that setup exists
        print("\n[SEARCH] Step 2: Validating existing setup...")
        validation_result = self._validate_existing_setup()

        if not validation_result["valid"]:
            raise Exception(f"Setup validation failed: {validation_result['error']}")

        # Run integration sync with UPSERT mode flag
        # The incremental parameter building is now handled in the ETL layer (query_builder.py)
        print("\n[SYNC] Step 3: Running integration sync with UPSERT mode...")
        sync_result = self._run_integration_direct(upsert_mode=True)

        if not sync_result["success"]:
            raise Exception(f"Integration sync failed: {sync_result['error']}")

        return {"sync_result": sync_result}

    def _execute_sql(self) -> Dict[str, Any]:
        """Execute generated SQL files"""
        try:
            sql_executor = SQLExecutor()

            # Create client_info for placeholder replacement using same logic as SQLExecutor
            client_info = sql_executor.extract_client_info_from_config(self.integration_name)

            # Handle both client_info formats (client_id vs clientID)
            client_id_val = client_info.get('client_id') or client_info.get('clientID', '')
            org_id_val = client_info.get('org_id') or client_info.get('orgID', '')
            etani_client_id = client_info.get('etani_client_id', '')

            print(f"  [CONFIG] Client Info: clientID={client_id_val}, orgID={org_id_val}, EtaniClientID={etani_client_id}")

            # Set EtaniClientID environment variable if available
            # This is crucial for AWS database selection in sql_executor.py
            if etani_client_id and 'EtaniClientID' not in os.environ:
                os.environ['EtaniClientID'] = etani_client_id.upper()
                print(f"  [CONFIG] Set environment variable: EtaniClientID={etani_client_id.upper()}")

            # Check if we need to handle AWS mode
            use_aws_db = os.getenv('USE_AWS_DB', 'false').lower() in ('true', '1', 'yes')
            if use_aws_db:
                # Extract FIRMCODE from EtaniClientID for AWS database naming
                from sql_helper import get_firmcode_from_client_id
                firmcode = get_firmcode_from_client_id(etani_client_id) if etani_client_id else None
                if firmcode:
                    print(f"  [CONFIG] Extracted FIRMCODE: {firmcode} for database selection")
                else:
                    print(f"  [WARNING]  Could not extract FIRMCODE from EtaniClientID: {etani_client_id}")

            # Only execute specific SQL files
            allowed_sql_files = [
                "create_procedure_table.sql",
                "create_prod_table.sql",
                "create_stage_table.sql",
                "create_view_table.sql"
            ]

            # Find SQL files in the sql directory with the allowed filenames
            sql_files = [f for f in self.sql_dir.glob("*.sql") if f.name in allowed_sql_files]

            if not sql_files:
                return {"success": False, "error": "No SQL files with allowed names found to execute"}

            executed_files = []
            errors = []

            for sql_file in sql_files:
                try:
                    # Skip create_prod_table.sql if client already exists
                    if (hasattr(self, 'is_exist_client') and
                        self.is_exist_client and
                        sql_file.name == 'create_prod_table.sql'):
                        print(f"  ⏩ Skipping: {sql_file.name} (client tables already exist)")
                        continue

                    print(f"  [FILE] Executing: {sql_file.name}")
                    # Pass legacy client ID for view files only
                    result = sql_executor.execute_sql_file(sql_file, client_info, legacy_client_id=self.legacy_client_id)

                    # Handle both old boolean return and new dict return
                    if isinstance(result, dict):
                        success = result.get("success", False)
                        queries_executed = result.get("queries_executed", 0)
                        if success:
                            executed_files.append({
                                "file": sql_file.name,
                                "status": "success",
                                "queries_executed": queries_executed
                            })
                        else:
                            error_msg = result.get("error", "Unknown error")
                            errors.append(f"Error executing {sql_file.name}: {error_msg}")
                            executed_files.append({
                                "file": sql_file.name,
                                "status": "error",
                                "error": error_msg
                            })
                    else:
                        # Old boolean return - assume success if True
                        if result:
                            executed_files.append({
                                "file": sql_file.name,
                                "status": "success",
                                "queries_executed": 1  # Default count
                            })
                        else:
                            error_msg = f"Execution failed for {sql_file.name}"
                            errors.append(error_msg)
                            executed_files.append({
                                "file": sql_file.name,
                                "status": "error",
                                "error": error_msg
                            })

                except Exception as e:
                    error_msg = f"Error executing {sql_file.name}: {str(e)}"
                    errors.append(error_msg)
                    executed_files.append({
                        "file": sql_file.name,
                        "status": "error",
                        "error": str(e)
                    })

            return {
                "success": len(errors) == 0,
                "executed_files": executed_files,
                "errors": errors
            }

        except Exception as e:
            return {"success": False, "error": str(e)}

    def _update_configuration(self) -> Dict[str, Any]:
        """Update configuration with provided parameters using dynamic config-based mapping"""
        try:
            # Set environment variables
            self._set_environment_variables()

            # Update integration config file if it exists
            if self.config_file.exists():
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    config = json.load(f)

                # Update config with parameters using dynamic mapping
                if "env_vars_config" not in config:
                    config["env_vars_config"] = {}

                # Use dynamic parameter mapping based on config file
                updated_count = 0
                for config_field, config_data in config.get("env_vars_config", {}).items():
                    env_var = config_data.get("env_var", "")
                    
                    # Check if we have a parameter that matches this config
                    param_value = None
                    if env_var in self.parameters:
                        param_value = self.parameters[env_var]
                    elif config_field.upper() in self.parameters:
                        param_value = self.parameters[config_field.upper()]
                    elif config_field in self.parameters:
                        param_value = self.parameters[config_field]
                    
                    if param_value is not None:
                        config_data["default_value"] = param_value
                        updated_count += 1
                        print(f"  [OK] Updated {config_field}: {param_value}")

                # Save updated config
                with open(self.config_file, 'w', encoding='utf-8') as f:
                    json.dump(config, f, indent=2, ensure_ascii=False)

                print(f"  [OK] Updated config file: {self.config_file} ({updated_count} fields)")

            return {"success": True, "parameters_set": list(self.parameters.keys())}

        except Exception as e:
            return {"success": False, "error": str(e)}

    def _set_environment_variables(self):
        """Set environment variables from parameters using dynamic config-based mapping"""
        try:
            # Load config to get env var mappings
            if self.config_file.exists():
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    config = json.load(f)
                
                # Use config-based mapping
                for config_field, config_data in config.get("env_vars_config", {}).items():
                    env_var = config_data.get("env_var", "")
                    
                    # Check if we have a parameter that matches this config
                    param_value = None
                    if env_var in self.parameters:
                        param_value = self.parameters[env_var]
                    elif config_field.upper() in self.parameters:
                        param_value = self.parameters[config_field.upper()]
                    elif config_field in self.parameters:
                        param_value = self.parameters[config_field]
                    
                    if param_value is not None and env_var:
                        os.environ[env_var] = str(param_value)
                        print(f"  [CONFIG] Set {env_var}={param_value}")
            else:
                # Fallback: use direct mapping for common parameters
                for param_name, param_value in self.parameters.items():
                    env_var = param_name.upper()
                    os.environ[env_var] = str(param_value)
                    print(f"  [CONFIG] Set {env_var}={param_value}")

        except Exception as e:
            print(f"[WARNING] Warning: Error setting environment variables: {e}")

# Incremental parameter building is now handled in the ETL layer (query_builder.py)
    # This provides better separation of concerns and keeps all API-related logic together

    def _run_integration_direct(self, upsert_mode: bool = False) -> Dict[str, Any]:
        """Run the integration directly without IntegrationPackage"""
        try:
            # Ensure correct database engines for this integration run
            print("[SYNC] Refreshing AWS engines if needed...")
            from sql_helper import refresh_aws_engines_if_needed
            refresh_aws_engines_if_needed()
            # Import the specific integration class dynamically
            integration_module_path = f"dynamic_integrations.generated_integrations.{self.integration_name}.{self.integration_name}_integration"

            try:
                import importlib
                integration_module = importlib.import_module(integration_module_path)

                # Get the integration class (assumes class name is like QBOIntegration, FYIIntegration)
                class_name = f"{self.integration_name.upper()}Integration"
                if not hasattr(integration_module, class_name):
                    # Try capitalized version
                    class_name = f"{self.integration_name.capitalize()}Integration"

                integration_class = getattr(integration_module, class_name)

                # Create integration instance with UPSERT mode
                config = {}
                if upsert_mode:
                    config['upsert_mode'] = True
                    
                    # Add custom UPSERT parameters from command line
                    upsert_params = {}
                    for param_key, param_value in self.parameters.items():
                        # Skip standard parameters, only include custom API parameters
                        if param_key not in ['EtaniClientID', 'EtaniOrganisationID']:
                            upsert_params[param_key] = param_value

                    # Set global time-from parameter for child endpoints if provided
                    if 'time-from' in upsert_params:
                        from dynamic_integrations.etl.extractors.child_endpoint_handler import set_custom_time_from
                        set_custom_time_from(upsert_params['time-from'])
                        print(f"  [TIME] Set global time-from parameter: {upsert_params['time-from']}")

                    if upsert_params:
                        config['custom_upsert_params'] = upsert_params
                        print(f"  [DATA] Enabling UPSERT mode with custom params: {list(upsert_params.keys())}")
                    else:
                        print(f"  [DATA] Enabling UPSERT mode with auto-detected timestamp params")
                
                # Pass refresh_token if available
                if hasattr(self, 'refresh_token') and self.refresh_token:
                    integration_instance = integration_class(config if config else None, refresh_token=self.refresh_token)
                    print(f"  [SECURE] Passing refresh_token to integration")
                else:
                    integration_instance = integration_class(config if config else None)

                print(f"  [CONFIG] Created {class_name} instance")
                
                # Set UPSERT mode if supported
                if upsert_mode and hasattr(integration_instance, 'set_upsert_mode'):
                    integration_instance.set_upsert_mode(True)
                    print(f"  [UPSERT] Enabled UPSERT mode in integration")
                
                # Validate configuration
                if hasattr(integration_instance, 'validate_configuration'):
                    if not integration_instance.validate_configuration():
                        return {"success": False, "error": "Integration configuration validation failed"}
                    print(f"  [OK] Configuration validated")

                # Use run_full_sync method - UPSERT mode is handled internally by the ETL layer
                sync_method = 'run_full_sync'
                if upsert_mode:
                    print(f"  [SYNC] Running full sync with UPSERT mode (incremental params built in ETL layer)")
                else:
                    print(f"  [INSERT] Running full sync with INSERT mode")

                # Run sync
                if hasattr(integration_instance, sync_method):
                    print(f"  [START] Running {sync_method.replace('_', ' ')}...")
                    
                    result = integration_instance.run_full_sync()
                    
                    if result.get('status') in ['completed', 'completed_with_errors']:
                        return {
                            "success": True, 
                            "result": result,
                            "integration_class": class_name,
                            "sync_method": sync_method,
                            "records_processed": result.get('total_records_processed', 0),
                            "upsert_mode_enabled": upsert_mode
                        }
                    else:
                        return {
                            "success": False, 
                            "error": f"Integration sync failed with status: {result.get('status')}", 
                            "result": result
                        }
                else:
                    return {"success": False, "error": f"Integration class {class_name} does not have {sync_method} method"}

            except ImportError as e:
                return {"success": False, "error": f"Could not import integration module: {e}"}
            except AttributeError as e:
                return {"success": False, "error": f"Integration class not found: {e}"}

        except Exception as e:
            return {"success": False, "error": str(e)}
        finally:
            # Clear global time-from parameter after integration completes (success or failure)
            if upsert_mode:
                try:
                    from dynamic_integrations.etl.extractors.child_endpoint_handler import clear_custom_time_from
                    clear_custom_time_from()
                    print(f"  [CLEAN] Cleared global time-from parameter")
                except Exception:
                    pass  # Ignore errors during cleanup

    def _validate_existing_setup(self) -> Dict[str, Any]:
        """Validate that existing setup is complete for UPSERT mode"""
        try:
            issues = []

            # Check schema file exists
            if not self.schema_file.exists():
                issues.append(f"Schema file missing: {self.schema_file}")

            # Check SQL directory exists
            if not self.sql_dir.exists():
                issues.append(f"SQL directory missing: {self.sql_dir}")

            # Check integration file exists
            integration_file = self.integration_dir / f"{self.integration_name}_integration.py"
            if not integration_file.exists():
                issues.append(f"Integration file missing: {integration_file}")

            if issues:
                return {
                    "valid": False,
                    "error": f"Setup incomplete: {'; '.join(issues)}"
                }

            return {"valid": True}

        except Exception as e:
            return {"valid": False, "error": str(e)}


def parse_parameters(param_list: List[str]) -> Dict[str, Any]:
    """
    Parse parameter list into dictionary

    Args:
        param_list: List of parameters in format ["key=value", "key=value"]

    Returns:
        Dict of parsed parameters
    """
    parameters = {}

    for param in param_list:
        if "=" not in param:
            raise ValueError(f"Invalid parameter format: {param}. Expected format: key=value")

        key, value = param.split("=", 1)
        parameters[key.strip()] = value.strip()

    return parameters


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description="Dynamic Integration Runner - Simplified INSERT/UPSERT workflow",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
            Examples:
              # INSERT - Simplified setup (config + SQL + direct run)
              python run_dynamic_integration.py --integration qbo --mode insert \\
                --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \\
                --param EtaniOrganisationID=7035 \\
                --param RealmID=123456789

              # UPSERT - Just run integration sync
              python run_dynamic_integration.py --integration qbo --mode upsert \\
                --param EtaniClientID=BIGOLESHOECOMPANY_CLIENT2013 \\
                --param EtaniOrganisationID=7035

              # Database-driven mode - Only provide org_id, fetch everything else from database
              python run_dynamic_integration.py --org-id 7102 --mode upsert
        """
    )

    parser.add_argument(
        "--integration",
        required=False,
        help="Integration name (e.g., qbo, jobman, fyi) - Not required if --org-id is provided"
    )

    parser.add_argument(
        "--mode",
        choices=["insert", "upsert"],
        required=True,
        help="Workflow mode: 'insert' (simplified setup) or 'upsert' (sync only)"
    )

    parser.add_argument(
        "--org-id",
        help="Organization ID - Fetch all parameters from database (Lambda invocation mode)"
    )

    parser.add_argument(
        "--param",
        action="append",
        default=[],
        help="Parameter in format key=value (can be used multiple times)"
    )

    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Enable verbose output"
    )
    
    parser.add_argument(
        "--is-exist-client",
        action="store_true",
        help="Skip production table creation (client tables already exist)"
    )

    parser.add_argument(
        "--ignore-sql",
        action="store_true",
        help="Skip SQL execution during insert mode"
    )

    parser.add_argument(
        "--legacy-client-id",
        help="Legacy client ID for SQL view naming (optional)"
    )

    args = parser.parse_args()

    try:
        # Check if using database-driven mode (--org-id provided)
        if args.org_id:
            print("=" * 80)
            print("DATABASE-DRIVEN MODE")
            print("=" * 80)
            print(f"[INFO] Organization ID: {args.org_id}")
            print(f"[SEARCH] Fetching all parameters from database...")

            # Fetch all parameters from database
            from dynamic_integrations.org_parameter_fetcher import fetch_parameters_from_database

            fetch_result = fetch_parameters_from_database(args.org_id)

            if not fetch_result['success']:
                print(f"[ERROR] Failed to fetch parameters from database")
                print(f"Error: {fetch_result['error']}")
                sys.exit(1)

            # Extract integration name and parameters
            integration_name = fetch_result['integration']
            parameters = fetch_result['parameters']
            service_id = fetch_result['service_id']
            status = fetch_result['status']

            print(f"[OK] Fetched parameters for integration: {integration_name}")
            print(f"   Service ID: {service_id}")
            print(f"   Status: {status}")
            print(f"   Parameters: {list(parameters.keys())}")

            # DIAGNOSTIC: Show sensitive parameter values (masked)
            print(f"\n[SEARCH] DIAGNOSTIC: Parameter values:")
            for key, value in parameters.items():
                # Mask sensitive fields
                sensitive_keywords = ['SECRET', 'PASSWORD', 'TOKEN', 'KEY', 'CREDENTIAL']
                is_sensitive = any(keyword in key.upper() for keyword in sensitive_keywords)

                if is_sensitive and value:
                    value_str = str(value)
                    masked = f"{value_str[:4]}...{value_str[-4:]}" if len(value_str) > 12 else "***"
                    print(f"   {key}: {masked} [MASKED]")
                else:
                    print(f"   {key}: {value}")

            # Validate status based on mode
            if args.mode == 'insert':
                # INSERT mode: Status 9 (Provisioning) is correct
                if status not in [9]:
                    print(f"[WARNING]  Warning: Organization status is {status} (expected 9 for INSERT mode)")
                    print(f"   Status 9 = Provisioning (clean full load)")
                    print(f"   Integration may not run successfully")
            else:
                # UPSERT mode: Status 1 or 12
                if status not in [1, 12]:
                    print(f"[WARNING]  Warning: Organization status is {status} (expected 1 or 12 for UPSERT mode)")
                    print(f"   Status 1 = Active (scheduled), Status 12 = Updating Data (manual)")
                    print(f"   Integration may not run successfully")

        else:
            # Traditional mode - require --integration and --param arguments
            if not args.integration:
                print("[ERROR] Error: Either --org-id or --integration must be provided")
                sys.exit(1)

            integration_name = args.integration
            parameters = parse_parameters(args.param)

            if not parameters:
                print("[WARNING] Warning: No parameters provided")

        # Load Xero OAuth credentials from AWS Secrets Manager (before orchestrator creation)
        xero_integrations = ['payroll_au', 'payroll_nz', 'xeroproject', 'xpm', 'xeroblue']
        if integration_name.lower() in xero_integrations:
            try:
                print("\n[SECURE] Loading Xero OAuth credentials from AWS Secrets Manager...")
                set_xero_oauth_env_vars()
                print("[OK] Xero OAuth credentials loaded successfully from Secrets Manager")
            except Exception as secrets_error:
                print(f"[ERROR] Failed to load Xero OAuth credentials from Secrets Manager: {secrets_error}")
                print(f"[WARNING] Integration may fail if config file defaults are empty")

        # Create and run orchestrator
        orchestrator = IntegrationWorkflowOrchestrator(
            integration_name=integration_name,
            mode=args.mode,
            parameters=parameters,
            is_exist_client=args.is_exist_client,
            ignore_sql=getattr(args, 'ignore_sql', False),
            legacy_client_id=getattr(args, 'legacy_client_id', None)
        )

        result = orchestrator.run()

        # Print results
        if result["status"] == "success":
            print(f"\n[SUCCESS] {args.mode.upper()} workflow completed successfully!")
            if args.verbose:
                print(f"[DATA] Execution time: {result['execution_time']:.2f} seconds")
                if "steps" in result:
                    print("📝 Steps completed:")
                    for step_name, step_result in result["steps"].items():
                        status = "[OK]" if step_result.get("success", True) else "[ERROR]"
                        print(f"  {status} {step_name}")
        else:
            print(f"\n[ERROR] {args.mode.upper()} workflow failed!")
            print(f"Error: {result['error']}")
            sys.exit(1)

    except KeyboardInterrupt:
        print("\n[WARNING] Workflow interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"[ERROR] Error: {str(e)}")
        sys.exit(1)

    finally:
        # CRITICAL: Cleanup all database connections before exit
        # Must be called BEFORE any sys.exit() to ensure ACU scale-down
        try:
            from sql_helper import cleanup_all_connections
            cleanup_all_connections()
        except Exception as cleanup_err:
            # Silent failure - don't prevent script exit
            print(f"⚠ Warning: Connection cleanup failed: {cleanup_err}")


if __name__ == "__main__":
    main()