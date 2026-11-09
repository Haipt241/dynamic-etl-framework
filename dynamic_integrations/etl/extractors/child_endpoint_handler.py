"""
Child Endpoint Handler - Manages hierarchical data extraction with multi-threading support
"""

import re
import logging
from typing import Dict, List
from sqlalchemy import text

from dynamic_integrations.singleton_manager import SingletonBase
from dynamic_integrations.etl.extractors.thread_pool_manager import (
    ThreadPoolManager, calculate_optimal_workers
)
from sql_helper import eva_engine, get_max_etl_update_time

# Global variable for custom time-from parameter
CUSTOM_TIME_FROM = None

def set_custom_time_from(timestamp: str):
    """Set custom time-from parameter for UPSERT"""
    global CUSTOM_TIME_FROM
    CUSTOM_TIME_FROM = timestamp

def clear_custom_time_from():
    """Clear custom time-from parameter after UPSERT completes"""
    global CUSTOM_TIME_FROM
    CUSTOM_TIME_FROM = None


class ChildEndpointHandler(SingletonBase):
    """Handles child endpoints that require parent data"""
    
    def __init__(self, integration_instance):
        super().__init__()
        if hasattr(self, '_initialized'):
            # For singleton, update integration-specific attributes
            self.integration = integration_instance
            self.logger = logging.getLogger(f"ChildEndpointHandler.{integration_instance.integration_name}")
            return
        self._initialized = True

        self.integration = integration_instance
        self.logger = logging.getLogger(f"ChildEndpointHandler.{integration_instance.integration_name}")

        # Threading will be handled by ThreadPoolManager - no need for WriteCoordinator
        self.logger.info(f"🚀 ChildEndpointHandler initialized with threading support")

    def _get_thread_pool_manager(self, endpoint: str) -> ThreadPoolManager:
        """Get or create ThreadPoolManager for specific endpoint"""
        try:
            schema = self.integration._load_schema()
            api_config = schema.get('api_config', {})

            # Get rate limiting config from authentication section (same as _setup_threading_components)
            auth_config = api_config.get('authentication', {})
            rate_config = auth_config.get('rate_limiting', {})

            rate_limit = rate_config.get('requests_per_minute', 60) if rate_config else 60
            safety_margin = 0.8

            # Calculate optimal workers based on rate limit
            optimal_workers = calculate_optimal_workers(rate_limit, safety_margin, max_workers=100)

            # Create manager with endpoint-specific logger
            logger_name = f"{self.integration.integration_name}.{endpoint}.ThreadPoolManager"

            return ThreadPoolManager(
                max_workers=optimal_workers,
                rate_limit_per_minute=rate_limit,
                safety_margin=safety_margin,
                logger_name=logger_name
            )

        except Exception as e:
            self.logger.error(f"Error creating ThreadPoolManager for {endpoint}: {e}")
            # Return basic manager as fallback
            return ThreadPoolManager(max_workers=1, rate_limit_per_minute=60)
    
    def extract_child_data(self, endpoint: str, stage_table: str, upsert_mode: bool = False, upsert_params: Dict = None) -> int:
        """Main method to extract data for child endpoints"""
        try:
            # Get child endpoint configuration
            child_config = self._get_child_endpoint_config(endpoint)
            if not child_config:
                self.logger.warning(f"No child configuration found for {endpoint}")
                return 0

            # Check if recursive or not based on skip_recursive_query flag
            schema = self.integration._load_schema()
            recursive = True

            # Look for skip_recursive_query flag in endpoint config
            for ep in schema.get('endpoints', []):
                if ep.get('name', '').lower() == endpoint.lower():
                    if ep.get('skip_recursive_query') == True:
                        recursive = False
                        self.logger.info(f"Using non-recursive mode for {endpoint} based on skip_recursive_query flag")
                    break

            # Parse dependency chain using child config instead of URL parsing
            url_path = self._get_endpoint_url_path(endpoint)

            if not recursive:
                return self._process_direct_query(endpoint, stage_table, child_config, upsert_mode, upsert_params)
            else:
                # Normal recursive mode
                dependency_chain = self._parse_dependency_chain(url_path, endpoint, child_config)
                # Process combinations using streaming approach
                return self._process_combinations_streaming(dependency_chain, endpoint, stage_table, upsert_mode, child_config, upsert_params)

        except Exception as e:
            self.logger.error(f"Error extracting child endpoint data for {endpoint}: {e}")
            return 0
    
    def _get_child_endpoint_config(self, endpoint: str) -> List[Dict]:
        """Get child endpoint configuration from schema"""
        try:
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return []
            
            for ep in schema['endpoints']:
                if ep.get('name', '').lower() == endpoint.lower():
                    return ep.get('child_endpoint_config', [])
            
            return []
        except Exception as e:
            self.logger.error(f"Error getting child config for {endpoint}: {e}")
            return []
    
    def _get_endpoint_url_path(self, endpoint: str) -> str:
        """Get URL path for endpoint from schema"""
        try:
            schema = self.integration._extract_schema_config()
            endpoints = schema.get('endpoints_config', [])

            for ep in endpoints:
                if ep.get('name', '').lower() == endpoint.lower():
                    api_details = ep.get('api_details', {})
                    return api_details.get('path', '')

            self.logger.warning(f"No URL path found for endpoint: {endpoint}")
            return ''
        except Exception as e:
            self.logger.error(f"Error getting URL path for {endpoint}: {e}")
            return ''
    
    def _parse_dependency_chain(self, url_path: str, endpoint_name: str = None, child_config: List[Dict] = None) -> List[Dict]:
        """
        Parse URL to extract dependency chain generically
        URL: /quotes/{quote_id}/sections/{section_id}/costCenters
        Result: [
            {'level': 0, 'entity': 'quotes', 'id_param': 'quote_id', 'table': 'quotes', 'parent_key': None},
            {'level': 1, 'entity': 'sections', 'id_param': 'section_id', 'table': 'quotesections', 'parent_key': 'QuoteID'},
            {'level': 2, 'entity': 'quotesectioncostcenters', 'id_param': None, 'table': None}  # Final endpoint
        ]
        """
        try:
            # Find all /{entity}/{id_param} patterns in path
            path_pattern = r'/([^/]+)/\{([^}]+)\}'
            path_matches = re.findall(path_pattern, url_path)

            # Check if any child_config has is_query_pattern flag set to True
            has_query_pattern = False
            if child_config:
                for config in child_config:
                    if config.get('is_query_pattern', False):
                        has_query_pattern = True
                        break

            query_matches = []
            if has_query_pattern:
                # Only find query parameter placeholders if explicitly enabled
                query_pattern = r'[?&]([^=]+)=\{([^}]+)\}'
                query_matches = re.findall(query_pattern, url_path)
                self.logger.debug(f"Query pattern enabled for {endpoint_name}, found query matches: {query_matches}")

            # Combine both types of matches
            # Path matches: [('product', 'product_id')] from /product/{product_id}
            # Query matches: [('ProductID', 'product_id')] from ?ProductID={product_id}
            matches = path_matches + query_matches
            
            chain = []
            for i, (entity, id_param) in enumerate(matches):
                # Map URL path entity to actual endpoint name to avoid snake_case issues
                resolved_entity = self._resolve_url_entity_to_endpoint_name(entity, url_path)
                
                # Use configured values from child_config instead of auto-generating
                if child_config and len(child_config) > 0 and i < len(child_config):
                    config = child_config[i]  # Use correct config for this level
                    table_name = config.get('parent_table', resolved_entity.lower())
                    parent_key = config.get('parent_id_column', 'ID') if i > 0 else None

                    # Use parent_id_source for URL placeholder instead of id_param
                    url_param = config.get('parent_id_source', id_param)
                else:
                    # Fallback to auto-generation if no config
                    table_name = self._resolve_table_name(resolved_entity.lower(), i, matches)
                    parent_key = self._resolve_parent_key(resolved_entity.lower(), i, matches) if i > 0 else None
                    url_param = id_param

                level_info = {
                    'level': i,
                    'entity': resolved_entity.lower(),
                    'id_param': url_param,  # Use parent_id_source for placeholder
                    'table': table_name,
                    'parent_key': parent_key
                }
                chain.append(level_info)
                self.logger.debug(f"Parsed level {i}: {level_info}")
            
            # Add final endpoint
            if endpoint_name:
                final_entity = self._resolve_final_entity_name(url_path, matches, endpoint_name)
            else:
                final_entity = url_path.split('/')[-1].lower()
            
            chain.append({
                'level': len(matches),
                'entity': final_entity,
                'id_param': None,
                'table': None  # This is API call target
            })
            
            return chain
            
        except Exception as e:
            self.logger.error(f"Error parsing dependency chain for {url_path}: {e}")
            return []
    
    def _resolve_url_entity_to_endpoint_name(self, url_entity: str, full_url_path: str = None) -> str:
        """
        Map URL path entity to actual endpoint name to handle naming variations
        """
        try:
            # Load schema to get actual endpoint names
            schema = self.integration._load_schema()
            if not schema or 'endpoints' not in schema:
                return url_entity
            
            available_endpoints = [ep.get('name', '') for ep in schema.get('endpoints', [])]
            
            # Direct match first (case-insensitive)
            for endpoint_name in available_endpoints:
                if endpoint_name.lower() == url_entity.lower():
                    return endpoint_name
            
            # Try pattern matching with the full URL path
            if full_url_path:
                for ep in schema.get('endpoints', []):
                    ep_name = ep.get('name', '')
                    api_details = ep.get('api_details', {})
                    ep_path = api_details.get('path', '')
                    
                    if self._url_patterns_match(full_url_path, ep_path):
                        # Extract the entity part that matches our url_entity
                        if url_entity.lower() in ep_path.lower():
                            return ep_name
            
            # Fallback: try common transformations
            transformations = [
                url_entity,  # As-is
                url_entity.capitalize(),  # Capitalize first letter
                url_entity.title(),  # Title case
                url_entity.lower(),  # Lowercase
                url_entity.upper(),  # Uppercase
            ]
            
            for transform in transformations:
                for endpoint_name in available_endpoints:
                    if endpoint_name.lower() == transform.lower():
                        return endpoint_name
            
            # If no match found, return original
            self.logger.debug(f"Could not resolve URL entity '{url_entity}' to endpoint name. Available: {available_endpoints}")
            return url_entity
            
        except Exception as e:
            self.logger.error(f"Error resolving URL entity {url_entity}: {e}")
            return url_entity
    
    @staticmethod
    def _url_patterns_match(url_path: str, endpoint_path: str) -> bool:
        """Check if URL patterns match considering placeholders"""
        try:
            # Remove placeholders for comparison
            url_clean = re.sub(r'/\{[^}]+\}', '/{}', url_path)
            endpoint_clean = re.sub(r'/\{[^}]+\}', '/{}', endpoint_path)
            
            return url_clean == endpoint_clean
        except Exception:
            return False
    
    def _resolve_final_entity_name(self, url_path: str, matches: List, endpoint_name: str) -> str:
        """Resolve the final entity name for the target endpoint
        
        Always use endpoint name to ensure consistency with schema naming
        EmployeeTimesheets -> employeetimesheets (not employeestimesheets)
        """
        try:
            # Convert endpoint name to lowercase table format
            endpoint_lower = endpoint_name.lower()
            
            # Always use endpoint name instead of URL path to avoid naming issues
            # This ensures consistent table naming: EmployeeTimesheets -> employeetimesheets
            return endpoint_lower
                
        except Exception as e:
            self.logger.error(f"Error resolving final entity name: {e}")
            return endpoint_name.lower() if endpoint_name else "unknown"
    
    def _resolve_table_name(self, entity: str, level: int, all_matches: List) -> str:
        """Resolve table name for the entity at given level"""
        try:
            if level == 0:
                # Root level - simple entity name
                return entity
            else:
                # Child level - compound name from all parent levels
                parent_entities = [match[0] for match in all_matches[:level]]
                parent_entities.append(entity)
                return ''.join(parent_entities).lower()
                
        except Exception as e:
            self.logger.error(f"Error resolving table name for {entity} at level {level}: {e}")
            return entity
    
    def _resolve_parent_key(self, entity: str, level: int, all_matches: List) -> str:
        """Resolve parent key name for the entity"""
        try:
            if level == 0:
                return None
            
            # Get parent entity from previous level
            parent_entity = all_matches[level - 1][0]
            
            # Common parent key patterns
            possible_keys = [
                f"{parent_entity.title()}ID",
                f"{parent_entity.lower()}_id",
                f"{parent_entity}Id",
                "ParentID",
                "Parent_ID"
            ]
            
            return possible_keys[0]  # Default to first pattern
            
        except Exception as e:
            self.logger.error(f"Error resolving parent key for {entity}: {e}")
            return "ParentID"
    
    def _process_combinations_streaming(self, dependency_chain: List[Dict], endpoint: str, stage_table: str, upsert_mode: bool = False, child_config: List[Dict] = None, upsert_params: Dict = None) -> int:
        """Process parent-child combinations using streaming approach"""
        if not dependency_chain:
            return 0
        
        total_records = 0
        combination_count = 0
        
        try:
            def process_level_recursive(current_level: int, current_combination: Dict):
                """Recursively process each level of the dependency chain"""
                nonlocal total_records, combination_count
                
                if current_level >= len(dependency_chain) - 1:
                    # Final level - call main extraction flow
                    try:
                        combination_count += 1
                        url_path = self._build_final_api_url(dependency_chain, current_combination)
                        
                        # ⚠️ FIX: Use persistent write_mode to avoid truncating data from previous combinations
                        # First combination: overwrite, subsequent: append
                        current_write_mode = 'overwrite' if combination_count == 1 else 'append'
                        
                        # Call main extraction flow with controlled write_mode
                        from dynamic_integrations.etl.data_extraction import DataExtractor
                        data_extractor = DataExtractor(self.integration)
                        # Pass current_combination as parent_ids so they can be added to the DataFrame
                        records_in_batch = data_extractor._extract_from_url(
                            url_path,
                            '',
                            endpoint,
                            stage_table,
                            upsert_mode,
                            initial_write_mode=current_write_mode,
                            parent_ids=current_combination  # Pass parent IDs
                        )
                        
                        total_records += records_in_batch
                        self.logger.info(f"📦 Combination {combination_count} ({'overwrite' if combination_count == 1 else 'append'}): {records_in_batch} records")
                            
                    except Exception as e:
                        error_str = str(e)
                        if "400 Client Error" in error_str or "404 Client Error" in error_str:
                            # Client errors (4xx) - log as warning with full details
                            self.logger.warning(f"API response warning for combination {current_combination}: {error_str}")
                        elif "500 Server Error" in error_str or "503 Server Error" in error_str:
                            # Server errors (5xx) - log as error
                            self.logger.error(f"Server error for combination {current_combination}: {e}")
                        else:
                            # Other errors - log as error
                            self.logger.error(f"Error processing combination {current_combination}: {e}")
                    
                    return False
                
                # Get current dependency
                current_dep = dependency_chain[current_level]
                parent_table = current_dep['table']
                
                # Handle parent ID processing with pagination for root level
                if current_level == 0:
                    # Root level - use pagination to process in batches
                    page = 1
                    batch_size = 1000
                    total_processed = 0
                    
                    while True:
                        parent_ids = self._get_root_parent_ids(parent_table, child_config, upsert_params, page, batch_size)
                        
                        if not parent_ids:
                            if page == 1:
                                self.logger.warning(f"No parent IDs found in {parent_table}, skipping API calls for level {current_level}")
                                return False
                            else:
                                # No more pages, break the pagination loop
                                self.logger.info(f"📋 Finished processing all pages for {parent_table}. Total processed: {total_processed}")
                                break
                        
                        self.logger.info(f"🔍 Processing page {page}: {len(parent_ids)} parent IDs from {parent_table}")
                        
                        # Always process parent IDs with threading
                        print(f"🚀 Processing {len(parent_ids)} (page {page}) parent IDs with threading (level {current_level})")

                        # Get thread pool manager
                        thread_manager = self._get_thread_pool_manager(endpoint)

                        # Define processor for single parent ID
                        def process_single_parent_id(parent_id):
                            """Process single parent ID - no coordination needed"""
                            try:
                                new_combination = current_combination.copy()
                                new_combination[current_dep['id_param']] = parent_id

                                # Direct processing - no write coordination needed
                                return process_level_recursive(current_level + 1, new_combination)

                            except Exception as e:
                                self.logger.error(f"Error in threaded processing for parent {parent_id}: {e}")
                                return False

                        # Execute with threading
                        results = thread_manager.threaded_execution(parent_ids, process_single_parent_id)
                        total_processed += len(parent_ids)

                        # Check if any result indicates stop
                        if any(filter(None, results)):
                            return True
                        
                        # Move to next page
                        page += 1
                        
                        # If we got less than batch_size, this was the last page
                        if len(parent_ids) < batch_size:
                            self.logger.info(f"📋 Reached last page {page-1} for {parent_table}. Total processed: {total_processed}")
                            break
                
                else:
                    # Child level - use existing logic without pagination
                    parent_key = current_dep['parent_key']
                    parent_id = current_combination.get(dependency_chain[current_level - 1]['id_param'])
                    parent_ids = self._get_child_ids(parent_table, parent_key, parent_id, child_config)
                    
                    # Early exit if no parent IDs found
                    if not parent_ids:
                        self.logger.debug(f"No child IDs found in {parent_table} for parent {parent_id}, skipping API calls")
                        return False
                    
                    self.logger.info(f"🔍 Found {len(parent_ids)} child IDs in {parent_table} for parent {parent_id}")
                    
                    # Process each child ID
                    for child_id in parent_ids:
                        try:
                            new_combination = current_combination.copy()
                            new_combination[current_dep['id_param']] = child_id
                            
                            # Recurse to next level
                            should_stop = process_level_recursive(current_level + 1, new_combination)
                            if should_stop:
                                return True
                        
                        except Exception as e:
                            self.logger.error(f"Error processing level {current_level} for {endpoint}: {e}")
                
                return False
            
            # Start processing from root level
            self.logger.info(f"🔄 Starting streaming processing for {endpoint}")
            process_level_recursive(0, {})
            
            self.logger.info(f"📊 Streaming processing complete: {combination_count} combinations, {total_records} records")
            
            
            return total_records
            
        except Exception as e:
            self.logger.error(f"Error in streaming combination processing for {endpoint}: {e}")
            return 0
    
    def _build_final_api_url(self, dependency_chain: List[Dict], parent_combination: Dict) -> str:
        """Build final API URL with all placeholders substituted"""
        try:
            # Get the final endpoint name
            final_endpoint = dependency_chain[-1]['entity']
            
            # Get the URL path template from schema
            url_path = self._get_endpoint_url_path(final_endpoint)
            if not url_path:
                url_path = f"/{final_endpoint}"
            
            # Get base URL from schema and append path
            schema_config = self.integration._extract_schema_config()
            url_config = schema_config.get('url_config', {})
            base_url = url_config.get('base_url', '')
            
            if base_url:
                # Build complete URL: base_url + path
                from dynamic_integrations.etl.extractors.url_builder import URLBuilder
                url_builder = URLBuilder(self.integration)
                complete_url = f"{base_url.rstrip('/')}{url_path}"
                # Replace base URL template variables (domain, company_id, etc.)
                final_url = url_builder.replace_base_url_template_vars(complete_url)
            else:
                # Fallback to just path
                final_url = url_path
            
            # Substitute parent ID placeholders with parent combination values
            for param_name, param_value in parent_combination.items():
                placeholder = f"{{{param_name}}}"
                if placeholder in final_url:
                    final_url = final_url.replace(placeholder, str(param_value))
            
            return final_url
            
        except Exception as e:
            self.logger.error(f"Error building final API URL: {e}")
            return f"/{dependency_chain[-1]['entity'] if dependency_chain else 'unknown'}"
    
    
    def _get_root_parent_ids(self, table_name: str, child_config: List[Dict] = None, upsert_params: Dict = None, page: int = 1, batch_size: int = 1000) -> List[str]:
        """Get parent IDs from root table with pagination and UPSERT filtering
        
        Args:
            table_name: Name of the parent table
            child_config: Child endpoint configuration
            upsert_params: UPSERT parameters for incremental sync filtering
            page: Page number (1-based) for pagination
            batch_size: Number of records per page
            
        Returns:
            List[str]: List of parent IDs for the specified page
        """
        try:
            full_table = f"c{self.integration.client_id_number}_{self.integration.integration_name.lower()}_{table_name}"
            
            # Use configured parent_id_column from child_config instead of auto-detection
            if child_config and len(child_config) > 0:
                config = child_config[0]
                pk_column = config.get('parent_id_column', 'id')
                self.logger.debug(f"Using configured parent_id_column: {pk_column}")
            else:
                # Fallback to auto-detection if no config
                entity_name = table_name.replace('stage', '')
                # Handle plural forms: 'ies' -> 'y', 's' -> ''
                if entity_name.endswith('ies'):
                    entity_name = entity_name[:-3] + 'y'  # estimatesummaries -> estimatesummary
                elif entity_name.endswith('s'):
                    entity_name = entity_name[:-1]  # Remove plural 's'
                
                pk_column = self._detect_primary_key_column(full_table, entity_name)
                if not pk_column:
                    self.logger.info(f"No primary key found for {full_table}, skipping parent ID extraction")
                    return []
            
            # Build WHERE conditions
            where_conditions = ["OrganisationID = :org_id"]
            query_params = {'org_id': self.integration.etani_organisation_id}
            
            # Add UPSERT filtering if in incremental mode
            if upsert_params and upsert_params.get('_load_type') == 'incremental':
                last_sync_timestamp = self._get_parent_table_max_etl_time(table_name)
                if last_sync_timestamp and last_sync_timestamp != '1970-01-01 00:00:00':  # Skip default timestamp
                    where_conditions.append("etlupdatetime > :last_sync")
                    query_params['last_sync'] = last_sync_timestamp
                    self.logger.info(f"🔄 UPSERT filtering: Only getting parents updated after {last_sync_timestamp}")
                else:
                    self.logger.info(f"📥 No previous sync found for parent table {table_name}, using full load")
            
            where_clause = " AND ".join(where_conditions)
            
            # Calculate offset for pagination (page is 1-based)
            offset = (page - 1) * batch_size
            
            query = text(f"""
                SELECT {pk_column} 
                FROM {full_table} 
                WHERE {where_clause}
                ORDER BY {pk_column} 
                LIMIT :limit OFFSET :offset
            """)
            
            query_params.update({
                'limit': batch_size,
                'offset': offset
            })
            
            with eva_engine.connect() as connection:
                result = connection.execute(query, query_params)
                batch_rows = result.fetchall()
                
                # Filter out None values and convert to string
                parent_ids = [str(row[0]) for row in batch_rows if row[0] is not None]
                
            self.logger.info(f"📋 Retrieved {len(parent_ids)} parent IDs from {full_table} using {pk_column} (page {page}, batch_size {batch_size})")
            return parent_ids
            
        except Exception as e:
            self.logger.error(f"Error getting root parent IDs from {table_name} (page {page}): {e}")
            return []
    
    def _get_parent_table_max_etl_time(self, table_name: str) -> str:
        """Get maximum etlupdatetime from parent production table using sql_helper logic
        
        Args:
            table_name: Name of the parent table (without client prefix)
            
        Returns:
            str: Last sync timestamp or default '1970-01-01 00:00:00' if not found
        """
        try:
            # Extract client number from client_id (e.g., BIGOLESHOECOMPANY_CLIENT2013 -> 2013)
            config = self.integration.config or {}
            client_id = config.get('client_id') or getattr(self.integration, 'etani_client_id', '')
            client_number = client_id.split('CLIENT')[-1] if 'CLIENT' in client_id else str(self.integration.client_id_number)
            
            org_id = str(self.integration.etani_organisation_id)
            integration_name = self.integration.integration_name
            
            # Use sql_helper function (same logic as query_builder)
            max_timestamp = get_max_etl_update_time(
                client_number=client_number,
                org_id=org_id,
                integration_name=integration_name,
                endpoint_name=table_name,  # Parent table name
                timestamp_format=None  # Use default format
            )
            
            self.logger.debug(f"Got max etlupdatetime for parent table {table_name}: {max_timestamp}")
            return max_timestamp
            
        except Exception as e:
            self.logger.error(f"Error getting max etlupdatetime for parent {table_name}: {e}")
            return '1970-01-01 00:00:00'  # Return default timestamp on error
    
    def _get_child_ids(self, table_name: str, parent_key: str, parent_id: str, child_config: List[Dict] = None) -> List[str]:
        """Get child IDs for specific parent with dynamic column detection"""
        try:
            full_table = f"c{self.integration.client_id_number}_{self.integration.integration_name.lower()}_{table_name}"
            
            # Use configured child_id_column from child_config instead of auto-detection
            if child_config and len(child_config) > 0:
                config = child_config[0]
                pk_column = config.get('parent_id_column', 'id')  # Use same column for child IDs
                self.logger.debug(f"Using configured child_id_column: {pk_column}")
            else:
                # Fallback to auto-detection if no config
                entity_name = table_name.replace('stage', '')
                # Handle plural forms: 'ies' -> 'y', 's' -> ''
                if entity_name.endswith('ies'):
                    entity_name = entity_name[:-3] + 'y'  # estimatesummaries -> estimatesummary
                elif entity_name.endswith('s'):
                    entity_name = entity_name[:-1]  # Remove plural 's'
                
                pk_column = self._detect_primary_key_column(full_table, entity_name)
                if not pk_column:
                    self.logger.info(f"No primary key found for {full_table}, skipping child ID extraction")
                    return []
            
            # Find actual parent column in target table
            actual_parent_column = self._find_actual_parent_column(full_table, parent_key)
            if not actual_parent_column:
                self.logger.warning(f"Parent column {parent_key} not found in {full_table}")
                return []
            
            # Use pagination to get all child IDs
            all_child_ids = []
            offset = 0
            batch_size = 1000  # Process 1000 records per batch
            
            while True:
                query = text(f"""
                    SELECT {pk_column} 
                    FROM {full_table} 
                    WHERE {actual_parent_column} = :parent_id 
                    AND OrganisationID = :org_id
                    ORDER BY {pk_column} 
                    LIMIT :limit OFFSET :offset
                """)
                
                with eva_engine.connect() as connection:
                    result = connection.execute(query, {
                        'parent_id': parent_id,
                        'org_id': self.integration.etani_organisation_id,
                        'limit': batch_size,
                        'offset': offset
                    })
                    batch_rows = result.fetchall()
                    
                    if not batch_rows:
                        break
                    
                    # Filter out None values and convert to string
                    batch_ids = [str(row[0]) for row in batch_rows if row[0] is not None]
                    all_child_ids.extend(batch_ids)
                    
                    self.logger.debug(f"Retrieved batch {offset//batch_size + 1}: {len(batch_ids)} child IDs from {full_table} for parent {parent_id}")
                    
                    # Continue to next batch
                    offset += batch_size
                    
                    # Break if we got less than batch_size (last batch)
                    if len(batch_rows) < batch_size:
                        break
            
            child_ids = all_child_ids
                
            self.logger.debug(f"Retrieved {len(child_ids)} child IDs from {full_table} for parent {parent_id}")
            return child_ids
            
        except Exception as e:
            self.logger.error(f"Error getting child IDs from {table_name} for parent {parent_id}: {e}")
            return []

    def _detect_primary_key_column(self, full_table: str, entity_name: str) -> str:
        """Detect primary key column: try ID, EntityKey, EntityID patterns (case-insensitive)"""
        try:
            # Try in order: ID -> EntityKey -> EntityID -> Id (for Users)
            possible_patterns = [
                'ID',
                f'{entity_name}Key',
                f'{entity_name}ID', 
                'Id'  # Special case for Users table
            ]
            
            with eva_engine.connect() as connection:
                # Get all column names from table
                columns_query = text(f"SHOW COLUMNS FROM {full_table}")
                result = connection.execute(columns_query)
                existing_columns = [row[0] for row in result.fetchall()]
                
                # Case-insensitive matching - find first match and return actual column name
                for pattern in possible_patterns:
                    for actual_col in existing_columns:
                        if pattern.lower() == actual_col.lower():
                            self.logger.debug(f"Found primary key column '{actual_col}' (matched pattern '{pattern}') in {full_table}")
                            return actual_col  # Return actual column name with correct case
                
                self.logger.warning(f"No suitable primary key column found in {full_table}")
                self.logger.debug(f"Available columns: {existing_columns}")
                self.logger.debug(f"Tried patterns: {possible_patterns}")
                return None
                
        except Exception as e:
            self.logger.error(f"Error detecting primary key column for {full_table}: {e}")
            return None

    def _find_actual_parent_column(self, full_table: str, expected_parent_key: str) -> str:
        """Find actual parent column name in table (handle case variations)"""
        try:
            with eva_engine.connect() as connection:
                columns_query = text(f"SHOW COLUMNS FROM {full_table}")
                result = connection.execute(columns_query)
                available_columns = [row[0] for row in result.fetchall()]

            # Extract base name from expected parent key (e.g., QuoteID -> Quote)
            base_name = expected_parent_key.replace('ID', '').replace('_id', '').replace('Key', '')

            # Try different variations in priority order
            possible_names = [
                expected_parent_key,  # Exact match first
                base_name + 'ID',     # QuoteID
                base_name + '_ID',    # Quote_ID
                base_name + 'Key',    # QuoteKey
                base_name + '_Key',   # Quote_Key
                base_name,            # Quote (without ID)
                'Parent_ID',          # Generic parent reference with underscore (priority)
                'ParentID',           # Generic parent reference
                'parent_id',          # lowercase generic
                'PARENT_ID',          # uppercase generic
                f"{base_name}Id",     # QuoteId (camelCase)
                f"{base_name.lower()}id",  # quoteid (all lowercase)
                f"{base_name}ID",     # QuoteID (exact match, different order)
                'ID',                 # Sometimes just ID column
            ]

            # Find the first matching column
            for possible_name in possible_names:
                if possible_name in available_columns or possible_name.lower() in available_columns:
                    self.logger.info(f"Found matching parent column: {expected_parent_key} -> {possible_name}")
                    return possible_name

            self.logger.warning(f"No matching parent column found for {expected_parent_key} in {available_columns}")
            return None

        except Exception as e:
            self.logger.error(f"Error finding actual parent column for {expected_parent_key} in {full_table}: {e}")
            return None

    def _process_direct_query(self, endpoint: str, stage_table: str, child_config: List[Dict], upsert_mode: bool = False, upsert_params: Dict = None) -> int:
        """Process direct query from parent table without recursive queries"""
        try:
            # Check if child_config exists
            if not child_config or len(child_config) == 0:
                self.logger.error(f"No child config for {endpoint}")
                return 0

            # Get the URL path template from schema
            url_path_template = self._get_endpoint_url_path(endpoint)
            if not url_path_template:
                self.logger.error(f"No URL path found for endpoint: {endpoint}")
                return 0

            # All configs should use the same parent_table
            parent_table = child_config[0].get('parent_table')
            if not parent_table:
                self.logger.error(f"Missing parent_table in child config for {endpoint}")
                return 0

            # Create full table name
            full_parent_table = f"c{self.integration.client_id_number}_{self.integration.integration_name.lower()}_{parent_table}"

            # Build list of columns to select from config
            select_columns = []
            column_to_placeholder = {}  # Maps database columns to URL placeholders

            for config in child_config:
                col = config.get('parent_id_column')
                placeholder = config.get('parent_id_source')
                if col and placeholder:
                    select_columns.append(col)
                    column_to_placeholder[col] = placeholder
                else:
                    self.logger.warning(f"Missing parent_id_column or parent_id_source in config: {config}")

            if not select_columns:
                self.logger.error(f"No valid columns found in child_endpoint_config for {endpoint}")
                return 0

            # Create SQL query to get all needed columns in a single query with pagination
            columns_str = ', '.join(select_columns)

            # Build WHERE conditions with UPSERT filtering if needed
            where_conditions = ["OrganisationID = :org_id"]
            query_params = {'org_id': self.integration.etani_organisation_id}

            # Add UPSERT filtering if in incremental mode with priority for custom time parameter
            if upsert_params and upsert_params.get('_load_type') == 'incremental':
                timestamp_to_use = None

                # Priority 1: Check for global CUSTOM_TIME_FROM parameter
                global CUSTOM_TIME_FROM
                if CUSTOM_TIME_FROM:
                    timestamp_to_use = CUSTOM_TIME_FROM

                # Priority 2: Fallback to last sync timestamp from database
                if not timestamp_to_use:
                    timestamp_to_use = self._get_parent_table_max_etl_time(parent_table)
                    if not (timestamp_to_use and timestamp_to_use != '1970-01-01 00:00:00'):
                        self.logger.info(f"📥 No previous sync found for parent table {parent_table}, using full load")
                        timestamp_to_use = None

                # Apply timestamp filtering if we have a valid timestamp
                if timestamp_to_use:
                    where_conditions.append("etlupdatetime > :last_sync")
                    query_params['last_sync'] = timestamp_to_use

            where_clause = " AND ".join(where_conditions)

            # First count the total number of rows
            count_query = text(f"""
                SELECT COUNT(*)
                FROM {full_parent_table}
                WHERE {where_clause}
            """)

            total_rows = 0
            with eva_engine.connect() as connection:
                count_result = connection.execute(count_query, query_params)
                total_rows = count_result.scalar()

            self.logger.info(f"Total available rows in {parent_table}: {total_rows}")

            # Now fetch all rows in batches
            rows = []
            batch_size = 1000  # Use a large batch size to get more rows
            offset = 0

            while True:
                batch_query = text(f"""
                    SELECT {columns_str}
                    FROM {full_parent_table}
                    WHERE {where_clause}
                    ORDER BY {select_columns[0]}  /* Order by first column for consistent paging */
                    LIMIT :limit OFFSET :offset
                """)

                batch_query_params = query_params.copy()
                batch_query_params.update({
                    'limit': batch_size,
                    'offset': offset
                })

                with eva_engine.connect() as connection:
                    batch_result = connection.execute(batch_query, batch_query_params)
                    batch_rows = batch_result.fetchall()

                if not batch_rows:
                    break  # No more rows

                rows.extend(batch_rows)
                self.logger.info(f"Fetched {len(batch_rows)} rows, total so far: {len(rows)}")

                offset += batch_size

                # Break if we got fewer rows than the batch size (last batch)
                if len(batch_rows) < batch_size:
                    break

            if not rows:
                self.logger.warning(f"No data found in {parent_table}")
                return 0

            self.logger.info(f"Found {len(rows)} rows in {parent_table}")

            # Extract DataExtractor for API calls
            from dynamic_integrations.etl.data_extraction import DataExtractor
            data_extractor = DataExtractor(self.integration)

            total_records = 0
            row_count = 0

            # Define function to process a single row
            def process_single_row(row_data):
                """Process a single database row to make API call"""
                row_index, row = row_data
                try:
                    # Create a combination dictionary for URL substitution
                    combination = {}
                    row_dict = {}  # For logging

                    # Fill the combination dictionary with values from this row
                    for i, col in enumerate(select_columns):
                        placeholder = column_to_placeholder[col]
                        value = str(row[i]) if row[i] is not None else ""
                        combination[placeholder] = value
                        row_dict[placeholder] = value

                    # Build the final URL using the existing method that properly adds base URL
                    url = self._build_final_api_url([{'entity': endpoint}], combination)

                    # Create detail_url when needed
                    detail_url = ""

                    # Get endpoint information from schema
                    schema = self.integration._load_schema()
                    endpoint_schema = None
                    if schema and 'endpoints' in schema:
                        for ep in schema.get('endpoints', []):
                            if ep.get('name', '').lower() == endpoint.lower():
                                endpoint_schema = ep
                                break

                    if endpoint_schema and endpoint_schema.get('is_details', False):
                        # Get detail path from schema
                        detail_path = endpoint_schema.get('detail_path', '')

                        # If detail_path exists, process to create detail_url
                        if detail_path:
                            # Get the URL path template from schema
                            url_path_template = self._get_endpoint_url_path(endpoint)

                            # Check if detail_path is just url_path_template with an additional parameter at the end
                            if url_path_template in detail_path or detail_path.startswith(url_path_template.rstrip('/')):
                                # Get the different part between detail_path and url_path_template
                                diff_part = detail_path.replace(url_path_template.rstrip('/'), '')
                                detail_url = url.rstrip('/') + diff_part

                    # Call data_extractor to get data from the API
                    records_in_batch = data_extractor._extract_from_url(
                        url,
                        detail_url,
                        endpoint,
                        stage_table,
                        upsert_mode,
                        initial_write_mode='append',  # Always append for threading
                        parent_ids=combination
                    )

                    self.logger.debug(f"Processed row {row_index + 1} with values {row_dict}: {records_in_batch} records")
                    return records_in_batch

                except Exception as e:
                    self.logger.error(f"Error processing row {row_index + 1}: {str(e)}")
                    return 0

            # Clear stage table first for full load (not for upsert)
            if not upsert_mode:
                try:
                    with eva_engine.connect() as connection:
                        truncate_query = text(f"TRUNCATE TABLE {stage_table}")
                        connection.execute(truncate_query)
                        connection.commit()
                    self.logger.info(f"🗑️ Cleared stage table {stage_table} for full load")
                except Exception as e:
                    self.logger.warning(f"Could not clear stage table {stage_table}: {e}")
                    # Continue anyway - first API call with overwrite will clear table

            # Always use threading with rate limiting
            print(f"🚀 Processing {len(rows)} rows with threading")

            # Prepare row data for threading
            row_data_list = [(i, row) for i, row in enumerate(rows)]

            # Get thread pool manager
            thread_manager = self._get_thread_pool_manager(endpoint)

            # Execute with threading - no coordination needed
            results = thread_manager.threaded_execution(row_data_list, process_single_row)

            # Calculate total records
            total_records = sum(filter(lambda x: x is not None and isinstance(x, int), results))

            # Log thread manager stats
            stats = thread_manager.get_stats()
            self.logger.info(f"📊 Threading stats: {stats}")

            self.logger.info(f"Direct query complete: processed {len(rows)} rows, total {total_records} records")
            return total_records

        except Exception as e:
            self.logger.error(f"Error in direct query for {endpoint}: {e}")
            return 0


