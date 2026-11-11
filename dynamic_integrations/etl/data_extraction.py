import json
from pathlib import Path

import pandas as pd
from typing import Dict, Any, List
from datetime import datetime
# Add parent directory to path
import sys
import os

import requests

from ..generator.utils import Utils

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from dynamic_integrations.database.sql_helper import LoadToEvaStageTable, LoadToEvaStageTableUpsert, ExecuteDirectCMSSP

# Import modular extractors
from .extractors.api_client import APIClient
from .extractors.url_builder import URLBuilder
from .extractors.query_builder import QueryBuilder  
from .extractors.child_endpoint_handler import ChildEndpointHandler

class DataExtractor:
    """
    Data extraction component for Dynamic Integration
    Handles API calls, pagination, URL building, and data retrieval
    
    This class now serves as an orchestrator that delegates specific tasks
    to specialized singleton-based extractor classes.
    """
    
    def __init__(self, integration_instance):
        """Initialize with reference to the main integration instance"""
        self.integration = integration_instance
        self.logger = integration_instance.logger
        self.config = integration_instance.config
        self.error_list = integration_instance.error_list
        
        # Initialize singleton-based extractors for efficient reuse
        self._api_client = None
        self._url_builder = None
        self._query_builder = None
        self._child_handler = None
    
    @property
    def api_client(self):
        """Lazy-loaded singleton API client"""
        if self._api_client is None:
            self._api_client = APIClient(self.integration)
        return self._api_client
    
    @property
    def url_builder(self):
        """Lazy-loaded singleton URL builder"""
        if self._url_builder is None:
            self._url_builder = URLBuilder(self.integration)
        return self._url_builder
    
    @property
    def query_builder(self):
        """Lazy-loaded singleton query builder"""
        if self._query_builder is None:
            self._query_builder = QueryBuilder(self.integration)
        return self._query_builder
    
    @property
    def child_handler(self):
        """Lazy-loaded singleton child endpoint handler"""
        if self._child_handler is None:
            self._child_handler = ChildEndpointHandler(self.integration)
        return self._child_handler
    
    def extract_api_response(self, endpoint: str, upsert_mode: bool = False) -> Dict[str, Any]:
        """
        Main API data extraction method - orchestration only
        
        Delegates actual processing to specialized extractor classes

        Args:
            endpoint: Name of the endpoint to extract
            upsert_mode: If True, builds incremental parameters for UPSERT mode
        """
        try:
            stage_table = f"{self.integration.table_prefix_eva}{endpoint.lower()}stage"

            # Check if this is a child endpoint and delegate accordingly
            if self._is_child_endpoint_from_schema(endpoint):
                self.logger.info(f"🔗 Processing child endpoint: {endpoint}")
                
                # Build UPSERT parameters for child endpoint if in UPSERT mode
                upsert_params = {}
                if upsert_mode:
                    upsert_params = self.query_builder.build_upsert_params(endpoint)
                
                total_records = self.child_handler.extract_child_data(endpoint, stage_table, upsert_mode, upsert_params)
            else:
                # Regular endpoint: Build URL then extract
                url_builder = URLBuilder(self.integration)
                url, detail_url = url_builder.build_api_url(endpoint)
                total_records = self._extract_from_url(url, detail_url, endpoint, stage_table, upsert_mode)

            if total_records > 0:
                # Execute stored procedure for main endpoint
                integration_name = self.integration.integration_original_name.lower() if hasattr(self.integration, 'integration_original_name') else self.integration.integration_name.lower()
                sp_name = f'sp_dynamic_{integration_name}_{endpoint.lower()}'
                sp_call = f"CALL {sp_name}('{self.integration.client_id_number}', {self.integration.etani_organisation_id})"
                # Execute SQL directly against client database - bypass stored procedure
                ExecuteDirectCMSSP(sp_call, endpoint, self.error_list, query=True)

                # Check if endpoint has reference configuration
                endpoint_schema = self._get_endpoint_schema(endpoint)
                if endpoint_schema and 'reference' in endpoint_schema:
                    self.logger.info(f"🔄 Processing reference data for {endpoint}")
                    reference_records = self._extract_reference_data(endpoint, stage_table, upsert_mode)
                
                # Execute stored procedures for nested endpoints (cascade)
                self._execute_nested_endpoint_sps(endpoint)

            return {'success': True, 'endpoint': endpoint, 'records_processed': total_records}

        except requests.exceptions.HTTPError as http_err:
            # Initialize error_msg with default value
            error_msg = f"HTTP error: {str(http_err)}"
            
            # Format error message for _is_token_error() detection
            if hasattr(http_err, 'response') and http_err.response is not None:
                status_code = http_err.response.status_code
                try:
                    response_json = http_err.response.json()
                    if response_json.get('error') == 'invalid_grant':
                        error_msg = f"Authentication error: invalid_grant"
                    elif status_code in [401, 403]:
                        error_msg = f"Authentication error {status_code}: {str(http_err)}"
                    else:
                        error_msg = f"HTTP error {status_code}: {str(http_err)}"
                except:
                    if status_code in [401, 403]:
                        error_msg = f"Authentication error {status_code}: {str(http_err)}"

            return {'success': False, 'endpoint': endpoint, 'error': error_msg, 'records_processed': 0}
        except Exception as e:
            error_msg = f"Error extracting {endpoint}: {str(e)}"
            self.logger.error(error_msg)
            return {'success': False, 'endpoint': endpoint, 'error': error_msg, 'records_processed': 0}
    
    def _execute_nested_endpoint_sps(self, endpoint: str):
        """
        Execute stored procedures for all nested endpoints (including cascade nesting)
        
        Args:
            endpoint: Parent endpoint name
        """
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return
            
            # Find parent endpoint config
            endpoint_config = None
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    endpoint_config = ep
                    break
            
            if not endpoint_config or 'nested_extractions' not in endpoint_config:
                return
            
            # Get all nested endpoints recursively
            nested_endpoints = self._get_all_nested_endpoints_recursive(endpoint, schema, set())
            
            # Execute SP for each nested endpoint
            for nested_endpoint in nested_endpoints:
                integration_name = self.integration.integration_original_name.lower() if hasattr(self.integration,
                                                                                                 'integration_original_name') else self.integration.integration_name.lower()
                sp_name = f'sp_dynamic_{integration_name.lower()}_{nested_endpoint.lower()}'
                sp_call = f"CALL {sp_name}('{self.integration.client_id_number}', {self.integration.etani_organisation_id})"
                self.logger.info(f"Executing nested endpoint SP: {nested_endpoint}")
                # Execute SQL directly against client database - bypass stored procedure
                ExecuteDirectCMSSP(sp_call, nested_endpoint, self.error_list, query=True)
                
        except Exception as e:
            self.logger.error(f"Error executing nested endpoint SPs for {endpoint}: {str(e)}")
    
    def _get_all_nested_endpoints_recursive(self, endpoint: str, schema: Dict, visited: set) -> List[str]:
        """
        Get all nested endpoints recursively (cascade nesting)
        
        Args:
            endpoint: Current endpoint name
            schema: Schema configuration
            visited: Set to track visited endpoints (avoid infinite loops)
            
        Returns:
            List of all nested endpoint names
        """
        if endpoint in visited:
            return []
        
        visited.add(endpoint)
        nested_endpoints = []
        
        # Find endpoint config
        endpoint_config = None
        for ep in schema.get('endpoints', []):
            if ep.get('name') == endpoint:
                endpoint_config = ep
                break
        
        if not endpoint_config:
            return []
        
        # Get direct nested endpoints
        nested_extractions = endpoint_config.get('nested_extractions', [])
        for extraction in nested_extractions:
            table_name = extraction.get('table_name')
            if table_name:
                nested_endpoints.append(table_name)
                # Recursively get nested endpoints of this nested endpoint
                child_nested = self._get_all_nested_endpoints_recursive(table_name, schema, visited)
                nested_endpoints.extend(child_nested)
        
        return nested_endpoints

    def extract_api_response_for_discovery(self, endpoint: str) -> Dict[str, Any]:
        """
        Extract API data for discovery purposes - collect only 1 merged sample record
        
        Load schema first to identify JSON fields, merge only non-null JSON fields
        Return single record instead of all sample data to optimize memory
        
        Args:
            endpoint: Name of the endpoint to sample
            
        Returns:
            Dict with success status and single merged sample_data record
        """
        try:
            # Load JSON fields from schema first
            json_fields = self._get_json_fields_from_endpoint_schema(endpoint)
            if not json_fields:
                self.logger.info(f"No JSON fields found in schema for {endpoint}, skipping discovery")
                return {'success': True, 'endpoint': endpoint, 'sample_data': {}}
            
            self.logger.info(f"Found {len(json_fields)} JSON fields to discover: {json_fields}")
            
            # Check if this is a child endpoint and delegate accordingly
            if self._is_child_endpoint_from_schema(endpoint):
                self.logger.info(f"Sampling child endpoint: {endpoint}")
                raw_sample_data = self.child_handler.sample_child_data(endpoint)
            else:
                # Regular endpoint: Build URL then sample
                url_builder = URLBuilder(self.integration)
                url = url_builder.build_api_url(endpoint)
                raw_sample_data = self._sample_from_url_for_json_fields(url, endpoint, json_fields)
            
            # Merge only JSON fields from all records into single record
            merged_sample = self._merge_json_fields_to_single_record(raw_sample_data, json_fields, endpoint)
            
            self.logger.info(f"Discovery complete for {endpoint}: merged {len(raw_sample_data) if isinstance(raw_sample_data, list) else 'N/A'} records into 1 sample with {len(merged_sample)} JSON fields")
            return {'success': True, 'endpoint': endpoint, 'sample_data': merged_sample}

        except Exception as e:
            error_msg = f"Error sampling {endpoint}: {str(e)}"
            self.logger.error(error_msg)
            return {'success': False, 'endpoint': endpoint, 'error': error_msg, 'sample_data': {}}

    def _sample_from_url(self, base_url: str, endpoint: str) -> list:
        """
        Sample data from URL for discovery purposes - collect sample data only
        
        Similar to _extract_from_url but returns sample data instead of saving to DB
        
        Args:
            base_url: Base URL to sample from
            endpoint: Name of the endpoint
            
        Returns:
            List of sample records
        """
        sample_data = []
        page = 1
        max_sample_pages = 3  # Limit sample to first 3 pages
        
        schema_config = self.integration._extract_schema_config()
        
        # Get pagination config (same logic as _extract_from_url)
        endpoint_pagination_config = self._get_endpoint_pagination_config(endpoint)
        if endpoint_pagination_config:
            pagination_config = endpoint_pagination_config
            self.logger.info(f"📋 Using endpoint-specific pagination for {endpoint} sampling")
        else:
            pagination_config = schema_config.get('api_config', {}).get('pagination', {})
            if not pagination_config:
                pagination_config = schema_config.get('pagination_config', {})
            self.logger.info(f"📋 Using global pagination config for {endpoint} sampling")
        
        limit = pagination_config.get('default_limit', 100)
        
        # Check if pagination should be used
        use_pagination = self._should_use_pagination(endpoint)
        if not use_pagination:
            self.logger.info(f"🚫 Pagination disabled for {endpoint} - sampling single record")
        
        while True:
            # Build parameters (no UPSERT params for sampling)
            params = {}
            
            # Add required parameters from schema
            required_params = self.query_builder.build_required_params(endpoint)
            if required_params:
                params.update(required_params)
                self.logger.debug(f"Adding required params to sample API call: {required_params}")
            
            # Add pagination params only if pagination is enabled
            if use_pagination:
                pagination_params = self.query_builder.build_pagination_params(pagination_config, page, limit)
                params.update(pagination_params)
            
            # Make API call (same logic as _extract_from_url)
            auth_type = self.integration.config.get('auth_type', 'api_key')
            if auth_type == 'custom_request':
                data = self.api_client._call_api(endpoint, params, url=base_url)
            else:
                current_url = self._build_paginated_url(base_url, params)
                data = self.api_client._call_api(endpoint, {}, url=current_url)
            
            if data is None or data.empty or len(data) == 0:
                if page == 1:
                    self.logger.info(f"ℹ️ No data returned for endpoint {endpoint} sampling")
                else:
                    self.logger.info(f"ℹ️ No more data for endpoint {endpoint} at page {page} - sampling complete")
                break
            
            # Convert DataFrame to records for analysis
            if hasattr(data, 'to_dict'):
                page_records = data.to_dict('records')
            else:
                page_records = data if isinstance(data, list) else [data]
            
            sample_data.extend(page_records)
            self.logger.info(f"🔍 Sampled {len(page_records)} records from {endpoint} (Page {page})")
            
            # Stop conditions for sampling
            if not use_pagination:
                # No pagination - single request only
                break
            elif len(data) < limit:
                # Pagination enabled but got less data than limit - done
                break
            elif page >= max_sample_pages:
                # Reached max sample pages
                self.logger.info(f"📊 Sampling stopped at page {page} for {endpoint} (max sample pages reached)")
                break
            
            page += 1
        
        self.logger.info(f"📊 Total sample records collected for {endpoint}: {len(sample_data)}")
        return sample_data

    def _get_endpoint_schema(self, endpoint: str) -> dict:
        """
        Get endpoint schema configuration from the loaded schema

        Args:
            endpoint: Name of the endpoint

        Returns:
            dict: Endpoint schema configuration or empty dict if not found
        """
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

    def _extract_reference_data(self, endpoint: str, stage_table: str, upsert_mode: bool = False) -> int:
        """
        Process reference data for an endpoint after primary data has been processed

        This method handles the following steps:
        1. Get reference configuration from schema
        2. Fetch data from the reference_path API endpoint
        3. Convert XML to JSON if return_type is 'xml'
        4. Compare reference data with data already in database
        5. Fetch missing records using specific_path
        6. Process and save missing records by leveraging _extract_from_url

        Args:
            endpoint: Name of the endpoint
            stage_table: Stage table name
            upsert_mode: If True, use upsert mode for loading data

        Returns:
            int: Number of additional records processed
        """
        try:
            # Get endpoint schema and reference configuration
            endpoint_schema = self._get_endpoint_schema(endpoint)
            if not endpoint_schema or 'reference' not in endpoint_schema:
                self.logger.warning(f"No reference configuration found for {endpoint}")
                return 0

            reference_config = endpoint_schema.get('reference', {})

            # Get reference parameters
            reference_path = reference_config.get('reference_path')
            return_type = reference_config.get('return_type', 'json')
            method = reference_config.get('method', 'GET')
            query_params = reference_config.get('query_parameters', {}).get('required', {})
            root_data_field = reference_config.get('root_data_field', '')
            mapping_field = reference_config.get('mapping_field', {})
            ref_field = mapping_field.get('reference_field', 'UUID')
            table_field = mapping_field.get('table_field', 'UUID')

            if not reference_path:
                self.logger.warning(f"No reference_path found in reference configuration for {endpoint}")
                return 0

            self.logger.info(f"Fetching reference data from {reference_path} for {endpoint}")

            # Call API to get reference data
            from dynamic_integrations.etl.extractors.api_client import APIClient
            api_client = APIClient(self.integration)

            # Make the API call
            response = api_client._call_api(
                endpoint=endpoint,
                url=reference_path,
                params=query_params,
                return_type=return_type
            )

            # Process response based on return_type
            reference_records = []
            if return_type.lower() == 'xml':
                try:
                    import xmltodict
                    # Parse XML to dict
                    xml_dict = xmltodict.parse(response.content)

                    # Extract data using root_data_field path
                    if root_data_field:
                        # Split the path and navigate through nested dictionaries
                        field_parts = root_data_field.split('.')
                        data = xml_dict
                        for part in field_parts:
                            if part in data:
                                data = data[part]
                            else:
                                self.logger.error(f"Cannot find {part} in reference data structure")
                                return 0

                        # Handle both single item and list of items
                        if isinstance(data, dict):
                            reference_records = [data]
                        elif isinstance(data, list):
                            reference_records = data
                        else:
                            self.logger.error(f"Unexpected data type for {root_data_field}: {type(data)}")
                            return 0
                    else:
                        self.logger.error(f"No root_data_field specified for XML parsing in {endpoint}")
                        return 0

                except ImportError:
                    self.logger.error("xmltodict module not found. Install with 'pip install xmltodict'")
                    return 0
                except Exception as e:
                    self.logger.error(f"Error processing XML response: {str(e)}")
                    return 0
            else:
                # Assume JSON response
                reference_records = response.json()

                # Handle root data field if specified
                if root_data_field and isinstance(reference_records, dict):
                    field_parts = root_data_field.split('.')
                    data = reference_records
                    for part in field_parts:
                        if part in data:
                            data = data[part]
                        else:
                            self.logger.error(f"Cannot find {part} in reference data structure")
                            return 0
                    reference_records = data

            # Ensure reference_records is a list
            if not isinstance(reference_records, list):
                if isinstance(reference_records, dict):
                    reference_records = [reference_records]
                else:
                    self.logger.error(f"Unexpected reference data format: {type(reference_records)}")
                    return 0

            self.logger.info(f"Fetched {len(reference_records)} reference records for {endpoint}")

            # Get existing records from database for comparison
            existing_records = self._get_existing_records_from_db(stage_table)

            if not existing_records:
                self.logger.warning(f"No existing records found in {stage_table} for comparison")
                return 0

            # Extract IDs from reference and existing records
            reference_ids = set()
            for record in reference_records:
                ref_id = record.get(ref_field)
                if ref_id:
                    reference_ids.add(str(ref_id))

            existing_ids = set()
            for record in existing_records:
                existing_id = record.get(table_field)
                if existing_id:
                    existing_ids.add(str(existing_id))

            # Find missing IDs
            missing_ids = reference_ids - existing_ids

            if not missing_ids:
                self.logger.info(f"No missing records found for {endpoint}")
                return 0

            self.logger.info(f"Found {len(missing_ids)} missing records for {endpoint}")

            # Get specific_path for fetching individual records
            specific_path = endpoint_schema.get('specific_path')
            if not specific_path:
                self.logger.warning(f"No specific_path found for {endpoint}, cannot fetch missing records")
                return 0

            # Process missing IDs in batches using _extract_from_url
            # This leverages existing code for API calls, data processing, and database operations
            total_added = 0
            batch_size = 20  # Process 20 IDs at a time to avoid overwhelming the system
            missing_ids_list = list(missing_ids)

            # Calculate number of batches for progress reporting
            num_batches = (len(missing_ids_list) + batch_size - 1) // batch_size

            # Process each batch of missing IDs
            for batch_index, batch_start in enumerate(range(0, len(missing_ids_list), batch_size)):
                # Get current batch of IDs
                batch_end = min(batch_start + batch_size, len(missing_ids_list))
                current_batch = missing_ids_list[batch_start:batch_end]

                self.logger.info(f"Processing reference batch {batch_index+1}/{num_batches} with {len(current_batch)} IDs for {endpoint}")

                # Process each ID in the batch
                for missing_id in current_batch:
                    try:
                        # Replace UUID placeholder in specific_path
                        detail_path = specific_path.replace('{UUID}', str(missing_id))

                        # Get base URL from schema config
                        schema_config = self.integration._extract_schema_config()
                        url_config = schema_config.get('url_config', {})
                        base_api_url = url_config.get('base_url', '')

                        # Combine base URL with detail path
                        if base_api_url:
                            # Handle trailing and leading slashes correctly
                            if base_api_url.endswith('/') and detail_path.startswith('/'):
                                full_url = f"{base_api_url[:-1]}{detail_path}"
                            elif not base_api_url.endswith('/') and not detail_path.startswith('/'):
                                full_url = f"{base_api_url}/{detail_path}"
                            else:
                                full_url = f"{base_api_url}{detail_path}"
                        else:
                            # If no base URL in config, use detail_path as-is (might be a full URL)
                            full_url = detail_path

                        self.logger.info(f"Processing reference ID {missing_id} for {endpoint}, URL: {full_url}")

                        # Use _extract_from_url to leverage existing data extraction and loading logic
                        # This reuses code for API calls, error handling, data transformation, and database operations
                        records_added = self._extract_from_url(
                            base_url=full_url,
                            detail_url="",  # No detail URL needed as this is already a detail request
                            endpoint=endpoint,
                            stage_table=stage_table,
                            upsert_mode=upsert_mode,
                            initial_write_mode='append'  # Always append to avoid overwriting existing data
                        )

                        if records_added > 0:
                            total_added += records_added
                            self.logger.info(f"Added {records_added} reference records for ID {missing_id}")
                    except Exception as e:
                        self.logger.error(f"Error processing reference ID {missing_id} for {endpoint}: {str(e)}")
                        continue

                # Log batch completion
                self.logger.info(f"Completed reference batch {batch_index+1}/{num_batches} for {endpoint}")

            # Execute stored procedure after loading all missing records
            if total_added > 0:
                integration_name = self.integration.integration_original_name.lower() if hasattr(self.integration, 'integration_original_name') else self.integration.integration_name.lower()
                sp_name = f'sp_dynamic_{integration_name}_{endpoint.lower()}'
                sp_call = f"CALL {sp_name}('{self.integration.client_id_number}', {self.integration.etani_organisation_id})"

                # Execute SQL directly against client database - bypass stored procedure
                ExecuteDirectCMSSP(sp_call, f"{endpoint} (Reference)", self.error_list, query=True)

            return total_added

        except Exception as e:
            self.logger.error(f"Error extracting reference data for {endpoint}: {str(e)}")
            return 0

    def _is_child_endpoint_from_schema(self, endpoint: str) -> bool:
        """Check if endpoint is marked as child endpoint in schema"""
        try:
            endpoint_schema = self._get_endpoint_schema(endpoint)
            return endpoint_schema.get('is_child_endpoint', False)
        except Exception as e:
            self.logger.warning(f"Error checking child endpoint status for {endpoint}: {e}")
            return False

    def _get_existing_records_from_db(self, table_name: str) -> List[Dict]:
        """
        Get existing records from database table for reference data comparison

        Args:
            table_name: Name of the database table

        Returns:
            List of records as dictionaries
        """
        try:
            from sqlalchemy import text
            from dynamic_integrations.database.sql_helper import eva_engine

            # Build query to get all records from table
            query = text(f"""
                SELECT * FROM {table_name}
                WHERE OrganisationID = :org_id
            """)

            # Execute query
            records = []
            with eva_engine.connect() as connection:
                result = connection.execute(query, {
                    'org_id': self.integration.etani_organisation_id
                })
                # Convert to list of dicts
                for row in result:
                    record = {}
                    for column, value in row._mapping.items():
                        record[column] = value
                    records.append(record)

            self.logger.info(f"Retrieved {len(records)} existing records from {table_name}")
            return records
        except Exception as e:
            self.logger.error(f"Error getting existing records from {table_name}: {str(e)}")
            return []

    def _get_child_endpoint_config(self, endpoint: str) -> list:
        """Get child endpoint configuration from schema"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return []

            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    return ep.get('child_endpoint_config', [])

            return []
        except Exception as e:
            self.logger.warning(f"Error getting child endpoint config for {endpoint}: {e}")
            return []

    def _extract_from_url(self, base_url: str, detail_url: str, endpoint: str, stage_table: str, upsert_mode: bool = False, initial_write_mode: str = 'overwrite', parent_ids: Dict = None) -> int:
        """
        UNIFIED data extraction with centralized pagination handling
        
        Accepts base URL and builds all pagination parameters internally.
        This ensures consistent pagination handling for both regular and child endpoints.

        Args:
            base_url: Base URL (without pagination params) - will add pagination internally
            endpoint: Name of the endpoint
            stage_table: Stage table name
            upsert_mode: If True, builds incremental parameters for UPSERT mode
        """
        total_records = 0
        page = 1
        write_mode = initial_write_mode  # Use provided initial write mode instead of hardcoded 'overwrite'

        schema_config = self.integration._extract_schema_config()
        
        # First check if endpoint has its own pagination config
        endpoint_pagination_config = self._get_endpoint_pagination_config(endpoint)
        if endpoint_pagination_config:
            pagination_config = endpoint_pagination_config
            self.logger.info(f"📋 Using endpoint-specific pagination for {endpoint}")
        else:
            # Fallback to global pagination config from schema api_config.pagination
            pagination_config = schema_config.get('api_config', {}).get('pagination', {})
            if not pagination_config:
                # Fallback to old pagination_config key
                pagination_config = schema_config.get('pagination_config', {})
            self.logger.info(f"📋 Using global pagination config for {endpoint}")

        limit = pagination_config.get('default_limit', 100)
        
        # Check if pagination should be used for this endpoint
        use_pagination = self._should_use_pagination(endpoint)
        if not use_pagination:
            self.logger.info(f"🚫 Pagination disabled for {endpoint} - fetching single record")

        # Build UPSERT parameters if in UPSERT mode
        upsert_params = {}
        if upsert_mode:
            upsert_params = self.query_builder.build_upsert_params(endpoint)
            if upsert_params.get('_load_type') == 'incremental':
                self.logger.info(f"📈 UPSERT mode: Using incremental sync for {endpoint}")
                write_mode = 'append'  # Use append mode for incremental data
            else:
                self.logger.info(f"📥 UPSERT mode: Using full load for {endpoint} (no previous data)")

        # Check if we should limit test records (using settings from config.py)
        import config
        is_max_test = getattr(config, 'IS_MAX_TEST', False)
        max_test_records = getattr(config, 'MAX_TEST_RECORDS', 100) if is_max_test else float('inf')

        auth_type = self.integration.config.get('auth_type', 'api_key')
        while True:
            # Initialize params with UPSERT parameters first
            params = {}
            api_params = {}  # Initialize api_params to avoid UnboundLocalError
            if upsert_params:
                # Filter out internal parameters (starting with _)
                api_params = {k: v for k, v in upsert_params.items() if not k.startswith('_')}
                params.update(api_params)
                if api_params:
                    self.logger.debug(f"Adding UPSERT params to API call: {api_params}")

            # Add required parameters from schema (key=value format)
            # Skip required params that conflict with UPSERT time parameters
            required_params = self.query_builder.build_required_params(endpoint)
            if required_params:
                # Filter out required params that conflict with UPSERT params
                filtered_required_params = {}
                conflicts_found = []

                for key, value in required_params.items():
                    if key in api_params:
                        # UPSERT param takes priority over required param
                        conflicts_found.append(f"{key} (UPSERT: {api_params[key]} vs Required: {value})")
                    else:
                        filtered_required_params[key] = value

                if conflicts_found:
                    self.logger.info(f"UPSERT params override required params: {', '.join(conflicts_found)}")

                if filtered_required_params:
                    params.update(filtered_required_params)
                    self.logger.debug(f"Adding required params to API call: {filtered_required_params}")
                else:
                    self.logger.debug("All required params were overridden by UPSERT params")

            # Check endpoint method and request body configuration
            endpoint_method, request_body_config = self._get_endpoint_method_and_request_body(endpoint)
            # Add parent IDs for child endpoints (for POST request body building)
            if endpoint_method == "POST" and parent_ids:
                params.update(parent_ids)
                self.logger.debug(f"Adding parent IDs to API params for child endpoint: {parent_ids}")
            # Handle different pagination types
            if use_pagination and pagination_config.get('type') == 'link_header_based':
                # Shopify-style Link header pagination
                if page == 1:
                    # First request: add limit param only
                    pagination_params = self.query_builder.build_pagination_params(pagination_config, page, limit)
                    params.update(pagination_params)
                    current_url = self._build_paginated_url(base_url, params)
                    data = self.api_client._call_api(endpoint, {}, url=current_url, detail_url=detail_url)
                else:
                    # Subsequent requests: use next URL from Link header
                    if hasattr(self.api_client, '_last_pagination_info') and self.api_client._last_pagination_info.get('next_url'):
                        next_url = self.api_client._last_pagination_info['next_url']
                        self.logger.debug(f"Using next URL from Link header: {next_url}")
                        data = self.api_client._call_api(endpoint, {}, url=next_url)
                    else:
                        # No next URL available, pagination complete
                        self.logger.info(f"ℹ️ No next URL in Link header for {endpoint} - pagination complete")
                        break
            else:
                # Standard pagination (offset, page, limit_only, etc.)
                if use_pagination:
                    pagination_params = self.query_builder.build_pagination_params(pagination_config, page, limit)
                    params.update(pagination_params)

                # Handle POST requests with request body or custom_request differently
                if auth_type == 'custom_request' or (endpoint_method == 'POST' and request_body_config):
                    # For custom_request or POST with body: pass params and request_body to _call_api for body inclusion
                    # URL should only contain base_url without pagination params
                    data = self.api_client._call_api(endpoint, params, url=base_url, detail_url=detail_url,
                                                   request_body_config=request_body_config)
                else:
                    # For standard GET requests: build complete URL with all params
                    current_url = self._build_paginated_url(base_url, params)
                    detail_url = self._build_paginated_url(detail_url, required_params)
                    data = self.api_client._call_api(endpoint, {}, url=current_url, detail_url=detail_url)
            # Check if data is empty (handle both DataFrame and dict formats)
            if isinstance(data, dict):
                # For dict format, check if main endpoint data is empty
                main_data = data.get(endpoint, pd.DataFrame())
                if main_data.empty:
                    if page == 1:
                        self.integration.logger.info(f"ℹ️ No data returned for endpoint {endpoint}")
                    else:
                        self.integration.logger.info(f"ℹ️ No more data for endpoint {endpoint} at page {page} - pagination complete")
                    break
            else:
                if data is None or isinstance(data, pd.DataFrame) and data.empty:
                    # Log when no data is returned from URL
                    if page == 1:
                        self.integration.logger.info(f"ℹ️ No data returned for endpoint {endpoint} from URL")
                    else:
                        self.integration.logger.info(
                            f"ℹ️ No more data for endpoint {endpoint} at page {page} - pagination complete")
                    break

            # Process and save all endpoints data (main + nested)
            if isinstance(data, dict):
                # New format: dict of endpoints
                all_endpoints_data = data
            else:
                # Legacy format: single DataFrame for main endpoint
                all_endpoints_data = {endpoint: data}

            # Process each endpoint in the collection
            for current_endpoint, current_data in all_endpoints_data.items():
                # Process data using integration's transformer
                processed_data = self.integration.transformer._add_audit_columns(current_data, current_endpoint)

                # Add parent IDs if provided (for child endpoints)
                if parent_ids:
                    processed_data = self._add_parent_ids_to_dataframe(processed_data, parent_ids, current_endpoint)

                # Apply column filtering to match stage table schema
                current_stage_table = f"{self.integration.table_prefix_eva}{current_endpoint.lower()}stage"
                filtered_data = self.integration.transformer._filter_dataframe_columns(processed_data, current_endpoint, current_stage_table)

                if not filtered_data.empty:
                    # Log the URL being processed (only for main endpoint)
                    if current_endpoint == endpoint:
                        if auth_type == 'custom_request' or (endpoint_method == 'POST' and request_body_config):
                            print(f"{current_endpoint} (Page {page}) - Processing URL: {base_url} (with body params: {params})")
                        else:
                            print(f"{current_endpoint} (Page {page}) - Processing URL: {current_url}")
                    else:
                        print(f"{current_endpoint} (Nested from {endpoint}, Page {page})")
                        
                    # Pass page info to LoadToEvaStageTable for better logging
                    endpoint_with_page = f"{current_endpoint} (Page {page})"

                    if upsert_mode:
                        # Check if endpoint has primary key for UPSERT
                        primary_key = self._get_primary_key_from_schema(current_endpoint)

                        if primary_key:
                            # TRUE UPSERT: Update existing + Insert new at stage level
                            LoadToEvaStageTableUpsert(filtered_data, endpoint_with_page, primary_key, current_stage_table, self.error_list)
                            self.logger.info(f"📈 UPSERT: Updated/inserted {len(filtered_data)} records for {current_endpoint} using primary key: {primary_key}")
                        else:
                            # NO PRIMARY KEY: Fallback to append mode
                            LoadToEvaStageTable(filtered_data, endpoint_with_page, write_mode, current_stage_table, self.error_list)
                            self.logger.info(f"📥 UPSERT: No primary key found for {current_endpoint}, using append mode")
                            write_mode = 'append'  # Ensure subsequent pages append
                    else:
                        # INSERT mode: Normal load
                        LoadToEvaStageTable(filtered_data, endpoint_with_page, write_mode, current_stage_table, self.error_list)
                        write_mode = 'append'  # Switch to append after first page
                    
                    # Log InProgress after loading data to stage (only for main endpoint)
                    if current_endpoint == endpoint:
                        total_records += len(filtered_data)
                        load_type = 'UPSERT' if upsert_mode else 'Full'
                        self.integration.log_endpoint_step(current_endpoint, 'InProgress', load_type, stage_count=total_records)
                else:
                    self.logger.warning(f"No valid data after filtering for {current_endpoint}")

            # Stop if we've reached test limit (based on config settings)
            if is_max_test and total_records >= max_test_records:
                self.logger.info(f"⚠️ TEST LIMIT REACHED: Stopping at {total_records} records for {endpoint} (MAX_TEST_RECORDS={max_test_records})")
                break
            # Check if we should continue pagination
            if not use_pagination:
                # No pagination - single request only
                break
            elif pagination_config.get('type') == 'link_header_based':
                # For Link header pagination, continue based on availability of next URL
                if not (hasattr(self.api_client, '_last_pagination_info') and
                        self.api_client._last_pagination_info.get('has_more', False)):
                    self.logger.info(f"📄 Pagination complete: No more pages available from Link header for {endpoint}")
                    break
            else:
                # Standard pagination: check record count against limit
                main_data = all_endpoints_data.get(endpoint, pd.DataFrame())
                if len(main_data) < limit:
                    # Pagination enabled but got less data than limit - done
                    self.logger.info(f"📄 Pagination complete: Got {len(main_data)} records (< {limit} limit) for {endpoint}")
                    break
            page += 1

        return total_records

    def _build_paginated_url(self, base_url: str, params: Dict) -> str:
        """Build complete URL with pagination parameters"""
        import urllib.parse

        if not base_url:
            return None

        if not params:
            return base_url

        # Get global pagination config
        schema_config = self.integration._extract_schema_config()
        global_pagination = schema_config.get('pagination_config', {})

        # Check if this is path_page pagination
        if global_pagination.get('type') == 'path_page':
            page_param = global_pagination.get('page_param', 'pageNumber')

            # Check if page number is in params
            if page_param in params:
                page_number = params[page_param]
                # Remove page number from query params since it goes in URL path
                params_copy = params.copy()
                del params_copy[page_param]

                # Insert page number into URL path
                # For Unleashed: /Companies/1?pageSize=10
                if base_url.endswith('/'):
                    base_url = f"{base_url}{page_number}"
                else:
                    base_url = f"{base_url}/{page_number}"

                # Continue with remaining params (like pageSize)
                params = params_copy

        # Add API key parameter for api_key_param auth type
        auth_type = self.integration.config.get('auth_type')
        if auth_type == 'api_key_param':
            api_key = self._get_api_key_from_config()
            param_name = self._get_api_key_param_name()
            if api_key:
                params[param_name] = api_key
                self.logger.debug(f"Added API key parameter to URL: {param_name}={api_key}")

        # Check if base_url already has query parameters
        if '?' in base_url:
            # Append to existing query string
            separator = '&'
        else:
            # Start new query string
            separator = '?'

        # Handle parameters with special characters (like $ symbols) to avoid over-encoding
        special_char_params = [key for key in params.keys() if key.startswith('$') or '$' in key]
        if special_char_params:
            # Build query string manually to preserve special characters like $
            query_parts = []
            for key, value in params.items():
                query_parts.append(f"{key}={urllib.parse.quote_plus(str(value))}")
            query_string = '&'.join(query_parts)
        else:
            # Use standard encoding for regular parameters
            query_string = urllib.parse.urlencode(params)

        return f"{base_url}{separator}{query_string}"

    def _get_endpoint_pagination_config(self, endpoint: str) -> Dict[str, Any]:
        """Get endpoint-specific pagination config if it exists"""
        try:
            # Get endpoint schema
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return {}
            
            # Find endpoint in schema
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    api_details = ep.get('api_details', {})
                    pagination_config = api_details.get('pagination', {})
                    if pagination_config:
                        self.logger.debug(f"Found endpoint-specific pagination config for {endpoint}: {pagination_config}")
                        return pagination_config
            
            return {}
            
        except Exception as e:
            self.logger.warning(f"Error getting endpoint pagination config for {endpoint}: {e}")
            return {}

    def _get_endpoint_method_and_request_body(self, endpoint: str) -> tuple:
        """Get endpoint HTTP method and request body configuration from schema"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return 'GET', None

            for ep in schema['endpoints']:
                if ep.get('name', '').lower() == endpoint.lower():
                    api_details = ep.get('api_details', {})
                    method = api_details.get('method', 'GET').upper()
                    request_body = api_details.get('request_body', None)
                    return method, request_body

            return 'GET', None

        except Exception as e:
            self.logger.warning(f"Error getting endpoint method for {endpoint}: {e}")
            return 'GET', None

    def _should_use_pagination(self, endpoint: str) -> bool:
        """Check if pagination should be used for this endpoint"""
        try:
            # Get endpoint schema
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return True  # Default to using pagination
            
            # Find endpoint in schema
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    # Check use_pagination flag - default True if not specified
                    return ep.get('use_pagination', True)
            
            # Endpoint not found in schema - default to pagination
            return True
            
        except Exception as e:
            self.logger.warning(f"Error checking pagination setting for {endpoint}: {e}")
            return True  # Default to pagination on error

    def _add_parent_ids_to_dataframe(self, df, parent_ids, endpoint):
        """
        Add parent IDs to DataFrame based on map_id_to_column configuration

        Args:
            df: DataFrame to add parent IDs to
            parent_ids: Dictionary of parent ID values (from current_combination)
            endpoint: Current endpoint name

        Returns:
            DataFrame with parent IDs added
        """
        try:
            # Skip if no parent_ids or empty DataFrame
            if not parent_ids or df.empty:
                return df

            # Get child_endpoint_config from schema
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return df

            # Find endpoint config
            endpoint_config = None
            for ep in schema['endpoints']:
                if ep.get('name') == endpoint:
                    endpoint_config = ep
                    break

            if not endpoint_config:
                self.logger.debug(f"No endpoint config found for {endpoint} when adding parent IDs")
                return df

            # Get child_endpoint_config if exists
            child_config = endpoint_config.get('child_endpoint_config', [])
            if not child_config:
                self.logger.debug(f"No child_endpoint_config found for {endpoint}")
                return df

            # Process each parent ID from current_combination
            added_columns = []
            for param_name, param_value in parent_ids.items():
                # Find matching config for this param
                for config in child_config:
                    if config.get('parent_id_source') == param_name:
                        # Found matching config - get column name to map to
                        db_column = config.get('map_id_to_column')
                        if db_column:
                            # Add column with parent ID value
                            df[db_column] = param_value
                            self.logger.info(f"Added parent ID column {db_column}={param_value} to {endpoint} DataFrame")
                            added_columns.append(db_column)
                            break

            if added_columns:
                self.logger.info(f"Added parent ID columns to {endpoint}: {', '.join(added_columns)}")
            return df

        except Exception as e:
            self.logger.error(f"Error adding parent IDs to DataFrame for {endpoint}: {e}")
            return df

    def _get_primary_key_from_schema(self, endpoint: str) -> str:
        """
        Get primary key field name from main schema

        Args:
            endpoint: Name of the endpoint

        Returns:
            Primary key field name or None if not found
        """
        try:
            # Read from main schema only
            schema = self.integration._load_schema()
            if schema and 'endpoints' in schema:
                for ep in schema['endpoints']:
                    if ep.get('name') == endpoint:
                        fields = ep.get('fields', [])
                        for field in fields:
                            if field.get('is_primary_key', False):
                                primary_key = field.get('db_column') or field.get('api_name') or field.get('name')
                                self.logger.debug(f"Found primary key for {endpoint} in main schema: {primary_key}")
                                return primary_key

            self.logger.debug(f"No primary key found for {endpoint}")
            return None

        except Exception as e:
            self.logger.warning(f"Error getting primary key for {endpoint}: {e}")
            return None

    def _get_json_fields_from_endpoint_schema(self, endpoint: str) -> List[str]:
        """
        Get list of JSON and UNDEFINED field names from endpoint schema
        
        Returns:
            List of field names that have data_type="JSON" or "UNDEFINED"
        """
        try:
            # Use common utility function from Utils to get from main schema file
            schema = self.integration._load_schema()
            if schema:
                # Get JSON fields
                json_fields = Utils.get_json_fields_from_schema(schema, endpoint)
                json_field_names = [field['api_name'] for field in json_fields]
                
                # Also get UNDEFINED fields that need type resolution
                undefined_field_names = []
                for ep in schema.get('endpoints', []):
                    if ep.get('name') == endpoint:
                        for field in ep.get('fields', []):
                            if field.get('data_type') == 'UNDEFINED':
                                undefined_field_names.append(field.get('api_name'))
                        break
                
                # Combine both types
                all_field_names = json_field_names + undefined_field_names
                self.logger.debug(f"Found {len(json_field_names)} JSON + {len(undefined_field_names)} UNDEFINED fields for {endpoint}: {all_field_names}")
                return all_field_names
            
            return []
            
        except Exception as e:
            self.logger.warning(f"Error getting JSON/UNDEFINED fields for {endpoint}: {e}")
            return []

    def _sample_from_url_for_json_fields(self, base_url: str, endpoint: str, json_fields: List[str]) -> list:
        """
        Sample data from URL but stop early when all JSON fields are filled
        
        Args:
            base_url: Base URL to sample from
            endpoint: Name of the endpoint
            json_fields: List of JSON field names to collect
            
        Returns:
            List of sample records (stops when all JSON fields found)
        """
        sample_data = []
        page = 1
        max_sample_pages = 5  # Increased limit since we might need more records to find all JSON fields
        filled_json_fields = set()  # Track which JSON fields we've found
        
        schema_config = self.integration._extract_schema_config()
        
        # Get pagination config (same logic as _extract_from_url)
        endpoint_pagination_config = self._get_endpoint_pagination_config(endpoint)
        if endpoint_pagination_config:
            pagination_config = endpoint_pagination_config
        else:
            pagination_config = schema_config.get('api_config', {}).get('pagination', {})
            if not pagination_config:
                pagination_config = schema_config.get('pagination_config', {})
        
        limit = pagination_config.get('default_limit', 100)
        use_pagination = self._should_use_pagination(endpoint)
        
        while True:
            # Build parameters (no UPSERT params for sampling)
            params = {}
            
            # Add required parameters from schema
            required_params = self.query_builder.build_required_params(endpoint)
            if required_params:
                params.update(required_params)
            
            # Add pagination params only if pagination is enabled
            if use_pagination:
                pagination_params = self.query_builder.build_pagination_params(pagination_config, page, limit)
                params.update(pagination_params)
            
            # Make API call
            auth_type = self.integration.config.get('auth_type', 'api_key')
            if auth_type == 'custom_request':
                data = self.api_client._call_api(endpoint, params, url=base_url)
            else:
                current_url = self._build_paginated_url(base_url, params)
                data = self.api_client._call_api(endpoint, {}, url=current_url)
            
            # Check if data is empty - handle both DataFrame and dict/list
            if data is None:
                self.logger.info(f"No data returned for endpoint {endpoint} at page {page}")
                break
            elif hasattr(data, 'empty') and data.empty:
                self.logger.info(f"Empty DataFrame for endpoint {endpoint} at page {page}")
                break
            elif isinstance(data, (list, dict)) and len(data) == 0:
                self.logger.info(f"Empty data for endpoint {endpoint} at page {page}")
                break
            
            # Convert DataFrame to records for analysis
            if hasattr(data[endpoint], 'to_dict'):
                page_records = data[endpoint].to_dict('records')
            else:
                page_records = data[endpoint] if isinstance(data[endpoint], list) else [data[endpoint]]
            
            # Extract only JSON field values from records using shared utility
            json_samples = Utils.extract_json_field_samples(
                page_records, json_fields, filled_json_fields, endpoint, self.logger
            )
            
            # Add collected JSON samples to result (only if new fields found)
            if json_samples:
                sample_data.append({endpoint: json_samples})
            
            # Early exit if all JSON fields are found
            if len(filled_json_fields) >= len(json_fields):
                self.logger.info(f"All {len(json_fields)} JSON fields found for {endpoint}, stopping early at page {page}")
                break
            
            self.logger.info(f"Page {page}: Found {len(filled_json_fields)}/{len(json_fields)} JSON fields for {endpoint}")
            
            # Stop conditions
            if not use_pagination:
                break
            elif len(data) < limit:
                break
            elif page >= max_sample_pages:
                self.logger.info(f"Reached max sample pages ({max_sample_pages}) for {endpoint}")
                break
            
            page += 1
        
        self.logger.info(f"Sampling complete for {endpoint}: found {len(filled_json_fields)}/{len(json_fields)} JSON fields in {len(sample_data)} records")
        return sample_data

    def _merge_json_fields_to_single_record(self, raw_sample_data: list, json_fields: List[str], endpoint: str) -> Dict:
        """
        Merge JSON fields from multiple records into single comprehensive record
        
        Takes field A from record 1, field B from record 2, etc. to create complete sample
        
        Args:
            raw_sample_data: List of sample records
            json_fields: List of JSON field names to merge
            endpoint: Endpoint name for logging
            
        Returns:
            Single merged record with all available JSON fields
        """
        merged_record = {}
        
        if not raw_sample_data or not json_fields:
            return merged_record
        
        # Track which JSON fields we've successfully merged
        found_fields = set()
        
        for record in raw_sample_data:
            if not isinstance(record, dict):
                continue
            
            # Handle new format: {endpoint: {json_field: sample_value}}
            for endpoint_name, json_data in record.items():
                if not isinstance(json_data, dict):
                    continue
                    
                # Extract JSON field values
                for json_field in json_fields:
                    if json_field in found_fields:
                        continue  # Already found this field
                        
                    if json_field in json_data:
                        field_value = json_data[json_field]
                        # Only use non-null, non-empty values
                        if field_value is not None and field_value != "" and field_value != {}:
                            merged_record[json_field] = field_value
                            found_fields.add(json_field)
                            self.logger.debug(f"Merged JSON field '{json_field}' for {endpoint}")
            
            # Early exit if all JSON fields found
            if len(found_fields) >= len(json_fields):
                break
        
        self.logger.info(f"Merged {len(found_fields)}/{len(json_fields)} JSON fields for {endpoint}")
        return merged_record

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

            # Fallback to environment variable
            import os
            api_key = os.getenv(env_var)
            if api_key:
                self.logger.debug(f"Got API key from environment variable '{env_var}'")
                return api_key

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

