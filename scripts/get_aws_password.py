#!/usr/bin/env python3
"""
Get AWS RDS Password from Secrets Manager

This script retrieves the database password from AWS Secrets Manager.
Requires AWS credentials to be configured.
"""

# Support direct operational CLI execution.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import json
import boto3
import sys
import os
import config  # Assumes config.py exists with AWS_RDS_SECRET_NAME and AWS_RDS_REGION

def get_aws_rds_password():
    """
    Retrieve AWS RDS password from Secrets Manager
    Returns both username and password
    """
    try:
        # Get secret details from config
        secret_name = config.AWS_RDS_SECRET_NAME  # 'rds!cluster-e715bbba-8b9f-43d1-8820-0f1b72fda546'
        region_name = config.AWS_RDS_REGION       # 'ap-southeast-2'

        print(f"Retrieving secret '{secret_name}' from region '{region_name}'...")

        # Create AWS session
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        # Get secret value
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

        # Extract secret string
        secret = get_secret_value_response['SecretString']

        # Parse JSON (most AWS RDS secrets are in JSON format)
        try:
            secret_dict = json.loads(secret)
            username = secret_dict.get('username', config.AWS_RDS_USERNAME)
            password = secret_dict.get('password')

            if not password:
                raise ValueError("No password found in secret")

            print(f"Successfully retrieved credentials for user: {username}")

            # Return both username and password
            return {
                'username': username,
                'password': password,
                'host': config.AWS_RDS_HOST
            }

        except json.JSONDecodeError:
            # If not in JSON format, treat entire string as password
            print(f"Secret is not in JSON format, treating entire string as password")
            return {
                'username': config.AWS_RDS_USERNAME,
                'password': secret,
                'host': config.AWS_RDS_HOST
            }

    except Exception as e:
        print(f"Error retrieving AWS RDS password: {str(e)}")
        return None

if __name__ == "__main__":
    # Check if AWS credentials are set
    if not os.getenv('AWS_ACCESS_KEY_ID') and hasattr(config, 'AWS_ACCESS_KEY_ID'):
        os.environ['AWS_ACCESS_KEY_ID'] = config.AWS_ACCESS_KEY_ID
        print("Set AWS_ACCESS_KEY_ID from config")

    if not os.getenv('AWS_SECRET_ACCESS_KEY') and hasattr(config, 'AWS_SECRET_ACCESS_KEY'):
        os.environ['AWS_SECRET_ACCESS_KEY'] = config.AWS_SECRET_ACCESS_KEY
        print("Set AWS_SECRET_ACCESS_KEY from config")

    # Get credentials
    credentials = get_aws_rds_password()

    if credentials:
        print("\n=== AWS RDS CONNECTION DETAILS ===")
        print(f"Host:     {credentials['host']}")
        print(f"Username: {credentials['username']}")
        print(f"Password: {credentials['password']}")

        # Print connection string example
        print("\n=== Connection String Example ===")
        print(f"mysql+pymysql://{credentials['username']}:{credentials['password']}@{credentials['host']}/vibedb_FIRMCODE")
        print("\nReplace FIRMCODE with the appropriate firmcode (e.g., tigers)")
    else:
        print("Failed to retrieve AWS RDS credentials")
        sys.exit(1)