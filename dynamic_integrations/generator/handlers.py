import json
import os
from pathlib import Path

from dynamic_integrations.generator.prompt_builder import PromptBuilder
from dynamic_integrations.generator.utils import Utils
from dynamic_integrations.generator.schema_to_config import SchemaToConfigConverter
from dynamic_integrations.generator.integration_dynamic import DynamicIntegration


class GeneratorHandlers:
    def __init__(self, force: bool = False):
        self.force = force
        self.schema_converter = SchemaToConfigConverter()

    @staticmethod
    def handle_sql(schemas, sql_type: str = None):
        """Redirect to hybrid approach for consistency"""
        return GeneratorHandlers.handle_sql_hybrid(schemas, sql_type)

    @staticmethod
    def handle_sql_hybrid(schemas, sql_type: str = None):
        """
        Handle SQL generation using unified approach (template-first + LLM verification)
        
        Args:
            schemas: Schema data
            sql_type: Type of SQL to generate (stage, prod, view, procedure)
        """
        integration = schemas[0].get("integration_name", "").lower()
        if not integration:
            raise ValueError("integration_name is required in schema but was not found")
        
        print(f"🔥 Generating {sql_type} SQL for {integration} using UNIFIED approach")
        print(f"🚀 Template-first + LLM verification for optimal results & efficiency")
        
        try:
            # Use new unified SQL generator
            from dynamic_integrations.generator.unified_sql_generator import UnifiedSQLGenerator
            
            # Set up paths
            base_dir = Path(__file__).parent.parent
            schema_dir = base_dir / "generated_integrations" / integration / "schemas"
            output_dir = base_dir / "generated_integrations" / integration / "sql"
            
            # Create unified generator
            generator = UnifiedSQLGenerator(
                integration_name=integration,
                use_llm_verification=True  # Enable LLM verification by default
            )
            
            # Generate SQL file
            result_file = generator.generate_sql_type(schema_dir, output_dir, sql_type)
            
            print(f"✅ Unified SQL generation completed: {result_file}")
            return result_file
            
        except Exception as e:
            print(f"❌ Unified SQL generation failed: {e}")
            return None
    
    @staticmethod
    def _convert_schemas_to_entities(schemas, sql_type: str):
        """Convert schema format to entity format for hybrid handler"""
        entities = []
        
        for schema in schemas:
            schema_endpoints = schema.get("endpoints", [])
            for endpoint in schema_endpoints:
                # Skip virtual endpoints for SQL generation
                if endpoint.get("is_virtual_endpoint", False):
                    continue

                # Convert endpoint to entity schema format
                entity = {
                    "name": endpoint.get("name", "unknown"),
                    "description": endpoint.get("description", ""),
                    "entity_type": endpoint.get("entity_type", "unknown"),
                    "fields": endpoint.get("fields", [])
                }
                entities.append(entity)
        
        return entities

    def handle_dynamic_integration_file(self, schemas):
        """
        Handle dynamic integration file generation - creates Python integration file that inherits from DynamicIntegration
        """
        if not schemas:
            print("⚠️ No schemas provided.")
            return
        
        try:
            schema = schemas[0]
            integration_name = schema.get("integration_name", "unknown").upper()
            
            print(f"🔄 Generating dynamic integration file for {integration_name}...")
            
            # Generate integration file path in generated_integrations directory
            integration_file_path = f"generated_integrations/{integration_name.lower()}/{integration_name.lower()}_integration.py"
            
            if not self.force and Path(integration_file_path).exists():
                print(f"⚠️ Integration file already exists: {integration_file_path}")
                if input("Overwrite? (y/n): ").lower() != 'y':
                    return
            
            # Step 1: Create base structure from template (clean approach)
            print("📝 Creating clean integration from template...")
            final_content = self._create_integration_from_template(schema, integration_name)
            
            # DISABLED: Step 2 & 3 - LLM generation creates redundant functions
            # DynamicIntegration already provides all needed functionality
            # No need for additional LLM-generated methods that duplicate existing capabilities
            print("✅ Using template-only approach (no LLM generation needed)")
            # prompt = PromptBuilder.build_dynamic_integration_prompt(schema, integration_name)
            # specific_methods = Utils.run_claude_prompt(prompt)
            # final_content = self._merge_base_and_specific_methods(base_content, specific_methods, integration_name)
            
            # Write integration file
            Utils.write_file_if_not_exists(Path(integration_file_path), final_content, self.force)
            
            print(f"✅ Dynamic integration file generated: {integration_file_path}")
            
            # Verify the file can be imported
            try:
                import importlib.util
                spec = importlib.util.spec_from_file_location(
                    f"{integration_name.lower()}_integration", 
                    integration_file_path
                )
                module = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(module)
                print(f"✅ Integration file syntax verified successfully")
            except Exception as e:
                print(f"⚠️ Warning: Integration file syntax verification failed: {e}")
            
        except Exception as e:
            print(f"❌ Error generating dynamic integration file: {e}")

    def _create_integration_from_template(self, schema: dict, integration_name: str) -> str:
        """
        Create integration file from template by replacing placeholders with schema data
        """
        try:
            # Read template file
            template_path = Path(__file__).parent / "integration_template.py"
            with open(template_path, 'r') as f:
                template_content = f.read()
            
            # Extract comprehensive API configuration from schema
            api_config = schema.get("api_config", {})
            authentication = api_config.get("authentication", {})
            pagination = api_config.get("pagination", {})
            error_handling = api_config.get("error_handling", {})
            endpoints = schema.get("endpoints", [])
            
            # Load integration config to get auth_type
            from .utils import Utils
            integration_config = Utils.load_integration_config(integration_name.upper())
            
            # Extract configuration values - prioritize config over schema
            api_base_url = integration_config.get("api_base_url") or api_config.get("base_url", "https://api.example.com")
            # Get auth_type from config first, then schema authentication
            auth_type = integration_config.get("auth_type") or authentication.get("type", "oauth2")
            rate_limit = authentication.get("rate_limiting", {}).get("requests_per_minute", 60)
            
            # Get all endpoint names (not limited to 10), excluding virtual endpoints
            endpoint_names = [endpoint.get("name", "unknown") for endpoint in endpoints if not endpoint.get("is_virtual_endpoint", False)]
            
            # Extract custom procedures names from schema
            custom_procedures_raw = schema.get("custom_procedures", [])
            custom_procedures = [proc.get("name", "unknown") for proc in custom_procedures_raw] if custom_procedures_raw else []
            
            # Prepare configuration objects as strings
            import json
            
            # Use integration config auth_config directly
            config_auth = integration_config.get('auth_config', {})
            
            if auth_type == "oauth2":
                auth_config = {
                    "token_url": config_auth.get("token_url", "https://oauth.example.com/token"),
                    "client_id_env_var": config_auth.get("client_id_env_var", f"{integration_name.upper()}_CLIENT_ID"),
                    "client_secret_env_var": config_auth.get("client_secret_env_var", f"{integration_name.upper()}_CLIENT_SECRET"),
                    "additional_params": config_auth.get("additional_params", {}),
                    "custom_headers": config_auth.get("custom_headers", {})
                }
            elif auth_type == "api_key":
                auth_config = {
                    "api_key_env_var": config_auth.get("api_key_env_var", f"{integration_name.upper()}_API_KEY"),
                    "key_location": config_auth.get("key_location", "header"),
                    "key_name": config_auth.get("key_name", "X-API-Key"),
                    "custom_headers": config_auth.get("custom_headers", {})
                }
            elif auth_type == "basic_auth":
                auth_config = {
                    "username_env_var": config_auth.get("username_env_var", f"{integration_name.upper()}_USERNAME"),
                    "password_env_var": config_auth.get("password_env_var", f"{integration_name.upper()}_PASSWORD"),
                    "custom_headers": config_auth.get("custom_headers", {})
                }
            else:
                auth_config = config_auth if config_auth else {"type": auth_type}
            
            # Format as Python literals instead of JSON strings
            import pprint
            
            authentication_config = pprint.pformat(auth_config, indent=4, width=80)
            
            # Get pagination from config first, then schema
            config_pagination = integration_config.get('pagination_config', {})
            
            pagination_config_dict = {
                "type": config_pagination.get("type") or pagination.get("type", "offset"),
                "limit_param": config_pagination.get("limit_param") or pagination.get("limit_param", "limit"),
                "offset_param": config_pagination.get("offset_param") or pagination.get("offset_param", "offset"),
                "default_limit": config_pagination.get("default_limit") or pagination.get("default_limit", 100),
                "max_limit": config_pagination.get("max_limit") or pagination.get("max_limit", 1000)
            }
            pagination_config = pprint.pformat(pagination_config_dict, indent=4, width=80)
            
            # Use enterprise retry system configurations
            error_handling_config_dict = {
                "retry_codes": error_handling.get("retry_codes", [429, 500, 502, 503, 504]),
                "max_retries": error_handling.get("max_retries", 5),  # API_CALLS default
                "backoff_strategy": error_handling.get("backoff_strategy", "exponential"),
                "enterprise_retry_strategy": "API_CALLS",  # Reference enterprise strategy
                "gateway_retry_codes": [502, 503, 504],  # Gateway-specific codes
                "use_enterprise_retry": True  # Flag to enable enterprise retry system
            }
            error_handling_config = pprint.pformat(error_handling_config_dict, indent=4, width=80)
            
            endpoints_config = pprint.pformat(endpoint_names, indent=4, width=80)
            
            # Format custom procedures configuration
            custom_procedures_config = pprint.pformat(custom_procedures, indent=4, width=80)
            
            # Replace placeholders with schema data
            content = template_content.replace("__INTEGRATION_NAME__", integration_name)
            content = content.replace("__INTEGRATION_NAME_LOWER__", integration_name.lower())
            content = content.replace("__INTEGRATION_NAME_UPPER__", integration_name.upper())
            content = content.replace("'__ENDPOINTS__'", endpoints_config)  # Remove quotes and replace
            content = content.replace("'__CUSTOM_PROCEDURES__'", custom_procedures_config)  # Remove quotes and replace
            
            return content
            
        except Exception as e:
            print(f"❌ Error creating integration from template: {e}")
            import traceback
            traceback.print_exc()
            return ""

    def _merge_base_and_specific_methods(self, base_content: str, specific_methods: str, integration_name: str) -> str:
        """
        Merge base template content with API-specific methods generated by LLM
        """
        try:
            # Check for execution errors first
            if "Execution error" in specific_methods:
                print("⚠️ Warning: Execution error found in LLM response, skipping API-specific methods")
                return base_content
            
            # Extract clean Python code from LLM response
            clean_methods = Utils.extract_python_code(specific_methods)
            
            # Additional check after cleaning
            if not clean_methods or clean_methods.strip() == "" or "Execution error" in clean_methods:
                print("⚠️ Warning: No valid Python methods found in LLM response")
                return base_content
            
            # Find insertion point - before the main() function
            main_function_start = base_content.find("def main():")
            if main_function_start == -1:
                # If main() not found, append to end of class
                class_end = base_content.rfind("    def run_full_sync")
                if class_end != -1:
                    # Find end of run_full_sync method
                    next_def = base_content.find("\n\ndef", class_end)
                    if next_def != -1:
                        insertion_point = next_def
                    else:
                        insertion_point = len(base_content)
                else:
                    insertion_point = len(base_content)
            else:
                insertion_point = main_function_start
            
            # Insert specific methods before main() function
            final_content = (
                base_content[:insertion_point] + 
                "\n    # API-specific methods generated by LLM\n" +
                clean_methods + 
                "\n\n" +
                base_content[insertion_point:]
            )
            
            return final_content
            
        except Exception as e:
            print(f"❌ Error merging base and specific methods: {e}")
            return base_content

    def handle_test(self, schemas):
        for schema in schemas:
            integration = schema.get("integration_name", "").lower()
            if not integration:
                raise ValueError("integration_name is required in schema but was not found")
            test_path = Path(f"tests/integration/test_{integration}_integration.py")
            if self.force or not test_path.exists():
                prompt = PromptBuilder.build_test_prompt(schema)
                response = Utils.run_claude_prompt(prompt)
                clean_python_code = Utils.extract_python_code(response)
                Utils.write_file_if_not_exists(test_path, clean_python_code, self.force)