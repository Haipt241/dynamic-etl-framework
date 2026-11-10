"""
PowerBI Integration Wrapper

Class-based wrapper to integrate PowerBI functionality 
into the dynamic integration workflow.
"""

import logging
from typing import Optional, List, Dict, Any

from dynamic_integrations.database.sql_helper import ReadMySQLTable
from .powerbi_manager import PowerBIManager


class PowerBIIntegration:
    """
    PowerBI Integration wrapper class for dynamic integrations
    
    Provides high-level PowerBI operations for integration workflows.
    """
    
    def __init__(self, client_id: str, organisation_id: str, integration_name: str = "generic"):
        """
        Initialize PowerBI Integration
        
        Args:
            client_id: Etani Client ID
            organisation_id: Etani Organisation ID
            integration_name: Integration name (xero_blue, qbo, etc.)
        """
        self.client_id = client_id
        self.organisation_id = organisation_id
        self.integration_name = integration_name
        self.logger = logging.getLogger(f"PowerBIIntegration.{integration_name}")
        
        # Initialize PowerBI Manager
        self.pbi_manager = PowerBIManager(client_id, organisation_id, integration_name)
        self._workspace_id_cache = None
    
    def get_workspace_id(self, force_refresh: bool = False) -> Optional[str]:
        """
        Get PowerBI workspace ID from CMS (with caching)
        
        Args:
            force_refresh: Force refresh from CMS, ignore cache
            
        Returns:
            str: PowerBI workspace ID or None if not found
        """
        if not force_refresh and self._workspace_id_cache:
            return self._workspace_id_cache
        
        try:
            workspace_id = self._get_workspace_id_from_cms()
            
            if workspace_id:
                self._workspace_id_cache = workspace_id
                self.logger.info(f"Got workspace ID from CMS: {workspace_id}")
            else:
                self.logger.warning("Could not retrieve workspace ID from CMS")
            
            return workspace_id
            
        except Exception as e:
            self.logger.error(f"Error getting workspace ID: {e}")
            return None
    
    def _get_workspace_id_from_cms(self) -> Optional[str]:
        """
        Get PowerBI workspace ID from CMS database
        
        Returns:
            str: PowerBI workspace ID or None if not found
        """
        try:
            client_number = self.client_id
            if 'CLIENT' in self.client_id:
                client_number = self.client_id[self.client_id.find('CLIENT') + len('CLIENT'):]
            
            query = f'''
                SELECT 
                    JSON_UNQUOTE(JSON_EXTRACT(cs3.Details, '$.id')) AS PBIWorkspaceId
                FROM client_service cs1
                INNER JOIN client_service cs3 
                    ON cs1.Client = cs3.Client
                    AND cs3.Service = 3
                    AND cs3.Status NOT IN (0, 2, 13) 
                WHERE cs1.Service = 4
                    AND cs1.id = '{self.organisation_id}'
                    AND cs1.Client = '{client_number}'
                GROUP BY cs3.Details
                LIMIT 1
            '''
            
            # Query CMS database
            df = ReadMySQLTable(query, 'PowerBI_CMS', self.client_id, self.organisation_id, [], IsCMS=True)
            
            if not df.empty and 'PBIWorkspaceId' in df.columns:
                workspace_id = df.loc[0, 'PBIWorkspaceId']
                if workspace_id and workspace_id != 'null':
                    return str(workspace_id)
            
            self.logger.warning(f"No PowerBI workspace ID found in CMS for client {client_number}, org {self.organisation_id}")
            return None
            
        except Exception as e:
            self.logger.error(f"Error querying CMS for workspace ID: {e}")
            return None
    
    def upload_template(self, workspace_id: str = None, 
                       template_path: str = None,
                       dataset_name: str = None) -> bool:
        """
        Upload PowerBI template for integration
        
        Args:
            workspace_id: PowerBI workspace ID (auto-detected if not provided)
            template_path: Path to PBIX template (auto-detected if not provided)
            dataset_name: Name for the dataset
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self.logger.info(f"Starting PowerBI template upload for {self.integration_name}")
            
            # Get workspace ID if not provided
            if not workspace_id:
                workspace_id = self.get_workspace_id()
                if not workspace_id:
                    self.logger.error("Could not determine PowerBI workspace ID")
                    return False
            
            # Get template path if not provided
            if not template_path:
                template_path = self.pbi_manager.get_template_path()
            
            # Upload template
            success = self.pbi_manager.upload_template(template_path, workspace_id, dataset_name)
            
            if success:
                self.logger.info(f"✅ PowerBI template uploaded successfully")
            else:
                self.logger.error(f"❌ PowerBI template upload failed")
            
            return success
            
        except Exception as e:
            self.logger.error(f"❌ PowerBI template upload error: {e}")
            return False
    
    def refresh_dataset(self, workspace_id: str = None,
                       dataset_patterns: List[str] = None,
                       check_other_refreshes: bool = True) -> bool:
        """
        Refresh PowerBI dataset for integration
        
        Args:
            workspace_id: PowerBI workspace ID (auto-detected if not provided)
            dataset_patterns: Dataset name patterns to search for
            check_other_refreshes: Whether to check for other running refreshes
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self.logger.info(f"Starting PowerBI dataset refresh for {self.integration_name}")
            
            # Get workspace ID if not provided
            if not workspace_id:
                workspace_id = self.get_workspace_id()
                if not workspace_id:
                    self.logger.error("Could not determine PowerBI workspace ID")
                    return False
            
            # Refresh dataset
            success = self.pbi_manager.refresh_dataset(
                workspace_id=workspace_id,
                name_patterns=dataset_patterns,
                check_other_refreshes=check_other_refreshes
            )
            
            if success:
                self.logger.info(f"✅ PowerBI dataset refresh completed successfully")
            else:
                self.logger.error(f"❌ PowerBI dataset refresh failed")
            
            return success
            
        except Exception as e:
            self.logger.error(f"❌ PowerBI dataset refresh error: {e}")
            return False
    
    def validate_config(self) -> bool:
        """
        Validate PowerBI configuration for this integration
        
        Returns:
            bool: True if config is valid, False otherwise
        """
        try:
            self.logger.info(f"Validating PowerBI configuration for {self.integration_name}")
            
            # Test authentication
            if self.pbi_manager.authenticate():
                self.logger.info("✅ PowerBI configuration is valid")
                return True
            else:
                self.logger.error("❌ PowerBI authentication failed - check configuration")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ PowerBI configuration validation error: {e}")
            return False
    
    def get_workspace_info(self, workspace_id: str = None) -> Optional[Dict[str, Any]]:
        """
        Get PowerBI workspace information
        
        Args:
            workspace_id: PowerBI workspace ID (auto-detected if not provided)
            
        Returns:
            Dict with workspace info or None if failed
        """
        try:
            # Get workspace ID if not provided
            if not workspace_id:
                workspace_id = self.get_workspace_id()
                if not workspace_id:
                    return None
            
            return self.pbi_manager.get_workspace_info(workspace_id)
            
        except Exception as e:
            self.logger.error(f"Error getting workspace info: {e}")
            return None
    
    def get_datasets(self, workspace_id: str = None) -> Optional[List[Dict[str, Any]]]:
        """
        Get datasets in PowerBI workspace
        
        Args:
            workspace_id: PowerBI workspace ID (auto-detected if not provided)
            
        Returns:
            List of datasets or None if failed
        """
        try:
            # Get workspace ID if not provided
            if not workspace_id:
                workspace_id = self.get_workspace_id()
                if not workspace_id:
                    return None
            
            return self.pbi_manager.get_datasets(workspace_id)
            
        except Exception as e:
            self.logger.error(f"Error getting datasets: {e}")
            return None


