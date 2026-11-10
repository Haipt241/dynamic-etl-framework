"""
Dynamic Integration Template - Simplified ETL for APIs

Core functionality: API call -> Parse JSON -> Add audit columns -> Save to DB
Organized by functional sections for clarity and maintainability.
"""

import os
import json
import requests
import pandas as pd
from typing import Dict, List, Any
from datetime import datetime, timezone, timedelta
import time
import logging

# Add parent directory to path
import sys

import config
from .utils import Utils
from ..cms_manager import set_cms_disconnected, check_cms_status_for_provisioning
from .rate_limiter import RateLimiter

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from dynamic_integrations.base_integration import BaseIntegration, IntegrationCapability
from sql_helper import LoadToEvaStageTable, get_firm_id, update_container_logs, ReadMySQLTable, \
    LoggingDetails, ExecuteDirectCMSSP, ExecuteCMSSP, check_procedure_exists, submit_query_logs
import uuid
from .auth_manager import AuthManager
from .child_endpoint_processor import ChildEndpointProcessor, ChildEndpointMixin
from ..etl.data_extraction import DataExtractor
from ..powerbi import PowerBIIntegration
from ..etl.data_transformation import DataTransformer
from .reconciliation_module import ReconciliationModule
from etl_cost_tracker import ETLCostTracker, calculate_fargate_cost, get_default_resource_metrics


