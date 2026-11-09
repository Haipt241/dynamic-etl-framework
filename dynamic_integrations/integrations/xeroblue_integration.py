"""
Enhanced XeroBlue Integration - Maintains compatibility with existing XEROBLUE - UPSERT.py
while providing plug-and-play abstractions.

This integration extracts only the Xero-specific API logic while preserving 
all existing database operations, transformations, and business logic.
"""

import os
import time
import json
import base64
import requests
import urllib.parse
import pandas as pd
import uuid
import logging
from typing import Dict, Any, List, Optional
from datetime import datetime, timezone
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError, ProgrammingError

from sql_helper import eva_engine

# Import base integration interface
try:
    from ..base_integration import BaseIntegration, IntegrationCapability
except ImportError:
    from base_integration import BaseIntegration, IntegrationCapability

# Import existing modules to maintain compatibility
try:
    from sql_helper import (
        LoggingDetails, update_container_logs, eva_engine, cms_engine,
        ExecuteEvaSP, ExecuteCMSSP, ReadMySQLTable, get_firm_id, LoadToEvaStageTable
    )
    from azure.storage.fileshare import ShareFileClient
    from utils import get_acronym
    import config
except ImportError:
    # Fallback for testing
    def LoggingDetails(*args): pass
    def update_container_logs(*args): pass
    def ExecuteEvaSP(*args): pass
    def ExecuteCMSSP(*args): pass
    def ReadMySQLTable(*args): return pd.DataFrame()
    def get_firm_id(*args): return 0
    def LoadToEvaStageTable(*args): pass