# Helper functions for backward compatibility and simple usage
def upload_powerbi_template(client_id: str, organisation_id: str, 
                           integration_name: str = "generic",
                           workspace_id: str = None, 
                           template_path: str = None,
                           dataset_name: str = None) -> bool:
    """Function wrapper for PowerBI template upload"""
    pbi_integration = PowerBIIntegration(client_id, organisation_id, integration_name)
    return pbi_integration.upload_template(workspace_id, template_path, dataset_name)


def refresh_powerbi_dataset(client_id: str, organisation_id: str,
                           integration_name: str = "generic", 
                           workspace_id: str = None,
                           dataset_patterns: List[str] = None,
                           check_other_refreshes: bool = True) -> bool:
    """Function wrapper for PowerBI dataset refresh"""
    pbi_integration = PowerBIIntegration(client_id, organisation_id, integration_name)
    return pbi_integration.refresh_dataset(workspace_id, dataset_patterns, check_other_refreshes)


def validate_powerbi_config(integration_name: str = "generic") -> bool:
    """Function wrapper for PowerBI config validation"""
    pbi_integration = PowerBIIntegration("TEST", "TEST", integration_name)
    return pbi_integration.validate_config()


# Backward compatibility functions (matching original XERO function names)
def UploadPBITemplate(client_id: str, organisation_id: str, base_currency: str = "AUD", integration_name: str = "xero_blue"):
    """Backward compatibility wrapper for UploadPBITemplate"""
    return upload_powerbi_template(
        client_id=client_id,
        organisation_id=organisation_id,
        integration_name=integration_name
    )


def RefreshPBIDataset(client_id: str, organisation_id: str, integration_name: str = "xero_blue"):
    """Backward compatibility wrapper for RefreshPBIDataset"""
    return refresh_powerbi_dataset(
        client_id=client_id,
        organisation_id=organisation_id,
        integration_name=integration_name
    )