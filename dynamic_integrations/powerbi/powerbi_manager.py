"""
PowerBI Manager

Unified PowerBI integration manager for dynamic integrations.
Extracted from XERO files and refactored into reusable class.
"""

import os
import json
import logging
import requests
import pandas as pd
import time
from typing import Dict, Any, Optional, List


class PowerBIManager:
    """
    PowerBI Manager for handling template uploads and dataset refreshes.
    
    Supports all integrations with configurable templates and workspace management.
    """
    
    def __init__(self, client_id: str, organisation_id: str, integration_name: str = "generic"):
        """
        Initialize PowerBI Manager
        
        Args:
            client_id: Etani Client ID
            organisation_id: Etani Organisation ID  
            integration_name: Integration name for template selection
        """
        self.client_id = client_id
        self.organisation_id = organisation_id
        self.integration_name = integration_name.lower()
        self.logger = logging.getLogger(f"PowerBIManager.{integration_name}")
        
        # Load PowerBI configuration
        self.config = self._load_config()
        self.pbi_config = self.config['powerbi']
        
        # PowerBI credentials
        self.base_url = self.pbi_config['base_url']
        self.api_base_url = self.pbi_config['api_base_url']
        self.username = self.pbi_config['username']
        self.password = self.pbi_config['password']
        self.client_id_pbi = self.pbi_config['client_id']
        self.client_secret = self.pbi_config['client_secret']
        self.scope = self.pbi_config['scope']
        
        # Cached access token
        self.access_token = None
        
    def _load_config(self) -> Dict[str, Any]:
        """Load PowerBI configuration from JSON file"""
        config_path = os.path.join(os.path.dirname(__file__), 'config', 'powerbi_config.json')
        try:
            with open(config_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            self.logger.error(f"PowerBI config file not found: {config_path}")
            return self._get_default_config()
        except json.JSONDecodeError as e:
            self.logger.error(f"Error parsing PowerBI config: {e}")
            return self._get_default_config()
    
    def _get_default_config(self) -> Dict[str, Any]:
        """Fallback default configuration"""
        return {
            "powerbi": {
                "base_url": "REDACTED",
                "api_base_url": "https://api.powerbi.com/v1.0/myorg",
                "username": "REDACTED",
                "password": "REDACTED",
                "scope": "https://analysis.windows.net/powerbi/api",
                "client_id": "REDACTED",
                "client_secret": "REDACTED"
            },
            "dataset_patterns": {
                "generic": {
                    "name_contains": ["MASTER"],
                    "template_path": "pbix/GENERIC-MASTER-TEMPLATE.pbix"
                }
            }
        }
    
    def authenticate(self) -> bool:
        """
        Authenticate with PowerBI and get access token
        
        Returns:
            bool: True if authentication successful, False otherwise
        """
        try:
            self.logger.info("Authenticating with PowerBI...")
            
            response = requests.post(
                self.base_url,
                data={
                    'grant_type': 'password',
                    'username': self.username,
                    'password': self.password,
                    'resource': self.scope,
                    'client_id': self.client_id_pbi,
                    'client_secret': self.client_secret
                }
            )
            
            if response.status_code == 200:
                json_response = response.json()
                self.access_token = json_response['access_token']
                self.logger.info("✅ PowerBI authentication successful")
                return True
            else:
                self.logger.error(f"❌ PowerBI authentication failed: {response.status_code}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ PowerBI authentication error: {e}")
            return False
    
    def get_workspace_info(self, workspace_id: str) -> Optional[Dict[str, Any]]:
        """
        Get PowerBI workspace information
        
        Args:
            workspace_id: PowerBI workspace ID
            
        Returns:
            Dict with workspace info or None if failed
        """
        if not self.access_token:
            if not self.authenticate():
                return None
        
        try:
            url = f"{self.api_base_url}/groups/{workspace_id}"
            headers = {'Authorization': f'Bearer {self.access_token}'}
            
            response = requests.get(url, headers=headers)
            
            if response.status_code == 200:
                return response.json()
            else:
                self.logger.error(f"Failed to get workspace info: {response.status_code}")
                return None
                
        except Exception as e:
            self.logger.error(f"Error getting workspace info: {e}")
            return None
    
    def get_datasets(self, workspace_id: str) -> Optional[List[Dict[str, Any]]]:
        """
        Get datasets in PowerBI workspace
        
        Args:
            workspace_id: PowerBI workspace ID
            
        Returns:
            List of datasets or None if failed
        """
        if not self.access_token:
            if not self.authenticate():
                return None
        
        try:
            url = f"{self.api_base_url}/groups/{workspace_id}/datasets"
            headers = {'Authorization': f'Bearer {self.access_token}'}
            
            self.logger.info(f"Getting datasets from workspace: {workspace_id}")
            response = requests.get(url, headers=headers)
            
            if response.status_code == 200:
                json_response = response.json()
                self.logger.debug(f"Datasets response: {json_response}")
                return json_response.get('value', [])
            else:
                self.logger.error(f"Failed to get datasets: {response.status_code}")
                return None
                
        except Exception as e:
            self.logger.error(f"Error getting datasets: {e}")
            return None
    
    def find_dataset_by_pattern(self, workspace_id: str, name_patterns: List[str] = None) -> Optional[Dict[str, Any]]:
        """
        Find dataset by name patterns
        
        Args:
            workspace_id: PowerBI workspace ID
            name_patterns: List of strings that dataset name should contain
            
        Returns:
            Dataset dict or None if not found
        """
        if not name_patterns:
            # Get patterns from config based on integration
            dataset_config = self.config.get('dataset_patterns', {})
            integration_config = dataset_config.get(self.integration_name, dataset_config.get('generic', {}))
            name_patterns = integration_config.get('name_contains', ['MASTER'])
        
        datasets = self.get_datasets(workspace_id)
        if not datasets:
            return None
        
        try:
            df = pd.DataFrame(datasets)
            if len(df) > 0:
                self.logger.debug(f"All datasets: {df[['name', 'id']].to_dict('records')}")
                
                # Filter by all patterns
                filtered_df = df.copy()
                for pattern in name_patterns:
                    filtered_df = filtered_df.loc[filtered_df['name'].str.contains(pattern, case=False, na=False)]
                
                if len(filtered_df) > 0:
                    self.logger.info(f"Found matching dataset(s): {filtered_df[['name', 'id']].to_dict('records')}")
                    return filtered_df.iloc[0].to_dict()
                else:
                    self.logger.warning(f"No dataset found matching patterns: {name_patterns}")
                    return None
            else:
                self.logger.warning("No datasets found in workspace")
                return None
                
        except Exception as e:
            self.logger.error(f"Error filtering datasets: {e}")
            return None
    
    def get_dataset_refresh_status(self, workspace_id: str, dataset_id: str) -> Optional[Dict[str, Any]]:
        """
        Get latest refresh status for dataset
        
        Args:
            workspace_id: PowerBI workspace ID
            dataset_id: PowerBI dataset ID
            
        Returns:
            Latest refresh status or None if failed
        """
        if not self.access_token:
            if not self.authenticate():
                return None
        
        try:
            url = f"{self.api_base_url}/groups/{workspace_id}/datasets/{dataset_id}/refreshes?$top=1"
            headers = {'Authorization': f'Bearer {self.access_token}'}
            
            response = requests.get(url, headers=headers)
            
            if response.status_code == 200:
                json_response = response.json()
                refreshes = json_response.get('value', [])
                if refreshes:
                    return refreshes[0]  # Latest refresh
                else:
                    return {'status': 'Unknown', 'message': 'No refresh history found'}
            else:
                self.logger.error(f"Failed to get refresh status: {response.status_code}")
                return None
                
        except Exception as e:
            self.logger.error(f"Error getting refresh status: {e}")
            return None
    
    def trigger_dataset_refresh(self, workspace_id: str, dataset_id: str) -> bool:
        """
        Trigger dataset refresh in PowerBI
        
        Args:
            workspace_id: PowerBI workspace ID
            dataset_id: PowerBI dataset ID
            
        Returns:
            bool: True if refresh triggered successfully, False otherwise
        """
        if not self.access_token:
            if not self.authenticate():
                return False
        
        try:
            url = f"{self.api_base_url}/groups/{workspace_id}/datasets/{dataset_id}/refreshes"
            headers = {'Authorization': f'Bearer {self.access_token}'}
            
            self.logger.info(f"Triggering refresh for dataset {dataset_id} in workspace {workspace_id}")
            response = requests.post(url, headers=headers)
            
            if response.status_code == 202:  # Accepted
                self.logger.info("✅ Dataset refresh triggered successfully")
                return True
            else:
                self.logger.error(f"❌ Failed to trigger refresh: {response.status_code}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ Error triggering refresh: {e}")
            return False
    
    def refresh_dataset(self, workspace_id: str, 
                       name_patterns: List[str] = None,
                       check_other_refreshes: bool = True,
                       cms_manager = None) -> bool:
        """
        Main method to refresh PowerBI dataset
        
        Args:
            workspace_id: PowerBI workspace ID
            name_patterns: Dataset name patterns to search for
            check_other_refreshes: Whether to check for other running refreshes
            cms_manager: CMS manager instance for checking other refreshes
            
        Returns:
            bool: True if refresh completed successfully, False otherwise
        """
        try:
            self.logger.info(f"Starting PowerBI dataset refresh for {self.integration_name}")
            
            # Check for other running refreshes (XERO-specific logic)
            if check_other_refreshes and cms_manager and self.integration_name.startswith('xero'):
                other_refreshes = self._check_other_xero_refreshes(cms_manager)
                if other_refreshes > 0:
                    self.logger.info(f"Skipping refresh - {other_refreshes} other XERO refreshes in progress")
                    return True  # Not an error, just skipped
            
            # Find dataset by patterns
            dataset = self.find_dataset_by_pattern(workspace_id, name_patterns)
            if not dataset:
                self.logger.error("No matching dataset found")
                return False
            
            dataset_id = dataset['id']
            dataset_name = dataset['name']
            
            # Check current refresh status
            refresh_status = self.get_dataset_refresh_status(workspace_id, dataset_id)
            if refresh_status:
                current_status = refresh_status.get('status', 'Unknown')
                self.logger.info(f"Current refresh status: {current_status}")
                
                # Only trigger refresh if not already running
                if current_status not in ['InProgress', 'Unknown']:
                    if self.trigger_dataset_refresh(workspace_id, dataset_id):
                        self.logger.info(f"✅ Triggered refresh for dataset '{dataset_name}' (ID: {dataset_id})")
                        return True
                    else:
                        return False
                else:
                    self.logger.info(f"Dataset refresh already in progress, skipping")
                    return True
            else:
                # If we can't get status, try to trigger anyway
                if self.trigger_dataset_refresh(workspace_id, dataset_id):
                    self.logger.info(f"✅ Triggered refresh for dataset '{dataset_name}' (ID: {dataset_id})")
                    return True
                else:
                    return False
                    
        except Exception as e:
            self.logger.error(f"❌ Dataset refresh failed: {e}")
            return False
    
    def _check_other_xero_refreshes(self, cms_manager) -> int:
        """
        Check for other XERO refreshes in progress (XERO-specific logic)
        
        Args:
            cms_manager: CMS manager instance
            
        Returns:
            int: Number of other XERO refreshes in progress
        """
        try:
            # This would need to be implemented based on CMS structure
            # For now, return 0 (no other refreshes)
            return 0
        except Exception as e:
            self.logger.warning(f"Could not check other refreshes: {e}")
            return 0
    
    def upload_template(self, template_path: str, workspace_id: str, 
                       dataset_name: str = None) -> bool:
        """
        Upload PowerBI template (PBIX file) to workspace
        
        Args:
            template_path: Path to PBIX template file
            workspace_id: PowerBI workspace ID
            dataset_name: Name for the dataset (optional)
            
        Returns:
            bool: True if upload successful, False otherwise
        """
        try:
            self.logger.info(f"📊 PowerBI template upload requested")
            self.logger.info(f"   Template: {template_path}")
            self.logger.info(f"   Workspace: {workspace_id}")
            self.logger.info(f"   Dataset Name: {dataset_name}")

            # Check if template file exists
            if not os.path.exists(template_path):
                self.logger.error(f"Template file not found: {template_path}")
                return False
            
            # Authenticate first
            if not self.authenticate():
                self.logger.error("Authentication failed for template upload")
                return False
            
            # PowerBI Import API endpoint
            import_url = f"{self.api_base_url}/groups/{workspace_id}/imports"
            
            # Prepare file upload
            filename = os.path.basename(template_path)
            dataset_name = dataset_name or filename.replace('.pbix', '')
            
            # Headers
            headers = {
                'Authorization': f'Bearer {self.access_token}'
            }
            
            # Upload parameters
            params = {
                'datasetDisplayName': dataset_name,
                'nameConflict': 'Overwrite'  # Overwrite if exists
            }
            
            # Upload file
            with open(template_path, 'rb') as f:
                files = {
                    'file': (filename, f, 'application/octet-stream')
                }
                
                self.logger.info(f"🔄 Uploading template to PowerBI workspace...")
                response = requests.post(import_url, headers=headers, files=files, params=params)
            
            if response.status_code == 202:  # Accepted - async operation
                import_result = response.json()
                import_id = import_result.get('id')
                
                self.logger.info(f"✅ Template upload initiated - Import ID: {import_id}")
                
                # Check import status (optional - can be async)
                if import_id:
                    status_url = f"{self.api_base_url}/groups/{workspace_id}/imports/{import_id}"
                    
                    # Poll for completion (max 30 seconds)
                    for _ in range(6):
                        time.sleep(5)
                        status_response = requests.get(status_url, headers=headers)
                        
                        if status_response.status_code == 200:
                            status_data = status_response.json()
                            import_state = status_data.get('importState', 'Unknown')
                            
                            self.logger.info(f"📊 Import status: {import_state}")
                            
                            if import_state == 'Succeeded':
                                self.logger.info(f"✅ Template upload completed successfully")
                                return True
                            elif import_state == 'Failed':
                                self.logger.error(f"❌ Template upload failed: {status_data.get('error', 'Unknown error')}")
                                return False
                        
                        time.sleep(5)
                
                # If we can't get final status, assume success since upload was accepted
                self.logger.info(f"✅ Template upload accepted - processing in background")
                return True
                
            else:
                error_msg = response.text
                self.logger.error(f"❌ Template upload failed - HTTP {response.status_code}: {error_msg}")
                return False
                
        except Exception as e:
            self.logger.error(f"❌ Template upload error: {e}")
            return False
    
    def get_template_path(self) -> str:
        """
        Get template path for current integration
        
        Returns:
            str: Absolute path to template file
        """
        dataset_config = self.config.get('dataset_patterns', {})
        integration_config = dataset_config.get(self.integration_name, dataset_config.get('generic', {}))
        relative_path = integration_config.get('template_path', self.pbi_config.get('default_template_path', ''))
        
        # Convert relative path to absolute path based on powerbi module directory
        if relative_path:
            powerbi_dir = os.path.dirname(__file__)
            return os.path.join(powerbi_dir, relative_path)
        
        return relative_path