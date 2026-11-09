"""
Test the AWS Secrets Manager retrieval function
"""
import boto3
from botocore.exceptions import ClientError
import json


def _get_awsrds_secret():
    secret_name = "rds!cluster-44496612-3d03-451b-9749-88451f45fed7"
    region_name = "ap-northeast-3"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    secret = get_secret_value_response['SecretString']
    return secret


if __name__ == "__main__":
    print("Testing AWS Secrets Manager connection...")
    print("="*60)

    # First, check if credentials are available
    print("\n1. Checking for AWS credentials...")
    session = boto3.session.Session()
    credentials = session.get_credentials()

    if credentials:
        print("✓ AWS credentials found!")
        print(f"   Access Key ID: {credentials.access_key[:10]}...")
        print(f"   Region: ap-northeast-3")
    else:
        print("✗ No AWS credentials found")
        print("\nTo test this, you need to either:")
        print("  1. Set environment variables:")
        print("     export AWS_ACCESS_KEY_ID=your_key")
        print("     export AWS_SECRET_ACCESS_KEY=your_secret")
        print("  2. Or configure ~/.aws/credentials")
        print("\nSkipping secret retrieval test...")
        exit(1)

    # Try to retrieve the secret
    print("\n2. Attempting to retrieve secret from AWS Secrets Manager...")
    try:
        secret = _get_awsrds_secret()
        print("✓ Successfully retrieved secret!")

        # Try to parse it
        print("\n3. Parsing secret...")
        try:
            secret_dict = json.loads(secret)
            print("✓ Secret is valid JSON")
            print(f"   Keys found: {list(secret_dict.keys())}")

            if 'username' in secret_dict:
                print(f"   Username: {secret_dict['username']}")
            if 'password' in secret_dict:
                print(f"   Password: {'*' * 10} (hidden)")

        except json.JSONDecodeError:
            print("⚠ Secret is not JSON (plain text password)")
            print(f"   Length: {len(secret)} characters")

        print("\n" + "="*60)
        print("✓ TEST PASSED - Function works correctly!")

    except ClientError as e:
        error_code = e.response['Error']['Code']
        error_message = e.response['Error']['Message']
        print(f"✗ AWS Error: {error_code}")
        print(f"   Message: {error_message}")

        if error_code == 'AccessDeniedException':
            print("\n   → The IAM user doesn't have permission to read this secret")
            print("   → Check IAM policy includes: secretsmanager:GetSecretValue")
        elif error_code == 'ResourceNotFoundException':
            print("\n   → Secret not found")
            print("   → Check the secret name is correct")

        exit(1)

    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
