from typing import Dict, List
import json


class PromptBuilder:
    """
    Builder for creating prompts for LLM integration generation
    (SQL prompts moved to unified_sql_generator.py)
    """

    @staticmethod
    def build_dynamic_integration_prompt(schema: dict, integration_name: str) -> str:
        """
        Build prompt for generating API-specific methods with dynamic schema components
        
        Args:
            schema: Schema data containing endpoints and configuration
            integration_name: Name of the integration (e.g., "QBO", "Salesforce")
            
        Returns:
            str: Prompt for LLM to generate API-specific methods with schema-based configuration
        """
        import json
        
        # Extract information from schema
        endpoints = schema.get("endpoints", [])
        api_config = schema.get("api_config", {})
        authentication = api_config.get("authentication", {})
        pagination = api_config.get("pagination", {})
        error_handling = api_config.get("error_handling", {})
        
        # Get all endpoint names from schema
        endpoint_names = [endpoint.get("name", "unknown") for endpoint in endpoints]
        
        # Get API configuration
        api_base_url = api_config.get("base_url", "https://api.example.com")
        auth_type = authentication.get("type", "oauth2")
        rate_limit = authentication.get("rate_limiting", {}).get("requests_per_minute", 60)
        
        # Get pagination info
        pagination_type = pagination.get("type", "offset")
        limit_param = pagination.get("limit_param", "limit")
        offset_param = pagination.get("offset_param", "offset")
        default_limit = pagination.get("default_limit", 100)
        max_limit = pagination.get("max_limit", 1000)
        
        # Get error handling info (enterprise retry compatible)
        retry_codes = error_handling.get("retry_codes", [429, 500, 502, 503, 504])
        max_retries = error_handling.get("max_retries", 5)  # API_CALLS default
        backoff_strategy = error_handling.get("backoff_strategy", "exponential")
        enterprise_strategy = error_handling.get("enterprise_retry_strategy", "API_CALLS")
        gateway_codes = [502, 503, 504]
        
        return f"""
GENERATE ONLY VALID PYTHON CODE. DO NOT INCLUDE ANY EXPLANATIONS, COMMENTS, OR CONVERSATIONAL TEXT.
RETURN ONLY THE PYTHON METHODS BELOW WITH PROPER INDENTATION (4 spaces for class methods).
ALL METHODS MUST BE INDENTED AS CLASS METHODS WITH 4 SPACES.

    def get_specific_endpoints(self):
        \"\"\"Return {integration_name}-specific endpoints from schema\"\"\"
        return {{
            'base_url': '{api_base_url}',
            'endpoints': {endpoint_names},
            'authentication': {{
                'type': '{auth_type}',
                'rate_limit': {rate_limit}
            }},
            'pagination': {{
                'type': '{pagination_type}',
                'limit_param': '{limit_param}',
                'offset_param': '{offset_param}',
                'default_limit': {default_limit},
                'max_limit': {max_limit}
            }},
            'error_handling': {{
                'retry_codes': {retry_codes},
                'max_retries': {max_retries},
                'backoff_strategy': '{backoff_strategy}',
                'enterprise_retry_strategy': '{enterprise_strategy}',
                'gateway_retry_codes': {gateway_codes},
                'use_enterprise_retry': True
            }}
        }}

    def get_authentication_config(self):
        \"\"\"Return authentication configuration from schema\"\"\"
        return {{
            'type': '{auth_type}',
            'rate_limiting': {{
                'requests_per_minute': {rate_limit},
                'burst_limit': {authentication.get("rate_limiting", {}).get("burst_limit", 100)}
            }}
        }}

    def get_pagination_config(self):
        \"\"\"Return pagination configuration from schema\"\"\"
        return {{
            'type': '{pagination_type}',
            'limit_param': '{limit_param}',
            'offset_param': '{offset_param}',
            'default_limit': {default_limit},
            'max_limit': {max_limit}
        }}

    def get_error_handling_config(self):
        \"\"\"Return error handling configuration from schema\"\"\"
        return {{
            'retry_codes': {retry_codes},
            'max_retries': {max_retries},
            'backoff_strategy': '{backoff_strategy}',
            'enterprise_retry_strategy': '{enterprise_strategy}',
            'gateway_retry_codes': {gateway_codes},
            'use_enterprise_retry': True
        }}

    def transform_data(self, endpoint_name, raw_data):
        \"\"\"Transform data for specific endpoint\"\"\"
        if not raw_data:
            return []
        
        if isinstance(raw_data, dict):
            return [raw_data]
        elif isinstance(raw_data, list):
            return raw_data
        else:
            return []

    def validate_response(self, response):
        \"\"\"Validate API response\"\"\"
        if not response:
            return False
        
        return isinstance(response, (dict, list))

    def should_retry(self, status_code):
        \"\"\"Check if request should be retried based on schema config (enterprise compatible)\"\"\"
        return status_code in {retry_codes}

    def should_retry_gateway(self, status_code):
        \"\"\"Check if request should be retried with gateway strategy\"\"\"
        return status_code in {gateway_codes}

    def get_retry_config(self):
        \"\"\"Get retry configuration from schema\"\"\"
        return {{
            'max_retries': {max_retries},
            'backoff_strategy': '{backoff_strategy}',
            'retry_codes': {retry_codes},
            'enterprise_retry_strategy': '{enterprise_strategy}',
            'gateway_retry_codes': {gateway_codes},
            'use_enterprise_retry': True
        }}
        """.strip()

    @staticmethod
    def _render_entities(schema_batch: List[Dict]) -> str:
        """Render entities list for prompts"""
        entities = []
        for schema in schema_batch:
            # Handle both 'entity' and 'name' keys for compatibility
            entity_name = schema.get("entity") or schema.get("name", "unknown")
            entities.append(f"- {entity_name}")
        return "\n".join(entities)
    
    @staticmethod
    def _render_compact_schema(schema_batch: List[Dict]) -> str:
        """Render compact schema for prompts"""
        compact_data = []
        for entity in schema_batch:
            # Handle both 'entity' and 'name' keys for compatibility
            entity_name = entity.get("entity") or entity.get("name", "unknown")
            compact_entity = {
                "entity": entity_name,
                "field_mapping": entity.get("field_mapping", {}),
                "primary_keys": entity.get("primary_keys", []),
                "fields": entity.get("fields", [])  # Include fields for hybrid approach
            }
            compact_data.append(compact_entity)
        return json.dumps(compact_data, indent=2)

    @staticmethod
    def build_test_prompt(schema: dict) -> str:
        """
        Build prompt for generating test files
        
        Args:
            schema: Schema data containing integration information
            
        Returns:
            str: Prompt for LLM to generate test code
        """
        integration_name = schema.get("integration_name", "unknown")
        endpoints = schema.get("endpoints", [])
        
        endpoint_names = [ep.get("name", "unknown") for ep in endpoints]
        endpoints_list = "\n".join([f"- {name}" for name in endpoint_names])
        
        return f"""
            Generate comprehensive unit tests for the {integration_name} integration.
            
            ## Integration Details:
            - Integration Name: {integration_name}
            - Endpoints: {endpoints_list}
            
            ## Test Requirements:
            1. Test all major methods of the integration class
            2. Mock external API calls
            3. Test error handling
            4. Test data transformation
            5. Use pytest framework
            6. Include setup and teardown methods
            
            ## Output Requirements:
            - Complete Python test file
            - Use pytest and unittest.mock
            - Include proper imports
            - Test both success and failure scenarios
            - **NO** markdown code blocks
            - **NO** explanations
            
            Generate the test file:
            """.strip()