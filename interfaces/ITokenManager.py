"""
Abstract interface for token management
This interface defines the contract for managing OAuth tokens across different integrations.
"""

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any
import sys
import os
sys.path.append(os.path.dirname(__file__))
from IIntegrationAPI import IIntegrationAPI


class ITokenManager(ABC):
    """Abstract base class for token management"""
    
    def __init__(self, integration_api: IIntegrationAPI, token_file_name: str):
        """
        Initialize the token manager
        
        Args:
            integration_api: The integration API implementation
            token_file_name: Name of the token file
        """
        self.integration_api = integration_api
        self.token_file_name = token_file_name
        self._current_access_token = None
        self._current_refresh_token = None
    
    @abstractmethod
    def get_token_from_file(self) -> List[str]:
        """
        Read tokens from storage file
        
        Returns:
            List containing [access_token, refresh_token, refresh_token] or similar format
        """
        pass
    
    @abstractmethod
    def save_token_to_file(self, tokens: List[str]):
        """
        Save tokens to storage file
        
        Args:
            tokens: List of tokens to save
        """
        pass
    
    @abstractmethod
    def refresh_access_token(self, refresh_token: str) -> List[str]:
        """
        Refresh the access token using the refresh token
        
        Args:
            refresh_token: Current refresh token
            
        Returns:
            List containing new [access_token, refresh_token] or error response
        """
        pass
    
    def get_valid_token(self) -> str:
        """
        Get a valid access token, refreshing if necessary
        
        Returns:
            Valid access token string
        """
        # If we don't have a cached token, get from file
        if not self._current_access_token:
            tokens = self.get_token_from_file()
            if tokens and len(tokens) >= 2:
                self._current_access_token = tokens[0]
                self._current_refresh_token = tokens[1]
            else:
                raise Exception("No valid tokens found in file")
        
        # For now, return the current token
        # In production, you might want to validate token expiry here
        return self._current_access_token
    
    def refresh_token_if_needed(self) -> str:
        """
        Refresh token if needed and return valid access token
        
        Returns:
            Valid access token string
        """
        try:
            # Try to get current tokens
            old_tokens = self.get_token_from_file()
            if not old_tokens or len(old_tokens) < 2:
                raise Exception("No valid tokens found")
            
            # Attempt token refresh
            new_tokens = self.refresh_access_token(old_tokens[1])
            
            if new_tokens and len(new_tokens) >= 2 and not isinstance(new_tokens, dict):
                # Success - save new tokens
                self.save_token_to_file(new_tokens)
                self._current_access_token = new_tokens[0]
                self._current_refresh_token = new_tokens[1]
                return self._current_access_token
            else:
                # Refresh failed - use existing token
                self._current_access_token = old_tokens[0]
                self._current_refresh_token = old_tokens[1]
                return self._current_access_token
                
        except Exception as e:
            print(f"Token refresh error: {str(e)}")
            # Try to use existing token as fallback
            if self._current_access_token:
                return self._current_access_token
            raise e
    
    def invalidate_cache(self):
        """Invalidate cached tokens"""
        self._current_access_token = None
        self._current_refresh_token = None
    
    def get_token_file_path(self) -> str:
        """
        Get the full path to the token file
        Default implementation - override if needed
        
        Returns:
            Full path to token file
        """
        return f"/path/to/tokens/{self.token_file_name}"
    
    @abstractmethod
    def acquire_file_lock(self) -> Any:
        """
        Acquire file lock for token operations
        
        Returns:
            Lock object or context manager
        """
        pass
    
    @abstractmethod
    def release_file_lock(self, lock: Any):
        """
        Release file lock for token operations
        
        Args:
            lock: Lock object to release
        """
        pass