import os

# XERO API Credentials
XERO_CLIENT_ID = os.getenv("XERO_CLIENT_ID", "")
XERO_CLIENT_SECRET = os.getenv("XERO_CLIENT_SECRET", "")

# QBO API Credentials
QBO_CLIENT_ID = os.getenv("QBO_CLIENT_ID", "")
QBO_CLIENT_SECRET = os.getenv("QBO_CLIENT_SECRET", "")

# SQL SERVER Credentials
SQL_SERVER_USERNAME = os.getenv("SQL_SERVER_USERNAME", "")
SQL_SERVER_PASSWORD = os.getenv("SQL_SERVER_PASSWORD", "")
SQL_SERVER_NAME = os.getenv("SQL_SERVER_NAME", "")
SQL_SERVER_DATABASE = os.getenv("SQL_SERVER_DATABASE", "")

# SSL Certificate (not used by AWS RDS, but kept for legacy code references)
MYSQL_SERVER_SSL_CERT = os.path.join(os.path.dirname(__file__), 'DigiCertGlobalRootCA.crt 2.pem')

AWS_RDS_HOST = os.getenv("AWS_RDS_HOST", "")
AWS_RDS_USERNAME = os.getenv("AWS_RDS_USERNAME", "")
AWS_RDS_SECRET_NAME = os.getenv("AWS_RDS_SECRET_NAME", "")
AWS_RDS_REGION = 'ap-northeast-3'
AWS_RDS_DATABASE = os.getenv("AWS_RDS_DATABASE", "")

# AWS IAM Credentials (fallback if not in environment variables)
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID", "")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY", "")

# Token File Path
STORAGE_ACCOUNT_NAME = os.getenv("STORAGE_ACCOUNT_NAME", "")
STORAGE_ACCOUNT_KEY = os.getenv("STORAGE_ACCOUNT_KEY", "")
BLOB_CONTAINER_NAME = os.getenv("BLOB_CONTAINER_NAME", "")
FILE_SHARE_NAME = os.getenv("FILE_SHARE_NAME", "")

#POWERBI API Credentials
PBI_BASEURL = os.getenv("PBI_BASEURL", "")
PBI_USERNAME = os.getenv("PBI_USERNAME", "")
PBI_PASSWORD = os.getenv("PBI_PASSWORD", "")
PBI_SCOPE = 'https://analysis.windows.net/powerbi/api'
PBI_CLIENT_ID = os.getenv("PBI_CLIENT_ID", "")
PBI_CLIENT_SECRET = os.getenv("PBI_CLIENT_SECRET", "")
PBI_FILE_PATH = os.getenv("PBI_FILE_PATH", "")

# Integration Feature Flags
ENABLE_CMS_CHECK = False        # Enable/disable CMS status checking before running integration
ENABLE_POWERBI_INTEGRATION = False  # Enable/disable PowerBI template upload and dataset refresh

# Validation Settings
ENABLE_REQUIRED_PARAMS_CHECK = False  # Enable/disable required parameters validation (set to False for dev with defaults)

# Test Settings
IS_MAX_TEST = False              # Enable/disable test record limit
MAX_TEST_RECORDS = 10          # Maximum number of records to process during testing

# SSL Configuration
SSL_VERIFY = True              # Enable/disable SSL certificate verification for HTTPS requests
                                # Set to False for development with self-signed certificates
USE_AWS_DB = True

# AWS Container Pricing for cost calculation
AWS_CONTAINER_PRICING = {
    'us-east-1': {
        'vcpu_per_hour': 0.04048,
        'memory_per_gb_per_hour': 0.004445,
        'aurora_io_price_per_million': 0.20
    },
    'ap-southeast-2': {
        'vcpu_per_hour': 0.04048,
        'memory_per_gb_per_hour': 0.004445,
        'aurora_io_price_per_million': 0.24
    },
    'ap-northeast-3': {
        'vcpu_per_hour': 0.04666,
        'memory_per_gb_per_hour': 0.005122,
        'aurora_io_price_per_million': 0.24
    }
}

# Container Cost Tracking Settings
CONTAINER_COST_TRACKING = {
    'enabled': True,
    'default_region': 'ap-southeast-2',
    'container_size_mapping': {
        'small': {'vcpu': 0.25, 'memory_gb': 0.5},
        'medium': {'vcpu': 1.0, 'memory_gb': 2.0},
        'large': {'vcpu': 2.0, 'memory_gb': 4.0},
        'xlarge': {'vcpu': 4.0, 'memory_gb': 8.0}
    },
    # Database cost estimation multipliers
    'mysql_io_multipliers': {
        'insert_write_ops': 2,  # Data + index writes
        'update_write_ops': 2,  # Data + index writes
        'select_read_ops': 1    # Read operations
    },
    # Resource monitoring settings
    'resource_tracking': {
        'enabled': True,
        'sample_interval_seconds': 10.0,
        'fallback_metrics': {
            'peak_cpu_percent': 75.0,
            'avg_cpu_percent': 50.0,
            'cpu_utilization': 0.8,
            'memory_utilization': 0.6
        }
    }
}

# Query Monitoring Settings
QUERY_MONITORING_ENABLED = False
ETL_API_URL = os.getenv("ETL_API_URL", "")
ETL_API_KEY = os.getenv("ETL_API_KEY", "")
