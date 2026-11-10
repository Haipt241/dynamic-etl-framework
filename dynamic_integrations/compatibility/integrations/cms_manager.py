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
        }
        # Add more integrations as needed
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
            
            # Execute query
            df = ReadMySQLTable(query, endpoint, self.client_id, self.organisation_id, 
                              self.error_list, IsCMS=True)
            
            if not df.empty:
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
        """Build the CMS query for this integration"""
        return f"""
            SELECT 
                cs1.`Status`,
                JSON_UNQUOTE(JSON_EXTRACT(cs3.Details, '$.id')) AS PBIWorkspaceId,
                COUNT(cs2.id) AS OtherXeroRefreshes,
                CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')),'{self.client_number}') AS CHAR(10)) AS LegacyClientID,
                CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs1.Details, '$.Legacy.id')), '{self.organisation_id}') AS CHAR(10)) AS LegacyOrganisationID,
                c.accountingFirm as FirmID,
                CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs1.Details, '$.tenantId')), '') AS CHAR(100)) AS tenantId
            FROM client_service cs1
            INNER JOIN client c 
                ON cs1.`Client` = c.id
            INNER JOIN client_service cs3 
                ON cs1.`Client` = cs3.`Client`
                AND cs3.`Service` = {self.service_config['pbi_service']}
                AND cs3.`Status` NOT IN (0, 2, 13) 
            LEFT JOIN client_service cs2 
                ON cs1.`Client` = cs2.`Client`
                AND cs1.`Service` = cs2.`Service`
                AND cs1.id <> cs2.id 
                AND cs2.`Status` = 12
            WHERE cs1.`Service` = {self.service_config['main_service']}
                AND cs1.id = {self.organisation_id}
                AND cs1.`Client` = {self.client_number}
            GROUP BY cs1.`Status`, cs3.Details
        """
    
    def _parse_cms_results(self, df: pd.DataFrame, tenant_id: str = ''):
        """Parse CMS query results into standardized format"""
        try:
            row = df.iloc[0]
            
            self.cms_details.update({
                'status': int(row.get('Status', 0)),
                'legacy_client_id': self.client_id.replace(self.client_number, str(row.get('LegacyClientID', self.client_number))),
                'legacy_organisation_id': int(row.get('LegacyOrganisationID', 0)),
                'firm_id': int(row.get('FirmID', 0)) if row.get('FirmID') else 0,
                'tenant_id': str(row.get('tenantId', tenant_id)),
                'pbi_workspace_id': str(row.get('PBIWorkspaceId', '')),
                'other_xero_refreshes': int(row.get('OtherXeroRefreshes', 0)),
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


if __name__ == "__main__":
    # Run tests if executed directly
    test_cms_manager()