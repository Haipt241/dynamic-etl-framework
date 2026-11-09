"""
Script to retrieve and display AWS RDS credentials from AWS Secrets Manager.
This script directly calls AWS Secrets Manager using boto3.
"""

import sys
import json
import boto3
from botocore.exceptions import ClientError
import config

def get_awsrds_secret():
    """
    Retrieve RDS credentials from AWS Secrets Manager.
    """
    secret_name = config.AWS_RDS_SECRET_NAME
    region_name = config.AWS_RDS_REGION

    try:
        session = boto3.session.Session()
        client = session.client(
            service_name='secretsmanager',
            region_name=region_name
        )

        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

        secret = get_secret_value_response['SecretString']

        try:
            secret_dict = json.loads(secret)
            username = secret_dict.get('username', config.AWS_RDS_USERNAME)
            password = secret_dict.get('password')
        except (json.JSONDecodeError, KeyError):
            username = config.AWS_RDS_USERNAME
            password = secret

        return {
            'username': username,
            'password': password
        }

    except ClientError as e:
        print(f"Failed to retrieve AWS secret: {e}")
        raise e

def main():
    """Retrieve and print AWS RDS secret credentials."""
    try:
        print("=" * 60)
        print("AWS RDS Secret Retrieval")
        print("=" * 60)

        # Get credentials from AWS Secrets Manager
        credentials = get_awsrds_secret()

        if credentials:
            print("\n✓ Successfully retrieved AWS RDS credentials:\n")
            print(f"Username: {credentials.get('username')}")
            print(f"Password: {credentials.get('password')}")
            print("\n" + "=" * 60)
            return 0
        else:
            print("\n✗ Failed to retrieve credentials - empty response")
            return 1

    except Exception as e:
        print(f"\n✗ Error retrieving AWS RDS secret: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())
