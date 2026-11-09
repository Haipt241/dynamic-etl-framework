"""
Base implementation of IPackageRequestManager
Provides common functionality for making API requests with rate limiting,
error handling, and response processing.
"""

import time
import requests
import pandas as pd
from typing import Dict, Any, Optional
import json
import traceback

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from interfaces.IPackageRequestManager import IPackageRequestManager
from interfaces.IIntegrationAPI import IIntegrationAPI
from interfaces.ITokenManager import ITokenManager


class BaseRequestManager(IPackageRequestManager):
    """
    Base implementation of package request manager
    Handles common API request patterns with integration-specific customization
    """
    
    def __enter__(self) -> pd.DataFrame:
        """
        Context manager entry point - execute the API request
        
        Returns:
            DataFrame containing the API response data
        """
        try:
            self.data = self.make_api_request()
            return self.data
        except Exception as e:
            print(f"Error in API request for {self.endpoint}: {str(e)}")
            # Return empty DataFrame on error
            return pd.DataFrame()
    
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
        print(f"Cleaning up request data for {self.endpoint}")
        if hasattr(self, 'data'):
            del self.data
        return False
    
    def make_api_request(self) -> pd.DataFrame:
        """
        Make the actual API request with rate limiting and error handling
        
        Returns:
            DataFrame containing the API response data
        """
        # Handle rate limiting
        self.handle_rate_limiting()
        
        # Get access token
        access_token = self.get_access_token()
        
        # Build request URL and headers
        url = self.integration_api.build_api_url(self.endpoint, self.params, self.id)
        headers = self.integration_api.get_auth_headers(access_token)
        
        # Add standard headers
        headers.update({
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        })
        
        # Add if-modified-since header if provided
        if self.if_modified_since:
            headers['If-Modified-Since'] = self.if_modified_since
        
        # Make the request
        start_time = time.time()
        
        try:
            # Get timeout from integration
            timeout = self.integration_api.get_timeout_seconds()
            
            print(f"Making API request to: {url}")
            
            # Make HTTP request
            response = requests.get(url, headers=headers, timeout=timeout)
            
            # Calculate response time
            response_time = time.time() - start_time
            
            # Increment API call counter
            self.integration_api.increment_api_call()
            
            # Log the request
            self.log_request(url, response.status_code, response_time)
            
            # Handle response
            if response.status_code == 200:
                return self._handle_successful_response(response)
            elif response.status_code == 304:
                # Not modified - return empty DataFrame
                print(f"No new data for {self.endpoint} (304 Not Modified)")
                return pd.DataFrame()
            elif response.status_code == 401:
                # Token might be expired - try refresh
                return self._handle_auth_error(response)
            else:
                # Other error
                return self._handle_api_error(response)
                
        except requests.exceptions.Timeout:
            error_msg = f"Request timeout after {timeout} seconds"
            self.handle_api_error(Exception(error_msg), url)
            return pd.DataFrame()
            
        except requests.exceptions.RequestException as e:
            self.handle_api_error(e, url)
            return pd.DataFrame()
            
        except Exception as e:
            self.handle_api_error(e, url)
            return pd.DataFrame()
    
    def _handle_successful_response(self, response: requests.Response) -> pd.DataFrame:
        """
        Handle successful API response
        
        Args:
            response: HTTP response object
            
        Returns:
            DataFrame with processed data
        """
        try:
            # Parse JSON response
            response_json = response.json()
            
            # Save raw response for debugging if needed
            self._save_raw_response(response_json)
            
            # Process response using integration-specific logic
            df = self.process_response(response_json)
            
            print(f"Successfully processed {len(df)} records from {self.endpoint}")
            return df
            
        except json.JSONDecodeError as e:
            error_msg = f"Invalid JSON response: {str(e)}"
            self.handle_api_error(Exception(error_msg), response.url)
            return pd.DataFrame()
        
        except Exception as e:
            self.handle_api_error(e, response.url)
            return pd.DataFrame()
    
    def _handle_auth_error(self, response: requests.Response) -> pd.DataFrame:
        """
        Handle authentication errors (401)
        
        Args:
            response: HTTP response object
            
        Returns:
            DataFrame (usually empty after error)
        """
        print(f"Authentication error (401) for {self.endpoint}. Attempting token refresh...")
        
        try:
            # Try to refresh token
            new_token = self.token_manager.refresh_token_if_needed()
            
            # Retry the request with new token
            print(f"Retrying {self.endpoint} with refreshed token...")
            return self.make_api_request()
            
        except Exception as e:
            error_msg = f"Token refresh failed: {str(e)}"
            self.handle_api_error(Exception(error_msg), response.url)
            return pd.DataFrame()
    
    def _handle_api_error(self, response: requests.Response) -> pd.DataFrame:
        """
        Handle API errors (non-200 status codes)
        
        Args:
            response: HTTP response object
            
        Returns:
            DataFrame (usually empty)
        """
        try:
            error_data = response.json()
            error_msg = f"API Error {response.status_code}: {error_data}"
        except:
            error_msg = f"API Error {response.status_code}: {response.text}"
        
        self.handle_api_error(Exception(error_msg), response.url)
        return pd.DataFrame()
    
    def _save_raw_response(self, response_json: Dict[str, Any]):
        """
        Save raw API response for debugging
        
        Args:
            response_json: Raw JSON response
        """
        try:
            # Create filename
            integration_name = self.integration_api.integration_name.lower()
            filename = f"/tmp/{integration_name}_{self.endpoint}_response.json"
            
            # Save response
            with open(filename, 'w') as f:
                json.dump(response_json, f, indent=2, default=str)
                
            print(f"Raw response saved to: {filename}")
            
        except Exception as e:
            print(f"Failed to save raw response: {str(e)}")
    
    def get_access_token(self) -> str:
        """
        Get a valid access token, with retry logic
        
        Returns:
            Valid access token string
        """
        max_retries = 3
        
        for attempt in range(max_retries):
            try:
                return self.token_manager.get_valid_token()
            except Exception as e:
                if attempt < max_retries - 1:
                    print(f"Token retrieval attempt {attempt + 1} failed: {str(e)}. Retrying...")
                    time.sleep(1)
                else:
                    raise e
    
    def handle_rate_limiting(self):
        """Enhanced rate limiting with integration-specific logic"""
        if self.integration_api.should_throttle():
            print(f"Rate limit reached for {self.integration_api.integration_name}. Waiting...")
            self.integration_api.wait_for_rate_limit()
    
    def log_request(self, url: str, status_code: int, response_time: float):
        """
        Enhanced request logging
        
        Args:
            url: The API URL that was called
            status_code: HTTP status code
            response_time: Response time in seconds
        """
        integration_name = self.integration_api.integration_name
        
        # Log with color coding for status
        if status_code == 200:
            status_symbol = "✓"
        elif status_code == 304:
            status_symbol = "◦"  # Not modified
        elif status_code >= 400:
            status_symbol = "✗"
        else:
            status_symbol = "?"
        
        print(f"[{integration_name}] {status_symbol} {self.endpoint}: {status_code} ({response_time:.2f}s)")
        
        # Log slow requests
        if response_time > 10:
            print(f"[{integration_name}] WARNING: Slow response for {self.endpoint}: {response_time:.2f}s")
    
    def handle_api_error(self, error: Exception, url: str):
        """
        Enhanced error handling with more context
        
        Args:
            error: The exception that occurred
            url: The API URL that failed
        """
        integration_name = self.integration_api.integration_name
        
        print(f"[{integration_name}] ✗ API Error for {self.endpoint}")
        print(f"[{integration_name}]   URL: {url}")
        print(f"[{integration_name}]   Error: {str(error)}")
        
        # Log full traceback for debugging
        if hasattr(error, '__traceback__'):
            print(f"[{integration_name}]   Traceback: {traceback.format_exc()}")
        
        # Don't re-raise in base implementation - let caller decide
        # raise error