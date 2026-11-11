"""
⚠️  DEPRECATION NOTICE ⚠️
=======================
This standalone schema-to-config converter is now integrated into the unified workflow.

🔄 MIGRATION GUIDE:
- OLD: python schema_to_config.py schema.json --output config.json
- NEW: python run_dynamic_integration.py --integration INTEGRATION_NAME --mode insert

Configuration generation is now handled automatically in the INSERT workflow.

For the complete workflow, use:
    python run_dynamic_integration.py --help

This converter will be maintained for compatibility but new development should use run_dynamic_integration.py
=======================

Schema to Configuration Converter

Converts schema files or integration_entities output to DynamicIntegration configuration.
This bridges the gap between schema discovery and dynamic integration execution.
"""

import json
import os
import sys
from typing import Dict, List, Optional, Any, Union
from pathlib import Path
from dataclasses import dataclass, field, asdict

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


@dataclass
class EndpointConfig:
    """Configuration for a single API endpoint"""
    path: str
    method: str = "GET"
    data_path: Optional[str] = None
    query_params: Dict[str, Any] = field(default_factory=dict)
    schema_columns: Optional[List[str]] = None
    transformations: Dict[str, Dict] = field(default_factory=dict)
    pagination: Dict[str, Any] = field(default_factory=dict)


@dataclass
class AuthConfig:
    """Authentication configuration"""
    auth_type: str  # oauth2, api_key, basic_auth
    token_url: Optional[str] = None
    client_id_env_var: Optional[str] = None
    client_secret_env_var: Optional[str] = None
    api_key_env_var: Optional[str] = None
    username_env_var: Optional[str] = None
    password_env_var: Optional[str] = None
    key_location: str = "header"  # header, query
    key_name: str = "X-API-Key"
    additional_params: Dict[str, Any] = field(default_factory=dict)
    custom_headers: Dict[str, str] = field(default_factory=dict)


@dataclass
class IntegrationConfig:
    """Complete integration configuration"""
    integration_name: str
    api_base_url: str
    auth_config: AuthConfig
    endpoints: Dict[str, EndpointConfig]
    capabilities: str = "UPSERT"
    allowed_statuses: List[int] = field(default_factory=lambda: [9, 12])
    rate_limit: int = 60
    timeout_seconds: int = 30


