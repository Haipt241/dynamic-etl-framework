"""
S3 Upload Tool for VibeCFO Bucket
Provides both programmatic and CLI interfaces for uploading files to S3.
"""

import os
import sys
import boto3
from botocore.exceptions import ClientError, NoCredentialsError
from typing import Optional, Dict, List
import mimetypes
from pathlib import Path
import json
from datetime import datetime


class S3Uploader:
    """
    S3 Uploader class for managing file uploads to the vibecfo-bucket.
    """

    def __init__(self, bucket_name: str = "vibecfo-bucket", region_name: str = "us-east-1"):
        """
        Initialize the S3 uploader.

        Args:
            bucket_name: The S3 bucket name (default: vibecfo-bucket)
            region_name: AWS region (default: us-east-1)
        """
        self.bucket_name = bucket_name
        self.region_name = region_name
        self.s3_client = None
        self._initialize_client()

    def _initialize_client(self):
        """Initialize the S3 client with error handling."""
        try:
            self.s3_client = boto3.client('s3', region_name=self.region_name)
            # Test credentials by checking bucket access
            self.s3_client.head_bucket(Bucket=self.bucket_name)
        except NoCredentialsError:
            raise Exception(
                "AWS credentials not found. Please configure your credentials using:\n"
                "1. AWS CLI: aws configure\n"
                "2. Environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY\n"
                "3. IAM role (if running on EC2/ECS/Lambda)"
            )
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == '403':
                raise Exception(f"Access denied to bucket '{self.bucket_name}'. Check your IAM permissions.")
            elif error_code == '404':
                raise Exception(f"Bucket '{self.bucket_name}' not found.")
            else:
                raise Exception(f"Error connecting to S3: {e}")

    def upload_file(
        self,
        file_path: str,
        s3_key: Optional[str] = None,
        metadata: Optional[Dict[str, str]] = None,
        public: bool = False,
        storage_class: str = 'STANDARD'
    ) -> Dict[str, str]:
        """
        Upload a file to S3.

        Args:
            file_path: Local path to the file to upload
            s3_key: S3 object key (path in bucket). If None, uses the filename
            metadata: Optional metadata dictionary to attach to the object
            public: If True, makes the object publicly readable
            storage_class: S3 storage class (STANDARD, INTELLIGENT_TIERING, GLACIER, etc.)

        Returns:
            Dict containing upload information (bucket, key, url, size)

        Raises:
            FileNotFoundError: If the file doesn't exist
            Exception: For S3 upload errors
        """
        # Validate file exists
        if not os.path.isfile(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")

        # Use filename as key if not provided
        if s3_key is None:
            s3_key = os.path.basename(file_path)

        # Get file size
        file_size = os.path.getsize(file_path)

        # Determine content type
        content_type, _ = mimetypes.guess_type(file_path)
        if content_type is None:
            content_type = 'application/octet-stream'

        # Prepare upload arguments
        extra_args = {
            'ContentType': content_type,
            'StorageClass': storage_class
        }

        # Add metadata if provided
        if metadata:
            extra_args['Metadata'] = metadata

        # Set ACL if public
        if public:
            extra_args['ACL'] = 'public-read'

        try:
            print(f"Uploading {file_path} to s3://{self.bucket_name}/{s3_key}...")

            # Upload the file
            self.s3_client.upload_file(
                file_path,
                self.bucket_name,
                s3_key,
                ExtraArgs=extra_args
            )

            # Generate S3 URL
            s3_url = f"s3://{self.bucket_name}/{s3_key}"
            https_url = f"https://{self.bucket_name}.s3.{self.region_name}.amazonaws.com/{s3_key}"

            result = {
                'bucket': self.bucket_name,
                'key': s3_key,
                's3_url': s3_url,
                'https_url': https_url if public else None,
                'size_bytes': file_size,
                'content_type': content_type,
                'storage_class': storage_class,
                'timestamp': datetime.utcnow().isoformat()
            }

            print(f"✓ Upload successful!")
            print(f"  S3 URI: {s3_url}")
            print(f"  Size: {self._format_size(file_size)}")

            return result

        except ClientError as e:
            raise Exception(f"Failed to upload file to S3: {e}")

    def upload_directory(
        self,
        directory_path: str,
        s3_prefix: str = "",
        recursive: bool = True,
        file_pattern: Optional[str] = None,
        **upload_kwargs
    ) -> List[Dict[str, str]]:
        """
        Upload all files in a directory to S3.

        Args:
            directory_path: Local directory path
            s3_prefix: Prefix to add to all S3 keys (folder in bucket)
            recursive: If True, includes subdirectories
            file_pattern: Optional glob pattern to filter files (e.g., "*.txt", "*.json")
            **upload_kwargs: Additional arguments passed to upload_file()

        Returns:
            List of upload result dictionaries
        """
        if not os.path.isdir(directory_path):
            raise NotADirectoryError(f"Directory not found: {directory_path}")

        directory = Path(directory_path)
        results = []

        # Get files based on pattern and recursion
        if file_pattern:
            if recursive:
                files = directory.rglob(file_pattern)
            else:
                files = directory.glob(file_pattern)
        else:
            if recursive:
                files = directory.rglob("*")
            else:
                files = directory.glob("*")

        # Filter to only actual files
        files = [f for f in files if f.is_file()]

        if not files:
            print(f"No files found in {directory_path}")
            return results

        print(f"Found {len(files)} file(s) to upload")

        for file_path in files:
            # Calculate relative path for S3 key
            relative_path = file_path.relative_to(directory)
            s3_key = os.path.join(s3_prefix, str(relative_path)).replace("\\", "/")

            try:
                result = self.upload_file(str(file_path), s3_key=s3_key, **upload_kwargs)
                results.append(result)
            except Exception as e:
                print(f"✗ Failed to upload {file_path}: {e}")
                results.append({
                    'file': str(file_path),
                    'error': str(e),
                    'status': 'failed'
                })

        successful = sum(1 for r in results if 'error' not in r)
        print(f"\n✓ Upload complete: {successful}/{len(results)} files uploaded successfully")

        return results

    def list_objects(self, prefix: str = "", max_keys: int = 1000) -> List[Dict]:
        """
        List objects in the S3 bucket.

        Args:
            prefix: Filter objects by prefix (folder path)
            max_keys: Maximum number of objects to return

        Returns:
            List of object metadata dictionaries
        """
        try:
            response = self.s3_client.list_objects_v2(
                Bucket=self.bucket_name,
                Prefix=prefix,
                MaxKeys=max_keys
            )

            if 'Contents' not in response:
                return []

            objects = []
            for obj in response['Contents']:
                objects.append({
                    'key': obj['Key'],
                    'size': obj['Size'],
                    'last_modified': obj['LastModified'].isoformat(),
                    's3_url': f"s3://{self.bucket_name}/{obj['Key']}"
                })

            return objects

        except ClientError as e:
            raise Exception(f"Failed to list objects: {e}")

    def read_file(self, s3_key: str, encoding: str = 'utf-8') -> str:
        """
        Read a file's contents from S3 as a string.

        Args:
            s3_key: S3 object key to read
            encoding: Text encoding (default: utf-8)

        Returns:
            File contents as string

        Raises:
            Exception: For S3 read errors
        """
        try:
            response = self.s3_client.get_object(Bucket=self.bucket_name, Key=s3_key)
            contents = response['Body'].read().decode(encoding)
            print(f"✓ Read {len(contents)} characters from s3://{self.bucket_name}/{s3_key}")
            return contents

        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'NoSuchKey':
                raise Exception(f"Object not found: s3://{self.bucket_name}/{s3_key}")
            else:
                raise Exception(f"Failed to read file from S3: {e}")

    def write_file(
        self,
        s3_key: str,
        contents: str,
        encoding: str = 'utf-8',
        metadata: Optional[Dict[str, str]] = None
    ) -> Dict[str, str]:
        """
        Write string contents directly to S3.

        Args:
            s3_key: S3 object key to write to
            contents: String contents to write
            encoding: Text encoding (default: utf-8)
            metadata: Optional metadata dictionary

        Returns:
            Dict containing upload information

        Raises:
            Exception: For S3 write errors
        """
        try:
            # Convert string to bytes
            data = contents.encode(encoding)

            # Prepare upload arguments
            extra_args = {
                'ContentType': 'text/plain'
            }

            if metadata:
                extra_args['Metadata'] = metadata

            print(f"Writing {len(data)} bytes to s3://{self.bucket_name}/{s3_key}...")

            # Upload the data
            self.s3_client.put_object(
                Bucket=self.bucket_name,
                Key=s3_key,
                Body=data,
                **extra_args
            )

            result = {
                'bucket': self.bucket_name,
                'key': s3_key,
                's3_url': f"s3://{self.bucket_name}/{s3_key}",
                'size_bytes': len(data),
                'timestamp': datetime.utcnow().isoformat()
            }

            print(f"✓ Write successful! Size: {self._format_size(len(data))}")
            return result

        except ClientError as e:
            raise Exception(f"Failed to write file to S3: {e}")

    def update_file(
        self,
        s3_key: str,
        contents: str,
        encoding: str = 'utf-8',
        metadata: Optional[Dict[str, str]] = None,
        backup: bool = True
    ) -> Dict[str, str]:
        """
        Update an existing file in S3, optionally creating a backup.

        Args:
            s3_key: S3 object key to update
            contents: New contents
            encoding: Text encoding (default: utf-8)
            metadata: Optional metadata dictionary
            backup: If True, creates/replaces a single backup file (.backup_latest)
                   This ensures only 1 backup per integration, not multiple timestamped backups

        Returns:
            Dict containing update information

        Raises:
            Exception: For S3 update errors
        """
        # Create backup if requested
        file_exists = False
        if backup:
            try:
                # Check if file exists
                self.s3_client.head_object(Bucket=self.bucket_name, Key=s3_key)
                file_exists = True

                # Create/replace single backup (no timestamp = 1 backup per token)
                backup_key = f"{s3_key}.backup_latest"

                self.s3_client.copy_object(
                    Bucket=self.bucket_name,
                    CopySource={'Bucket': self.bucket_name, 'Key': s3_key},
                    Key=backup_key
                )
                print(f"✓ Created/updated backup: s3://{self.bucket_name}/{backup_key}")
            except ClientError as e:
                if e.response['Error']['Code'] == '404':
                    file_exists = False
                    print(f"ℹ File doesn't exist yet, will create backup after writing")
                else:
                    print(f"Warning: Could not create backup: {e}")

        # Write the new contents
        result = self.write_file(s3_key, contents, encoding, metadata)

        # If file didn't exist and backup was requested, create backup NOW from newly written file
        if backup and not file_exists:
            try:
                backup_key = f"{s3_key}.backup_latest"
                self.s3_client.copy_object(
                    Bucket=self.bucket_name,
                    CopySource={'Bucket': self.bucket_name, 'Key': s3_key},
                    Key=backup_key
                )
                print(f"✓ Created initial backup: s3://{self.bucket_name}/{backup_key}")
            except Exception as e:
                print(f"⚠ Warning: Could not create initial backup: {e}")

        return result

    def delete_object(self, s3_key: str) -> bool:
        """
        Delete an object from S3.

        Args:
            s3_key: S3 object key to delete

        Returns:
            True if successful
        """
        try:
            self.s3_client.delete_object(Bucket=self.bucket_name, Key=s3_key)
            print(f"✓ Deleted s3://{self.bucket_name}/{s3_key}")
            return True
        except ClientError as e:
            raise Exception(f"Failed to delete object: {e}")

    def get_object_metadata(self, s3_key: str) -> Dict:
        """
        Get metadata for an S3 object.

        Args:
            s3_key: S3 object key

        Returns:
            Dictionary containing object metadata
        """
        try:
            response = self.s3_client.head_object(Bucket=self.bucket_name, Key=s3_key)
            return {
                'key': s3_key,
                'size': response['ContentLength'],
                'content_type': response.get('ContentType'),
                'last_modified': response['LastModified'].isoformat(),
                'metadata': response.get('Metadata', {}),
                's3_url': f"s3://{self.bucket_name}/{s3_key}"
            }
        except ClientError as e:
            raise Exception(f"Failed to get object metadata: {e}")

    @staticmethod
    def _format_size(size_bytes: int) -> str:
        """Format bytes into human-readable size."""
        for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
            if size_bytes < 1024.0:
                return f"{size_bytes:.2f} {unit}"
            size_bytes /= 1024.0
        return f"{size_bytes:.2f} PB"


def main():
    """CLI interface for the S3 upload tool."""
    import argparse

    parser = argparse.ArgumentParser(
        description='Upload files to S3 bucket: vibecfo-bucket',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Upload a single file
  python s3_upload_tool.py upload myfile.txt

  # Upload to specific S3 path
  python s3_upload_tool.py upload myfile.txt --key reports/2024/myfile.txt

  # Upload directory
  python s3_upload_tool.py upload-dir ./reports --prefix backups/reports

  # Upload with metadata
  python s3_upload_tool.py upload data.json --metadata '{"source":"etl","version":"1.0"}'

  # List objects
  python s3_upload_tool.py list --prefix reports/

  # Delete object
  python s3_upload_tool.py delete reports/old_file.txt
        """
    )

    subparsers = parser.add_subparsers(dest='command', help='Command to execute')

    # Upload file command
    upload_parser = subparsers.add_parser('upload', help='Upload a file')
    upload_parser.add_argument('file', help='File path to upload')
    upload_parser.add_argument('--key', help='S3 key (path in bucket)')
    upload_parser.add_argument('--metadata', help='JSON string of metadata')
    upload_parser.add_argument('--public', action='store_true', help='Make file publicly readable')
    upload_parser.add_argument('--storage-class', default='STANDARD',
                              choices=['STANDARD', 'INTELLIGENT_TIERING', 'GLACIER', 'DEEP_ARCHIVE'],
                              help='S3 storage class')

    # Upload directory command
    upload_dir_parser = subparsers.add_parser('upload-dir', help='Upload a directory')
    upload_dir_parser.add_argument('directory', help='Directory path to upload')
    upload_dir_parser.add_argument('--prefix', default='', help='S3 prefix (folder)')
    upload_dir_parser.add_argument('--pattern', help='File pattern (e.g., *.txt)')
    upload_dir_parser.add_argument('--no-recursive', action='store_true', help='Do not recurse subdirectories')
    upload_dir_parser.add_argument('--public', action='store_true', help='Make files publicly readable')

    # List objects command
    list_parser = subparsers.add_parser('list', help='List objects in bucket')
    list_parser.add_argument('--prefix', default='', help='Filter by prefix')
    list_parser.add_argument('--max-keys', type=int, default=1000, help='Maximum objects to list')

    # Delete object command
    delete_parser = subparsers.add_parser('delete', help='Delete an object')
    delete_parser.add_argument('key', help='S3 key to delete')

    # Get metadata command
    info_parser = subparsers.add_parser('info', help='Get object metadata')
    info_parser.add_argument('key', help='S3 key')

    # Bucket info
    bucket_parser = subparsers.add_parser('bucket-info', help='Show bucket information')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    try:
        uploader = S3Uploader()

        if args.command == 'upload':
            metadata = None
            if args.metadata:
                metadata = json.loads(args.metadata)

            result = uploader.upload_file(
                args.file,
                s3_key=args.key,
                metadata=metadata,
                public=args.public,
                storage_class=args.storage_class
            )
            print(f"\nUpload details:")
            print(json.dumps(result, indent=2))

        elif args.command == 'upload-dir':
            results = uploader.upload_directory(
                args.directory,
                s3_prefix=args.prefix,
                recursive=not args.no_recursive,
                file_pattern=args.pattern,
                public=args.public
            )

        elif args.command == 'list':
            objects = uploader.list_objects(prefix=args.prefix, max_keys=args.max_keys)
            if objects:
                print(f"\nObjects in s3://{uploader.bucket_name}/{args.prefix}:")
                print(f"{'Key':<50} {'Size':<15} {'Last Modified':<25}")
                print("-" * 90)
                for obj in objects:
                    print(f"{obj['key']:<50} {uploader._format_size(obj['size']):<15} {obj['last_modified']:<25}")
                print(f"\nTotal: {len(objects)} object(s)")
            else:
                print(f"No objects found with prefix '{args.prefix}'")

        elif args.command == 'delete':
            uploader.delete_object(args.key)

        elif args.command == 'info':
            metadata = uploader.get_object_metadata(args.key)
            print(json.dumps(metadata, indent=2))

        elif args.command == 'bucket-info':
            print(f"Bucket: {uploader.bucket_name}")
            print(f"Region: {uploader.region_name}")
            print(f"ARN: arn:aws:s3:::{uploader.bucket_name}")

        return 0

    except Exception as e:
        print(f"✗ Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
