"""
AWS Secrets Manager utility for retrieving OAuth credentials

Security:
- Credentials never stored in code
- Retrieved on-demand from AWS Secrets Manager
- Cached for 1 hour to reduce API calls
- Automatic rotation support

Usage:
    from dynamic_integrations.secrets_manager import set_xero_oauth_env_vars

    # Call before integration initialization
    set_xero_oauth_env_vars()
"""

import os
import json
import boto3
from datetime import datetime, timedelta
from typing import Dict, Optional

# Cache to avoid excessive Secrets Manager API calls
_secrets_cache = {}
_cache_ttl = timedelta(hours=1)


def get_xero_oauth_credentials() -> Dict[str, str]:
    """
    Retrieve Xero OAuth application credentials from AWS Secrets Manager

    Returns:
        Dict with 'client_id' and 'client_secret' keys

    Raises:
        Exception: If credentials cannot be retrieved
    """
    secret_name = 'etani/xero/oauth-app'

    # Check cache first (1-hour TTL)
    cache_key = f"{secret_name}_xero_oauth"
    if cache_key in _secrets_cache:
        cached_data, cached_time = _secrets_cache[cache_key]
        if datetime.now() - cached_time < _cache_ttl:
            age_seconds = (datetime.now() - cached_time).seconds
            print(f"[OK] Using cached Xero OAuth credentials (age: {age_seconds}s)")
            return cached_data

    # Retrieve from Secrets Manager
    try:
        region = os.getenv('AWS_DEFAULT_REGION', 'ap-northeast-3')
        client = boto3.client('secretsmanager', region_name=region)

        print(f"[SECURE] Retrieving Xero OAuth credentials from AWS Secrets Manager...")
        print(f"   Secret: {secret_name}")
        print(f"   Region: {region}")

        response = client.get_secret_value(SecretId=secret_name)

        # Parse secret
        secrets = json.loads(response['SecretString'])

        # Validate required fields
        if 'client_id' not in secrets or 'client_secret' not in secrets:
            raise ValueError("Secret missing required fields: client_id, client_secret")

        # Cache for 1 hour
        credentials = {
            'client_id': secrets['client_id'],
            'client_secret': secrets['client_secret']
        }
        _secrets_cache[cache_key] = (credentials, datetime.now())

        # Log success with masked values
        client_id_masked = f"{credentials['client_id'][:4]}...{credentials['client_id'][-4:]}"
        print(f"[OK] Retrieved Xero OAuth credentials from Secrets Manager")
        print(f"   Client ID: {client_id_masked} [MASKED]")

        return credentials

    except client.exceptions.ResourceNotFoundException:
        error_msg = f"Secret '{secret_name}' not found in AWS Secrets Manager"
        print(f"[ERROR] {error_msg}")
        print(f"   Please create the secret using: aws secretsmanager create-secret --name {secret_name} ...")
        raise Exception(error_msg)

    except Exception as e:
        error_msg = f"Failed to retrieve Xero OAuth credentials from Secrets Manager: {e}"
        print(f"[ERROR] {error_msg}")
        raise Exception(error_msg)


def set_xero_oauth_env_vars():
    """
    Load Xero OAuth credentials from Secrets Manager and set as environment variables

    This is called during integration initialization to populate XERO_CLIENT_ID
    and XERO_CLIENT_SECRET environment variables.

    Environment variables set:
    - XERO_CLIENT_ID
    - XERO_CLIENT_SECRET
    """
    try:
        # Check if already set (don't overwrite if manually provided)
        if os.getenv('XERO_CLIENT_ID') and os.getenv('XERO_CLIENT_SECRET'):
            print(f"[OK] Xero OAuth credentials already set in environment (skipping Secrets Manager)")
            return

        credentials = get_xero_oauth_credentials()

        # Set environment variables (will be read by integration configs)
        os.environ['XERO_CLIENT_ID'] = credentials['client_id']
        os.environ['XERO_CLIENT_SECRET'] = credentials['client_secret']

        # Log (with masking)
        client_id_masked = f"{credentials['client_id'][:4]}...{credentials['client_id'][-4:]}"
        print(f"[OK] Set XERO_CLIENT_ID environment variable: {client_id_masked} [MASKED]")
        print(f"[OK] Set XERO_CLIENT_SECRET environment variable: *** [MASKED]")

    except Exception as e:
        print(f"[ERROR] Failed to set Xero OAuth environment variables: {e}")
        raise