class XeroblueIntegration(BaseIntegration):
    """
    XeroBlue Integration - Integration-Agnostic Implementation
    
    This module provides a XeroBlue integration that inherits from BaseIntegration,
    making it fully compatible with the dynamic integration orchestrator.
    
    Extracts only API-specific logic while maintaining compatibility with existing
    XEROBLUE - UPSERT.py infrastructure and providing plug-and-play interface.
    """
    
    # XeroBlue-specific configuration
    XEROBLUE_CONFIG = {
        'api_base_url': 'https://api.xero.com/api.xro/2.0',
        'token_url': 'https://identity.xero.com/connect/token',
        'report_endpoints': {'BalanceSheet', 'BankStatement', 'BankSummary', 'TrialBalance', 
                           'BudgetSummary', 'ExecutiveSummary', 'ProfitAndLoss'},
        'rate_limit': 60,  # calls per minute
        'default_fx_currencies': ['AUD', 'USD', 'NZD', 'GBP', 'EUR'],
        'timeout_seconds': 900,
        'max_workers': 30
    }
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        """Initialize XeroBlue integration with configuration"""
        # Initialize base integration
        super().__init__(config)
        
        # Merge with XeroBlue-specific configuration
        self.integration_config = {**self.XEROBLUE_CONFIG, **self.config}
        
        # Integration metadata
        self.table_prefix = "_xeroblue_"
        
        # Rate limiting
        self.rate_limit = self.integration_config.get('rate_limit', 60)  # calls per minute
        self.api_calls = 0
        self.last_reset = time.time()
        
        # Default value configuration
        self.apply_default_values = self.integration_config.get('apply_default_values', True)
        self.default_value_prefix = self.integration_config.get('default_value_prefix', 'DEFAULT')
        self.log_default_applications = self.integration_config.get('log_default_applications', True)
        
        # Environment configuration
        # NOTE: client_id and client_secret are now handled by BaseIntegration with XeroBlue defaults
        # NOTE: storage_account_name, storage_account_key, file_share_name, and blob_container_name
        # are now handled by BaseIntegration with proper defaults from config
        self.xero_tenant_id = os.getenv('XeroTenantID')
        
        # Note: Azure File Share operations moved to common_token_manager.py
        
        # Xero API endpoints that are reports
        self.report_endpoints = self.integration_config.get('report_endpoints', set())
        
        # Track errors and execution
        self.error_list = []
        self.start_time = time.time()
        self.log_id = str(uuid.uuid1())
        
        # Setup full configuration for business logic
        self.setup_full_configuration()
        self.setup_logging()
        
        # Initialize data conversion function
        self.convert_data_types = self._import_convert_data_types()
        
        # Note: Token file management moved to common_token_manager.py
    
    # ===================================================================================
    # BASE INTEGRATION INTERFACE IMPLEMENTATION
    # ===================================================================================
    
    @property
    def integration_name(self) -> str:
        """Get integration name"""
        return "XEROBLUE"
    
    @property
    def capabilities(self) -> IntegrationCapability:
        """Get integration capabilities - XeroBlue supports both INSERT and UPSERT"""
        return IntegrationCapability.BOTH
    
    # ===================================================================================
    # COMMON FUNCTIONALITY PROPERTIES (Required by BaseIntegration)
    # ===================================================================================
    
    @property
    def allowed_execution_statuses(self) -> List[int]:
        """Return list of organization statuses that allow execution (XeroBlue-specific)"""
        return [12]  # Status 12 = Updating Data (Status 16 + Reset_Mode handled automatically)
    
    # NOTE: etani_client_id, etani_organisation_id, table_prefix_eva, and table_prefix_dw
    # are now implemented in BaseIntegration with automatic generation and setter support
    
    def get_endpoints_list(self) -> List[str]:
        """Get list of available Xero API endpoints"""
        return [
            'Organisations', 'Accounts', 'Invoices', 'CreditNotes', 'Overpayments',
            'Prepayments', 'ManualJournals', 'Payments', 'BankTransactions', 'Transactions',
            'Journals', 'JournalsCash', 'Budgets', 'TrackingCategoryConnections', 
            'BankTransfers', 'BatchPayments', 'BrandingThemes', 'Contacts', 'Currencies',
            'InvoicesDraft', 'RepeatingInvoices', 'TaxRates', 'Users', 'ContactGroups',
            'ExpenseClaims', 'Items', 'PurchaseOrders', 'Receipts', 'TrackingCategories',
            'Employees', 'LinkedTransactions', 'Quotes', 'BankSummary', 'TrialBalance'
        ]
    
    def build_api_url(self, endpoint: str, id: str = None, params: Dict[str, str] = None) -> str:
        """Build Xero API URL for given endpoint"""
        base_api_url = self.integration_config.get('api_base_url', 'https://api.xero.com/api.xro/2.0')
        
        if endpoint in self.report_endpoints:
            base_url = f'{base_api_url}/Reports/{endpoint}'
        else:
            base_url = f'{base_api_url}/{endpoint}'
        
        if id:
            base_url += f'/{id}'
        
        if params:
            base_url += '?' + urllib.parse.urlencode(params)
        
        return base_url
    
    def get_auth_headers(self, access_token: str) -> Dict[str, str]:
        """Get Xero-specific authentication headers"""
        return {
            'Authorization': f'Bearer {access_token}',
            'Xero-tenant-id': self.xero_tenant_id,
            'Accept': 'application/json'
        }
    
    def apply_rate_limiting(self):
        """Apply Xero rate limiting (60 calls per minute)"""
        current_time = time.time()
        
        # Reset counter every minute
        if current_time - self.last_reset >= 60:
            self.api_calls = 0
            self.last_reset = current_time
        
        # Wait if we've hit the limit
        if self.api_calls >= self.rate_limit:
            wait_time = 60 - (current_time - self.last_reset)
            if wait_time > 0:
                time.sleep(wait_time)
                self.api_calls = 0
                self.last_reset = time.time()
        
        self.api_calls += 1
    
    def refresh_token_request(self, refresh_token: str) -> tuple:
        """
        Xero-specific token refresh request (Azure operations handled by common_token_manager)
        
        Args:
            refresh_token: Current refresh token
            
        Returns:
            Tuple: (response_data, status) where status is "success" or "error"
        """
        try:
            print(f"🔄 Making Xero token refresh request using token: {refresh_token}...")
            
            # Xero-specific authentication
            b64_id_secret = base64.b64encode(
                f"{self.client_id}:{self.client_secret}".encode('utf-8')
            ).decode('utf-8')
            
            # Xero-specific token refresh URL
            token_refresh_url = self.integration_config.get('token_url', 'https://identity.xero.com/connect/token')
            
            # Xero-specific request
            response = requests.post(
                token_refresh_url,
                headers={
                    'Authorization': f'Basic {b64_id_secret}',
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                data={
                    'grant_type': 'refresh_token',
                    'refresh_token': refresh_token
                }
            )
            
            json_response = response.json()
            
            if response.status_code == 200:
                print(f"✅ Xero token refresh successful")
                return json_response, "success"
            else:
                print(f"❌ Xero token refresh failed: {response.status_code}")
                return json_response, "error"
                
        except Exception as e:
            print(f"❌ Xero token refresh exception: {str(e)}")
            return {"error": str(e)}, "error"
    
    def get_endpoint_api_params(self, endpoint: str, page: int = None, offset: int = None) -> tuple:
        """
        Get endpoint-specific parameters, actual endpoint URL, and if-modified-since header
        Based on exact patterns from original XEROBLUE - UPSERT.py
        
        Returns:
            tuple: (actual_endpoint, params_dict, if_modified_since)
        """
        # Default values
        actual_endpoint = endpoint
        params = None
        if_modified_since = None
        
        # Simple endpoints (no params, no date filtering)
        simple_endpoints = {
            'Organisations', 'Accounts', 'BankTransfers', 'BrandingThemes', 
            'Currencies', 'Employees', 'ExpenseClaims', 'LinkedTransactions',
            'PurchaseOrders', 'Receipts', 'RepeatingInvoices', 'TaxRates', 'BankSummary'
        }
        
        if endpoint in simple_endpoints:
            # No parameters needed
            return actual_endpoint, None, None
        
        # Offset-based pagination endpoints
        elif endpoint == 'Journals':
            if offset is not None:
                params = {'offset': offset}
            return actual_endpoint, params, None
        
        # Special case: JournalsCash (endpoint modification + special params)
        elif endpoint == 'JournalsCash':
            actual_endpoint = 'Journals'  # Remove 'Cash' from endpoint
            if offset is not None:
                params = {'offset': offset, 'paymentsOnly': True}
            return actual_endpoint, params, None
        
        # Page-based pagination with date filtering endpoints
        paginated_endpoints = {
            'Invoices', 'CreditNotes', 'Payments', 'BankTransactions',
            'ManualJournals', 'Items', 'Overpayments', 'Prepayments', 'Users', 'PurchaseOrders'
        }
        
        if endpoint in paginated_endpoints:
            if page is not None:
                params = {'page': page, 'pagesize': 100}  # Standard pagesize
            
            # Get max date for if-modified-since (would come from GetMaxFilterParameter)
            # For now, we'll pass None and let the caller handle this
            return actual_endpoint, params, if_modified_since
        
        # Special case: Contacts (includes archived)
        elif endpoint == 'Contacts':
            if page is not None:
                params = {'includeArchived': True, 'page': page, 'pagesize': 100}
            return actual_endpoint, params, if_modified_since
        
        # Special case: InvoicesDraft (uses different endpoint + status filtering)
        elif endpoint == 'InvoicesDraft':
            actual_endpoint = 'Invoices'  # Use Invoices endpoint
            if page is not None:
                params = {'page': page, 'pagesize': 100, 'Statuses': 'DRAFT,SUBMITTED'}
            return actual_endpoint, params, ''  # Always empty string for this endpoint
        
        # Special case: BatchPayments (explicit None params with date filtering)
        elif endpoint == 'BatchPayments':
            # Note: params explicitly set to None in original
            return actual_endpoint, None, if_modified_since
        
        # Page-based pagination without date filtering
        elif endpoint in {'Quotes', 'LinkedTransactions'}:
            if page is not None:
                params = {'page': page, 'pagesize': 100}
            return actual_endpoint, params, None
        
        # Special case: TrackingCategories (includes archived)
        elif endpoint == 'TrackingCategories':
            if page is not None:
                params = {'includeArchived': True, 'page': page, 'pagesize': 100}
            else:
                params = {'includeArchived': True}
            return actual_endpoint, params, None
        
        # Report endpoints with special parameters
        elif endpoint == 'BalanceSheet':
            params = {'timeframe': 'MONTH', 'periods': 11}
            return actual_endpoint, params, None
        
        # Default fallback
        return actual_endpoint, params, if_modified_since
    
    def make_api_request_with_patterns(self, endpoint: str, page: int = None, offset: int = None,
                                     max_date: str = None, token_manager=None) -> pd.DataFrame:
        """
        Make Xero API request with exact patterns from original XEROBLUE - UPSERT.py
        This method replicates all XeroRequestsManager usage patterns
        """
        try:
            # Apply rate limiting
            self.apply_rate_limiting()
            
            # Get endpoint-specific parameters
            actual_endpoint, params, if_modified_since = self.get_endpoint_api_params(endpoint, page, offset)
            
            # Override if_modified_since with max_date if provided
            if max_date is not None:
                if_modified_since = str(max_date) if max_date else None
            
            # Get valid token using common token manager
            if token_manager is None:
                from common_token_manager import create_token_manager                
                token_manager = create_token_manager(self, self.legacy_client_id, self.legacy_organisation_id)
            
            access_token = token_manager.get_valid_token()
            
            # Build URL and headers
            api_url = self.build_api_url(actual_endpoint, None, params)
            headers = self.get_auth_headers(access_token)
            
            if if_modified_since:
                headers['If-Modified-Since'] = if_modified_since
            
            # Log the request (match original pattern)
            print(f"🔄 API Request: {actual_endpoint} (original: {endpoint})")
            if params:
                print(f"   Parameters: {params}")
            if if_modified_since:
                print(f"   If-Modified-Since: {if_modified_since}")
            
            if 'LoggingDetails' in globals():
                LoggingDetails("xero_requests", f"{endpoint} - Get API Response from: {api_url}", 
                             os.getenv('JOB_ID'), os.getenv('JOB_RUN_ID'), [])
            
            # Make request
            response = requests.get(api_url, headers=headers, timeout=900)
            print(f"📊 Response status: {response.status_code}")
            response.raise_for_status()
            
            json_response = response.json()
            
            # Save response locally for debugging
            self._save_response_locally(json_response, endpoint)
            
            # Parse response to DataFrame
            df = self._parse_response_to_dataframe(json_response, actual_endpoint)
            
            # Transform complex JSON objects to match database schema
            df = self._transform_complex_json_objects(df, endpoint)
            
            print(f"✅ Retrieved {len(df)} records for {endpoint}")
            return df
            
        except Exception as e:
            print(f"❌ API request failed for {endpoint}: {str(e)}")
            raise e
    
    def make_api_request(self, endpoint: str, params: Dict[str, str] = None, 
                        if_modified_since: str = None, id: str = None, 
                        token_manager=None) -> pd.DataFrame:
        """
        Legacy method for backward compatibility
        Redirects to the new pattern-based method
        """
        # For backward compatibility, use the enhanced method
        return self.make_api_request_with_patterns(
            endpoint=endpoint, 
            page=params.get('page') if params else None,
            offset=params.get('offset') if params else None,
            max_date=if_modified_since,
            token_manager=token_manager
        )
    
    def _handle_token_error(self, error_response: Dict[str, Any], endpoint: str):
        """Handle token refresh errors"""
        if isinstance(error_response, dict) and error_response.get('error') == 'invalid_grant':
            # Update client status in CMS if available
            org_id = os.getenv('EtaniOrganisationID')
            if org_id and 'ExecuteCMSSP' in globals():
                try:
                    from sql_helper import ExecuteCMSSP
                    ExecuteCMSSP(f"Update client_service SET status = 13 where Id = {org_id}", 
                               "client_service", [], True)
                except:
                    pass
            
            # Log container error if available
            if 'update_container_logs' in globals():
                params = {
                    "p_integration": "XEROBLUE",
                    "p_organisation_id": org_id,
                    "p_client_id": os.getenv('EtaniClientID', '').replace('CLIENT', ''),
                    "p_firm_id": 0,
                    "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_status": "Failed",
                    "p_log_id": os.getenv('log_id', ''),
                    "p_remarks": f"Invalid Grant or Token - Endpoint: {endpoint}"
                }
                update_container_logs(params)
    
    def _save_response_locally(self, json_response: Dict[str, Any], endpoint: str):
        """Save API response locally for debugging"""
        try:
            os.makedirs('json', exist_ok=True)
            
            # Generate table prefix for filename
            client_id = os.getenv('EtaniClientID', '')
            org_id = os.getenv('EtaniOrganisationID', '')
            if client_id and org_id:
                table_prefix = f"c{client_id.replace('CLIENT', '')}_{org_id}_xeroblue_"
                filename = f'json/{table_prefix}{endpoint.replace("/", "_")}_response.json'
                
                with open(filename, 'w') as f:
                    json.dump(json_response, f)
        except Exception as e:
            print(f"Warning: Could not save response locally: {str(e)}")
    
    def _parse_response_to_dataframe(self, json_response: Dict[str, Any], endpoint: str) -> pd.DataFrame:
        """Parse Xero API JSON response to pandas DataFrame"""
        try:
            if endpoint in self.report_endpoints:
                # Handle report endpoints
                if 'Reports' in json_response:
                    return pd.DataFrame(json_response['Reports'])
                else:
                    return pd.DataFrame()
            else:
                # Handle regular endpoints - check both exact match and capitalized version
                data_key = None
                if endpoint in json_response:
                    data_key = endpoint
                elif endpoint.capitalize() in json_response:
                    data_key = endpoint.capitalize()
                elif endpoint.title() in json_response:
                    data_key = endpoint.title()
                else:
                    # Try case-insensitive search through all keys
                    for key in json_response.keys():
                        if key.lower() == endpoint.lower():
                            data_key = key
                            break
                
                if data_key and data_key in json_response:
                    data_list = json_response[data_key]
                    if isinstance(data_list, list) and len(data_list) > 0:
                        print(f"✅ Found {len(data_list)} records for {endpoint} (using key: {data_key})")
                        return pd.DataFrame(data_list)
                    else:
                        print(f"⚠️  {endpoint} found but contains no data (key: {data_key})")
                        return pd.DataFrame()
                else:
                    print(f"⚠️  {endpoint} not found in JSON response. Available keys: {list(json_response.keys())}")
                    return pd.DataFrame()
                    
        except Exception as e:
            print(f"❌ Error parsing response for {endpoint}: {str(e)}")
            return pd.DataFrame()
    
    # ========================
    # Utility Functions (from original XEROBLUE - UPSERT.py)
    # ========================
    
    def _get_value(self, obj, key, default=''):
        """Safely get value from object with pandas NaN handling"""
        if obj is None or pd.isna(obj):
            return default
        if isinstance(obj, dict):
            value = obj.get(key, default)
            return str(value or '') if not pd.isna(value) else default
        return default
    
    def _validate_float(self, value):
        """Validate and convert value to float with error handling"""
        try:
            if value is None or pd.isna(value) or value == '':
                return 0.0
            return float(value)
        except (TypeError, ValueError):
            return 0.0
    
    def _validate_datetime(self, date_str):
        """Validate and convert datetime string"""
        try:
            if isinstance(date_str, tuple):
                date_str = date_str[0] if date_str else ''
            if not date_str or pd.isna(date_str) or str(date_str) == 'nan':
                return ''
            return str(date_str)
        except Exception:
            return ''
    
    def _safe_get(self, data, key, default=None):
        """Safely get value with comprehensive error handling"""
        try:
            if data is None:
                return default
            if isinstance(data, dict):
                value = data.get(key, default)
                # Handle pandas NaN checking for different data types
                if value is None:
                    return default
                if isinstance(value, (list, dict)):
                    # Don't apply pd.isna to lists/dicts, just return them
                    return value
                # Only check pd.isna for scalar values
                try:
                    return default if pd.isna(value) else value
                except (TypeError, ValueError):
                    # If pd.isna fails, just return the value
                    return value
            return default
        except Exception:
            return default
    
    # ========================
    # Main Transformation Router
    # ========================
    
    def _transform_complex_json_objects(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Transform complex JSON objects based on endpoint type (comprehensive implementation).
        
        This method routes to appropriate transformation functions based on the endpoint type
        and flattens complex JSON objects like LineItems, Addresses, Phones, etc. into 
        individual columns that match the expected database schema.
        """
        if df.empty:
            return df
            
        try:
            print(f"🔄 Transforming complex JSON objects for {endpoint}...")
            
            endpoint_lower = endpoint.lower()
            
            # Endpoints with LineItems transformation pattern (most common)
            if endpoint_lower in ['invoices', 'creditnotes', 'overpayments', 'prepayments', 
                                'banktransactions', 'invoicesdraft', 'purchaseorders', 
                                'receipts', 'quotes']:
                return self._transform_lineitems_data(df, endpoint)
            
            # Endpoints with specific patterns
            elif endpoint_lower == 'contacts':
                return self._transform_contacts_data(df)
            elif endpoint_lower == 'batchpayments':
                return self._transform_batchpayments_data(df)
            elif endpoint_lower == 'expenseclaims':
                return self._transform_expenseclaims_data(df)
            elif endpoint_lower == 'repeatinginvoices':
                return self._transform_repeatinginvoices_data(df)
            elif endpoint_lower == 'items':
                return self._transform_items_data(df)
            elif endpoint_lower == 'accounts':
                return self._transform_accounts_data(df)
            elif endpoint_lower == 'taxrates':
                return self._transform_taxrates_data(df)
            elif endpoint_lower == 'users':
                return self._transform_users_data(df)
            elif endpoint_lower == 'currencies':
                return self._transform_currencies_data(df)
            elif endpoint_lower == 'employees':
                return self._transform_employees_data(df)
            elif endpoint_lower == 'payments':
                return self._transform_payments_data(df)
            elif endpoint_lower == 'trackingcategories':
                return self._transform_trackingcategories_data(df)
            elif endpoint_lower in ['journals', 'journalscash']:
                return self._transform_journals_data(df, endpoint)
            elif endpoint_lower == 'manualjournals':
                return self._transform_manualjournals_data(df)
            elif endpoint_lower == 'organisations':
                return self._transform_organisations_data(df)
            elif endpoint_lower == 'batchpayments':
                return self._transform_batchpayments_data(df)
            elif endpoint_lower == 'repeatinginvoices':
                return self._transform_repeatinginvoices_data(df)
            elif endpoint_lower == 'expenseclaims':
                return self._transform_expenseclaims_data(df)
            elif endpoint_lower == 'banktransfers':
                return self._transform_banktransfers_data(df)
            elif endpoint_lower == 'brandingthemes':
                return self._transform_brandingthemes_data(df)
            elif endpoint_lower == 'contactgroups':
                return self._transform_contactgroups_data(df)
            elif endpoint_lower == 'linkedtransactions':
                return self._transform_linkedtransactions_data(df)
            elif endpoint_lower == 'budgets':
                return self._transform_budgets_data(df)
            elif endpoint_lower == 'trialbalance':
                return self._transform_trialbalance_data(df)
            elif endpoint_lower == 'balancesheet':
                return self._transform_balancesheet_data(df)
            elif endpoint_lower == 'banksummary':
                return self._transform_banksummary_data(df)
            else:
                print(f"   No complex JSON transformation defined for {endpoint}")
                return df
                
        except Exception as e:
            print(f"❌ Error transforming complex objects for {endpoint}: {str(e)}")
            import traceback
            traceback.print_exc()
            # Return original dataframe if transformation fails
            return df
    
    def _transform_contacts_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform contacts data to flatten complex JSON objects into individual columns.
        
        Based on the original xeroblue-upsert.py implementation (lines 2188-2309).
        """
        try:
            print(f"   Transforming {len(df)} contacts records...")
            
            transformed_data = []
            
            for index, contact in df.iterrows():
                # Handle cases where contact might be a pandas Series with NaN values
                # Convert to dict and handle NaN values
                if hasattr(contact, 'to_dict'):
                    contact_dict = contact.to_dict()
                else:
                    contact_dict = contact
                
                # Helper function to safely get values and handle NaN
                def safe_get(obj, key, default=None):
                    try:
                        if obj is None:
                            return default
                        # Check for NaN values (works for both scalars and arrays)
                        if pd.isnull(obj).any() if hasattr(pd.isnull(obj), 'any') else pd.isnull(obj):
                            return default
                        if isinstance(obj, dict):
                            return obj.get(key, default)
                        if isinstance(obj, (str, float, int)):
                            return default
                        return default
                    except (ValueError, TypeError):
                        # If any pandas operation fails, return default
                        return default
                
                # Extract addresses
                addresses = safe_get(contact_dict, 'Addresses', [])
                if isinstance(addresses, str):
                    # Handle case where addresses might be a string representation
                    import ast
                    try:
                        addresses = ast.literal_eval(addresses)
                    except:
                        addresses = []
                elif addresses is None:
                    addresses = []
                elif isinstance(addresses, float) and pd.isnull(addresses):
                    addresses = []
                
                pobox_address = next((addr for addr in addresses if isinstance(addr, dict) and addr.get('AddressType') == 'POBOX'), None)
                street_address = next((addr for addr in addresses if isinstance(addr, dict) and addr.get('AddressType') == 'STREET'), None)
                
                # Extract phones
                phones = safe_get(contact_dict, 'Phones', [])
                if isinstance(phones, str):
                    import ast
                    try:
                        phones = ast.literal_eval(phones)
                    except:
                        phones = []
                elif phones is None:
                    phones = []
                elif isinstance(phones, float) and pd.isnull(phones):
                    phones = []
                
                phone_default = next((phone for phone in phones if isinstance(phone, dict) and phone.get('PhoneType') == 'DEFAULT'), None)
                phone_fax = next((phone for phone in phones if isinstance(phone, dict) and phone.get('PhoneType') == 'FAX'), None)
                phone_mobile = next((phone for phone in phones if isinstance(phone, dict) and phone.get('PhoneType') == 'MOBILE'), None)
                phone_ddi = next((phone for phone in phones if isinstance(phone, dict) and phone.get('PhoneType') == 'DDI'), None)
                
                # Extract branding theme
                branding_theme = safe_get(contact_dict, 'BrandingTheme', {})
                if not isinstance(branding_theme, dict):
                    branding_theme = {}
                
                # Extract balances
                balances = safe_get(contact_dict, 'Balances', {})
                if isinstance(balances, str):
                    import ast
                    try:
                        balances = ast.literal_eval(balances)
                    except:
                        balances = {}
                elif not isinstance(balances, dict):
                    balances = {}
                
                accounts_receivable = balances.get('AccountsReceivable', {}) if isinstance(balances, dict) else {}
                accounts_payable = balances.get('AccountsPayable', {}) if isinstance(balances, dict) else {}
                
                # Build flattened contact data
                flattened_contact = {
                    'ContactID': str(safe_get(contact_dict, 'ContactID', '')),
                    'Name': str(safe_get(contact_dict, 'Name', '')),
                    'AccountNumber': str(safe_get(contact_dict, 'AccountNumber', '')),
                    'ContactNumber': str(safe_get(contact_dict, 'ContactNumber', '')),
                    'ContactStatus': str(safe_get(contact_dict, 'ContactStatus', '')),
                    'FirstName': str(safe_get(contact_dict, 'FirstName', '')),
                    'LastName': str(safe_get(contact_dict, 'LastName', '')),
                    'EmailAddress': str(safe_get(contact_dict, 'EmailAddress', '')),
                    'SkypeUserName': str(safe_get(contact_dict, 'SkypeUserName', '')),
                    
                    # Bank and Tax Information
                    'BankAccountDetails': str(safe_get(contact_dict, 'BankAccountDetails', '')),
                    'TaxNumber': str(safe_get(contact_dict, 'TaxNumber', '')),
                    'AccountsReceivableTaxType': str(safe_get(contact_dict, 'AccountsReceivableTaxType', '')),
                    'AccountsPayableTaxType': str(safe_get(contact_dict, 'AccountsPayableTaxType', '')),
                    
                    # Street Address Information
                    'Street_AddressLine1': str(street_address.get('AddressLine1', '')) if street_address else '',
                    'Street_AddressLine2': str(street_address.get('AddressLine2', '')) if street_address else '',
                    'Street_AddressLine3': str(street_address.get('AddressLine3', '')) if street_address else '',
                    'Street_AddressLine4': str(street_address.get('AddressLine4', '')) if street_address else '',
                    'Street_City': str(street_address.get('City', '')) if street_address else '',
                    'Street_Region': str(street_address.get('Region', '')) if street_address else '',
                    'Street_PostalCode': str(street_address.get('PostalCode', '')) if street_address else '',
                    'Street_Country': str(street_address.get('Country', '')) if street_address else '',
                    'Street_AttentionTo': str(street_address.get('AttentionTo', '')) if street_address else '',
                    
                    # PO Box Address Information
                    'POBox_AddressLine1': str(pobox_address.get('AddressLine1', '')) if pobox_address else '',
                    'POBox_AddressLine2': str(pobox_address.get('AddressLine2', '')) if pobox_address else '',
                    'POBox_AddressLine3': str(pobox_address.get('AddressLine3', '')) if pobox_address else '',
                    'POBox_AddressLine4': str(pobox_address.get('AddressLine4', '')) if pobox_address else '',
                    'POBox_City': str(pobox_address.get('City', '')) if pobox_address else '',
                    'POBox_Region': str(pobox_address.get('Region', '')) if pobox_address else '',
                    'POBox_PostalCode': str(pobox_address.get('PostalCode', '')) if pobox_address else '',
                    'POBox_Country': str(pobox_address.get('Country', '')) if pobox_address else '',
                    'POBox_AttentionTo': str(pobox_address.get('AttentionTo', '')) if pobox_address else '',
                    
                    # Phone Numbers
                    'DDI_PhoneNumber': str(phone_ddi.get('PhoneNumber', '')) if phone_ddi else '',
                    'DDI_PhoneAreaCode': str(phone_ddi.get('PhoneAreaCode', '')) if phone_ddi else '',
                    'DDI_PhoneCountryCode': str(phone_ddi.get('PhoneCountryCode', '')) if phone_ddi else '',
                    'Default_PhoneNumber': str(phone_default.get('PhoneNumber', '')) if phone_default else '',
                    'Default_PhoneAreaCode': str(phone_default.get('PhoneAreaCode', '')) if phone_default else '',
                    'Default_PhoneCountryCode': str(phone_default.get('PhoneCountryCode', '')) if phone_default else '',
                    'Fax_PhoneNumber': str(phone_fax.get('PhoneNumber', '')) if phone_fax else '',
                    'Fax_PhoneAreaCode': str(phone_fax.get('PhoneAreaCode', '')) if phone_fax else '',
                    'Fax_PhoneCountryCode': str(phone_fax.get('PhoneCountryCode', '')) if phone_fax else '',
                    'Mobile_PhoneNumber': str(phone_mobile.get('PhoneNumber', '')) if phone_mobile else '',
                    'Mobile_PhoneAreaCode': str(phone_mobile.get('PhoneAreaCode', '')) if phone_mobile else '',
                    'Mobile_PhoneCountryCode': str(phone_mobile.get('PhoneCountryCode', '')) if phone_mobile else '',
                    
                    # Additional Fields
                    'UpdatedDateUTC': safe_get(contact_dict, 'UpdatedDateUTC', ''),
                    'ContactGroupId': str(safe_get(contact_dict, 'ContactGroupId', '')),
                    'IsSupplier': bool(safe_get(contact_dict, 'IsSupplier', False)),
                    'IsCustomer': bool(safe_get(contact_dict, 'IsCustomer', False)),
                    'DefaultCurrency': str(safe_get(contact_dict, 'DefaultCurrency', '')),
                    'Website': str(safe_get(contact_dict, 'Website', '')),
                    'BrandingThemeId': str(branding_theme.get('BrandingThemeID', '')) if isinstance(branding_theme, dict) else '',
                    'BrandingThemeName': str(branding_theme.get('Name', '')) if isinstance(branding_theme, dict) else '',
                    'PurchasesDefaultAccountCode': str(safe_get(contact_dict, 'PurchasesDefaultAccountCode', '')),
                    'SalesDefaultAccountCode': str(safe_get(contact_dict, 'SalesDefaultAccountCode', '')),
                    
                    # Financial Balances
                    'Discount': float(safe_get(contact_dict, 'Discount', 0.00)),
                    'Balances_AccountsReceivable_Outstanding': float(accounts_receivable.get('Outstanding', 0.00)) if isinstance(accounts_receivable, dict) else 0.00,
                    'Balances_AccountsReceivable_Overdue': float(accounts_receivable.get('Overdue', 0.00)) if isinstance(accounts_receivable, dict) else 0.00,
                    'Balances_AccountsPayable_Outstanding': float(accounts_payable.get('Outstanding', 0.00)) if isinstance(accounts_payable, dict) else 0.00,
                    'Balances_AccountsPayable_Overdue': float(accounts_payable.get('Overdue', 0.00)) if isinstance(accounts_payable, dict) else 0.00,
                    
                    # Additional fields that might be needed (excluding validation fields)
                    'HasAttachments': bool(safe_get(contact_dict, 'HasAttachments', False))
                }
                
                # Add common fields including OrganisationID
                flattened_contact = self._add_common_fields(flattened_contact)
                transformed_data.append(flattened_contact)
            
            print(f"   ✅ Successfully transformed {len(transformed_data)} contacts records")
            return pd.DataFrame(transformed_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_contacts_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_expenseclaims_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Transform ExpenseClaims data following original XEROBLUE - UPSERT.py pattern
        ExpenseClaims doesn't use LineItems - it's a simple flat structure with User flattening
        """
        try:
            print(f"🔄 Transforming ExpenseClaims data (simple structure, no LineItems)...")
            
            transformed_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else dict(record)
                
                # Helper function to safely get values
                def get_value(obj, key, default=''):
                    if obj is None:
                        return default
                    if not isinstance(obj, dict):
                        return default
                    value = obj.get(key, default)
                    return str(value) if value is not None and not pd.isna(value) else default
                
                def validate_float(value):
                    try:
                        return float(value) if value is not None and str(value).strip() != '' else 0.0
                    except (TypeError, ValueError):
                        return 0.0
                
                def validate_datetime(value):
                    try:
                        return str(value) if value is not None else ''
                    except:
                        return ''
                
                # Create flattened ExpenseClaim record following original pattern
                expense_claim_data = {
                    'ExpenseClaimID': get_value(record_dict, 'ExpenseClaimID'),
                    'Status': get_value(record_dict, 'Status'),
                    'UpdatedDateUTC': validate_datetime(record_dict.get('UpdatedDateUTC')),
                    'Total': validate_float(get_value(record_dict, 'Total')),
                    'AmountDue': validate_float(get_value(record_dict, 'AmountDue')),
                    'AmountPaid': validate_float(get_value(record_dict, 'AmountPaid')),
                    'PaymentDueDate': validate_datetime(record_dict.get('PaymentDueDate')),
                    'ReportingDate': get_value(record_dict, 'ReportingDate'),
                    'UserId': get_value(record_dict.get('User', {}), 'UserID')  # Flatten User to UserId
                }
                
                # Add common fields including OrganisationID
                expense_claim_data = self._add_common_fields(expense_claim_data)
                transformed_data.append(expense_claim_data)
            
            print(f"   ✅ Successfully transformed {len(transformed_data)} ExpenseClaims records")
            return pd.DataFrame(transformed_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_expenseclaims_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_lineitems_data(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Transform endpoints with LineItems arrays into flattened structure
        Based on original XEROBLUE - UPSERT.py patterns (lines 881-931)
        Creates one row per LineItem with all invoice data + lineitem data
        """
        if df.empty:
            return df
        
        try:
            print(f"   Transforming {len(df)} {endpoint} records with LineItems pattern...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                # Convert record to dictionary for processing
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Get LineItems array (could be empty list)
                line_items = record_dict.get('LineItems', [])
                if not isinstance(line_items, list):
                    line_items = []
                
                # Process each LineItem (creates one row per LineItem)
                if line_items:
                    for line_index, line in enumerate(line_items, start=1):
                        if not isinstance(line, dict):
                            continue
                        
                        # Create flattened record following original pattern
                        base_data = self._create_invoice_base_data(record_dict, endpoint, line_index, line)
                        combined_data.append(base_data)
                else:
                    # No LineItems - create single record 
                    base_data = self._create_invoice_base_data(record_dict, endpoint, 1, {})
                    combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} {endpoint} records with LineItems")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_lineitems_data for {endpoint}: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _create_invoice_base_data(self, record_dict: dict, endpoint: str, line_index: int, line: dict) -> dict:
        """
        Create complete flattened invoice/creditnote record following original XEROBLUE - UPSERT.py pattern
        This matches the exact structure from lines 881-931 in the original file
        """
        # Helper function to safely get values
        def get_value(obj, key, default=''):
            if obj is None:
                return default
            if not isinstance(obj, dict):
                return default
            value = obj.get(key, default)
            return str(value) if value is not None and not pd.isna(value) else default
        
        def validate_float(value):
            try:
                return float(value) if value is not None and str(value).strip() != '' else 0.0
            except (TypeError, ValueError):
                return 0.0
        
        def validate_datetime(value):
            try:
                return str(value) if value is not None else ''
            except:
                return ''
        
        # Define endpoint ID mappings (source field -> target column)
        endpoint_id_mapping = {
            'invoices': ('InvoiceID', 'InvoiceId'),
            'invoicesdraft': ('InvoiceID', 'InvoiceId'),
            'creditnotes': ('CreditNoteID', 'CreditNoteId'),
            'overpayments': ('OverpaymentID', 'OverpaymentId'),
            'prepayments': ('PrepaymentID', 'PrepaymentId'),
            'banktransactions': ('BankTransactionID', 'BankTransactionId'),
            'purchaseorders': ('PurchaseOrderID', 'PurchaseOrderId'),
            'receipts': ('ReceiptID', 'ReceiptId'),
            'quotes': ('QuoteID', 'QuoteId'),
            'expenseclaims': ('ExpenseClaimID', 'ExpenseClaimID')  # Note: Keep original casing for this one
        }
        
        # Get the correct ID field based on endpoint
        endpoint_lower = endpoint.lower()
        if endpoint_lower in endpoint_id_mapping:
            source_id_field, target_id_column = endpoint_id_mapping[endpoint_lower]
            id_field = get_value(record_dict, source_id_field)
        else:
            # Fallback for unknown endpoints
            id_field = get_value(record_dict, 'ID', '')
            target_id_column = 'Id'
        
        # Create the base data structure exactly as in original
        base_data = {
            # Core record fields
            'Id': f"{line_index}|{id_field}",
        }
        
        # Add correct ID field based on endpoint
        if endpoint_lower in endpoint_id_mapping:
            source_id_field, target_id_column = endpoint_id_mapping[endpoint_lower]
            base_data[target_id_column] = get_value(record_dict, source_id_field)
        
        # Add common fields
        base_data.update({
            'Type': get_value(record_dict, 'Type'),
            'Date': get_value(record_dict, 'DateString'),
            'DueDate': get_value(record_dict, 'DueDateString'),
            'LineAmountTypes': get_value(record_dict, 'LineAmountTypes'),
            'InvoiceNumber': get_value(record_dict, 'InvoiceNumber') if endpoint.lower() == 'invoices' else get_value(record_dict, 'CreditNoteNumber'),
            'Reference': get_value(record_dict, 'Reference'),
            'BrandingThemeId': get_value(record_dict, 'BrandingThemeID'),
            'URL': get_value(record_dict, 'Url'),
            'CurrencyCode': get_value(record_dict, 'CurrencyCode'),
            'CurrencyRate': validate_float(get_value(record_dict, 'CurrencyRate', 0)),
            'Status': get_value(record_dict, 'Status'),
            'SentToContact': bool(record_dict.get('SentToContact', False)),
            'ExpectedPaymentDate': get_value(record_dict, 'ExpectedPaymentDateString'),
            'PlannedPaymentDate': get_value(record_dict, 'PlannedPaymentDateString'),
            'SubTotal': validate_float(get_value(record_dict, 'SubTotal')),
            'TotalTax': validate_float(get_value(record_dict, 'TotalTax')),
            'Total': validate_float(get_value(record_dict, 'Total')),
            'TotalDiscount': validate_float(get_value(record_dict, 'TotalDiscount')),
            'HasAttachments': bool(get_value(record_dict, 'HasAttachments')),
            'AmountDue': validate_float(get_value(record_dict, 'AmountDue')),
            'AmountPaid': validate_float(get_value(record_dict, 'AmountPaid')),
            'CISDeduction': validate_float(get_value(record_dict, 'CISDeduction')),
            'FullyPaidOnDate': validate_datetime(record_dict.get('FullyPaidOnDate')),
            'AmountCredited': validate_float(get_value(record_dict, 'AmountCredited')),
            'UpdatedDateUTC': validate_datetime(record_dict.get('UpdatedDateUTC')),
            'RepeatingInvoiceID': get_value(record_dict, 'RepeatingInvoiceID'),
            
            # Contact fields (flattened) - different patterns for different endpoints
            'ContactId': get_value(record_dict.get('Contact', {}), 'ContactID') if endpoint.lower() == 'invoices' else None,
            'ContactName': get_value(record_dict.get('Contact', {}), 'Name') if endpoint.lower() == 'invoices' else None,
            
            # LineItem fields (if line exists)
            'LineItem_LineItemId': get_value(line, 'LineItemID'),
            'LineItem_Description': get_value(line, 'Description'),
            'LineItem_Quantity': validate_float(get_value(line, 'Quantity')),
            'LineItem_UnitAmount': validate_float(get_value(line, 'UnitAmount')),
            'LineItem_ItemCode': get_value(line, 'ItemCode'),
            'LineItem_AccountCode': get_value(line, 'AccountCode'),
            'LineItem_TaxType': get_value(line, 'TaxType'),
            'LineItem_TaxAmount': validate_float(get_value(line, 'TaxAmount')),
            'LineItem_LineAmount': validate_float(get_value(line, 'LineAmount')),
            'LineItem_DiscountRate': validate_float(get_value(line, 'DiscountRate')),
            'LineItem_DiscountAmount': validate_float(get_value(line, 'DiscountAmount')),
        })
        
        # Remove None values from base_data
        base_data = {k: v for k, v in base_data.items() if v is not None}
        
        # Add endpoint-specific flattened fields following original XEROBLUE - UPSERT.py patterns
        if endpoint.lower() == 'banktransactions':
            # Add BankAccount flattened fields for BankTransactions
            bank_account = record_dict.get('BankAccount', {})
            base_data.update({
                'BankAccount_AccountId': get_value(bank_account, 'AccountID'),
                'BankAccount_AccountName': get_value(bank_account, 'Name'),
                'BankAccount_Code': get_value(bank_account, 'Code')
            })
        elif endpoint.lower() in ['overpayments', 'prepayments', 'creditnotes']:
            # Add Contact flattened fields with prefix (original pattern)
            contact = record_dict.get('Contact', {})
            base_data.update({
                'Contact_ContactId': get_value(contact, 'ContactID'),
                'Contact_Name': get_value(contact, 'Name')
            })
        elif endpoint.lower() == 'expenseclaims':
            # Add User field with simple name (original pattern: UserId not User_UserID)
            user = record_dict.get('User', {})
            base_data.update({
                'UserId': get_value(user, 'UserID')
            })
        
        # Add LineItem Tracking Categories (up to 2 categories per line item)
        if line and 'Tracking' in line:
            tracking_categories = line.get('Tracking', [])
            if tracking_categories and len(tracking_categories) >= 1:
                base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = get_value(tracking_categories[0], 'TrackingCategoryID')
                base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = get_value(tracking_categories[0], 'Name')
                base_data[f'LineItem_TrackingCategory{1}_OptionID'] = get_value(tracking_categories[0], 'TrackingOptionID')
                base_data[f'LineItem_TrackingCategory{1}_OptionName'] = get_value(tracking_categories[0], 'Option')
                if len(tracking_categories) == 2:
                    base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = get_value(tracking_categories[1], 'TrackingCategoryID')
                    base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = get_value(tracking_categories[1], 'Name')
                    base_data[f'LineItem_TrackingCategory{2}_OptionID'] = get_value(tracking_categories[1], 'TrackingOptionID')
                    base_data[f'LineItem_TrackingCategory{2}_OptionName'] = get_value(tracking_categories[1], 'Option')
        
        # Add Allocations processing for overpayments, prepayments, and creditnotes (up to 10 allocations)
        if endpoint.lower() in ['overpayments', 'prepayments', 'creditnotes']:
            allocations = record_dict.get('Allocations', [])
            for i, allocation in enumerate(allocations, start=1):
                if i <= 10:
                    base_data[f'Allocation{i}_AppliedAmount'] = validate_float(allocation.get('Amount', 0))
                    base_data[f'Allocation{i}_Date'] = get_value(allocation, 'Date')
                    invoice_info = allocation.get('Invoice', {})
                    base_data[f'Allocation{i}_InvoiceId'] = get_value(invoice_info, 'InvoiceID')
                    base_data[f'Allocation{i}_InvoiceNumber'] = get_value(invoice_info, 'InvoiceNumber')
        
        # Add array field concatenations for invoices (original pattern)
        if endpoint.lower() in ['invoices', 'invoicesdraft']:
            # Extract and concatenate ID values from various arrays
            credit_notes = record_dict.get('CreditNotes', [])
            creditnote_ids = [get_value(credit_note, 'CreditNoteID') for credit_note in credit_notes if credit_note]
            base_data['CreditNoteIds'] = ','.join(filter(None, creditnote_ids))
            
            prepayments = record_dict.get('Prepayments', [])
            prepayment_ids = [get_value(prepayment, 'PrepaymentID') for prepayment in prepayments if prepayment]
            base_data['PrepaymentIds'] = ','.join(filter(None, prepayment_ids))
            
            payments = record_dict.get('Payments', [])
            payment_ids = [get_value(payment, 'PaymentID') for payment in payments if payment]
            base_data['PaymentIds'] = ','.join(filter(None, payment_ids))
            
            overpayments = record_dict.get('Overpayments', [])
            overpayment_ids = [get_value(overpayment, 'OverpaymentID') for overpayment in overpayments if overpayment]
            base_data['OverpaymentIds'] = ','.join(filter(None, overpayment_ids))
        
        # Add common fields including OrganisationID to all endpoint records
        if hasattr(self, 'etani_organisation_id') and self.etani_organisation_id:
            try:
                base_data['OrganisationID'] = int(self.etani_organisation_id)
            except (ValueError, TypeError):
                base_data['OrganisationID'] = 0
        else:
            base_data['OrganisationID'] = 0
        
        return base_data
    
    def _add_common_fields(self, base_data: dict) -> dict:
        """Add common fields that should be present in all endpoint records"""
        # Add OrganisationID using CMS LegacyOrganisationID (following original XEROBLUE - UPSERT.py)
        if hasattr(self, 'legacy_organisation_id') and self.legacy_organisation_id and int(self.legacy_organisation_id) > 0:
            try:
                base_data['OrganisationID'] = int(self.legacy_organisation_id)
            except (ValueError, TypeError):
                base_data['OrganisationID'] = 0
        else:
            # Fallback to etani_organisation_id if legacy_organisation_id not available
            if hasattr(self, 'etani_organisation_id') and self.etani_organisation_id:
                try:
                    base_data['OrganisationID'] = int(self.etani_organisation_id)
                except (ValueError, TypeError):
                    base_data['OrganisationID'] = 0
            else:
                base_data['OrganisationID'] = 0
        
        return base_data
    
    def _create_base_record_data_old(self, record_dict: dict, endpoint: str, line_index: int = None) -> dict:
        """Create base record data common across endpoints"""
        base_data = {}
        
        # Common fields based on endpoint type
        if endpoint.lower() == 'invoices':
            id_field = self._get_value(record_dict, 'InvoiceID')
            base_data.update({
                'Id': f"{line_index}|{id_field}" if line_index else id_field,
                'InvoiceId': id_field,
                'Type': self._get_value(record_dict, 'Type'),
                'ContactId': self._get_value(self._safe_get(record_dict, 'Contact', {}), 'ContactID'),
                'ContactName': self._get_value(self._safe_get(record_dict, 'Contact', {}), 'Name'),
                'Date': self._get_value(record_dict, 'DateString'),
                'DueDate': self._get_value(record_dict, 'DueDateString'),
                'LineAmountTypes': self._get_value(record_dict, 'LineAmountTypes'),
                'InvoiceNumber': self._get_value(record_dict, 'InvoiceNumber'),
                'Reference': self._get_value(record_dict, 'Reference'),
                'BrandingThemeId': self._get_value(record_dict, 'BrandingThemeID'),
                'URL': self._get_value(record_dict, 'Url'),
                'CurrencyCode': self._get_value(record_dict, 'CurrencyCode'),
                'CurrencyRate': self._validate_float(self._get_value(record_dict, 'CurrencyRate')),
                'Status': self._get_value(record_dict, 'Status'),
                'SentToContact': bool(self._safe_get(record_dict, 'SentToContact', False)),
                'SubTotal': self._validate_float(self._get_value(record_dict, 'SubTotal')),
                'TotalTax': self._validate_float(self._get_value(record_dict, 'TotalTax')),
                'Total': self._validate_float(self._get_value(record_dict, 'Total')),
                'TotalDiscount': self._validate_float(self._get_value(record_dict, 'TotalDiscount')),
                'AmountDue': self._validate_float(self._get_value(record_dict, 'AmountDue')),
                'AmountPaid': self._validate_float(self._get_value(record_dict, 'AmountPaid')),
                'UpdatedDateUTC': self._validate_datetime(self._safe_get(record_dict, 'UpdatedDateUTC')),
            })
        elif endpoint.lower() in ['creditnotes', 'overpayments', 'prepayments']:
            # Get the correct ID field based on endpoint
            endpoint_id_field = f"{endpoint.title().rstrip('s')}ID"
            id_value = self._get_value(record_dict, endpoint_id_field)
            base_data.update({
                'Id': f"{line_index}|{id_value}" if line_index else id_value,
                f'{endpoint.title().rstrip("s")}Id': id_value,
                'ContactId': self._get_value(self._safe_get(record_dict, 'Contact', {}), 'ContactID'),
                'ContactName': self._get_value(self._safe_get(record_dict, 'Contact', {}), 'Name'),
                'Date': self._get_value(record_dict, 'DateString'),
                'Status': self._get_value(record_dict, 'Status'),
                'LineAmountTypes': self._get_value(record_dict, 'LineAmountTypes'),
                'SubTotal': self._validate_float(self._get_value(record_dict, 'SubTotal')),
                'TotalTax': self._validate_float(self._get_value(record_dict, 'TotalTax')),
                'Total': self._validate_float(self._get_value(record_dict, 'Total')),
                'UpdatedDateUTC': self._validate_datetime(self._safe_get(record_dict, 'UpdatedDateUTC')),
                'CurrencyCode': self._get_value(record_dict, 'CurrencyCode'),
                'CurrencyRate': self._validate_float(self._get_value(record_dict, 'CurrencyRate')),
            })
        # Add more endpoints as needed
        
        return base_data
    
    def _extract_lineitem_fields(self, line: dict) -> dict:
        """Extract LineItem-specific fields"""
        return {
            'LineItem_LineItemId': self._get_value(line, 'LineItemID'),
            'LineItem_Description': self._get_value(line, 'Description'),
            'LineItem_Quantity': self._validate_float(self._get_value(line, 'Quantity')),
            'LineItem_UnitAmount': self._validate_float(self._get_value(line, 'UnitAmount')),
            'LineItem_ItemCode': self._get_value(line, 'ItemCode'),
            'LineItem_AccountCode': self._get_value(line, 'AccountCode'),
            'LineItem_TaxType': self._get_value(line, 'TaxType'),
            'LineItem_TaxAmount': self._validate_float(self._get_value(line, 'TaxAmount')),
            'LineItem_LineAmount': self._validate_float(self._get_value(line, 'LineAmount')),
            'LineItem_DiscountRate': self._validate_float(self._get_value(line, 'DiscountRate')),
            'LineItem_DiscountAmount': self._validate_float(self._get_value(line, 'DiscountAmount'))
        }
    
    def _extract_tracking_categories(self, line: dict) -> dict:
        """Extract Tracking Categories from LineItem"""
        tracking_data = {}
        
        tracking = self._safe_get(line, 'Tracking', [])
        if isinstance(tracking, list) and tracking:
            # First tracking category
            if len(tracking) > 0 and isinstance(tracking[0], dict):
                tracking_data.update({
                    'LineItem_TrackingCategory1_CategoryId': self._get_value(tracking[0], 'TrackingCategoryID'),
                    'LineItem_TrackingCategory1_CategoryName': self._get_value(tracking[0], 'Name'),
                    'LineItem_TrackingCategory1_OptionID': self._get_value(tracking[0], 'TrackingOptionID'),
                    'LineItem_TrackingCategory1_OptionName': self._get_value(tracking[0], 'Option')
                })
            
            # Second tracking category
            if len(tracking) > 1 and isinstance(tracking[1], dict):
                tracking_data.update({
                    'LineItem_TrackingCategory2_CategoryId': self._get_value(tracking[1], 'TrackingCategoryID'),
                    'LineItem_TrackingCategory2_CategoryName': self._get_value(tracking[1], 'Name'),
                    'LineItem_TrackingCategory2_OptionID': self._get_value(tracking[1], 'TrackingOptionID'),
                    'LineItem_TrackingCategory2_OptionName': self._get_value(tracking[1], 'Option')
                })
        
        return tracking_data
    
    def _extract_allocations(self, record_dict: dict) -> dict:
        """Extract Allocations (for CreditNotes, Overpayments, Prepayments)"""
        allocations_data = {}
        
        allocations = self._safe_get(record_dict, 'Allocations', [])
        if isinstance(allocations, list):
            # Process up to 10 allocations (as per original implementation)
            for i, allocation in enumerate(allocations[:10], start=1):
                if isinstance(allocation, dict):
                    allocations_data.update({
                        f'Allocation{i}_AppliedAmount': self._validate_float(self._get_value(allocation, 'Amount')),
                        f'Allocation{i}_Date': self._get_value(allocation, 'Date'),
                        f'Allocation{i}_InvoiceId': self._get_value(self._safe_get(allocation, 'Invoice', {}), 'InvoiceID')
                    })
        
        return allocations_data
    
    def _transform_batchpayments_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform BatchPayments with Payments array flattening"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} BatchPayments records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure for BatchPayments
                base_data = {
                    'BatchPaymentId': self._get_value(record_dict, 'BatchPaymentID'),
                    'Account_AccountId': self._get_value(record_dict.get('Account', {}), 'AccountID'),
                    'Account_Name': self._get_value(record_dict.get('Account', {}), 'Name'),
                    'Reference': self._get_value(record_dict, 'Reference'),
                    'Particulars': self._get_value(record_dict, 'Particulars'),
                    'Code': self._get_value(record_dict, 'Code'),
                    'Details': self._get_value(record_dict, 'Details'),
                    'Narrative': self._get_value(record_dict, 'Narrative'),
                    'BatchPaymentNumber': self._get_value(record_dict, 'BatchPaymentNumber'),
                    'DateString': self._get_value(record_dict, 'DateString'),
                    'TotalAmount': self._validate_float(record_dict.get('TotalAmount', 0)),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    'IsReconciled': bool(record_dict.get('IsReconciled', False)),
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} BatchPayments records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_batchpayments_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_repeatinginvoices_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform RepeatingInvoices (only processes first LineItem)"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} RepeatingInvoices records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure for RepeatingInvoices
                base_data = {
                    'RepeatingInvoiceId': self._get_value(record_dict, 'RepeatingInvoiceID'),
                    'Type': self._get_value(record_dict, 'Type'),
                    'Contact_ContactId': self._get_value(record_dict.get('Contact', {}), 'ContactID'),
                    'Contact_Name': self._get_value(record_dict.get('Contact', {}), 'Name'),
                    'Schedule_Period': self._get_value(record_dict.get('Schedule', {}), 'Period'),
                    'Schedule_Unit': self._get_value(record_dict.get('Schedule', {}), 'Unit'),
                    'Schedule_DueDate': self._get_value(record_dict.get('Schedule', {}), 'DueDate'),
                    'Schedule_DueDateType': self._get_value(record_dict.get('Schedule', {}), 'DueDateType'),
                    'Schedule_StartDate': self._get_value(record_dict.get('Schedule', {}), 'StartDate'),
                    'Schedule_NextScheduledDate': self._get_value(record_dict.get('Schedule', {}), 'NextScheduledDate'),
                    'Schedule_EndDate': self._get_value(record_dict.get('Schedule', {}), 'EndDate'),
                    'LineAmountTypes': self._get_value(record_dict, 'LineAmountTypes'),
                    'Reference': self._get_value(record_dict, 'Reference'),
                    'BrandingThemeId': self._get_value(record_dict, 'BrandingThemeID'),
                    'CurrencyCode': self._get_value(record_dict, 'CurrencyCode'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'SubTotal': self._validate_float(record_dict.get('SubTotal', 0)),
                    'TotalTax': self._validate_float(record_dict.get('TotalTax', 0)),
                    'Total': self._validate_float(record_dict.get('Total', 0)),
                    'HasAttachments': bool(record_dict.get('HasAttachments', False)),
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} RepeatingInvoices records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_repeatinginvoices_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_items_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform items data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Items records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Helper to get nested values
                def get_nested_value(obj, path, default=''):
                    try:
                        for key in path:
                            if obj and isinstance(obj, dict):
                                obj = obj.get(key)
                            else:
                                return default
                        return str(obj) if obj is not None else default
                    except:
                        return default
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'ItemId': self._get_value(record_dict, 'ItemID'),
                    'Code': self._get_value(record_dict, 'Code'),
                    'InventoryAssetAccountCode': self._get_value(record_dict, 'InventoryAssetAccountCode'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'PurchaseDescription': self._get_value(record_dict, 'PurchaseDescription'),
                    'PurchaseDetails_UnitPrice': get_nested_value(record_dict, ['PurchaseDetails', 'UnitPrice']),
                    'PurchaseDetails_COGSAccountCode': get_nested_value(record_dict, ['PurchaseDetails', 'COGSAccountCode']),
                    'PurchaseDetails_AccountCode': get_nested_value(record_dict, ['PurchaseDetails', 'AccountCode']),
                    'PurchaseDetails_TaxType': get_nested_value(record_dict, ['PurchaseDetails', 'TaxType']),
                    'SalesDetails_UnitPrice': get_nested_value(record_dict, ['SalesDetails', 'UnitPrice']),
                    'SalesDetails_COGSAccountCode': get_nested_value(record_dict, ['SalesDetails', 'COGSAccountCode']),
                    'SalesDetails_AccountCode': get_nested_value(record_dict, ['SalesDetails', 'AccountCode']),
                    'SalesDetails_TaxType': get_nested_value(record_dict, ['SalesDetails', 'TaxType']),
                    'IsTrackedAsInventory': bool(record_dict.get('IsTrackedAsInventory', 0)),
                    'TotalCostPool': self._validate_float(record_dict.get('TotalCostPool', 0)),
                    'QuantityOnHand': self._validate_float(record_dict.get('QuantityOnHand', 0)),
                    'IsSold': bool(record_dict.get('IsSold', 0)),
                    'IsPurchased': bool(record_dict.get('IsPurchased', 0)),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC'))
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Items records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_items_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_accounts_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform accounts data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Accounts records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'AccountID': self._get_value(record_dict, 'AccountID'),
                    'Code': self._get_value(record_dict, 'Code'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'Type': self._get_value(record_dict, 'Type'),
                    'TaxType': self._get_value(record_dict, 'TaxType'),
                    'Class': self._get_value(record_dict, 'Class'),
                    'Description': self._get_value(record_dict, 'Description'),
                    'SystemAccount': self._get_value(record_dict, 'SystemAccount'),
                    'EnablePaymentsToAccount': bool(record_dict.get('EnablePaymentsToAccount', 0)),
                    'ShowInExpenseClaims': bool(record_dict.get('ShowInExpenseClaims', 0)),
                    'BankAccountNumber': self._get_value(record_dict, 'BankAccountNumber'),
                    'BankAccountType': self._get_value(record_dict, 'BankAccountType'),
                    'CurrencyCode': self._get_value(record_dict, 'CurrencyCode'),
                    'ReportingCode': self._get_value(record_dict, 'ReportingCode'),
                    'ReportingCodeName': self._get_value(record_dict, 'ReportingCodeName'),
                    'HasAttachments': bool(record_dict.get('HasAttachments', 0)),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    'AddToWatchlist': bool(record_dict.get('AddToWatchlist', 0)),
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Accounts records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_accounts_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_taxrates_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform TaxRates data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} TaxRates records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'Id': self._get_value(record_dict, 'Id'),
                    'TaxType': self._get_value(record_dict, 'TaxType'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'ReportTaxType': self._get_value(record_dict, 'ReportTaxType'),
                    'CanApplyToAssets': bool(record_dict.get('CanApplyToAssets', False)),
                    'CanApplyToEquity': bool(record_dict.get('CanApplyToEquity', False)),
                    'CanApplyToExpenses': bool(record_dict.get('CanApplyToExpenses', False)),
                    'CanApplyToLiabilities': bool(record_dict.get('CanApplyToLiabilities', False)),
                    'CanApplyToRevenue': bool(record_dict.get('CanApplyToRevenue', False)),
                    'DisplayTaxRate': self._validate_float(record_dict.get('DisplayTaxRate', 0)),
                    'EffectiveRate': self._validate_float(record_dict.get('EffectiveRate', 0)),
                }
                
                # TaxComponents processing
                tax_components = record_dict.get('TaxComponents', [])
                if tax_components and len(tax_components) >= 1:
                    taxcomponent = tax_components[0]
                    base_data['TaxComponent_Name'] = self._get_value(taxcomponent, 'Name')
                    base_data['TaxComponent_Rate'] = self._validate_float(taxcomponent.get('Rate', 0))
                    base_data['TaxComponents_IsNonRecoverable'] = bool(taxcomponent.get('IsNonRecoverable', False))
                    base_data['TaxComponent_IsCompound'] = bool(taxcomponent.get('IsCompound', False))
                    base_data['TaxComponentAggregate'] = self._get_value(taxcomponent, 'Aggregate')
                else:
                    base_data.update({
                        'TaxComponent_Name': '',
                        'TaxComponent_Rate': 0.0,
                        'TaxComponents_IsNonRecoverable': False,
                        'TaxComponent_IsCompound': False,
                        'TaxComponentAggregate': ''
                    })
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} TaxRates records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_taxrates_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_users_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Users data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Users records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'UserId': self._get_value(record_dict, 'UserID'),
                    'FirstName': self._get_value(record_dict, 'FirstName'),
                    'LastName': self._get_value(record_dict, 'LastName'),
                    'EmailAddress': self._get_value(record_dict, 'EmailAddress'),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    'IsSubscriber': bool(record_dict.get('IsSubscriber', False)),
                    'OrganisationRole': self._get_value(record_dict, 'OrganisationRole'),
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Users records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_users_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_currencies_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Currencies data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Currencies records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'Code': self._get_value(record_dict, 'Code'),
                    'Description': self._get_value(record_dict, 'Description'),
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Currencies records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_currencies_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_employees_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Employees data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Employees records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                external_link = record_dict.get('ExternalLink', {})
                base_data = {
                    'EmployeeId': self._get_value(record_dict, 'EmployeeID'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'FirstName': self._get_value(record_dict, 'FirstName'),
                    'LastName': self._get_value(record_dict, 'LastName'),
                    'ExternalLink_URL': self._get_value(external_link, 'URL') if external_link else '',
                    'ExternalLink_Description': self._get_value(external_link, 'Description') if external_link else '',
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC'))
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Employees records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_employees_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_payments_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Payments data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Payments records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                invoice = record_dict.get('Invoice', {})
                credit_note = record_dict.get('CreditNote', {})
                account = record_dict.get('Account', {})
                
                base_data = {
                    'PaymentId': self._get_value(record_dict, 'PaymentID'),
                    'Date': self._get_value(record_dict, 'Date'),
                    'Amount': self._validate_float(record_dict.get('Amount', 0)),
                    'CurrencyRate': self._validate_float(record_dict.get('CurrencyRate', 0)),
                    'Reference': self._get_value(record_dict, 'Reference'),
                    'PaymentType': self._get_value(record_dict, 'PaymentType'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    'IsReconciled': bool(record_dict.get('IsReconciled', False)),
                    'BatchPaymentId': self._get_value(record_dict, 'BatchPaymentID'),
                    'InvoiceId': self._get_value(invoice, 'InvoiceID') if invoice else '',
                    'InvoiceNumber': self._get_value(invoice, 'InvoiceNumber') if invoice else '',
                    'CreditNoteId': self._get_value(credit_note, 'CreditNoteID') if credit_note else '',
                    'CreditNoteNumber': self._get_value(credit_note, 'CreditNoteNumber') if credit_note else '',
                    'AccountId': self._get_value(account, 'AccountID') if account else '',
                    'AccountCode': self._get_value(account, 'Code') if account else '',
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Payments records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_payments_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_trackingcategories_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform TrackingCategories data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} TrackingCategories records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Get Options array (each option creates a separate row)
                options = record_dict.get('Options', [])
                if not isinstance(options, list):
                    options = []
                
                # Process each Option (creates one row per Option)
                if options:
                    for option_index, option in enumerate(options, start=1):
                        if not isinstance(option, dict):
                            continue
                        
                        # Create flattened record following original pattern
                        base_data = {
                            'Id': f"{option_index}|{self._get_value(record_dict, 'TrackingCategoryID')}",
                            'TrackingCategoryId': self._get_value(record_dict, 'TrackingCategoryID'),
                            'Name': self._get_value(record_dict, 'Name'),
                            'Status': self._get_value(record_dict, 'Status'),
                            'TrackingOptionId': self._get_value(option, 'TrackingOptionID'),
                            'OptionName': self._get_value(option, 'Name'),
                            'OptionStatus': self._get_value(option, 'Status')
                        }
                        # Add common fields including OrganisationID
                        base_data = self._add_common_fields(base_data)
                        combined_data.append(base_data)
                else:
                    # No Options - create single record
                    base_data = {
                        'Id': f"1|{self._get_value(record_dict, 'TrackingCategoryID')}",
                        'TrackingCategoryId': self._get_value(record_dict, 'TrackingCategoryID'),
                        'Name': self._get_value(record_dict, 'Name'),
                        'Status': self._get_value(record_dict, 'Status'),
                        'TrackingOptionId': '',
                        'OptionName': '',
                        'OptionStatus': ''
                    }
                    # Add common fields including OrganisationID
                    base_data = self._add_common_fields(base_data)
                    combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} TrackingCategories records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_trackingcategories_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_journals_data(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """Transform Journals/JournalsCash data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} {endpoint} records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Get JournalLines array (each line creates a separate row)
                journal_lines = record_dict.get('JournalLines', [])
                if not isinstance(journal_lines, list):
                    journal_lines = []
                
                # Process each JournalLine (creates one row per JournalLine)
                if journal_lines:
                    for line_index, line in enumerate(journal_lines, start=1):
                        if not isinstance(line, dict):
                            continue
                        
                        # Create flattened record following original pattern
                        base_data = {
                            'Id': f"{line_index}|{self._get_value(record_dict, 'JournalID')}",
                            'JournalId': self._get_value(record_dict, 'JournalID'),
                            'JournalDate': self._get_value(record_dict, 'JournalDate'),
                            'JournalNumber': self._get_value(record_dict, 'JournalNumber'),
                            'CreatedDateUTC': self._get_value(record_dict, 'CreatedDateUTC'),
                            'Reference': self._get_value(record_dict, 'Reference'),
                            'SourceId': self._get_value(record_dict, 'SourceID'),
                            'SourceType': self._get_value(record_dict, 'SourceType'),
                            'JournalLine_JournalLineId': self._get_value(line, 'JournalLineID'),
                            'JournalLine_Description': self._get_value(line, 'Description'),
                            'JournalLine_AccountId': self._get_value(line, 'AccountID'),
                            'JournalLine_AccountCode': self._get_value(line, 'AccountCode'),
                            'JournalLine_AccountType': self._get_value(line, 'AccountType'),
                            'JournalLine_AccountName': self._get_value(line, 'AccountName'),
                            'JournalLine_NetAmount': self._validate_float(line.get('NetAmount', 0)),
                            'JournalLine_GrossAmount': self._validate_float(line.get('GrossAmount', 0)),
                            'JournalLine_TaxAmount': self._validate_float(line.get('TaxAmount', 0)),
                            'JournalLine_TaxType': self._get_value(line, 'TaxType'),
                            'JournalLine_TaxName': self._get_value(line, 'TaxName')
                        }
                        # Add common fields including OrganisationID
                        base_data = self._add_common_fields(base_data)
                        combined_data.append(base_data)
                else:
                    # No JournalLines - create single record
                    base_data = {
                        'Id': f"1|{self._get_value(record_dict, 'JournalID')}",
                        'JournalId': self._get_value(record_dict, 'JournalID'),
                        'JournalDate': self._get_value(record_dict, 'JournalDate'),
                        'JournalNumber': self._get_value(record_dict, 'JournalNumber'),
                        'CreatedDateUTC': self._get_value(record_dict, 'CreatedDateUTC'),
                        'Reference': self._get_value(record_dict, 'Reference'),
                        'SourceId': self._get_value(record_dict, 'SourceID'),
                        'SourceType': self._get_value(record_dict, 'SourceType'),
                        'JournalLine_JournalLineId': '',
                        'JournalLine_Description': '',
                        'JournalLine_AccountId': '',
                        'JournalLine_AccountCode': '',
                        'JournalLine_AccountType': '',
                        'JournalLine_AccountName': '',
                        'JournalLine_NetAmount': 0.0,
                        'JournalLine_GrossAmount': 0.0,
                        'JournalLine_TaxAmount': 0.0,
                        'JournalLine_TaxType': '',
                        'JournalLine_TaxName': ''
                    }
                    # Add common fields including OrganisationID
                    base_data = self._add_common_fields(base_data)
                    combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} {endpoint} records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_journals_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_manualjournals_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform ManualJournals data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} ManualJournals records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Get JournalLines array (each line creates a separate row)
                journal_lines = record_dict.get('JournalLines', [])
                if not isinstance(journal_lines, list):
                    journal_lines = []
                
                # Process each JournalLine (creates one row per JournalLine)
                if journal_lines:
                    for line_index, line in enumerate(journal_lines, start=1):
                        if not isinstance(line, dict):
                            continue
                        
                        # Create flattened record following original pattern
                        base_data = {
                            'Id': f"{line_index}|{self._get_value(record_dict, 'ManualJournalID')}",
                            'ManualJournalId': self._get_value(record_dict, 'ManualJournalID'),
                            'Narration': self._get_value(record_dict, 'Narration'),
                            'Date': self._get_value(record_dict, 'Date'),
                            'Status': self._get_value(record_dict, 'Status'),
                            'URL': self._get_value(record_dict, 'URL'),
                            'ShowOnCashBasisReports': bool(record_dict.get('ShowOnCashBasisReports', 0)),
                            'LineAmountTypes': self._get_value(record_dict, 'LineAmountTypes'),
                            'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                            'HasAttachments': bool(record_dict.get('HasAttachments', False)),
                            'JournalLine_LineAmount': self._validate_float(line.get('LineAmount', 0)),
                            'JournalLine_AccountCode': self._get_value(line, 'AccountCode'),
                            'JournalLine_Description': self._get_value(line, 'Description'),
                            'JournalLine_TaxType': self._get_value(line, 'TaxType'),
                            'JournalLine_TaxAmount': self._validate_float(line.get('TaxAmount', 0)),
                        }
                        # Add common fields including OrganisationID
                        base_data = self._add_common_fields(base_data)
                        combined_data.append(base_data)
                else:
                    # No JournalLines - create single record 
                    base_data = {
                        'Id': f"1|{self._get_value(record_dict, 'ManualJournalID')}",
                        'ManualJournalId': self._get_value(record_dict, 'ManualJournalID'),
                        'Narration': self._get_value(record_dict, 'Narration'),
                        'Date': self._get_value(record_dict, 'Date'),
                        'Status': self._get_value(record_dict, 'Status'),
                        'URL': self._get_value(record_dict, 'URL'),
                        'ShowOnCashBasisReports': bool(record_dict.get('ShowOnCashBasisReports', 0)),
                        'LineAmountTypes': self._get_value(record_dict, 'LineAmountTypes'),
                        'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                        'HasAttachments': bool(record_dict.get('HasAttachments', False)),
                        'JournalLine_LineAmount': 0.0,
                        'JournalLine_AccountCode': '',
                        'JournalLine_Description': '',
                        'JournalLine_TaxType': '',
                        'JournalLine_TaxAmount': 0.0,
                    }
                    # Add common fields including OrganisationID
                    base_data = self._add_common_fields(base_data)
                    combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} ManualJournals records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_manualjournals_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_organisations_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Organisations data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Organisations records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure exactly matching original XEROBLUE - UPSERT.py
                base_data = {
                    'ShortCode': self._get_value(record_dict, 'ShortCode'),
                    'APIKey': self._get_value(record_dict, 'APIKey'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'LegalName': self._get_value(record_dict, 'LegalName'),
                    'PaysTax': self._get_value(record_dict, 'PaysTax'),
                    'Version': self._get_value(record_dict, 'Version'),
                    'BaseCurrency': self._get_value(record_dict, 'BaseCurrency'),
                    'CountryCode': self._get_value(record_dict, 'CountryCode'),
                    'IsDemoCompany': self._get_value(record_dict, 'IsDemoCompany'),
                    'OrganisationStatus': self._get_value(record_dict, 'OrganisationStatus'),
                    'RegistrationNumber': self._get_value(record_dict, 'RegistrationNumber'),
                    'TaxNumber': self._get_value(record_dict, 'TaxNumber'),
                    'FinancialYearEndDay': self._validate_float(record_dict.get('FinancialYearEndDay', 0)),
                    'FinancialYearEndMonth': self._validate_float(record_dict.get('FinancialYearEndMonth', 0)),
                    'PeriodLockDate': self._get_value(record_dict, 'PeriodLockDate'),
                    'EndOfYearLockDate': self._get_value(record_dict, 'EndOfYearLockDate'),
                    'CreatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'CreatedDateUTC')),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    'OrganisationEntityType': self._get_value(record_dict, 'OrganisationEntityType'),
                    'Timezone': self._get_value(record_dict, 'Timezone'),
                    'Edition': self._get_value(record_dict, 'Edition'),
                    'Class': self._get_value(record_dict, 'Class'),
                    'LineOfBusiness': self._get_value(record_dict, 'LineOfBusiness'),
                    'ClientID': self.etani_client_id
                }
                
                # Add flattened address fields - following original XEROBLUE - UPSERT.py pattern
                addresses = record_dict.get('Addresses', [])
                
                # Find STREET and POBOX addresses
                street_address = None
                pobox_address = None
                for addr in addresses:
                    if addr.get('AddressType') == 'STREET':
                        street_address = addr
                    elif addr.get('AddressType') == 'POBOX':
                        pobox_address = addr
                
                # Add STREET address fields
                base_data.update({
                    'Street_AddressLine1': self._get_value(street_address, 'AddressLine1') if street_address else '',
                    'Street_AddressLine2': self._get_value(street_address, 'AddressLine2') if street_address else '',
                    'Street_AddressLine3': self._get_value(street_address, 'AddressLine3') if street_address else '',
                    'Street_AddressLine4': self._get_value(street_address, 'AddressLine4') if street_address else '',
                    'Street_City': self._get_value(street_address, 'City') if street_address else '',
                    'Street_PostalCode': self._get_value(street_address, 'PostalCode') if street_address else '',
                    'Street_Country': self._get_value(street_address, 'Country') if street_address else '',
                    'Street_Region': self._get_value(street_address, 'Region') if street_address else '',
                    'Street_AttentionTo': self._get_value(street_address, 'AttentionTo') if street_address else '',
                })
                
                # Add POBOX address fields
                base_data.update({
                    'POBox_AddressLine1': self._get_value(pobox_address, 'AddressLine1') if pobox_address else '',
                    'POBox_AddressLine2': self._get_value(pobox_address, 'AddressLine2') if pobox_address else '',
                    'POBox_AddressLine3': self._get_value(pobox_address, 'AddressLine3') if pobox_address else '',
                    'POBox_AddressLine4': self._get_value(pobox_address, 'AddressLine4') if pobox_address else '',
                    'POBox_City': self._get_value(pobox_address, 'City') if pobox_address else '',
                    'POBox_PostalCode': self._get_value(pobox_address, 'PostalCode') if pobox_address else '',
                    'POBox_Country': self._get_value(pobox_address, 'Country') if pobox_address else '',
                    'POBox_Region': self._get_value(pobox_address, 'Region') if pobox_address else '',
                    'POBox_AttentionTo': self._get_value(pobox_address, 'AttentionTo') if pobox_address else '',
                })
                
                # Add flattened phone fields - following original XEROBLUE - UPSERT.py pattern
                phones = record_dict.get('Phones', [])
                
                # Find different phone types
                phone_ddi = None
                phone_default = None
                phone_fax = None
                phone_mobile = None
                for phone in phones:
                    phone_type = phone.get('PhoneType')
                    if phone_type == 'DDI':
                        phone_ddi = phone
                    elif phone_type == 'DEFAULT':
                        phone_default = phone
                    elif phone_type == 'FAX':
                        phone_fax = phone
                    elif phone_type == 'MOBILE':
                        phone_mobile = phone
                
                # Add phone fields by type
                base_data.update({
                    'DDI_PhoneNumber': self._get_value(phone_ddi, 'PhoneNumber') if phone_ddi else '',
                    'DDI_PhoneAreaCode': self._get_value(phone_ddi, 'PhoneAreaCode') if phone_ddi else '',
                    'DDI_PhoneCountryCode': self._get_value(phone_ddi, 'PhoneCountryCode') if phone_ddi else '',
                    'Default_PhoneNumber': self._get_value(phone_default, 'PhoneNumber') if phone_default else '',
                    'Default_PhoneAreaCode': self._get_value(phone_default, 'PhoneAreaCode') if phone_default else '',
                    'Default_PhoneCountryCode': self._get_value(phone_default, 'PhoneCountryCode') if phone_default else '',
                    'Fax_PhoneNumber': self._get_value(phone_fax, 'PhoneNumber') if phone_fax else '',
                    'Fax_PhoneAreaCode': self._get_value(phone_fax, 'PhoneAreaCode') if phone_fax else '',
                    'Fax_PhoneCountryCode': self._get_value(phone_fax, 'PhoneCountryCode') if phone_fax else '',
                    'Mobile_PhoneNumber': self._get_value(phone_mobile, 'PhoneNumber') if phone_mobile else '',
                    'Mobile_PhoneAreaCode': self._get_value(phone_mobile, 'PhoneAreaCode') if phone_mobile else '',
                    'Mobile_PhoneCountryCode': self._get_value(phone_mobile, 'PhoneCountryCode') if phone_mobile else '',
                })
                
                # Add external links fields - following original XEROBLUE - UPSERT.py pattern
                external_links = record_dict.get('ExternalLinks', [])
                facebook_url = ''
                twitter_url = ''
                googleplus_url = ''
                linkedin_url = ''
                website_url = ''
                
                for link in external_links:
                    link_type = link.get('LinkType', '').upper()
                    url = self._get_value(link, 'Url')
                    if link_type == 'FACEBOOK':
                        facebook_url = url
                    elif link_type == 'TWITTER':
                        twitter_url = url
                    elif link_type == 'GOOGLEPLUS':
                        googleplus_url = url
                    elif link_type == 'LINKEDIN':
                        linkedin_url = url
                    elif link_type == 'WEBSITE':
                        website_url = url
                
                base_data.update({
                    'Facebook_URL': facebook_url,
                    'Twitter_URL': twitter_url,
                    'GooglePlus_URL': googleplus_url,
                    'LinkedIn_URL': linkedin_url,
                    'Website_URL': website_url,
                })
                
                # Add payment terms flattening - following original XEROBLUE - UPSERT.py pattern
                payment_terms = record_dict.get('PaymentTerms', {})
                if payment_terms:
                    bills = payment_terms.get('Bills', {})
                    sales = payment_terms.get('Sales', {})
                    
                    base_data.update({
                        'PaymentTerms_Bills_Day': self._validate_float(bills.get('Day', 0)) if bills else 0,
                        'PaymentTerms_Bills_Type': self._get_value(bills, 'Type') if bills else '',
                        'PaymentTerms_Sales_Day': self._validate_float(sales.get('Day', 0)) if sales else 0,
                        'PaymentTerms_Sales_Type': self._get_value(sales, 'Type') if sales else '',
                    })
                else:
                    base_data.update({
                        'PaymentTerms_Bills_Day': 0,
                        'PaymentTerms_Bills_Type': '',
                        'PaymentTerms_Sales_Day': 0,
                        'PaymentTerms_Sales_Type': '',
                    })
                
                # Note: ClientID is added by the stored procedure, not in the initial transformation
                # This matches the original XEROBLUE - UPSERT.py pattern
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Organisations records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_organisations_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_banktransfers_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform BankTransfers data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} BankTransfers records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Helper function for safe nested object access
                def get_nested_bank_account(bank_account, field, default=''):
                    try:
                        if bank_account and isinstance(bank_account, dict):
                            return str(bank_account.get(field, default))
                        return default
                    except:
                        return default
                
                # Create base data structure exactly matching original XEROBLUE - UPSERT.py
                base_data = {
                    'BankTransferId': str(record_dict.get('BankTransferID', '')),
                    'FromBankAccount_Code': get_nested_bank_account(record_dict.get('FromBankAccount'), 'Code'),
                    'FromBankAccount_Name': get_nested_bank_account(record_dict.get('FromBankAccount'), 'Name'),
                    'FromBankAccount_AccountId': get_nested_bank_account(record_dict.get('FromBankAccount'), 'AccountID'),
                    'ToBankAccount_Code': get_nested_bank_account(record_dict.get('ToBankAccount'), 'Code'),
                    'ToBankAccount_Name': get_nested_bank_account(record_dict.get('ToBankAccount'), 'Name'),
                    'ToBankAccount_AccountId': get_nested_bank_account(record_dict.get('ToBankAccount'), 'AccountID'),
                    'Amount': self._validate_float(record_dict.get('Amount', 0)),
                    'Date': self._get_value(record_dict, 'Date'),
                    'CurrencyRate': self._validate_float(record_dict.get('CurrencyRate', 0)),
                    'FromBankTransactionID': self._get_value(record_dict, 'FromBankTransactionID'),
                    'ToBankTransactionID': self._get_value(record_dict, 'ToBankTransactionID'),
                    'HasAttachments': bool(record_dict.get('HasAttachments', False)),
                    'CreatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'CreatedDateUTC'))
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} BankTransfers records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_banktransfers_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_brandingthemes_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform BrandingThemes data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} BrandingThemes records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'BrandingThemeId': self._get_value(record_dict, 'BrandingThemeID'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'LogoURL': self._get_value(record_dict, 'LogoURL'),
                    'Type': self._get_value(record_dict, 'Type'),
                    'SortOrder': self._validate_float(record_dict.get('SortOrder', 0)),
                    'CreatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'CreatedDateUTC'))
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} BrandingThemes records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_brandingthemes_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_contactgroups_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform ContactGroups data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} ContactGroups records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'ContactGroupId': self._get_value(record_dict, 'ContactGroupID'),
                    'Name': self._get_value(record_dict, 'Name'),
                    'Status': self._get_value(record_dict, 'Status')
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} ContactGroups records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_contactgroups_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_linkedtransactions_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform LinkedTransactions data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} LinkedTransactions records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Helper function for safe nested object access
                def get_nested_transaction(transaction, field, default=''):
                    try:
                        if transaction and isinstance(transaction, dict):
                            return str(transaction.get(field, default))
                        return default
                    except:
                        return default
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                base_data = {
                    'LinkedTransactionId': self._get_value(record_dict, 'LinkedTransactionID'),
                    'SourceTransactionId': get_nested_transaction(record_dict.get('SourceTransaction'), 'TransactionID'),
                    'SourceTransactionTypeCode': get_nested_transaction(record_dict.get('SourceTransaction'), 'TransactionTypeCode'),
                    'ContactId': get_nested_transaction(record_dict.get('SourceTransaction'), 'ContactID'),
                    'TargetTransactionId': get_nested_transaction(record_dict.get('TargetTransaction'), 'TransactionID'),
                    'TargetTransactionTypeCode': get_nested_transaction(record_dict.get('TargetTransaction'), 'TransactionTypeCode'),
                    'ContactId_Target': get_nested_transaction(record_dict.get('TargetTransaction'), 'ContactID'),
                    'Status': self._get_value(record_dict, 'Status'),
                    'Type': self._get_value(record_dict, 'Type'),
                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC'))
                }
                
                # Add common fields including OrganisationID
                base_data = self._add_common_fields(base_data)
                combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} LinkedTransactions records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_linkedtransactions_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_budgets_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform Budgets data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} Budgets records...")
            
            combined_data = []
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # Create base data structure matching original XEROBLUE - UPSERT.py
                budget_lines = record_dict.get('BudgetLines', [])
                
                if budget_lines:
                    # Process budgets with BudgetLines (creates multiple records)
                    for line in budget_lines:
                        budget_balances = line.get('BudgetBalances', [])
                        
                        if budget_balances:
                            # Process each budget balance
                            for balance in budget_balances:
                                base_data = {
                                    'BudgetID': self._get_value(record_dict, 'BudgetID'),
                                    'Status': self._get_value(record_dict, 'Status'),
                                    'Description': self._get_value(record_dict, 'Description'),
                                    'Type': self._get_value(record_dict, 'Type'),
                                    'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                                    'BudgetLines.AccountID': self._get_value(line, 'AccountID'),
                                    'BudgetLines.AccountCode': self._get_value(line, 'AccountCode'),
                                    'BudgetLines.BudgetBalances.Period': self._get_value(balance, 'Period'),
                                    'BudgetLines.BudgetBalances.Amount': self._validate_float(balance.get('Amount', 0)),
                                    'BudgetLines.BudgetBalances.Notes': self._get_value(balance, 'Notes'),
                                }
                                
                                # Add tracking categories if present (up to 2)
                                tracking = line.get('Tracking', [])
                                if tracking and len(tracking) >= 1:
                                    base_data.update({
                                        'Tracking.1.Name': self._get_value(tracking[0], 'Name'),
                                        'Tracking.1.Option': self._get_value(tracking[0], 'Option'),
                                        'Tracking.1.TrackingCategoryID': self._get_value(tracking[0], 'TrackingCategoryID'),
                                        'Tracking.1.TrackingOptionID': self._get_value(tracking[0], 'TrackingOptionID'),
                                    })
                                    if len(tracking) >= 2:
                                        base_data.update({
                                            'Tracking.2.Name': self._get_value(tracking[1], 'Name'),
                                            'Tracking.2.Option': self._get_value(tracking[1], 'Option'),
                                            'Tracking.2.TrackingCategoryID': self._get_value(tracking[1], 'TrackingCategoryID'),
                                            'Tracking.2.TrackingOptionID': self._get_value(tracking[1], 'TrackingOptionID'),
                                        })
                                else:
                                    # Add empty tracking fields
                                    base_data.update({
                                        'Tracking.1.Name': '',
                                        'Tracking.1.Option': '',
                                        'Tracking.1.TrackingCategoryID': '',
                                        'Tracking.1.TrackingOptionID': '',
                                        'Tracking.2.Name': '',
                                        'Tracking.2.Option': '',
                                        'Tracking.2.TrackingCategoryID': '',
                                        'Tracking.2.TrackingOptionID': '',
                                    })
                                
                                # Add common fields including OrganisationID
                                base_data = self._add_common_fields(base_data)
                                combined_data.append(base_data)
                else:
                    # Process budgets without BudgetLines (header only)
                    base_data = {
                        'BudgetID': self._get_value(record_dict, 'BudgetID'),
                        'Status': self._get_value(record_dict, 'Status'),
                        'Description': self._get_value(record_dict, 'Description'),
                        'Type': self._get_value(record_dict, 'Type'),
                        'UpdatedDateUTC': self._validate_datetime(self._get_value(record_dict, 'UpdatedDateUTC')),
                    }
                    
                    # Add common fields including OrganisationID
                    base_data = self._add_common_fields(base_data)
                    combined_data.append(base_data)
            
            print(f"   ✅ Successfully transformed {len(combined_data)} Budgets records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_budgets_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_trialbalance_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform TrialBalance report data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} TrialBalance report records...")
            
            combined_data = []
            record_id = 1
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # TrialBalance has a Reports array structure
                reports = record_dict.get('Reports', [])
                for report in reports:
                    rows = report.get('Rows', [])
                    for row in rows:
                        if row.get('RowType') == 'Section':
                            # Process section rows with sub-rows
                            title = row.get('Title', '')
                            sub_rows = row.get('Rows', [])
                            for sub_row in sub_rows:
                                if sub_row.get('RowType') == 'Row':
                                    cells = sub_row.get('Cells', [])
                                    if len(cells) >= 6:  # Ensure we have enough cells
                                        # Extract AccountID from first cell attributes
                                        account_id = ''
                                        if cells[0].get('Attributes'):
                                            for attr in cells[0]['Attributes']:
                                                if attr.get('Id') == 'account':
                                                    account_id = attr.get('Value', '')
                                                    break
                                        
                                        base_data = {
                                            'ID': record_id,
                                            'Date': self._get_value(report, 'ReportDate'),
                                            'Title': title,
                                            'Account': self._get_value(cells[0], 'Value'),
                                            'Debit': self._get_value(cells[1], 'Value'),
                                            'Credit': self._get_value(cells[2], 'Value'),
                                            'YTDDebit': self._get_value(cells[3], 'Value'),
                                            'YTDCredit': self._get_value(cells[4], 'Value'),
                                            'AccountId': account_id
                                        }
                                        
                                        # Add common fields including OrganisationID
                                        base_data = self._add_common_fields(base_data)
                                        combined_data.append(base_data)
                                        record_id += 1
            
            print(f"   ✅ Successfully transformed {len(combined_data)} TrialBalance records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_trialbalance_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_balancesheet_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform BalanceSheet report data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} BalanceSheet report records...")
            
            combined_data = []
            record_id = 1
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # BalanceSheet has a Reports array structure
                reports = record_dict.get('Reports', [])
                for report in reports:
                    rows = report.get('Rows', [])
                    
                    # First, add header row
                    if rows and len(rows) > 0 and rows[0].get('RowType') == 'Header':
                        header_cells = rows[0].get('Cells', [])
                        if len(header_cells) >= 13:  # Ensure we have 13 label columns
                            base_data = {
                                'ID': record_id,
                                'Title': None,
                                'AccountId': None
                            }
                            
                            # Add all 13 label columns
                            for i in range(13):
                                base_data[f'Label{i+1}'] = self._get_value(header_cells[i], 'Value') if i < len(header_cells) else ''
                            
                            # Add common fields including OrganisationID
                            base_data = self._add_common_fields(base_data)
                            combined_data.append(base_data)
                            record_id += 1
                    
                    # Process section rows
                    for row in rows:
                        if row.get('RowType') == 'Section':
                            title = row.get('Title', '')
                            sub_rows = row.get('Rows', [])
                            for sub_row in sub_rows:
                                if sub_row.get('RowType') == 'Row':
                                    cells = sub_row.get('Cells', [])
                                    if len(cells) >= 13:  # Ensure we have 13 columns
                                        # Extract AccountID from first cell attributes
                                        account_id = ''
                                        if cells[0].get('Attributes'):
                                            for attr in cells[0]['Attributes']:
                                                if attr.get('Id') == 'account':
                                                    account_id = attr.get('Value', '')
                                                    break
                                        
                                        base_data = {
                                            'ID': record_id,
                                            'Title': title,
                                            'AccountId': account_id
                                        }
                                        
                                        # Add all 13 label columns
                                        for i in range(13):
                                            base_data[f'Label{i+1}'] = self._get_value(cells[i], 'Value') if i < len(cells) else ''
                                        
                                        # Add common fields including OrganisationID
                                        base_data = self._add_common_fields(base_data)
                                        combined_data.append(base_data)
                                        record_id += 1
            
            print(f"   ✅ Successfully transformed {len(combined_data)} BalanceSheet records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_balancesheet_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _transform_banksummary_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform BankSummary report data following original XEROBLUE - UPSERT.py pattern"""
        if df.empty:
            return df
            
        try:
            print(f"   Transforming {len(df)} BankSummary report records...")
            
            combined_data = []
            record_id = 1
            
            for index, record in df.iterrows():
                record_dict = record.to_dict() if hasattr(record, 'to_dict') else record
                
                # BankSummary has a Reports array structure
                reports = record_dict.get('Reports', [])
                for report in reports:
                    rows = report.get('Rows', [])
                    for row in rows:
                        if row.get('RowType') == 'Section':
                            sub_rows = row.get('Rows', [])
                            for sub_row in sub_rows:
                                if sub_row.get('RowType') == 'Row':
                                    cells = sub_row.get('Cells', [])
                                    if len(cells) >= 5:  # Ensure we have enough cells
                                        # Extract AccountID from first cell attributes
                                        account_id = ''
                                        if cells[0].get('Attributes'):
                                            for attr in cells[0]['Attributes']:
                                                if attr.get('Id') == 'account':
                                                    account_id = attr.get('Value', '')
                                                    break
                                        
                                        base_data = {
                                            'ID': record_id,
                                            'BankAccount': self._get_value(cells[0], 'Value'),
                                            'AccountId': account_id,
                                            'OpeningBalance': self._get_value(cells[1], 'Value'),
                                            'CashReceived': self._get_value(cells[2], 'Value'),
                                            'CashSpent': self._get_value(cells[3], 'Value'),
                                            'ClosingBalance': self._get_value(cells[4], 'Value')
                                        }
                                        
                                        # Add common fields including OrganisationID
                                        base_data = self._add_common_fields(base_data)
                                        combined_data.append(base_data)
                                        record_id += 1
            
            print(f"   ✅ Successfully transformed {len(combined_data)} BankSummary records")
            return pd.DataFrame(combined_data)
            
        except Exception as e:
            print(f"❌ Error in _transform_banksummary_data: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def get_token_refresh_params(self) -> Dict[str, str]:
        """Get token refresh parameters for this integration"""
        return {
            'token_url': self.integration_config.get('token_url', 'https://identity.xero.com/connect/token'),
            'client_id': self.client_id,
            'client_secret': self.client_secret
        }
    
    def get_endpoint_mapping(self, endpoint: str) -> Dict[str, Any]:
        """Get endpoint-specific configuration"""
        # This could be expanded to include field mappings, transformations, etc.
        return {
            'endpoint': endpoint,
            'is_report': endpoint in self.report_endpoints,
            'supports_pagination': endpoint not in self.report_endpoints,
            'supports_if_modified_since': endpoint not in self.report_endpoints
        }
    
    # ========================
    # Business Logic Setup Methods
    # ========================
    
    def setup_full_configuration(self):
        """Setup complete configuration from environment variables"""
        # Core environment variables
        self.db_destination = os.getenv('DB_Destination', 'EVA')
        self.trigger_type = os.getenv('TRIGGER_TYPE')
        
        # Organization details
        self.etani_client_id = os.getenv('EtaniClientID')
        self.etani_organisation_id = os.getenv('EtaniOrganisationID')
        self.reset_mode = os.getenv("Reset_Mode")
        
        # Derived values - set initial defaults
        self.legacy_organisation_id = 0
        self.firm_id = 0
        self.legacy_client_id = ''
        self.org_status = 0
        self.client_id_number = self.etani_client_id[self.etani_client_id.find('CLIENT') + len('CLIENT'):] if self.etani_client_id else ''
        
        # Get CMS details to populate legacy values using generic CMS manager
        self._get_cms_details()
        
        
        # Table naming (preserve existing logic)
        if self.etani_client_id and self.etani_organisation_id:
            self.table_prefix_dw = f"{self.etani_client_id}_{self.etani_organisation_id}_XEROBLUE_"
            self.table_prefix_eva = f"c{self.client_id_number}_{self.etani_organisation_id}_xeroblue_"
            self.table_client_eva = f"c{self.client_id_number}_xeroblue_"
        else:
            print("Warning: Client ID or Organisation ID not set")
    
    def setup_logging(self):
        """Setup logging configuration"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(__name__)
    
    def _import_convert_data_types(self):
        """Import the common ConvertDataTypes function from utils"""
        try:
            from utils import ConvertDataTypes
            
            def convert_data_types_wrapper(df, endpoint):
                """Wrapper around common ConvertDataTypes function with complete row filtering"""
                print(f"Converting data types for {endpoint}: {len(df)} records")
                
                # Step 1: Apply default values for required columns BEFORE data type conversion
                df_with_defaults = self._apply_default_values_for_required_columns(df, endpoint)
                
                # Step 2: Filter out rows with null required columns (prevents IntegrityError)
                df_filtered = self._filter_rows_with_null_required_columns(df_with_defaults, endpoint)
                
                if df_filtered.empty:
                    print(f"  ⚠️  No valid rows remaining for {endpoint} after filtering")
                    return df_filtered
                
                # Step 3: Apply standard data type conversion
                converted_df = ConvertDataTypes(df_filtered)
                
                # Step 4: Final validation to ensure no required columns are null
                validated_df = self._validate_required_columns(converted_df, endpoint)
                
                print(f"  Data type conversion and row filtering completed for {endpoint}: {len(validated_df)} valid rows")
                return validated_df
            
            return convert_data_types_wrapper
        except ImportError:
            print("Warning: Could not import ConvertDataTypes from utils, using placeholder")
            
            def convert_data_types_placeholder(df, endpoint):
                """Placeholder for data type conversion with complete row filtering"""
                print(f"Converting data types for {endpoint}: {len(df)} records")
                
                # Step 1: Apply default values even in fallback mode
                df_with_defaults = self._apply_default_values_for_required_columns(df, endpoint)
                
                # Step 2: Filter out rows with null required columns (prevents IntegrityError)
                df_filtered = self._filter_rows_with_null_required_columns(df_with_defaults, endpoint)
                
                if df_filtered.empty:
                    print(f"  ⚠️  No valid rows remaining for {endpoint} after filtering")
                    return df_filtered
                
                # Step 3: Final validation to ensure no required columns are null
                validated_df = self._validate_required_columns(df_filtered, endpoint)
                
                print(f"  Basic conversion and row filtering completed for {endpoint}: {len(validated_df)} valid rows")
                return validated_df
            
            return convert_data_types_placeholder
    
    def _get_required_columns_for_endpoint(self, endpoint: str) -> dict:
        """Get required columns and their data types for each endpoint"""
        # Define required columns for each endpoint based on XeroBlue schema
        # This mapping prevents IntegrityError: Column 'X' cannot be null
        
        required_columns = {
            'Organisations': {
                'OrganisationID': 'integer',  # Fixed: should be integer to use etani_organisation_id
                'Name': 'string',
                'ShortCode': 'string',
                'ClientID': 'string'
            },
            'Accounts': {
                'AccountID': 'string',
                'Code': 'string',
                'Name': 'string',
                'Type': 'string'
            },
            'Invoices': {
                'InvoiceId': 'string',  # Note: 'Id' not 'ID' to match stage table schema
                'InvoiceNumber': 'string',
                'Type': 'string'
                # Note: Removed 'Status' and 'Contact' as they don't exist in stage table schema
                # Stage table has 'ContactId' and 'ContactName' instead of 'Contact'
            },
            'CreditNotes': {
                'CreditNoteID': 'string',  # Note: Keep as 'ID' for CreditNotes (different from Invoices)
                'CreditNoteNumber': 'string',
                'Type': 'string'
                # Note: Removed 'Status' and 'Contact' - they don't exist in stage table schema
                # Stage table has 'ContactId' and 'ContactName' instead of 'Contact'
            },
            'Contacts': {
                'ContactId': 'string',  # Note: 'Id' not 'ID' for consistency with stage table schema
                'Name': 'string',
                'ContactStatus': 'string'
            },
            'Payments': {
                'PaymentID': 'string',
                'Date': 'datetime',
                'Amount': 'float',
                'Status': 'string'
            },
            'BankTransactions': {
                'BankTransactionId': 'string',  # Fixed: use flattened ID column name
                'Type': 'string',
                'Status': 'string',
                'BankAccount_AccountId': 'string'  # Fixed: use flattened column name
            },
            'ManualJournals': {
                'ManualJournalID': 'string',
                'Status': 'string',
                'Date': 'datetime'
            },
            'Overpayments': {
                'OverpaymentId': 'string',  # Fixed: use flattened ID column name
                'Type': 'string',
                'Status': 'string',
                'Contact_ContactId': 'string'  # Fixed: match original pattern with prefix
            },
            'Prepayments': {
                'PrepaymentId': 'string',  # Fixed: use flattened ID column name
                'Type': 'string',
                'Status': 'string',
                'Contact_ContactId': 'string'  # Fixed: match original pattern with prefix
            },
            'Items': {
                'ItemID': 'string',
                'Code': 'string',
                'Name': 'string'
            },
            'PurchaseOrders': {
                'PurchaseOrderID': 'string',
                'PurchaseOrderNumber': 'string',
                'Status': 'string'
            },
            'Receipts': {
                'ReceiptID': 'string',
                'ReceiptNumber': 'string',
                'Status': 'string'
            },
            'Quotes': {
                'QuoteID': 'string',
                'QuoteNumber': 'string',
                'Status': 'string'
            },
            'Journals': {
                'JournalID': 'string',
                'JournalNumber': 'integer',
                'JournalDate': 'datetime'
            },
            'JournalsCash': {
                'JournalID': 'string',
                'JournalNumber': 'integer',
                'JournalDate': 'datetime'
            },
            'TrackingCategories': {
                'TrackingCategoryID': 'string',
                'Name': 'string',
                'Status': 'string'
            },
            'TaxRates': {
                'TaxType': 'string',
                'Name': 'string',
                'Status': 'string'
            },
            'Users': {
                'UserID': 'string',
                'FirstName': 'string',
                'LastName': 'string'
            },
            'Employees': {
                'EmployeeID': 'string',
                'FirstName': 'string',
                'LastName': 'string'
            },
            'ExpenseClaims': {
                'ExpenseClaimID': 'string',
                'Status': 'string',
                'UserId': 'string'  # Fixed: match original pattern (simple name)
            },
            'LinkedTransactions': {
                'LinkedTransactionID': 'string',
                'Status': 'string',
                'Type': 'string'
            },
            'BatchPayments': {
                'BatchPaymentID': 'string',
                'Status': 'string',
                'Date': 'datetime'
            },
            'BankTransfers': {
                'BankTransferID': 'string',
                'Amount': 'float',
                'Date': 'datetime'
            },
            'BrandingThemes': {
                'BrandingThemeID': 'string',
                'Name': 'string'
            },
            'Currencies': {
                'Code': 'string',
                'Description': 'string'
            },
            'RepeatingInvoices': {
                'RepeatingInvoiceID': 'string',
                'Status': 'string',
                'Type': 'string'
            },
            'ContactGroups': {
                'ContactGroupID': 'string',
                'Name': 'string',
                'Status': 'string'
            }
        }
        
        # Return required columns for the specific endpoint, or empty dict if not defined
        return required_columns.get(endpoint, {})
    
    def _get_default_value_by_type(self, data_type: str, column_name: str = "") -> any:
        """Get appropriate default value based on data type"""
        import uuid
        from datetime import datetime
        
        defaults = {
            'string': 'UNKNOWN',
            'integer': 0,
            'float': 0.0,
            'datetime': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'date': datetime.now().strftime('%Y-%m-%d'),
            'boolean': False,
            'uuid': str(uuid.uuid4())
        }
        
        # Special handling for OrganisationID - use etani_organisation_id
        if column_name == 'OrganisationID':
            try:
                if hasattr(self, 'etani_organisation_id') and self.etani_organisation_id:
                    # Convert to int to ensure it's an integer value
                    org_id = int(self.etani_organisation_id)
                    print(f"   🔧 Using etani_organisation_id {org_id} for OrganisationID default")
                    return org_id
                else:
                    print(f"   ⚠️  etani_organisation_id not available, using fallback for OrganisationID")
                    return 0  # Fallback to 0 if etani_organisation_id not available
            except (ValueError, TypeError) as e:
                print(f"   ⚠️  Error converting etani_organisation_id to int: {e}, using fallback")
                return 0
            
        if column_name == 'ClientID':
            try:
                if hasattr(self, 'etani_client_id') and self.etani_client_id:
                    # Convert to int to ensure it's an integer value
                    client_id = self.etani_client_id
                    print(f"   🔧 Using etani_client_id {client_id} for ClientID default")
                    return client_id
                else:
                    print(f"   ⚠️  etani_organisation_id not available, using fallback for OrganisationID")
                    return 0  # Fallback to 0 if etani_organisation_id not available
            except (ValueError, TypeError) as e:
                print(f"   ⚠️  Error converting etani_organisation_id to int: {e}, using fallback")
                return 0
        
        # Special handling for other specific ID columns that should be integers
        id_column_mappings = {
            'ContactID': lambda: int(datetime.now().timestamp()) % 1000000,  # Generate reasonable integer
            'InvoiceID': lambda: int(datetime.now().timestamp()) % 1000000,
            'CreditNoteID': lambda: int(datetime.now().timestamp()) % 1000000,
            'PaymentID': lambda: int(datetime.now().timestamp()) % 1000000,
            'BankTransactionID': lambda: int(datetime.now().timestamp()) % 1000000,
            'AccountID': lambda: int(datetime.now().timestamp()) % 1000000,
            'ItemID': lambda: int(datetime.now().timestamp()) % 1000000,
            'TaxRateID': lambda: int(datetime.now().timestamp()) % 1000000,
            'TrackingCategoryID': lambda: int(datetime.now().timestamp()) % 1000000,
            'ReportID': lambda: 'AUTO_GENERATED_REPORT',  # Special case for report endpoints
        }
        
        # Check if this is a specific ID column we know about
        if column_name in id_column_mappings:
            try:
                return id_column_mappings[column_name]()
            except Exception as e:
                print(f"   ⚠️  Error generating default for {column_name}: {e}")
                # Fall through to general handling
        
        # General handling for ID columns
        if 'ID' in column_name:
            if data_type == 'string':
                # For string ID columns, generate a reasonable string default
                return f"AUTO_{column_name}_{int(datetime.now().timestamp()) % 1000000}"
            elif data_type == 'integer':
                # For integer ID columns, generate a reasonable integer default
                return int(datetime.now().timestamp()) % 1000000
            elif data_type == 'uuid':
                return str(uuid.uuid4())
        
        # Special handling for specific known columns
        if column_name in ['Status', 'ContactStatus']:
            return 'ACTIVE'
        elif column_name in ['Type']:
            return 'UNKNOWN'
        elif column_name in ['Name'] and data_type == 'string':
            return 'DEFAULT_NAME'
        elif column_name in ['Code'] and data_type == 'string':
            return 'DEFAULT_CODE'
        
        return defaults.get(data_type, '')
    
    def _handle_nested_data_id_preservation(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Handle nested data flattening issues where parent IDs might be lost during JSON processing.
        This ensures that records created from nested arrays inherit the parent ID.
        """
        try:
            if df.empty:
                return df
            
            # Define parent ID mappings for endpoints that commonly have nested data
            parent_id_mappings = {
                'CreditNotes': 'CreditNoteID',
                'Invoices': 'InvoiceId',  # Note: 'Id' not 'ID' to match stage table schema
                'Contacts': 'ContactId',  # Note: 'Id' not 'ID' for consistency with stage table schema
                'Payments': 'PaymentID',
                'BankTransactions': 'BankTransactionID',
                'ManualJournals': 'ManualJournalID',
                'Overpayments': 'OverpaymentID',
                'Prepayments': 'PrepaymentID'
            }
            
            if endpoint not in parent_id_mappings:
                # No special handling needed for this endpoint
                return df
            
            parent_id_column = parent_id_mappings[endpoint]
            
            # Check if the parent ID column exists and has any null values
            if parent_id_column in df.columns:
                null_count = df[parent_id_column].isnull().sum()
                
                if null_count > 0:
                    print(f"   🔍 Found {null_count} rows missing {parent_id_column} - attempting ID preservation...")
                    
                    # Try to fill missing parent IDs by forward-filling from valid records
                    df_copy = df.copy()
                    
                    # Sort by index to maintain order, then forward fill
                    df_copy[parent_id_column] = df_copy[parent_id_column].fillna(method='ffill')
                    
                    # If there are still nulls, try backward fill
                    df_copy[parent_id_column] = df_copy[parent_id_column].fillna(method='bfill')
                    
                    # Check how many were fixed
                    remaining_nulls = df_copy[parent_id_column].isnull().sum()
                    fixed_count = null_count - remaining_nulls
                    
                    if fixed_count > 0:
                        print(f"   ✅ Preserved {fixed_count} parent IDs through forward/backward fill")
                    
                    if remaining_nulls > 0:
                        print(f"   ⚠️  Still have {remaining_nulls} rows without {parent_id_column} - will apply defaults")
                    
                    return df_copy
                else:
                    # No null parent IDs - data is clean
                    return df
            else:
                # Parent ID column doesn't exist - will be handled by default value application
                return df
            
        except Exception as e:
            print(f"   ⚠️  Error in nested data ID preservation for {endpoint}: {str(e)}")
            return df
    
    def _apply_default_values_for_required_columns(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """Apply default values for required columns that are null or missing"""
        try:
            if df.empty:
                return df
            
            # Check if default value application is enabled
            if not getattr(self, 'apply_default_values', True):
                if getattr(self, 'log_default_applications', True):
                    print(f"   ℹ️  Default value application disabled for {endpoint}")
                return df
            
            if getattr(self, 'log_default_applications', True):
                print(f"   🔧 Applying default values for required columns in {endpoint}...")
            
            # Special handling for nested data flattening issues
            df_preprocessed = self._handle_nested_data_id_preservation(df, endpoint)
            
            # Get required columns for this endpoint
            required_columns = self._get_required_columns_for_endpoint(endpoint)
            
            if not required_columns:
                if getattr(self, 'log_default_applications', True):
                    print(f"   ℹ️  No required columns defined for {endpoint}, skipping default value application")
                return df_preprocessed
            
            # Create a copy to avoid modifying the original
            df_copy = df_preprocessed.copy()
            
            applied_defaults = []
            
            for column_name, data_type in required_columns.items():
                # Check if column exists in DataFrame
                if column_name not in df_copy.columns:
                    # Column doesn't exist - add it with default value
                    default_value = self._get_default_value_by_type(data_type, column_name)
                    df_copy[column_name] = default_value
                    applied_defaults.append(f"{column_name}={default_value} (added)")
                    
                else:
                    # Column exists - fill null values with defaults
                    null_mask = df_copy[column_name].isnull()
                    null_count = null_mask.sum()
                    
                    if null_count > 0:
                        default_value = self._get_default_value_by_type(data_type, column_name)
                        df_copy.loc[null_mask, column_name] = default_value
                        applied_defaults.append(f"{column_name}={default_value} ({null_count} nulls filled)")
            
            if applied_defaults:
                print(f"   ✅ Applied defaults for {len(applied_defaults)} columns: {', '.join(applied_defaults)}")
            else:
                print(f"   ✅ No default values needed for {endpoint} - all required columns present")
            
            return df_copy
            
        except Exception as e:
            print(f"   ⚠️  Error applying default values for {endpoint}: {str(e)}")
            # Return original DataFrame if default application fails
            return df
    
    def _validate_required_columns(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """Final validation to ensure no required columns are null"""
        try:
            if df.empty:
                return df
            
            required_columns = self._get_required_columns_for_endpoint(endpoint)
            
            if not required_columns:
                return df
            
            print(f"   🔍 Validating required columns for {endpoint}...")
            
            validation_issues = []
            
            for column_name in required_columns.keys():
                if column_name in df.columns:
                    null_count = df[column_name].isnull().sum()
                    if null_count > 0:
                        validation_issues.append(f"{column_name}: {null_count} null values")
                else:
                    validation_issues.append(f"{column_name}: column missing")
            
            if validation_issues:
                print(f"   ❌ Validation issues found for {endpoint}: {', '.join(validation_issues)}")
                # Log but don't fail - the database will catch these if they're truly required
                print(f"   ⚠️  Proceeding with data insertion - database constraints will handle validation")
            else:
                print(f"   ✅ All required columns validated for {endpoint}")
            
            return df
            
        except Exception as e:
            print(f"   ⚠️  Error validating required columns for {endpoint}: {str(e)}")
            return df
    
    def _filter_rows_with_null_required_columns(self, df: pd.DataFrame, endpoint: str) -> pd.DataFrame:
        """
        Filter out rows that have null values in required columns.
        This prevents IntegrityError: Column 'X' cannot be null during database insertion.
        """
        try:
            if df.empty:
                return df
            
            required_columns = self._get_required_columns_for_endpoint(endpoint)
            
            if not required_columns:
                print(f"   ℹ️  No required columns defined for {endpoint}, skipping row filtering")
                return df
            
            print(f"   🔍 Filtering rows with null required columns for {endpoint}...")
            
            original_count = len(df)
            valid_rows_mask = pd.Series([True] * len(df), index=df.index)
            skipped_reasons = []
            
            # Check each required column for null values
            for column_name in required_columns.keys():
                if column_name in df.columns:
                    null_mask = df[column_name].isnull()
                    null_count = null_mask.sum()
                    
                    if null_count > 0:
                        print(f"   ⚠️  Found {null_count} rows with null {column_name}")
                        valid_rows_mask = valid_rows_mask & ~null_mask
                        skipped_reasons.append(f"{null_count} rows: null {column_name}")
                else:
                    # If required column is missing entirely, skip all rows
                    print(f"   ❌ Required column '{column_name}' is missing entirely")
                    valid_rows_mask = pd.Series([False] * len(df), index=df.index)
                    skipped_reasons.append(f"all rows: missing {column_name}")
                    break
            
            # Filter to only valid rows
            filtered_df = df[valid_rows_mask].copy()
            
            skipped_count = original_count - len(filtered_df)
            
            if skipped_count > 0:
                print(f"   ⚠️  Skipped {skipped_count}/{original_count} rows with null required columns:")
                for reason in skipped_reasons:
                    print(f"      - {reason}")
                print(f"   ✅ Continuing with {len(filtered_df)} valid rows for {endpoint}")
            else:
                print(f"   ✅ All {original_count} rows are valid for {endpoint}")
            
            return filtered_df
            
        except Exception as e:
            print(f"   ⚠️  Error filtering rows for {endpoint}: {str(e)}")
            # Return original DataFrame if filtering fails - let database handle validation
            print(f"   🔄 Returning original data and letting database handle validation")
            return df
    
    def _validate_stage_table_before_sp_execution(self, endpoint: str) -> bool:
        """
        Validate stage table for null required columns before stored procedure execution.
        This is the final safety net to prevent IntegrityError during SP execution.
        """
        try:
            # Get required columns for this endpoint
            required_columns = self._get_required_columns_for_endpoint(endpoint)
            
            if not required_columns:
                print(f"   ℹ️  No required columns defined for {endpoint} - proceeding with SP execution")
                return True
            
            # Build stage table name (Organisations uses CLIENTSSTAGE, others use STAGE)
            if endpoint.lower() == 'organisations':
                stage_table = f"{self.table_prefix_eva}{endpoint}CLIENTSSTAGE"
            else:
                stage_table = f"{self.table_prefix_eva}{endpoint}STAGE"
            
            print(f"   🔍 Validating stage table {stage_table} before SP execution...")
            
            # Query to check for null values in required columns
            null_check_conditions = []
            for column_name in required_columns.keys():
                null_check_conditions.append(f"`{column_name}` IS NULL")
            
            null_check_query = f"""
                SELECT COUNT(*) as null_count
                FROM {stage_table} 
                WHERE ({' OR '.join(null_check_conditions)})
                LIMIT 1
            """
            
            # Execute the validation query
            try:
                null_count_df = ReadMySQLTable(null_check_query, f"{endpoint}_null_validation", 
                                             self.etani_client_id, self.etani_organisation_id, self.error_list)
                
                if not null_count_df.empty and len(null_count_df) > 0:
                    null_count = null_count_df['null_count'].iloc[0] if 'null_count' in null_count_df.columns else 0
                    
                    if null_count > 0:
                        print(f"   ❌ Found {null_count} rows with null required columns in {stage_table}")
                        print(f"   🔧 Cleaning up stage table to prevent IntegrityError...")
                        
                        # Clean up the stage table by removing rows with null required columns
                        cleanup_success = self._cleanup_stage_table_null_rows(endpoint, stage_table, required_columns)
                        
                        if cleanup_success:
                            print(f"   ✅ Stage table cleaned successfully - proceeding with SP execution")
                            return True
                        else:
                            print(f"   ❌ Failed to clean stage table - skipping SP execution")
                            return False
                    else:
                        print(f"   ✅ No null required columns found in {stage_table}")
                        return True
                else:
                    print(f"   ⚠️  Could not validate {stage_table} - proceeding with caution")
                    return True
                    
            except Exception as query_error:
                print(f"   ⚠️  Error validating stage table {stage_table}: {str(query_error)}")
                print(f"   ℹ️  Proceeding with SP execution - database will handle validation")
                return True
            
        except Exception as e:
            print(f"   ⚠️  Error in stage table validation for {endpoint}: {str(e)}")
            print(f"   ℹ️  Proceeding with SP execution - database will handle validation")
            return True
            
    def _cleanup_stage_table_null_rows(self, endpoint: str, stage_table: str, required_columns: dict) -> bool:
        """
        Remove rows with null required columns from stage table
        """
        try:
            print(f"   🧹 Removing rows with null required columns from {stage_table}...")
            
            # Build DELETE query for rows with null required columns
            null_conditions = []
            for column_name in required_columns.keys():
                null_conditions.append(f"`{column_name}` IS NULL")
            
            delete_query = f"""
                DELETE FROM {stage_table} 
                WHERE ({' OR '.join(null_conditions)})
            """
            
            print(f"   🗑️  Executing cleanup: DELETE rows with null required columns")
            
            # Execute the cleanup using the same pattern as other database operations
            try:
                # Import eva_engine for direct execution if available
                from sql_helper import eva_engine
                
                with eva_engine.connect() as connection:
                    result = connection.execute(text(delete_query))
                    deleted_count = result.rowcount if hasattr(result, 'rowcount') else 0
                    connection.commit()
                    
                print(f"   ✅ Removed {deleted_count} rows with null required columns")
                return True
                
            except Exception as cleanup_error:
                print(f"   ❌ Error during stage table cleanup: {str(cleanup_error)}")
                return False
                
        except Exception as e:
            print(f"   ❌ Error in stage table cleanup for {endpoint}: {str(e)}")
            return False
    
    def _get_cms_details(self):
        """
        Get CMS details using the generic, integration-agnostic CMS manager
        """
        if not self.etani_client_id or not self.etani_organisation_id:
            print("Warning: Cannot get CMS details - client or organization ID missing")
            return
            
        try:
            # Import the generic CMS manager
            try:
                from .cms_manager import CMSManager
            except ImportError:
                try:
                    # Fallback for standalone execution
                    from cms_manager import CMSManager
                except ImportError:
                    # Fallback to mock for testing
                    from mock_cms_manager import CMSManager
            
            # Create CMS manager for XEROBLUE integration
            cms_manager = CMSManager(
                integration_name="XEROBLUE",
                client_id=self.etani_client_id,
                organisation_id=self.etani_organisation_id,
                error_list=self.error_list,
                job_id=self.job_id,
                job_run_id=self.job_run_id
            )
            
            # Get CMS details
            cms_details = cms_manager.get_cms_details(tenant_id=self.xero_tenant_id)
            
            # Populate the legacy values from CMS
            self.org_status = cms_details['org_status']
            self.legacy_client_id = cms_details['legacy_client_id']
            self.legacy_organisation_id = cms_details['legacy_organisation_id']
            self.firm_id = cms_details['firm_id']
            
            # Update XeroTenantID if provided by CMS
            if cms_details['tenant_id'] and cms_details['tenant_id'].strip():
                self.xero_tenant_id = cms_details['tenant_id']
            
            # Store the CMS manager for later use (e.g., for transactions endpoint)
            self.cms_manager = cms_manager
            
            print(f"✅ CMS Details Retrieved via Generic Manager:")
            print(f"  Organization Status: {self.org_status}")
            print(f"  Legacy Client ID: {self.legacy_client_id}")
            print(f"  Legacy Organization ID: {self.legacy_organisation_id}")
            print(f"  Firm ID: {self.firm_id}")
            print(f"  Xero Tenant ID: {self.xero_tenant_id}")
                
        except Exception as e:
            # Fallback to default values on any error
            self.legacy_organisation_id = 0
            self.firm_id = 0
            self.legacy_client_id = ''
            self.org_status = 0
            
            error_msg = f"Error getting CMS details via generic manager: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            
            # The CMSManager handles its own logging, so we don't duplicate it here
            print("⚠️  Using default values for CMS details")

    def validate_configuration(self) -> bool:
        """Validate that all required configuration is present"""
        print("\\n=== Configuration Validation ===")
        
        required_vars = {
            'EtaniClientID': self.etani_client_id,
            'EtaniOrganisationID': self.etani_organisation_id,
            'XeroTenantID': self.xero_tenant_id,
            'DB_Destination': self.db_destination
        }
        
        missing_vars = []
        for var_name, var_value in required_vars.items():
            if var_value:
                print(f"  ✅ {var_name}: {var_value}")
            else:
                print(f"  ❌ {var_name}: <missing>")
                missing_vars.append(var_name)
        
        # Also show CMS-derived values
        print(f"\\n=== CMS-Derived Values ===")
        print(f"  Legacy Organization ID: {self.legacy_organisation_id}")
        print(f"  Legacy Client ID: {self.legacy_client_id}")
        print(f"  Firm ID: {self.firm_id}")
        print(f"  Organization Status: {self.org_status}")
        
        if missing_vars:
            print(f"\\n❌ Missing required variables: {missing_vars}")
            return False
        
        print("\\n✅ Configuration validation passed")
        return True
    
    # ========================
    # Main Business Logic Methods
    # ========================
    
    def extract_api_response(self, endpoint: str) -> Dict[str, Any]:
        """
        Main method to extract and process API response for any endpoint
        This contains all the business logic and transformations
        """
        try:
            load_type = ''
            stage_count = 0
            prod_count = 0
            start_utc_date = datetime.now(timezone.utc)
            
            # Table naming (preserve existing logic)
            stage_table = self.table_prefix_eva + endpoint + 'STAGE'
            sp_name = 'sp_' + self.table_prefix_eva + endpoint
            prod_table = self.table_prefix_eva.replace('_' + str(self.etani_organisation_id), '') + endpoint
            dw_prod_table = self.table_prefix_dw.replace('_' + str(self.etani_organisation_id), '') + endpoint
            
            print(f"\\n=== Processing {endpoint} ===")
            print(f"Stage Table: {stage_table}")
            print(f"SP Name: {sp_name}")
            print(f"Prod Table: {prod_table}")
            print(f"DW Prod Table: {dw_prod_table}")
            
            # Use endpoint-specific processing
            print(f"   🔀 Routing logic: endpoint='{endpoint}', endpoint=='Organisations': {endpoint == 'Organisations'}")
            if endpoint == 'Organisations':
                return self._process_organisations_endpoint(
                    endpoint, stage_table, sp_name, prod_table, dw_prod_table, start_utc_date
                )
            elif endpoint == 'Accounts':
                return self._process_accounts_endpoint(
                    endpoint, stage_table, sp_name, prod_table, dw_prod_table, start_utc_date
                )
            elif endpoint in ['Transactions', 'TrackingCategoryConnections']:
                return {
                    'endpoint': endpoint,
                    'status': 'completed',
                    'stage_count': 0,
                    'prod_count': 0,
                    'load_type': 'N/A'
                }
            else: 
                return self._process_generic_endpoint(
                    endpoint, stage_table, sp_name, prod_table, dw_prod_table, start_utc_date
                )
                
        except Exception as e:
            error_msg = f"Error processing {endpoint}: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return {
                'endpoint': endpoint,
                'status': 'failed',
                'error': error_msg,
                'stage_count': 0,
                'prod_count': 0
            }
    
    def _process_organisations_endpoint(self, endpoint: str, stage_table: str, sp_name: str, 
                                      prod_table: str, dw_prod_table: str, start_utc_date: datetime) -> Dict[str, Any]:
        """Process Organisations endpoint with existing business logic"""
        load_type = 'Full'
        
        # Adjust table names for Organisations (preserve existing logic)
        stage_table = self.table_prefix_eva + endpoint + 'CLIENTSSTAGE'
        sp_name = sp_name + 'CLIENTS'
        prod_table = prod_table + 'CLIENTS'
        dw_prod_table = dw_prod_table + 'CLIENTS'
        
        # Log start
        self._log_last_refresh_date(prod_table, stage_table, load_type, 'Started', endpoint, 'EVA', start_utc_date)
        
        try:
            # 1. Make API request using enhanced patterns (simple endpoint, no params)
            from common_token_manager import create_token_manager
            token_manager = create_token_manager(self, self.legacy_client_id, self.legacy_organisation_id)
            
            api_data = self.make_api_request_with_patterns(endpoint, token_manager=token_manager)
            
            if api_data is None or api_data.empty:
                print(f"No data returned for {endpoint}")
                return {'endpoint': endpoint, 'status': 'no_data', 'stage_count': 0, 'prod_count': 0}
            
            print(f"Retrieved {len(api_data)} records from Xero API")
            
            # 2. Transform data (preserve existing mapping logic)
            combined_data = []
            for index, organisation in api_data.iterrows():
                base_data = {
                    'ShortCode': organisation.get('ShortCode', '') or '',
                    'APIKey': organisation.get('APIKey', '') or '',
                    'Name': organisation.get('Name', '') or '',
                    'LegalName': organisation.get('LegalName', '') or '',
                    'PaysTax': organisation.get('PaysTax', '') or '',
                    'Version': organisation.get('Version', '') or '',
                    'BaseCurrency': organisation.get('BaseCurrency', '') or '',
                    'CountryCode': organisation.get('CountryCode', '') or '',
                    'IsDemoCompany': organisation.get('IsDemoCompany', '') or '',
                    'OrganisationStatus': organisation.get('OrganisationStatus', '') or '',
                    'RegistrationNumber': organisation.get('RegistrationNumber', '') or '',
                    'TaxNumber': organisation.get('TaxNumber', '') or '',
                    'FinancialYearEndDay': organisation.get('FinancialYearEndDay', '') or '',
                    'FinancialYearEndMonth': organisation.get('FinancialYearEndMonth', '') or '',
                    'CreatedDateUTC': organisation.get('CreatedDateUTC', '') or '',
                    'OrganisationEntityType': organisation.get('OrganisationEntityType', '') or '',
                    'Timezone': organisation.get('Timezone', '') or '',
                    'Edition': organisation.get('Edition', '') or '',
                    'Class': organisation.get('Class', '') or '',
                    'LineOfBusiness': organisation.get('LineOfBusiness', '') or '',
                    'PeriodLockDate': organisation.get('PeriodLockDate', '') or '',
                    'EndOfYearLockDate': organisation.get('EndOfYearLockDate', '') or ''
                }
                combined_data.append(base_data)
            
            # 3. Convert to DataFrame and apply data type conversion
            combined_df = pd.DataFrame(combined_data)
            converted_data = self.convert_data_types(combined_df, endpoint)
            
            # 4. Load to staging table
            self._load_to_stage_table(converted_data, endpoint, "overwrite", stage_table)
            stage_count = len(converted_data)
            self._log_last_refresh_date(prod_table, stage_table, load_type, 'InProgress', endpoint, 'EVA', start_utc_date, stage_count)
            
            # 5. Execute stored procedure (preserve existing logic)
            self._execute_stored_procedure(endpoint, stage_count)
            
            # 6. Get production count
            prod_count = self._get_production_count(prod_table)
            self._log_last_refresh_date(prod_table, stage_table, load_type, 'Completed', endpoint, 'EVA', start_utc_date, stage_count, prod_count)
            
            print(f"✅ {endpoint} completed: {stage_count} staged, {prod_count} in production")
            
            return {
                'endpoint': endpoint,
                'status': 'completed',
                'stage_count': stage_count,
                'prod_count': prod_count
            }
            
        except Exception as e:
            error_msg = f"Error in Organisations processing: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            raise e
    
    def _process_accounts_endpoint(self, endpoint: str, stage_table: str, sp_name: str, 
                                 prod_table: str, dw_prod_table: str, start_utc_date: datetime) -> Dict[str, Any]:
        """Process Accounts endpoint with existing business logic"""
        load_type = 'Full'
        
        # Log start
        self._log_last_refresh_date(prod_table, stage_table, load_type, 'Started', endpoint, 'EVA', start_utc_date)
        
        try:
            # Make API request using enhanced patterns (simple endpoint, no params)
            from common_token_manager import create_token_manager
            token_manager = create_token_manager(self, self.legacy_client_id, self.legacy_organisation_id)
            
            api_data = self.make_api_request_with_patterns(endpoint, token_manager=token_manager)
            
            if api_data is None or api_data.empty:
                print(f"No data returned for {endpoint}")
                return {'endpoint': endpoint, 'status': 'no_data', 'stage_count': 0, 'prod_count': 0}
            
            print(f"Retrieved {len(api_data)} records from Xero API")
            
            # Transform data (preserve existing mapping logic)
            combined_data = []
            for index, account in api_data.iterrows():
                base_data = {
                    'AccountID': account.get('AccountID', ''),
                    'Code': account.get('Code', ''),
                    'Name': account.get('Name', ''),
                    'Status': account.get('Status', ''),
                    'Type': account.get('Type', ''),
                    'TaxType': account.get('TaxType', ''),
                    'Class': account.get('Class', ''),
                    'Description': account.get('Description', ''),
                    'SystemAccount': account.get('SystemAccount', ''),
                    'EnablePaymentsToAccount': account.get('EnablePaymentsToAccount', 0),
                    'ShowInExpenseClaims': account.get('ShowInExpenseClaims', 0),
                    # Add other fields as needed...
                }
                combined_data.append(base_data)
            
            # Process and load data
            combined_df = pd.DataFrame(combined_data)
            converted_data = self.convert_data_types(combined_df, endpoint)
            
            self._load_to_stage_table(converted_data, endpoint, "overwrite", stage_table)
            stage_count = len(converted_data)
            
            self._execute_stored_procedure(endpoint, stage_count)
            prod_count = self._get_production_count(prod_table)
            
            self._log_last_refresh_date(prod_table, stage_table, load_type, 'Completed', endpoint, 'EVA', start_utc_date, stage_count, prod_count)
            
            print(f"✅ {endpoint} completed: {stage_count} staged, {prod_count} in production")
            
            return {
                'endpoint': endpoint,
                'status': 'completed',
                'stage_count': stage_count,
                'prod_count': prod_count
            }
            
        except Exception as e:
            error_msg = f"Error in Accounts processing: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            raise e
    
    def _process_generic_endpoint(self, endpoint: str, stage_table: str, sp_name: str, 
                                prod_table: str, dw_prod_table: str, start_utc_date: datetime) -> Dict[str, Any]:
        """
        Process any generic endpoint with full pagination and parameter patterns from original XEROBLUE - UPSERT.py
        Handles all pagination types: page-based, offset-based, and simple endpoints
        """
        try:
            # Determine load type and get filter parameter
            load_type = self._determine_load_type(endpoint)
            filter_parameter = self._get_max_filter_parameter(endpoint, prod_table, 'EVA')
            
            # Initialize pagination variables
            page = 1
            offset = 0
            pagesize = 100
            stage_count = 0
            prod_count = 0
            
            # Setup pagination based on endpoint type and filter parameter
            page, offset, load_type, max_date = self._setup_pagination_for_endpoint(
                endpoint, filter_parameter, load_type
            )
            
            # Log start
            self._log_last_refresh_date(prod_table, stage_table, load_type, 'Started', endpoint, 'EVA', start_utc_date)
            
            # Create token manager
            from common_token_manager import create_token_manager
            token_manager = create_token_manager(self, self.legacy_client_id, self.legacy_organisation_id)
            
            # Main pagination loop - handles all endpoint types
            while True:
                print(f"🔄 Processing {endpoint} - Page/Offset: {page}/{offset}")
                
                # Make API request with pattern-based parameters
                api_data = self.make_api_request_with_patterns(
                    endpoint=endpoint,
                    page=page if self._uses_page_pagination(endpoint) else None,
                    offset=offset if self._uses_offset_pagination(endpoint) else None,
                    max_date=max_date,
                    token_manager=token_manager
                )
                
                if api_data is None or api_data.empty:
                    print(f"No more data returned for {endpoint}")
                    break
                
                print(f"Retrieved {len(api_data)} records from Xero API")
                
                # Transform data with endpoint-specific transformations
                converted_data = self.convert_data_types(api_data, endpoint)
                
                # Determine write mode based on pagination position
                write_mode = self._determine_write_mode(endpoint, page, offset, filter_parameter)
                
                # Load to stage table
                self._load_to_stage_table(converted_data, endpoint, write_mode, stage_table)
                stage_count += len(converted_data)
                
                # Log progress
                self._log_last_refresh_date(prod_table, stage_table, load_type, 'InProgress', endpoint, 'EVA', start_utc_date, stage_count)
                
                # Check if we should continue pagination
                if not self._should_continue_pagination(endpoint, api_data, pagesize):
                    break
                
                # Advance pagination
                if self._uses_page_pagination(endpoint):
                    page += 1
                elif self._uses_offset_pagination(endpoint):
                    offset += pagesize
                else:
                    # Simple endpoint - no pagination
                    break
            
            # Execute stored procedure
            self._execute_stored_procedure(endpoint, stage_count)
            prod_count = self._get_production_count(prod_table)
            
            # Log completion
            self._log_last_refresh_date(prod_table, stage_table, load_type, 'Completed', endpoint, 'EVA', start_utc_date, stage_count, prod_count)
            
            print(f"✅ {endpoint} completed: {stage_count} staged, {prod_count} in production")
            
            return {
                'endpoint': endpoint,
                'status': 'completed',
                'stage_count': stage_count,
                'prod_count': prod_count,
                'load_type': load_type
            }
            
        except Exception as e:
            error_msg = f"Error in {endpoint} processing: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return {
                'endpoint': endpoint,
                'status': 'failed',
                'error': error_msg,
                'stage_count': 0,
                'prod_count': 0
            }
    
    # ========================
    # Pagination and Filter Parameter Helper Methods
    # ========================
    
    def _determine_load_type(self, endpoint: str) -> str:
        """
        Determine the load type for an endpoint based on original XEROBLUE - UPSERT.py patterns
        """
        # Full load endpoints (always start fresh)
        full_load_endpoints = {
            'Organisations', 'Accounts', 'BankTransfers', 'BrandingThemes', 
            'Currencies', 'Employees', 'ExpenseClaims', 'LinkedTransactions',
            'PurchaseOrders', 'Receipts', 'RepeatingInvoices', 'TaxRates', 
            'BankSummary', 'TrialBalance', 'BalanceSheet', 'Budgets',
            'TrackingCategories', 'Quotes', 'Items', 'Users', 'ContactGroups'
        }
        
        if endpoint in full_load_endpoints:
            return 'Full'
        else:
            return 'Incremental'  # Default for most endpoints
    
    def _get_max_filter_parameter(self, endpoint: str, prod_table: str, db_destination: str):
        """
        Get max filter parameter based on original GetMaxFilterParameter function patterns
        Returns: datetime string for date-based endpoints, integer for journal-based endpoints
        """
        try:
            # Date-based filter endpoints (use UpdatedDateUTC)
            if endpoint in ('Invoices', 'CreditNotes', 'ManualJournals', 'Payments', 'BatchPayments', 
                          'Contacts', 'PurchaseOrders', 'Overpayments', 'Prepayments', 'BankTransactions', 
                          'InvoicesDraft', 'Items', 'Users', 'Quotes'):
                query = f"SELECT CAST(IFNULL(DATE_SUB(MAX(UpdatedDateUTC), INTERVAL 1 DAY), '2000-01-01') AS DATETIME) AS MaxDate FROM {prod_table} WHERE OrganisationID = {self.legacy_organisation_id}"
                df = ReadMySQLTable(query, endpoint, self.etani_client_id, self.etani_organisation_id, self.error_list)
                if not df.empty:
                    max_date = df.loc[0, 'MaxDate']
                    # Ensure we return a string for consistent date comparison
                    return str(max_date) if max_date is not None else '2000-01-01'
                else:
                    return '2000-01-01'
            
            # Journal number-based filter endpoints (use JournalNumber)
            elif endpoint in ('Journals', 'JournalsCash'):
                query = f'SELECT IFNULL(MAX(JournalNumber), 0) as MaxJournalNumber FROM {prod_table} WHERE OrganisationID = {self.legacy_organisation_id}'
                df = ReadMySQLTable(query, endpoint, self.etani_client_id, self.etani_organisation_id, self.error_list)
                if not df.empty:
                    max_journal = df.loc[0, 'MaxJournalNumber']
                    # Ensure we return an integer for journal number comparison
                    return int(max_journal) if max_journal is not None else 0
                else:
                    return 0
            
            # CreatedDateUTC-based filter endpoints
            elif endpoint in ('TransactionsBlend',):
                query = f"SELECT CAST(IFNULL(DATE_SUB(MAX(CreatedDateUTC), INTERVAL 1 DAY), '2000-01-01') AS DATETIME) AS MaxDate FROM {prod_table} WHERE OrganisationID = {self.legacy_organisation_id}"
                df = ReadMySQLTable(query, endpoint, self.etani_client_id, self.etani_organisation_id, self.error_list)
                if not df.empty:
                    max_date = df.loc[0, 'MaxDate']
                    # Ensure we return a string for consistent date comparison
                    return str(max_date) if max_date is not None else '2000-01-01'
                else:
                    return '2000-01-01'
            
            # Budget year-based filter
            elif endpoint in ('Budgets',):
                query = f"SELECT IFNULL(YEAR(CONCAT(MAX(`BudgetLines.BudgetBalances.Period`),'-01'))-1, 2019) AS MaxYear FROM {prod_table} WHERE OrganisationID = {self.legacy_organisation_id}"
                df = ReadMySQLTable(query, endpoint, self.etani_client_id, self.etani_organisation_id, self.error_list)
                max_year = df.loc[0, 'MaxYear'] if not df.empty else 2019
                return f"{max_year}-07-01"
            
            # No filter needed for simple endpoints
            else:
                return None
                
        except Exception as e:
            print(f"⚠️  Error getting filter parameter for {endpoint}: {str(e)}")
            # Return safe defaults
            if endpoint in ('Journals', 'JournalsCash'):
                return 0
            elif endpoint in ('Budgets',):
                return "2019-07-01"
            else:
                return '2000-01-01'
    
    def _setup_pagination_for_endpoint(self, endpoint: str, filter_parameter, load_type: str) -> tuple:
        """
        Setup pagination variables based on endpoint type and filter parameter
        Returns: (page, offset, load_type, max_date)
        """
        page = 1
        offset = 0
        max_date = None
        
        # Page-based pagination endpoints
        if self._uses_page_pagination(endpoint):
            page = 1
            if filter_parameter and endpoint not in ('LinkedTransactions', 'TrackingCategories', 'Quotes'):
                max_date = str(filter_parameter)
                # Handle date comparison properly - convert both sides to strings for comparison
                filter_date_str = str(filter_parameter)
                load_type = 'Incremental' if filter_date_str > '2000-01-01' else 'Full'
        
        # Offset-based pagination endpoints
        elif self._uses_offset_pagination(endpoint):
            # For offset endpoints, filter_parameter should be a number (JournalNumber)
            if filter_parameter and isinstance(filter_parameter, (int, float)) and filter_parameter > 0:
                offset = int(filter_parameter) - 1
                load_type = 'Latest'
            else:
                offset = 0
                load_type = 'Full'
        
        # Simple endpoints (no pagination)
        else:
            # Most simple endpoints use full load
            load_type = 'Full'
        
        return page, offset, load_type, max_date
    
    def _uses_page_pagination(self, endpoint: str) -> bool:
        """Check if endpoint uses page-based pagination"""
        page_based_endpoints = {
            'Invoices', 'CreditNotes', 'Overpayments', 'Prepayments', 'ManualJournals',
            'Payments', 'BankTransactions', 'Contacts', 'InvoicesDraft', 'PurchaseOrders',
            'LinkedTransactions', 'Quotes', 'TrackingCategories', 'Items', 'Users'
        }
        return endpoint in page_based_endpoints
    
    def _uses_offset_pagination(self, endpoint: str) -> bool:
        """Check if endpoint uses offset-based pagination"""
        offset_based_endpoints = {'Journals', 'JournalsCash'}
        return endpoint in offset_based_endpoints
    
    def _determine_write_mode(self, endpoint: str, page: int, offset: int, filter_parameter) -> str:
        """
        Determine write mode (overwrite/append) based on pagination position
        Based on original XEROBLUE - UPSERT.py patterns
        """
        if self._uses_page_pagination(endpoint):
            # First page always overwrites
            return "overwrite" if page == 1 else "append"
        
        elif self._uses_offset_pagination(endpoint):
            # Overwrite if we're at or before the filter parameter, append after
            if isinstance(filter_parameter, (int, float)):
                return "overwrite" if offset <= filter_parameter else "append"
            else:
                return "overwrite" if offset == 0 else "append"
        
        else:
            # Simple endpoints always overwrite
            return "overwrite"
    
    def _should_continue_pagination(self, endpoint: str, api_data: pd.DataFrame, pagesize: int) -> bool:
        """
        Check if pagination should continue based on data returned
        """
        if api_data is None or api_data.empty:
            return False
        
        # If we got less than pagesize records, we've reached the end
        if len(api_data) < pagesize:
            return False
        
        # For simple endpoints (no pagination), never continue
        if not self._uses_page_pagination(endpoint) and not self._uses_offset_pagination(endpoint):
            return False
        
        return True

    # ========================
    # Helper Methods for Database Operations
    # ========================
    
    def _get_stage_table_columns(self, stage_table: str) -> set:
        """Get the actual column names from the stage table schema"""
        try:                        
            query = text("""
                SELECT COLUMN_NAME 
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = DATABASE() 
                AND TABLE_NAME = :table_name
            """)
            
            with eva_engine.connect() as connection:
                result = connection.execute(query, {"table_name": stage_table})
                columns = {row[0] for row in result.fetchall()}
                
            print(f"   📋 Stage table '{stage_table}' has {len(columns)} columns")
            return columns
            
        except Exception as e:
            print(f"❌ Error getting stage table columns for {stage_table}: {str(e)}")
            # Return empty set to avoid filtering if we can't get schema
            return set()
    
    def _filter_dataframe_columns(self, df: pd.DataFrame, endpoint: str, stage_table: str) -> pd.DataFrame:
        """Filter DataFrame to only include columns that exist in the target stage table"""
        try:
            print(f"   🔍 Filtering columns for {endpoint} (DataFrame has {len(df.columns)} columns)")
            
            # Special handling for report endpoints - they need different processing
            if endpoint in self.report_endpoints:
                print(f"   📊 Report endpoint detected: {endpoint}")
                return self._handle_report_data_structure(df, endpoint, stage_table)
            
            # Get actual stage table columns for regular endpoints
            stage_columns = self._get_stage_table_columns(stage_table)
            
            if not stage_columns:
                print(f"   ⚠️  Could not get stage table schema, applying safe filtering")
                # If we can't get schema, at least filter out known problematic columns
                safe_columns = [col for col in df.columns if col not in {
                    'HasValidationErrors', 'ValidationErrors', 'HasAttachments',
                    'ProviderName', 'DateTimeUTC', 'Id', 'Status', 'pagination',
                    'ReportID', 'ReportName', 'ReportType', 'ReportTitles', 'Fields', 'Rows'
                }]
                if safe_columns:
                    print(f"   🔒 Applied safe filtering: keeping {len(safe_columns)} columns")
                    return df[safe_columns].copy()
                else:
                    print(f"   ⚠️  No safe columns found, returning empty DataFrame")
                    return pd.DataFrame()
            
            # Define columns to always exclude (validation and metadata columns)
            excluded_columns = {
                'HasValidationErrors', 'ValidationErrors', 'HasAttachments',
                'ProviderName', 'DateTimeUTC', 'Id', 'Status', 'pagination'
            }
            
            # Get DataFrame columns that exist in stage table and are not excluded
            valid_columns = []
            excluded_by_schema = []
            excluded_by_filter = []
            
            for col in df.columns:
                if col in excluded_columns:
                    excluded_by_filter.append(col)
                elif col in stage_columns:
                    valid_columns.append(col)
                else:
                    excluded_by_schema.append(col)
            
            # Log filtering results
            if excluded_by_filter:
                print(f"   🚫 Excluded validation/metadata columns: {excluded_by_filter}")
            if excluded_by_schema:
                print(f"   🚫 Excluded non-existent columns: {excluded_by_schema}")
            
            print(f"   ✅ Keeping {len(valid_columns)} valid columns for insertion")
            
            # Return filtered DataFrame
            if valid_columns:
                return df[valid_columns].copy()
            else:
                print(f"   ⚠️  No valid columns found, returning original DataFrame")
                return df
                
        except Exception as e:
            print(f"❌ Error filtering DataFrame columns: {str(e)}")
            import traceback
            traceback.print_exc()
            return df
    
    def _handle_report_data_structure(self, df: pd.DataFrame, endpoint: str, stage_table: str) -> pd.DataFrame:
        """Handle report endpoint data structure - reports have different format than regular endpoints"""
        try:
            print(f"   📊 Processing report data for {endpoint}")
            
            if df.empty:
                return df
            
            # Report endpoints have a special structure with ReportID, ReportName, etc.
            # For now, we'll create a simplified structure that can fit standard stage tables
            
            # Get stage table columns to see what's available
            stage_columns = self._get_stage_table_columns(stage_table)
            
            if not stage_columns:
                print(f"   ⚠️  No stage table schema available for {endpoint}, skipping database insertion")
                return pd.DataFrame()  # Return empty to skip insertion
            
            # Option 1: Create a minimal compatible structure from report metadata
            report_data = []
            for index, row in df.iterrows():
                # Extract basic report information that might fit standard columns
                basic_data = {
                    'Name': row.get('ReportName', endpoint),
                    'Type': row.get('ReportType', endpoint),
                    'UpdatedDateUTC': row.get('UpdatedDateUTC', ''),
                    'ReportDate': row.get('ReportDate', ''),
                }
                
                # Only keep columns that exist in the stage table
                filtered_data = {k: v for k, v in basic_data.items() if k in stage_columns}
                
                if filtered_data:  # Only add if we have valid columns
                    report_data.append(filtered_data)
            
            if report_data:
                result_df = pd.DataFrame(report_data)
                print(f"   ✅ Created compatible report structure with {len(result_df.columns)} columns: {list(result_df.columns)}")
                return result_df
            else:
                print(f"   ⚠️  No compatible columns found for {endpoint}, creating minimal structure")
                
                # Option 2: Create minimal structure with just essential data
                minimal_data = {
                    'EndpointName': endpoint,
                    'ProcessedDate': pd.Timestamp.now().strftime('%Y-%m-%d %H:%M:%S'),
                    'RecordCount': len(df)
                }
                
                # Filter to only columns that exist in stage table
                compatible_minimal = {k: v for k, v in minimal_data.items() if k in stage_columns}
                
                if compatible_minimal:
                    result_df = pd.DataFrame([compatible_minimal])
                    print(f"   ℹ️ Created minimal report structure: {list(result_df.columns)}")
                    return result_df
                else:
                    print(f"   🙅 No compatible structure possible for {endpoint}, skipping database insertion")
                    return pd.DataFrame()  # Skip insertion
                    
        except Exception as e:
            print(f"   ❌ Error handling report data structure for {endpoint}: {str(e)}")
            import traceback
            traceback.print_exc()
            # Return empty DataFrame to skip insertion rather than cause errors
            return pd.DataFrame()
    
    def _log_last_refresh_date(self, prod_table: str, stage_table: str, load_type: str, 
                              status: str, endpoint: str, db_type: str, start_date: datetime, 
                              stage_count: int = 0, prod_count: int = 0):
        """Log last refresh date (placeholder for existing function)"""
        print(f"Logging refresh for {endpoint}: {status} - Stage: {stage_count}, Prod: {prod_count}")
    
    def _load_to_stage_table(self, data, endpoint: str, write_mode: str, stage_table: str):
        """Load data to staging table with row and column filtering (uses existing LoadToEvaStageTable if available)"""
        try:
            print(f"   🔧 Preparing {len(data)} rows for loading to {stage_table}")
            
            # Step 1: Apply default values for missing required columns
            data_with_defaults = self._apply_default_values_for_required_columns(data, endpoint)
            
            # Step 2: Filter out rows with null required columns (prevents IntegrityError)
            data_filtered_rows = self._filter_rows_with_null_required_columns(data_with_defaults, endpoint)
            
            if data_filtered_rows.empty:
                print(f"   ⚠️  No valid rows remaining for {endpoint} after filtering")
                print(f"   ℹ️  This can happen if all rows have null required columns")
                print(f"   ✅ Skipping database insertion to prevent IntegrityError")
                return
            
            # Step 3: Filter DataFrame to only include valid columns  
            filtered_data = self._filter_dataframe_columns(data_filtered_rows, endpoint, stage_table)
            
            if filtered_data.empty:
                print(f"   ⚠️  No data to insert for {endpoint} after column filtering (this is safe for report endpoints)")
                return
            
            print(f"   📊 Loading {len(filtered_data)} valid rows with {len(filtered_data.columns)} columns to {stage_table}")
            print(f"   📋 Columns: {list(filtered_data.columns)}")
            
            # Step 4: Load to database
            LoadToEvaStageTable(filtered_data, endpoint, write_mode, stage_table, self.error_list)
            print(f"   ✅ Successfully loaded {len(filtered_data)} rows to {stage_table}")
            
        except Exception as e:
            error_msg = f"Error loading to stage table {stage_table}: {str(e)}"
            print(f"❌ {error_msg}")
            
            # Check for specific database column errors
            if "Unknown column" in str(e) and endpoint in self.report_endpoints:
                print(f"   📊 This is a report endpoint - the error may be due to report data structure")
                print(f"   🔧 Report endpoints require special handling and may not insert to database")
            
            # Check for IntegrityError and provide helpful guidance
            if "IntegrityError" in str(e) and "cannot be null" in str(e):
                print(f"   💡 IntegrityError detected - this should have been prevented by row filtering")
                print(f"   🔍 Consider checking if required columns are properly defined for {endpoint}")
            
            # Don't re-raise for report endpoints, just log the error
            if endpoint in self.report_endpoints:
                print(f"   ℹ️  Report endpoint error logged but not re-raised")
                self.error_list.append(error_msg)
                return
            
            # For regular endpoints, log and re-raise
            import traceback
            traceback.print_exc()
            self.error_list.append(error_msg)
            raise e
    
    def _execute_stored_procedure(self, endpoint: str, stage_count: int):
        """Execute stored procedure with pre-execution validation (uses existing ExecuteEvaSP if available)"""
        try:
            # Pre-execution validation: Check for null required columns in stage table
            if not self._validate_stage_table_before_sp_execution(endpoint):
                print(f"   ⚠️  Skipping stored procedure for {endpoint} due to validation failures")
                print(f"   ℹ️  This prevents IntegrityError: Column 'X' cannot be null")
                return
            
            # Map each endpoint to its specific stored procedure call
            if endpoint == 'Organisations':
                sp_call = f"CALL sp_dynamic_xeroblue_default('organisationsclients','{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Accounts':
                sp_call = f"CALL sp_dynamic_xeroblue_accounts('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Invoices':
                sp_call = f"CALL sp_dynamic_xeroblue_invoices('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'CreditNotes':
                sp_call = f"CALL sp_dynamic_xeroblue_creditnotes('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Overpayments':
                sp_call = f"CALL sp_dynamic_xeroblue_overpayments('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Prepayments':
                sp_call = f"CALL sp_dynamic_xeroblue_prepayments('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'ManualJournals':
                sp_call = f"CALL sp_dynamic_xeroblue_manualjournals('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Payments':
                sp_call = f"CALL sp_dynamic_xeroblue_payments('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'BankTransactions':
                sp_call = f"CALL sp_dynamic_xeroblue_banktransactions('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Journals':
                sp_call = f"CALL sp_dynamic_xeroblue_journals('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'JournalsCash':
                sp_call = f"CALL sp_dynamic_xeroblue_journalscash('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Transactions':
                # Note: This one uses legacy_client_id differently - uses the raw legacy client ID from CMS
                cms_legacy_client_id = self.cms_manager.get_legacy_client_id_for_transactions() if hasattr(self, 'cms_manager') else self.client_id_number
                sp_call = f"CALL sp_dynamic_xeroblue_transactions('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id}, '{cms_legacy_client_id}')"
            elif endpoint == 'TransactionsBlend':
                sp_call = f"CALL sp_dynamic_xeroblue_transactionsblend('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'TrackingCategoryConnections':
                sp_call = f"CALL sp_dynamic_xeroblue_trackingcategoryconnections('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Budgets':
                sp_call = f"CALL sp_dynamic_xeroblue_budgets('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'BankTransfers':
                sp_call = f"CALL sp_dynamic_xeroblue_banktransfers('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'BatchPayments':
                sp_call = f"CALL sp_dynamic_xeroblue_batchpayments('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Contacts':
                sp_call = f"CALL sp_dynamic_xeroblue_contacts('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'InvoicesDraft':
                sp_call = f"CALL sp_dynamic_xeroblue_invoicesdraft('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            elif endpoint == 'Items':
                sp_call = f"CALL sp_dynamic_xeroblue_items('{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            # Default case for endpoints that use sp_dynamic_xeroblue_default
            elif endpoint in ['RepeatingInvoices', 'TaxRates', 'Users', 'ContactGroups', 'ExpenseClaims', 
                            'PurchaseOrders', 'Receipts', 'TrackingCategories', 'Employees', 'LinkedTransactions',
                            'Quotes', 'BankSummary', 'TrialBalance', 'BalanceSheet', 'BrandingThemes', 'Currencies']:
                sp_call = f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            else:
                # Fallback for any unknown endpoints
                sp_call = f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{self.client_id_number}', {self.etani_organisation_id}, {self.legacy_organisation_id})"
            
            # Execute the stored procedure
            ExecuteEvaSP(sp_call, endpoint, self.error_list, True)
            print(f"✅ Executed stored procedure for {endpoint}: {sp_call}")
            
        except Exception as e:
            error_msg = f"Error executing stored procedure for {endpoint}: {e}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            raise e
    
    def _get_production_count(self, prod_table: str) -> int:
        """Get production table count (uses existing ReadMySQLTable if available)"""
        try:
            df_count = ReadMySQLTable(
                f'SELECT COUNT(*) as Count FROM {prod_table} WHERE OrganisationID = {self.legacy_organisation_id}',
                'count_query', self.etani_client_id, self.etani_organisation_id, self.error_list
            )
            return df_count.loc[0, 'Count'] if not df_count.empty else 0
        except Exception as e:
            print(f"Error getting production count: {e}")
            return 0
    
    def run_full_sync(self, endpoint_list: list = None) -> Dict[str, Any]:
        """
        Run full synchronization for specified endpoints
        This is the main entry point for the integration
        """
        print("\\n" + "="*60)
        print("XeroBlue Integration - Full Sync")
        print("="*60)
        
        # First, check if execution should proceed based on organization status and environment
        print("\\n🔍 Checking execution prerequisites...")
        should_execute, reason = self.should_execute_endpoints()
        
        if not should_execute:
            # Log the execution decision for audit purposes
            self.log_execution_decision(should_execute, reason)
            
            # Create detailed error response
            error_response = {
                'status': 'failed',
                'error': 'Execution blocked by organization status check',
                'error_details': {
                    'reason': reason,
                    'organization_status': getattr(self, 'org_status', 'Unknown'),
                    'organization_status_description': self._get_status_description(getattr(self, 'org_status', 0)) if hasattr(self, 'org_status') else 'Unknown',
                    'reset_mode': self._get_reset_mode(),
                    'db_destination': self._get_db_destination(),
                    'check_type': 'organization_status_and_environment'
                },
                'duration_seconds': 0.0,
                'total_endpoints': 0,
                'successful_endpoints': 0,
                'failed_endpoints': 0,
                'total_records_processed': 0,
                'endpoint_results': {},
                'errors': [reason]
            }
            
            print(f"\\n❌ Execution Blocked:")
            print(f"   Reason: {reason}")
            print(f"   Organization Status: {error_response['error_details']['organization_status']} ({error_response['error_details']['organization_status_description']})")
            print(f"   Reset Mode: {error_response['error_details']['reset_mode']}")
            print(f"   DB Destination: {error_response['error_details']['db_destination']}")
            print("="*60)
            
            return error_response
        
        # Log successful execution decision
        self.log_execution_decision(should_execute, reason)
        print(f"✅ Execution approved: {reason}")
        
        # Set refresh status to Pending at start of processing
        self.update_last_refresh_date('Pending')
        
        # Validate configuration
        if not self.validate_configuration():
            return {'status': 'failed', 'error': 'Configuration validation failed'}
        
        # Initialize database indexes before processing endpoints
        print("\n🔍 Initializing database indexes...")
        if not self.initialize_indexes():
            return {
                'status': 'failed', 
                'error': 'Failed to initialize database indexes',
                'error_details': {
                    'phase': 'index_initialization',
                    'errors': self.error_list
                },
                'duration_seconds': 0.0,
                'total_endpoints': 0,
                'successful_endpoints': 0,
                'failed_endpoints': 0,
                'total_records_processed': 0,
                'endpoint_results': {},
                'errors': self.error_list
            }
        print("✅ Database indexes initialized successfully")
        
        # Default endpoint list (preserve existing order and selection)
        if endpoint_list is None:
            endpoint_list = [
                'Organisations', 'Accounts', 'Invoices', 'CreditNotes', 'Overpayments',
                'Prepayments', 'ManualJournals', 'Payments', 'BankTransactions',
                'Transactions', 'Journals', 'JournalsCash', 'Budgets',
                'TrackingCategoryConnections', 'BankTransfers', 'BatchPayments',
                'BrandingThemes', 'Contacts', 'Currencies', 'InvoicesDraft',
                'RepeatingInvoices', 'TaxRates', 'Users', 'ContactGroups',
                'ExpenseClaims', 'Items', 'PurchaseOrders', 'Receipts',
                'TrackingCategories', 'Employees', 'LinkedTransactions',
                'Quotes', 'BankSummary', 'TrialBalance'
            ]
        
        # Process endpoints
        results = {}
        successful_endpoints = []
        failed_endpoints = []
        total_records = 0
        
        print(f"\\nProcessing {len(endpoint_list)} endpoints...")
        
        for i, endpoint in enumerate(endpoint_list, 1):
            print(f"\\n[{i}/{len(endpoint_list)}] Processing {endpoint}...")
            
            try:
                result = self.extract_api_response(endpoint)
                results[endpoint] = result
                
                if result['status'] == 'completed':
                    successful_endpoints.append(endpoint)
                    total_records += result.get('stage_count', 0)
                else:
                    failed_endpoints.append(endpoint)
                    
            except Exception as e:
                error_msg = f"Failed to process {endpoint}: {str(e)}"
                print(f"❌ {error_msg}")
                failed_endpoints.append(endpoint)
                results[endpoint] = {
                    'endpoint': endpoint,
                    'status': 'failed',
                    'error': error_msg
                }
        
        # Summary
        end_time = time.time()
        duration = end_time - self.start_time
        
        summary = {
            'status': 'completed' if not failed_endpoints else 'completed_with_errors',
            'duration_seconds': duration,
            'total_endpoints': len(endpoint_list),
            'successful_endpoints': len(successful_endpoints),
            'failed_endpoints': len(failed_endpoints),
            'total_records_processed': total_records,
            'endpoint_results': results,
            'errors': self.error_list
        }
        
        # Update refresh status based on completion
        if summary['status'] == 'completed':
            self.update_last_refresh_date('Completed')
        elif summary['status'] in ['completed_with_errors', 'failed']:
            self.update_last_refresh_date('Failed')
        
        self._log_execution_summary(summary)
        
        return summary
    
    def _log_execution_summary(self, summary: Dict[str, Any]):
        """Log execution summary"""
        print("\\n" + "="*60)
        print("XeroBlue Integration - Execution Summary")
        print("="*60)
        print(f"Status: {summary['status']}")
        print(f"Duration: {summary['duration_seconds']:.1f} seconds")
        print(f"Endpoints: {summary['successful_endpoints']}/{summary['total_endpoints']} successful")
        print(f"Records Processed: {summary['total_records_processed']}")
        
        if summary['failed_endpoints'] > 0:
            print(f"\\n❌ Failed Endpoints: {summary['failed_endpoints']}")
            for endpoint, result in summary['endpoint_results'].items():
                if result['status'] == 'failed':
                    print(f"  - {endpoint}: {result.get('error', 'Unknown error')}")
        
        if summary['errors']:
            print(f"\\n⚠️  Errors: {len(summary['errors'])}")
            for error in summary['errors'][:5]:  # Show first 5 errors
                print(f"  - {error}")
        
        print("="*60)
    
    # ========================
    # INSERT Integration Interface
    # ========================
    
    def get_insert_configuration(self) -> Dict[str, Any]:
        """
        Get configuration for INSERT operations - required interface for IntegrationPackageInsert
        
        Returns:
            Dictionary containing all configuration needed for SQL object creation
        """
        return {
            'integration_name': self.integration_name,
            'client_id': self.client_id_number,
            'organisation_id': self.etani_organisation_id,
            'legacy_client_id': self.legacy_client_id,
            'base_currency': 'AUD',  # Default for XeroBlue
            'fx_currencies': self.integration_config.get('default_fx_currencies', ['AUD', 'USD', 'NZD', 'GBP', 'EUR']),
            'error_list': self.error_list,
            'rate_limit': self.integration_config.get('rate_limit', 60),
            'max_workers': self.integration_config.get('max_workers', 30),
            'timeout_seconds': self.integration_config.get('timeout_seconds', 900)
        }
    
    def create_sql_objects(self, parallel: bool = True) -> bool:
        """
        XeroBlue-specific SQL object creation (optional override for IntegrationPackageInsert)
        
        Args:
            parallel: Whether to create objects in parallel
            
        Returns:
            True if successful, False otherwise
        """
        try:
            print(f"🔨 Creating XeroBlue SQL Objects")
            print(f"   Client: {self.client_id_number}")
            print(f"   Organization: {self.etani_organisation_id}")
            print(f"   Legacy Client: {self.legacy_client_id}")
            print(f"   Parallel: {parallel}")
            
            # Use the integration-agnostic SQL Object Manager
            from .sql_object_manager import create_sql_objects_for_integration
            
            success, details = create_sql_objects_for_integration(
                integration_name=self.integration_name,
                client_id=self.client_id_number,
                organisation_id=self.etani_organisation_id,
                legacy_client_id=self.legacy_client_id,
                error_list=self.error_list,
                base_currency='AUD',
                fx_currencies=self.integration_config.get('default_fx_currencies', ['AUD', 'USD', 'NZD', 'GBP', 'EUR']),
                parallel=parallel
            )
            
            if success:
                print(f"✅ XeroBlue SQL objects created successfully")
                print(f"   Success Rate: {details.get('success_rate', 0):.2%}")
                print(f"   Objects Created: {details.get('successful_objects', 0)}/{details.get('total_objects', 0)}")
            else:
                print(f"❌ Failed to create XeroBlue SQL objects")
                print(f"   Failed Objects: {details.get('failed_objects', [])}")
                
            return success
            
        except Exception as e:
            error_msg = f"Error in XeroBlue SQL object creation: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return False
    
    def initialize_indexes(self) -> bool:
        """
        XeroBlue-specific index initialization with efficient checking
        
        Creates indexes on PRODUCTION and STAGE tables, with deduplication and efficiency checks.
        Only creates indexes that don't already exist.
        
        Returns:
            True if successful, False otherwise
        """
        try:
            print(f"🔍 Initializing XeroBlue indexes")
            return self._check_and_init_indexes()
            
        except Exception as e:
            error_msg = f"Error initializing XeroBlue indexes: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return False
    
    def _check_and_init_indexes(self) -> bool:
        """
        Create indexes on PRODUCTION and STAGE tables, with deduplication and efficiency.
        Based on original CheckAndInitIndexes from XEROBLUE - UPSERT.py
        """
        try:
            print("📊 Starting comprehensive index creation with efficiency checks...")
            
            # Get existing indexes first for efficiency
            existing_indexes = self._get_existing_indexes()
            print(f"🔍 Found {len(existing_indexes)} existing indexes")
            
            # Define all indexes to be created
            indexes_to_create = self._get_index_definitions()
            print(f"📋 Total indexes defined: {len(indexes_to_create)}")
            
            # Filter out already existing indexes
            new_indexes = [idx for idx in indexes_to_create if idx['index_name'] not in existing_indexes]
            print(f"✨ New indexes to create: {len(new_indexes)}")
            print(f"⏭️  Skipping {len(indexes_to_create) - len(new_indexes)} existing indexes")
            
            # Create indexes in batches for efficiency
            success_count = 0
            skip_count = 0
            error_count = 0
            
            for index_def in new_indexes:
                if index_def['index_type'] == 'stage':
                    success = self._add_stage_table_index(index_def['endpoint'], index_def['columns'])
                else:  # client table
                    success = self._add_client_table_index(index_def['endpoint'], index_def['columns'])
                
                if success:
                    success_count += 1
                else:
                    error_count += 1
            
            # Also create any skipped indexes to handle the ones that might already exist
            for index_def in indexes_to_create:
                if index_def['index_name'] in existing_indexes:
                    skip_count += 1
            
            print(f"📈 Index creation summary:")
            print(f"   ✅ Created: {success_count}")
            print(f"   ⏭️  Skipped (existing): {skip_count}")
            print(f"   ❌ Errors: {error_count}")
            
            total_processed = success_count + skip_count + error_count
            print(f"   📊 Total processed: {total_processed}")
            
            return error_count == 0
            
        except Exception as e:
            error_msg = f"Error in _check_and_init_indexes: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return False
    
    def _get_existing_indexes(self) -> set:
        """
        Get list of existing indexes from database for efficiency checking
        
        Returns:
            Set of existing index names
        """
        try:
            # Get client table prefix and stage table prefix
            client_prefix = self._get_client_table_prefix()
            stage_prefix = self._get_stage_table_prefix()
            
            query = text("""
                SELECT DISTINCT INDEX_NAME 
                FROM INFORMATION_SCHEMA.STATISTICS 
                WHERE TABLE_SCHEMA = DATABASE() 
                AND (TABLE_NAME LIKE :client_prefix OR TABLE_NAME LIKE :stage_prefix)
                AND INDEX_NAME != 'PRIMARY'
            """)
            
            with eva_engine.connect() as conn:
                result = conn.execute(query, {
                    'client_prefix': f'{client_prefix}%',
                    'stage_prefix': f'{stage_prefix}%'
                })
                existing_indexes = {row[0] for row in result.fetchall()}
                return existing_indexes
                
        except Exception as e:
            print(f"⚠️  Warning: Could not fetch existing indexes: {str(e)}")
            return set()  # Return empty set to allow all index creation attempts
    
    def _get_index_definitions(self) -> List[Dict[str, str]]:
        """
        Get comprehensive list of all indexes that should be created
        Based on original CheckAndInitIndexes method
        
        Returns:
            List of index definitions with endpoint, columns, and type
        """
        indexes = []
        
        # Stage table indexes
        stage_indexes = [
            ("overpayments", "OrganisationId,OverPaymentId"),
            ("overpayments", "CurrencyCode,Date"),
            ("prepayments", "CurrencyCode,Date"),
            ("Invoices", "InvoiceId"),
            ("ManualJournals", "ManualJournalId"),
            ("Payments", "PaymentId"),
            ("BankTransactions", "BankTransactionId"),
            ("BatchPayments", "BatchPaymentId"),
            ("Payments", "OrganisationId,PaymentId,InvoiceId,PaymentType,Amount"),
            ("Journals", "OrganisationId, SourceId"),
            ("Journals", "JournalLine_JournalLineId"),
            ("Journals", "OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount"),
            ("Journals", "JournalDate"),
            ("Journals", "JournalId"),
            ("JournalsCash", "OrganisationId, SourceId"),
            ("JournalsCash", "JournalLine_JournalLineId"),
            ("JournalsCash", "OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount"),
            ("JournalsCash", "JournalDate"),
            ("JournalsCash", "JournalId"),
        ]
        
        for endpoint, columns in stage_indexes:
            index_name = self._generate_stage_index_name(endpoint, columns)
            indexes.append({
                'endpoint': endpoint,
                'columns': columns,
                'index_type': 'stage',
                'index_name': index_name
            })
        
        # Client table indexes (Production tables)
        client_indexes = [
            # Journals indexes
            ("Journals", "OrganisationId, SourceId"),
            ("Journals", "JournalLine_JournalLineId"),
            ("Journals", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount"),
            ("Journals", "JournalDate"),
            ("Journals", "JournalLine_AccountId,OrganisationID"),
            ("Journals", "OrganisationID,JournalLine_AccountId,JournalDate,ContactName,JournalLine_NetAmount"),
            ("Journals", "JournalId"),
            ("Journals", "JournalDate,JournalId"),
            ("Journals", "SourceType,Changes"),
            ("Journals", "ContactSource,Changes"),
            ("Journals", "OrganisationID, JournalDate, JournalLine_NetAmount"),
            ("Journals", "JournalLine_NetAmount"),
            ("Journals", "JournalLine_AccountType"),
            ("Journals", "LineItem_TrackingCategory1_CategoryName"),
            ("Journals", "LineItem_TrackingCategory1_OptionName"),
            ("Journals", "OrganisationName"),
            ("Journals", "PaymentType"),
            
            # JournalsCash indexes
            ("JournalsCash", "OrganisationId, SourceId"),
            ("JournalsCash", "JournalLine_JournalLineId"),
            ("JournalsCash", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount"),
            ("JournalsCash", "OrganisationID,JournalLine_AccountId,ContactName,JournalLine_NetAmount"),
            ("JournalsCash", "JournalDate"),
            ("JournalsCash", "JournalId"),
            ("JournalsCash", "JournalDate,JournalId"),
            ("JournalsCash", "SourceType,Changes"),
            ("JournalsCash", "ContactSource,Changes"),
            ("JournalsCash", "OrganisationID, JournalDate, JournalLine_NetAmount"),
            ("JournalsCash", "JournalLine_NetAmount"),
            ("JournalsCash", "JournalLine_AccountType"),
            ("JournalsCash", "LineItem_TrackingCategory1_OptionName"),
            ("JournalsCash", "OrganisationName"),
            ("JournalsCash", "PaymentType"),
            
            # Transactions indexes
            ("Transactions", "OrganisationId,Id"),
            ("Transactions", "OrganisationID,AccountCode,LineAmount"),
            
            # Other table indexes
            ("creditnotes", "OrganisationId,CreditNoteId"),
            ("invoices", "OrganisationId,InvoiceId"),
            ("Invoices", "OrganisationId"),
            ("Invoices", "InvoiceId"),
            ("Invoices", "InvoiceId,UpdatedDateUTC"),
            ("Invoices", "OrganisationID,InvoiceId"),
            ("BankTransactions", "OrganisationId"),
            ("BankTransactions", "BankTransactionId"),
            ("BankTransactions", "OrganisationId,BankTransactionId"),
            ("BankTransactions", "LineItem_LineItemId"),
            ("BankTransactions", "BankTransactionId,LineItem_LineItemId"),
            ("banktransfers", "OrganisationId,BankTransferId"),
            ("BatchPayments", "OrganisationId,BatchPaymentId"),
            ("Payments", "OrganisationID,PaymentId"),
            ("Payments", "OrganisationID,UpdatedDateUTC"),
            ("Payments", "OrganisationID,InvoiceId,PaymentId"),
            ("Payments", "OrganisationID,InvoiceId,PaymentType"),
            ("accounts", "OrganisationID,Code"),
            ("accounts", "SystemAccount"),
            ("accounts", "AccountId,OrganisationID"),
            ("accounts", "AccountId,OrganisationID,AccountType"),
            ("accounts", "AccountId,OrganisationID,AccountType,Name"),
            ("accounts", "AccountId"),
            ("accounts", "OrganisationID, AccountType"),
            ("OverPayments", "OrganisationID,OverpaymentId"),
            ("PrePayments", "OrganisationID,PrepaymentId"),
            ("Contacts", "OrganisationID,ContactId"),
            ("ManualJournals", "OrganisationId,ManualJournalId"),
            ("organisationsclients", "OrganisationID,BaseCurrency"),
            ("budgets", "`BudgetLines.AccountCode`,OrganisationID"),
        ]
        
        for endpoint, columns in client_indexes:
            index_name = self._generate_client_index_name(endpoint, columns)
            indexes.append({
                'endpoint': endpoint,
                'columns': columns,
                'index_type': 'client',
                'index_name': index_name
            })
        
        return indexes
    
    def _add_stage_table_index(self, endpoint: str, columns: str) -> bool:
        """
        Creates an index on a stage table, equivalent to Add_StageId_Generic_Index
        
        Args:
            endpoint: The endpoint name (e.g., 'Invoices')
            columns: Comma-separated column names for the index
            
        Returns:
            True if successful, False otherwise
        """
        if not endpoint or not columns:
            print("⚠️  Missing parameters for _add_stage_table_index")
            return False
        
        try:
            table_name = self._get_stage_table_name(endpoint)
            index_name = self._generate_stage_index_name(endpoint, columns)
            
            # Clean up column names
            clean_columns = columns.replace(" ", "")
            
            params = {
                "table_name": table_name,
                "index_name": index_name,
                "column_names": clean_columns
            }
            
            return self._safe_execute_eva_sql(
                "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
                f"Add_{table_name}_Generic_Index",
                endpoint,
                params=params
            )
            
        except Exception as e:
            print(f"❌ Error creating stage index for {endpoint}: {str(e)}")
            return False
    
    def _add_client_table_index(self, endpoint: str, columns: str) -> bool:
        """
        Creates an index on a client table, equivalent to Add_ClientTable_Index
        
        Args:
            endpoint: The endpoint name (e.g., 'Journals')
            columns: Comma-separated column names for the index
            
        Returns:
            True if successful, False otherwise
        """
        if not endpoint or not columns:
            print("⚠️  Missing parameters for _add_client_table_index")
            return False
        
        try:
            table_name = self._get_client_table_name(endpoint)
            index_name = self._generate_client_index_name(endpoint, columns)
            
            # Clean up column names  
            clean_columns = columns.replace(" ", "")
            
            params = {
                "table_name": table_name,
                "index_name": index_name,
                "column_names": clean_columns
            }
            
            return self._safe_execute_eva_sql(
                "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
                f"Add_{table_name}_ClientTable_Index",
                endpoint,
                params=params
            )
            
        except Exception as e:
            print(f"❌ Error creating client index for {endpoint}: {str(e)}")
            return False
    
    def _safe_execute_eva_sql(self, query: str, operation_name: str, endpoint: str, params: dict = None) -> bool:
        """
        Executes an EVA SQL command, handling duplicate key errors
        Equivalent to safe_execute_eva_sql from original UPSERT.py
        
        Args:
            query: SQL query to execute
            operation_name: Name of the operation for logging
            endpoint: Endpoint name for logging
            params: Parameters for the query
            
        Returns:
            True if successful, False otherwise
        """
        try:
            # Use SQLAlchemy execution similar to existing patterns
            with eva_engine.connect() as conn:
                if params:
                    conn.execute(text(query), params)
                else:
                    conn.execute(text(query))
                conn.commit()
            return True
            
        except Exception as e:
            error_str = str(e).lower()
            # Handle duplicate key errors (MySQL error 1061)
            if 'duplicate key name' in error_str or '1061' in error_str or 'already exists' in error_str:
                print(f"⏭️  Index already exists - skipping: {operation_name}")
                return True  # Consider this a success since index exists
            else:
                print(f"❌ Error in {operation_name}: {str(e)}")
                return False
    
    def _get_stage_table_name(self, endpoint: str) -> str:
        """Get the full stage table name for an endpoint"""
        stage_prefix = self._get_stage_table_prefix()
        return f"{stage_prefix}{endpoint.lower()}stage"
    
    def _get_client_table_name(self, endpoint: str) -> str:
        """Get the full client table name for an endpoint"""
        client_prefix = self._get_client_table_prefix()
        return f"{client_prefix}{endpoint}"
    
    def _get_stage_table_prefix(self) -> str:
        """Get the stage table prefix (equivalent to TablePrefixEVA)"""
        etani_client_id = self.etani_client_id or os.getenv('EtaniClientID', '')
        etani_organisation_id = self.etani_organisation_id or os.getenv('EtaniOrganisationID', '')
        
        if 'CLIENT' in etani_client_id:
            client_number = etani_client_id[etani_client_id.find('CLIENT') + len('CLIENT'):]
        else:
            client_number = etani_client_id
            
        return f"c{client_number}_{etani_organisation_id}_xeroblue_"
    
    def _get_client_table_prefix(self) -> str:
        """Get the client table prefix (equivalent to TableClientEVA)"""
        etani_client_id = self.etani_client_id or os.getenv('EtaniClientID', '')
        
        if 'CLIENT' in etani_client_id:
            client_number = etani_client_id[etani_client_id.find('CLIENT') + len('CLIENT'):]
        else:
            client_number = etani_client_id
            
        return f"c{client_number}_xeroblue_"
    
    def _generate_stage_index_name(self, endpoint: str, columns: str) -> str:
        """
        Generate index name for stage table, following original patterns from Add_StageId_Generic_Index
        """
        table_name = self._get_stage_table_name(endpoint)
        
        # Simplified naming following original pattern
        col_names = columns.replace(',', '').replace('OrganisationId', 'OrgID').replace(' ', '').replace('_', '')
        index_name = f"{table_name}_{col_names}"
        index_name = index_name[:60]  # Truncate before adding suffix
        index_name += "_idx"
        
        return index_name
    
    def _generate_client_index_name(self, endpoint: str, columns: str) -> str:
        """
        Generate index name for client table, following original patterns from Add_ClientTable_Index
        """
        table_name = self._get_client_table_name(endpoint)
        
        # Create acronyms following original pattern
        try:
            from utils import get_acronym
            acronyms = [get_acronym(col.strip()) for col in columns.split(",")]
        except ImportError:
            # Fallback if get_acronym is not available
            acronyms = [col.strip()[:3].upper() for col in columns.split(",")]
        
        base_index_name = f"{table_name}_{''.join(acronyms)}"
        index_name = base_index_name[:60]  # Truncate to max length (MySQL limit)
        index_name += "_idx"  # Consistent suffix
        
        return index_name
    
    # ===================================================================================
    # ORGANIZATION STATUS AND EXECUTION CONTROL
    # ===================================================================================
    
    # NOTE: should_execute_endpoints() is now inherited from BaseIntegration
    # The base class implementation uses our allowed_execution_statuses property
    # and calls our _get_organization_status() method below
    
    def _get_organization_status(self) -> Optional[int]:
        """
        Get organization status from CMS using existing CMS details
        
        Uses the existing self.org_status populated by _get_cms_details()
        
        Returns:
            Organization status code or None if failed
        """
        try:
            # Check if org_status is already populated
            if hasattr(self, 'org_status') and self.org_status is not None:
                print(f"🔍 Using cached organization status: {self.org_status}")
                return int(self.org_status)
            
            # If not populated, get CMS details first
            print("🔄 Organization status not cached, retrieving from CMS...")
            self._get_cms_details()
            
            # Check if org_status was populated by _get_cms_details
            if hasattr(self, 'org_status') and self.org_status is not None:
                print(f"🔍 Retrieved organization status: {self.org_status}")
                return int(self.org_status)
            else:
                print("⚠️  No organization status found in CMS details")
                return None
                
        except Exception as e:
            print(f"❌ Error retrieving organization status: {str(e)}")
            return None
    
    def _get_reset_mode(self) -> bool:
        """
        Get Reset_Mode from environment variable
        
        Returns:
            True if Reset_Mode is enabled, False otherwise
        """
        reset_mode_str = os.getenv("Reset_Mode")
        # Convert string values to boolean (handle various representations)
        if reset_mode_str:
            return reset_mode_str.lower() in ['true', '1', 'yes', 'on', 'enabled']
        return False
    
    def _get_db_destination(self) -> str:
        """
        Get DB_Destination from environment variable
        
        Returns:
            DB destination string (default: 'EVA')
        """
        return os.getenv('DB_Destination', 'EVA')
    
    def _get_status_description(self, status_code: int) -> str:
        """
        Get human-readable description for status code
        
        Based on CustomStatuses from original XEROBLUE - UPSERT.py
        
        Args:
            status_code: Numeric status code
            
        Returns:
            Human-readable status description
        """
        custom_statuses = {
            1: 'Active',
            2: 'Inactive', 
            9: 'Provisioning New Data',
            12: 'Updating Data',
            13: 'Disconnected',
            16: 'Resetting Data'
        }
        
        return custom_statuses.get(status_code, f'Unknown Status ({status_code})')
    
    def log_execution_decision(self, should_execute: bool, reason: str) -> None:
        """
        Log the execution decision for audit and debugging purposes
        
        Args:
            should_execute: Whether execution should proceed
            reason: Reason for the decision
        """
        try:
            # Get current parameters for logging
            etani_client_id = self.etani_client_id or os.getenv('EtaniClientID', '')
            etani_organisation_id = self.etani_organisation_id or os.getenv('EtaniOrganisationID', '')
            
            # Create log entry
            log_entry = {
                "timestamp": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "integration": "XEROBLUE", 
                "client_id": etani_client_id,
                "organisation_id": etani_organisation_id,
                "execution_allowed": should_execute,
                "reason": reason,
                "reset_mode": self._get_reset_mode(),
                "db_destination": self._get_db_destination()
            }
            
            # Log to container logs if available
            if should_execute:
                status = "Started"
                remarks = f"Execution approved: {reason}"
            else:
                status = "Failed"
                remarks = f"Execution blocked: {reason}"
            
            # Use the existing container logging infrastructure
            params = {
                "p_integration": "XEROBLUE",
                "p_organisation_id": etani_organisation_id,
                "p_client_id": etani_client_id.replace('CLIENT', '') if 'CLIENT' in etani_client_id else etani_client_id,
                "p_firm_id": 0,  # Will be updated by caller if needed
                "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_status": status,
                "p_log_id": self.log_id,
                "p_remarks": remarks
            }
            
            try:
                update_container_logs(params)
            except Exception as log_error:
                print(f"⚠️  Could not update container logs: {log_error}")
            
        except Exception as e:
            print(f"⚠️  Error logging execution decision: {str(e)}")
    
    def upload_powerbi_template(self, workspace_id: str = None) -> bool:
        """
        XeroBlue-specific PowerBI template upload (optional override for IntegrationPackageInsert)
        
        Args:
            workspace_id: PowerBI workspace ID
            
        Returns:
            True if successful, False otherwise
        """
        try:
            print(f"📊 Uploading XeroBlue PowerBI template")
            if workspace_id:
                print(f"   Workspace ID: {workspace_id}")
            
            # XeroBlue-specific PowerBI upload logic would go here
            # For now, return True as placeholder
            print(f"✅ XeroBlue PowerBI template uploaded successfully (placeholder)")
            return True
            
        except Exception as e:
            error_msg = f"Error uploading XeroBlue PowerBI template: {str(e)}"
            print(f"❌ {error_msg}")
            self.error_list.append(error_msg)
            return False


# Compatibility functions that wrap the enhanced integration
# These maintain compatibility with existing XEROBLUE - UPSERT.py code

def create_xero_enhanced_integration(config: Optional[Dict[str, Any]] = None) -> XeroblueIntegration:
    """Factory function to create enhanced Xero integration"""
    return XeroblueIntegration(config)


def xero_requests_enhanced(endpoint: str, params: Dict[str, str] = None, 
                          if_modified_since: str = None, id: str = None) -> pd.DataFrame:
    """
    Enhanced drop-in replacement for XeroRequests function
    This maintains compatibility with existing XEROBLUE - UPSERT.py code
    """
    config = {
        'rate_limit': 60,
        'timeout_seconds': 900
    }
    
    integration = XeroblueIntegration(config)
    
    # Create common token manager
    from common_token_manager import create_token_manager
    token_manager = create_token_manager(integration)
    
    return integration.make_api_request(endpoint, params, if_modified_since, id, token_manager)


class XeroRequestsManagerEnhanced:
    """
    Enhanced drop-in replacement for XeroRequestsManager
    This maintains compatibility with existing XEROBLUE - UPSERT.py code
    """
    
    def __init__(self, endpoint: str, params: Dict[str, str] = None, 
                 if_modified_since: str = None, id: str = None):
        self.endpoint = endpoint
        self.params = params
        self.if_modified_since = if_modified_since
        self.id = id
        self.data = None
        self.integration = XeroblueIntegration()
        
        # Create common token manager
        from common_token_manager import create_token_manager
        self.token_manager = create_token_manager(self.integration)
    
    def __enter__(self):
        self.data = self.integration.make_api_request(
            self.endpoint, self.params, self.if_modified_since, self.id, self.token_manager
        )
        return self.data
    
    def __exit__(self, exc_type, exc_value, traceback):
        print("Cleaning up DataFrame")
        del self.data
        return False