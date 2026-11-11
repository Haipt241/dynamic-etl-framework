"""
Authentication Manager for Dynamic Integrations

Handles all authentication methods including:
- OAuth2 (with refresh token support)
- API Key authentication  
- Basic authentication
- Bearer token authentication
"""

import os
import sys
import json
import logging
import time
import hmac
import hashlib
import base64
import threading
from urllib.parse import urlencode
from typing import Dict, Any, Tuple, Optional
import requests
from azure.storage.fileshare import ShareFileClient

from dynamic_integrations.auth.token_manager import TokenManager

# Add parent directories to path to enable imports from root

# Add AWS S3 support
import boto3
from botocore.exceptions import ClientError, NoCredentialsError

# Import S3Uploader from scripts/s3_upload_tool.py
from dynamic_integrations.storage.s3_upload_tool import S3Uploader

# Import the new TokenManager class


class AuthManager:
    """
    Authentication Manager class

    Centralized authentication handling for all integration types.
    Supports multiple auth methods and token management.
    """

    def __init__(self, integration_instance, config: Dict[str, Any]):
        """
        Initialize authentication manager

        Args:
            integration_instance: The integration instance that owns this auth manager
            config: Configuration dictionary containing auth settings
        """
        self.integration = integration_instance
        self.config = config
        self.access_token = None
        self.token_expires_at = None
        self.token_last_refresh = None
        self.token_manager_cache = None  # Cache CommonTokenManager instance
        self.logger = logging.getLogger(f"AuthManager.{config.get('integration_name', 'Unknown')}")

        # ========================================
        # NEW: Use dedicated TokenManager for OAuth2 token handling
        # ========================================
        self.token_manager = None  # Will be created when needed for OAuth2

    def get_auth_headers(self, access_token: str = None) -> Dict[str, str]:
        """Generate authentication headers based on auth type"""
        auth_type = self.config.get('auth_type', 'api_key')
        auth_config = self.config.get('auth_config', {})

        headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'User-Agent': f'{self.config.get("integration_name", "Unknown")}-Integration/1.0'
        }

        # Dispatch to appropriate auth handler
        try:
            if auth_type == 'oauth2':
                self._apply_oauth2_auth(headers, access_token)
            elif auth_type == 'api_key':
                self._apply_api_key_auth(headers, auth_config)
            elif auth_type == 'basic_auth':
                self._apply_basic_auth(headers, auth_config)
            elif auth_type == 'bearer_token':
                self._apply_bearer_token_auth(headers, auth_config)
            elif auth_type == 'dual_key':
                self._apply_dual_key_auth(headers, auth_config)
            elif auth_type == 'header_token':
                self._apply_header_token_auth(headers, auth_config)
            elif auth_type == 'dual_header_auth':
                self._apply_dual_header_auth(headers, auth_config)
            elif auth_type == 'custom_request':
                self._apply_custom_request_auth(headers, auth_config)
            elif auth_type == 'wfm_oauth2':
                headers = {}  # WFM specific: clear headers first
                self._apply_oauth2_auth(headers, access_token)
            elif auth_type == 'myob_oauth2':
                self._apply_myob_oauth2_auth(headers, access_token)
            elif auth_type == 'xero_oauth2':
                self._apply_xero_oauth2_auth(headers, access_token)
            elif auth_type == 'unleashed_hmac_signature':
                self._apply_unleashed_hmac_signature_auth(headers, auth_config)
            elif auth_type == 'oauth2_custom_prefix':
                self._apply_oauth2_custom_prefix_auth(headers, auth_config)
            elif auth_type == 'api_key_param' or auth_type == 'oauth2_password_grant':
                return headers
            else:
                self.logger.warning(f"Unsupported auth type: {auth_type}")
                # Add custom headers for unsupported auth types
                custom_headers = auth_config.get('custom_headers', {})
                headers.update(custom_headers)
        except Exception as e:
            error_msg = str(e).lower()

            # Token errors should propagate to integration layer for status 13 handling
            token_error_keywords = ['invalid_grant', 'unauthorized', 'token expired', 'invalid_client', 'token refresh']
            if any(keyword in error_msg for keyword in token_error_keywords):
                self.logger.error(f"Token error detected: {e}")
                raise  # Re-raise to trigger status 13 logic

            # For OAuth2 auth types, ANY exception is critical (don't continue without auth)
            oauth_auth_types = ['oauth2', 'xero_oauth2', 'myob_oauth2', 'wfm_oauth2', 'oauth2_custom_prefix', 'oauth2_password_grant']
            if auth_type in oauth_auth_types:
                self.logger.error(f"CRITICAL: OAuth2 authentication failed for {auth_type}: {e}")
                raise Exception(f"Authentication failed: {e}")  # Raise to stop processing

            # Other auth types log but continue
            self.logger.error(f"Authentication failed for {auth_type}: {e}")

        return headers

    def _is_token_valid(self) -> bool:
        """Check if the cached token is still valid"""
        if not self.access_token:
            return False

        # If we have an expiration time, check if it's still valid (with 5 minute buffer)
        if self.token_expires_at:
            current_time = time.time()
            return current_time < (self.token_expires_at - 300)  # 5 minutes buffer

        # If no expiration time but we have a token, check how long ago it was refreshed
        if self.token_last_refresh:
            current_time = time.time()
            # Default token lifetime: 1 hour, refresh if older than 50 minutes
            return (current_time - self.token_last_refresh) < 3000  # 50 minutes

        # If we have a token but no timing info, consider it invalid to be safe
        return False

    # ========================================
    # OAuth2 Authentication Methods
    # ========================================

    def _apply_oauth2_auth(self, headers: Dict[str, str], access_token: str = None):
        """Apply OAuth2 authentication using new TokenManager with 30-minute caching"""

        # ========================================
        # NEW: Use dedicated TokenManager for OAuth2 token handling
        # ========================================

        # Create TokenManager instance if not exists
        if not self.token_manager:
            self.token_manager = TokenManager(self.integration, self.config)
            self.logger.debug("Created TokenManager instance")

        # Get valid token (with 30-minute caching)
        access_token = self.token_manager.get_valid_token()

        # CRITICAL: If no token available, raise exception to trigger status 13 handling
        if not access_token:
            error_msg = "Authentication failed: No OAuth2 access token available"
            self.logger.error(f"[ERROR] {error_msg}")
            raise Exception(error_msg)

        # Apply authentication headers
        headers['Authorization'] = f'Bearer {access_token}'

        # WFM OAuth2 specific: Add account-id header if available
        if self.config.get('auth_type') == 'wfm_oauth2':
            env_vars_config = self.config.get('env_vars_config', {})
            for key, value in env_vars_config.items():
                if 'wfm2_tenant_id' in key.lower():
                    wfm2_tenant_id = value.get('default_value')
                    if wfm2_tenant_id:
                        headers['account-id'] = wfm2_tenant_id
                    break

        # Update legacy cache variables for backward compatibility
        self.access_token = access_token
        self.token_last_refresh = time.time()

        self.logger.info("[OK] OAuth2 authentication applied successfully with TokenManager")

    def _apply_myob_oauth2_auth(self, headers: Dict[str, str], access_token: str = None):
        """Apply MYOB OAuth2 authentication with special headers"""
        # First apply standard OAuth2 authentication
        self._apply_oauth2_auth(headers, access_token)

        # Then add MYOB-specific headers
        env_vars_config = self.config.get('env_vars_config', {})

        # Add x-myobapi-key header
        for key, value in env_vars_config.items():
            if 'myob_api_key' in key.lower():
                myob_api_key = value.get('default_value')
                if myob_api_key:
                    headers['x-myobapi-key'] = myob_api_key
                    self.logger.debug(f"Added x-myobapi-key header: {myob_api_key[:5]}...")
                break

        # Add x-myobapi-version header
        for key, value in env_vars_config.items():
            if 'myob_api_version' in key.lower():
                myob_api_version = value.get('default_value')
                if myob_api_version:
                    headers['x-myobapi-version'] = myob_api_version
                    self.logger.debug(f"Added x-myobapi-version header: {myob_api_version}")
                break

        # Add x-myobapi-cftoken header if available
        for key, value in env_vars_config.items():
            if 'myob_cf_token' in key.lower():
                myob_cf_token = value.get('default_value')
                if myob_cf_token:
                    headers['x-myobapi-cftoken'] = myob_cf_token
                    self.logger.debug(f"Added x-myobapi-cftoken header")
                break

        self.logger.info("MYOB OAuth2 authentication applied successfully")

    def _apply_xero_oauth2_auth(self, headers: Dict[str, str], access_token: str = None):
        """Apply Xero OAuth2 authentication with Xero-specific headers"""
        # First apply standard OAuth2 authentication
        self._apply_oauth2_auth(headers, access_token)

        # Then add Xero-specific headers
        env_vars_config = self.config.get('env_vars_config', {})

        # Add Xero-tenant-id header
        for key, value in env_vars_config.items():
            if 'xero_tenant_id' in key.lower():
                xero_tenant_id = value.get('default_value')
                if xero_tenant_id:
                    headers['Xero-tenant-id'] = xero_tenant_id
                    self.logger.debug(f"Added Xero-tenant-id header: {xero_tenant_id}")
                break

        self.logger.info("Xero OAuth2 authentication applied successfully")

    def _apply_oauth2_custom_prefix_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply OAuth2 authentication with configurable authorization prefix (e.g., 'OAuth', 'Bearer', 'Token')"""

        # Get integration name for dynamic token lookup
        integration_name = self.config.get('integration_name', '').lower()

        # Get token from config using pattern: {integration}_access_token
        env_vars_config = self.config.get('env_vars_config', {})
        token_key = f'{integration_name}_access_token'

        token = None
        if token_key in env_vars_config:
            token = env_vars_config[token_key].get('default_value')

        # If no token found using standard pattern, try api_key_env_var from auth_config
        if not token and auth_config:
            api_key_env_var = auth_config.get('api_key_env_var')
            if api_key_env_var:
                token = os.getenv(api_key_env_var)

        if token:
            # Get configurable authorization prefix from auth_config (default to 'Bearer')
            auth_prefix = auth_config.get('authorization_prefix', 'Bearer') if auth_config else 'Bearer'
            headers['Authorization'] = f'{auth_prefix} {token}'

            self.logger.info(f"OAuth2 custom prefix authentication applied with '{auth_prefix}' prefix")
        else:
            self.logger.error(f"No access token available for oauth2_custom_prefix authentication - tried {token_key} in env_vars_config")


    def _apply_api_key_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply API key authentication"""
        api_key = os.getenv(auth_config.get('api_key_env_var'))
        if api_key:
            key_name = auth_config.get('key_name', 'X-API-Key')
            headers[key_name] = api_key

    def _apply_basic_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply Basic authentication"""
        import base64

        username = None
        password = ""

        # Check if api_key_env_var is specified (for token-based basic auth)
        api_key_env_var = auth_config.get('api_key_env_var')
        if api_key_env_var:
            # Find the token in env_vars_config that matches api_key_env_var
            env_vars_config = self.config.get('env_vars_config', {})
            for field_name, field_config in env_vars_config.items():
                if field_config.get('env_var') == api_key_env_var:
                    username = field_config.get('default_value')
                    break
        else:
            # Original logic for username:password based basic auth
            env_vars_config = self.config.get('env_vars_config', {})
            username = env_vars_config.get('api_username', {}).get('default_value')
            password = env_vars_config.get('api_key', {}).get('default_value') or ""

        # Create credentials if username found
        if username:
            credentials = base64.b64encode(f"{username}:{password}".encode()).decode()
            headers['Authorization'] = f'Basic {credentials}'

    def _apply_bearer_token_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply Bearer token authentication"""
        # Get integration name for dynamic token lookup
        integration_name = self.config.get('integration_name', '').lower()

        # Get token from config using pattern: {integration}_token
        env_vars_config = self.config.get('env_vars_config', {})
        token_key = f'{integration_name}_token'

        if token_key in env_vars_config:
            token = env_vars_config[token_key].get('default_value')
            if token:
                headers['Authorization'] = f'Bearer {token}'

    def _apply_dual_key_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply dual key authentication (AccessKey + Bearer token)"""
        # Get keys from integration instance attributes (set from env_vars_config)
        access_key = getattr(self.integration, 'karbon_access_key', None)
        tenant_access_key = getattr(self.integration, 'karbon_tenant_access_key', None)

        # Fallback to environment variables if not found in instance
        if not access_key:
            access_key_env = auth_config.get('access_key_env_var', 'KARBON_ACCESS_KEY')
            access_key = os.getenv(access_key_env)

        if not tenant_access_key:
            tenant_access_key_env = auth_config.get('tenant_access_key_env_var', 'KARBON_TENANT_ACCESS_KEY')
            tenant_access_key = os.getenv(tenant_access_key_env)

        # Apply dual key headers (corrected mapping per Karbon API docs)
        if access_key and tenant_access_key:
            headers['Authorization'] = f'Bearer {access_key}'        # access_key goes to Authorization Bearer
            headers['AccessKey'] = tenant_access_key                # tenant_access_key goes to AccessKey header
            self.logger.info(f"Applied dual key authentication headers (AccessKey: {tenant_access_key[:20]}..., Authorization Bearer: {access_key[:8]}...)")
        else:
            self.logger.error(f"Missing dual key credentials - access_key: {bool(access_key)}, tenant_access_key: {bool(tenant_access_key)}")
            self.logger.error(f"Checked integration attrs: karbon_access_key={hasattr(self.integration, 'karbon_access_key')}, karbon_tenant_access_key={hasattr(self.integration, 'karbon_tenant_access_key')}")
            self.logger.error(f"Checked env vars: {auth_config.get('access_key_env_var', 'KARBON_ACCESS_KEY')}={bool(os.getenv(auth_config.get('access_key_env_var', 'KARBON_ACCESS_KEY')))}, {auth_config.get('tenant_access_key_env_var', 'KARBON_TENANT_ACCESS_KEY')}={bool(os.getenv(auth_config.get('tenant_access_key_env_var', 'KARBON_TENANT_ACCESS_KEY')))}")

    def _apply_header_token_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply header token authentication with configurable header name"""
        # Get token from integration instance attribute or environment
        token = None

        # Try to get token from various sources
        access_token_env_var = auth_config.get('access_token_env_var')
        if access_token_env_var:
            token = os.getenv(access_token_env_var)

        # For Shopify, try shopify_access_token attribute
        if not token and hasattr(self.integration, 'shopify_access_token'):
            token = self.integration.shopify_access_token

        if token:
            # Use configurable header name (default to X-Shopify-Access-Token for backward compatibility)
            header_name = auth_config.get('header_name', 'X-Shopify-Access-Token')
            headers[header_name] = token
            self.logger.debug(f"Applied header token authentication ({header_name}: {token[:20]}...)")
        else:
            self.logger.error(f"Missing access token - check {access_token_env_var} env var or integration attribute")

    def _apply_dual_header_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """Apply dual header authentication for APIs like CIN7 Dear with multiple custom headers"""
        # Get custom headers from auth_config
        custom_headers = auth_config.get('custom_headers', {})

        # Add Content-Type if not present
        if 'Content-Type' not in headers:
            headers['Content-Type'] = 'application/json'

        # Apply each custom header with environment variable lookup
        for header_name, header_config in custom_headers.items():
            # Handle both simple string format and complex object format
            if isinstance(header_config, str):
                # Simple format: "api-auth-accountid": "dear_account_id" (config key)
                config_key = header_config
            elif isinstance(header_config, dict):
                # Complex format: "api-auth-accountid": {"env_var": "DEAR_ACCOUNT_ID", "description": "..."}
                # For complex format, we need to find config key by env_var
                env_var_name = header_config.get('env_var')
                config_key = None
                env_vars_config = self.config.get('env_vars_config', {})
                for key, config_data in env_vars_config.items():
                    if config_data.get('env_var') == env_var_name:
                        config_key = key
                        break
            else:
                self.logger.error(f"Invalid header config format for {header_name}: {header_config}")
                continue

            if not config_key:
                self.logger.error(f"Missing config key for header {header_name}")
                continue

            # Get value from env_vars_config (exact same logic as custom_request)
            env_vars_config = self.config.get('env_vars_config', {})
            if config_key in env_vars_config:
                header_value = env_vars_config[config_key]['default_value']
                headers[header_name] = header_value
                self.logger.debug(f"Applied dual header auth: {header_name} = {header_value[:20] if header_value else 'None'}...")

    def _apply_custom_request_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """
        Apply custom request authentication for APIs like FYI that use:
        1. Custom headers for authentication
        2. POST requests with JSON payload structure
        3. Special request body format

        This handles cases where API requires both custom headers AND specific request body structure
        """
        try:
            # Apply custom authentication headers
            custom_headers = auth_config.get('custom_headers', {})

            # Map header values from env_vars_config
            env_vars_config = self.config.get('env_vars_config', {})

            for header_name, config_key in custom_headers.items():
                if config_key in env_vars_config:
                    header_value = env_vars_config[config_key]['default_value']
                    headers[header_name] = header_value

            # Store request body configuration for later use by data extraction
            request_body_config = auth_config.get('request_body', {})
            if request_body_config:
                # Store in headers for retrieval by data extraction layer
                # This is a temporary solution - ideally should be handled by request builder
                headers['X-Custom-Request-Body'] = json.dumps(request_body_config)
                self.logger.debug("Stored custom request body configuration")

            self.logger.debug(f"Applied custom_request authentication with {len(custom_headers)} headers")

        except Exception as e:
            self.logger.error(f"Failed to apply custom_request authentication: {e}")

    def _apply_unleashed_hmac_signature_auth(self, headers: Dict[str, str], auth_config: Dict[str, Any]):
        """
        Apply Unleashed HMAC signature authentication

        Creates HMAC-SHA256 signature from query parameters using API private key
        Requires: api_id, api_private_key, client_identifier
        """
        try:
            # Get credentials from env_vars_config
            env_vars_config = self.config.get('env_vars_config', {})
            credentials_mapping = auth_config.get('credentials_mapping', {})

            # Map credentials from config
            api_id = None
            api_private_key = None
            client_identifier = None

            for config_key, env_var in credentials_mapping.items():
                if config_key == 'api_id' and 'unleashed_api_id' in env_vars_config:
                    api_id = env_vars_config['unleashed_api_id']['default_value']
                elif config_key == 'api_private_key' and 'unleashed_api_private_key' in env_vars_config:
                    api_private_key = env_vars_config['unleashed_api_private_key']['default_value']
                elif config_key == 'client_identifier' and 'unleashed_client_type' in env_vars_config:
                    client_identifier = env_vars_config['unleashed_client_type']['default_value']

            # Validate required credentials
            if not api_id:
                self.logger.error("Missing Unleashed API ID - check unleashed_api_id in env_vars_config")
                return

            if not api_private_key:
                self.logger.error("Missing Unleashed API private key - check unleashed_api_private_key in env_vars_config")
                return

            if not client_identifier:
                self.logger.error("Missing Unleashed client type - check unleashed_client_type in env_vars_config")
                return

            # Apply required headers from auth_config
            required_headers = auth_config.get('required_headers', {})
            for header_name, header_template in required_headers.items():
                if header_template == '{api_id}':
                    headers[header_name] = api_id
                elif header_template == '{client_identifier}':
                    headers[header_name] = client_identifier
                elif header_template == '{hmac_signature}':
                    # Signature will be generated later when we have query parameters
                    # For now, we'll store a placeholder
                    headers[header_name] = 'SIGNATURE_PLACEHOLDER'
                else:
                    # Static header value
                    headers[header_name] = header_template

            # Store signature generation info for later use by the request handler
            headers['X-Unleashed-Signature-Key'] = api_private_key
            headers['X-Unleashed-Signature-Method'] = 'HMAC-SHA256'

        except Exception as e:
            self.logger.error(f"Failed to apply Unleashed HMAC signature authentication: {e}")

    def generate_unleashed_signature(self, query_params: Dict[str, Any], api_private_key: str) -> str:
        """
        Generate HMAC-SHA256 signature for Unleashed API from query parameters

        Args:
            query_params: Dictionary of query parameters
            api_private_key: API private key for HMAC generation

        Returns:
            Base64 encoded HMAC-SHA256 signature
        """
        try:
            # Convert query parameters to query string (excluding empty values)
            filtered_params = {k: v for k, v in query_params.items() if v is not None and v != ""}

            if filtered_params:
                # Create query string in format: key1=value1&key2=value2
                query_string = urlencode(filtered_params, doseq=True)
            else:
                # Empty string for requests without parameters
                query_string = ""

            self.logger.debug(f"Generating signature for query string: {query_string}")

            # Generate HMAC-SHA256 signature
            signature = hmac.new(
                api_private_key.encode('utf-8'),
                query_string.encode('utf-8'),
                hashlib.sha256
            ).digest()

            # Encode to base64
            signature_base64 = base64.b64encode(signature).decode('utf-8')

            self.logger.debug(f"Generated signature: {signature_base64[:20]}...")
            return signature_base64

        except Exception as e:
            self.logger.error(f"Failed to generate Unleashed signature: {e}")
            return ""


    def _get_token_filename(self) -> str:
        """Get token filename """
        env_vars_config = self.config.get('env_vars_config', {})
        etani_client_id = None
        etani_organisation_id = None
        etani_link_organisation_id = None

        for key, value in env_vars_config.items():
            if 'etani_client_id' in key.lower():
                etani_client_id = value.get('default_value')
            elif 'etani_organisation_id' in key.lower():
                etani_organisation_id = value.get('default_value')
            elif 'etani_link_organisation_id' in key.lower():
                etani_link_organisation_id = value.get('default_value')

        if not etani_client_id or not etani_organisation_id:
            self.logger.error(f"Missing EtaniClientID ({etani_client_id}) or EtaniOrganisationID ({etani_organisation_id}) for token filename")
            self.logger.error(f"Available keys: {list(env_vars_config.keys())}")
            return "MISSING_CLIENT_ORG_INFO.txt"

        if etani_link_organisation_id and etani_link_organisation_id != "":
            etani_organisation_id = etani_link_organisation_id

        token_file_name = f'{etani_client_id}_{etani_organisation_id}.txt'
        return token_file_name

    def _supports_refresh_token(self) -> bool:
        """Check if this integration supports refresh token flow based on token_source config"""
        try:
            auth_config = self.config.get('auth_config', {})
            token_source = auth_config.get('token_source', '')

            # Check if this integration uses Azure refresh token flow
            if token_source == 'azure_refresh_token':
                if (hasattr(self.integration, 'etani_client_id') and hasattr(self.integration, 'etani_organisation_id') and
                    self.integration.etani_client_id and self.integration.etani_organisation_id):
                    return True

            # Other token sources (client_credentials, static_token, etc.) don't use refresh token flow
            return False
        except Exception:
            return False

    def get_fresh_token(self) -> str:
        """Get fresh access token using appropriate method based on auth type"""
        try:
            # Use cached token manager if available
            if not self.token_manager_cache:
                from dynamic_integrations.auth.common_token_manager import create_token_manager
                self.token_manager_cache = create_token_manager(
                    self.integration,
                    getattr(self.integration, 'etani_client_id', ''),
                    getattr(self.integration, 'etani_organisation_id', '')
                )
                self.logger.debug("Created and cached token manager instance")

            return self.token_manager_cache.get_valid_token()
        except Exception as e:
            self.logger.warning(f"CommonTokenManager not available: {e}")
            # Fallback to simple token retrieval
            return self._get_oauth2_token()

    def _get_static_oauth2_token(self) -> str:
        """Get OAuth2 token using client_credentials flow (no refresh token) - generic version"""
        auth_config = self.config.get('auth_config', {})
        token_url = auth_config.get('token_url')

        if not token_url:
            raise ValueError("Token URL not configured for OAuth2")

        # Get integration name for environment variable prefix
        integration_name = self.config.get('integration_name', '').upper()

        # Get client credentials directly from config default values
        client_id = None
        client_secret = None

        env_vars_config = self.config.get('env_vars_config', {})
        self.logger.debug(f"Available env_vars_config keys: {list(env_vars_config.keys())}")

        for key, value in env_vars_config.items():
            if 'client_id' in key.lower():
                client_id = value.get('default_value')
                self.logger.debug(f"Got client ID from config key '{key}': {client_id[:20] if client_id else 'None'}...")
            elif 'client_secret' in key.lower():
                client_secret = value.get('default_value')
                self.logger.debug(f"Got client secret from config key '{key}'")

        if not client_id or not client_secret:
            raise ValueError(f"Client ID or Secret not found in config for {integration_name} integration")

        # Make token request
        data = {
            'grant_type': 'client_credentials',
            'client_id': client_id,
            'client_secret': client_secret
        }

        # Add any additional parameters from config
        additional_params = auth_config.get('additional_params', {})
        data.update(additional_params)

        # Use custom headers if specified
        headers = {'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded'}
        custom_headers = auth_config.get('custom_headers', {})
        headers.update(custom_headers)

        self.logger.debug(f"Making OAuth2 token request to {token_url}")

        response = requests.post(token_url, data=data, headers=headers)
        response.raise_for_status()

        token_data = response.json()
        access_token = token_data.get('access_token', '')

        if access_token:
            # Cache token with expiration info
            expires_in = token_data.get('expires_in', 3600)
            self.token_expires_at = time.time() + expires_in
            self.logger.info(f"Retrieved static OAuth2 token (expires in {expires_in}s)")

        return access_token

    def _get_password_grant_oauth2_token(self) -> str:
        """Get OAuth2 token using password grant flow - for Accredo integration"""
        auth_config = self.config.get('auth_config', {})
        token_url = auth_config.get('token_url')

        if not token_url:
            raise ValueError("Token URL not configured for OAuth2")

        # Replace {domain} or {oauth_domain} placeholder in token_url
        env_vars_config = self.config.get('env_vars_config', {})

        # Look for oauth_domain first, then fallback to domain
        oauth_domain = None
        domain = None
        for key, value in env_vars_config.items():
            if 'oauth_domain' in key.lower():
                oauth_domain = value.get('default_value')
            elif 'domain' in key.lower() and not oauth_domain:
                domain = value.get('default_value')

        # Replace oauth_domain first, then domain
        if oauth_domain and '{oauth_domain}' in token_url:
            token_url = token_url.replace('{oauth_domain}', oauth_domain)
            self.logger.debug(f"Updated token URL with oauth_domain: {token_url}")
        elif domain and '{domain}' in token_url:
            token_url = token_url.replace('{domain}', domain)
            self.logger.debug(f"Updated token URL with domain: {token_url}")

        # Get credentials from env_vars_config
        client_id = None
        username = None
        password = None

        for key, value in env_vars_config.items():
            if 'client_id' in key.lower():
                client_id = value.get('default_value')
                self.logger.debug(f"Got client ID from config key '{key}': {client_id[:10] if client_id else 'None'}...")
            elif 'username' in key.lower():
                username = value.get('default_value')
                self.logger.debug(f"Got username from config key '{key}': {username}")
            elif 'password' in key.lower():
                password = value.get('default_value')
                self.logger.debug(f"Got password from config key '{key}': {'*' * len(password) if password else 'None'}")

        if not client_id or not username or not password:
            missing_fields = []
            if not client_id: missing_fields.append('client_id')
            if not username: missing_fields.append('username')
            if not password: missing_fields.append('password')
            raise ValueError(f"Missing OAuth2 password grant credentials: {missing_fields}")

        # Make token request
        data = {
            'grant_type': 'password',
            'client_id': client_id,
            'username': username,
            'password': password
        }

        # Add any additional parameters from config
        additional_params = auth_config.get('additional_params', {})
        data.update(additional_params)

        # Use custom headers if specified
        headers = {'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded'}
        custom_headers = auth_config.get('custom_headers', {})
        headers.update(custom_headers)

        self.logger.debug(f"Making OAuth2 password grant token request to {token_url}")

        try:
            # Disable SSL verification if configured
            ssl_verify = auth_config.get('ssl_verify', True)
            response = requests.post(token_url, data=data, headers=headers, verify=ssl_verify, timeout=30)
            response.raise_for_status()

            token_data = response.json()
            access_token = token_data.get('access_token', '')

            if access_token:
                expires_in = token_data.get('expires_in', 3600)
                refresh_token = token_data.get('refresh_token', '')

                # Cache + S3 save via TokenManager
                if not self.token_manager:
                    self.token_manager = TokenManager(self.integration, self.config)

                token_filename = self.token_manager._get_token_filename()

                # Cache for 30 minutes
                self.token_manager._cache_tokens(
                    access_token=access_token,
                    refresh_token=refresh_token,
                    token_filename=token_filename,
                    expires_in=1800
                )

                # Save complete token data to S3
                try:
                    complete_token_data = {
                        'access_token': access_token,
                        'refresh_token': refresh_token,
                        'expires_in': expires_in,
                        'token_type': 'Bearer'
                    }
                    import json
                    json_data = json.dumps(complete_token_data).encode('utf-8')
                    self.token_manager._save_token_to_aws_s3_with_retry(token_filename, json_data)
                    self.logger.info("[OK] Password grant token cached and saved to S3")
                except Exception as save_error:
                    self.logger.warning(f"Failed to save password grant token to S3: {save_error}")

                # Update instance variables for backward compatibility
                self.token_expires_at = time.time() + expires_in
                self.token_last_refresh = time.time()
                self.access_token = access_token

                self.logger.info(f"[OK] OAuth2 password grant complete (expires in {expires_in}s, refresh_token: {bool(refresh_token)})")

            return access_token

        except requests.exceptions.HTTPError as e:
            self.logger.error(f"OAuth2 token request failed: {e}")
            if hasattr(e.response, 'text'):
                self.logger.error(f"Response: {e.response.text}")
            raise
        except requests.exceptions.RequestException as e:
            self.logger.error(f"OAuth2 token request error: {e}")
            raise

    def _get_oauth2_token(self) -> str:
        """Get OAuth2 access token - generic version for any integration"""
        try:
            # Get integration name for environment variable prefix
            integration_name = self.config.get('integration_name', '').upper()

            # Try integration-specific environment variable first
            token_env_var = f'{integration_name}_ACCESS_TOKEN'
            token = os.getenv(token_env_var)
            if token:
                self.logger.debug(f"Found token in {token_env_var}")
                return token

            # Try to get token from integration config default_value
            env_vars_config = self.config.get('env_vars_config', {})
            for key, value in env_vars_config.items():
                if 'access_token' in key.lower():
                    config_token = value.get('default_value')
                    if config_token and config_token != "YOUR_TOKEN_HERE":
                        self.logger.debug(f"Found token in config default_value for {key}")
                        return config_token

            # Try integration-specific token file
            token_file_env_var = f'{integration_name}_TOKEN_FILE'
            token_file = os.getenv(token_file_env_var)
            if token_file and os.path.exists(token_file):
                with open(token_file, 'r') as f:
                    token_data = json.load(f)
                    return token_data.get('access_token', '')

            # For backward compatibility, try common token patterns for any integration
            if not integration_name:
                # If no integration name, try common environment variables
                common_token_vars = ['ACCESS_TOKEN', 'API_TOKEN', 'AUTH_TOKEN']
                for var in common_token_vars:
                    token = os.getenv(var)
                    if token:
                        self.logger.debug(f"Found token in {var}")
                        return token

                # Try common token file patterns
                common_token_files = ['token.json', 'access_token.json', 'auth_token.json']
                for token_file in common_token_files:
                    if os.path.exists(token_file):
                        with open(token_file, 'r') as f:
                            token_data = json.load(f)
                            access_token = token_data.get('access_token', '')
                            if access_token:
                                self.logger.debug(f"Found token in {token_file}")
                                return access_token


            # Generic warning message with integration-specific env var
            self.logger.warning(f"OAuth2 token not found - set {token_env_var} env var or {token_file_env_var}")
            return ""

        except Exception as e:
            self.logger.error(f"Error getting OAuth2 token: {str(e)}")
            return ""

    def refresh_token_request(self, refresh_token: str) -> Tuple[Dict[str, Any], str]:
        """
        Generic token refresh implementation for CommonTokenManager

        Args:
            refresh_token: Current refresh token

        Returns:
            Tuple: (token_data_dict, status) where status is "success" or "error"
        """
        try:
            auth_config = self.config.get('auth_config', {})
            auth_type = auth_config.get('type') or self.config.get('auth_type', 'oauth2')

            if auth_type != 'oauth2':
                return {"error": "Token refresh only supported for OAuth2"}, "error"

            # Get token URL
            token_url = auth_config.get('token_url')
            if not token_url:
                return {"error": "Token URL not configured"}, "error"

            # Get client credentials
            client_id_env_var = auth_config.get('client_id_env_var')
            client_secret_env_var = auth_config.get('client_secret_env_var')

            client_id = os.getenv(client_id_env_var)
            client_secret = os.getenv(client_secret_env_var)

            # Fallback to config file if env vars not set
            if not client_id or not client_secret:
                try:
                    import config
                    client_id = client_id or getattr(config, client_id_env_var.replace('_ENV_VAR', ''), None)
                    client_secret = client_secret or getattr(config, client_secret_env_var.replace('_ENV_VAR', ''), None)
                except ImportError:
                    pass

            if not client_id or not client_secret:
                return {"error": f"Client credentials not found in environment or config"}, "error"

            # Make refresh token request
            data = {
                'grant_type': 'refresh_token',
                'refresh_token': refresh_token,
                'client_id': client_id,
                'client_secret': client_secret
            }

            headers = {'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded'}

            response = requests.post(token_url, data=data, headers=headers, timeout=30)
            response.raise_for_status()

            token_data = response.json()

            # Return token data in expected format
            return {
                'access_token': token_data.get('access_token'),
                'refresh_token': token_data.get('refresh_token', refresh_token),
                'expires_in': token_data.get('expires_in', 3600),
                'token_type': token_data.get('token_type', 'Bearer')
            }, "success"

        except Exception as e:
            error_msg = f"Token refresh failed: {str(e)}"
            self.logger.error(error_msg)
            return {"error": error_msg}, "error"

    def validate_auth_config(self) -> bool:
        """Validate authentication configuration"""
        auth_type = self.config.get('auth_type')
        if not auth_type:
            self.logger.error("Auth type not specified")
            return False

        auth_config = self.config.get('auth_config', {})

        if auth_type == 'oauth2' or auth_type == 'myob_oauth2' or auth_type == 'xero_oauth2' or auth_type == 'oauth2_custom_prefix' or auth_type == 'oauth2_password_grant':
            return self._validate_oauth2_password_grant_config(auth_config) if auth_type == 'oauth2_password_grant' else self._validate_oauth2_config(auth_config)
        elif auth_type == 'api_key':
            return self._validate_api_key_config(auth_config)
        elif auth_type == 'api_key_param':
            return self._validate_api_key_param_config(auth_config)
        elif auth_type == 'basic_auth':
            return self._validate_basic_auth_config(auth_config)
        elif auth_type == 'bearer_token':
            return self._validate_bearer_token_config(auth_config)
        elif auth_type == 'dual_key':
            return self._validate_dual_key_config(auth_config)
        elif auth_type == 'unleashed_hmac_signature':
            return self._validate_unleashed_hmac_signature_config(auth_config)
        else:
            self.logger.error(f"Unsupported auth type: {auth_type}")
            return False

    def _validate_oauth2_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate OAuth2 configuration"""
        required_fields = ['client_id_env_var', 'client_secret_env_var']
        for field in required_fields:
            if field not in auth_config:
                self.logger.error(f"Missing OAuth2 config field: {field}")
                return False
        return True

    def _validate_oauth2_password_grant_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate OAuth2 password grant configuration"""
        # Check required fields for password grant flow
        required_fields = ['token_url', 'grant_type']
        for field in required_fields:
            if field not in auth_config:
                self.logger.error(f"Missing OAuth2 password grant config field: {field}")
                return False

        # Validate grant type
        if auth_config.get('grant_type') != 'password':
            self.logger.error("OAuth2 password grant requires grant_type = 'password'")
            return False

        # Check that required env vars are configured
        env_vars_config = self.config.get('env_vars_config', {})
        required_env_vars = []

        # Look for client_id, username, password in env_vars_config
        has_client_id = any('client_id' in key.lower() for key in env_vars_config.keys())
        has_username = any('username' in key.lower() for key in env_vars_config.keys())
        has_password = any('password' in key.lower() for key in env_vars_config.keys())

        if not has_client_id:
            required_env_vars.append('client_id')
        if not has_username:
            required_env_vars.append('username')
        if not has_password:
            required_env_vars.append('password')

        if required_env_vars:
            self.logger.error(f"Missing required env_vars_config for OAuth2 password grant: {required_env_vars}")
            return False

        return True

    def _validate_api_key_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate API key configuration"""
        if 'api_key_env_var' not in auth_config:
            self.logger.error("Missing API key environment variable configuration")
            return False
        return True

    def _validate_api_key_param_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate API key parameter configuration"""
        if 'api_key' not in auth_config:
            self.logger.error("Missing api_key configuration for api_key_param auth")
            return False

        api_key_config = auth_config.get('api_key', {})
        if 'env_var' not in api_key_config:
            self.logger.error("Missing env_var in api_key configuration for api_key_param auth")
            return False

        if 'param_name' not in api_key_config:
            self.logger.error("Missing param_name in api_key configuration for api_key_param auth")
            return False

        return True

    def _validate_basic_auth_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate Basic auth configuration"""
        required_fields = ['username_env_var', 'password_env_var']
        for field in required_fields:
            if field not in auth_config:
                self.logger.error(f"Missing Basic auth config field: {field}")
                return False
        return True

    def _validate_bearer_token_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate Bearer token configuration"""
        if 'api_key_env_var' not in auth_config:
            self.logger.error("Missing Bearer token environment variable configuration")
            return False
        return True

    def _validate_dual_key_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate dual key configuration"""
        # Check for required environment variable configuration
        required_fields = ['access_key_env_var', 'tenant_access_key_env_var']
        for field in required_fields:
            if field not in auth_config:
                self.logger.error(f"Missing dual key config field: {field}")
                return False

        # Check if environment variables exist or integration has attributes
        access_key_env = auth_config.get('access_key_env_var')
        tenant_access_key_env = auth_config.get('tenant_access_key_env_var')

        has_access_key = (hasattr(self.integration, 'karbon_access_key') and
                         getattr(self.integration, 'karbon_access_key', None) is not None) or \
                        os.getenv(access_key_env) is not None

        has_tenant_key = (hasattr(self.integration, 'karbon_tenant_access_key') and
                         getattr(self.integration, 'karbon_tenant_access_key', None) is not None) or \
                        os.getenv(tenant_access_key_env) is not None

        if not has_access_key:
            self.logger.error(f"Missing access key - neither integration.karbon_access_key nor env var {access_key_env} found")
            return False

        if not has_tenant_key:
            self.logger.error(f"Missing tenant access key - neither integration.karbon_tenant_access_key nor env var {tenant_access_key_env} found")
            return False

        return True

    def _validate_unleashed_hmac_signature_config(self, auth_config: Dict[str, Any]) -> bool:
        """Validate Unleashed HMAC signature configuration"""
        # Check required configuration structure
        required_fields = ['required_headers', 'signature_generation', 'credentials_mapping']
        for field in required_fields:
            if field not in auth_config:
                self.logger.error(f"Missing Unleashed HMAC signature config field: {field}")
                return False

        # Check credentials mapping
        credentials_mapping = auth_config.get('credentials_mapping', {})
        required_credentials = ['api_id', 'api_private_key', 'client_identifier']
        for credential in required_credentials:
            if credential not in credentials_mapping:
                self.logger.error(f"Missing credential mapping: {credential}")
                return False

        # Check if corresponding env_vars_config exists
        env_vars_config = self.config.get('env_vars_config', {})
        required_env_vars = ['unleashed_api_id', 'unleashed_api_private_key', 'unleashed_client_type']
        for env_var in required_env_vars:
            if env_var not in env_vars_config:
                self.logger.error(f"Missing env_vars_config for: {env_var}")
                return False

        # Check signature generation config
        signature_config = auth_config.get('signature_generation', {})
        signature_required_fields = ['method', 'input_source', 'output_format', 'secret_key_source']
        for field in signature_required_fields:
            if field not in signature_config:
                self.logger.error(f"Missing signature generation config field: {field}")
                return False

        # Validate signature method
        if signature_config.get('method') != 'HMAC-SHA256':
            self.logger.error("Unleashed API requires HMAC-SHA256 signature method")
            return False

        # Validate input source
        if signature_config.get('input_source') != 'query_parameters_only':
            self.logger.error("Unleashed API signature input must be query_parameters_only")
            return False

        return True