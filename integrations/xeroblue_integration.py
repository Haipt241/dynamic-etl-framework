"""
XeroBlue Integration Implementation
Concrete implementation of IIntegrationAPI for XeroBlue accounting system.
This module contains all XeroBlue-specific logic for API calls, authentication, and data processing.
"""

import os
import pandas as pd
from typing import Dict, Any, Optional, List, Tuple
from datetime import datetime
import numpy as np

import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from interfaces.IIntegrationAPI import IIntegrationAPI


class XeroBlueIntegration(IIntegrationAPI):
    """
    XeroBlue implementation of the integration API
    Handles XeroBlue-specific API calls, authentication, and data processing
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize XeroBlue integration
        
        Args:
            config: Configuration dictionary
        """
        super().__init__(config)
        
        # XeroBlue specific configuration
        self.xero_tenant_id = os.getenv('XeroTenantID')
        if not self.xero_tenant_id:
            raise ValueError("XeroTenantID environment variable is required")
        
        # Set XeroBlue defaults
        self.rate_limit = config.get('rate_limit', 60)  # 60 calls per minute
        self.base_url = "https://api.xero.com/api.xro/2.0"
        
        # Report endpoints (different URL pattern)
        self.report_endpoints = {
            'TrialBalance', 'ProfitAndLoss', 'BalanceSheet', 'CashSummary',
            'AgedReceivables', 'AgedPayables', 'BankStatement'
        }
    
    @property
    def integration_name(self) -> str:
        """Return the name of the integration"""
        return "XEROBLUE"
    
    @property
    def table_prefix(self) -> str:
        """Return the table prefix for this integration"""
        return "_xeroblue_"
    
    def build_api_url(self, endpoint: str, params: Optional[Dict[str, Any]] = None, 
                     id: Optional[str] = None) -> str:
        """
        Build the complete API URL for XeroBlue endpoint
        
        Args:
            endpoint: The API endpoint name
            params: Optional query parameters
            id: Optional entity ID for single entity requests
            
        Returns:
            Complete API URL string
        """
        if self.is_report_endpoint(endpoint):
            # Reports use different URL pattern
            url = f"{self.base_url}/Reports/{endpoint}"
        else:
            # Regular endpoints
            url = f"{self.base_url}/{endpoint}"
            
            # Add ID for single entity requests
            if id:
                url = f"{url}/{id}"
        
        # Add query parameters
        if params:
            query_string = "&".join([f"{k}={v}" for k, v in params.items()])
            url = f"{url}?{query_string}"
        
        return url
    
    def get_auth_headers(self, access_token: str) -> Dict[str, str]:
        """
        Get authentication headers for XeroBlue API requests
        
        Args:
            access_token: OAuth access token
            
        Returns:
            Dictionary of HTTP headers
        """
        return {
            'Authorization': f'Bearer {access_token}',
            'Xero-tenant-id': self.xero_tenant_id,
            'Accept': 'application/json'
        }
    
    def parse_api_response(self, response_json: Dict[str, Any], 
                          endpoint: str) -> List[Dict[str, Any]]:
        """
        Parse the XeroBlue API response and extract the data array
        
        Args:
            response_json: Raw JSON response from API
            endpoint: The endpoint that was called
            
        Returns:
            List of data objects
        """
        try:
            # XeroBlue responses are typically structured as {endpoint: [data]}
            if endpoint in response_json:
                data = response_json[endpoint]
                if isinstance(data, list):
                    return data
                elif isinstance(data, dict):
                    # Single object response
                    return [data]
                else:
                    print(f"Unexpected data type for {endpoint}: {type(data)}")
                    return []
            else:
                # Check for alternative response structures
                possible_keys = [
                    endpoint,
                    endpoint.lower(),
                    endpoint.title(),
                    'data',
                    'items',
                    'records'
                ]
                
                for key in possible_keys:
                    if key in response_json:
                        data = response_json[key]
                        if isinstance(data, list):
                            return data
                        elif isinstance(data, dict):
                            return [data]
                
                print(f"No data found for endpoint {endpoint} in response keys: {list(response_json.keys())}")
                return []
                
        except Exception as e:
            print(f"Error parsing response for {endpoint}: {str(e)}")
            return []
    
    def get_endpoint_mapping(self, endpoint: str) -> Dict[str, Any]:
        """
        Get the field mapping configuration for the XeroBlue endpoint
        
        Args:
            endpoint: The API endpoint name
            
        Returns:
            Dictionary containing field mappings and metadata
        """
        # Basic mapping configuration - can be expanded
        mapping = {
            'endpoint_name': endpoint,
            'requires_transform': True,
            'field_mappings': {},  # Add specific field mappings if needed
            'data_types': self._get_endpoint_data_types(endpoint)
        }
        
        return mapping
    
    def _get_endpoint_data_types(self, endpoint: str) -> Dict[str, str]:
        """
        Get data type mappings for endpoint fields
        
        Args:
            endpoint: The API endpoint name
            
        Returns:
            Dictionary mapping field names to data types
        """
        # Common XeroBlue data type patterns
        common_types = {
            'Date': 'datetime',
            'UpdatedDateUTC': 'datetime',
            'CreatedDateUTC': 'datetime',
            'DueDateString': 'datetime',
            'Total': 'float',
            'SubTotal': 'float',
            'TotalTax': 'float',
            'AmountDue': 'float',
            'AmountPaid': 'float',
            'AmountCredited': 'float',
            'IsSupplier': 'boolean',
            'IsCustomer': 'boolean',
            'HasAttachments': 'boolean'
        }
        
        return common_types
    
    def get_token_refresh_params(self) -> Dict[str, str]:
        """
        Get parameters required for XeroBlue token refresh
        
        Returns:
            Dictionary of parameters needed for token refresh
        """
        return {
            'token_url': 'https://identity.xero.com/connect/token',
            'additional_params': {}  # XeroBlue doesn't need additional params
        }
    
    def get_client_credentials(self) -> Tuple[str, str]:
        """
        Get XeroBlue client credentials for authentication
        
        Returns:
            Tuple of (client_id, client_secret)
        """
        client_id = os.getenv('xeroblue_client_id')
        client_secret = os.getenv('xeroblue_client_secret')
        
        if not client_id or not client_secret:
            raise ValueError("XeroBlue client credentials not found in environment")
        
        return client_id, client_secret
    
    def get_additional_auth_params(self) -> Dict[str, Any]:
        """
        Get additional authentication parameters for XeroBlue
        
        Returns:
            Dictionary containing XeroTenantID
        """
        return {
            'xero_tenant_id': self.xero_tenant_id
        }
    
    def get_endpoints_list(self) -> List[str]:
        """
        Get list of all XeroBlue endpoints to process
        
        Returns:
            List of endpoint names
        """
        return [
            'Organisations',
            'Accounts',
            'BankTransactions',
            'BankTransfers',
            'Contacts',
            'CreditNotes',
            'Currencies',
            'Employees',
            'Invoices',
            'Items',
            'Journals',
            'ManualJournals',
            'Overpayments',
            'Payments',
            'Prepayments',
            'PurchaseOrders',
            'Receipts',
            'RepeatingInvoices',
            'TaxRates',
            'TrackingCategories',
            'Users',
            'BrandingThemes',
            'ContactGroups',
            'LinkedTransactions',
            'Setup',
            'Attachments',
            'HistoryRecords',
            'AssociatedRecords',
            'Files'
            # Report endpoints can be added separately
            # 'TrialBalance',
            # 'ProfitAndLoss',
            # 'BalanceSheet'
        ]
    
    def convert_data_types(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Convert data types for XeroBlue endpoint DataFrame
        
        Args:
            df: DataFrame with raw data
            endpoint: The endpoint name
            
        Returns:
            DataFrame with converted data types
        """
        if df.empty:
            return df
        
        try:
            # Get data type mappings for this endpoint
            data_types = self._get_endpoint_data_types(endpoint)
            
            for column, dtype in data_types.items():
                if column in df.columns:
                    df = self._convert_column_type(df, column, dtype)
            
            # Apply general XeroBlue data conversions
            df = self._apply_xeroblue_conversions(df)
            
            return df
            
        except Exception as e:
            print(f"Error converting data types for {endpoint}: {str(e)}")
            return df
    
    def _convert_column_type(self, df: pd.DataFrame, column: str, dtype: str) -> pd.DataFrame:
        """
        Convert a specific column to the target data type
        
        Args:
            df: DataFrame to modify
            column: Column name to convert
            dtype: Target data type
            
        Returns:
            DataFrame with converted column
        """
        try:
            if dtype == 'datetime':
                # Handle XeroBlue datetime formats
                df[column] = pd.to_datetime(df[column], errors='coerce', utc=True)
            elif dtype == 'float':
                df[column] = pd.to_numeric(df[column], errors='coerce')
            elif dtype == 'boolean':
                df[column] = df[column].astype(bool)
            elif dtype == 'string':
                df[column] = df[column].astype(str)
                
        except Exception as e:
            print(f"Error converting column {column} to {dtype}: {str(e)}")
        
        return df
    
    def _apply_xeroblue_conversions(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Apply XeroBlue-specific data conversions
        
        Args:
            df: DataFrame to convert
            
        Returns:
            Converted DataFrame
        """
        # Convert boolean strings to actual booleans
        boolean_columns = ['IsSupplier', 'IsCustomer', 'HasAttachments', 'HasErrors']
        for col in boolean_columns:
            if col in df.columns:
                df[col] = df[col].map({'true': True, 'false': False, True: True, False: False})
                df[col] = df[col].fillna(False)
        
        # Handle XeroBlue date formats
        date_columns = [col for col in df.columns if 'Date' in col or 'date' in col.lower()]
        for col in date_columns:
            if col in df.columns:
                df[col] = pd.to_datetime(df[col], errors='coerce', utc=True)
        
        # Handle numeric columns
        numeric_columns = [col for col in df.columns if any(term in col for term in ['Total', 'Amount', 'Rate', 'Quantity'])]
        for col in numeric_columns:
            if col in df.columns:
                df[col] = pd.to_numeric(df[col], errors='coerce')
        
        # Replace NaN with None for better database compatibility
        df = df.replace({np.nan: None})
        
        return df
    
    def is_report_endpoint(self, endpoint: str) -> bool:
        """
        Check if endpoint is a XeroBlue report-type endpoint
        
        Args:
            endpoint: The endpoint name
            
        Returns:
            True if this is a report endpoint
        """
        return endpoint in self.report_endpoints
    
    def get_timeout_seconds(self) -> int:
        """Get API request timeout in seconds for XeroBlue"""
        return self.config.get('timeout_seconds', 900)  # 15 minutes default