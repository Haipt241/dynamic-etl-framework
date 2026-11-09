# S3 Upload Tool

A comprehensive tool for uploading files to the VibeCFO S3 bucket (`arn:aws:s3:::vibecfo-bucket`).

## Features

- Upload single files or entire directories
- Set custom metadata and storage classes
- Public/private file access control
- List, view, and delete S3 objects
- Both CLI and Python API interfaces
- Progress feedback and error handling
- Automatic content-type detection

## Prerequisites

1. **AWS Credentials**: Ensure your AWS credentials are configured. The tool supports:
   - AWS CLI configuration (`aws configure`)
   - Environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
   - IAM roles (when running on EC2/ECS/Lambda)

2. **IAM Permissions**: Your AWS credentials need these S3 permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:DeleteObject",
           "s3:ListBucket"
         ],
         "Resource": [
           "arn:aws:s3:::vibecfo-bucket",
           "arn:aws:s3:::vibecfo-bucket/*"
         ]
       }
     ]
   }
   ```

3. **Dependencies**: boto3 is already in your requirements.txt

## CLI Usage

### Upload a Single File

```bash
# Basic upload (uses filename as S3 key)
python s3_upload_tool.py upload myfile.txt

# Upload to specific S3 path
python s3_upload_tool.py upload myfile.txt --key reports/2024/myfile.txt

# Upload with metadata
python s3_upload_tool.py upload data.json --metadata '{"source":"etl","version":"1.0","client":"acme"}'

# Upload as public file
python s3_upload_tool.py upload report.pdf --key public/reports/report.pdf --public

# Upload with different storage class
python s3_upload_tool.py upload archive.zip --storage-class GLACIER
```

### Upload a Directory

```bash
# Upload entire directory (recursive)
python s3_upload_tool.py upload-dir ./reports

# Upload to specific S3 prefix (folder)
python s3_upload_tool.py upload-dir ./reports --prefix backups/reports/2024

# Upload only specific file types
python s3_upload_tool.py upload-dir ./data --pattern "*.csv" --prefix data/csv

# Upload directory non-recursively
python s3_upload_tool.py upload-dir ./files --no-recursive

# Upload directory as public files
python s3_upload_tool.py upload-dir ./public_assets --prefix public --public
```

### List Objects

```bash
# List all objects
python s3_upload_tool.py list

# List objects with specific prefix
python s3_upload_tool.py list --prefix reports/2024/

# Limit number of results
python s3_upload_tool.py list --prefix data/ --max-keys 100
```

### View Object Info

```bash
# Get metadata for a specific object
python s3_upload_tool.py info reports/2024/myfile.txt
```

### Delete Object

```bash
# Delete a specific object
python s3_upload_tool.py delete reports/old_file.txt
```

### Bucket Information

```bash
# Show bucket details
python s3_upload_tool.py bucket-info
```

## Python API Usage

### Basic Usage

```python
from s3_upload_tool import S3Uploader

# Initialize uploader
uploader = S3Uploader()

# Upload a file
result = uploader.upload_file('myfile.txt')
print(f"Uploaded to: {result['s3_url']}")

# Upload to specific S3 path
result = uploader.upload_file(
    'report.pdf',
    s3_key='reports/2024/january/report.pdf'
)
```

### Advanced Upload Options

```python
from s3_upload_tool import S3Uploader

uploader = S3Uploader()

# Upload with metadata
result = uploader.upload_file(
    'data.json',
    s3_key='data/processed/data.json',
    metadata={
        'source': 'etl_pipeline',
        'version': '1.0',
        'client_id': 'CLIENT123',
        'processed_date': '2024-01-15'
    },
    storage_class='INTELLIGENT_TIERING'
)

# Upload as public file
result = uploader.upload_file(
    'public_report.pdf',
    s3_key='public/reports/report.pdf',
    public=True
)
print(f"Public URL: {result['https_url']}")
```

### Upload Directory

```python
from s3_upload_tool import S3Uploader

uploader = S3Uploader()

# Upload entire directory
results = uploader.upload_directory(
    './reports',
    s3_prefix='backups/reports'
)

# Upload only CSV files
results = uploader.upload_directory(
    './data',
    s3_prefix='data/csv',
    file_pattern='*.csv',
    metadata={'type': 'csv_data'}
)

# Upload with custom settings
results = uploader.upload_directory(
    './archives',
    s3_prefix='archives/2024',
    recursive=True,
    file_pattern='*.zip',
    storage_class='GLACIER',
    metadata={'archive': 'true'}
)

print(f"Uploaded {len(results)} files")
```

### List and Manage Objects

```python
from s3_upload_tool import S3Uploader

uploader = S3Uploader()

# List objects
objects = uploader.list_objects(prefix='reports/2024/')
for obj in objects:
    print(f"{obj['key']}: {obj['size']} bytes")

# Get object metadata
metadata = uploader.get_object_metadata('reports/2024/myfile.txt')
print(f"Size: {metadata['size']}")
print(f"Last modified: {metadata['last_modified']}")
print(f"Content type: {metadata['content_type']}")

# Delete object
uploader.delete_object('old/file.txt')
```

## Integration Examples

### ETL Pipeline Integration

```python
from s3_upload_tool import S3Uploader
import pandas as pd
from datetime import datetime

