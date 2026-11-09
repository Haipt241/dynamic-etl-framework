"""
Query Builder - Handles parameter building for different query types
"""

import logging
from typing import Dict, Any
from datetime import datetime, timedelta
import sys
import os

from dynamic_integrations.singleton_manager import SingletonBase
from sql_helper import get_max_etl_update_time

# Add parent directory to path for utils
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))))
from utils import format_timestamp


class QueryBuilder(SingletonBase):
    """Builds query parameters for different API types"""
    
    def __init__(self, integration_instance):
        super().__init__()
        if hasattr(self, '_initialized'):
            # For singleton, update integration-specific attributes
            self.integration = integration_instance
            self.logger = logging.getLogger(f"QueryBuilder.{integration_instance.integration_name}")
            return
        self._initialized = True
        
        self.integration = integration_instance
        self.logger = logging.getLogger(f"QueryBuilder.{integration_instance.integration_name}")
    
    def build_date_params(self, endpoint: str) -> Dict[str, str]:
        """Build date filtering parameters for incremental sync"""
        date_params = {}
        
        try:
            # Check if endpoint supports date filtering
            schema = self.integration._load_schema()
            if schema and 'endpoints' in schema:
                for ep in schema['endpoints']:
                    if ep.get('name') == endpoint:
                        api_details = ep.get('api_details', {})
                        
                        # Check for date filter configuration
                        if 'date_filter' in api_details:
                            date_filter = api_details['date_filter']
                            max_date = getattr(self.integration, 'max_date_string', '2014-01-01')
                            date_filter = date_filter.replace('{MaxDateString}', max_date)
                            
                            # Parse date filter
                            if '=' in date_filter:
                                filter_key, filter_value = date_filter.split('=', 1)
                                date_params[filter_key] = filter_value
                        
                        # Check for incremental sync support
                        if api_details.get('supports_incremental_sync', False):
                            date_params['modified_since'] = self._get_last_sync_timestamp(endpoint)
                        
                        break
        
        except Exception as e:
            self.logger.warning(f"Error building date params for {endpoint}: {e}")
        
        return date_params
    
    def build_custom_query_params(self, endpoint: str, params: Dict[str, Any]) -> Dict[str, Any]:
        """Build custom query parameters based on integration requirements"""
        try:
            schema_config = self.integration._extract_schema_config()
            url_config = schema_config.get('url_config', {})
            custom_format = url_config.get('custom_query_format', {})
            
            if custom_format:
                # Apply custom formatting rules
                formatted_params = {}
                for key, value in params.items():
                    formatted_key = custom_format.get(key, key)
                    formatted_params[formatted_key] = value
                return formatted_params
            
            return params
            
        except Exception as e:
            self.logger.warning(f"Error building custom query params: {e}")
            return params
    
    def _get_last_sync_timestamp(self, endpoint: str) -> str:
        """Get last sync timestamp for incremental sync"""
        try:
            # This would typically come from sync state tracking
            # For now, return a default timestamp
            default_timestamp = datetime.now() - timedelta(days=30)
            return default_timestamp.isoformat()
            
        except Exception as e:
            self.logger.warning(f"Could not get last sync timestamp for {endpoint}: {e}")
            return "2020-01-01T00:00:00"
    
    def build_query_string(self, endpoint: str, params: Dict[str, Any], url_patterns: Dict) -> str:
        """Build query string based on API query type from config"""
        # Get query type from instance config first, then schema config
        query_config = self.integration.config.get('query_config', {})
        if not query_config:
            schema_config = self.integration._extract_schema_config()
            query_config = schema_config.get('query_config', {})

        query_type = query_config.get('type', 'standard')

        if query_type == 'sql':
            # SQL-style query (QBO, Salesforce SOQL)
            return self.build_sql_query_params(endpoint, params)
        elif query_type == 'odata':
            # OData-style query (Microsoft APIs)
            return self.build_odata_query_params(endpoint, params)
        elif query_type == 'custom':
            # Custom query format (SimplPro with columns, DateModified)
            return self.build_custom_query_params_advanced(endpoint, params)
        else:
            # Standard REST query parameters (default)
            import urllib.parse
            return urllib.parse.urlencode(params) if params else ""

    def build_sql_query_params(self, endpoint: str, params: Dict[str, Any]) -> str:
        """Build SQL-style query parameters (QBO)"""
        import urllib.parse
        
        if params and any(k in params for k in ['limit', 'offset', 'pageSize', 'page']):
            limit = params.get('limit') or params.get('pageSize', 1000)
            offset = params.get('offset', 0)

            # Convert page-based to offset if needed
            if 'page' in params:
                offset = (params['page'] - 1) * limit

            start_position = offset + 1  # 1-based indexing
            query = f"SELECT * FROM {endpoint} STARTPOSITION {start_position} MAXRESULTS {limit}"
        else:
            query = f"SELECT * FROM {endpoint}"

        return urllib.parse.urlencode({'query': query})

    def build_custom_query_params_advanced(self, endpoint: str, params: Dict[str, Any]) -> str:
        """Build custom query parameters (SimplPro with columns, DateModified)"""
        import urllib.parse
        
        schema_config = self.integration._extract_schema_config()
        query_config = schema_config.get('query_config', {})

        # Get custom parameters template
        custom_params = {}

        # Add pagination params
        if params:
            custom_params.update(params)

        # Add custom fields from config
        custom_fields = query_config.get('custom_fields', {})
        for field_name, field_config in custom_fields.items():
            if field_config.get('required', False):
                # Get value from config or default
                value = getattr(self.integration, field_config.get('source_attr'), field_config.get('default_value', ''))
                if value:
                    custom_params[field_name] = value

        return urllib.parse.urlencode(custom_params)

    def build_odata_query_params(self, endpoint: str, params: Dict[str, Any]) -> str:
        """Build OData-style query parameters (Microsoft APIs)"""
        import urllib.parse
        
        odata_params = {}

        # Convert standard params to OData format
        if params:
            if 'limit' in params or 'pageSize' in params:
                odata_params['$top'] = params.get('limit') or params.get('pageSize')
            if 'offset' in params:
                odata_params['$skip'] = params['offset']
            if 'page' in params:
                limit = params.get('limit', 100)
                odata_params['$skip'] = (params['page'] - 1) * limit

        return urllib.parse.urlencode(odata_params)

    def build_pagination_params(self, pagination_config: Dict[str, Any], page: int, limit: int) -> Dict[str, Any]:
        """
        UNIFIED pagination parameter builder for all APIs
        
        Supports all pagination patterns with consistent field names:
        - offset: limit + offset (QBO, most REST APIs)
        - page: limit_param + offset_param as page (SimplPro, JobMan)
        - page_based: limit_param + offset_param as page (FYI, WFM)
        - odata: $top + $skip (Karbon)
        - limit_only: just limit (Shopify)
        """
        pagination_type = pagination_config.get('type', 'offset').lower()
        limit_param = pagination_config.get('limit_param', 'limit')
        offset_param = pagination_config.get('offset_param', 'offset')
        
        params = {}
        
        if pagination_type in ['page', 'page_based']:
            # Page-based pagination: pageSize=100&page=1 or per_page=50&page=1
            # Page starts from 1, not 0
            if limit_param:
                params[limit_param] = limit
            if offset_param:
                params[offset_param] = page
        elif pagination_type == 'path_page':
            if limit_param:
                params[limit_param] = limit
            if offset_param:
                params[offset_param] = page
        elif pagination_type == 'odata':
            # OData-style: $top=100&$skip=0
            params['$top'] = limit
            if offset_param:
                params[offset_param] = (page - 1) * limit  # $skip
        elif pagination_type == 'limit_only':
            # Only limit, no offset/page
            if limit_param:
                params[limit_param] = limit
        elif pagination_type == 'link_header_based':
            # Shopify-style: First request uses limit, subsequent requests use full URL from Link header
            if page == 1:
                if limit_param:
                    params[limit_param] = limit
        else:
            # Default offset-based: limit=100&offset=0
            if limit_param:
                params[limit_param] = limit
            if offset_param:
                params[offset_param] = (page - 1) * limit  # offset (0, 100, 200...)
        
        return params

    def build_date_params_advanced(self, endpoint: str) -> Dict[str, str]:
        """Build date parameters for endpoints that require StartDate/EndDate"""
        from datetime import datetime
        
        try:
            # Check if endpoint needs date parameters from schema
            schema = self.integration._load_schema()
            if not schema:
                return {}

            endpoints = schema.get('endpoints', [])
            endpoint_config = None

            # Find endpoint configuration
            for ep_config in endpoints:
                if ep_config.get('name') == endpoint:
                    endpoint_config = ep_config
                    break

            if not endpoint_config:
                return {}

            # Check if StartDate and EndDate are in required parameters
            api_details = endpoint_config.get('api_details', {})
            query_params = api_details.get('query_parameters', {})
            required_params = query_params.get('required', [])

            # Check if both StartDate and EndDate are required
            if 'StartDate' not in required_params or 'EndDate' not in required_params:
                return {}

            # Generate date values - use test range for now
            start_date = datetime.strptime('2024-01-01', '%Y-%m-%d')
            end_date = datetime.now()

            # Format dates
            start_date_str = start_date.strftime('%Y-%m-%d')
            end_date_str = end_date.strftime('%Y-%m-%d')

            return {
                'StartDate': start_date_str,
                'EndDate': end_date_str
            }

        except Exception as e:
            self.logger.warning(f"Error building date params for {endpoint}: {e}")
            return {}

    def get_endpoint_pagination_params(self, endpoint: str) -> list:
        """Get pagination parameter names from endpoint schema"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return []
                
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    api_details = ep.get('api_details', {})
                    query_params = api_details.get('query_parameters', {})
                    optional_params = query_params.get('optional', [])
                    required_params = query_params.get('required', [])
                    return optional_params + required_params
                    
            return []
        except Exception as e:
            self.logger.warning(f"Error getting pagination params for {endpoint}: {e}")
            return []

    def get_incremental_timestamp_advanced(self, endpoint: str) -> str:
        """Get last sync timestamp for incremental sync"""
        try:
            # Temporarily return empty string to skip time filtering
            return ""
            
        except Exception as e:
            self.logger.warning(f"Could not get incremental timestamp for {endpoint}: {e}")
            return ""
    
    def build_upsert_params(self, endpoint: str) -> Dict[str, Any]:
        """
        Build incremental parameters for UPSERT mode based on schema configuration
        
        Priority:
        1. Custom 'time-from' parameter (bypasses database query)
        2. Auto-detection from production table etlupdatetime
        3. Full load if endpoint doesn't support incremental sync
        
        Args:
            endpoint: Name of the endpoint
            
        Returns:
            Dict with incremental parameters if available, empty dict otherwise
        """
        try:
            # Load schema first to know which params are valid for incremental sync
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                self.logger.debug(f"No schema found for incremental params")
                return {}
            
            # Find the specific endpoint configuration
            endpoint_config = None
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    endpoint_config = ep
                    break
            
            if not endpoint_config:
                self.logger.debug(f"No endpoint configuration found for {endpoint}")
                return {}
            
            # Check for incremental sync configuration
            api_details = endpoint_config.get('api_details', {})
            query_params = api_details.get('query_parameters', {})
            incremental_sync = query_params.get('incremental_sync', {})
            
            if not incremental_sync or not incremental_sync.get('timestamp_field'):
                self.logger.info(f"Endpoint {endpoint} does not support incremental sync (no timestamp parameters) - using full load")
                return {}
            
            # Get incremental sync type and configuration  
            sync_type = incremental_sync.get('type', 'simple')  # Default to 'simple' for backward compatibility
            timestamp_field = incremental_sync.get('timestamp_field')
            timestamp_format = incremental_sync.get('timestamp_format')
            description = incremental_sync.get('description', f'Incremental sync using {timestamp_field}')
            
            self.logger.info(f"Found incremental sync for {endpoint}: type={sync_type}, field={timestamp_field}, format={timestamp_format}")
            
            # Step 1: Get timestamp value (common for all types)
            timestamp_value = self._get_incremental_timestamp_value(endpoint, timestamp_format, description)
            if not timestamp_value:
                return {}  # Full load or error
            
            # Step 2: Format parameters based on type
            if sync_type == 'simple':
                return self._format_simple_params(timestamp_field, timestamp_value, description)
            elif sync_type == 'template':
                return self._format_template_params(timestamp_field, timestamp_value, description)
            else:
                self.logger.error(f"Unsupported incremental sync type '{sync_type}' for {endpoint}")
                return {}
                
        except Exception as e:
            self.logger.error(f"Error building upsert params for {endpoint}: {e}")
            return {}
    
    def _get_incremental_timestamp_value(self, endpoint: str, timestamp_format: str, description: str) -> dict:
        """Get timestamp value from custom params or auto-detection (common for all types)"""
        try:
            # Priority 1: Check for custom 'time-from' parameter
            custom_upsert_params = getattr(self.integration, 'config', {}).get('custom_upsert_params', {})
            if 'time-from' in custom_upsert_params:
                raw_timestamp = custom_upsert_params['time-from']
                self.logger.info(f"Found custom time-from parameter: {raw_timestamp}")
                
                # Parse and format the custom timestamp according to schema format
                try:
                    # Parse the raw timestamp (assume ISO format from user input)
                    if isinstance(raw_timestamp, str):
                        parsed_dt = datetime.fromisoformat(raw_timestamp.replace('Z', '+00:00'))
                    else:
                        parsed_dt = raw_timestamp
                    
                    # Format according to schema requirements
                    formatted_timestamp = format_timestamp(parsed_dt, timestamp_format)
                    
                    self.logger.info(f"Using custom time-from parameter for {endpoint}: {formatted_timestamp}")
                    return {
                        'value': formatted_timestamp,
                        'source': 'custom',
                        'description': f'{description} (using custom time-from parameter: {raw_timestamp})'
                    }
                    
                except Exception as e:
                    self.logger.error(f"Error parsing custom time-from parameter '{raw_timestamp}': {e}")
                    self.logger.info(f"Falling back to auto-detection from database")
            
            # Priority 2: Auto-detection from production table
            max_timestamp = self._get_max_etl_update_time(endpoint, timestamp_format)
            
            if max_timestamp:
                self.logger.info(f"Using auto-detected timestamp for {endpoint}: {max_timestamp}")
                return {
                    'value': max_timestamp,
                    'source': 'auto-detect',
                    'description': f'{description} (auto-detected from production table)'
                }
            else:
                self.logger.info(f"No previous sync found for {endpoint} (first time sync), using full load")
                return {
                    'value': None,
                    'source': 'full-load',
                    'description': f'Full load (first time sync - no previous etlupdatetime found in production table)'
                }
                
        except Exception as e:
            self.logger.error(f"Error getting incremental timestamp value for {endpoint}: {e}")
            return {}
    
    def _format_simple_params(self, timestamp_field: str, timestamp_info: dict, description: str) -> Dict[str, Any]:
        """Format simple type parameters (field=value format)"""
        if not timestamp_info or not timestamp_info.get('value'):
            # Full load case
            return {
                '_load_type': 'full',
                '_description': timestamp_info.get('description', 'Full load')
            }
        
        # Incremental case
        return {
            timestamp_field: timestamp_info['value'],
            '_load_type': 'incremental', 
            '_description': timestamp_info['description']
        }
    
    def _format_template_params(self, timestamp_template: str, timestamp_info: dict, description: str) -> Dict[str, Any]:
        """Format template type parameters (parse template string format)
        
        Example: "ScheduleStartDate=ge({MaxDateString})" -> {"ScheduleStartDate": "ge(2024-01-15T10:30:00)"}
        """
        if not timestamp_info or not timestamp_info.get('value'):
            # Full load case
            return {
                '_load_type': 'full',
                '_description': timestamp_info.get('description', 'Full load')
            }
        
        try:
            # Parse template: "ScheduleStartDate=ge({MaxDateString})" 
            # Split on '=' to get field name and value template
            if '=' not in timestamp_template:
                self.logger.error(f"Invalid template format '{timestamp_template}' - missing '=' separator")
                return {}
            
            field_name, value_template = timestamp_template.split('=', 1)
            field_name = field_name.strip()
            
            # Replace placeholder with actual timestamp value
            # Support multiple placeholder formats: {MaxDateString}, {timestamp}, {value}
            placeholders = ['{MaxDateString}', '{timestamp}', '{value}']
            formatted_value = value_template
            
            for placeholder in placeholders:
                if placeholder in formatted_value:
                    formatted_value = formatted_value.replace(placeholder, timestamp_info['value'])
                    break
            
            self.logger.info(f"Template parsed: {field_name} = {formatted_value}")
            
            return {
                field_name: formatted_value,
                '_load_type': 'incremental',
                '_description': timestamp_info['description']
            }
            
        except Exception as e:
            self.logger.error(f"Error parsing template '{timestamp_template}': {e}")
            return {}
    
    def _get_max_etl_update_time(self, endpoint_name: str, timestamp_format: str = None) -> str:
        """
        Get maximum ETL update time from production table
        
        Args:
            endpoint_name: Name of the endpoint (e.g., 'Cabinet', 'TimeEntry')
            
        Returns:
            Maximum etlupdatetime as API timestamp string or None if not found
        """
        try:
            # Get client information
            config = self.integration.config or {}
            client_id = config.get('client_id') or getattr(self.integration, 'etani_client_id', '')
            org_id = config.get('org_id') or getattr(self.integration, 'etani_organisation_id', '')
            
            if not client_id or not org_id:
                self.logger.warning(f"Cannot query etlupdatetime - missing client_id ({client_id}) or org_id ({org_id})")
                return None
                
            # Extract client number from client_id (e.g., REDACTED -> 2013)
            client_number = client_id.split('CLIENT')[-1] if 'CLIENT' in client_id else client_id
            integration_name = self.integration.integration_name

            # Check if we should use EtaniLinkOrganisationID when usingEtaniLinkOrganisationID = true
            etani_link_org_id = None
            schema = self.integration._load_schema()
            if schema and schema.get('usingEtaniLinkOrganisationID', False) and hasattr(self.integration, 'etani_link_organisation_id'):
                etani_link_org_id = self.integration.etani_link_organisation_id
                self.logger.info(f"Using EtaniLinkOrganisationID for UPSERT timestamp query: {etani_link_org_id}")

            # Call sql_helper function with the appropriate OrganisationID
            try:
                max_timestamp = get_max_etl_update_time(
                    client_number=client_number,
                    org_id=org_id,
                    integration_name=integration_name,
                    endpoint_name=endpoint_name,
                    timestamp_format=timestamp_format,
                    etani_link_org_id=etani_link_org_id
                )
                
                return max_timestamp
                
            except ImportError:
                self.logger.warning(f"sql_helper not available, cannot query max etlupdatetime")
                return None
            
        except Exception as e:
            self.logger.error(f"Error getting max etlupdatetime for {endpoint_name}: {e}")
            return None
    
    def build_required_params(self, endpoint: str) -> Dict[str, str]:
        """
        Build parameters from required parameters in endpoint schema.
        Returns required parameters as a dictionary
        
        Args:
            endpoint: Name of the endpoint
            
        Returns:
            Dict of required parameters from schema
        """
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return {}
                
            # Find endpoint in schema
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    api_details = ep.get('api_details', {})
                    query_params = api_details.get('query_parameters', {})
                    required_params = query_params.get('required', {})
                    
                    # If required is a dict, return it directly
                    if isinstance(required_params, dict):
                        processed_params = {}

                        # Standard format with key-value pairs
                        for key, value in required_params.items():
                            # Replace placeholder in value with actual value
                            processed_value = self._replace_placeholders(value)
                            processed_params[key] = processed_value

                        if processed_params:
                            self.logger.info(f"Built required params for {endpoint}: {processed_params}")
                        return processed_params


                    # If required is a list (old format), convert to empty dict for now
                    elif isinstance(required_params, list):
                        self.logger.debug(f"Endpoint {endpoint} has list-format required params (old format), ignoring")
                        return {}

                    return {}

            return {}
            
        except Exception as e:
            self.logger.warning(f"Error building required params for {endpoint}: {e}")
            return {}

    def _replace_placeholders(self, value: str) -> str:
        """
        Replace placeholders in the value with actual values from integration config.

        Args:
            value: String value that may contain placeholders like {myob_start_date}

        Returns:
            String with placeholders replaced by actual values
        """
        try:
            # Check if value contains a placeholder
            if '{' in value and '}' in value:
                # Extract variable name from placeholder {var_name}
                var_name = value.strip('{}')

                # Use URL builder to get actual value from config/integration
                from dynamic_integrations.etl.extractors.url_builder import URLBuilder
                url_builder = URLBuilder(self.integration)
                var_value = url_builder.get_url_template_var_value(var_name)

                # Only return the replaced value if we got a real value (not just placeholder again)
                if var_value and not var_value.startswith('{'):
                    return var_value

            # Return original value if no placeholder or couldn't replace
            return value

        except Exception as e:
            self.logger.warning(f"Error replacing placeholders in '{value}': {e}")
            # Return original value in case of error
            return value
