#!/usr/bin/env python3
"""
Upload token to AWS S3

This script uploads a token file to AWS S3 bucket in the correct folder structure.
"""

import os
import sys
from .s3_upload_tool import S3Uploader
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def upload_token_to_s3(token_file_path, integration_name):
    """
    Upload a token file to AWS S3 in the correct folder structure

    Args:
        token_file_path: Path to the token file
        integration_name: Name of the integration (e.g., "wfm", "myob")
    """
    # Get AWS configuration from environment variables
    s3_bucket_name = os.getenv('AWS_S3_BUCKET_NAME')
    s3_region = os.getenv('AWS_S3_REGION', 'ap-northeast-3')

    if not s3_bucket_name:
        print("Error: AWS_S3_BUCKET_NAME environment variable not set")
        sys.exit(1)

    # Get token file name
    token_file_name = os.path.basename(token_file_path)

    # Create S3 key with correct folder structure
    s3_prefix = os.getenv('AWS_S3_PREFIX', 'tokens')
    s3_key = f"{s3_prefix}/{integration_name.lower()}/{token_file_name}"

    try:
        # Initialize S3Uploader
        print(f"Initializing S3Uploader with region: {s3_region}")
        s3_uploader = S3Uploader(bucket_name=s3_bucket_name, region_name=s3_region)

        # Upload token file
        print(f"Uploading {token_file_path} to s3://{s3_bucket_name}/{s3_key}...")
        result = s3_uploader.upload_file(
            token_file_path,
            s3_key=s3_key,
            metadata={"content-type": "application/json"},
            storage_class='STANDARD'
        )

        print(f"✅ Token successfully uploaded to AWS S3!")
        print(f"S3 URI: {result['s3_url']}")
        return True

    except Exception as e:
        print(f"❌ Error uploading token to S3: {str(e)}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python upload_token_to_s3.py <token_file_path> <integration_name>")
        print("Example: python upload_token_to_s3.py TIGERS_CLIENT6923_1755241340.txt wfm")
        sys.exit(1)

    token_file_path = sys.argv[1]
    integration_name = sys.argv[2]

    if not os.path.exists(token_file_path):
        print(f"Error: Token file {token_file_path} does not exist")
        sys.exit(1)

    upload_token_to_s3(token_file_path, integration_name)