class SchemaToConfigConverter:
    """
    Converts various schema formats to DynamicIntegration configuration
    """
    
    def __init__(self):
        # Auth type templates - generic patterns based on authentication method
        self.auth_templates = {
            'oauth2': self._get_oauth2_template(),
            'api_key': self._get_api_key_template(),
            'basic_auth': self._get_basic_auth_template(),
            'bearer_token': self._get_bearer_token_template(),
        }
    
    def convert_from_schema_file(self, schema_file: str, api_type: str = None) -> IntegrationConfig:
        """
        Convert schema file to integration configuration
        
        Args:
            schema_file: Path to schema JSON file
            api_type: Optional API type hint (qbo, salesforce, etc.)
            
        Returns:
            IntegrationConfig instance
        """
        with open(schema_file, 'r') as f:
            schema_data = json.load(f)
        
        # Handle both single schema and list of schemas
        if isinstance(schema_data, list):
            schema_data = schema_data[0] if schema_data else {}
        
        return self._convert_schema_data(schema_data, api_type)
    
    def convert_from_integration_entities(self, entities_result: Dict[str, Any], api_type: str = None) -> IntegrationConfig:
        """
        Convert integration_entities output to configuration
        
        Args:
            entities_result: Output from integration_entities wizard
            api_type: Optional API type hint
            
        Returns:
            IntegrationConfig instance
        """
        return self._convert_entities_data(entities_result, api_type)
    
    def convert_from_api_discovery(self, discovery_data: Dict[str, Any], api_type: str = None) -> IntegrationConfig:
        """
        Convert API discovery data to configuration
        
        Args:
            discovery_data: API discovery/documentation data
            api_type: API type (qbo, salesforce, etc.)
            
        Returns:
            IntegrationConfig instance
        """
        return self._convert_discovery_data(discovery_data, api_type)
    
    def _convert_schema_data(self, schema_data: Dict[str, Any], api_type: str = None) -> IntegrationConfig:
        """Convert schema data to configuration"""
        
        # Extract basic info
        integration_name = schema_data.get('integration_name', 'unknown')
        api_base_url = schema_data.get('api_base_url', '')
        
        # Auto-detect API type if not provided
        if not api_type:
            api_type = self._detect_api_type(api_base_url, integration_name)
        
        # Get patterns for this API type
        patterns = self._get_api_patterns(api_type)
        
        # Build auth configuration
        auth_config = self._build_auth_config(schema_data, patterns)
        
        # Build endpoint configurations
        endpoints = self._build_endpoints_from_schema(schema_data, patterns)
        
        return IntegrationConfig(
            integration_name=integration_name,
            api_base_url=api_base_url,
            auth_config=auth_config,
            endpoints=endpoints,
            capabilities=schema_data.get('capabilities', 'UPSERT'),
            rate_limit=schema_data.get('rate_limit', patterns.get('rate_limit', 60)),
            timeout_seconds=schema_data.get('timeout_seconds', 30)
        )
    
    def _convert_entities_data(self, entities_result: Dict[str, Any], api_type: str = None) -> IntegrationConfig:
        """Convert integration_entities result to configuration"""
        
        # Extract entity schema
        schema = entities_result.get('schema')
        if not schema:
            raise ValueError("No schema found in entities result")
        
        entity_name = entities_result.get('entity_name', 'unknown')
        
        # Auto-detect API type
        if not api_type:
            api_type = self._detect_api_type_from_entity(entity_name)
        
        patterns = self._get_api_patterns(api_type)
        
        # Build configuration for single entity
        auth_config = self._build_auth_config({}, patterns)
        
        # Create endpoint configuration from entity schema
        endpoint_config = self._build_endpoint_from_entity_schema(schema, patterns)
        
        return IntegrationConfig(
            integration_name=api_type,
            api_base_url=patterns.get('api_base_url', ''),
            auth_config=auth_config,
            endpoints={entity_name.lower(): endpoint_config},
            rate_limit=patterns.get('rate_limit', 60)
        )
    
    def _convert_discovery_data(self, discovery_data: Dict[str, Any], api_type: str) -> IntegrationConfig:
        """Convert API discovery data to configuration"""
        
        patterns = self._get_api_patterns(api_type)
        
        # Extract discovered endpoints
        endpoints = {}
        discovered_endpoints = discovery_data.get('endpoints', {})
        
        for endpoint_name, endpoint_data in discovered_endpoints.items():
            endpoints[endpoint_name] = EndpointConfig(
                path=endpoint_data.get('path', f'/{endpoint_name}'),
                method=endpoint_data.get('method', 'GET'),
                data_path=endpoint_data.get('data_path'),
                query_params=endpoint_data.get('query_params', {}),
                schema_columns=endpoint_data.get('schema_columns'),
                transformations=endpoint_data.get('transformations', {}),
                pagination=endpoint_data.get('pagination', {})
            )
        
        # Build auth config
        auth_config = self._build_auth_config(discovery_data, patterns)
        
        return IntegrationConfig(
            integration_name=discovery_data.get('integration_name', api_type),
            api_base_url=discovery_data.get('api_base_url', patterns.get('api_base_url', '')),
            auth_config=auth_config,
            endpoints=endpoints,
            capabilities=discovery_data.get('capabilities', 'UPSERT'),
            rate_limit=discovery_data.get('rate_limit', patterns.get('rate_limit', 60))
        )
    
    def _build_auth_config(self, data: Dict[str, Any], patterns: Dict[str, Any]) -> AuthConfig:
        """Build authentication configuration"""
        
        auth_type = data.get('auth_type', patterns.get('auth_type', 'oauth2'))
        
        if auth_type == 'oauth2':
            return AuthConfig(
                auth_type='oauth2',
                token_url=data.get('token_url', patterns.get('token_url')),
                client_id_env_var=data.get('client_id_env_var', patterns.get('client_id_env_var')),
                client_secret_env_var=data.get('client_secret_env_var', patterns.get('client_secret_env_var')),
                additional_params=data.get('oauth_params', patterns.get('oauth_params', {})),
                custom_headers=data.get('custom_headers', patterns.get('custom_headers', {}))
            )
        
        elif auth_type == 'api_key':
            return AuthConfig(
                auth_type='api_key',
                api_key_env_var=data.get('api_key_env_var', patterns.get('api_key_env_var')),
                key_location=data.get('key_location', patterns.get('key_location', 'header')),
                key_name=data.get('key_name', patterns.get('key_name', 'X-API-Key')),
                custom_headers=data.get('custom_headers', patterns.get('custom_headers', {}))
            )
        
        elif auth_type == 'basic_auth':
            return AuthConfig(
                auth_type='basic_auth',
                username_env_var=data.get('username_env_var', patterns.get('username_env_var')),
                password_env_var=data.get('password_env_var', patterns.get('password_env_var')),
                custom_headers=data.get('custom_headers', patterns.get('custom_headers', {}))
            )
        
        else:
            raise ValueError(f"Unsupported auth type: {auth_type}")
    
    def _build_endpoints_from_schema(self, schema_data: Dict[str, Any], patterns: Dict[str, Any]) -> Dict[str, EndpointConfig]:
        """Build endpoint configurations from schema data"""
        
        endpoints = {}
        
        # Check for explicit endpoints definition
        if 'endpoints' in schema_data:
            for endpoint_name, endpoint_data in schema_data['endpoints'].items():
                endpoints[endpoint_name] = EndpointConfig(
                    path=endpoint_data.get('path', f'/{endpoint_name}'),
                    method=endpoint_data.get('method', 'GET'),
                    data_path=endpoint_data.get('data_path'),
                    query_params=endpoint_data.get('query_params', {}),
                    schema_columns=endpoint_data.get('schema_columns'),
                    transformations=self._build_transformations(endpoint_data.get('fields', [])),
                    pagination=endpoint_data.get('pagination', {})
                )
        
        # Check for entities list (from integration_entities output)
        elif 'entities' in schema_data:
            for entity in schema_data['entities']:
                entity_name = entity.get('name', '').lower()
                endpoints[entity_name] = EndpointConfig(
                    path=entity.get('path', f'/{entity_name}'),
                    data_path=patterns.get('data_path', 'data'),
                    schema_columns=self._extract_schema_columns(entity.get('fields', [])),
                    transformations=self._build_transformations(entity.get('fields', []))
                )
        
        # Fallback: use pattern-based endpoints
        else:
            pattern_endpoints = patterns.get('endpoints', {})
            for endpoint_name, endpoint_pattern in pattern_endpoints.items():
                endpoints[endpoint_name] = EndpointConfig(
                    path=endpoint_pattern.get('path', f'/{endpoint_name}'),
                    data_path=endpoint_pattern.get('data_path'),
                    query_params=endpoint_pattern.get('query_params', {}),
                    pagination=endpoint_pattern.get('pagination', {})
                )
        
        return endpoints
    
    def _build_endpoint_from_entity_schema(self, schema: Any, patterns: Dict[str, Any]) -> EndpointConfig:
        """Build endpoint configuration from entity schema"""
        
        # Extract fields from schema
        fields = []
        if hasattr(schema, 'fields'):
            fields = schema.fields
        elif isinstance(schema, dict) and 'fields' in schema:
            fields = schema['fields']
        
        return EndpointConfig(
            path=f"/{schema.name.lower()}" if hasattr(schema, 'name') else "/entity",
            data_path=patterns.get('data_path', 'data'),
            schema_columns=self._extract_schema_columns(fields),
            transformations=self._build_transformations(fields)
        )
    
    def _build_transformations(self, fields: List[Any]) -> Dict[str, Dict]:
        """Build transformation configurations from field definitions"""
        
        transformations = {}
        
        for field in fields:
            field_name = field.name if hasattr(field, 'name') else field.get('name', '')
            field_type = field.field_type if hasattr(field, 'field_type') else field.get('type', '')
            
            if not field_name:
                continue
            
            # Auto-detect transformations based on field type and name
            if field_type in ['datetime', 'date', 'timestamp']:
                transformations[field_name] = {'type': 'datetime'}
            
            elif field_name.endswith('_date') or field_name.endswith('_time'):
                transformations[field_name] = {'type': 'datetime'}
            
            elif field_type == 'object' or (hasattr(field, 'nested_fields') and field.nested_fields):
                transformations[field_name] = {'type': 'flatten', 'separator': '_'}
            
            elif field_type == 'array':
                transformations[field_name] = {'type': 'flatten', 'separator': '_'}
            
            # Add value mapping for known enum fields
            elif field_name in ['status', 'state', 'type']:
                transformations[field_name] = {
                    'type': 'map_values',
                    'mapping': {}  # Will be populated based on actual data
                }
        
        return transformations
    
    def _extract_schema_columns(self, fields: List[Any]) -> List[str]:
        """Extract column names from field definitions"""
        
        columns = []
        
        for field in fields:
            field_name = field.name if hasattr(field, 'name') else field.get('name', '')
            if field_name:
                # Handle nested fields
                if hasattr(field, 'nested_fields') and field.nested_fields:
                    for nested_field in field.nested_fields:
                        nested_name = nested_field.name if hasattr(nested_field, 'name') else nested_field.get('name', '')
                        if nested_name:
                            columns.append(f"{field_name}_{nested_name}")
                else:
                    columns.append(field_name)
        
        return columns
    
    def _detect_api_type(self, api_base_url: str, integration_name: str) -> str:
        """Auto-detect API type from URL or name"""
        
        url_lower = api_base_url.lower()
        name_lower = integration_name.lower()
        
        if 'intuit' in url_lower or 'quickbooks' in url_lower or 'qbo' in name_lower:
            return 'qbo'
        elif 'salesforce' in url_lower or 'salesforce' in name_lower:
            return 'salesforce'
        elif 'stripe' in url_lower or 'stripe' in name_lower:
            return 'stripe'
        elif 'hubspot' in url_lower or 'hubspot' in name_lower:
            return 'hubspot'
        else:
            return 'generic'
    
    def _detect_api_type_from_entity(self, entity_name: str) -> str:
        """Detect API type from entity name"""
        
        entity_lower = entity_name.lower()
        
        qbo_entities = ['customer', 'vendor', 'item', 'invoice', 'payment', 'account', 'bill']
        salesforce_entities = ['account', 'contact', 'opportunity', 'lead', 'case']
        
        if any(entity in entity_lower for entity in qbo_entities):
            return 'qbo'
        elif any(entity in entity_lower for entity in salesforce_entities):
            return 'salesforce'
        else:
            return 'generic'
    
    def _get_api_patterns(self, api_type: str, auth_type: str = None) -> Dict[str, Any]:
        """Get API-specific patterns using auth templates"""
        
        # Determine auth type - use parameter or default to oauth2
        final_auth_type = auth_type or 'oauth2'
        
        # Get base template for this auth type
        patterns = self.auth_templates.get(final_auth_type, self._get_oauth2_template()).copy()
        
        # Set auth type explicitly
        patterns['auth_type'] = final_auth_type
        
        # Set empty api_base_url as fallback
        patterns['api_base_url'] = ''
        
        # Handle environment variable naming conventions
        if api_type:
            api_upper = api_type.upper()
            if final_auth_type == 'oauth2':
                patterns['client_id_env_var'] = f'{api_upper}_CLIENT_ID'
                patterns['client_secret_env_var'] = f'{api_upper}_CLIENT_SECRET'
            elif final_auth_type in ['api_key', 'bearer_token']:
                patterns['api_key_env_var'] = f'{api_upper}_API_KEY'
            elif final_auth_type == 'basic_auth':
                patterns['username_env_var'] = f'{api_upper}_USERNAME'
                patterns['password_env_var'] = f'{api_upper}_PASSWORD'
        
        return patterns
    

    def _get_oauth2_template(self) -> Dict[str, Any]:
        """OAuth2 authentication template"""
        return {
            'auth_type': 'oauth2',
            'default_base_url': '',
            'token_url': '',
            'client_id_env_var': 'CLIENT_ID',
            'client_secret_env_var': 'CLIENT_SECRET',
            'oauth_params': {},
            'rate_limit': 100,
            'data_path': 'data',
            'endpoints': {}
        }

    def _get_api_key_template(self) -> Dict[str, Any]:
        """API Key authentication template"""
        return {
            'auth_type': 'api_key',
            'default_base_url': '',
            'api_key_env_var': 'API_KEY',
            'key_location': 'header',
            'key_name': 'X-API-Key',
            'rate_limit': 60,
            'data_path': 'data',
            'endpoints': {}
        }

    def _get_basic_auth_template(self) -> Dict[str, Any]:
        """Basic authentication template"""
        return {
            'auth_type': 'basic_auth',
            'default_base_url': '',
            'username_env_var': 'USERNAME',
            'password_env_var': 'PASSWORD',
            'rate_limit': 60,
            'data_path': 'data',
            'endpoints': {}
        }

    def _get_bearer_token_template(self) -> Dict[str, Any]:
        """Bearer token authentication template"""
        return {
            'auth_type': 'bearer_token',
            'default_base_url': '',
            'api_key_env_var': 'BEARER_TOKEN',
            'key_location': 'header',
            'key_name': 'Authorization',
            'rate_limit': 60,
            'data_path': 'data',
            'endpoints': {}
        }

    def _get_generic_patterns(self) -> Dict[str, Any]:
        """Generic API patterns"""
        return self._get_api_key_template()
    
    def save_config(self, config: IntegrationConfig, output_file: str) -> None:
        """Save configuration to JSON file"""
        
        # Convert to dictionary
        config_dict = asdict(config)
        
        # Save to file
        with open(output_file, 'w') as f:
            json.dump(config_dict, f, indent=2)
        
        print(f"✅ Configuration saved to {output_file}")
    
    def load_config(self, config_file: str) -> IntegrationConfig:
        """Load configuration from JSON file"""
        
        with open(config_file, 'r') as f:
            config_dict = json.load(f)
        
        # Reconstruct objects
        auth_config = AuthConfig(**config_dict['auth_config'])
        
        endpoints = {}
        for name, endpoint_data in config_dict['endpoints'].items():
            endpoints[name] = EndpointConfig(**endpoint_data)
        
        return IntegrationConfig(
            integration_name=config_dict['integration_name'],
            api_base_url=config_dict['api_base_url'],
            auth_config=auth_config,
            endpoints=endpoints,
            capabilities=config_dict.get('capabilities', 'UPSERT'),
            allowed_statuses=config_dict.get('allowed_statuses', [9, 12]),
            rate_limit=config_dict.get('rate_limit', 60),
            timeout_seconds=config_dict.get('timeout_seconds', 30)
        )


