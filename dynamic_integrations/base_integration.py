"""
Base Integration Interface

This module defines the base interface/contract that all integrations must implement
to work with the Dynamic Integration Package orchestrator.

This ensures true integration-agnostic behavior and plug-and-play architecture.
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, List
from enum import Enum
import os


class IntegrationCapability(Enum):
    """Enumeration of integration capabilities"""
    INSERT = "INSERT"
    UPSERT = "UPSERT"
    BOTH = "BOTH"


class BaseIntegration(ABC):
    """
    Abstract base class that defines the interface all integrations must implement.
    
    This ensures that integrations are truly plug-and-play with the orchestrator
    without requiring changes to the IntegrationPackage class.
    
    Required Interface:
    - integration_name: str property
    - capabilities: IntegrationCapability property 
    - validate_configuration(): bool method
    
    Conditional Requirements:
    - If supports INSERT: get_insert_configuration() method
    - If supports UPSERT: run_full_sync() method
    
    Optional Methods:
    - create_sql_objects(), initialize_indexes(), upload_powerbi_template()
    - extract_api_response(), get_endpoints_list(), etc.
    """
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        """
        Initialize the integration with configuration
        
        Args:
            config: Configuration dictionary
        """
        self.config = config or {}
        self._validate_required_interface()
    
    @property
    @abstractmethod
    def integration_name(self) -> str:
        """
        Return the name of the integration
        
        Returns:
            str: Integration name (e.g., 'XEROBLUE', 'MYOB', etc.)
        """
        pass
    
    @property
    @abstractmethod
    def capabilities(self) -> IntegrationCapability:
        """
        Return the capabilities supported by this integration
        
        Returns:
            IntegrationCapability: What operations this integration supports
        """
        pass
    
    @abstractmethod
    def validate_configuration(self) -> bool:
        """
        Validate the integration configuration
        
        Returns:
            bool: True if configuration is valid, False otherwise
        """
        pass
    
    # ===================================================================================
    # COMMON FUNCTIONALITY PROPERTIES (Required for shared methods)
    # ===================================================================================
    
    @property
    @abstractmethod
    def allowed_execution_statuses(self) -> List[int]:
        """
        Return list of organization statuses that allow execution (without Reset_Mode requirement)
        
        Status 16 (Resetting Data) is handled automatically - it always requires Reset_Mode.
        Each integration defines which other statuses are allowed.
        
        Examples:
        - XeroBlue: [12] (Status 12 = Updating Data)
        - QBO: [9] (Status 9 = Provisioning New Data)
        
        Returns:
            List[int]: Organization status codes that allow execution
        """
        pass
    
    @property
    def etani_client_id(self) -> str:
        """
        Return the Etani client identifier
        
        Returns:
            str: Client identifier (e.g., 'BIGOLESHOECOMPANY_CLIENT1518')
        """
        return getattr(self, '_etani_client_id', os.getenv('EtaniClientID', ''))
    
    @etani_client_id.setter
    def etani_client_id(self, value: str):
        """Set the Etani client identifier"""
        self._etani_client_id = value
    
    @property
    def etani_organisation_id(self) -> str:
        """
        Return the Etani organisation identifier
        
        Returns:
            str: Organisation identifier (e.g., '7035')
        """
        return getattr(self, '_etani_organisation_id', os.getenv('EtaniOrganisationID', ''))
    
    @etani_organisation_id.setter
    def etani_organisation_id(self, value: str):
        """Set the Etani organisation identifier"""
        self._etani_organisation_id = value
    
    @property
    def table_prefix_eva(self) -> str:
        """
        Return the EVA table prefix for this integration
        
        Returns:
            str: EVA table prefix (e.g., 'c1518_7035_qbo_')
        """
        if hasattr(self, '_table_prefix_eva'):
            return self._table_prefix_eva
        
        # Generate default prefix from environment variables
        try:
            etani_client_id = self.etani_client_id
            etani_organisation_id = self.etani_organisation_id
            integration_name = self.integration_name.lower()
            
            if etani_client_id and 'CLIENT' in etani_client_id:
                client_number = etani_client_id[etani_client_id.find('CLIENT') + len('CLIENT'):]
                return f'c{client_number}_{etani_organisation_id}_{integration_name}_'
            else:
                return f'{etani_client_id}_{etani_organisation_id}_{integration_name}_'
        except Exception:
            return f'default_{integration_name}_'
    
    @table_prefix_eva.setter
    def table_prefix_eva(self, value: str):
        """Set the EVA table prefix for this integration"""
        self._table_prefix_eva = value
    
    @property
    def table_prefix_dw(self) -> str:
        """
        Return the DW table prefix for this integration
        
        Returns:
            str: DW table prefix (e.g., 'c1518_7035_qbo_')
        """
        if hasattr(self, '_table_prefix_dw'):
            return self._table_prefix_dw
        
        # Generate default DW prefix from environment variables
        try:
            etani_client_id = self.etani_client_id
            etani_organisation_id = self.etani_organisation_id
            integration_name = self.integration_name.upper()
            
            return f'{etani_client_id}_{etani_organisation_id}_{integration_name}_'
        except Exception:
            return f'DEFAULT_{integration_name}_'
    
    @table_prefix_dw.setter
    def table_prefix_dw(self, value: str):
        """Set the DW table prefix for this integration"""
        self._table_prefix_dw = value
    
    @property
    def job_id(self) -> str:
        """
        Return the job identifier
        
        Returns:
            str: Job identifier from environment or assigned value
        """
        return getattr(self, '_job_id', os.getenv('JOB_ID', ''))
    
    @job_id.setter
    def job_id(self, value: str):
        """Set the job identifier"""
        self._job_id = value
    
    @property
    def job_run_id(self) -> str:
        """
        Return the job run identifier
        
        Returns:
            str: Job run identifier from environment or assigned value
        """
        return getattr(self, '_job_run_id', os.getenv('JOB_RUN_ID', ''))
    
    @job_run_id.setter
    def job_run_id(self, value: str):
        """Set the job run identifier"""
        self._job_run_id = value
    
    @property
    def legacy_client_id(self) -> str:
        """
        Return the legacy client identifier
        
        Returns:
            str: Legacy client identifier (typically populated from CMS)
        """
        return getattr(self, '_legacy_client_id', '')
    
    @legacy_client_id.setter
    def legacy_client_id(self, value: str):
        """Set the legacy client identifier"""
        self._legacy_client_id = value
    
    @property
    def legacy_organisation_id(self) -> str:
        """
        Return the legacy organisation identifier
        
        Returns:
            str: Legacy organisation identifier (typically populated from CMS)
        """
        return getattr(self, '_legacy_organisation_id', '')
    
    @legacy_organisation_id.setter
    def legacy_organisation_id(self, value: str):
        """Set the legacy organisation identifier"""
        self._legacy_organisation_id = value
    
    @property
    def client_id(self) -> str:
        """
        Return the API client identifier
        
        Returns:
            str: API client identifier with integration-specific fallbacks
        """
        if hasattr(self, '_client_id'):
            return self._client_id
        
        # Integration-specific environment variable fallbacks
        integration_name = self.integration_name.upper()
        
        if integration_name == 'XEROBLUE':
            # XeroBlue: Check multiple environment variable patterns
            client_id = os.getenv('xeroblue_client_id') or os.getenv('XERO_CLIENT_ID')
            if client_id is None:
                # XeroBlue default fallback
                return '7D624AC6AEAA49CAA480DC684FCAA0C4'
            return client_id
        elif integration_name == 'QBO':
            # QBO: Check config or use test fallback
            try:
                import config
                return getattr(config, 'QBO_CLIENT_ID', 'Q0Uon6a8WLHJdy0b9NuyYNxp6YsWgYenowtLglbnKNZqZ1TNcP')
            except ImportError:
                return 'Q0Uon6a8WLHJdy0b9NuyYNxp6YsWgYenowtLglbnKNZqZ1TNcP'
        else:
            # Generic fallback for other integrations
            return os.getenv(f'{integration_name}_CLIENT_ID', f'default_{integration_name.lower()}_client_id')
    
    @client_id.setter
    def client_id(self, value: str):
        """Set the API client identifier"""
        self._client_id = value
    
    @property
    def client_secret(self) -> str:
        """
        Return the API client secret
        
        Returns:
            str: API client secret with integration-specific fallbacks
        """
        if hasattr(self, '_client_secret'):
            return self._client_secret
        
        # Integration-specific environment variable fallbacks
        integration_name = self.integration_name.upper()
        
        if integration_name == 'XEROBLUE':
            # XeroBlue: Check multiple environment variable patterns
            client_secret = os.getenv('xeroblue_client_secret') or os.getenv('XERO_CLIENT_SECRET')
            if client_secret is None:
                # XeroBlue default fallback
                return 'REDACTED'
            return client_secret
        elif integration_name == 'QBO':
            # QBO: Check config or use test fallback
            try:
                import config
                return getattr(config, 'QBO_CLIENT_SECRET', 'REDACTED')
            except ImportError:
                return 'REDACTED'
        else:
            # Generic fallback for other integrations
            return os.getenv(f'{integration_name}_CLIENT_SECRET', f'default_{integration_name.lower()}_client_secret')
    
    @client_secret.setter
    def client_secret(self, value: str):
        """Set the API client secret"""
        self._client_secret = value
    
    @property
    def storage_account_name(self) -> str:
        """
        Return the Azure Storage Account Name
        
        Returns:
            str: Storage account name with fallbacks
        """
        if hasattr(self, '_storage_account_name'):
            return self._storage_account_name
        
        # Try environment variable, then config, then default
        storage_name = os.getenv('STORAGE_ACCOUNT_NAME')
        if storage_name:
            return storage_name
        
        try:
            import config
            return getattr(config, 'STORAGE_ACCOUNT_NAME', 'etanissis')
        except ImportError:
            return 'etanissis'  # Default value
    
    @storage_account_name.setter
    def storage_account_name(self, value: str):
        """Set the Azure Storage Account Name"""
        self._storage_account_name = value
    
    @property
    def storage_account_key(self) -> str:
        """
        Return the Azure Storage Account Key
        
        Returns:
            str: Storage account key with fallbacks
        """
        if hasattr(self, '_storage_account_key'):
            return self._storage_account_key
        
        # Try environment variable, then config, then default
        storage_key = os.getenv('STORAGE_ACCOUNT_KEY')
        if storage_key:
            return storage_key
        
        try:
            import config
            return getattr(config, 'STORAGE_ACCOUNT_KEY', 'REDACTED')
        except ImportError:
            return 'REDACTED'  # Default value
    
    @storage_account_key.setter
    def storage_account_key(self, value: str):
        """Set the Azure Storage Account Key"""
        self._storage_account_key = value
    
    @property
    def blob_container_name(self) -> str:
        """
        Return the Azure Blob Container Name

        Returns:
            str: Blob container name with fallbacks
        """
        if hasattr(self, '_blob_container_name'):
            return self._blob_container_name

        # Try environment variable, then config, then default
        container_name = os.getenv('BLOB_CONTAINER_NAME')
        if container_name:
            return container_name

        try:
            import config
            return getattr(config, 'BLOB_CONTAINER_NAME', 'databrickstemp')
        except ImportError:
            return 'databrickstemp'  # Default value

    @blob_container_name.setter
    def blob_container_name(self, value: str):
        """Set the Azure Blob Container Name"""
        self._blob_container_name = value

    @property
    def file_share_name(self) -> str:
        """
        Return the Azure File Share Name

        Returns:
            str: File share name with fallbacks
        """
        if hasattr(self, '_file_share_name'):
            return self._file_share_name

        # Try environment variable, then config, then default
        share_name = os.getenv('FILE_SHARE_NAME')
        if share_name:
            return share_name

        try:
            import config
            return getattr(config, 'FILE_SHARE_NAME', 'xeroblue-pydw-refreshtoken')
        except ImportError:
            return 'xeroblue-pydw-refreshtoken'  # Default value

    @file_share_name.setter
    def file_share_name(self, value: str):
        """Set the Azure File Share Name"""
        self._file_share_name = value

    # AWS S3 Properties

    @property
    def use_aws_s3(self) -> bool:
        """
        Determine whether to use AWS S3 instead of Azure storage

        Returns:
            bool: True if AWS S3 should be used, False otherwise
        """
        return os.getenv('USE_AWS_DB', 'false').lower() in ('true', '1', 'yes')

    @property
    def aws_s3_bucket_name(self) -> str:
        """
        Return the AWS S3 Bucket Name

        Returns:
            str: S3 bucket name from environment or config
        """
        if hasattr(self, '_aws_s3_bucket_name'):
            return self._aws_s3_bucket_name

        # Try environment variable, then config
        bucket_name = os.getenv('AWS_S3_BUCKET_NAME')
        if bucket_name:
            return bucket_name

        try:
            import config
            return getattr(config, 'AWS_S3_BUCKET_NAME', '')
        except ImportError:
            return ''  # No default value

    @aws_s3_bucket_name.setter
    def aws_s3_bucket_name(self, value: str):
        """Set the AWS S3 Bucket Name"""
        self._aws_s3_bucket_name = value

    @property
    def aws_s3_prefix(self) -> str:
        """
        Return the AWS S3 prefix for organizing files

        Returns:
            str: S3 prefix with fallbacks
        """
        if hasattr(self, '_aws_s3_prefix'):
            return self._aws_s3_prefix

        # Try environment variable, then config, then default
        prefix = os.getenv('AWS_S3_PREFIX')
        if prefix:
            return prefix

        try:
            import config
            return getattr(config, 'AWS_S3_PREFIX', 'tokens')
        except ImportError:
            return 'tokens'  # Default value

    @aws_s3_prefix.setter
    def aws_s3_prefix(self, value: str):
        """Set the AWS S3 prefix"""
        self._aws_s3_prefix = value
    
    # ===================================================================================
    # INSERT INTERFACE (Required if capabilities include INSERT)
    # ===================================================================================
    
    def get_insert_configuration(self) -> Dict[str, Any]:
        """
        Get configuration needed for INSERT operations
        
        Required if capabilities include INSERT.
        
        Returns:
            Dict containing:
            - integration_name: str
            - client_id: str  
            - organisation_id: str
            - legacy_client_id: str
            - base_currency: str (optional, default 'AUD')
            - fx_currencies: List[str] (optional, default ['AUD', 'USD', 'EUR'])
            - error_list: List (optional, default [])
        
        Raises:
            NotImplementedError: If integration doesn't support INSERT
        """
        if self.capabilities not in [IntegrationCapability.INSERT, IntegrationCapability.BOTH]:
            raise NotImplementedError(f"Integration {self.integration_name} does not support INSERT operations")
        
        raise NotImplementedError("get_insert_configuration must be implemented for INSERT-capable integrations")
    
    def create_sql_objects(self, parallel: bool = True) -> bool:
        """
        Create SQL objects (tables, views, stored procedures) for the integration
        
        Optional method for custom SQL object creation.
        
        Args:
            parallel: Whether to create objects in parallel
            
        Returns:
            bool: True if successful, False otherwise
        """
        return True  # Default implementation does nothing but succeeds
    
    def initialize_indexes(self) -> bool:
        """
        Initialize database indexes for the integration
        
        Optional method for custom index initialization.
        
        Returns:
            bool: True if successful, False otherwise
        """
        return True  # Default implementation does nothing but succeeds
    
    def upload_powerbi_template(self, workspace_id: str = None) -> bool:
        """
        Upload PowerBI template for the integration
        
        Optional method for PowerBI template management.
        
        Args:
            workspace_id: PowerBI workspace ID
            
        Returns:
            bool: True if successful, False otherwise
        """
        return True  # Default implementation does nothing but succeeds
    
    # ===================================================================================
    # UPSERT INTERFACE (Required if capabilities include UPSERT)  
    # ===================================================================================
    
    def run_full_sync(self, endpoint_list: Optional[List[str]] = None) -> Dict[str, Any]:
        """
        Run full synchronization for the integration
        
        Required if capabilities include UPSERT.
        
        Args:
            endpoint_list: Optional list of specific endpoints to process
            
        Returns:
            Dict containing execution results with keys like:
            - status: str ('completed', 'failed', 'completed_with_errors')
            - duration_seconds: float
            - total_endpoints: int
            - successful_endpoints: int
            - total_records_processed: int
            - error_details: Any (if errors occurred)
        
        Raises:
            NotImplementedError: If integration doesn't support UPSERT
        """
        if self.capabilities not in [IntegrationCapability.UPSERT, IntegrationCapability.BOTH]:
            raise NotImplementedError(f"Integration {self.integration_name} does not support UPSERT operations")
        
        raise NotImplementedError("run_full_sync must be implemented for UPSERT-capable integrations")
    
    def extract_api_response(self, endpoint: str) -> Dict[str, Any]:
        """
        Extract API response for a single endpoint
        
        Optional method for single endpoint processing.
        
        Args:
            endpoint: The endpoint to process
            
        Returns:
            Dict containing extraction results
        """
        # Default implementation falls back to run_full_sync
        return self.run_full_sync([endpoint])
    
    def get_endpoints_list(self) -> List[str]:
        """
        Get list of available endpoints for this integration
        
        Optional method to provide endpoint information.
        
        Returns:
            List[str]: Available endpoints
        """
        return []  # Default implementation returns empty list
    
    # ===================================================================================
    # VALIDATION AND UTILITY METHODS
    # ===================================================================================
    
    def _validate_required_interface(self):
        """
        Validate that the integration implements the required interface
        based on its declared capabilities
        """
        # Check required properties
        try:
            _ = self.integration_name
            _ = self.capabilities
        except NotImplementedError:
            raise ValueError(f"Integration must implement integration_name and capabilities properties")
        
        # Check common functionality properties (required for shared methods)
        # Only check allowed_execution_statuses since other properties are now implemented in base class
        required_properties = ['allowed_execution_statuses']
        
        for prop in required_properties:
            try:
                _ = getattr(self, prop)
            except (NotImplementedError, AttributeError):
                raise ValueError(f"Integration must implement {prop} property for common functionality")
        
        # Check capability-specific requirements
        if self.capabilities in [IntegrationCapability.INSERT, IntegrationCapability.BOTH]:
            if not hasattr(self, 'get_insert_configuration'):
                raise ValueError(f"INSERT-capable integration must implement get_insert_configuration method")
        
        if self.capabilities in [IntegrationCapability.UPSERT, IntegrationCapability.BOTH]:
            if not hasattr(self, 'run_full_sync'):
                raise ValueError(f"UPSERT-capable integration must implement run_full_sync method")
    
    def supports_insert(self) -> bool:
        """Check if integration supports INSERT operations"""
        return self.capabilities in [IntegrationCapability.INSERT, IntegrationCapability.BOTH]
    
    def supports_upsert(self) -> bool:
        """Check if integration supports UPSERT operations"""
        return self.capabilities in [IntegrationCapability.UPSERT, IntegrationCapability.BOTH]
    
    # ===================================================================================
    # COMMON INTEGRATION METHODS (Shared across all integrations)
    # ===================================================================================
    
    def should_execute_endpoints(self) -> tuple[bool, str]:
        """
        Check if endpoint processing should execute based on organization status and environment
        
        Implements common business logic with integration-specific status configurations:
        - Uses allowed_execution_statuses property for integration-specific statuses
        - Status 16 (Resetting Data) always requires Reset_Mode for all integrations
        - SQL destinations are always blocked for all integrations
        
        Returns:
            tuple[bool, str]: (should_execute, reason)
        """
        try:
            # Get organization status
            org_status = self._get_organization_status()
            if org_status is None:
                return False, "Unable to retrieve organization status"
            
            # Get environment variables
            reset_mode = self._get_reset_mode()
            db_destination = self._get_db_destination()
            
            # Log execution check parameters (try both logging approaches for compatibility)
            log_msg = f"📊 Execution Check Parameters:"
            if hasattr(self, 'logger'):
                self.logger.info(log_msg)
                self.logger.info(f"   Organization Status: {org_status} ({self._get_status_description(org_status)})")
                self.logger.info(f"   Reset Mode: {reset_mode}")
                self.logger.info(f"   DB Destination: {db_destination}")
            else:
                print(log_msg)
                print(f"   Organization Status: {org_status} ({self._get_status_description(org_status)})")
                print(f"   Reset Mode: {reset_mode}")
                print(f"   DB Destination: {db_destination}")
            
            # Apply business logic using integration-specific allowed statuses
            allowed_statuses = self.allowed_execution_statuses
            status_check = (org_status in allowed_statuses) or (org_status == 16 and reset_mode)
            destination_check = db_destination != 'SQL'
            
            should_execute = status_check and destination_check
            
            # Generate detailed reason
            if not status_check:
                if org_status == 16 and not reset_mode:
                    reason = f"Organization status {org_status} (Resetting Data) requires Reset_Mode to be enabled"
                elif org_status not in allowed_statuses and org_status != 16:
                    status_desc = self._get_status_description(org_status)
                    allowed_descriptions = [f"{s} ({self._get_status_description(s)})" for s in allowed_statuses]
                    reason = f"Organization status {org_status} ({status_desc}) is not in allowed statuses: {allowed_descriptions} or 'Resetting Data' (16)"
                else:
                    reason = f"Organization status {org_status} is not valid for data processing"
            elif not destination_check:
                reason = f"Database destination '{db_destination}' is not supported (SQL destinations are blocked)"
            else:
                reason = "All execution prerequisites satisfied"
            
            execution_decision = "true" if should_execute else "false"
            result_msg = f"✅ Execution Decision: {execution_decision}"
            reason_msg = f"📝 Reason: {reason}"
            
            if hasattr(self, 'logger'):
                self.logger.info(result_msg)
                self.logger.info(reason_msg)
            else:
                print(result_msg)
                print(reason_msg)
            
            return should_execute, reason
            
        except Exception as e:
            error_msg = f"Error checking execution prerequisites: {str(e)}"
            if hasattr(self, 'logger'):
                self.logger.error(error_msg)
            else:
                print(f"❌ {error_msg}")
            
            # Add to error list if available
            if hasattr(self, 'error_list'):
                self.error_list.append(error_msg)
            
            return False, error_msg
    
    def update_last_refresh_date(self, refresh_status: str) -> None:
        """
        Update last refresh date and organization status
        
        Implements the common UpdateLastRefreshDate functionality from XEROBLUE - UPSERT.py
        using integration instance properties instead of global variables.
        
        Args:
            refresh_status: 'Pending', 'Failed', or 'Completed'
        """
        try:
            # Import required functions (lazy import to avoid circular dependencies)
            try:
                from dynamic_integrations.database.sql_helper import ExecuteEvaSP, ExecuteCMSSP
            except ImportError:
                # Fallback for testing environments
                if hasattr(self, 'logger'):
                    self.logger.warning("sql_helper functions not available - update_last_refresh_date will be skipped")
                else:
                    print("Warning: sql_helper functions not available - update_last_refresh_date will be skipped")
                return
            
            endpoint = 'ETANI'
            table_name = 'LastRefreshDate'
            prod_table = self.table_prefix_eva.replace('_' + str(self.etani_organisation_id), '') + table_name
            
            # Get error list if available
            error_list = getattr(self, 'error_list', [])
            
            if refresh_status == 'Pending':
                # Update production table RefreshStatus and client_service status to 15
                query = f"UPDATE {prod_table} SET RefreshStatus = '{refresh_status}' WHERE ClientID = '{self.etani_client_id}' AND OrganisationID = {self.etani_organisation_id}"
                ExecuteEvaSP(query, endpoint, error_list, True)
                
                query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 15 WHERE id = {self.etani_organisation_id}"
                ExecuteCMSSP(query, endpoint, error_list, True)
                
            elif refresh_status == 'Failed':
                # Update production table RefreshStatus to Failed (only if currently Pending)
                query = f"UPDATE {prod_table} SET RefreshStatus = '{refresh_status}' WHERE ClientID = '{self.etani_client_id}' AND OrganisationID = {self.etani_organisation_id} AND RefreshStatus = 'Pending'"
                ExecuteEvaSP(query, endpoint, error_list, True)
                
            elif refresh_status == 'Completed':
                # Update client_service LastRefreshDate and set status back to 1 (Active)
                query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 1 WHERE id = {self.etani_organisation_id}"
                ExecuteCMSSP(query, endpoint, error_list, True)
                
                query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 12 WHERE id = {self.etani_organisation_id}"
                ExecuteCMSSP(query, endpoint, error_list, True)
            
            # Log the update
            if hasattr(self, 'logger'):
                self.logger.info(f"📝 Updated last refresh date: {refresh_status}")
            else:
                print(f"📝 Updated last refresh date: {refresh_status}")
                
        except Exception as e:
            error_msg = f"Error updating last refresh date: {str(e)}"
            if hasattr(self, 'logger'):
                self.logger.error(error_msg)
            else:
                print(f"❌ {error_msg}")
            
            # Add to error list if available
            if hasattr(self, 'error_list'):
                self.error_list.append(error_msg)
    
    # ===================================================================================
    # HELPER METHODS FOR COMMON FUNCTIONALITY (Must be implemented by integrations)
    # ===================================================================================
    
    def _get_organization_status(self) -> Optional[int]:
        """
        Get organization status from cached value or CMS database
        
        This method should be implemented by each integration to return the
        current organization status from their CMS integration.
        
        Returns:
            Optional[int]: Organization status code or None if failed
        """
        # Default implementation - integrations should override this
        if hasattr(self, 'logger'):
            self.logger.warning("_get_organization_status not implemented - returning None")
        else:
            print("Warning: _get_organization_status not implemented - returning None")
        return None
    
    def _get_reset_mode(self) -> bool:
        """
        Get Reset_Mode from environment variable with flexible parsing
        
        Returns:
            bool: True if Reset_Mode is enabled, False otherwise
        """
        try:
            reset_mode_value = os.getenv('Reset_Mode', 'false')
            
            # Handle various boolean representations
            if isinstance(reset_mode_value, bool):
                return reset_mode_value
            elif isinstance(reset_mode_value, str):
                return reset_mode_value.lower() in ['true', '1', 'yes', 'on']
            else:
                return bool(reset_mode_value)
                
        except Exception as e:
            if hasattr(self, 'logger'):
                self.logger.warning(f"Error parsing Reset_Mode: {e}, defaulting to False")
            else:
                print(f"Warning: Error parsing Reset_Mode: {e}, defaulting to False")
            return False
    
    def _get_db_destination(self) -> str:
        """
        Get DB_Destination from environment variable
        
        Returns:
            str: Database destination (default 'EVA')
        """
        return os.getenv('DB_Destination', 'EVA')
    
    def _get_status_description(self, status: int) -> str:
        """
        Get human-readable description for organization status
        
        Returns:
            str: Status description
        """
        status_descriptions = {
            1: 'Active',
            2: 'Inactive',
            9: 'Provisioning New Data',
            12: 'Updating Data',
            13: 'Disconnected',
            15: 'In Progress',
            16: 'Resetting Data'
        }
        return status_descriptions.get(status, f'Unknown Status ({status})')
    
    def get_integration_metadata(self) -> Dict[str, Any]:
        """
        Get metadata about this integration
        
        Returns:
            Dict containing integration metadata
        """
        metadata = {
            'integration_name': self.integration_name,
            'capabilities': self.capabilities.value,
            'supports_insert': self.supports_insert(),
            'supports_upsert': self.supports_upsert(),
            'class_name': self.__class__.__name__,
            'module': self.__class__.__module__
        }
        
        # Add optional method availability
        optional_methods = [
            'create_sql_objects', 'initialize_indexes', 'upload_powerbi_template',
            'extract_api_response', 'get_endpoints_list'
        ]
        
        available_methods = []
        for method in optional_methods:
            if hasattr(self, method) and callable(getattr(self, method)):
                # Check if it's overridden (not the default implementation)
                method_func = getattr(self, method)
                if method_func.__qualname__ != f'BaseIntegration.{method}':
                    available_methods.append(method)
        
        metadata['optional_methods'] = available_methods
        
        # Add endpoint list if available
        try:
            endpoints = self.get_endpoints_list()
            if endpoints:
                metadata['available_endpoints'] = endpoints
        except:
            pass
        
        return metadata
    
    def __str__(self) -> str:
        """String representation of the integration"""
        return f"{self.integration_name} Integration ({self.capabilities.value})"
    
    def __repr__(self) -> str:
        """Detailed string representation"""
        return f"<{self.__class__.__name__}: {self.integration_name} ({self.capabilities.value})>"


# ===================================================================================
# INTEGRATION REGISTRY (Optional - for name-based lookups)
# ===================================================================================

class IntegrationRegistry:
    """
    Optional registry for name-based integration lookups.
    
    This allows for backward compatibility while maintaining the new
    integration-agnostic architecture.
    """
    
    _registry: Dict[str, type] = {}
    
    @classmethod
    def register(cls, name: str, integration_class: type):
        """
        Register an integration class with a name
        
        Args:
            name: Integration name (e.g., 'XEROBLUE')
            integration_class: Integration class that inherits from BaseIntegration
        """
        if not issubclass(integration_class, BaseIntegration):
            raise ValueError(f"Integration class must inherit from BaseIntegration")
        
        cls._registry[name.upper()] = integration_class
    
    @classmethod
    def create_integration(cls, name: str, config: Optional[Dict[str, Any]] = None) -> BaseIntegration:
        """
        Create an integration instance by name
        
        Args:
            name: Integration name
            config: Configuration dictionary
            
        Returns:
            BaseIntegration: Integration instance
            
        Raises:
            ValueError: If integration name is not registered
        """
        name = name.upper()
        if name not in cls._registry:
            available = list(cls._registry.keys())
            raise ValueError(f"Integration '{name}' not registered. Available: {available}")
        
        integration_class = cls._registry[name]
        return integration_class(config)
    
    @classmethod
    def list_integrations(cls) -> List[str]:
        """
        List all registered integration names
        
        Returns:
            List[str]: Registered integration names
        """
        return list(cls._registry.keys())
    
    @classmethod
    def is_registered(cls, name: str) -> bool:
        """
        Check if an integration is registered
        
        Args:
            name: Integration name
            
        Returns:
            bool: True if registered, False otherwise
        """
        return name.upper() in cls._registry


# ===================================================================================
# CONVENIENCE FUNCTIONS
# ===================================================================================

def validate_integration_interface(integration_instance: Any) -> bool:
    """
    Validate that an object implements the required integration interface
    
    Args:
        integration_instance: Object to validate
        
    Returns:
        bool: True if valid, False otherwise
    """
    if not isinstance(integration_instance, BaseIntegration):
        return False
    
    try:
        integration_instance._validate_required_interface()
        return True
    except (ValueError, NotImplementedError):
        return False


def get_integration_capabilities(integration_instance: BaseIntegration) -> Dict[str, bool]:
    """
    Get capabilities of an integration instance
    
    Args:
        integration_instance: Integration to check
        
    Returns:
        Dict with capability flags
    """
    return {
        'supports_insert': integration_instance.supports_insert(),
        'supports_upsert': integration_instance.supports_upsert(),
        'capabilities': integration_instance.capabilities.value
    }