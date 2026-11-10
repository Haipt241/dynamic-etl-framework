"""
Generic CMS Manager - Integration Agnostic
Provides CMS details retrieval functionality that can be used by any integration.
"""

import os
import pandas as pd
from datetime import datetime
from typing import Dict, Any, Optional
from sqlalchemy.exc import SQLAlchemyError, ProgrammingError


class CMSManager:
    """
    Generic CMS Manager that can retrieve CMS details for any integration.
    This class abstracts the CMS operations to be integration-agnostic.
    """
    
    # Service type mappings for different integrations
    SERVICE_MAPPINGS = {
        'XEROBLUE': {
            'main_service': 1,
            'pbi_service': 3
        },
        'QBO': {
            'main_service': 4,
            'pbi_service': 3
        },
        'MYOB': {
            'main_service': 2,  # Assuming MYOB uses service 2
            'pbi_service': 3
        },
        # Generated integrations mappings
        'CIN7': {
            'main_service': 27,  # Cin7
            'pbi_service': 3
        },
        'CIN7_DEAR': {
            'main_service': 14,  # Dear Inventory
            'pbi_service': 3
        },
        'DEPUTY': {
            'main_service': 23,  # Deputy
            'pbi_service': 3
        },
        'DQ_MYOBAR': {
            'main_service': 7,   # MYOB Business
            'pbi_service': 3
        },
        'FYI': {
            'main_service': 72,  # FYI Elite
            'pbi_service': 3
        },
        'HUBSPOT': {
            'main_service': 9,   # Hubspot - CRM
            'pbi_service': 3
        },
        'KARBON_HQ': {
            'main_service': 50,  # Karbon
            'pbi_service': 3
        },
        'KEYPAY': {
            'main_service': 57,  # KeyPay
            'pbi_service': 3
        },
        'MYOB_DETAILED': {
            'main_service': 71,  # MYOB Business - DETAILED
            'pbi_service': 3
        },
        'PAYROLL_AU': {
            'main_service': 21,  # Xero Payroll
            'pbi_service': 3
        },
        'PAYROLL_NZ': {
            'main_service': 21,  # Xero Payroll
            'pbi_service': 3
        },
        'SHOPIFY': {
            'main_service': 38,  # Shopify
            'pbi_service': 3
        },
        'SIMPRO': {
            'main_service': 16,  # SimPro
            'pbi_service': 3
        },
        'TIDYWORK': {
            'main_service': 62,  # TidyWork
            'pbi_service': 3
        },
        'UNLEASHED': {
            'main_service': 17,  # Unleashed
            'pbi_service': 3
        },
        'VINSIGHT': {
            'main_service': 43,  # Vinsight
            'pbi_service': 3
        },
        'WFM': {
            'main_service': 69,  # WorkflowMax Bluerock
            'pbi_service': 3
        },
        'XEROPROJECT': {
            'main_service': 25,  # Xero Projects
            'pbi_service': 3
        }
        # Note: jobman not in provided mapping
    }
    
    def __init__(self, integration_name: str, client_id: str, organisation_id: str, 
                 error_list: list, job_id: str = None, job_run_id: str = None):
        """
        Initialize CMS Manager for specific integration
        
        Args:
            integration_name: Name of the integration (e.g., 'XEROBLUE', 'QBO')
            client_id: Etani Client ID
            organisation_id: Etani Organisation ID
            error_list: List to append errors to
            job_id: Optional job ID for logging
            job_run_id: Optional job run ID for logging
        """
        self.integration_name = integration_name.upper()
        self.client_id = client_id
        self.organisation_id = organisation_id
        self.error_list = error_list
        self.job_id = job_id
        self.job_run_id = job_run_id
        
        # Extract client number from client ID
        self.client_number = self._extract_client_number(client_id)
        
        # Get service mappings for this integration
        self.service_config = self.SERVICE_MAPPINGS.get(
            self.integration_name, 
            self.SERVICE_MAPPINGS['XEROBLUE']  # Default fallback
        )
        
        # Initialize result variables
        self.cms_details = {}
        self._reset_cms_values()
    
    def _extract_client_number(self, client_id: str) -> str:
        """Extract numeric client number from client ID"""
        if not client_id or 'CLIENT' not in client_id:
            return ''
        return client_id[client_id.find('CLIENT') + len('CLIENT'):]
    
    def _reset_cms_values(self):
        """Reset CMS values to defaults"""
        self.cms_details = {
            'status': 0,
            'legacy_client_id': '',
            'legacy_organisation_id': 0,
            'firm_id': 0,
            'tenant_id': '',
            'pbi_workspace_id': '',
            'other_xero_refreshes': 0,
            'org_status': 0
        }
    
    def get_cms_details(self, tenant_id: str = '') -> Dict[str, Any]:
        """
        Get CMS details for the configured integration
        
        Args:
            tenant_id: Optional tenant ID (for integrations that use it)
            
        Returns:
            Dictionary containing CMS details
        """
        try:
            # Import ReadMySQLTable function
            from dynamic_integrations.database.sql_helper import ReadMySQLTable
            
            query = self._build_cms_query()
            endpoint = 'ETANI'
            
            print(f"🔍 Retrieving CMS details for {self.integration_name}")
            print(f"   Client: {self.client_id} | Org: {self.organisation_id}")
            print(f"   Services: Main={self.service_config['main_service']}, PBI={self.service_config['pbi_service']}")
            
            # Add debugging for database connection
            import config
            use_aws = os.getenv('USE_AWS_DB', 'False').lower() in ('true', '1', 'yes')
            print(f"🔍 Database Connection Debug:")
            if use_aws:
                print(f"   Database: AWS RDS Aurora (vibedb_cms)")
                print(f"   Host: {config.AWS_RDS_HOST}")
                print(f"   SSL: AWS Certificate Authority (built-in)")
            else:
                print(f"   Database: Azure MySQL (DEPRECATED)")
                print(f"   SSL Cert Path: {config.MYSQL_SERVER_SSL_CERT if hasattr(config, 'MYSQL_SERVER_SSL_CERT') else 'N/A'}")
                if hasattr(config, 'MYSQL_SERVER_SSL_CERT'):
                    print(f"   SSL Cert Exists: {os.path.exists(config.MYSQL_SERVER_SSL_CERT)}")
            
            # Execute query
            print(f"🔍 Executing CMS query...")
            print(f"🔍 Query being executed:")
            print(query)
            print(f"🔍 Expected: cs1.id=7102 should return Status=12")

            df = ReadMySQLTable(query, endpoint, self.client_id, self.organisation_id,
                              self.error_list, IsCMS=True, integration_name=self.integration_name)

            # DEBUG: Show raw query result
            if df is not None and not df.empty:
                print(f"🔍 RAW QUERY RESULT:")
                print(df.to_string())
                print(f"🔍 Status column value: {df['Status'].iloc[0] if 'Status' in df.columns else 'MISSING'}")
            elif df is None:
                print(f"❌ Query returned None - check SQL error logs")
            else:
                print(f"⚠️  Query returned empty dataframe")

            if not df.empty if df is not None else False:
                # Parse results
                self._parse_cms_results(df, tenant_id)
                print(f"✅ CMS Details Retrieved for {self.integration_name}:")
                self._log_cms_details()
                return self.cms_details
            else:
                print(f"⚠️  No CMS details found for {self.integration_name} - using defaults")
                return self.cms_details
                
        except SQLAlchemyError as sqlerr:
            self._handle_sqlalchemy_error(sqlerr)
            return self.cms_details
            
        except ProgrammingError as perr:
            self._handle_programming_error(perr)
            return self.cms_details
            
        except Exception as e:
            self._handle_general_error(e)
            return self.cms_details
    
    def _build_cms_query(self) -> str:
        """Build the CMS query for this integration - SIMPLIFIED"""
        # Direct query - no subqueries, minimal JSON extraction
        # PBI workspace comes from separate Service=3 record, not from this integration's record
        return f'''
            SELECT
                cs1.Status,
                cs1.id as ClientServiceID,
                cs1.Client as ClientID,
                cs1.AccountingFirm as FirmID
            FROM vibedb_cms.client_service cs1
            WHERE cs1.Service = {self.service_config['main_service']}
                AND cs1.id = {self.organisation_id}
        '''
    
    def _parse_cms_results(self, df: pd.DataFrame, tenant_id: str = ''):
        """Parse CMS query results into standardized format"""
        try:
            row = df.iloc[0]

            self.cms_details.update({
                'status': int(row.get('Status', 0)),
                'client_service_id': int(row.get('ClientServiceID', 0)),
                'client_id': int(row.get('ClientID', 0)),
                'legacy_client_id': self.client_id.replace(self.client_number, str(row.get('LegacyClientID', self.client_number))),
                'legacy_organisation_id': int(row.get('LegacyOrganisationID', 0)),
                'firm_id': int(row.get('FirmID', 0)) if row.get('FirmID') else 0,
                'tenant_id': str(row.get('tenantId', tenant_id)) if row.get('tenantId') else tenant_id,
                'pbi_workspace_id': str(row.get('PBIWorkspaceId', '') if row.get('PBIWorkspaceId') else ''),
                'other_xero_refreshes': 0,  # Removed from query - not needed
                'org_status': int(row.get('Status', 0))
            })
            
            # Update tenant_id if provided by CMS and not empty
            cms_tenant_id = self.cms_details['tenant_id']
            if cms_tenant_id and cms_tenant_id.strip():
                self.cms_details['tenant_id'] = cms_tenant_id
            elif tenant_id:
                self.cms_details['tenant_id'] = tenant_id
                
        except Exception as e:
            print(f"❌ Error parsing CMS results: {str(e)}")
            self.error_list.append(f"Error parsing CMS results for {self.integration_name}: {str(e)}")
    
    def _log_cms_details(self):
        """Log retrieved CMS details"""
        details = self.cms_details
        print(f"  Organization Status: {details['org_status']}")
        print(f"  Client Service ID (cs1.id): {details.get('client_service_id', 'N/A')}")
        print(f"  Client ID (cs1.Client): {details.get('client_id', 'N/A')}")
        print(f"  Legacy Client ID: {details['legacy_client_id']}")
        print(f"  Legacy Organization ID: {details['legacy_organisation_id']}")
        print(f"  Firm ID: {details['firm_id']}")
        print(f"  Tenant ID: {details['tenant_id']}")
        print(f"  PBI Workspace ID: {details['pbi_workspace_id']}")
    
    def _handle_sqlalchemy_error(self, sqlerr):
        """Handle SQLAlchemy errors"""
        self._reset_cms_values()
        error_msg = f"MySQL SQLAlchemy Error in GetCMSDetails for {self.integration_name}: {str(sqlerr)}"
        print(f"❌ {error_msg}")
        self.error_list.append(error_msg)
        self._log_error(error_msg, f"MySQL Error: {sqlerr}, Endpoint: GetCMSDetails")
    
    def _handle_programming_error(self, perr):
        """Handle Programming errors"""
        self._reset_cms_values()
        error_msg = f"MySQL Programming Error in GetCMSDetails for {self.integration_name}: {str(perr)}"
        print(f"❌ {error_msg}")
        self.error_list.append(error_msg)
        self._log_error(error_msg, f"MySQL Error: {perr}, Endpoint: GetCMSDetails")
    
    def _handle_general_error(self, e):
        """Handle general errors"""
        self._reset_cms_values()
        error_msg = f"General Error getting CMS details for {self.integration_name}: {str(e)}"
        print(f"❌ {error_msg}")
        self.error_list.append(error_msg)
        self._log_error(error_msg, f"MySQL Error: {str(e)}, Endpoint: GetCMSDetails")
    
    def _log_error(self, error_msg: str, remarks: str):
        """Log error using available logging functions"""
        try:
            # Try to import and use logging functions
            from dynamic_integrations.database.sql_helper import LoggingDetails, update_container_logs
            
            # Log the error
            if self.job_id and self.job_run_id:
                LoggingDetails("GetCMSDetails", error_msg, self.job_id, self.job_run_id, self.error_list)
            
            # Update container logs
            params = {
                "p_integration": self.integration_name,
                "p_organisation_id": self.organisation_id,
                "p_client_id": self.client_number,
                "p_firm_id": self.cms_details.get('firm_id', 0),
                "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_status": "Failed",
                "p_log_id": os.getenv('log_id', ''),
                "p_remarks": remarks
            }
            update_container_logs(params)
            
        except ImportError:
            # Logging functions not available
            print(f"Warning: Could not import logging functions for error: {error_msg}")
        except Exception as log_err:
            print(f"Warning: Error in logging: {str(log_err)}")
    
    def get_legacy_client_id_for_transactions(self) -> str:
        """
        Get properly formatted legacy client ID for transactions endpoint
        Some integrations need special formatting for certain endpoints
        """
        legacy_client_id = self.cms_details.get('legacy_client_id', '')
        if 'CLIENT' in legacy_client_id:
            return legacy_client_id.replace('CLIENT', '')
        return self.client_number
    
    def validate_cms_details(self) -> bool:
        """Validate that CMS details were retrieved successfully"""
        details = self.cms_details
        
        required_fields = ['legacy_organisation_id', 'firm_id']
        
        for field in required_fields:
            if not details.get(field):
                print(f"⚠️  Warning: {field} not found in CMS details")
                return False
        
        print(f"✅ CMS details validation passed for {self.integration_name}")
        return True
    
    @classmethod
    def add_integration_mapping(cls, integration_name: str, main_service: int, pbi_service: int = 3):
        """
        Add a new integration mapping to the service mappings
        
        Args:
            integration_name: Name of the integration
            main_service: Main service ID for this integration
            pbi_service: PBI service ID (defaults to 3)
        """
        cls.SERVICE_MAPPINGS[integration_name.upper()] = {
            'main_service': main_service,
            'pbi_service': pbi_service
        }
        print(f"✅ Added service mapping for {integration_name}: Main={main_service}, PBI={pbi_service}")
    
    @classmethod
    def get_supported_integrations(cls) -> list:
        """Get list of supported integrations"""
        return list(cls.SERVICE_MAPPINGS.keys())