class DynamicIntegration(ChildEndpointMixin, BaseIntegration):
    """
    Dynamic Integration class - Simplified ETL for APIs
    
    Implements minimal ETL pipeline:
    - Authentication (API Key, Bearer Token, Basic Auth)
    - Simple pagination
    - JSON parsing
    - Audit column addition
    - Database operations
    """
    
    # ==================== INITIALIZATION ====================
    
    def __init__(self, config: Dict[str, Any]):
        """Initialize Dynamic integration with configuration"""
        # Initialize CMS progress tracking
        self.cms_progressuid = None
        super().__init__(config)
        self.config = config
        self.error_list = []
        self.last_request_time = None
        # Initialize rate limiting tracker
        self.rate_limiter = RateLimiter()
        
        # Setup basic attributes from config
        env_vars_config = self.config.get('env_vars_config', {})
        self.etani_client_id = env_vars_config.get('etani_client_id', {}).get('default_value', '')
        self.etani_organisation_id = env_vars_config.get('etani_organisation_id', {}).get('default_value', '')
        self.etani_link_organisation_id = env_vars_config.get('etani_link_organisation_id', {}).get('default_value', '')

        # Debug logging for config loading
        print(f"[DEBUG] DEBUG Config - Integration: {getattr(self, 'integration_name', 'Unknown')}")
        print(f"[DEBUG] DEBUG Config - etani_client_id: '{self.etani_client_id}'")
        print(f"[DEBUG] DEBUG Config - etani_organisation_id: '{self.etani_organisation_id}'")
        print(f"[DEBUG] DEBUG Config - etani_link_organisation_id: '{self.etani_link_organisation_id}'")

        # Get firm ID
        if self.etani_client_id and 'CLIENT' in self.etani_client_id:
            client_number = self.etani_client_id[self.etani_client_id.find('CLIENT') + len('CLIENT'):]
            self.firm_id = get_firm_id(self.error_list, client_number) if client_number else 0
            self.client_id_number = client_number
        else:
            self.firm_id = 0
            self.client_id_number = ""
            
        self.logger = logging.getLogger(f"DynamicIntegration.{self.integration_name}")

        # Initialize Authentication Manager
        self.auth_manager = AuthManager(self, config)
        
        # Initialize ETL components
        self.extractor = DataExtractor(self)
        self.transformer = DataTransformer(self)
        
        # Initialize PowerBI integration
        self.powerbi_integration = PowerBIIntegration(
            client_id=self.etani_client_id,
            organisation_id=self.etani_organisation_id,
            integration_name=self.integration_name
        )

        # Initialize reconciliation module if enabled
        self.reconciliation_module = None
        if self.config.get('reconciliation', {}).get('enabled', False):
            try:
                self.reconciliation_module = ReconciliationModule(self.config, self)
                self.logger.info("[OK] Reconciliation module initialized")
            except Exception as e:
                self.logger.error(f"[ERROR] Failed to initialize reconciliation module: {e}")

        # Initialize max_date_string for DateModified filters
        # This mimics the SSIS formula for calculating MaxDateString in YYYY-MM-DD format
        self.max_date_string = self._calculate_max_date_string()

        # Container logging attributes for cost tracking
        self.container_log_id = None
        self.container_start_time = None

        # Initialize ETL cost tracking
        self.cost_tracker = None
        self.cost_tracking_enabled = getattr(config, 'CONTAINER_COST_TRACKING', {}).get('enabled', True)
    
    def _calculate_max_date_string(self) -> str:
        """
        Calculate MaxDateString in YYYY-MM-DD format
        This mimics the SSIS formula:
        DATEPART("yyyy", MaxDate) + "-" + right((100+DATEPART("m", MaxDate)),2) + "-" + right((100 + DATEPART("dd", MaxDate)),2)
        
        For now, using a default date that can be configured via environment variable or config
        """
        import os
        from datetime import datetime, timedelta
        
        # Try to get MaxDate from environment variable or config, otherwise use a reasonable default
        max_date_str = os.getenv('MAX_DATE_STRING')
        if max_date_str:
            return max_date_str
            
        # Get from config if available
        max_date_str = self.config.get('max_date_string')
        if max_date_str:
            return max_date_str
            
        # Default to 30 days ago for incremental sync (in YYYY-MM-DD format)
        default_date = datetime.now() - timedelta(days=30)
        return default_date.strftime('%Y-%m-%d')
    
    # ==================== ABSTRACT PROPERTIES ====================
    
    @property
    def integration_name(self) -> str:
        """Return integration name"""
        return self.config['integration_name']
    
    @property
    def capabilities(self) -> IntegrationCapability:
        """Return integration capabilities"""
        return IntegrationCapability.UPSERT
    
    @property
    def allowed_execution_statuses(self) -> List[int]:
        """Return allowed organization statuses"""
        return [9, 12]
    
    @property
    def clientID(self) -> str:
        """Return client ID for backward compatibility"""
        return self.etani_client_id
    
    @property
    def organisationID(self) -> str:
        """Return organisation ID for backward compatibility"""
        return self.etani_organisation_id
    
    # ==================== HELPER PROPERTIES FOR TABLE NAMING ====================
    
    @property
    def table_client_prod(self) -> str:
        """Return c{clientID}_{integration}_ prefix for prod tables"""
        integration_name = self.integration_original_name.lower() if hasattr(self, 'integration_original_name') else self.integration_name.lower()
        return f"c{self.client_id_number}_{integration_name}_"
    
    @property
    def table_client_stage(self) -> str:
        """Return c{clientID}_{orgID}_{integration}_ prefix for stage tables"""
        integration_name = self.integration_original_name.lower() if hasattr(self, 'integration_original_name') else self.integration_name.lower()
        return f"c{self.client_id_number}_{self.etani_organisation_id}_{integration_name}_"
    
    @property
    def lastrefreshdate_table(self) -> str:
        """Return LastRefreshDate table name"""
        return f"{self.table_client_prod}lastrefreshdate"
    
    @property
    def lastrefreshdate_procedure(self) -> str:
        """Return LastRefreshDate procedure name"""
        integration_name = self.integration_original_name.lower() if hasattr(self, 'integration_original_name') else self.integration_name.lower()
        return f"sp_dynamic_{integration_name}_lastrefreshdate"
    
    @property
    def integration_procedure_prefix(self) -> str:
        """Return sp_dynamic_{integration}_ prefix for procedures"""
        integration_name = self.integration_original_name.lower() if hasattr(self, 'integration_original_name') else self.integration_name.lower()
        return f"sp_dynamic_{integration_name}"
    
    @property
    def view_prefix(self) -> str:
        """Return {etani_client_id}_{integration}_ prefix for views"""
        integration_name = self.integration_original_name.lower() if hasattr(self, 'integration_original_name') else self.integration_name.lower()
        return f"{self.etani_client_id.lower()}_{integration_name}"
    
    def get_prod_table(self, endpoint: str) -> str:
        """Get production table name for endpoint"""
        return f"{self.table_client_prod}{endpoint.lower()}"
    
    def get_stage_table(self, endpoint: str) -> str:
        """Get stage table name for endpoint"""
        return f"{self.table_client_stage}{endpoint.lower()}stage"
    
    def get_procedure_name(self, endpoint: str) -> str:
        """Get procedure name for endpoint"""
        return f"{self.integration_procedure_prefix}_{endpoint.lower()}"
    
    # ==================== CONFIGURATION ====================
    
    def _load_schema(self, schema_filename: str = None) -> Dict[str, Any]:
        """Load schema from JSON file"""
        if hasattr(self, '_cached_schema') and self._cached_schema:
            return self._cached_schema
            
        try:
            if schema_filename is None:
                schema_filename = f"{self.integration_name.lower()}_schema.json"
            
            from dynamic_integrations.paths import provider_directory
            # Try to find schema file
            possible_paths = [
                str(provider_directory(self.integration_name) / 'schemas' / schema_filename),
                os.path.join(os.getcwd(), 'schemas', schema_filename)
            ]
            
            for path in possible_paths:
                if os.path.exists(path):
                    with open(path, 'r', encoding='utf-8') as f:
                        self._cached_schema = json.load(f)
                        return self._cached_schema
            
            self.logger.warning(f"Schema file {schema_filename} not found")
            return {}
            
        except Exception as e:
            self.logger.warning(f"Error loading schema file {schema_filename}: {e}")
            return {}
    
    def _extract_schema_config(self) -> Dict[str, Any]:
        """Extract configuration from schema for general use"""
        schema = self._load_schema()
        if not schema:
            return {}
        
        api_config = schema.get('api_config', {})
        
        return {
            # URL Configuration
            'url_config': {
                'base_url': api_config.get('base_url', ''),
                'url_patterns': api_config.get('url_patterns', {}),
                'has_special_query': api_config.get('url_patterns', {}).get('special_query_format', False)
            },

            # Authentication Configuration
            'auth_config': {
                'type': api_config.get('authentication', {}).get('type', 'api_key'),
                'oauth2_config': api_config.get('authentication', {}).get('oauth2_config', {}),
                'rate_limiting': api_config.get('authentication', {}).get('rate_limiting', {})
            },

            # Rate Limiting Configuration (top-level in api_config)
            'api_config': {
                'rate_limiting': api_config.get('rate_limiting', {
                    'requests_per_minute': 60,
                    'burst_limit': 1,
                    'retry_strategy': 'exponential_backoff'
                })
            },

            # Pagination Configuration
            'pagination_config': api_config.get('pagination', {
                'type': 'offset',
                'limit_param': 'limit',
                'offset_param': 'offset',
                'default_limit': 100,
                'max_limit': 1000
            }),

            # Data Transformation Configuration
            'transform_config': {
                'response_format': schema.get('response_format', 'standard'),
                'data_mapping': schema.get('data_mapping', {}),
                'field_transformations': schema.get('field_transformations', {}),
                'nested_handling': schema.get('nested_handling', 'flatten')
            },

            # Endpoints Configuration
            'endpoints_config': schema.get('endpoints', {}),

            # Custom Procedures Configuration
            'custom_procedures_config': schema.get('custom_procedures', []),

            # Error Handling Configuration
            'error_config': api_config.get('error_handling', {})
        }
    
    def validate_configuration(self) -> bool:
        """Validate integration configuration with clear field source definitions"""
        # Validate self.config fields (basic integration setup)
        basic_fields = ['integration_name']
        for field in basic_fields:
            if field not in self.config:
                self.error_list.append(f"Missing required field in self.config: {field}")
                return False
        
        # Validate config.json fields (integration-specific config)
        try:
            integration_config = Utils.load_integration_config(self.integration_name.upper())
            
            config_json_fields = ['auth_type']
            for field in config_json_fields:
                if field not in integration_config:
                    self.error_list.append(f"Missing required field in config.json: {field}")
                    return False
                    
        except Exception as e:
            self.error_list.append(f"Config.json validation error: {e}")
            return False
        
        # Validate schema fields
        try:
            schema_config = self._extract_schema_config()
            
            schema_fields = ['api_base_url']
            for field in schema_fields:
                if field == 'api_base_url':
                    url_config = schema_config.get('url_config', {})
                    if not url_config.get('base_url'):
                        self.error_list.append(f"Missing required schema field: {field} (url_config.base_url)")
                        return False
                
        except Exception as e:
            self.error_list.append(f"Schema validation error: {e}")
            return False
        
        return True
    
    def get_endpoints_list(self) -> List[str]:
        """Return list of available endpoints with exclusions applied"""
        endpoints = self.config.get('endpoints', [])
        if isinstance(endpoints, list):
            endpoint_list = endpoints
        elif isinstance(endpoints, dict):
            endpoint_list = list(endpoints.keys())
        else:
            endpoint_list = []
        
        # Filter out virtual endpoints from schema
        endpoint_list = self._filter_virtual_endpoints(endpoint_list)
        
        # Apply exclusions using utility function
        return Utils.apply_endpoint_exclusions(endpoint_list, self.integration_name)
    
    def get_custom_procedures_list(self) -> List[str]:
        """Return list of custom procedures from configuration"""
        custom_procedures = self.config.get('custom_procedures', [])
        if isinstance(custom_procedures, list):
            return custom_procedures
        else:
            return []
    
    def _filter_virtual_endpoints(self, endpoint_list: List[str]) -> List[str]:
        """Filter out virtual endpoints from schema"""
        try:
            schema = self._load_schema()
            if not schema or 'endpoints' not in schema:
                return endpoint_list
                
            # Get virtual endpoints from schema
            virtual_endpoints = []
            for ep in schema['endpoints']:
                if ep.get('is_virtual_endpoint', False):
                    virtual_endpoints.append(ep.get('name'))
            
            # Filter out virtual endpoints
            filtered_list = [ep for ep in endpoint_list if ep not in virtual_endpoints]
            
            if virtual_endpoints:
                self.logger.debug(f"Filtered out virtual endpoints: {virtual_endpoints}")
                
            return filtered_list
            
        except Exception as e:
            self.logger.warning(f"Error filtering virtual endpoints: {e}")
            return endpoint_list
    
    def supports_upsert(self) -> bool:
        """Check if integration supports UPSERT operations"""
        return self.capabilities.value == 'UPSERT'
    
    # ==================== AUTHENTICATION ====================
    
    def get_auth_headers(self, access_token: str = None) -> Dict[str, str]:
        """Generate authentication headers using AuthManager"""
        return self.auth_manager.get_auth_headers(access_token)
    
    def refresh_token_request(self, refresh_token: str):
        """Delegate to AuthManager for token refresh"""
        return self.auth_manager.refresh_token_request(refresh_token)
    
    # ==================== DATA EXTRACTION ====================
    
    def extract_api_response(self, endpoint: str, discovery_mode: bool = False) -> Dict[str, Any]:
        """Main API data extraction method - delegate to DataExtractor"""
        if discovery_mode:
            return self.extractor.extract_api_response_for_discovery(endpoint)
        else:
            upsert_mode = getattr(self, 'upsert_mode', False) or self.config.get('upsert_mode', False)
            return self.extractor.extract_api_response(endpoint, upsert_mode)
    
    def set_upsert_mode(self, enabled: bool = True):
        """Enable or disable UPSERT mode for incremental loading"""
        self.upsert_mode = enabled
        if enabled:
            self.logger.info("[SYNC] UPSERT mode enabled - using incremental parameter building")
        else:
            self.logger.info("[INSERT] UPSERT mode disabled - using full data extraction")
    
    # ==================== RATE LIMITING ====================
    
    def _rate_limit(self):
        """Smart rate limiting with time-window-based request counting (only when configured)"""
        try:
            # Get config from schema
            schema_config = self._extract_schema_config()
            rate_config = schema_config.get('api_config', {}).get('rate_limiting', {})

            # Check if rate limiting is configured
            if not rate_config or not rate_config.get('requests_per_minute'):
                # No rate limiting configured - skip rate limiting
                return

            requests_per_minute = rate_config.get('requests_per_minute')

            # Validate the value
            if not isinstance(requests_per_minute, (int, float)) or requests_per_minute <= 0:
                print(f"[WARNING] Invalid rate limit value: {requests_per_minute}, skipping rate limiting")
                return

            # Use smart rate limiter with safety margin
            self.rate_limiter.wait_if_needed(requests_per_minute, safety_margin=0.8)

        except Exception as e:
            # If there's an error accessing rate config, skip rate limiting (no fallback)
            print(f"[WARNING] Rate limiting config error: {e}, proceeding without rate limiting")
    
    def insert_update_cmsprogress(self, process: str, details: Any = '', progress: float = 0):
        """
        Insert or update CMS progress in task table - XEROBLUE style
        
        Args:
            process: 'insert' or 'update'
            details: Details JSON or string
            progress: Progress percentage (0-100)
        """
        endpoint = 'ETANI'
        
        # Handle details formatting
        if isinstance(details, dict):
            details = json.dumps(details, ensure_ascii=False).replace("'", "''")
        
        status = 'processing' if progress < 100 else 'completed'
        
        if process == 'insert':
            # Generate new task ID if not exists
            if self.cms_progressuid is None:
                self.cms_progressuid = str(uuid.uuid4())
                
            query = f"""
                INSERT INTO task (taskId, type, business, client, clientService, details, status, progress, createdAt, updatedAt)
                VALUES ('{self.cms_progressuid}', 'refresh', {self.firm_id}, {self.client_id_number}, {self.etani_organisation_id}, '{details}', '{status}', '0', UTC_TIMESTAMP(), UTC_TIMESTAMP())
            """
            
        elif process == 'update':
            if self.cms_progressuid is None:
                # If no task ID, generate one (fallback)
                self.cms_progressuid = str(uuid.uuid4())
                
            query = f"""
                UPDATE task SET
                    progress = '{progress:.0f}',
                    status = '{status}',
                    updatedAt = UTC_TIMESTAMP()
                WHERE taskId = '{self.cms_progressuid}'
            """
        
        try:
            ExecuteCMSSP(query, endpoint, self.error_list, True)
            print(f"[DATA] CMS Progress: {progress:.0f}% ({'Completed' if progress >= 100 else 'Processing'})")
        except Exception as e:
            print(f"[WARNING] CMS progress update failed: {e}")
            self.error_list.append(f"CMS progress update error: {e}")
    
    # ==================== MAIN ORCHESTRATION ====================
    
    def run_full_sync(self, endpoint_list: List[str] = None, discovery_mode: bool = False) -> Dict[str, Any]:
        """Run complete ETL pipeline for all endpoints"""
        start_time = time.time()
        
        try:
            # Check CMS status before proceeding (controlled by config flag)
            if getattr(config, 'ENABLE_CMS_CHECK', True):
                cms_check_result = self._check_cms_status()
                if not cms_check_result.get('can_proceed', False):
                    return {
                        'status': 'failed', 
                        'error': cms_check_result.get('error', 'CMS status check failed'),
                        'execution_time': time.time() - start_time
                    }
            else:
                print("ℹ️ CMS status check disabled by config flag")
            
            # Validate configuration
            if not self.validate_configuration():
                return {'status': 'failed', 'error': 'Configuration validation failed'}

            # Start container logging for cost tracking
            if not discovery_mode:
                self.start_container_logging()

            # Set CMS status to Processing (Status = 15) with status = 9 protection - XEROBLUE pattern
            if not discovery_mode:
                try:
                    # Get org_status from cms_check_result
                    org_status = None
                    if getattr(config, 'ENABLE_CMS_CHECK', True) and cms_check_result:
                        org_status = cms_check_result.get('status')

                    # Apply logic: Status 9 = clean full load - keep status at 9 during load
                    if org_status == 9:
                        # INSERT mode: Keep status at 9 for clean full load, only update LastRefreshDate
                        query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP() WHERE id = {self.etani_organisation_id}"
                        ExecuteCMSSP(query, "integration_start", self.error_list, True)
                        print(f"[SYNC] INSERT mode (Status 9): Clean full load in progress - keeping status = 9, only updating LastRefreshDate for organisation {self.etani_organisation_id}")
                    else:
                        # UPSERT mode: ATOMIC STATUS TRANSITION with race condition protection
                        # Accept Status 1 (Lambda scheduled) or Status 12 (API "Refresh Now")
                        # The WHERE clause ensures only ONE container wins the race
                        print(f"[SYNC] UPSERT mode: Attempting atomic status transition {org_status} → 15")
                        query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 15 WHERE id = {self.etani_organisation_id} AND Status IN (1, 12) AND Status != 13"
                        ExecuteCMSSP(query, "integration_start", self.error_list, True)

                        # Verify the status transition succeeded by re-checking current status
                        from sql_helper import read_cms_table
                        status_check = read_cms_table(
                            f"SELECT Status FROM vibedb_cms.client_service WHERE id = {self.etani_organisation_id}",
                            error_list=self.error_list
                        )

                        current_status = int(status_check.iloc[0, 0]) if len(status_check) > 0 else -1

                        if current_status != 15:
                            # Race condition: Another container already processing (status changed between our check and UPDATE)
                            print(f"[WARNING] DUPLICATE DETECTED: Race condition - current status is {current_status}, expected 15")
                            print("   Another container won the race to process this org. Exiting to prevent conflicts.")
                            return {
                                'status': 'duplicate',
                                'error': f'Race condition: Another container won the race (current status: {current_status})',
                                'execution_time': time.time() - start_time
                            }

                        # Successfully transitioned to Status 15 - we won the race, proceed with processing
                        print(f"[OK] Successfully set status to 15 (running) for organisation {self.etani_organisation_id}")
                        print(f"   Entry status: {org_status} → 15 (Lambda scheduled={org_status==1}, Manual refresh={org_status==12})")

                    # Set RefreshStatus to 'Pending' for overall ETL - XEROBLUE pattern using log_endpoint_step
                    self.log_endpoint_step('ETL_OVERALL', 'Started', 'Full')
                    print(f"[CONFIG] RefreshStatus set to 'Pending' for overall ETL using log_endpoint_step")

                    # Initialize CMS progress tracking - XEROBLUE style
                    self.insert_update_cmsprogress('insert', '', 0)
                    
                except Exception as e:
                    print(f"[WARNING] CMS status update failed: {e}")
            else:
                print("ℹ️ CMS status update skipped (discovery mode)")

            # Get endpoints to process
            endpoints = endpoint_list or self.get_endpoints_list()

            if discovery_mode:
                # Discovery mode: collect sample data instead of processing
                print(f"[DEBUG] Running in discovery mode - collecting sample data from {len(endpoints)} endpoints...")
                sample_data = {}
                success_count = 0
                failed_endpoints = []

                for i, endpoint in enumerate(endpoints, 1):
                    try:
                        print(f"[SYNC] Sampling endpoint [{i}/{len(endpoints)}]: {endpoint}")

                        result = self.extract_api_response(endpoint, discovery_mode=True)
                        if result.get('success'):
                            success_count += 1
                            endpoint_sample = result.get('sample_data', [])
                            sample_data[endpoint] = endpoint_sample
                            print(f"[OK] Collected {len(endpoint_sample)} sample records from {endpoint}")
                        else:
                            failed_endpoints.append(endpoint)
                            error_msg = result.get('error', 'Unknown error')
                            print(f"[WARNING] Failed to sample {endpoint}: {error_msg}")
                    except Exception as e:
                        failed_endpoints.append(endpoint)
                        print(f"[ERROR] Error sampling endpoint {endpoint}: {str(e)}")
                        continue

                execution_time = time.time() - start_time

                return {
                    'status': 'completed',
                    'mode': 'discovery',
                    'sample_data': sample_data,
                    'endpoints_sampled': success_count,
                    'failed_endpoints': failed_endpoints,
                    'execution_time': execution_time
                }

            else:
                # Normal mode: full ETL processing
                total_records = 0
                success_count = 0
                failed_endpoints = []

                # Process each endpoint
                for i, endpoint in enumerate(endpoints, 1):
                    try:
                        print(f"[SYNC] Processing endpoint [{i}/{len(endpoints)}]: {endpoint}")

                        # Determine load type and log Started
                        load_type = 'UPSERT' if getattr(self, 'upsert_mode', False) else 'Full'
                        self.log_endpoint_step(endpoint, 'Started', load_type)

                        result = self.extract_api_response(endpoint)
                        if result.get('success'):
                            success_count += 1
                            records_processed = result.get('records_processed', 0)
                            stage_count = result.get('stage_count', records_processed)
                            total_records += records_processed

                            # Get total count from production table (not stage count)
                            production_table_count = self._get_production_table_count(endpoint)

                            # Reconciliation check with retry logic if enabled
                            if self.reconciliation_module:
                                try:
                                    # Get retry configuration
                                    max_retries = getattr(self.reconciliation_module.config, 'retry_attempts', 1)
                                    retry_count = 0
                                    reconciliation_successful = False

                                    while retry_count < max_retries and not reconciliation_successful:
                                        # Perform reconciliation check
                                        reconciliation_result = self.reconciliation_module.check_reconciliation(
                                            endpoint, production_table_count
                                        )

                                        if reconciliation_result.requires_reload:
                                            # Log reconciliation mismatch with RefreshDetail
                                            retry_suffix = f" (Retry {retry_count + 1}/{max_retries})" if retry_count > 0 else ""
                                            refresh_detail = f"Reconciliation failure{retry_suffix}: {reconciliation_result.message}"
                                            self.log_endpoint_step(
                                                endpoint, f'Reconciliation_Mismatch{retry_suffix}', 'Full',
                                                stage_count, production_table_count, refresh_detail
                                            )

                                            print(f"[WARNING] Reconciliation mismatch for {endpoint}{retry_suffix}: {reconciliation_result.message}")

                                            # Trigger full reload
                                            new_production_count = self.reconciliation_module.trigger_full_reload(endpoint, self)
                                            production_table_count = new_production_count  # Use new count for final logging

                                            print(f"[SYNC] Full reload completed for {endpoint} - New count: {new_production_count}")

                                            # Check if reload fixed the issue
                                            retry_reconciliation = self.reconciliation_module.check_reconciliation(
                                                endpoint, new_production_count
                                            )

                                            if not retry_reconciliation.requires_reload:
                                                # Retry successful - remove from failed list
                                                self.reconciliation_module.remove_failed_endpoint(endpoint)
                                                reconciliation_successful = True
                                                print(f"[OK] Reconciliation retry successful for {endpoint}")
                                            else:
                                                # Still failed, increment retry count
                                                retry_count += 1
                                                if retry_count >= max_retries:
                                                    # Exhausted all retries - add to failed endpoints
                                                    self.reconciliation_module.add_failed_endpoint(
                                                        endpoint,
                                                        retry_reconciliation.api_count,
                                                        retry_reconciliation.production_count,
                                                        f"Failed after {max_retries} retry attempts: {retry_reconciliation.message}"
                                                    )
                                                    print(f"[ERROR] Reconciliation failed for {endpoint} after {max_retries} retries")
                                        else:
                                            # Reconciliation successful
                                            reconciliation_successful = True
                                            print(f"[OK] Reconciliation successful for {endpoint}: {reconciliation_result.message}")

                                            # Remove from failed list if it was there
                                            self.reconciliation_module.remove_failed_endpoint(endpoint)

                                except Exception as reconciliation_error:
                                    # Log reconciliation error but don't fail the entire endpoint
                                    error_msg = f"Reconciliation error for {endpoint}: {str(reconciliation_error)}"
                                    print(f"[WARNING] {error_msg}")
                                    self.error_list.append(error_msg)

                                    # Add to failed endpoints list for tracking
                                    if self.reconciliation_module:
                                        self.reconciliation_module.add_failed_endpoint(
                                            endpoint, None, production_table_count, error_msg
                                        )

                            # Log Completed
                            self.log_endpoint_step(
                                endpoint=endpoint,
                                step='Completed',
                                load_type=load_type,
                                stage_count=stage_count,
                                total_count=production_table_count  # Use actual production table count
                            )

                            print(f"[OK] Endpoint {endpoint} completed successfully - {records_processed} records processed")
                            
                            # Update progress
                            if not discovery_mode:
                                progress_percentage = (i / len(endpoints)) * 100
                                self.insert_update_cmsprogress('update', '', progress_percentage)
                        else:
                            failed_endpoints.append(endpoint)
                            error_msg = result.get('error', 'Unknown error')

                            # Check if this is a token error for special handling
                            if self._is_token_error(error_msg):
                                print(f"[SECURE] Token error detected for {endpoint}: {error_msg}")

                                # Set CMS Status = 13 (Disconnected)
                                try:
                                    query = f"UPDATE client_service SET status = 13 WHERE Id = {self.etani_organisation_id}"
                                    ExecuteCMSSP(query, "token_error", self.error_list, True)
                                    print(f"[DATA] CMS status set to 13 (Disconnected) due to token error")
                                    break
                                except Exception as cms_e:
                                    print(f"[WARNING] CMS status update to Disconnected failed: {cms_e}")

                            # Check if this is a persistent 429 rate limit error
                            if self._is_persistent_rate_limit_error(error_msg):
                                print(f"🚦 Persistent rate limit error detected for {endpoint}: {error_msg}")
                                print(f"🛑 Stopping ETL process due to API rate limiting - no point continuing")

                                # Log the termination reason
                                self.error_list.append(f"ETL terminated due to persistent rate limiting on endpoint: {endpoint}")

                                # Set a specific error status to indicate rate limit termination
                                return {
                                    'status': 'terminated_rate_limit',
                                    'error': f'ETL process terminated due to persistent 429 rate limit errors on endpoint: {endpoint}',
                                    'failed_endpoint': endpoint,
                                    'total_endpoints': len(endpoints),
                                    'successful_endpoints': success_count,
                                    'failed_endpoints': len(failed_endpoints) + 1,
                                    'total_records_processed': total_records,
                                    'duration_seconds': time.time() - start_time
                                }

                            # Log Failed
                            self.log_endpoint_step(
                                endpoint=endpoint,
                                step='Failed',
                                load_type=load_type,
                                error_message=error_msg
                            )

                            print(f"[WARNING] Endpoint {endpoint} failed: {error_msg}")
                    except Exception as e:
                        failed_endpoints.append(endpoint)
                        exception_msg = str(e)
                        self.error_list.append(f"Failed {endpoint}: {exception_msg}")

                        # Check if this is a token error that should stop processing
                        if self._is_token_error(exception_msg):
                            print(f"[SECURE] Token error exception detected for {endpoint}: {exception_msg}")

                            # Set CMS Status = 13 (Disconnected)
                            try:
                                query = f"UPDATE client_service SET status = 13 WHERE Id = {self.etani_organisation_id}"
                                ExecuteCMSSP(query, "token_error", self.error_list, True)
                                print(f"[DATA] CMS status set to 13 (Disconnected) due to token error exception")
                                break  # Stop processing immediately
                            except Exception as cms_e:
                                print(f"[WARNING] CMS status update to Disconnected failed: {cms_e}")
                                break  # Still stop processing even if CMS update fails

                        # Log Failed for exception
                        try:
                            self.log_endpoint_step(
                                endpoint=endpoint,
                                step='Failed',
                                load_type=load_type,
                                error_message=exception_msg
                            )
                        except Exception as log_e:
                            print(f"[WARNING] Could not log failure for {endpoint}: {log_e}")

                        print(f"[ERROR] Endpoint {endpoint} encountered exception: {exception_msg}")
            
            # Process custom procedures after endpoints
            # custom_procedures = self.get_custom_procedures_list()
            # custom_success_count = 0
            # failed_procedures = []
            #
            # if custom_procedures:
            #     print(f"[CONFIG] Processing {len(custom_procedures)} custom procedures...")
            #
            #     for i, procedure in enumerate(custom_procedures, 1):
            #         try:
            #             print(f"[SYNC] Processing custom procedure [{i}/{len(custom_procedures)}]: {procedure}")
            #
            #             result = self.process_custom_procedure(procedure)
            #             if result.get('success'):
            #                 custom_success_count += 1
            #                 print(f"[OK] Custom procedure {procedure} executed successfully")
            #             else:
            #                 failed_procedures.append(procedure)
            #                 error_msg = result.get('error', 'Unknown error')
            #                 print(f"[WARNING] Custom procedure {procedure} failed: {error_msg}")
            #         except Exception as e:
            #             failed_procedures.append(procedure)
            #             self.error_list.append(f"Failed custom procedure {procedure}: {str(e)}")
            #             print(f"[ERROR] Custom procedure {procedure} encountered exception: {str(e)}")
            # else:
            #     print("ℹ️ No custom procedures configured for this integration")
            
            # Determine overall status
            if success_count == len(endpoints):
                status = 'completed'
            elif success_count > 0:
                status = 'completed_with_errors'
            else:
                status = 'failed'

            # Execute CloseOut stored procedure for successful integrations
            if status in ['completed', 'completed_with_errors'] and not discovery_mode:
                self._execute_integration_closeout()

            # Update CMS status to Active when integration completes successfully - XEROBLUE style
            if status in ['completed', 'completed_with_errors']:
                try:
                    # Final progress update - XEROBLUE style (must be 100 for email trigger)
                    if not discovery_mode:
                        self.insert_update_cmsprogress('update', '', 100)
                    
                    # Status 1: Completed successfully (triggers email notification)
                    query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 1 WHERE id = {self.etani_organisation_id}"
                    ExecuteCMSSP(query, "integration_completed", self.error_list, True)
                    print(f"[DATA] CMS status set to 1 (Completed) for organisation {self.etani_organisation_id} - Email should trigger")

                    # Set RefreshStatus to 'Completed' for overall ETL - XEROBLUE pattern using log_endpoint_step
                    self.log_endpoint_step('ETL_OVERALL', 'Completed', 'Full')
                    print(f"[CONFIG] RefreshStatus set to 'Completed' for overall ETL using log_endpoint_step")
                    
                except Exception as e:
                    print(f"[WARNING] CMS status update to Completed failed: {e}")
                    # Don't fail the entire integration for CMS update failure
                
                # PowerBI integration - upload template and refresh dataset (controlled by config flag)
                if getattr(config, 'ENABLE_POWERBI_INTEGRATION', True):
                    try:
                        print("[SYNC] Starting PowerBI integration...")
                        
                        # Upload PowerBI template
                        template_upload_result = self.powerbi_integration.upload_template()
                        if template_upload_result:
                            print("[OK] PowerBI template uploaded successfully")
                        else:
                            print("[WARNING] PowerBI template upload failed or skipped")
                        
                        # Refresh PowerBI dataset
                        dataset_refresh_result = self.powerbi_integration.refresh_dataset()
                        if dataset_refresh_result:
                            print("[OK] PowerBI dataset refresh completed successfully")
                        else:
                            print("[WARNING] PowerBI dataset refresh failed or skipped")
                            
                    except Exception as powerbi_error:
                        print(f"[WARNING] PowerBI integration error: {powerbi_error}")
                        # Don't fail the entire integration for PowerBI errors
                else:
                    print("ℹ️ PowerBI integration disabled by config flag")

            # Finalize reconciliation - save failed endpoints report if any failures occurred
            if self.reconciliation_module and not discovery_mode:
                try:
                    failed_count = self.reconciliation_module.get_failed_endpoints_count()
                    if failed_count > 0:
                        report_filepath = self.reconciliation_module.save_failed_endpoints_report()
                        if report_filepath:
                            print(f"[FILE] Reconciliation failures report generated: {failed_count} endpoints")
                        else:
                            print(f"[WARNING] Failed to generate reconciliation failures report")
                    else:
                        print(f"[OK] All reconciliation checks passed - no failed endpoints to report")
                except Exception as reconciliation_finalize_error:
                    print(f"[WARNING] Error finalizing reconciliation report: {reconciliation_finalize_error}")
                    # Don't fail the entire integration for reconciliation report errors

            # End container logging for cost tracking
            if not discovery_mode:
                error_summary = "; ".join(self.error_list[:3]) if self.error_list else None
                self.end_container_logging(status.upper(), error_summary)

            return {
                'status': status,
                'integration_name': self.integration_name,
                'total_endpoints': len(endpoints),
                'successful_endpoints': success_count,
                'failed_endpoints': len(failed_endpoints),
                # 'total_custom_procedures': len(custom_procedures),
                # 'successful_custom_procedures': custom_success_count,
                # 'failed_custom_procedures': len(failed_procedures),
                'total_records_processed': total_records,
                'duration_seconds': time.time() - start_time,
                'errors': self.error_list if self.error_list else None
            }
            
        except Exception as e:
            # Set RefreshStatus to 'Failed' for overall ETL failure - XEROBLUE pattern using log_endpoint_step
            try:
                self.log_endpoint_step('ETL_OVERALL', 'Failed', 'Full', error_message=str(e))
                print(f"[CONFIG] RefreshStatus set to 'Failed' for overall ETL due to exception using log_endpoint_step")
            except Exception as refresh_error:
                print(f"[WARNING] Failed to update RefreshStatus to 'Failed': {refresh_error}")

            # End container logging for exception case
            if not discovery_mode:
                self.end_container_logging('FAILED', str(e))

            return {
                'status': 'failed',
                'error': str(e),
                'duration_seconds': time.time() - start_time
            }

        finally:
            # CRITICAL: Cleanup all database connections before exit
            # This releases MySQL connections immediately and allows Aurora ACUs to scale down
            try:
                from sql_helper import cleanup_all_connections, log_connection_ids

                # Log connection IDs for debugging
                container_info = {
                    'container_id': os.environ.get('CONTAINER_ID', 'unknown'),
                    'client_id': self.config.get('client_id'),
                    'org_id': self.config.get('organisation_id')
                }
                log_connection_ids(container_info)

                # Dispose all connection pools
                cleanup_all_connections()
            except Exception as cleanup_err:
                # Don't raise - cleanup failures shouldn't crash the script
                print(f"[WARNING] Warning: Connection cleanup failed: {cleanup_err}")

    def process_custom_procedure(self, procedure_name: str) -> Dict[str, Any]:
        """
        Process a custom stored procedure
        
        Args:
            procedure_name: Name of the custom procedure to execute
            
        Returns:
            Dict with success status and details
        """
        try:
            # Execute stored procedure using existing SQL helper - follow the reference pattern
            procedure_full_name = f"sp_dynamic_{self.integration_name}_{procedure_name}"
            
            # Set up variables following the reference code pattern
            TaskName = procedure_name

            # Build the CALL statement with client_id and org_id parameters like endpoints do
            client_id_number = getattr(self, 'client_id_number', '')
            etani_org_id = getattr(self, 'etani_organisation_id', '')
            
            # Create the full CALL statement with parameters
            # Special handling for transactions procedure that needs 3 parameters (clientID, orgID, legacyOrgID)
            # Extract FIRMCODE from client_id to determine client database
            client_db = None
            try:
                from sql_helper import get_firmcode_from_client_id
                firmcode = get_firmcode_from_client_id(self.etani_client_id)
                if firmcode:
                    client_db = f"vibedb_{firmcode.upper()}"
                else:
                    client_db = "vibedb"  # Fallback to default
            except Exception as e:
                print(f"[WARNING] Error determining client database: {str(e)}")
                client_db = "vibedb"  # Fallback to default

            if procedure_name == 'transactions':
                # Get legacy organization ID from CMS details
                legacy_org_id = getattr(self, 'legacy_organisation_id', etani_org_id) or etani_org_id
                sp_call = f"CALL {procedure_full_name}('{client_id_number}', {etani_org_id}, {legacy_org_id}, '{client_db}')"
            else:
                sp_call = f"CALL {procedure_full_name}('{client_id_number}', {etani_org_id}, '{client_db}')"
            
            # Execute stored procedure with query=True since we're passing the full CALL statement
            # Execute SQL directly against client database - bypass stored procedure
            ExecuteDirectCMSSP(sp_call, procedure_name, self.error_list, query=True)

            # Get production table name and count records
            prod_table = f"{self.table_client_eva}{procedure_name}"
            try:
                etani_org_id = getattr(self, 'etani_organisation_id', '')
                if etani_org_id:
                    df_prod_count = ReadMySQLTable(
                        f'SELECT COUNT(*) as Count FROM {prod_table} WHERE `OrganisationID` = {etani_org_id}', 
                        procedure_name,
                        self.etani_client_id,
                        self.etani_organisation_id,
                        self.error_list
                    )
                    prod_count = df_prod_count.loc[0, 'Count'] if not df_prod_count.empty else 0
                else:
                    # Fallback count without OrganisationID filter
                    df_prod_count = ReadMySQLTable(
                        f'SELECT COUNT(*) as Count FROM {prod_table}', 
                        procedure_name,
                        self.etani_client_id,
                        self.etani_organisation_id,
                        self.error_list
                    )
                    prod_count = df_prod_count.loc[0, 'Count'] if not df_prod_count.empty else 0
            except Exception as count_error:
                print(f"[WARNING] Could not count records for {procedure_name}: {count_error}")
                prod_count = 0
            
            # Log refresh details following the reference pattern
            try:
                LoggingDetails(
                    TaskName, 
                    f"{procedure_name} - Successfully loaded data to {prod_table}",
                    getattr(self, 'job_id', os.getenv('JOB_ID', '0')),
                    getattr(self, 'job_run_id', os.getenv('JOB_RUN_ID', '0')),
                    self.error_list,
                    self.integration_name.upper()
                )
            except Exception as log_error:
                print(f"[WARNING] Logging error for {procedure_name}: {log_error}")
            
            print(f"[OK] Custom procedure {procedure_name} executed successfully - {prod_count} records in {prod_table}")
            return {
                'success': True,
                'procedure_name': procedure_name,
                'records_count': prod_count,
                'prod_table': prod_table
            }
                
        except Exception as e:
            self.logger.error(f"[ERROR] Error processing custom procedure {procedure_name}: {str(e)}")
            return {
                'success': False,
                'error': str(e)
            }
    
    # ==================== LASTREFRESHDATE LOGGING ====================
    
    def _is_token_error(self, error_message: str) -> bool:
        """
        Detect if error message indicates token/authentication failure
        Based on XEROBLUE INSERT.py logic for invalid_grant detection
        
        Args:
            error_message: Error message to check
            
        Returns:
            True if this appears to be a token-related error
        """
        if not error_message:
            return False
        
        error_lower = error_message.lower()
        token_keywords = [
            'invalid_grant',          # Main keyword from old code
            'invalid_client',         # Xero OAuth error
            'unauthorized',
            'token expired',
            'token invalid',
            'token refresh',          # Matches "Token refresh failed"
            'refresh token',          # Matches "refresh token expired"
            'authentication failed',
            'authentication error',
            'access denied',
            'forbidden',
            'invalid token',
            'token not found',
            'oauth error'
        ]
        
        return any(keyword in error_lower for keyword in token_keywords)

    def _is_persistent_rate_limit_error(self, error_message: str) -> bool:
        """
        Detect if error message indicates persistent 429 rate limiting that should stop ETL

        Args:
            error_message: Error message to check

        Returns:
            True if this appears to be a persistent rate limit error after retries failed
        """
        if not error_message:
            return False

        error_lower = error_message.lower()
        rate_limit_keywords = [
            '429',
            'too many requests',
            'rate limit',
            'rate limited',
            'quota exceeded',
            'api limit exceeded',
            'throttled',
            'throttling',
            'request limit'
        ]

        # Must be a rate limit error AND indicate it failed after retries
        is_rate_limit = any(keyword in error_lower for keyword in rate_limit_keywords)
        indicates_failure_after_retries = any(phrase in error_lower for phrase in [
            'failed after',
            'max retries',
            'retry failed',
            'attempts exceeded',
            'timeout after retries'
        ])

        return is_rate_limit and (indicates_failure_after_retries or '429' in error_lower)

    def log_endpoint_step(self, endpoint: str, step: str, load_type: str,
                         stage_count: int = None, total_count: int = None, 
                         error_message: str = None) -> Dict[str, Any]:
        """
        Simplified logging method that auto-generates table names and common params
        
        Args:
            endpoint: API endpoint name
            step: Step status ('Started', 'InProgress', 'Completed', 'Failed')
            load_type: Load type ('Full', 'UPSERT', 'Latest', etc.)
            stage_count: Number of records in stage (optional)
            total_count: Total records in production (optional) 
            error_message: Error message if step is 'Failed' (optional)
            
        Returns:
            Dict with success status and details
        """
        try:
            # Auto-generate table names and common params
            prod_table = self.get_prod_table(endpoint)
            stage_table = self.get_stage_table(endpoint)
            start_time_str = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            
            # Delegate to main logging method
            return self.log_last_refresh_date(
                prod_table=prod_table,
                stage_table=stage_table,
                load_type=load_type,
                step=step,
                endpoint=endpoint,
                destination='EVA',
                start_date=start_time_str,
                stage_count=stage_count,
                total_count=total_count,
                error_message=error_message
            )
            
        except Exception as e:
            error_msg = f"Error in log_endpoint_step for {endpoint} (step: {step}): {str(e)}"
            print(f"[ERROR] {error_msg}")
            return {'success': False, 'error': error_msg}
    
    def log_last_refresh_date(self, prod_table: str, stage_table: str, load_type: str, 
                             step: str, endpoint: str, destination: str, start_date: str,
                             stage_count: int = None, total_count: int = None, 
                             error_message: str = None) -> Dict[str, Any]:
        """
        Log LastRefreshDate record using stored procedure
        
        Args:
            prod_table: Production table name
            stage_table: Stage table name  
            load_type: Load type ('Full', 'Latest', etc.)
            step: Step status ('Started', 'InProgress', 'Completed', 'Failed')
            endpoint: API endpoint name
            destination: Database destination ('EVA')
            start_date: Start date string
            stage_count: Number of records in stage (optional)
            total_count: Total records in production (optional)
            error_message: Error message if step is 'Failed' (optional)
            
        Returns:
            Dict with success status and details
        """
        try:
            # Clean error message if provided - handle special characters for dynamic SQL context
            if error_message:
                # For dynamic SQL context, need to escape quotes more carefully
                # First escape backslashes
                error_message = error_message.replace("\\", "\\\\")
                # Then escape single quotes - for dynamic SQL we need quadruple quotes
                error_message = error_message.replace("'", " ")
                # Handle other problematic characters
                error_message = error_message.replace('"', '\\"')
                # Limit length to prevent SQL issues
                if len(error_message) > 500:
                    error_message = error_message[:500] + "..."
            
            # Extract FIRMCODE from client_id to determine client database
            client_db = None
            try:
                from sql_helper import get_firmcode_from_client_id
                firmcode = get_firmcode_from_client_id(self.etani_client_id)
                if firmcode:
                    client_db = f"vibedb_{firmcode.upper()}"
                else:
                    client_db = "vibedb"  # Fallback to default
            except Exception as e:
                print(f"[WARNING] Error determining client database: {str(e)}")
                client_db = "vibedb"  # Fallback to default

            # Build SP call based on step
            if step == "Started":
                sp_call = (
                    f"CALL {self.lastrefreshdate_procedure}({self.client_id_number}, '{prod_table}', "
                    f"0, NULL, '{start_date}', NULL, NULL, '{load_type}', '{step}', "
                    f"{os.getenv('JOB_RUN_ID', '0')}, '{destination}', '{self.etani_client_id}', "
                    f"{self.etani_organisation_id}, '{os.getenv('TRIGGER_TYPE', 'MANUAL')}', NULL)"
                )
                
            elif step == "InProgress":
                print(f"{endpoint} - processing is in progress...")
                return {'success': True, 'message': f'{step} status logged for {endpoint}'}
                
            elif step == "Completed":
                sp_call = (
                    f"CALL {self.lastrefreshdate_procedure}({self.client_id_number}, '{prod_table}', "
                    f"{stage_count or 0}, {total_count or 0}, '{start_date}', UTC_TIMESTAMP(), UTC_TIMESTAMP(), "
                    f"'{load_type}', '{step}', {os.getenv('JOB_RUN_ID', '0')}, '{destination}', "
                    f"'{self.etani_client_id}', {self.etani_organisation_id}, "
                    f"'{os.getenv('TRIGGER_TYPE', 'MANUAL')}', NULL)"
                )
                
            elif step == "Failed":
                sp_call = (
                    f"CALL {self.lastrefreshdate_procedure}({self.client_id_number}, '{prod_table}', "
                    f"{stage_count or 0}, {total_count or 0}, '{start_date}', UTC_TIMESTAMP(), NULL, "
                    f"'{load_type}', '{step}', {os.getenv('JOB_RUN_ID', '0')}, '{destination}', "
                    f"'{self.etani_client_id}', {self.etani_organisation_id}, "
                    f"'{os.getenv('TRIGGER_TYPE', 'MANUAL')}', '{error_message or ''}')"
                )
                
            else:
                return {'success': False, 'error': f'Invalid step: {step}'}
            
            # Execute stored procedure
            if step in ["Started", "Completed", "Failed"]:
                # Execute SQL directly against client database - bypass stored procedure
                # Set query=True because sp_call already contains CALL keyword
                ExecuteDirectCMSSP(sp_call, endpoint, self.error_list, query=True)
                print(f"[OK] LastRefreshDate logged: {step} for {endpoint}")
                
                # Handle token errors - set CMS status to 13 (Disconnected)
                if step == "Failed" and error_message and self._is_token_error(error_message):
                    try:
                        cms_result = set_cms_disconnected(
                            organisation_id=str(self.etani_organisation_id),
                            error_list=self.error_list
                        )
                        
                        if cms_result.get('success'):
                            print(f"🔗 CMS status set to Disconnected (13) due to token error")
                        else:
                            print(f"[WARNING] Failed to update CMS status to Disconnected: {cms_result.get('error')}")
                            
                    except Exception as cms_e:
                        print(f"[WARNING] Error updating CMS status for token failure: {cms_e}")
            
            return {
                'success': True,
                'step': step,
                'endpoint': endpoint,
                'message': f'LastRefreshDate logging {step} completed for {endpoint}'
            }
            
        except Exception as e:
            error_msg = f"Error logging LastRefreshDate for {endpoint} (step: {step}): {str(e)}"
            print(f"[ERROR] {error_msg}")
            self.error_list.append(error_msg)
            
            return {
                'success': False,
                'error': error_msg,
                'step': step,
                'endpoint': endpoint
            }
    
    # ==================== CMS INTEGRATION ====================
    
    def _execute_integration_closeout(self) -> bool:
        """
        Execute the integration closeout stored procedure
        Format: "Dynamic-ETL-{INTEGRATION_NAME}-Integration-CloseOut"

        Returns:
            bool: True if successful, False otherwise
        """
        try:
            # Format stored procedure name following requested pattern
            closeout_sp_name = f"Dynamic-ETL-{self.integration_name.upper()}-Integration-CloseOut"

            # Check if the procedure exists before attempting to execute it
            if not check_procedure_exists(closeout_sp_name):
                print(f"ℹ️ CloseOut procedure '{closeout_sp_name}' does not exist - skipping execution")
                return True  # Return success since this is an expected condition

            # Extract FIRMCODE from client_id to determine client database
            client_db = None
            try:
                from sql_helper import get_firmcode_from_client_id
                firmcode = get_firmcode_from_client_id(self.etani_client_id)
                if firmcode:
                    client_db = f"vibedb_{firmcode.upper()}"
                else:
                    client_db = "vibedb"  # Fallback to default
            except Exception as e:
                print(f"[WARNING] Error determining client database: {str(e)}")
                client_db = "vibedb"  # Fallback to default

            # Wrap the stored procedure name in backticks to handle special characters like hyphens
            closeout_sp_call = f"CALL `{closeout_sp_name}`('{self.client_id_number}', {self.etani_organisation_id}, '{client_db}')"

            print(f"[DATA] Executing integration closeout stored procedure: {closeout_sp_name}")

            # Execute SQL directly against client database - bypass stored procedure
            ExecuteDirectCMSSP(closeout_sp_call, "CloseOut", self.error_list, query=True)
            print(f"[OK] Integration closeout procedure executed successfully")
            return True
        except Exception as e:
            # If the error is about procedure not existing, handle it gracefully
            if "PROCEDURE" in str(e) and "does not exist" in str(e):
                print(f"ℹ️ Procedure '{closeout_sp_name}' does not exist. This is normal for some integrations.")
                # Don't add to error list since this isn't a real error
                return True
            else:
                # For other errors, log them
                print(f"[WARNING] Integration closeout procedure execution failed: {e}")
                self.error_list.append(f"Integration closeout procedure execution failed: {str(e)}")
                # Don't fail the entire integration for CloseOut failure
                return False

    def _check_cms_status(self) -> Dict[str, Any]:
        """Check CMS status before running integration"""
        try:
            # Skip CMS check if not applicable
            trigger_type = self.config.get('trigger_type', 'MANUAL')
            if trigger_type != 'MANUAL':
                return {'success': True, 'can_proceed': True, 'message': 'CMS check skipped - not MANUAL trigger'}
            
            if not (hasattr(self, 'etani_client_id') and hasattr(self, 'etani_organisation_id')):
                return {'success': True, 'can_proceed': True, 'message': 'CMS check skipped - missing client info'}
            
            # Use cms_manager for status check
            return check_cms_status_for_provisioning(
                client_id=self.etani_client_id,
                organisation_id=str(self.etani_organisation_id),
                integration_name=self.integration_name.upper(),
                error_list=self.error_list
            )
            
        except Exception as e:
            error_msg = f"CMS status check failed: {str(e)}"
            print(f"[ERROR] {error_msg}")
            return {
                'success': False,
                'error': error_msg,
                'can_proceed': False
            }
    
    def _update_cms_status_completed(self) -> Dict[str, Any]:
        """Update CMS status to Active when integration completes"""
        try:
            if not (hasattr(self, 'etani_client_id') and hasattr(self, 'etani_organisation_id')):
                return {'success': True, 'message': 'CMS update skipped - missing client info'}
            
            from ..cms_manager import set_cms_active
            
            # Extract client number from EtaniClientID
            client_id_str = str(self.etani_client_id)
            if 'CLIENT' in client_id_str:
                client_number = client_id_str[client_id_str.find('CLIENT') + len('CLIENT'):]
            else:
                return {'success': False, 'error': 'Invalid EtaniClientID format'}
            
            return set_cms_active(
                organisation_id=str(self.etani_organisation_id),
                client_id=client_number,
                error_list=self.error_list
            )
            
        except Exception as e:
            error_msg = f"Error updating CMS status to completed: {str(e)}"
            print(f"[ERROR] {error_msg}")
            return {'success': False, 'error': error_msg}

    def _get_production_table_count(self, endpoint: str) -> int:
        """Get total count of records from production table for TotalRowCount"""
        try:
            # Use existing property for production table prefix
            production_table = f"{self.table_client_prod}{endpoint.lower()}"

            # Determine correct organisation ID (same logic as data_transformation._add_audit_columns)
            organisation_id_value = self.etani_organisation_id
            schema = self._load_schema()
            if schema and schema.get('usingEtaniLinkOrganisationID', False) and hasattr(self, 'etani_link_organisation_id'):
                organisation_id_value = self.etani_link_organisation_id
                self.logger.debug(f"Using EtaniLinkOrganisationID for production count query: {organisation_id_value}")

            # Query to count records in production table for this organisation
            query = f"""
                SELECT COUNT(*) as total_count
                FROM {production_table}
                WHERE OrganisationID = {organisation_id_value}
            """

            # Execute query using ReadMySQLTable
            result_df = ReadMySQLTable(
                query,
                endpoint,
                self.etani_client_id,
                self.etani_organisation_id,
                self.error_list,
                IsCMS=False,
                integration_name=self.integration_name.upper()
            )

            if not result_df.empty and 'total_count' in result_df.columns:
                total_count = int(result_df.iloc[0]['total_count'])
                self.logger.debug(f"Production table {production_table} has {total_count} records")
                return total_count
            else:
                self.logger.warning(f"Could not get count from production table {production_table}")
                return 0

        except Exception as e:
            self.logger.error(f"Error getting production table count for {endpoint}: {e}")
            # Return 0 as fallback rather than causing the whole process to fail
            return 0

    # ==================== CONTAINER LOGGING ====================

    def _calculate_container_cost(self, vcpu_allocated: float, memory_gb_allocated: float, duration_seconds: int) -> float:
        """Calculate container cost based on AWS pricing"""
        try:
            import config
            region = 'ap-southeast-2'  # Fixed region
            pricing = config.AWS_CONTAINER_PRICING.get(region, config.AWS_CONTAINER_PRICING['ap-southeast-2'])

            duration_hours = duration_seconds / 3600.0
            vcpu_cost = vcpu_allocated * pricing['vcpu_per_hour'] * duration_hours
            memory_cost = memory_gb_allocated * pricing['memory_per_gb_per_hour'] * duration_hours

            return round(vcpu_cost + memory_cost, 4)
        except Exception as e:
            self.logger.warning(f"Error calculating container cost: {e}")
            return 0.0

    def start_container_logging(self):
        """Start container logging - INSERT record to container_logs table"""
        try:
            # Generate unique log ID
            import uuid
            self.container_log_id = str(uuid.uuid4())
            self.container_start_time = datetime.now()

            # Initialize ETL cost tracker if enabled
            if self.cost_tracking_enabled:
                try:
                    # Determine run type
                    run_type = 'UPSERT' if getattr(self, 'upsert_mode', False) else 'INSERT'

                    # Initialize cost tracker
                    self.cost_tracker = ETLCostTracker(
                        org_id=int(self.etani_organisation_id) if self.etani_organisation_id else 0,
                        client_id=int(self.client_id_number) if self.client_id_number else 0,
                        etani_client_id=self.etani_client_id,
                        run_type=run_type,
                        start_time=self.container_start_time.timestamp()  # Convert datetime to timestamp
                    )

                    # Make cost tracker globally accessible to SQL operations
                    try:
                        import sql_helper
                        sql_helper.cost_tracker = self.cost_tracker
                        print(f"💰 ETL cost tracking initialized: {run_type} mode")
                    except ImportError:
                        # If sql_helper not available, continue without global access
                        print(f"💰 ETL cost tracking initialized: {run_type} mode (local only)")

                except Exception as cost_error:
                    print(f"[WARNING] Failed to initialize cost tracker: {cost_error}")

            # Fixed container metadata
            platform = 'AWS'
            region = 'ap-southeast-2'
            container_name = 'dynamic-integration'
            vcpu_allocated = 1.0
            memory_gb_allocated = 2.0
            trigger_type = 'MANUAL'

            # Prepare SP call parameters - exact match with SP definition (28 parameters)
            sp_call = f"""
                CALL sp_add_container_logs(
                    '{self.integration_name}',
                    {self.etani_organisation_id},
                    {self.client_id_number},
                    {self.firm_id},
                    '{self.container_start_time.strftime('%Y-%m-%d %H:%M:%S')}',
                    NULL,
                    'RUNNING',
                    '{self.container_log_id}',
                    'Dynamic integration started',
                    '{platform}',
                    '{region}',
                    '{container_name}',
                    0,
                    '{trigger_type}',
                    NULL,
                    {vcpu_allocated},
                    {memory_gb_allocated},
                    '',
                    '',
                    '',
                    {vcpu_allocated},
                    {memory_gb_allocated},
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    0.0
                )
            """

            # Execute SP
            ExecuteCMSSP(sp_call, "container_logging", self.error_list, True)
            self.logger.info(f"Container logging started: {self.container_log_id}")

        except Exception as e:
            self.logger.warning(f"Failed to start container logging: {e}")

    def end_container_logging(self, status: str, error_details: str = None):
        """End container logging - UPDATE record in container_logs table"""
        try:
            if not self.container_log_id or not self.container_start_time:
                return

            # Calculate duration and cost
            end_time = datetime.now()
            duration_seconds = int((end_time - self.container_start_time).total_seconds())

            # Fixed container metadata
            platform = 'AWS'
            region = 'ap-southeast-2'
            container_name = 'dynamic-integration'
            vcpu_allocated = 1.0
            memory_gb_allocated = 2.0
            trigger_type = 'MANUAL'

            # Finalize cost tracking if enabled
            total_cost_usd = 0.0
            mysql_io_cost_usd = 0.0
            if self.cost_tracker and self.cost_tracking_enabled:
                try:
                    # Get resource metrics (fallback to defaults)
                    resource_metrics = get_default_resource_metrics()

                    # Calculate container cost using imported function
                    container_cost_usd = calculate_fargate_cost(vcpu_allocated, memory_gb_allocated, duration_seconds)

                    # Finalize cost tracking - convert datetime to Unix timestamp
                    cost_data = self.cost_tracker.finalize(
                        end_time=end_time.timestamp(),  # Convert datetime to Unix timestamp
                        container_cost_usd=container_cost_usd,
                        resource_metrics=resource_metrics
                    )

                    total_cost_usd = cost_data['total_cost_usd']
                    mysql_io_cost_usd = cost_data['mysql_io_cost_usd']

                except Exception as cost_error:
                    print(f"[WARNING] Error finalizing cost tracking: {cost_error}")
                    # Fallback to basic cost calculation
                    total_cost_usd = self._calculate_container_cost(vcpu_allocated, memory_gb_allocated, duration_seconds)
            else:
                # Basic cost calculation
                total_cost_usd = self._calculate_container_cost(vcpu_allocated, memory_gb_allocated, duration_seconds)

            # Prepare remarks with cost breakdown
            mysql_io_cost_usd = mysql_io_cost_usd if 'mysql_io_cost_usd' in locals() else 0.0
            container_cost_usd = total_cost_usd - mysql_io_cost_usd
            remarks = f"Integration {status.lower()}, duration: {duration_seconds}s, total: ${total_cost_usd:.6f} (container: ${container_cost_usd:.6f}, I/O: ${mysql_io_cost_usd:.6f})"

            # Prepare SP call parameters - UPDATE will happen based on log_id (28 parameters)
            # Escape single quotes in text parameters to prevent SQL syntax errors
            safe_remarks = remarks[:500].replace("'", "''") if remarks else ''
            safe_error_details = (error_details or '')[:500].replace("'", "''").replace('\n', ' ').replace('\r', ' ')

            sp_call = f"""
                CALL sp_add_container_logs(
                    '{self.integration_name}',
                    {self.etani_organisation_id},
                    {self.client_id_number},
                    {self.firm_id},
                    '{self.container_start_time.strftime('%Y-%m-%d %H:%M:%S')}',
                    '{end_time.strftime('%Y-%m-%d %H:%M:%S')}',
                    '{status}',
                    '{self.container_log_id}',
                    '{safe_remarks}',
                    '{platform}',
                    '{region}',
                    '{container_name}',
                    {duration_seconds},
                    '{trigger_type}',
                    '{safe_error_details}',
                    {vcpu_allocated},
                    {memory_gb_allocated},
                    '',
                    '',
                    '',
                    {vcpu_allocated},
                    {memory_gb_allocated},
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    {total_cost_usd}
                )
            """

            # Execute SP
            ExecuteCMSSP(sp_call, "container_logging", self.error_list, True)

            # Submit query logs if available
            try:
                submit_query_logs(self.container_log_id)
            except Exception as e:
                print(f"[WARNING] Failed to submit query logs: {e}")

            self.logger.info(f"Container logging completed: {status}, ${total_cost_usd:.6f} USD")

        except Exception as e:
            self.logger.warning(f"Failed to end container logging: {e}")

