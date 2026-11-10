"""
Alternative: Retrieve AWS credentials from Azure Key Vault instead of environment variables

This approach stores AWS credentials in Azure Key Vault, which might be
preferable if you already use Azure Key Vault for other secrets.
"""

# Support direct operational CLI execution.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import json
import logging
import boto3
from botocore.exceptions import ClientError
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool
import config

logger = logging.getLogger(__name__)

# Cache for credentials
_aws_credentials_cache = None


def _get_aws_credentials_from_azure_keyvault():
    """
    Retrieve AWS credentials from Azure Key Vault.

    You need to:
    1. Install: pip install azure-identity azure-keyvault-secrets
    2. Store in Azure Key Vault:
       - Secret name: aws-access-key-id
       - Secret name: aws-secret-access-key
    3. Grant your Azure App Service managed identity access to Key Vault

    Returns:
        dict: {'access_key_id': '...', 'secret_access_key': '...'}
    """
    from azure.identity import DefaultAzureCredential
    from azure.keyvault.secrets import SecretClient

    # Your Azure Key Vault URL
    key_vault_url = "https://your-keyvault-name.vault.azure.net/"

    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=key_vault_url, credential=credential)

    try:
        access_key = client.get_secret("aws-access-key-id").value
        secret_key = client.get_secret("aws-secret-access-key").value

        return {
            'access_key_id': access_key,
            'secret_access_key': secret_key
        }
    except Exception as e:
        logger.error(f"Failed to retrieve AWS credentials from Azure Key Vault: {e}")
        raise


def _get_awsrds_secret():
    """
    Retrieve RDS password from AWS Secrets Manager.
    Uses AWS credentials from Azure Key Vault.

    Returns:
        dict: {'username': '...', 'password': '...'}
    """
    global _aws_credentials_cache

    if _aws_credentials_cache is not None:
        return _aws_credentials_cache

    # Get AWS credentials from Azure Key Vault
    aws_creds = _get_aws_credentials_from_azure_keyvault()

    # Your hardcoded values
    secret_name = "rds!cluster-44496612-3d03-451b-9749-88451f45fed7"
    region_name = "ap-northeast-3"

    # Create a Secrets Manager client with credentials from Azure Key Vault
    session = boto3.session.Session(
        aws_access_key_id=aws_creds['access_key_id'],
        aws_secret_access_key=aws_creds['secret_access_key']
    )

    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

        secret = get_secret_value_response['SecretString']

        # Parse the secret
        try:
            secret_dict = json.loads(secret)
            username = secret_dict.get('username', config.AWS_RDS_USERNAME)
            password = secret_dict.get('password')
        except (json.JSONDecodeError, KeyError):
            username = config.AWS_RDS_USERNAME
            password = secret

        _aws_credentials_cache = {
            'username': username,
            'password': password
        }

        logger.info(f"Retrieved RDS credentials from AWS Secrets Manager")
        return _aws_credentials_cache

    except ClientError as e:
        logger.error(f"Failed to retrieve secret from AWS Secrets Manager: {e}")
        raise


def create_aws_engine():
    """Create SQLAlchemy engine with connection pooling."""
    credentials = _get_awsrds_secret()

    connection_string = (
        f"mysql+pymysql://{credentials['username']}:{credentials['password']}"
        f"@{config.AWS_RDS_HOST}/{config.AWS_RDS_DATABASE}"
    )

    engine = create_engine(
        connection_string,
        poolclass=QueuePool,
        pool_size=10,
        max_overflow=20,
        pool_timeout=30,
        pool_recycle=3600,
        pool_pre_ping=True,
        echo=False,
    )

    logger.info(f"AWS RDS connection pool created")
    return engine


# Usage:
# engine = create_aws_engine()