# Convenience functions for backward compatibility and easy usage

def get_cms_details_for_integration(integration_name: str, client_id: str, organisation_id: str, 
                                   error_list: list, tenant_id: str = '', 
                                   job_id: str = None, job_run_id: str = None) -> Dict[str, Any]:
    """
    Convenience function to get CMS details for any integration
    
    Args:
        integration_name: Name of the integration (e.g., 'XEROBLUE', 'QBO')
        client_id: Etani Client ID
        organisation_id: Etani Organisation ID
        error_list: List to append errors to
        tenant_id: Optional tenant ID
        job_id: Optional job ID for logging
        job_run_id: Optional job run ID for logging
        
    Returns:
        Dictionary containing CMS details
    """
    cms_manager = CMSManager(integration_name, client_id, organisation_id, error_list, job_id, job_run_id)
    return cms_manager.get_cms_details(tenant_id)


def test_cms_manager():
    """
    Test function to verify CMS Manager works with different integrations
    """
    print("🧪 Testing CMS Manager with different integrations...")
    
    # Test data
    test_client_id = os.getenv('EtaniClientID', 'TEST_CLIENT123')
    test_org_id = os.getenv('EtaniOrganisationID', '456')
    test_errors = []
    
    # Test supported integrations
    for integration in CMSManager.get_supported_integrations():
        print(f"\n--- Testing {integration} ---")
        
        cms_manager = CMSManager(integration, test_client_id, test_org_id, test_errors)
        
        # Test query building
        query = cms_manager._build_cms_query()
        print(f"✅ Query built successfully for {integration}")
        print(f"   Main Service: {cms_manager.service_config['main_service']}")
        print(f"   PBI Service: {cms_manager.service_config['pbi_service']}")
        
        # Test service mapping
        assert cms_manager.service_config['main_service'] is not None
        assert cms_manager.service_config['pbi_service'] is not None
        
    print(f"\n✅ All integration tests passed!")
    print(f"   Supported integrations: {CMSManager.get_supported_integrations()}")
    
    # Test adding new integration
    CMSManager.add_integration_mapping('CUSTOM_TEST', 99, 3)
    assert 'CUSTOM_TEST' in CMSManager.get_supported_integrations()
    print("✅ Dynamic integration mapping test passed!")