def backup_etl_results(df, client_id, job_id):
    """Backup ETL results to S3."""
    # Save DataFrame to temporary file
    temp_file = f'/tmp/etl_result_{job_id}.csv'
    df.to_csv(temp_file, index=False)

    # Upload to S3
    uploader = S3Uploader()
    timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
    s3_key = f'etl_results/{client_id}/{timestamp}/result_{job_id}.csv'

    result = uploader.upload_file(
        temp_file,
        s3_key=s3_key,
        metadata={
            'client_id': client_id,
            'job_id': str(job_id),
            'timestamp': timestamp,
            'row_count': str(len(df))
        }
    )

    # Clean up temp file
    import os
    os.remove(temp_file)

    return result['s3_url']

# Usage
df = pd.DataFrame({'data': [1, 2, 3]})
s3_url = backup_etl_results(df, 'CLIENT123', 456)
print(f"Backed up to: {s3_url}")
```

### Log Backup

```python
from s3_upload_tool import S3Uploader
from datetime import datetime

def backup_logs(log_directory, client_id):
    """Backup all log files to S3."""
    uploader = S3Uploader()
    date_str = datetime.utcnow().strftime('%Y-%m-%d')

    results = uploader.upload_directory(
        log_directory,
        s3_prefix=f'logs/{client_id}/{date_str}',
        file_pattern='*.log',
        metadata={
            'client_id': client_id,
            'backup_date': date_str,
            'type': 'logs'
        },
        storage_class='INTELLIGENT_TIERING'
    )

    successful = sum(1 for r in results if 'error' not in r)
    return f"Backed up {successful}/{len(results)} log files"

# Usage
result = backup_logs('/var/log/etl', 'CLIENT123')
print(result)
```

### Database Backup

```python
from s3_upload_tool import S3Uploader
import subprocess
from datetime import datetime

def backup_database_to_s3(db_name, client_id):
    """Backup database dump to S3."""
    timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
    dump_file = f'/tmp/{db_name}_backup_{timestamp}.sql'

    # Create database dump (example using mysqldump)
    subprocess.run([
        'mysqldump',
        '-u', 'username',
        '-p', 'password',
        db_name,
        '--result-file', dump_file
    ])

    # Upload to S3
    uploader = S3Uploader()
    s3_key = f'database_backups/{client_id}/{db_name}/{timestamp}.sql'

    result = uploader.upload_file(
        dump_file,
        s3_key=s3_key,
        metadata={
            'database': db_name,
            'client_id': client_id,
            'backup_timestamp': timestamp
        },
        storage_class='GLACIER'  # Use cheaper storage for backups
    )

    # Clean up
    import os
    os.remove(dump_file)

    return result['s3_url']
```

## Storage Classes

Choose the appropriate storage class based on access patterns:

- **STANDARD**: Frequently accessed data (default)
- **INTELLIGENT_TIERING**: Automatically moves data between access tiers
- **GLACIER**: Archive data with retrieval times of minutes to hours
- **DEEP_ARCHIVE**: Lowest cost for long-term archive (12-hour retrieval)

## Error Handling

The tool provides clear error messages for common issues:

```python
from s3_upload_tool import S3Uploader

try:
    uploader = S3Uploader()
    result = uploader.upload_file('myfile.txt')
except FileNotFoundError as e:
    print(f"File not found: {e}")
except Exception as e:
    print(f"Upload failed: {e}")
```

## Environment Variables

You can customize the bucket and region using environment variables:

```bash
export AWS_DEFAULT_REGION=us-west-2
python s3_upload_tool.py upload myfile.txt
```

Or in Python:

```python
from s3_upload_tool import S3Uploader

# Use different bucket or region
uploader = S3Uploader(
    bucket_name='other-bucket',
    region_name='us-west-2'
)
```

## Best Practices

1. **Use meaningful S3 keys**: Organize files with clear folder structures
   ```
   s3://vibecfo-bucket/
   ├── etl_results/CLIENT123/2024-01-15/...
   ├── logs/CLIENT456/2024-01-15/...
   └── backups/databases/...
   ```

2. **Add metadata**: Include useful information for tracking
   ```python
   metadata={
       'client_id': 'CLIENT123',
       'job_id': '456',
       'source': 'etl_pipeline',
       'version': '1.0'
   }
   ```

3. **Choose appropriate storage class**: Use GLACIER for archives to save costs

4. **Use prefixes for organization**: Group related files using S3 prefixes (folders)

5. **Handle errors gracefully**: Always wrap uploads in try-except blocks

## Troubleshooting

### Credentials Not Found
```
Error: AWS credentials not found
```
**Solution**: Configure AWS credentials using `aws configure` or set environment variables

### Access Denied
```
Error: Access denied to bucket 'vibecfo-bucket'
```
**Solution**: Check IAM permissions for your AWS credentials

### Bucket Not Found
```
Error: Bucket 'vibecfo-bucket' not found
```
**Solution**: Verify the bucket name and ensure it exists in your AWS account

## Support

For issues or questions:
- Check AWS credentials configuration
- Verify IAM permissions
- Review error messages for specific guidance
- Check AWS CloudWatch logs for detailed error information
