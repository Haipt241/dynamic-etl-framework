"""
Token Manager for Dynamic Integrations

Handles OAuth2 token management with advanced features:
- 30-minute token caching with 5-minute buffer
- S3-only storage with backup strategy
- Distributed locking to prevent race conditions
- CMS fallback for auto-recovery
- Retry logic with exponential backoff

Features implemented from xero-aws-only branch.
"""

import os
import sys
import json
import logging
import time
import threading
import base64
from datetime import datetime
from typing import Dict, Any, Tuple, Optional
import requests
from azure.storage.fileshare import ShareFileClient

# Add parent directories to path to enable imports from root

# Add AWS S3 support
import boto3
from botocore.exceptions import ClientError, NoCredentialsError

# Import S3Uploader and distributed locking
from dynamic_integrations.storage.s3_upload_tool import S3Uploader
from dynamic_integrations.auth.token_lock_manager_new import TokenLockManagerNew

# Add retry logic
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

# Import SSL configuration
from config import SSL_VERIFY


class TokenManager:
    """
    Advanced Token Manager with 30-minute caching and distributed locking

    Features:
    - 30-minute token caching (only refresh 5 minutes before expiry)
    - S3-only storage (faster than Azure File Share)
    - Distributed locking (prevent race conditions)
    - CMS fallback (auto-recovery when token issues)
    - Retry logic (exponential backoff for S3 operations)
    """

    def __init__(self, integration_instance, config: Dict[str, Any]):
        """
        Initialize token manager

        Args:
            integration_instance: The integration instance that owns this token manager
            config: Configuration dictionary containing integration settings
        """
        self.integration = integration_instance
        self.config = config
        self.logger = logging.getLogger(f"TokenManager.{config.get('integration_name', 'Unknown')}")

        # ========================================
        # 30-MINUTE TOKEN CACHING ATTRIBUTES
        # ========================================
        self.cached_access_token = None
        self.cached_refresh_token = None
        self.cached_token_expires_at = None  # Unix timestamp
        self.cached_token_filename = None
        self._cache_lock = threading.RLock()  # Thread safety for caching
        self.cache_buffer_seconds = 300

        # ========================================
        # DISTRIBUTED LOCKING SUPPORT
        # ========================================
        self.use_distributed_locking = True
        self.lock_manager = None  # Will be initialized when needed

        # ========================================
        # CMS FALLBACK SUPPORT
        # ========================================
        self.enable_cms_fallback = True

        # ========================================
        # S3 RETRY LOGIC
        # ========================================
        self.s3_retry_attempts = 3
        self.s3_retry_backoff = True

    def get_valid_token(self) -> str:
        """
        Get valid access token with 30-minute caching

        This is the main entry point for token management.
        Returns cached token if valid, otherwise refreshes and caches new token.

        Returns:
            str: Valid access token or raises exception if failed
        """
        token_file_name = self._get_token_filename()

        # ========================================
        # CACHING LOGIC: Check cache first!
        # ========================================

        # Priority 1: Check 30-minute cached token first
        if self._is_cached_token_valid(token_file_name):
            with self._cache_lock:
                self.logger.info(f"[CACHE] Using 30-minute cached token (saves ~900ms)")
                if self.cached_token_expires_at:
                    seconds_remaining = self.cached_token_expires_at - time.time()
                    expires_at_str = time.strftime('%H:%M:%S', time.localtime(self.cached_token_expires_at))
                    self.logger.info(f"[CACHE] Token expires at: {expires_at_str} ({seconds_remaining:.0f}s remaining)")
                return self.cached_access_token
        else:
            # Priority 2: Cache miss - get fresh token from S3 and cache it
            self.logger.info("=" * 80)
            self.logger.info("[TOKEN] CACHE MISS - Need to refresh from S3")
            self.logger.info("=" * 80)
            if self.cached_token_expires_at:
                cache_expired_ago = time.time() - self.cached_token_expires_at
                self.logger.info(f"[TOKEN] Previous cache expired {cache_expired_ago:.0f} seconds ago")
            else:
                self.logger.info(f"[TOKEN] No previous cache found")
            self.logger.info("")

            # Get fresh token from S3
            fresh_token = self._get_token_from_aws_s3(token_file_name)

            if fresh_token:
                # Handle case where fresh_token might be array [access_token, refresh_token, ...]
                if isinstance(fresh_token, list) and len(fresh_token) > 0:
                    access_token = fresh_token[0]  # Take access_token (first element)
                else:
                    access_token = fresh_token

                self.logger.info("[OK] Fresh token retrieved and cached for 30 minutes")
                return access_token

            # Priority 3: Password grant fallback for oauth2_password_grant
            auth_type = self.config.get('auth_type', 'oauth2')
            if auth_type == 'oauth2_password_grant':
                self.logger.info("🔑 Both cache and S3 failed, trying password grant")
                try:
                    from dynamic_integrations.auth.auth_manager import AuthManager
                    auth_manager = AuthManager(self.integration, self.config)
                    # Password grant method handles cache + S3 save internally
                    access_token = auth_manager._get_password_grant_oauth2_token()
                    if access_token:
                        return access_token
                except Exception as e:
                    self.logger.error(f"Password grant fallback failed: {e}")

            # CRITICAL: Raise exception instead of returning None to trigger status 13 handling
            error_msg = "Authentication failed: All token retrieval methods failed"
            self.logger.error(f"[ERROR] {error_msg}")
            raise Exception(error_msg)

    def _is_cached_token_valid(self, token_filename: str = None) -> bool:
        """
        Check if the 30-minute cached token is still valid

        Args:
            token_filename: Optional specific token filename to check

        Returns:
            bool: True if cached token is valid and should be used
        """
        with self._cache_lock:
            # Check if we have cached token data
            if not self.cached_access_token or not self.cached_token_expires_at:
                self.logger.debug("No cached token available")
                return False

            # If token_filename specified, verify it matches our cached token
            if token_filename and self.cached_token_filename != token_filename:
                self.logger.debug(f"Token filename mismatch: cached={self.cached_token_filename}, requested={token_filename}")
                return False

            current_time = time.time()
            time_until_expiry = self.cached_token_expires_at - current_time

            # Check if token will expire within buffer period (5 minutes = 300 seconds)
            if time_until_expiry <= self.cache_buffer_seconds:
                self.logger.info(f"Cached token expires in {time_until_expiry:.0f}s (< {self.cache_buffer_seconds}s buffer), needs refresh")
                return False

            self.logger.info(f"[OK] Using cached token (valid for {time_until_expiry:.0f}s more)")
            return True

    def _cache_tokens(self, access_token: str, refresh_token: str, token_filename: str, expires_in: int = 1800):
        """
        Cache tokens for 30-minute reuse

        Args:
            access_token: OAuth access token
            refresh_token: OAuth refresh token
            token_filename: Token filename for this client/org
            expires_in: Token lifetime in seconds (default: 1800 = 30 minutes)
        """
        with self._cache_lock:
            current_time = time.time()

            # Cache the tokens
            self.cached_access_token = access_token
            self.cached_refresh_token = refresh_token
            self.cached_token_filename = token_filename
            self.cached_token_expires_at = current_time + expires_in

            # Log cache update
            expires_at_str = time.strftime('%H:%M:%S', time.localtime(self.cached_token_expires_at))
            self.logger.info(f"🎯 Token cached until {expires_at_str} ({expires_in}s), filename: {token_filename}")

    def _get_lock_manager(self):
        """Get or create distributed lock manager instance"""
        if not self.lock_manager and self.use_distributed_locking:
            try:
                self.lock_manager = TokenLockManagerNew(
                    table_name='etani-token-locks',
                    region_name='us-east-1',
                    lock_timeout=120  # 2 minutes
                )
                self.logger.debug("Initialized distributed lock manager")
            except Exception as e:
                self.logger.warning(f"Failed to initialize distributed locking: {e}")
                self.use_distributed_locking = False
        return self.lock_manager

    def _try_backup_token(self, token_file_name: str, s3_uploader):
        """
        Try to retrieve backup token from S3 (.backup_latest file)

        Args:
            token_file_name: Token filename (e.g., 'CLIENT123_456.txt')
            s3_uploader: S3Uploader instance

        Returns:
            List containing [access_token, refresh_token, refresh_token] or None
        """
        try:
            integration_name = self.config.get('integration_name', 'unknown').lower()
            s3_bucket_name = os.getenv('AWS_S3_BUCKET_NAME')

            # Build backup S3 key matching the primary structure
            if integration_name in ['payroll_au', 'payroll_nz']:
                backup_s3_key = f"{integration_name}/{token_file_name}.backup_latest"
            else:
                backup_s3_key = f"{integration_name}tokens/{token_file_name}.backup_latest"

            self.logger.info(f"[DEBUG] Checking S3 backup: s3://{s3_bucket_name}/{backup_s3_key}")

            # Try to read backup file
            response = s3_uploader.s3_client.get_object(
                Bucket=s3_bucket_name,
                Key=backup_s3_key
            )
            file_contents = response['Body'].read().decode('utf-8')
            json_response = json.loads(file_contents)

            self.logger.info(f"[OK] Backup token found!")
            return [
                json_response.get('access_token', ''),
                json_response.get('refresh_token', ''),
                json_response.get('refresh_token', '')
            ]

        except Exception as e:
            self.logger.info(f"No backup token found: {e}")
            return None

    def _get_token_from_aws_s3(self, token_file_name: str):
        """Get token from AWS S3 bucket using S3Uploader and refresh if needed"""
        try:
            # Get credentials from config for client_id/secret lookup
            env_vars_config = self.config.get('env_vars_config', {})
            etani_client_id = None
            etani_organisation_id = None
            etani_link_organisation_id = None

            # Extract EtaniClientID and EtaniOrganisationID from env_vars_config
            for key, value in env_vars_config.items():
                if 'etani_client_id' in key.lower():
                    etani_client_id = value.get('default_value')
                elif 'etani_organisation_id' in key.lower():
                    etani_organisation_id = value.get('default_value')
                elif 'etani_link_organisation_id' in key.lower():
                    etani_link_organisation_id = value.get('default_value')

            if not etani_client_id or not etani_organisation_id:
                self.logger.debug(f"Missing EtaniClientID ({etani_client_id}) or EtaniOrganisationID ({etani_organisation_id})")
                return None

            if etani_link_organisation_id and etani_link_organisation_id != "":
                etani_organisation_id = etani_link_organisation_id

            # Get S3 bucket name from environment
            s3_bucket_name = os.getenv('AWS_S3_BUCKET_NAME')
            if not s3_bucket_name:
                error_message = "AWS_S3_BUCKET_NAME environment variable not set"
                self.logger.error(error_message)
                raise ValueError(error_message)

            # S3 key structure
            integration_name = self.config.get('integration_name', 'unknown').lower()

            # Special handling for Xero Payroll integrations (simplified structure without "tokens" suffix)
            if integration_name in ['payroll_au', 'payroll_nz']:
                new_s3_key = f"{integration_name}/{token_file_name}"  # payroll_au/
                self.logger.info(f"Using Xero Payroll token path: {new_s3_key}")
            else:
                # All other integrations use existing structure
                # NEW STRUCTURE: {integration}tokens/ (e.g., xeroprojecttokens/)
                new_s3_key = f"{integration_name}tokens/{token_file_name}"

            # OLD STRUCTURE: tokens/{integration}/ (e.g., tokens/xeroproject/)
            s3_prefix = os.getenv('AWS_S3_PREFIX', 'tokens')
            old_s3_key = f"{s3_prefix}/{integration_name}/{token_file_name}"

            # Get AWS region
            s3_region = os.getenv('AWS_S3_REGION', 'ap-northeast-3')

            # Step 1: Check if refresh_token provided from params (highest priority)
            if hasattr(self.integration, 'refresh_token') and self.integration.refresh_token:
                self.logger.info(f"Using refresh_token from params for {etani_client_id}_{etani_organisation_id}")
                old_tokens = [None, self.integration.refresh_token]  # [access_token, refresh_token] format
            else:
                # Step 2: Get token from AWS S3 (new structure first, fallback to old)
                try:
                    # Initialize S3Uploader
                    self.logger.info(f"Initializing S3Uploader with region: {s3_region}")
                    s3_uploader = S3Uploader(bucket_name=s3_bucket_name, region_name=s3_region)

                    # Try NEW structure first
                    try:
                        self.logger.info(f"[DEBUG] Checking NEW structure: {new_s3_key}")
                        response = s3_uploader.s3_client.get_object(
                            Bucket=s3_bucket_name,
                            Key=new_s3_key
                        )
                        file_contents = response['Body'].read().decode('utf-8')
                        self.logger.info(f"[OK] Token found in NEW structure")

                    except Exception as e:
                        # Only attempt fallback for non-payroll integrations
                        if integration_name not in ['payroll_au', 'payroll_nz']:
                            # Fallback to OLD structure
                            self.logger.info(f"Token not in new structure, checking old structure...")
                            response = s3_uploader.s3_client.get_object(
                                Bucket=s3_bucket_name,
                                Key=old_s3_key
                            )
                            file_contents = response['Body'].read().decode('utf-8')
                            self.logger.info(f"📁 Token found in OLD structure - will migrate on next save")
                        else:
                            # Payroll integrations: no fallback, raise error
                            self.logger.error(f"[ERROR] Token not found at: {new_s3_key}")
                            raise

                    # Backup token locally
                    os.makedirs('token', exist_ok=True)
                    backup_path = f'token/{token_file_name.replace(".txt", "_old.txt")}'
                    with open(backup_path, 'w+') as f:
                        f.write(file_contents)
                        self.logger.info(f"Backed up token to {backup_path}")

                    # Parse JSON
                    json_response = json.loads(file_contents)
                    self.logger.info(f"Successfully retrieved token from AWS S3")

                    old_tokens = [
                        json_response.get('access_token', ''),
                        json_response.get('refresh_token', ''),
                        json_response.get('refresh_token', '')
                    ]
                except Exception as e:
                    error_message = f"Failed to get token from S3: {str(e)}"
                    self.logger.error(error_message)

                    # ========================================
                    # FALLBACK 1: Try S3 backup (.backup_latest)
                    # ========================================
                    self.logger.info("")
                    self.logger.info("=" * 80)
                    self.logger.info("[SYNC] FALLBACK 1: S3 BACKUP FILE")
                    self.logger.info("=" * 80)

                    backup_tokens = self._try_backup_token(token_file_name, s3_uploader)

                    if backup_tokens and backup_tokens[1]:
                        self.logger.info(f"[SYNC] Refreshing token using S3 backup...")

                        try:
                            new_tokens = self.refresh_token_with_locking(backup_tokens[1])

                            if new_tokens and len(new_tokens) >= 1:
                                access_token = new_tokens[0]
                                refresh_token = new_tokens[1] if len(new_tokens) > 1 else None

                                # Cache the new tokens
                                self._cache_tokens(
                                    access_token=access_token,
                                    refresh_token=refresh_token,
                                    token_filename=token_file_name,
                                    expires_in=1800
                                )

                                self.logger.info("")
                                self.logger.info("=" * 80)
                                self.logger.info("[OK] S3 BACKUP RECOVERY SUCCESSFUL")
                                self.logger.info(f"📁 Token file restored in S3: {token_file_name}")
                                self.logger.info("=" * 80)
                                self.logger.info("")

                                return access_token
                            else:
                                self.logger.info(f"✗ Token refresh with backup failed, trying CMS...")
                        except Exception as backup_error:
                            self.logger.error(f"✗ Backup token refresh failed: {backup_error}")

                    self.logger.info("=" * 80)
                    self.logger.info("")

                    # ========================================
                    # FALLBACK 2: Try CMS database (client_service.Details → RefreshToken)
                    # ========================================
                    if self.enable_cms_fallback and all([etani_client_id, etani_organisation_id]):
                        self.logger.info("")
                        self.logger.info("=" * 80)
                        self.logger.info("[SYNC] FALLBACK 2: CMS DATABASE")
                        self.logger.info("=" * 80)
                        self.logger.info(f"[WARNING] Token not found in S3 or backup")
                        self.logger.info(f"[DEBUG] Attempting to retrieve RefreshToken from CMS database...")
                        self.logger.info("   (Note: CMS token is from original UI connection, may be stale)")
                        self.logger.info("")

                        try:
                            cms_refresh_token = self._get_token_from_cms()

                            if cms_refresh_token:
                                self.logger.info(f"[OK] Found RefreshToken in CMS database")
                                self.logger.info(f"[SYNC] Testing and creating S3 token from CMS...")

                                # Test and refresh the token
                                new_tokens = self.refresh_token_with_locking(cms_refresh_token)

                                if new_tokens and len(new_tokens) >= 1:
                                    access_token = new_tokens[0]
                                    refresh_token = new_tokens[1] if len(new_tokens) > 1 else None

                                    # Cache the new tokens
                                    self._cache_tokens(
                                        access_token=access_token,
                                        refresh_token=refresh_token,
                                        token_filename=token_file_name,
                                        expires_in=1800
                                    )

                                    self.logger.info("")
                                    self.logger.info("=" * 80)
                                    self.logger.info("[OK] CMS TOKEN FALLBACK SUCCESSFUL")
                                    self.logger.info(f"📁 Token file created in S3: {token_file_name}")
                                    self.logger.info("=" * 80)
                                    self.logger.info("")

                                    return access_token
                                else:
                                    self.logger.error(f"✗ CMS token invalid or refresh failed")
                            else:
                                self.logger.error(f"✗ CMS database has no RefreshToken for this organization")

                            self.logger.info("=" * 80)
                            self.logger.info("")
                        except Exception as cms_error:
                            self.logger.error(f"✗ CMS fallback failed: {cms_error}")
                            self.logger.info("=" * 80)
                            self.logger.info("")

                    # All fallbacks failed
                    self.logger.error("[ERROR] All token retrieval methods failed (S3, S3 backup, CMS database)")
                    raise Exception("Authentication failed: All token retrieval methods failed")

            # Step 3: Refresh token with distributed locking
            if old_tokens and len(old_tokens) >= 2:
                # Call GetNewToken with refresh token
                new_tokens = self.refresh_token_with_locking(old_tokens[1])  # old_tokens[1] is refresh_token

                if new_tokens and len(new_tokens) >= 1:
                    access_token = new_tokens[0]
                    refresh_token = new_tokens[1] if len(new_tokens) > 1 else None

                    # ========================================
                    # CACHE THE NEW TOKENS FOR 30 MINUTES!
                    # ========================================
                    self._cache_tokens(
                        access_token=access_token,
                        refresh_token=refresh_token,
                        token_filename=token_file_name,
                        expires_in=1800  # 30 minutes default
                    )

                    # If we successfully used refresh_token from params, clear it to prevent future reuse
                    if hasattr(self.integration, 'refresh_token') and self.integration.refresh_token and old_tokens[0] is None:
                        self.logger.info(f"Clearing refresh_token from params after successful authentication for {etani_client_id}_{etani_organisation_id}")
                        delattr(self.integration, 'refresh_token')

                    self.logger.info(f"[OK] OAuth2 token refreshed and cached for 30min from AWS S3 for {etani_client_id}_{etani_organisation_id}")
                    return access_token
                else:
                    # Token refresh failed - raise exception
                    raise Exception("Authentication failed: Token refresh returned no tokens")

            # If we get here, we couldn't get old tokens - raise exception
            raise Exception("Authentication failed: Could not retrieve tokens from S3")

        except Exception as e:
            error_message = str(e).lower()

            # Token errors should propagate to integration layer for status 13 handling
            token_error_keywords = ['invalid_grant', 'unauthorized', 'token expired', 'invalid_client']
            if any(keyword in error_message for keyword in token_error_keywords):
                self.logger.error(f"Token error detected: {e}")
                raise  # Re-raise to trigger status 13 logic

            # Other errors (network, S3, etc.) should return None
            self.logger.error(f"AWS S3 token retrieval failed: {e}")
            return None

    def refresh_token_with_locking(self, refresh_token: str):
        """Refresh token with distributed locking to prevent race conditions"""

        # ========================================
        # DISTRIBUTED LOCKING: Prevent race conditions
        # ========================================
        token_filename = self._get_token_filename()
        lock_manager = self._get_lock_manager()

        if lock_manager and self.use_distributed_locking:
            self.logger.info(f"🔒 Acquiring distributed lock for: {token_filename}")
            try:
                with lock_manager.lock(token_filename, wait=True):
                    self.logger.info(f"[OK] Lock acquired, refreshing token for: {token_filename}")
                    return self._do_token_refresh(refresh_token)
            except Exception as e:
                self.logger.warning(f"Distributed locking failed, proceeding without lock: {e}")
                return self._do_token_refresh(refresh_token)
        else:
            # No locking available, proceed directly
            return self._do_token_refresh(refresh_token)

    def _do_token_refresh(self, refresh_token: str):
        """Actual token refresh implementation with CMS fallback"""
        try:
            self.logger.info("=" * 80)
            self.logger.info("[TOKEN REFRESH] Starting token refresh attempt")
            self.logger.info("=" * 80)
            self.logger.info(f"[TOKEN] Refresh token (first 8 chars): {refresh_token[:8] if refresh_token else 'None'}...")
            self.logger.info(f"[TOKEN] Process ID: {os.getpid()}")
            self.logger.info(f"[TOKEN] Thread ID: {threading.current_thread().ident}")
            self.logger.info("")

            if not refresh_token:
                error_msg = "No refresh token provided"
                self.logger.error(error_msg)
                raise Exception(f"Authentication failed: {error_msg}")

            # Get client credentials (check environment variables first, then config defaults)
            env_vars_config = self.config.get('env_vars_config', {})
            client_id = None
            client_secret = None

            for key, value in env_vars_config.items():
                if 'client_id' in key.lower():
                    env_var = value.get('env_var')
                    # Priority 1: Environment variable (for Secrets Manager support)
                    # Priority 2: Config default value
                    client_id = os.getenv(env_var) if env_var else None
                    if not client_id:
                        client_id = value.get('default_value')
                elif 'client_secret' in key.lower():
                    env_var = value.get('env_var')
                    # Priority 1: Environment variable (for Secrets Manager support)
                    # Priority 2: Config default value
                    client_secret = os.getenv(env_var) if env_var else None
                    if not client_secret:
                        client_secret = value.get('default_value')

            # OAuth2 password grant only needs client_id for refresh (no client_secret)
            auth_type = self.config.get('auth_type', 'oauth2')
            if auth_type == 'oauth2_password_grant':
                if not client_id:
                    error_msg = "Missing client_id for OAuth2 password grant refresh"
                    self.logger.error(error_msg)
                    raise Exception(f"Authentication failed: {error_msg}")
            else:
                # Standard OAuth2 needs both client_id and client_secret
                if not client_id or not client_secret:
                    error_msg = f"Missing client credentials: client_id={bool(client_id)}, client_secret={bool(client_secret)}"
                    self.logger.error(error_msg)
                    raise Exception(f"Authentication failed: {error_msg}")

            # Get integration-specific OAuth endpoints and scopes
            auth_config = self.config.get('auth_config', {})
            integration_name = self.config.get('integration_name', '').lower()

            # Integration-specific configurations
            if integration_name == 'wfm':
                token_refresh_url = 'https://oauth.workflowmax.com/oauth/token'
                scope = 'openid email profile workflowmax offline_access'
            elif integration_name == 'myob':
                token_refresh_url = 'https://secure.myob.com/oauth2/v1/authorize/'
                scope = 'CompanyFile offline_access openid'
            else:
                # Generic OAuth2 endpoint from config or default patterns
                token_refresh_url = auth_config.get('token_url', 'https://oauth.example.com/oauth/token')
                scope = auth_config.get('scopes', 'offline_access')

                # Replace URL template variables if needed (e.g., for oauth2_password_grant)
                if '{oauth_domain}' in token_refresh_url or '{domain}' in token_refresh_url:
                    oauth_domain = None
                    domain = None
                    for key, value in env_vars_config.items():
                        if 'oauth_domain' in key.lower():
                            oauth_domain = value.get('default_value')
                        elif 'domain' in key.lower() and not oauth_domain:
                            domain = value.get('default_value')

                    if oauth_domain and '{oauth_domain}' in token_refresh_url:
                        token_refresh_url = token_refresh_url.replace('{oauth_domain}', oauth_domain)
                    elif domain and '{domain}' in token_refresh_url:
                        token_refresh_url = token_refresh_url.replace('{domain}', domain)

            # ========================================
            # CMS FALLBACK: Try CMS token if refresh fails
            # ========================================
            try:
                # Prepare authorization - Xero requires Basic Auth header with base64 encoded credentials
                b64_id_secret = base64.b64encode(
                    bytes(client_id + ':' + client_secret, 'utf-8')
                ).decode('utf-8')

                # Token refresh data - only grant_type and refresh_token (NO client_id/secret/scope)
                data = {
                    'grant_type': 'refresh_token',
                    'refresh_token': refresh_token
                }

                # Log token refresh request (masked)
                self.logger.info(f"[DEBUG] Token refresh request:")
                self.logger.info(f"  URL: {token_refresh_url}")
                self.logger.info(f"  Authorization: Basic {b64_id_secret[:10]}... [MASKED]")
                self.logger.info(f"  grant_type: {data.get('grant_type')}")
                self.logger.info(f"  refresh_token: {refresh_token[:4] if refresh_token else 'None'}...{refresh_token[-4:] if refresh_token else 'None'}")

                response = requests.post(
                    token_refresh_url,
                    headers={
                        'Authorization': 'REDACTED' + b64_id_secret,
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    data=data,
                    verify=SSL_VERIFY
                )

                json_response = response.json()
                status_code = response.status_code

                # Log response status
                if status_code != 200:
                    self.logger.error(f"[DEBUG] Token refresh failed with status {status_code}")
                    self.logger.error(f"[DEBUG] Response: {json_response}")

            except Exception as e:
                self.logger.error(f"OAuth refresh request failed: {e}")
                status_code = 400
                json_response = {"error": str(e)}

            # Check if token refresh failed with 400 error (CMS fallback trigger)
            if status_code == 400 and self.enable_cms_fallback:
                self.logger.warning("Token refresh failed with 400, attempting CMS fallback...")
                try:
                    cms_refresh_token = self._get_token_from_cms()
                    if cms_refresh_token:
                        self.logger.info("[SYNC] Retrying token refresh with CMS token")
                        # Retry with CMS token
                        data['refresh_token'] = cms_refresh_token
                        response = requests.post(
                            token_refresh_url,
                            headers={'Content-Type': 'application/x-www-form-urlencoded'},
                            data=data
                        )
                        json_response = response.json()
                        status_code = response.status_code
                        if status_code == 200:
                            self.logger.info("[OK] CMS fallback successful!")
                except Exception as e:
                    self.logger.error(f"CMS fallback failed: {e}")

            # Save new token file locally
            os.makedirs('token', exist_ok=True)
            token_file_name = f'token/{self._get_token_filename().replace(".txt", "_new.txt")}'
            with open(token_file_name, 'w+') as f:
                f.write(json.dumps(json_response))

            if status_code == 200:
                # Save to AWS S3 with retry logic
                token_file_name_remote = self._get_token_filename()
                json_data = json.dumps(json_response).encode('utf-8')

                new_access_token = json_response.get('access_token', '')
                new_refresh_token = json_response.get('refresh_token', '')

                self.logger.info("=" * 80)
                self.logger.info("[TOKEN REFRESH] SUCCESS - Xero accepted refresh token")
                self.logger.info("=" * 80)
                self.logger.info(f"[TOKEN] Old refresh token (first 8): {refresh_token[:8]}...")
                self.logger.info(f"[TOKEN] New refresh token (first 8): {new_refresh_token[:8] if new_refresh_token else 'None'}...")
                self.logger.info(f"[TOKEN] New access token length: {len(new_access_token)}")
                self.logger.info(f"[TOKEN] Saving to S3: {token_file_name_remote}")
                self.logger.info("")

                self._save_token_to_aws_s3_with_retry(token_file_name_remote, json_data)

                self.logger.info("[TOKEN] ✓ Successfully saved new tokens to S3 with backup")
                self.logger.info("=" * 80)
                self.logger.info("")

                return [new_access_token, new_refresh_token]
            else:
                # Extract error details for propagation
                error_detail = json_response.get('error', 'Unknown error')
                error_description = json_response.get('error_description', error_detail)
                self.logger.error(f"Token refresh failed: {error_description}")

                # Raise exception to propagate error to integration layer (for status 13 handling)
                raise Exception(f"Token refresh failed: {error_detail}")

        except requests.exceptions.RequestException as req_err:
            # Network/HTTP errors
            self.logger.error(f"_do_token_refresh network error: {req_err}")
            raise Exception(f"Token refresh network error: {str(req_err)}")
        except Exception as e:
            # Re-raise to propagate error (don't swallow it)
            self.logger.error(f"_do_token_refresh failed: {e}")
            raise

    def _get_token_from_cms(self) -> str:
        """
        CMS Database Fallback - Get fresh refresh token from CMS database
        Triggered when S3 token refresh fails with 400 Bad Request
        """
        try:
            env_vars_config = self.config.get('env_vars_config', {})

            # Extract parameters from environment
            etani_client_id = None
            etani_organisation_id = None
            xero_tenant_id = None

            for key, value in env_vars_config.items():
                if 'etani_client_id' in key.lower():
                    etani_client_id = value.get('default_value')
                elif 'etani_organisation_id' in key.lower():
                    etani_organisation_id = value.get('default_value')
                elif 'xero_tenant_id' in key.lower():
                    xero_tenant_id = value.get('default_value')

            if not all([etani_client_id, etani_organisation_id, xero_tenant_id]):
                self.logger.error(f"Missing CMS parameters: client_id={etani_client_id}, org_id={etani_organisation_id}, tenant_id={xero_tenant_id}")
                return None

            # Try to import and call GetCMSDetails
            try:
                from dynamic_integrations.database.sql_helper import GetCMSDetails
                self.logger.info(f"Calling GetCMSDetails({etani_client_id}, {etani_organisation_id}, {xero_tenant_id})")

                cms_result = GetCMSDetails(etani_client_id, etani_organisation_id, xero_tenant_id)

                # Check if DataFrame has results (GetCMSDetails returns pandas DataFrame)
                if cms_result is not None and not cms_result.empty:
                    # Extract RefreshToken from DataFrame (first row)
                    refresh_token = cms_result.loc[0, 'RefreshToken'] if 'RefreshToken' in cms_result.columns else None

                    if refresh_token and refresh_token.strip():
                        self.logger.info(f"[OK] Retrieved refresh token from CMS database: {refresh_token[:4]}...{refresh_token[-4:]}")
                        return refresh_token
                    else:
                        self.logger.error("No RefreshToken found in CMS response (NULL or empty)")
                        return None
                else:
                    self.logger.error("Empty response from CMS database")
                    return None

            except ImportError as e:
                self.logger.error(f"GetCMSDetails not available: {e}")
                return None
            except Exception as e:
                self.logger.error(f"GetCMSDetails call failed: {e}")
                return None

        except Exception as e:
            self.logger.error(f"CMS fallback failed: {e}")
            return None

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=4, max=10),
        retry=retry_if_exception_type((ClientError, Exception)),
        reraise=True
    )
    def _save_token_to_aws_s3_with_retry(self, token_file_name: str, json_data: bytes) -> bool:
        """Save token to AWS S3 bucket with retry logic and exponential backoff"""
        try:
            self.logger.debug(f"Attempting S3 save with retry: {token_file_name}")
            result = self._save_token_to_aws_s3(token_file_name, json_data)
            if result:
                self.logger.info(f"[OK] S3 save successful with retry: {token_file_name}")
            return result
        except Exception as e:
            self.logger.warning(f"[WARNING] S3 save attempt failed (will retry): {e}")
            raise  # Re-raise to trigger retry

    def _save_token_to_aws_s3(self, token_file_name: str, json_data: bytes) -> bool:
        """Save token to AWS S3 bucket using S3Uploader"""
        # Get S3 bucket name from environment
        s3_bucket_name = os.getenv('AWS_S3_BUCKET_NAME')
        if not s3_bucket_name:
            error_message = "AWS_S3_BUCKET_NAME environment variable not set"
            self.logger.error(error_message)
            raise ValueError(error_message)

        # Create folder structure - ALWAYS use NEW structure for saves
        integration_name = self.config.get('integration_name', 'unknown').lower()

        # Special handling for Xero Payroll integrations
        if integration_name in ['payroll_au', 'payroll_nz']:
            s3_key = f"{integration_name}/{token_file_name}"  # payroll_au/
            self.logger.info(f"Saving Xero Payroll token to: {s3_key}")
        else:
            # All other integrations use existing structure
            s3_key = f"{integration_name}tokens/{token_file_name}"  # NEW: xeroprojecttokens/

        # Get AWS region
        s3_region = os.getenv('AWS_S3_REGION', 'ap-northeast-3')

        try:
            # Initialize S3Uploader
            self.logger.info(f"Initializing S3Uploader with region: {s3_region}")
            s3_uploader = S3Uploader(bucket_name=s3_bucket_name, region_name=s3_region)

            # Decode json_data if it's bytes
            if isinstance(json_data, bytes):
                contents = json_data.decode('utf-8')
            else:
                contents = json_data

            # Save token using update_file with backup support
            # Creates .backup_latest before updating the primary file
            self.logger.info(f"Uploading token with backup to s3://{s3_bucket_name}/{s3_key}")

            s3_uploader.update_file(
                s3_key=s3_key,
                contents=contents,
                metadata={
                    'updated': datetime.utcnow().isoformat(),
                    'status': 'active',
                    'content-type': 'application/json'
                },
                backup=True  # [OK] Create .backup_latest file
            )

            # Generate S3 URL for logging
            s3_url = f"s3://{s3_bucket_name}/{s3_key}"
            backup_s3_url = f"s3://{s3_bucket_name}/{s3_key}.backup_latest"
            self.logger.info(f"[OK] Token successfully saved to AWS S3: {s3_url}")
            self.logger.info(f"[OK] Backup token created at: {backup_s3_url}")
            return True

        except Exception as e:
            error_message = f"Failed to save token to S3: {str(e)}"
            self.logger.error(error_message)
            raise ValueError(error_message)

    def _get_token_filename(self) -> str:
        """Get token filename based on client and organization IDs"""
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

    def GetTokenFromFile(self, token_file_name: str = None):
        """
        Get token from file - backward compatibility method

        Args:
            token_file_name: Optional token filename (auto-generated if not provided)

        Returns:
            List: [access_token, refresh_token] for backward compatibility
        """
        try:
            # Use existing get_valid_token method
            access_token = self.get_valid_token()

            if access_token:
                # Return in old format for backward compatibility: [access_token, refresh_token, ...]
                with self._cache_lock:
                    return [access_token, self.cached_refresh_token]
            else:
                return None

        except Exception as e:
            self.logger.error(f"GetTokenFromFile failed: {e}")
            return None

    def GetNewToken(self, refresh_token: str):
        """
        Refresh token - backward compatibility method

        Args:
            refresh_token: Refresh token to use

        Returns:
            List: [access_token, refresh_token] for backward compatibility
        """
        try:
            # Use existing refresh method with locking
            result = self.refresh_token_with_locking(refresh_token)
            return result

        except Exception as e:
            self.logger.error(f"GetNewToken failed: {e}")
            return None