# ==================== UTILITY FUNCTIONS ====================

def update_cms_status(organisation_id: str, status: int, client_id: str = None, error_list: list = None) -> Dict[str, Any]:
    """
    Update CMS status for organisation
    
    Args:
        organisation_id: Organisation ID
        status: Status code (1=Active, 13=Disconnected, 15=Pending, 12=Updating)
        client_id: Client ID (optional, needed for status updates with client constraint)
        error_list: Error list to append to (optional)
    
    Returns:
        Dict with success status and message
    """
    try:
        from dynamic_integrations.database.sql_helper import ExecuteCMSSP
        
        if error_list is None:
            error_list = []
        
        # Status mappings for logging
        status_names = {
            1: 'Active',
            12: 'Updating Data', 
            13: 'Disconnected',
            15: 'Pending',
            16: 'Resetting Data'
        }
        
        # Build appropriate query based on whether client_id is provided
        if client_id:
            # For operations that require client constraint (like INSERT completion)
            query = f'UPDATE etaniv2.client_service SET `Status` = {status} WHERE id = {organisation_id} and client = {client_id}'
        else:
            # For general status updates (like token failures)
            query = f'UPDATE client_service SET status = {status} WHERE Id = {organisation_id}'
        
        # Execute CMS status update
        ExecuteCMSSP(query, 'UPDATE_CMS_STATUS', error_list, True)
        
        status_name = status_names.get(status, str(status))
        success_msg = f"✅ Updated CMS status to {status_name} ({status}) for Organisation {organisation_id}"
        if client_id:
            success_msg += f", Client {client_id}"
        
        print(success_msg)
        
        return {
            'success': True,
            'message': success_msg,
            'status': status,
            'status_name': status_name
        }
        
    except Exception as e:
        error_msg = f'Error updating CMS status to {status} for Organisation {organisation_id}: {str(e)}'
        print(f"❌ {error_msg}")
        if error_list:
            error_list.append(error_msg)
        
        return {
            'success': False,
            'error': error_msg,
            'status': status
        }


