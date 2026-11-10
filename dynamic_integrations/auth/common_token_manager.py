"""
Common Token Manager - Abstraction Layer
Handles Azure File Share token operations for all integrations

This module provides common token management functionality that works
across all integrations (XeroBlue, QBO, MYOB, etc.) while keeping
integration-specific token refresh logic in the integration layer.
"""

import os
import json
from typing import List, Dict, Any, Tuple
from azure.storage.fileshare import ShareFileClient


class CommonTokenManager:
    """
    Common token manager that handles Azure File Share operations
    for all integrations while delegating integration-specific
    token refresh logic to the integration layer.
    """
    
    def __init__(self, integration_api, token_file_name: str):
        """
        Initialize common token manager
        
        Args:
            integration_api: Integration instance that provides token refresh logic
            token_file_name: Name of token file (e.g., "CLIENT1518_7232.txt")
        """
        self.integration_api = integration_api
        self.token_file_name = token_file_name
        
        # Azure File Share configuration (common for all integrations)
        self.storage_account_name = os.getenv('AZ_FILE_SHARE') or os.getenv('STORAGE_ACCOUNT_NAME')
        self.storage_account_key = os.getenv('AZ_FILE_SHARE_KEY') or os.getenv('STORAGE_ACCOUNT_KEY')
        # Use integration-specific file share name
        default_file_share = f'{self.integration_api.integration_name.lower()}-pydw-refreshtoken'
        self.file_share_name = os.getenv('FILE_SHARE_NAME', default_file_share)
        
        if self.storage_account_name is None: 
            self.storage_account_name = 'etanissis'
        if self.storage_account_key is None: 
            self.storage_account_key = 'REDACTED'
        if self.file_share_name is None:
            self.file_share_name = f'{self.integration_api.integration_name.lower()}-pydw-refreshtoken'
            
        
        if not self.storage_account_name or not self.storage_account_key:
            raise ValueError("Azure File Share configuration not found in environment")
    
    def get_connection_string(self) -> str:
        """Build Azure File Share connection string"""
        return (
            f"DefaultEndpointsProtocol=https;"
            f"AccountName={self.storage_account_name};"
            f"AccountKey={self.storage_account_key};"
            f"BlobEndpoint=https://{self.storage_account_name}.file.core.windows.net/"
        )
    
    def get_token_from_azure(self) -> List[str]:
        """
        Get tokens from Azure File Share
        Returns: [access_token, refresh_token, refresh_token]
        
        This function is common across all integrations as Azure operations are identical.
        """
        try:
            print(f"📥 Reading token from Azure File Share...")
            print(f"   Storage Account: {self.storage_account_name}")
            print(f"   File Share: {self.file_share_name}")
            print(f"   Token File: {self.token_file_name}")
            print(f"   Account Key: {self.storage_account_key}")
            
            share_file_client = ShareFileClient.from_connection_string(
                self.get_connection_string(),
                self.file_share_name,
                self.token_file_name
            )
            
            # Download file from Azure
            downloader = share_file_client.download_file()
            file_contents = downloader.readall().decode('utf-8')
            
            print(f"✅ Token file downloaded successfully from Azure")
            
            # Save backup locally
            self._save_local_backup(file_contents, "_old")
            
            # Parse JSON content
            json_response = json.loads(file_contents)
            
            # Return in expected format [access_token, refresh_token, refresh_token]
            return [
                json_response['access_token'],
                json_response['refresh_token'],
                json_response['refresh_token']
            ]
            
        except Exception as e:
            raise Exception(f"Failed to get token from Azure File Share: {str(e)}")
    
    def save_token_to_azure(self, token_data: Dict[str, Any]) -> bool:
        """
        Save token data to Azure File Share
        
        Args:
            token_data: Dictionary containing access_token, refresh_token, etc.
            
        Returns:
            bool: True if successful, False otherwise
            
        This function is common across all integrations as Azure operations are identical.
        """
        try:
            print(f"💾 Saving token to Azure File Share...")
            
            share_file_client = ShareFileClient.from_connection_string(
                self.get_connection_string(),
                self.file_share_name,
                self.token_file_name
            )
            
            # Convert to JSON and upload
            data = json.dumps(token_data).encode('utf-8')
            share_file_client.upload_file(data)
            
            print(f"✅ Token saved successfully to Azure")
            
            # Save backup locally
            self._save_local_backup(json.dumps(token_data), "_new")
            
            return True
            
        except Exception as e:
            print(f"❌ Failed to save token to Azure: {str(e)}")
            return False
    
    def refresh_token(self, refresh_token: str) -> Tuple[str, str]:
        """
        Refresh token using integration-specific logic
        
        Args:
            refresh_token: Current refresh token
            
        Returns:
            Tuple: (new_access_token, new_refresh_token) or (error_response, "error")
            
        This method delegates to the integration layer for integration-specific refresh logic,
        while handling the common Azure storage operations.
        """
        try:
            print(f"🔄 Refreshing token...")
            
            # Delegate to integration-specific token refresh logic
            if not hasattr(self.integration_api, 'refresh_token_request'):
                raise Exception("Integration API does not provide refresh_token_request method")
            
            # Get integration-specific refresh response
            refresh_response = self.integration_api.refresh_token_request(refresh_token)
            
            if isinstance(refresh_response, tuple) and len(refresh_response) == 2:
                response_data, status = refresh_response
                
                if status == "error":
                    print(f"❌ Token refresh failed: {response_data}")
                    return response_data, "error"
                
                # Success - save to Azure using common logic
                if self.save_token_to_azure(response_data):
                    print(f"✅ Token refresh successful")
                    return response_data['access_token'], response_data['refresh_token']
                else:
                    print(f"⚠️ Token refreshed but failed to save to Azure")
                    return response_data['access_token'], response_data['refresh_token']
            else:
                raise Exception("Invalid response format from integration token refresh")
                
        except Exception as e:
            error_response = {"error": str(e)}
            return error_response, "error"
    
    def get_valid_token(self) -> str:
        """
        Get a valid access token, refreshing if necessary
        
        Returns:
            str: Valid access token
            
        This orchestrates the common token management flow.
        """
        try:
            # Get current tokens from Azure
            tokens = self.get_token_from_azure()
            
            if not tokens or len(tokens) < 2:
                raise Exception("No valid tokens found in Azure File Share")
            
            # Try to refresh the token to ensure it's valid
            new_access_token, new_refresh_token = self.refresh_token(tokens[1])
            
            if new_refresh_token == "error":
                raise Exception(f"Token refresh failed: {new_access_token}")
            
            return new_access_token
            
        except Exception as e:
            raise Exception(f"Failed to get valid token: {str(e)}")
    
    def _save_local_backup(self, content: str, suffix: str):
        """Save local backup of token file"""
        try:
            os.makedirs('token', exist_ok=True)
            backup_filename = f'token/{self.token_file_name.replace(".txt", f"{suffix}.txt")}'
            
            with open(backup_filename, 'w') as f:
                f.write(content)
                
        except Exception as e:
            print(f"Warning: Could not save local backup: {str(e)}")
    
    def get_token_file_path(self) -> str:
        """Get the full path to the token file in Azure"""
        return f"{self.storage_account_name}/{self.file_share_name}/{self.token_file_name}"


def create_token_manager(integration_api, client_id: str = None, org_id: str = None) -> CommonTokenManager:
    """
    Factory function to create a token manager with dynamic token file naming
    
    Args:
        integration_api: Integration instance
        client_id: Client ID (if None, gets from environment)
        org_id: Organization ID (if None, gets from environment)
        
    Returns:
        CommonTokenManager: Configured token manager instance
    """
    # Get client and org IDs
    client_id = client_id or os.getenv('EtaniClientID', '')
    org_id = org_id or os.getenv('EtaniOrganisationID', '')
    
    if not client_id or not org_id:
        raise ValueError("Client ID and Organization ID must be provided or available in environment")
    
    # Generate token file name
    token_file_name = f"{client_id}_{org_id}.txt"
    
    print(f"🔐 Creating token manager:")
    print(f"   Client ID: {client_id}")
    print(f"   Organization ID: {org_id}")
    print(f"   Token File: {token_file_name}")
    
    return CommonTokenManager(integration_api, token_file_name)