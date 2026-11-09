"""
URL Builder Module - Handles URL construction and template replacement
"""

import os
import urllib.parse
from typing import Dict, Any
import logging

from dynamic_integrations.singleton_manager import SingletonBase

# Import reliability controlling system  
from reliability_controlling import enterprise_retry, RetryStrategy


class URLBuilder(SingletonBase):
    """Handles URL construction and template variable replacement"""
    
    def __init__(self, integration_instance):
        super().__init__()
        if hasattr(self, '_initialized'):
            # For singleton, update integration-specific attributes
            self.integration = integration_instance
            self.config = integration_instance.config
            self.logger = logging.getLogger(f"URLBuilder.{integration_instance.integration_name}")
            return
        self._initialized = True
        
        self.integration = integration_instance
        self.config = integration_instance.config
        self.logger = logging.getLogger(f"URLBuilder.{integration_instance.integration_name}")
    
    def build_api_url(self, endpoint: str, params: Dict[str, Any] = None, parent_data=None) -> tuple[
        str, str | None]:
        """Main URL building method - determines which builder to use"""
        schema_config = self.integration._extract_schema_config()
        url_config = schema_config.get('url_config', {})
        base_url = url_config.get('base_url', '')
        
        if not base_url:
            raise ValueError("Missing required base_url in schema url_config")
        
        # Check if this integration uses special query format
        has_special_query = url_config.get('has_special_query', False)
        
        if has_special_query:
            return self._build_special_query_url(base_url, endpoint, url_config, params), None
        else:
            return self._build_standard_url(base_url, endpoint, params, parent_data)
    
    def build_complete_url_from_path(self, url_path: str, params: Dict[str, Any], endpoint: str) -> str:
        """Build complete URL from pre-built path with template variable replacement"""
        schema_config = self.integration._extract_schema_config()
        url_config = schema_config.get('url_config', {})
        
        # Get base URL from schema
        base_url = url_config.get('base_url', '')
        if not base_url:
            raise ValueError("Missing required base_url in schema url_config")
        base_url = base_url.rstrip('/')
        
        # Ensure trailing slash if required
        url_patterns = url_config.get('url_patterns', {})
        require_trailing_slash = url_patterns.get('require_trailing_slash', False)
        if require_trailing_slash and not url_path.endswith('/'):
            url_path += '/'
        
        # Build complete URL with template variable replacement
        complete_url = f"{base_url}{url_path}"
        complete_url = self.replace_base_url_template_vars(complete_url)
        
        # Add query parameters
        query_params = {}
        
        # Add endpoint-specific columns from schema
        endpoint_schema = self._get_endpoint_schema(endpoint)
        if endpoint_schema:
            api_details = endpoint_schema.get('api_details', {})
            if 'columns' in api_details:
                query_params['columns'] = api_details['columns']
        
        # NOTE: Pagination parameters are handled dynamically in _extract_from_url
        # This avoids duplicate pagination parameters being added to the base URL
        
        # Add additional params (filtered for custom_request)
        if params:
            filtered_params = self._filter_params_for_url(params)
            query_params.update(filtered_params)

        # Add authentication parameters to query string
        auth_type = self.integration.config.get('auth_type')
        if auth_type == 'api_key_param':
            api_key = self._get_api_key_from_config()
            param_name = self._get_api_key_param_name()
            if api_key:
                query_params[param_name] = api_key
                self.logger.debug(f"Added API key parameter: {param_name}={api_key}")
            else:
                self.logger.error("API key not found in config for api_key_param auth")

        elif auth_type == 'oauth2_password_grant':
            auth_config = self.integration.config.get('auth_config', {})
            if auth_config.get('token_usage') == 'query_param':
                access_token = self._get_oauth2_access_token()
                param_name = auth_config.get('token_param_name', 'access_token')
                if access_token:
                    query_params[param_name] = access_token
                    self.logger.debug(f"Added OAuth2 token parameter: {param_name}=***")
                else:
                    self.logger.error("Access token not found for oauth2_password_grant query_param")
        
        # Build final URL with query string
        if query_params:
            query_string = urllib.parse.urlencode(query_params)
            complete_url += f"?{query_string}"
        
        return complete_url
    
    def _build_special_query_url(self, base_url: str, endpoint: str, url_config: Dict,
                                params: Dict[str, Any]) -> str:
        """Build URL for integrations with special query format"""
        url_patterns = url_config.get('url_patterns', {})
        query_endpoint = url_patterns.get('query_endpoint', '/query')

        # Build base query URL
        complete_url = f"{base_url.rstrip('/')}{query_endpoint}"

        # Prepare query parameters
        query_params = {}

        # Add authentication parameters to query string
        auth_type = self.integration.config.get('auth_type')
        if auth_type == 'api_key_param':
            api_key = self._get_api_key_from_config()
            param_name = self._get_api_key_param_name()
            if api_key:
                query_params[param_name] = api_key
                self.logger.debug(f"Added API key parameter: {param_name}={api_key}")
            else:
                self.logger.error("API key not found in config for api_key_param auth")

        elif auth_type == 'oauth2_password_grant':
            auth_config = self.integration.config.get('auth_config', {})
            if auth_config.get('token_usage') == 'query_param':
                access_token = self._get_oauth2_access_token()
                param_name = auth_config.get('token_param_name', 'access_token')
                if access_token:
                    query_params[param_name] = access_token
                    self.logger.debug(f"Added OAuth2 token parameter: {param_name}=***")
                else:
                    self.logger.error("Access token not found for oauth2_password_grant query_param")

        # Add regular query parameters
        if params:
            query_string = self._build_query_string(endpoint, params, url_patterns)
            if query_string:
                # Parse existing query string and merge with auth params
                if query_params:
                    import urllib.parse
                    auth_query_string = urllib.parse.urlencode(query_params)
                    complete_url += f"?{auth_query_string}&{query_string}"
                else:
                    complete_url += f"?{query_string}"
        else:
            # Only auth params
            if query_params:
                import urllib.parse
                auth_query_string = urllib.parse.urlencode(query_params)
                complete_url += f"?{auth_query_string}"

        return complete_url
    
    def _build_standard_url(self, base_url: str, endpoint: str, params: Dict[str, Any] = None,
                           parent_data=None) -> tuple[str, str | None]:
        """Build standard REST API URL with schema-based endpoint configurations"""
        # Replace URL template variables in base_url using unified helper
        base_url = self.replace_base_url_template_vars(base_url)
        
        # First try to get endpoint configuration from schema
        schema = self.integration._load_schema()
        endpoint_schema = None
        if schema and 'endpoints' in schema:
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    endpoint_schema = ep
                    break
        
        # Use schema path if available, otherwise fall back to config
        complete_url = None
        if endpoint_schema and 'api_details' in endpoint_schema:
            api_details = endpoint_schema['api_details']
            # Check for exact_url first (for special endpoints like Companies)
            if 'exact_url' in api_details:
                complete_url = api_details['exact_url']
                complete_url = self.replace_base_url_template_vars(complete_url)
            else:
                path = api_details.get('path', f'/{endpoint.lower()}')
                # Handle potential double slash when base_url ends with '/' and path starts with '/'
                if base_url.endswith('/') and path.startswith('/'):
                    complete_url = f"{base_url.rstrip('/')}{path}"
                else:
                    complete_url = f"{base_url}{path}"
            # Handle multi-level parent substitution
            if parent_data:
                complete_url = self._substitute_multi_level_placeholders(complete_url, parent_data, endpoint)

        detail_url = None
        if endpoint_schema and 'is_details' in endpoint_schema and 'detail_path' in endpoint_schema:
            is_details = endpoint_schema['is_details']
            detail_path = ""
            if is_details:
                detail_path = endpoint_schema['detail_path']
            if base_url.endswith('/') and path.startswith('/'):
                detail_url = f"{base_url.rstrip('/')}{detail_path}"
            else:
                detail_url = f"{base_url}{detail_path}"

        # Add query parameters (moved outside detail_path condition)
        query_params = {}

        # Add authentication parameters to query string
        auth_type = self.integration.config.get('auth_type')
        if auth_type == 'api_key_param':
            api_key = self._get_api_key_from_config()
            param_name = self._get_api_key_param_name()
            if api_key:
                query_params[param_name] = api_key
                self.logger.debug(f"Added API key parameter: {param_name}={api_key}")
            else:
                self.logger.error("API key not found in config for api_key_param auth")

        elif auth_type == 'oauth2_password_grant':
            auth_config = self.integration.config.get('auth_config', {})
            if auth_config.get('token_usage') == 'query_param':
                access_token = self._get_oauth2_access_token()
                param_name = auth_config.get('token_param_name', 'access_token')
                if access_token:
                    query_params[param_name] = access_token
                    self.logger.debug(f"Added OAuth2 token parameter: {param_name}=***")
                else:
                    self.logger.error("Access token not found for oauth2_password_grant query_param")

        # Add date filtering if available
        if endpoint_schema and 'api_details' in endpoint_schema:
            api_details = endpoint_schema['api_details']
            if 'date_filter' in api_details:
                date_filter = api_details['date_filter']
                # Replace MaxDateString placeholder
                max_date = getattr(self.integration, 'max_date_string', '2014-01-01')
                date_filter = date_filter.replace('{MaxDateString}', max_date)
                # Parse and add date filter to query params
                if '=' in date_filter:
                    filter_key, filter_value = date_filter.split('=', 1)
                    query_params[filter_key] = filter_value

        # Build final URL with query parameters
        if query_params:
            query_string = urllib.parse.urlencode(query_params)
            if complete_url:
                complete_url += f"?{query_string}"
            if detail_url:
                detail_url += f"?{query_string}"
        # else:
        #     # Fall back to config-based approach
        #     endpoint_config = self.config.get('endpoints_config', {}).get(endpoint, {})
        #
        #     # Check if endpoint case should be preserved
        #     url_config = self.config.get('url_config', {})
        #     preserve_case = url_config.get('preserve_endpoint_case', False)
        #
        #     if preserve_case:
        #         path = endpoint_config.get('path', f'/{endpoint}')
        #     else:
        #         path = endpoint_config.get('path', f'/{endpoint.lower()}')
        #     url = f"{base_url}{path}"
        #
        #     # Add standard query parameters (filtered for custom_request)
        #     if params:
        #         filtered_params = self._filter_params_for_url(params)
        #         if filtered_params:
        #             query_string = urllib.parse.urlencode(filtered_params)
        #             url += f"?{query_string}"
        #
        #     complete_url = url
        
        return complete_url, detail_url
    
    
    
    def _substitute_multi_level_placeholders(self, path: str, parent_data, endpoint: str) -> str:
        """
        Substitute multiple placeholders in the path for multi-level dependencies
        
        For path like /quotes/{quote_id}/sections/{section_id}/costCenters
        And parent_data like {'quote_id': '123', 'section_id': '456'}
        Result: /quotes/123/sections/456/costCenters
        """
        try:
            # Handle different parent_data formats
            if isinstance(parent_data, str):
                # Legacy single parent ID format
                dependency = self.integration.child_processor.get_parent_dependency(path)
                if dependency:
                    path = self.integration.child_processor.substitute_placeholder(path, parent_data, dependency.placeholder)
                    self.logger.debug(f"Single-level substitution: {parent_data} in path: {path}")
            
            elif isinstance(parent_data, dict):
                # Multi-level parent data format
                self.logger.debug(f"Multi-level substitution for {endpoint}: {parent_data} in path: {path}")
                
                # Substitute each placeholder based on the parent_data keys
                if 'quote_id' in parent_data:
                    path = path.replace('{quote_id}', parent_data['quote_id'])
                if 'section_id' in parent_data:
                    path = path.replace('{section_id}', parent_data['section_id'])
                if 'parent_id' in parent_data:
                    # Handle single-level case where parent_data is dict with 'parent_id' key
                    # Find the placeholder and substitute
                    dependency = self.integration.child_processor.get_parent_dependency(path)
                    if dependency:
                        path = self.integration.child_processor.substitute_placeholder(path, parent_data['parent_id'], dependency.placeholder)
                
                self.logger.debug(f"After multi-level substitution: {path}")
            
            return path
            
        except Exception as e:
            self.logger.warning(f"Error substituting placeholders in path {path}: {e}")
            return path
    
    def _filter_params_for_url(self, params: Dict[str, Any]) -> Dict[str, Any]:
        """
        Filter parameters that should be included in URL query string vs JSON body
        For custom_request auth type, pagination parameters go in JSON body, not URL
        """
        if not params:
            return {}
            
        # Get auth type from integration config
        auth_type = self.integration.config.get('auth_type')
        
        # For custom_request authentication, filter out pagination parameters
        if auth_type == 'custom_request':
            pagination_params = {'page', 'per_page', 'limit', 'offset', 'pageSize', 'pageNumber'}
            filtered_params = {k: v for k, v in params.items() if k not in pagination_params}
            
            if len(filtered_params) != len(params):
                self.logger.debug(f"Filtered pagination params for custom_request: {set(params.keys()) - set(filtered_params.keys())}")
            
            return filtered_params
        
        # For other auth types, include all parameters in URL
        return params
    
    def _get_endpoint_schema(self, endpoint: str) -> Dict:
        """Get endpoint schema configuration"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return {}
            
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    return ep
            
            return {}
        except Exception as e:
            self.logger.warning(f"Error getting endpoint schema for {endpoint}: {e}")
            return {}
    
    
    def _build_query_string(self, endpoint: str, params: Dict[str, Any], url_patterns: Dict) -> str:
        """Build query string based on integration type"""
        query_type = url_patterns.get('query_type', 'standard')
        
        if query_type == 'sql':
            return self._build_sql_query_params(endpoint, params)
        elif query_type == 'custom':
            return self._build_custom_query_params(endpoint, params)
        elif query_type == 'odata':
            return self._build_odata_query_params(endpoint, params)
        else:
            # Standard URL encoding
            return urllib.parse.urlencode(params) if params else ""
    
    @staticmethod
    def _build_sql_query_params(endpoint: str, params: Dict[str, Any]) -> str:
        """Build SQL-style query parameters"""
        # Construct SQL query for endpoint
        sql_query = f"SELECT * FROM {endpoint}"
        
        # Add WHERE conditions if params exist
        if params:
            conditions = []
            for key, value in params.items():
                if isinstance(value, str):
                    conditions.append(f"{key} = '{value}'")
                else:
                    conditions.append(f"{key} = {value}")
            
            if conditions:
                sql_query += f" WHERE {' AND '.join(conditions)}"
        
        return urllib.parse.urlencode({'sql': sql_query})
    
    def _build_custom_query_params(self, endpoint: str, params: Dict[str, Any]) -> str:
        """Build custom query parameters"""
        # This can be customized per integration
        schema_config = self.integration._extract_schema_config()
        custom_format = schema_config.get('url_config', {}).get('custom_query_format', {})
        
        if custom_format:
            # Apply custom formatting rules
            formatted_params = {}
            for key, value in params.items():
                formatted_key = custom_format.get(key, key)
                formatted_params[formatted_key] = value
            return urllib.parse.urlencode(formatted_params)
        
        return urllib.parse.urlencode(params) if params else ""
    
    @staticmethod
    def _build_odata_query_params(endpoint: str, params: Dict[str, Any]) -> str:
        """Build OData-style query parameters"""
        odata_params = {}
        
        # Convert standard params to OData format
        if 'limit' in params:
            odata_params['$top'] = params['limit']
        if 'offset' in params:
            odata_params['$skip'] = params['offset']
        
        # Add other OData parameters
        filters = []
        for key, value in params.items():
            if key not in ['limit', 'offset']:
                if isinstance(value, str):
                    filters.append(f"{key} eq '{value}'")
                else:
                    filters.append(f"{key} eq {value}")
        
        if filters:
            odata_params['$filter'] = ' and '.join(filters)
        
        return urllib.parse.urlencode(odata_params)
    


    def get_url_template_var_value(self, var_name: str) -> str:
        """
        Get value for URL template variable from config.json env_vars_config
        """
        from dynamic_integrations.generator.utils import Utils
        
        # Load integration config from file (not from instance config)
        integration_name = getattr(self.integration, 'integration_name', 'UNKNOWN').upper()
        integration_config = Utils.load_integration_config(integration_name)
        
        env_vars_config = integration_config.get('env_vars_config', {})
        
        # Look for matching attribute in integration instance (set during setup_configuration)
        for attr_name, config_data in env_vars_config.items():
            # Simple direct matching first
            if attr_name == var_name:
                if hasattr(self.integration, attr_name):
                    value = getattr(self.integration, attr_name)
                    if value:
                        return str(value)
        
        # Fallback to common variable name mappings
        integration_name_lower = integration_name.lower()
        var_mappings = {
            'realmId': 'realm_id',  # Map realmId to realm_id
            'companyId': 'company_id',
            'storeUrl': 'store_url',
            'company_id': f'{integration_name_lower}_company_id',  # Dynamic company_id mapping based on integration
            'company_name': f'{integration_name_lower}_company_name',  # Dynamic company_name mapping based on integration (e.g., accredo_company_name)
            'client_id': f'{integration_name_lower}_client_id',   # Dynamic client_id mapping based on integration
            'domain': f'{integration_name_lower}_domain',         # Dynamic domain mapping based on integration (e.g., simpro_domain, deputy_domain)
            'oauth_domain': f'{integration_name_lower}_oauth_domain',  # Dynamic oauth_domain mapping based on integration (e.g., accredo_oauth_domain)
            'api_key': f'{integration_name_lower}_api_key'
        }

        # Try mapped name
        mapped_name = var_mappings.get(var_name)
        if mapped_name and mapped_name in env_vars_config:
            if hasattr(self.integration, mapped_name):
                value = getattr(self.integration, mapped_name)
                if value:
                    return str(value)
            
            # Try from config data
            config_data = env_vars_config[mapped_name]
            env_var = config_data.get('env_var')
            default_value = config_data.get('default_value')
            
            if env_var:
                env_value = os.getenv(env_var)
                if env_value:
                    return env_value
            
            if default_value:
                return str(default_value)

        # Try to get from environment variable
        env_value = os.getenv(var_name)
        if env_value:
            return env_value

        # Try alternative environment variable names
        for alt_name in [var_name.upper(), var_name.lower()]:
            alt_value = os.getenv(alt_name)
            if alt_value:
                return alt_value

        # If no environment variable found, return placeholder
        return f"{{{var_name}}}"
    
    def replace_base_url_template_vars(self, url: str) -> str:
        """Replace all base URL template variables from config"""
        base_url_vars = ['domain', 'oauth_domain', 'company_id', 'company_name', 'realm_id', 'store_url', 'api_version', 'myob_company_file', 'client_id', 'api_key']
        
        for var_name in base_url_vars:
            placeholder = f"{{{var_name}}}"
            if placeholder in url:
                var_value = self.get_url_template_var_value(var_name)
                if var_value and not var_value.startswith('{'):
                    url = url.replace(placeholder, var_value)
        
        return url

    def _get_api_key_from_config(self) -> str:
        """Get API key from config for api_key_param auth type"""
        try:
            # Get auth config
            auth_config = self.integration.config.get('auth_config', {})
            api_key_config = auth_config.get('api_key', {})
            env_var = api_key_config.get('env_var')

            if not env_var:
                self.logger.error("Missing env_var in api_key configuration")
                return None

            # Get from env_vars_config first (default_value)
            env_vars_config = self.integration.config.get('env_vars_config', {})
            for field_name, field_config in env_vars_config.items():
                if field_config.get('env_var') == env_var:
                    api_key = field_config.get('default_value')
                    if api_key:
                        self.logger.debug(f"Got API key from config field '{field_name}'")
                        return api_key
                    break

            return None

        except Exception as e:
            self.logger.error(f"Error getting API key from config: {e}")
            return None

    def _get_api_key_param_name(self) -> str:
        """Get API key parameter name from config"""
        try:
            auth_config = self.integration.config.get('auth_config', {})
            api_key_config = auth_config.get('api_key', {})
            param_name = api_key_config.get('param_name', 'api-key')
            return param_name
        except Exception as e:
            self.logger.error(f"Error getting API key param name: {e}")
            return 'api-key'

    def _get_oauth2_access_token(self) -> str:
        """Get OAuth2 access token with full caching flow"""
        try:
            if hasattr(self.integration, 'auth_manager') and self.integration.auth_manager:
                auth_type = self.integration.config.get('auth_type', 'oauth2')

                if auth_type == 'oauth2_password_grant':
                    # Create TokenManager if not exists
                    if not hasattr(self.integration.auth_manager, 'token_manager') or not self.integration.auth_manager.token_manager:
                        from ...generator.token_manager import TokenManager
                        self.integration.auth_manager.token_manager = TokenManager(self.integration, self.integration.config)
                        self.logger.debug("Created TokenManager instance for OAuth2 password grant")

                    # Call get_valid_token to trigger full flow: cache → S3 → password grant fallback
                    self.logger.debug("Getting OAuth2 token via TokenManager (cache → S3 → password grant)")
                    access_token = self.integration.auth_manager.token_manager.get_valid_token()
                    if access_token:
                        return access_token

            return None
        except Exception as e:
            self.logger.error(f"Error getting OAuth2 access token: {e}")
            return None