def rotate_xero_oauth_credentials(new_client_id: str, new_client_secret: str):
    """
    Rotate Xero OAuth credentials in AWS Secrets Manager

    Args:
        new_client_id: New OAuth2 client ID from Xero Developer Portal
        new_client_secret: New OAuth2 client secret from Xero Developer Portal

    Usage:
        from dynamic_integrations.secrets_manager import rotate_xero_oauth_credentials

        rotate_xero_oauth_credentials(
            new_client_id='NEW_ID_HERE',
            new_client_secret='NEW_SECRET_HERE'
        )
    """
    secret_name = 'etani/xero/oauth-app'

    try:
        region = os.getenv('AWS_DEFAULT_REGION', 'ap-northeast-3')
        client = boto3.client('secretsmanager', region_name=region)

        print(f"[SYNC] Rotating Xero OAuth credentials in Secrets Manager...")

        # Update secret
        new_secret = {
            'client_id': new_client_id,
            'client_secret': new_client_secret,
            'rotated_date': datetime.now().isoformat(),
            'rotation_schedule': 'quarterly',
            'updated_by': 'manual_rotation'
        }

        client.put_secret_value(
            SecretId=secret_name,
            SecretString=json.dumps(new_secret)
        )

        # Clear cache so next call gets new credentials
        cache_key = f"{secret_name}_xero_oauth"
        if cache_key in _secrets_cache:
            del _secrets_cache[cache_key]

        print(f"[OK] Successfully rotated Xero OAuth credentials")
        print(f"[WARNING]  All running containers will pick up new credentials within 1 hour (cache TTL)")
        print(f"[WARNING]  Consider restarting all Xero integration containers immediately")

    except Exception as e:
        print(f"[ERROR] Failed to rotate Xero OAuth credentials: {e}")
        raise


def verify_secrets_manager_access():
    """
    Verify that AWS Secrets Manager is accessible and credentials can be retrieved

    Returns:
        bool: True if successful, False otherwise

    Usage:
        from dynamic_integrations.secrets_manager import verify_secrets_manager_access

        if verify_secrets_manager_access():
            print("Secrets Manager is working!")
    """
    try:
        print("[SEARCH] Verifying AWS Secrets Manager access...")
        credentials = get_xero_oauth_credentials()

        if credentials and 'client_id' in credentials and 'client_secret' in credentials:
            print(f"[OK] Secrets Manager access verified successfully")
            return True
        else:
            print(f"[ERROR] Retrieved credentials are invalid")
            return False

    except Exception as e:
        print(f"[ERROR] Secrets Manager access verification failed: {e}")
        return False


if __name__ == '__main__':
    """
    Test script to verify Secrets Manager access

    Usage:
        python dynamic_integrations/secrets_manager.py
    """
    print("=" * 80)
    print("AWS Secrets Manager - Xero OAuth Credentials Test")
    print("=" * 80)
    print()

    # Test 1: Verify access
    print("Test 1: Verify Secrets Manager access")
    print("-" * 80)
    success = verify_secrets_manager_access()
    print()

    if success:
        # Test 2: Set environment variables
        print("Test 2: Set environment variables")
        print("-" * 80)
        set_xero_oauth_env_vars()
        print()

        # Test 3: Verify environment variables
        print("Test 3: Verify environment variables")
        print("-" * 80)
        client_id = os.getenv('XERO_CLIENT_ID', '')
        client_secret = os.getenv('XERO_CLIENT_SECRET', '')

        if client_id and client_secret:
            client_id_masked = f"{client_id[:4]}...{client_id[-4:]}"
            print(f"[OK] XERO_CLIENT_ID: {client_id_masked} [MASKED]")
            print(f"[OK] XERO_CLIENT_SECRET: *** [MASKED]")
            print(f"[OK] All tests passed!")
        else:
            print(f"[ERROR] Environment variables not set")
    else:
        print(f"[ERROR] Tests failed - Secrets Manager not accessible")

    print()
    print("=" * 80)
