"""
Abstract interface for package request managers
This interface defines the contract for managing API requests with context management,
rate limiting, and error handling.
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, Optional
import pandas as pd
import sys
import os
sys.path.append(os.path.dirname(__file__))
from IIntegrationAPI import IIntegrationAPI
from ITokenManager import ITokenManager


class IPackageRequestManager(ABC):
    """Abstract base class for package request managers"""
    
    def __init__(self, integration_api: IIntegrationAPI, token_manager: ITokenManager,
                 endpoint: str, params: Optional[Dict[str, Any]] = None, 
                 if_modified_since: Optional[str] = None, id: Optional[str] = None):
        """
        Initialize the request manager
        
        Args:
            integration_api: The integration API implementation
            token_manager: The token manager implementation
            endpoint: API endpoint to call
            params: Optional query parameters
            if_modified_since: Optional datetime for incremental updates
            id: Optional entity ID for single entity requests
        """
        self.integration_api = integration_api
        self.token_manager = token_manager
        self.endpoint = endpoint
        self.params = params
        self.if_modified_since = if_modified_since
        self.id = id
        self.data = None
    
    @abstractmethod
    def __enter__(self) -> pd.DataFrame:
        """
        Context manager entry point - execute the API request
        
        Returns:
            DataFrame containing the API response data
        """
        pass
    
    @abstractmethod
    def __exit__(self, exc_type, exc_value, traceback) -> bool:
        """
        Context manager exit point - cleanup resources
        
        Args:
            exc_type: Exception type if exception occurred
            exc_value: Exception value if exception occurred
            traceback: Exception traceback if exception occurred
            
        Returns:
            False to not suppress exceptions
        """
        pass
    
    @abstractmethod
    def make_api_request(self) -> pd.DataFrame:
        """
        Make the actual API request with rate limiting and error handling
        
        Returns:
            DataFrame containing the API response data
        """
        pass
    
    def get_access_token(self) -> str:
        """
        Get a valid access token, refreshing if necessary
        
        Returns:
            Valid access token string
        """
        return self.token_manager.get_valid_token()
    
    def handle_rate_limiting(self):
        """Handle rate limiting before making API request"""
        if self.integration_api.should_throttle():
            self.integration_api.wait_for_rate_limit()
    
    def process_response(self, response_json: Dict[str, Any]) -> pd.DataFrame:
        """
        Process the API response into a DataFrame
        
        Args:
            response_json: Raw JSON response from API
            
        Returns:
            Processed DataFrame
        """
        # Parse response using integration-specific logic
        data_list = self.integration_api.parse_api_response(response_json, self.endpoint)
        
        # Convert to DataFrame
        if data_list:
            df = pd.DataFrame(data_list)
            # Apply integration-specific data type conversions
            df = self.integration_api.convert_data_types(df, self.endpoint)
            return df
        else:
            return pd.DataFrame()
    
    def log_request(self, url: str, status_code: int, response_time: float):
        """
        Log the API request details
        
        Args:
            url: The API URL that was called
            status_code: HTTP status code
            response_time: Response time in seconds
        """
        integration_name = self.integration_api.integration_name
        print(f"[{integration_name}] {self.endpoint}: {status_code} - {response_time:.2f}s")
    
    def handle_api_error(self, error: Exception, url: str):
        """
        Handle API request errors
        
        Args:
            error: The exception that occurred
            url: The API URL that failed
        """
        integration_name = self.integration_api.integration_name
        print(f"[{integration_name}] API Error for {self.endpoint}: {str(error)}")
        print(f"[{integration_name}] Failed URL: {url}")
        
        # Re-raise the exception for upstream handling
        raise error