def check_cms_status_for_provisioning(client_id: str, organisation_id: str, integration_name: str = 'FYI', 
                                     error_list: list = None) -> Dict[str, Any]:
    """
    Check if CMS status = 9 (Provisioning New Data) OR 12 (Updating Data) before proceeding with integration

    Args:
        client_id: Etani Client ID (e.g., 'BIGOLESHOECOMPANY_CLIENT2034')
        organisation_id: Organisation ID
        integration_name: Integration name for logging (default: 'FYI')
        error_list: Error list to append to (optional)

    Returns:
        Dict with success status, CMS data, and error details
    """
    try:
        if error_list is None:
            error_list = []
        
        # Status mappings
        status_names = {
            1: 'Active',
            2: 'Inactive',
            9: 'Provisioning New Data',
            12: 'Updating Data',
            13: 'Disconnected',
            15: 'Refreshing Data',
            16: 'Resetting Data'
        }
        
        print(f"📋 Checking CMS status for {integration_name} integration...")
        
        # Get CMS details using existing utility function  
        cms_result = get_cms_details_for_integration(
            integration_name=integration_name,
            client_id=client_id,
            organisation_id=organisation_id,
            error_list=error_list
        )
        
        # Check if cms_result is empty or has error
        if not cms_result or 'org_status' not in cms_result:
            error_msg = f"Failed to get CMS details or missing org_status in response"
            print(f"❌ {error_msg}")
            return {
                'success': False,
                'error': error_msg,
                'can_proceed': False
            }
        
        # Extract status from CMS data (direct access)
        org_status = cms_result.get('org_status')
        if org_status is None:
            error_msg = "CMS status not found in response"
            print(f"❌ {error_msg}")
            return {
                'success': False,
                'error': error_msg,
                'can_proceed': False
            }
        
        status_name = status_names.get(org_status, str(org_status))
        print(f"📊 Current CMS Status: {status_name} ({org_status})")

        # DUPLICATE DETECTION: Check if Status == 15 (already running)
        if org_status == 15:
            duplicate_msg = f"⚠️ DUPLICATE DETECTED: Org {organisation_id} already has Status 15 (Refreshing Data - running)"
            print(duplicate_msg)
            print("   Another container is already processing. Exiting to prevent token conflicts.")
            return {
                'success': True,  # Successfully got status, but detected duplicate
                'message': duplicate_msg,
                'can_proceed': False,
                'duplicate': True,  # Special flag for duplicate detection
                'status': org_status,
                'status_name': status_name,
                'cms_data': cms_result.get('data', {})
            }

        # Check status based on Xero UPSERT logic:
        # - Status 1 (Active - Lambda scheduled) - UPSERT mode
        # - Status 9 (Provisioning New Data) - INSERT mode
        # - Status 12 (Updating Data) - Manual refresh UPSERT mode
        if org_status in [1, 9, 12]:
            success_msg = f"✅ CMS status check passed - {status_name}. Integration can proceed."
            print(success_msg)
            return {
                'success': True,
                'message': success_msg,
                'can_proceed': True,
                'status': org_status,
                'status_name': status_name,
                'cms_data': cms_result.get('data', {})
            }
        else:
            error_msg = f"❌ Integration cannot proceed. CMS status is '{status_name}' (Expected: Active (1), Provisioning New Data (9), or Updating Data (12))"
            print(error_msg)
            return {
                'success': True,  # Successfully got status, but can't proceed
                'message': error_msg,
                'can_proceed': False,
                'status': org_status,
                'status_name': status_name,
                'cms_data': cms_result.get('data', {})
            }
            
    except Exception as e:
        error_msg = f"CMS status check failed: {str(e)}"
        print(f"❌ {error_msg}")
        if error_list:
            error_list.append(error_msg)
        
        return {
            'success': False,
            'error': error_msg,
            'can_proceed': False
        }


# Convenience functions for common status updates
def set_cms_active(organisation_id: str, client_id: str, error_list: list = None) -> Dict[str, Any]:
    """Set CMS status to Active (1)"""
    return update_cms_status(organisation_id, 1, client_id, error_list)


def set_cms_disconnected(organisation_id: str, error_list: list = None) -> Dict[str, Any]:
    """Set CMS status to Disconnected (13)"""
    return update_cms_status(organisation_id, 13, None, error_list)


def set_cms_updating(organisation_id: str, error_list: list = None) -> Dict[str, Any]:
    """Set CMS status to Updating (12)"""
    return update_cms_status(organisation_id, 12, None, error_list)


if __name__ == "__main__":
    # Run tests if executed directly
    test_cms_manager()