"""
Abstract interface for integration APIs (XeroBlue, MYOB, XPM, FYI Elite, etc.)
This interface defines the contract that all integration implementations must follow.
"""

from abc import ABC, abstractmethod
from typing import Dict, Any, Optional, List, Tuple
import pandas as pd


class IIntegrationAPI(ABC):
    """Abstract base class for all integration APIs"""
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize the integration API
        
        Args:
            config: Configuration dictionary containing integration-specific settings
        """
        self.config = config
        self.api_calls = 0
        self.last_reset = 0
        self.rate_limit = config.get('rate_limit', 60)  # calls per minute
    
    @property
    @abstractmethod
    def integration_name(self) -> str:
        """Return the name of the integration (e.g., 'XEROBLUE', 'QBO', 'MYOB')"""
        pass
    
    @property
    @abstractmethod
    def table_prefix(self) -> str:
        """Return the table prefix for this integration (e.g., '_xeroblue_', '_qbo_')"""
        pass
    
    @abstractmethod
    def build_api_url(self, endpoint: str, params: Optional[Dict[str, Any]] = None, 
                     id: Optional[str] = None) -> str:
        """
        Build the complete API URL for the given endpoint
        
        Args:
            endpoint: The API endpoint name
            params: Optional query parameters
            id: Optional entity ID for single entity requests
            
        Returns:
            Complete API URL string
        """
        pass
    
    @abstractmethod
    def get_auth_headers(self, access_token: str) -> Dict[str, str]:
        """
        Get authentication headers for API requests
        
        Args:
            access_token: OAuth access token
            
        Returns:
            Dictionary of HTTP headers
        """
        pass
    
    @abstractmethod
    def parse_api_response(self, response_json: Dict[str, Any], 
                          endpoint: str) -> List[Dict[str, Any]]:
        """
        Parse the API response and extract the data array
        
        Args:
            response_json: Raw JSON response from API
            endpoint: The endpoint that was called
            
        Returns:
            List of data objects
        """
        pass
    
    @abstractmethod
    def get_endpoint_mapping(self, endpoint: str) -> Dict[str, Any]:
        """
        Get the field mapping configuration for the endpoint
        
        Args:
            endpoint: The API endpoint name
            
        Returns:
            Dictionary containing field mappings and metadata
        """
        pass
    
    @abstractmethod
    def get_token_refresh_params(self) -> Dict[str, str]:
        """
        Get parameters required for token refresh
        
        Returns:
            Dictionary of parameters needed for token refresh
        """
        pass
    
    @abstractmethod
    def get_client_credentials(self) -> Tuple[str, str]:
        """
        Get client credentials for authentication
        
        Returns:
            Tuple of (client_id, client_secret)
        """
        pass
    
    def get_additional_auth_params(self) -> Dict[str, Any]:
        """
        Get additional authentication parameters (e.g., tenant_id, realm_id)
        Default implementation returns empty dict - override if needed
        
        Returns:
            Dictionary of additional auth parameters
        """
        return {}
    
    def should_throttle(self) -> bool:
        """
        Check if API calls should be throttled based on rate limiting
        
        Returns:
            True if should wait before making next call
        """
        import time
        current_time = time.time()
        
        # Reset counter every minute
        if current_time - self.last_reset >= 60:
            self.api_calls = 0
            self.last_reset = current_time
        
        return self.api_calls >= self.rate_limit
    
    def wait_for_rate_limit(self):
        """Wait until rate limit window resets"""
        import time
        current_time = time.time()
        wait_time = 60 - (current_time - self.last_reset)
        if wait_time > 0:
            print(f"Rate limit reached. Waiting {wait_time:.1f} seconds...")
            time.sleep(wait_time)
            self.api_calls = 0
            self.last_reset = time.time()
    
    def increment_api_call(self):
        """Increment the API call counter"""
        self.api_calls += 1
    
    def get_endpoints_list(self) -> List[str]:
        """
        Get list of all endpoints to process for this integration
        Default implementation - override in concrete classes
        
        Returns:
            List of endpoint names
        """
        return []
    
    def convert_data_types(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Convert data types for the endpoint DataFrame
        Default implementation - override for integration-specific conversions
        
        Args:
            df: DataFrame with raw data
            endpoint: The endpoint name
            
        Returns:
            DataFrame with converted data types
        """
        return df
    
    def get_timeout_seconds(self) -> int:
        """Get API request timeout in seconds"""
        return self.config.get('timeout_seconds', 900)
    
    def is_report_endpoint(self, endpoint: str) -> bool:
        """
        Check if endpoint is a report-type endpoint
        Default implementation returns False - override if needed
        
        Args:
            endpoint: The endpoint name
            
        Returns:
            True if this is a report endpoint
        """
        return False