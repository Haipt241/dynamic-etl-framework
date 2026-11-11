"""
API Client Module - Handles HTTP requests and response processing
"""
import copy
import json
import requests
import pandas as pd
import time
from typing import Dict, Any
from datetime import datetime, timedelta
import logging
import sys
import os
import threading

# Import SSL configuration
from config import SSL_VERIFY

from pandas import DataFrame
from requests import Response

from dynamic_integrations.etl.extractors.url_builder import URLBuilder
from dynamic_integrations.etl.extractors.thread_pool_manager import ThreadPoolManager, calculate_optimal_workers
from dynamic_integrations.auth.auth_manager import AuthManager
from dynamic_integrations.singleton_manager import SingletonBase

# Import reliability controlling system
from dynamic_integrations.reliability import enterprise_retry, RetryStrategy

# Add parent directory to path for sql_helper
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))))
from dynamic_integrations.database.sql_helper import LoadToEvaStageTable, ExecuteEvaSP, ExecuteCMSSP


class APIClient(SingletonBase):
    """Handles HTTP requests and API communication"""
    
    def __init__(self, integration_instance):
        super().__init__()

        # Make sure token refresh attributes are always set (singleton pattern)
        if not hasattr(self, '_last_token_refresh_time'):
            self._last_token_refresh_time = datetime.now()
        if not hasattr(self, '_token_refresh_lock'):
            self._token_refresh_lock = threading.RLock()

        if hasattr(self, '_initialized'):
            # For singleton, update integration-specific attributes
            self.integration = integration_instance
            self.logger = logging.getLogger(f"APIClient.{integration_instance.integration_name}")
            return
        self._initialized = True
        
        self.integration = integration_instance
        self.logger = logging.getLogger(f"APIClient.{integration_instance.integration_name}")
    
    @enterprise_retry(
        strategy=RetryStrategy.API_CALLS,
        max_attempts=3,
        enable_logging=True
    )
    def make_request(self, url: str, headers: Dict[str, str], params: Dict[str, Any], endpoint: str) -> requests.Response:
        """Make HTTP request based on auth type and configuration"""
        auth_type = self.integration.config.get('auth_type', 'api_key')
        
        if auth_type == 'custom_request':
            return self._make_custom_request(url, headers, params, endpoint)
        else:
            return self._make_standard_request(url, headers, params)
    
    @staticmethod
    @enterprise_retry(
        strategy=RetryStrategy.GATEWAY_CALLS,  # Changed from API_CALLS to GATEWAY_CALLS for better 502 handling
        max_attempts=3,
        base_delay=2.0,  # Use 2 seconds between retries as requested
        enable_logging=True
    )
    def _make_standard_request(url: str, headers: Dict[str, str], params: Dict[str, Any]) -> requests.Response:
        """Make standard GET request with immediate status code check for 5xx errors"""
        # Make the actual HTTP request
        response = requests.get(
            url=url,
            headers=headers,
            timeout=300,
            verify=SSL_VERIFY
        )

        # Immediately check for rate limit (429) and 5xx errors and raise exception to trigger retry
        if response.status_code == 429 or 500 <= response.status_code < 600:
            response.raise_for_status()

        return response
    
    @enterprise_retry(
        strategy=RetryStrategy.GATEWAY_CALLS,  # Changed from API_CALLS to GATEWAY_CALLS for better 502 handling
        max_attempts=3,
        base_delay=2.0,  # Use 2 seconds between retries as requested
        enable_logging=True
    )
    def _make_custom_request(self, url: str, headers: Dict[str, str], params: Dict[str, Any], endpoint: str) -> requests.Response:
        """
        Make custom request for APIs that require special handling with immediate status check for 5xx errors
        Used for APIs like FYI that need POST with JSON body structure
        """
        try:
            # Extract request body configuration from headers
            request_body_json = headers.pop('X-Custom-Request-Body', '{}')
            request_body_config = json.loads(request_body_json)

            # Build request body from configuration
            request_body = self._build_custom_request_body(request_body_config, params, endpoint)

            # Get HTTP method from auth config, default to POST for custom_request
            auth_config = self.integration.config.get('auth_config', {})
            method = auth_config.get('method', 'POST').upper()

            # Make HTTP request with JSON body
            if method == 'POST':
                response = requests.post(
                    url=url,
                    headers=headers,
                    json=request_body,
                    timeout=30
                )
            elif method == 'GET':
                response = requests.get(
                    url=url,
                    headers=headers,
                    timeout=30
                )
            else:
                raise ValueError(f"Unsupported HTTP method: {method}")

            # Immediately check for rate limit (429) and 5xx errors and raise exception to trigger retry
            if response.status_code == 429 or 500 <= response.status_code < 600:
                response.raise_for_status()

            return response

        except Exception as e:
            self.logger.error(f"Custom request failed for {endpoint}: {e}")
            raise

    @enterprise_retry(
        strategy=RetryStrategy.GATEWAY_CALLS,
        max_attempts=3,
        base_delay=2.0,
        enable_logging=True
    )
    def _make_post_request_with_body(self, url: str, headers: Dict[str, str], params: Dict[str, Any], endpoint: str, request_body_config: Dict) -> requests.Response:
        """
        Make POST request with JSON body for endpoints like HubSpot v3 associations
        Handles request body configuration directly from schema
        """
        try:
            # Build request body from schema configuration
            request_body = self._build_request_body_from_config(request_body_config, params, endpoint)

            self.logger.debug(f"Making POST request to {url} with body: {json.dumps(request_body, indent=2)}")

            # Make POST request with JSON body
            response = requests.post(
                url=url,
                headers=headers,
                json=request_body,
                timeout=30
            )

            # Immediately check for rate limit (429) and 5xx errors and raise exception to trigger retry
            if response.status_code == 429 or 500 <= response.status_code < 600:
                response.raise_for_status()

            return response

        except Exception as e:
            self.logger.error(f"POST request with body failed for {endpoint}: {e}")
            raise

    def _build_request_body_from_config(self, body_config: Dict[str, Any], params: Dict[str, Any], endpoint: str) -> Dict[str, Any]:
        """
        Build request body from schema configuration and parameters
        Handles HubSpot v3 association endpoints and similar POST body structures
        """
        try:
            # Deep copy the body structure to avoid modifying original
            request_body = copy.deepcopy(body_config.get('structure', {}))

            # Replace template variables and add parent IDs for child endpoints
            request_body = self._replace_hubspot_variables(request_body, params, endpoint)

            return request_body

        except Exception as e:
            self.logger.error(f"Error building request body from config for {endpoint}: {e}")
            return {}

    def _replace_hubspot_variables(self, obj: Any, params: Dict[str, Any], endpoint: str) -> Any:
        """
        Replace template variables in HubSpot v3 style request bodies
        Specifically handles {parent_id} replacements for association endpoints
        """
        if isinstance(obj, dict):
            result = {}
            for key, value in obj.items():
                result[key] = self._replace_hubspot_variables(value, params, endpoint)
            return result

        elif isinstance(obj, list):
            return [self._replace_hubspot_variables(item, params, endpoint) for item in obj]

        elif isinstance(obj, str):
            # Replace HubSpot-specific template variables
            # These come from child endpoint parent IDs
            for param_key, param_value in params.items():
                placeholder = f"{{{param_key}}}"
                if placeholder in obj and param_value is not None:
                    obj = obj.replace(placeholder, str(param_value))
                    self.logger.debug(f"Replaced {placeholder} with '{param_value}' in request body")

            return obj
        else:
            return obj

    def _build_custom_request_body(self, body_config: Dict[str, Any], params: Dict[str, Any], endpoint: str) -> Dict[str, Any]:
        """
        Build custom request body from configuration template
        
        Replaces template variables and includes pagination parameters
        """
        try:
            # Deep copy the body structure to avoid modifying original
            request_body = copy.deepcopy(body_config.get('structure', {}))
            
            # Replace template variables in the body
            request_body = self._replace_request_body_variables(request_body, params, endpoint)
            
            return request_body
            
        except Exception as e:
            self.logger.error(f"Error building custom request body for {endpoint}: {e}")
            return body_config
    
    def _replace_request_body_variables(self, obj: Any, params: Dict[str, Any], endpoint: str) -> Any:
        """
        Recursively replace template variables in request body structure
        
        Handles nested dictionaries and lists, replacing variables like:
        - {incremental_field} -> actual timestamp
        - {current_timestamp} -> current timestamp  
        - page/per_page -> from params
        """
        if isinstance(obj, dict):
            result = {}
            for key, value in obj.items():
                # Handle special metadata fields
                if key == 'data' and isinstance(value, dict):
                    # This is the data section where we add pagination and filters
                    data_section = self._replace_request_body_variables(value, params, endpoint)
                    
                    # Add pagination parameters from params
                    if 'page' in params:
                        data_section['page'] = params['page']
                    if 'per_page' in params:
                        data_section['per_page'] = params['per_page']
                    if 'limit' in params:
                        data_section['per_page'] = params['limit']
                    
                    # Add UPSERT timestamp parameters from params
                    # These come from query_builder.build_upsert_params()
                    for param_key, param_value in params.items():
                        # Skip internal parameters and pagination params already handled
                        if (not param_key.startswith('_') and 
                            param_key not in ['page', 'per_page', 'limit'] and
                            param_value is not None and param_value != ''):
                            # Only set if current value is empty or doesn't exist
                            if param_key not in data_section or data_section[param_key] == '':
                                data_section[param_key] = param_value
                    
                    result[key] = data_section
                else:
                    result[key] = self._replace_request_body_variables(value, params, endpoint)
            return result
            
        elif isinstance(obj, list):
            return [self._replace_request_body_variables(item, params, endpoint) for item in obj]
            
        elif isinstance(obj, str):
            # Replace template variables
            if '{incremental_field}' in obj:
                # Leave empty for now - datetime processing not implemented yet
                obj = obj.replace('{incremental_field}', "")
            
            if '{current_timestamp}' in obj:
                # Leave empty for now - datetime processing not implemented yet
                obj = obj.replace('{current_timestamp}', "")
                
            return obj
        else:
            return obj
    
    def _get_incremental_timestamp(self, endpoint: str) -> str:
        """Get last sync timestamp for incremental sync"""
        try:
            # This would typically come from sync state tracking
            # For now, return a default timestamp
            # Default to 30 days ago for initial sync
            default_timestamp = datetime.now() - timedelta(days=30)
            return default_timestamp.isoformat()
            
        except Exception as e:
            self.logger.warning(f"Could not get incremental timestamp for {endpoint}: {e}")
            return "2020-01-01T00:00:00"
    
    def process_response(self, response: requests.Response, endpoint: str) -> pd.DataFrame:
        """Process API response and convert to DataFrame"""
        try:
            # Check status code using the new _check_status method
            error_msg = self._check_status(response)
            if error_msg:
                # Return empty DataFrame and log warning for 4xx errors
                self.logger.warning(f"{error_msg}")
                return pd.DataFrame()

            # Parse JSON response
            if response.content:
                data = response.json()
            else:
                self.logger.warning(f"Empty response for {endpoint}")
                return pd.DataFrame()

            # Extract data based on response format
            return self._extract_data_from_response(data, endpoint)

        except requests.exceptions.HTTPError as e:
            # 5xx errors are reported in _check_status
            self.logger.error(f"HTTP error for {endpoint}: {e}")
            raise
        except json.JSONDecodeError as e:
            self.logger.error(f"JSON decode error for {endpoint}: {e}")
            self.logger.debug(f"Response content: {response.text[:500]}")
            raise
        except Exception as e:
            self.logger.error(f"Error processing response for {endpoint}: {e}")
            raise
    
    def _extract_data_from_response(self, data: Any, endpoint: str) -> pd.DataFrame:
        """Extract data array from API response based on format"""
        try:
            # Get response format from schema
            schema = self.integration._load_schema()
            endpoint_config = None
            
            if schema and 'endpoints' in schema:
                for ep in schema['endpoints']:
                    if ep.get('name') == endpoint:
                        endpoint_config = ep
                        break
            
            if endpoint_config and 'response_structure' in endpoint_config:
                response_structure = endpoint_config['response_structure']
                root_data_field = response_structure.get('root_data_field', 'data')
                is_array = response_structure.get('is_array', True)
            else:
                # Default assumptions
                root_data_field = 'data'
                is_array = True
            
            # Extract data from response
            if isinstance(data, list):
                # Response is already an array
                extracted_data = data
            elif isinstance(data, dict):
                if root_data_field in data:
                    extracted_data = data[root_data_field]
                else:
                    # Try common field names
                    common_fields = ['data', 'results', 'items', 'records']
                    extracted_data = None
                    for field in common_fields:
                        if field in data:
                            extracted_data = data[field]
                            break
                    
                    if extracted_data is None:
                        # If no data field found, assume the entire response is the data
                        extracted_data = data
            else:
                extracted_data = data
            
            # Convert to DataFrame
            if isinstance(extracted_data, list):
                if extracted_data:
                    return pd.DataFrame(extracted_data)
                else:
                    return pd.DataFrame()
            elif isinstance(extracted_data, dict):
                # Single record response
                return pd.DataFrame([extracted_data])
            else:
                self.logger.warning(f"Unexpected data format for {endpoint}: {type(extracted_data)}")
                return pd.DataFrame()
                
        except Exception as e:
            self.logger.error(f"Error extracting data from response for {endpoint}: {e}")
            return pd.DataFrame()
    
    
    def _check_status(self, response):
        """Check status code and return error message instead of raising exception for 4xx errors"""
        if 400 <= response.status_code < 500:
            # Client Error
            if isinstance(response.reason, bytes):
                try:
                    reason = response.reason.decode("utf-8")
                except UnicodeDecodeError:
                    reason = response.reason.decode("iso-8859-1")
            else:
                reason = response.reason

            # Extract meaningful message from response if possible
            error_message = ""
            try:
                if response.content:
                    content = response.json()
                    # Check for MYOB error format
                    if "Errors" in content and isinstance(content["Errors"], list) and len(content["Errors"]) > 0:
                        error_obj = content["Errors"][0]
                        if "Message" in error_obj:
                            error_message = f"API Message: {error_obj['Message']}"
                        elif "Name" in error_obj:
                            error_message = f"API Error: {error_obj['Name']}"
                    # Check for other common error formats
                    elif "error" in content and "message" in content["error"]:
                        error_message = f"API Message: {content['error']['message']}"
                    elif "message" in content:
                        error_message = f"API Message: {content['message']}"
            except:
                # Fallback to showing brief content if parsing fails
                try:
                    if response.content:
                        content_str = response.content.decode('utf-8')
                        if len(content_str) > 100:
                            error_message = f"Response: {content_str[:100]}..."
                        else:
                            error_message = f"Response: {content_str}"
                except:
                    pass

            return f"{response.status_code} Client Error: {reason} for url: {response.url}. {error_message}"

        elif 500 <= response.status_code < 600:
            # Server Error - still raise exception for these
            response.raise_for_status()

        return None

    def _call_api(self, endpoint: str, params: Dict[str, Any], parent_data=None, url: str = None, detail_url: str = None, return_type: str = 'json', request_body_config: Dict = None) -> DataFrame | Response | dict | Any:
        """Make API call and process response"""
        # Build URL if not provided
        if not url:
            url_builder = URLBuilder(self.integration)
            url = url_builder.build_api_url(endpoint, params, parent_data)

        self.logger.debug(f"Making API call to: {url}")

        # Common HTTP request logic
        headers = self.integration.get_auth_headers()

        # Handle Unleashed HMAC signature authentication
        auth_type = self.integration.config.get('auth_type', 'api_key')
        if auth_type == 'unleashed_hmac_signature':
            headers = self._apply_unleashed_signature(url, headers)

        self.integration._rate_limit()

        # Check if this is a custom_request authentication or POST request with request body
        auth_type = self.integration.config.get('auth_type', 'api_key')
        if auth_type == 'custom_request' and 'X-Custom-Request-Body' in headers:
            # Handle custom request with JSON body (like FYI)
            response = self._make_custom_request(url, headers, params, endpoint)
        elif request_body_config:
            # Handle POST request with request body configuration (like HubSpot v3 associations)
            response = self._make_post_request_with_body(url, headers, params, endpoint, request_body_config)
        else:
            # Standard GET request
            response = self._make_standard_request(url, headers, params)

        # Check status code
        error_msg = self._check_status(response)
        if error_msg:
            # Return empty DataFrame and log warning for 4xx errors
            self.logger.warning(f"{error_msg}")
            return pd.DataFrame()

        if return_type.lower() == 'xml':
            # Return response object directly for XML processing
            return response
        else :
            # Get JSON response
            response_data = response.json()

            # Check if we need to fetch detailed data for each record
            detailed_response_data = self._call_api_detail(endpoint, response_data, detail_url, headers)
            if detailed_response_data is not None:
                # Use detailed data if available
                response_data = detailed_response_data

            # Parse JSON response using integration's transformer
            parsed_data = self.integration.transformer._parse_json(response_data, endpoint)

            # Check if we need to extract pagination info from headers
            schema_config = self.integration._extract_schema_config()
            pagination_config = schema_config.get('api_config', {}).get('pagination', {})
            if not pagination_config:
                pagination_config = schema_config.get('pagination_config', {})

            if pagination_config.get('type') == 'link_header_based':
                # Extract next URL from Link header
                next_url = self._extract_next_url_from_link_header(response.headers, pagination_config)
                # Add pagination info to parsed data
                if isinstance(parsed_data, dict):
                    # If parsed_data is dict (multiple endpoints), add pagination to each
                    for key in parsed_data:
                        if hasattr(parsed_data[key], '__dict__'):  # DataFrame
                            parsed_data[key]._pagination_info = {
                                'next_url': next_url,
                                'has_more': next_url is not None
                            }
                # Also store as instance variable for data_extraction to access
                self._last_pagination_info = {
                    'next_url': next_url,
                    'has_more': next_url is not None
                }

            return parsed_data

    @staticmethod
    def _should_refresh_token(last_refresh_time: datetime) -> bool:
        """
        Check if token should be refreshed (20-minute interval)

        Args:
            last_refresh_time: Time when token was last refreshed

        Returns:
            True if 20 minutes have passed since last refresh, False otherwise
        """
        refresh_interval = timedelta(minutes=20)
        return datetime.now() - last_refresh_time >= refresh_interval

    def _call_api_detail(self, endpoint: str, response_data: Dict, detail_url: str, headers: Dict) -> Dict:
        """
        Fetch detailed data for each record in the initial response.

        This is used when an endpoint has is_details=True and detail_path defined in schema.
        For each record in the initial response, fetch the detailed version and merge them.

        Refreshes authentication token every 20 minutes to avoid expiration issues by
        processing records in batches with fresh tokens for each batch.

        Args:
            endpoint: The current endpoint name
            response_data: The initial API response data
            detail_url: The URL format for detailed data
            headers: Headers to use for API requests

        Returns:
            A new response data object with detailed data merged in, or None if detailed data
            is not needed or unavailable
        """
        try:
            # Check if this endpoint has is_details and detail_path in schema
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return None

            # Find current endpoint config
            endpoint_config = None
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    endpoint_config = ep
                    break

            if not endpoint_config:
                return None

            # Check if this endpoint has is_details and detail_path
            is_details = endpoint_config.get('is_details', False)
            if not is_details:
                return None

            # Extract records from initial response
            # First check if schema defines root_data_field
            response_structure = endpoint_config.get('response_structure', {})
            root_data_field = response_structure.get('root_data_field', 'data')

            if isinstance(response_data, list):
                records = response_data
            elif isinstance(response_data, dict):
                # Prioritize schema-defined root_data_field
                if root_data_field in response_data:
                    records = response_data[root_data_field]
                else:
                    # Fallback to common field names only if schema doesn't specify
                    for field in ['data', 'results', 'items', 'records']:
                        if field in response_data:
                            records = response_data[field]
                            break
                    else:
                        self.logger.warning(f"Could not extract records from response for detail fetching using root_data_field '{root_data_field}' or common fields")
                        return None
            else:
                self.logger.warning(f"Could not extract records from response for detail fetching")
                return None

            if not records or not isinstance(records, list):
                self.logger.warning(f"No records found in response for detail fetching")
                return None

            # Get ID field candidates with intelligent detection from detail_url
            import re
            id_field_candidates = []

            # First priority: Extract field names from detail_url placeholders
            if detail_url:
                url_placeholders = re.findall(r'\{([^}]+)\}', detail_url)
                for placeholder in url_placeholders:
                    if placeholder not in id_field_candidates:
                        id_field_candidates.append(placeholder)

            # Second priority: Primary key from schema
            primary_id_field = None
            for field in endpoint_config.get('fields', []):
                if field.get('is_primary_key', False):
                    primary_id_field = field.get('api_name', '')
                    break

            if primary_id_field and primary_id_field not in id_field_candidates:
                id_field_candidates.append(primary_id_field)

            # Third priority: Common ID field patterns
            common_id_fields = ['uuid', 'id', 'UUID', 'ID', 'Uuid', 'Id']
            for common_field in common_id_fields:
                if common_field not in id_field_candidates:
                    id_field_candidates.append(common_field)

            self.logger.info(f"ID field candidates in priority order: {id_field_candidates}")

            # Create merged data structure for detailed records
            merged_data = [None] * len(records)

            # Use ThreadPoolManager for consistent threading logic
            try:
                auth_config = schema.get('api_config', {}).get('authentication', {})
                rate_config = auth_config.get('rate_limiting', {})
                requests_per_minute = rate_config.get('requests_per_minute', 60)
                safety_margin = 0.8

                optimal_workers = calculate_optimal_workers(requests_per_minute, safety_margin, max_workers=20)

                # Create ThreadPoolManager for detail processing
                logger_name = f"{self.integration.integration_name}.{endpoint}.DetailProcessing"
                thread_manager = ThreadPoolManager(
                    max_workers=optimal_workers,
                    rate_limit_per_minute=requests_per_minute,
                    safety_margin=safety_margin,
                    logger_name=logger_name
                )

                self.logger.info(f"Using ThreadPoolManager with {optimal_workers} workers for detail processing")
            except Exception as e:
                # Fallback to basic ThreadPoolManager
                self.logger.warning(f"Error setting up ThreadPoolManager: {e}, using fallback")
                thread_manager = ThreadPoolManager(max_workers=5, rate_limit_per_minute=60)

            # Define function to process a single record
            def process_record(index, record, headers_copy):
                """Process a single record with the given headers"""
                # Find an ID field in the record
                record_id = None
                used_id_field = None

                # Case-insensitive check for ID fields
                record_keys_lower = {k.lower(): k for k in record.keys()}

                # Try each candidate in priority order
                for candidate in id_field_candidates:
                    # Exact match first
                    if candidate in record and record[candidate]:
                        record_id = record[candidate]
                        used_id_field = candidate
                        break
                    # Case-insensitive match
                    elif candidate.lower() in record_keys_lower:
                        actual_key = record_keys_lower[candidate.lower()]
                        if record[actual_key]:  # Make sure it's not empty
                            record_id = record[actual_key]
                            used_id_field = actual_key
                            break

                # If no valid ID found, return original record
                if not record_id:
                    self.logger.warning(f"Record {index} missing any valid ID field from {id_field_candidates}")
                    return record

                # Double check that the ID is not empty
                if not str(record_id).strip():
                    self.logger.warning(f"Record {index} has empty ID value")
                    return record

                self.logger.debug(f"Using ID '{used_id_field}' with value '{record_id}' for record {index}")

                # Build detail URL by replacing all placeholders with record values
                import re
                detail_url_replace = detail_url

                # Find all placeholders in the URL (format: {FieldName})
                placeholder_matches = re.findall(r'\{([^}]+)\}', detail_url)

                for placeholder_field in placeholder_matches:
                    placeholder_full = f"{{{placeholder_field}}}"

                    # Try to find matching field in record (case-insensitive)
                    replacement_value = None

                    # First try exact match
                    if placeholder_field in record and record[placeholder_field]:
                        replacement_value = str(record[placeholder_field])
                    else:
                        # Try case-insensitive match
                        record_keys_lower = {k.lower(): k for k in record.keys()}
                        if placeholder_field.lower() in record_keys_lower:
                            actual_key = record_keys_lower[placeholder_field.lower()]
                            if record[actual_key]:
                                replacement_value = str(record[actual_key])

                    # If found, replace in URL
                    if replacement_value:
                        detail_url_replace = detail_url_replace.replace(placeholder_full, replacement_value)
                        self.logger.debug(f"Replaced {placeholder_full} with '{replacement_value}' from field '{placeholder_field}'")
                    else:
                        self.logger.warning(f"Could not find value for placeholder {placeholder_full} in record {index}")
                        # If any placeholder cannot be resolved, return original record
                        return record

                try:
                    # Apply rate limiting
                    self.integration._rate_limit()

                    # Make the request
                    detail_response = self._make_standard_request(
                        url=detail_url_replace,
                        headers=headers_copy,
                        params={}
                    )

                    # Check response
                    error_msg = self._check_status(detail_response)
                    if error_msg:
                        # Handle 401 Unauthorized - token expired
                        if (detail_response.status_code == 401 and
                            ("Token expired" in error_msg or "Unauthorized" in error_msg)):

                            # Try to refresh token and retry the request
                            self.logger.info(f"Token expired detected. Refreshing auth headers for retry...")
                            refreshed_headers = self.integration.get_auth_headers()

                            self.integration._rate_limit()
                            detail_response = self._make_standard_request(
                                url=detail_url_replace,
                                headers=refreshed_headers,
                                params={}
                            )

                            # Check response after retry
                            error_msg = self._check_status(detail_response)
                            if error_msg:
                                self.logger.warning(f"Error fetching detail for record {record_id} after token refresh: {error_msg}")
                                self._log_retry_failure(endpoint, record_id, detail_url_replace, f"401 retry failed: {error_msg}")
                                return record
                        # Handle 429 Too Many Requests - rate limit exceeded
                        elif detail_response.status_code == 429:
                            self.logger.warning(f"Rate limit exceeded for record {record_id}: {error_msg}")
                            self._log_retry_failure(endpoint, record_id, detail_url_replace, f"429 rate limit: {error_msg}")
                            return record
                        else:
                            self.logger.warning(f"Error fetching detail for record {record_id}: {error_msg}")
                            self._log_retry_failure(endpoint, record_id, detail_url_replace, error_msg)
                            return record

                    # Parse the response
                    detail_data = detail_response.json()

                    # Extract the detailed record from the response
                    detail_record = None
                    if isinstance(detail_data, dict):
                        # First try schema-defined root_data_field for single record responses
                        if root_data_field in detail_data:
                            detail_record = detail_data[root_data_field]
                        else:
                            # Try common field names for wrapped data
                            for field in ['data', 'results', 'item', 'record']:
                                if field in detail_data:
                                    detail_record = detail_data[field]
                                    break

                    # If no specific wrapper field found, use the entire response
                    if detail_record is None:
                        detail_record = detail_data

                    # Ensure detail_record is a dictionary
                    if not isinstance(detail_record, dict):
                        # If it's a list, try to get the first element
                        if isinstance(detail_record, list) and len(detail_record) > 0:
                            detail_record = detail_record[0]
                            # Check if first element is a dictionary
                            if not isinstance(detail_record, dict):
                                self.logger.warning(f"First element of detail data is not a dictionary: {type(detail_record)}")
                                return record
                        else:
                            self.logger.warning(f"Detailed data is not a dictionary: {type(detail_record)}")
                            return record

                    # Merge detailed data with original record
                    merged_record = {**record, **detail_record}

                    # Log enriched fields
                    detail_only_keys = [k for k in detail_record if k not in record or detail_record[k] != record[k]]
                    if detail_only_keys:
                        self.logger.debug(f"Record {index} enriched with {len(detail_only_keys)} new fields")

                    return merged_record

                except Exception as e:
                    self.logger.error(f"Error processing record {record_id}: {str(e)}")
                    return record

            # Process records in batches to ensure token freshness
            # This is the key improvement to prevent token expiration issues
            batch_size = 100  # Adjust based on expected processing time
            total_records = len(records)

            self.logger.info(f"Processing {total_records} records in batches of {batch_size}")

            # Process all records in batches, each with a fresh token
            for batch_start in range(0, total_records, batch_size):
                # Add delay between batches to prevent rate limit conflicts
                if batch_start > 0:  # Not the first batch
                    delay_seconds = 5  # 5 second buffer between batches
                    delay_msg = f"⏳ Waiting {delay_seconds}s between batches to respect rate limits..."
                    self.logger.info(delay_msg)
                    print(delay_msg)
                    time.sleep(delay_seconds)

                # Get batch end index (limited by total records)
                batch_end = min(batch_start + batch_size, total_records)
                batch_records = records[batch_start:batch_end]

                # Log batch information
                batch_msg = f"\n📊 Processing batch {batch_start+1}-{batch_end} of {total_records} records"
                self.logger.info(batch_msg)
                print(batch_msg)

                # Get fresh token for this batch
                with self._token_refresh_lock:
                    # Get fresh token regardless of previous token age
                    # This ensures each batch always starts with a fresh token
                    new_headers = self.integration.get_auth_headers()
                    self._last_token_refresh_time = datetime.now()

                    # Log token refresh
                    refresh_msg = f"🔄 Starting batch with fresh token at {self._last_token_refresh_time.strftime('%H:%M:%S')}"
                    self.logger.info(refresh_msg)
                    print(refresh_msg)

                # Define processor for single record with headers
                def process_single_record_with_headers(record_data):
                    """Process single record with pre-set headers"""
                    actual_index, record = record_data
                    headers_copy = new_headers.copy()
                    return process_record(actual_index, record, headers_copy)

                # Prepare data for ThreadPoolManager
                batch_data = [(batch_start + i, record) for i, record in enumerate(batch_records)]

                # Use ThreadPoolManager instead of concurrent.futures
                batch_results = thread_manager.threaded_execution(batch_data, process_single_record_with_headers)

                # Store results in merged_data
                for i, result in enumerate(batch_results):
                    actual_index = batch_start + i
                    if result is not None:
                        merged_data[actual_index] = result
                    else:
                        # Use original record on error
                        merged_data[actual_index] = records[actual_index]

                # Log batch completion
                self.logger.info(f"✅ Completed batch {batch_start+1}-{batch_end}")

            # Create final result structure based on original response format
            if isinstance(response_data, list):
                # If original response was a list, return merged list
                self.logger.info(f"Successfully fetched and merged detailed data for {len(merged_data)} records")
                return merged_data

            elif isinstance(response_data, dict):
                # Use schema-defined root_data_field first, then fallback
                if root_data_field in response_data:
                    result = copy.deepcopy(response_data)
                    result[root_data_field] = merged_data
                    self.logger.info(f"Successfully fetched and merged detailed data for {len(merged_data)} records using schema root_data_field '{root_data_field}'")
                    return result
                else:
                    # For other formats, try to identify the data field and replace it
                    for field in ['data', 'results', 'items', 'records']:
                        if field in response_data:
                            result = copy.deepcopy(response_data)
                            result[field] = merged_data
                            self.logger.info(f"Successfully fetched and merged detailed data for {len(merged_data)} records using fallback field '{field}'")
                            return result

                # If we can't determine format, return original response
                self.logger.warning("Could not merge detailed data with original response format")
                return None

        except Exception as e:
            self.logger.error(f"Error in _call_api_detail for endpoint {endpoint}: {str(e)}")
            return None

    def _extract_next_url_from_link_header(self, headers: Dict, pagination_config: Dict) -> str:
        """Extract next URL from Link header (Shopify style)"""
        try:
            header_name = pagination_config.get('header_name', 'Link')
            next_rel = pagination_config.get('next_rel', 'next')

            link_header = headers.get(header_name, '')
            if not link_header:
                return None

            # Parse Link header format: <https://example.com/api?page_info=xyz>; rel="next"
            import re
            pattern = rf'<([^>]+)>;\s*rel="{next_rel}"'
            match = re.search(pattern, link_header)
            if match:
                return match.group(1)

            return None
        except Exception as e:
            self.logger.warning(f"Error extracting next URL from Link header: {e}")
            return None

    def _save_to_database(self, df: pd.DataFrame, stage_table: str, endpoint: str = 'unknown') -> int:
        """Save DataFrame to database stage table using UPSERT"""
        try:
            if df.empty:
                return 0
            
            # Add metadata columns
            df['SourceSystemName'] = 'API'
            df['CaptureLog'] = f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - API extraction"

            # Check if schema config has usingEtaniLinkOrganisationID flag set to true
            schema = self.integration._load_schema()
            if schema and schema.get('usingEtaniLinkOrganisationID', False) and hasattr(self.integration, 'etani_link_organisation_id'):
                # Use EtaniLinkOrganisationID for OrganisationID column if available
                df['OrganisationID'] = self.integration.etani_link_organisation_id
                print(f"📊 Using EtaniLinkOrganisationID for data: {self.integration.etani_link_organisation_id}")
            else:
                # Use regular OrganisationID
                df['OrganisationID'] = self.integration.etani_organisation_id

            df['IntegrationRunID'] = getattr(self.integration, 'integration_run_id', 1)
            
            # Get primary key from schema for UPSERT
            primary_key = self._get_primary_key_for_endpoint(endpoint)
            
            # Use UPSERT function like main extraction flow
            from dynamic_integrations.database.sql_helper import LoadToEvaStageTableUpsert
            LoadToEvaStageTableUpsert(df, endpoint, primary_key, stage_table, [])
            
            self.logger.info(f"Successfully saved {len(df)} records to {stage_table} using UPSERT")
            return len(df)
            
        except Exception as e:
            self.logger.error(f"Error saving data to database: {e}")
            return 0
    
    def _get_primary_key_for_endpoint(self, endpoint: str) -> str:
        """Get primary key for endpoint from schema"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return 'ID'  # Default fallback
            
            # Find endpoint in schema
            for ep in schema['endpoints']:
                if ep.get('name', '').lower() == endpoint.lower():
                    # Check for explicit primary key in schema
                    primary_key = ep.get('primary_key')
                    if primary_key:
                        return primary_key
                    
                    # Check database_config for primary key
                    db_config = ep.get('database_config', {})
                    if 'primary_key' in db_config:
                        return db_config['primary_key']
                    
                    # Fallback to entity-based naming
                    entity_name = endpoint.replace('stage', '')
                    if entity_name.endswith('ies'):
                        entity_name = entity_name[:-3] + 'y'
                    elif entity_name.endswith('s'):
                        entity_name = entity_name[:-1]
                    
                    # Return common primary key patterns
                    return f'{entity_name}ID'
            
            # Ultimate fallback
            return 'ID'
            
        except Exception as e:
            self.logger.warning(f"Error getting primary key for {endpoint}: {e}")
            return 'ID'
    
    def _get_endpoint_path(self, endpoint: str) -> str:
        """Get API path for endpoint from schema"""
        try:
            schema = self.integration._load_schema()
            if schema and 'endpoints' in schema:
                for ep in schema['endpoints']:
                    if ep.get('name') == endpoint:
                        api_details = ep.get('api_details', {})
                        return api_details.get('path', f'/{endpoint.lower()}')
            
            return f'/{endpoint.lower()}'
            
        except Exception as e:
            self.logger.warning(f"Error getting endpoint path for {endpoint}: {e}")
            return f'/{endpoint.lower()}'
    
    @enterprise_retry(
        strategy=RetryStrategy.GATEWAY_CALLS,  # Changed from API_CALLS to GATEWAY_CALLS for better 502 handling
        max_attempts=3,
        base_delay=2.0,  # Use 2 seconds between retries as requested
        enable_logging=True
    )
    def make_custom_request_advanced(self, url: str, headers: Dict[str, str], params: Dict[str, Any], endpoint: str):
        """
        Handle custom request with JSON body for APIs like FYI with immediate status check for 5xx errors

        This method handles the special case where:
        1. Authentication is via custom headers
        2. Request is POST with JSON payload
        3. Pagination and filters are in request body, not query params
        4. Response data may be wrapped in a specific structure
        """
        try:
            # Extract request body configuration from headers
            request_body_json = headers.pop('X-Custom-Request-Body', '{}')
            request_body_config = json.loads(request_body_json)

            # Build request body from configuration
            request_body = self.build_custom_request_body(request_body_config, params, endpoint)

            # Get HTTP method from auth config, default to POST for custom_request
            auth_config = self.integration.config.get('auth_config', {})
            method = auth_config.get('method', 'POST').upper()

            # Make HTTP request with JSON body
            if method == 'POST':
                response = requests.post(
                    url=url,
                    headers=headers,
                    json=request_body,
                    timeout=30
                )
            elif method == 'GET':
                response = requests.get(
                    url=url,
                    headers=headers,
                    timeout=30
                )
            else:
                raise ValueError(f"Unsupported HTTP method: {method}")

            # Immediately check for 5xx errors and raise exception to trigger retry
            if 500 <= response.status_code < 600:
                response.raise_for_status()

            return response

        except Exception as e:
            self.logger.error(f"Custom request failed for {endpoint}: {str(e)}")
            raise
    
    def build_custom_request_body(self, body_config: Dict[str, Any], params: Dict[str, Any], endpoint: str) -> Dict[str, Any]:
        """
        Build request body from configuration and parameters
        
        Handles template variable replacement and parameter injection
        """
        try:
            # Deep copy the body structure to avoid modifying original
            request_body = copy.deepcopy(body_config.get('structure', {}))
            
            # Replace template variables and add pagination params
            request_body = self._replace_request_body_variables(request_body, params, endpoint)
            
            return request_body
            
        except Exception as e:
            self.logger.error(f"Failed to build custom request body: {str(e)}")
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

    def _apply_unleashed_signature(self, url: str, headers: Dict[str, str]) -> Dict[str, str]:
        """Apply Unleashed HMAC signature to headers by parsing URL for query parameters"""
        try:
            from urllib.parse import urlparse, parse_qs

            # Parse URL to get query parameters
            parsed_url = urlparse(url)
            query_params = parse_qs(parsed_url.query, keep_blank_values=False)

            # Convert query_params to flat dict (parse_qs returns lists)
            flat_params = {}
            for key, values in query_params.items():
                if values and values[0]:  # Only non-empty values
                    flat_params[key] = values[0]

            # Get private key from headers (set by auth_manager)
            api_private_key = headers.pop('X-Unleashed-Signature-Key', None)
            if not api_private_key:
                self.logger.error("Missing Unleashed API private key in headers")
                return headers

            # Generate signature using the auth_manager method
            signature = self.integration.auth_manager.generate_unleashed_signature(flat_params, api_private_key)

            # Find and replace signature header
            for header_name, header_value in headers.items():
                if header_value == 'SIGNATURE_PLACEHOLDER':
                    headers[header_name] = signature
                    self.logger.debug(f"Applied Unleashed signature to header '{header_name}'")
                    break

            self.logger.debug(f"Generated Unleashed signature for query params: {list(flat_params.keys())}")
            return headers

        except Exception as e:
            self.logger.error(f"Failed to apply Unleashed signature: {e}")
            return headers

    @staticmethod
    def _log_retry_failure(endpoint: str, record_id: str, url: str, error_message: str):
        """Log failed retry IDs to simple text file for tracking"""
        try:
            import os
            from datetime import datetime

            # Create failures directory
            from dynamic_integrations.paths import data_directory
            failures_dir = str(data_directory('retry_failures'))
            os.makedirs(failures_dir, exist_ok=True)

            # Write to simple text file
            log_filename = f"failed_retry_ids_{datetime.now().strftime('%Y%m%d')}.txt"
            log_filepath = os.path.join(failures_dir, log_filename)

            with open(log_filepath, 'a', encoding='utf-8') as f:
                f.write(f"{record_id}\n")

        except Exception as e:
            pass  # Silent fail