def main():
    """Main function for command-line usage"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Convert schema to DynamicIntegration configuration')
    parser.add_argument('input', help='Input schema file or entities result')
    parser.add_argument('--output', '-o', help='Output configuration file')
    parser.add_argument('--api-type', help='API type (qbo, salesforce, stripe, hubspot)')
    parser.add_argument('--format', choices=['schema', 'entities', 'discovery'], 
                       default='schema', help='Input format')
    
    args = parser.parse_args()
    
    converter = SchemaToConfigConverter()
    
    try:
        # Load input data
        if args.format == 'schema':
            config = converter.convert_from_schema_file(args.input, args.api_type)
        elif args.format == 'entities':
            with open(args.input, 'r') as f:
                entities_data = json.load(f)
            config = converter.convert_from_integration_entities(entities_data, args.api_type)
        elif args.format == 'discovery':
            with open(args.input, 'r') as f:
                discovery_data = json.load(f)
            config = converter.convert_from_api_discovery(discovery_data, args.api_type)
        else:
            raise ValueError(f"Unsupported format: {args.format}")
        
        # Save configuration
        if args.output:
            converter.save_config(config, args.output)
        else:
            # Print to stdout
            print(json.dumps(asdict(config), indent=2))
        
        print(f"✅ Successfully converted {args.input} to DynamicIntegration configuration")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()