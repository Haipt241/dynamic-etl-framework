"""
Base implementation of ITokenManager
Provides common functionality for OAuth token management with Azure File Share storage.
"""

import os
import time
import base64
import requests
import json
import threading
from typing import List, Optional, Dict, Any
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from interfaces.ITokenManager import ITokenManager
from interfaces.IIntegrationAPI import IIntegrationAPI


class BaseTokenManager(ITokenManager):
    """
    Base implementation of token manager
    Handles OAuth token storage, refresh, and file locking for Azure File Share
    """
    
    def __init__(self, integration_api: IIntegrationAPI, token_file_name: str):
        """
        Initialize the token manager
        
        Args:
            integration_api: The integration API implementation
            token_file_name: Name of the token file
        """
        super().__init__(integration_api, token_file_name)
        
        # Azure File Share configuration
        self.az_file_share = os.getenv('AZ_FILE_SHARE')
        self.az_file_share_key = os.getenv('AZ_FILE_SHARE_KEY')
        
        if not self.az_file_share or not self.az_file_share_key:
            raise ValueError("Azure File Share configuration not found in environment")
        
        # Thread lock for token operations
        self._file_lock = threading.Lock()
    
    def get_token_from_file(self) -> List[str]:
        """
        Read tokens from Azure File Share
        
        Returns:
            List containing [access_token, refresh_token, refresh_token] format
        """
        with self._file_lock:
            try:
                # Construct Azure File Share URL
                file_url = self._get_azure_file_url()
                
                # Download token file
                response = requests.get(file_url, timeout=30)
                
                if response.status_code == 200:
                    # Parse token file content
                    tokens_text = response.text.strip()
                    if tokens_text:
                        # Split tokens by newline (typical format)
                        tokens = tokens_text.split('\\n')
                        if len(tokens) >= 2:
                            # Return in expected format: [access, refresh, refresh]
                            return [tokens[0], tokens[1], tokens[1]]
                        else:
                            raise Exception(f"Invalid token file format: {len(tokens)} tokens found")
                    else:
                        raise Exception("Empty token file")
                        
                elif response.status_code == 404:
                    raise Exception("Token file not found")
                else:
                    raise Exception(f"Failed to download token file: {response.status_code}")
                    
            except Exception as e:
                print(f"Error reading token file {self.token_file_name}: {str(e)}")
                raise e
    
    def save_token_to_file(self, tokens: List[str]):
        """
        Save tokens to Azure File Share
        
        Args:
            tokens: List of tokens to save [access_token, refresh_token]
        """
        with self._file_lock:
            try:
                if len(tokens) < 2:
                    raise ValueError("Need at least 2 tokens to save")
                
                # Format tokens for file storage
                token_content = f"{tokens[0]}\\n{tokens[1]}"
                
                # Upload to Azure File Share
                file_url = self._get_azure_file_url()
                
                headers = {
                    'x-ms-type': 'file',
                    'x-ms-content-length': str(len(token_content.encode('utf-8'))),
                    'Content-Type': 'text/plain'
                }
                
                # Create/update file
                response = requests.put(file_url, headers=headers, timeout=30)
                
                if response.status_code in [201, 204]:
                    # Upload content
                    range_header = f"bytes=0-{len(token_content.encode('utf-8')) - 1}"
                    content_headers = {
                        'x-ms-range': range_header,
                        'x-ms-write': 'update',
                        'Content-Type': 'text/plain'
                    }
                    
                    content_url = f"{file_url}?comp=range"
                    content_response = requests.put(content_url, headers=content_headers, 
                                                  data=token_content, timeout=30)
                    
                    if content_response.status_code == 201:
                        print(f"Token file {self.token_file_name} updated successfully")
                    else:
                        raise Exception(f"Failed to update file content: {content_response.status_code}")
                else:
                    raise Exception(f"Failed to create/update token file: {response.status_code}")
                    
            except Exception as e:
                print(f"Error saving token file {self.token_file_name}: {str(e)}")
                raise e
    
    def refresh_access_token(self, refresh_token: str) -> List[str]:
        """
        Refresh the access token using the refresh token
        
        Args:
            refresh_token: Current refresh token
            
        Returns:
            List containing new [access_token, refresh_token] or error response
        """
        try:
            # Get integration-specific refresh parameters
            refresh_params = self.integration_api.get_token_refresh_params()
            client_id, client_secret = self.integration_api.get_client_credentials()
            
            # Prepare refresh request
            refresh_url = refresh_params.get('token_url')
            if not refresh_url:
                raise ValueError("Token refresh URL not configured")
            
            # Encode client credentials
            credentials = base64.b64encode(f"{client_id}:{client_secret}".encode()).decode()
            
            headers = {
                'Authorization': f'Basic {credentials}',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            }
            
            data = {
                'grant_type': 'refresh_token',
                'refresh_token': refresh_token
            }
            
            # Add any additional parameters
            additional_params = refresh_params.get('additional_params', {})
            data.update(additional_params)
            
            print(f"Refreshing token for {self.integration_api.integration_name}...")
            
            # Make refresh request
            response = requests.post(refresh_url, headers=headers, data=data, timeout=30)
            
            if response.status_code == 200:
                token_data = response.json()
                
                # Extract tokens from response
                new_access_token = token_data.get('access_token')
                new_refresh_token = token_data.get('refresh_token', refresh_token)  # Use old if not provided
                
                if not new_access_token:
                    raise Exception("No access token in refresh response")
                
                print(f"Token refreshed successfully for {self.integration_api.integration_name}")
                return [new_access_token, new_refresh_token]
                
            else:
                # Return error response for upstream handling
                error_data = response.json() if response.headers.get('content-type', '').startswith('application/json') else response.text
                print(f"Token refresh failed: {response.status_code} - {error_data}")
                return {"error": error_data, "status_code": response.status_code}
                
        except Exception as e:
            print(f"Token refresh error for {self.integration_api.integration_name}: {str(e)}")
            return {"error": str(e), "exception": True}
    
    def get_token_file_path(self) -> str:
        """
        Get the Azure File Share URL for the token file
        
        Returns:
            Full URL to token file
        """
        return self._get_azure_file_url()
    
    def _get_azure_file_url(self) -> str:
        """
        Construct Azure File Share URL for the token file
        
        Returns:
            Complete Azure File Share URL
        """
        # Azure File Share URL format
        # https://{account}.file.core.windows.net/{share}/{directory}/{file}?{sas_token}
        
        base_url = f"https://{self.az_file_share}.file.core.windows.net"
        file_path = f"tokens/{self.token_file_name}"
        
        # Use SAS token or account key authentication
        if self.az_file_share_key.startswith('sv='):
            # SAS token
            return f"{base_url}/{file_path}?{self.az_file_share_key}"
        else:
            # Account key - would need to generate SAS token
            # For simplicity, assume SAS token is provided
            return f"{base_url}/{file_path}?{self.az_file_share_key}"
    
    def acquire_file_lock(self) -> Any:
        """
        Acquire file lock for token operations
        
        Returns:
            Lock object (threading.Lock in this implementation)
        """
        self._file_lock.acquire()
        return self._file_lock
    
    def release_file_lock(self, lock: Any):
        """
        Release file lock for token operations
        
        Args:
            lock: Lock object to release
        """
        if hasattr(lock, 'release'):
            lock.release()
    
    def get_valid_token(self) -> str:
        """
        Get a valid access token with automatic refresh capability
        
        Returns:
            Valid access token string
        """
        try:
            # Try to get token from cache first
            if self._current_access_token:
                return self._current_access_token
            
            # Get tokens from file
            tokens = self.get_token_from_file()
            if tokens and len(tokens) >= 2:
                self._current_access_token = tokens[0]
                self._current_refresh_token = tokens[1]
                return self._current_access_token
            else:
                raise Exception("No valid tokens found")
                
        except Exception as e:
            print(f"Error getting valid token: {str(e)}")
            raise e
    
    def refresh_token_if_needed(self) -> str:
        """
        Refresh token if needed and return valid access token
        
        Returns:
            Valid access token string
        """
        try:
            # Get current tokens
            old_tokens = self.get_token_from_file()
            if not old_tokens or len(old_tokens) < 2:
                raise Exception("No tokens available for refresh")
            
            # Attempt refresh
            refresh_result = self.refresh_access_token(old_tokens[1])
            
            if isinstance(refresh_result, list) and len(refresh_result) >= 2:
                # Success - save new tokens
                self.save_token_to_file(refresh_result)
                self._current_access_token = refresh_result[0]
                self._current_refresh_token = refresh_result[1]
                return self._current_access_token
            else:
                # Refresh failed - try using existing token
                print("Token refresh failed, using existing token")
                self._current_access_token = old_tokens[0]
                return self._current_access_token
                
        except Exception as e:
            print(f"Error in token refresh: {str(e)}")
            # Try to return cached token as last resort
            if self._current_access_token:
                return self._current_access_token
            raise e