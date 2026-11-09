#!/usr/bin/env python3
"""
Accredo API Sample Data Extractor

This script calls Accredo API endpoints and saves response data
to the sample data directory without fetching metadata.

Author: Etani ETL Integration
Date: 2026-01-14
"""

import os
import json
import requests
import time
import urllib3
from datetime import datetime
from pathlib import Path

# Import SSL configuration
from config import SSL_VERIFY

# Disable SSL warnings for expired certificates
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Configuration from provided credentials
ACCREDO_CONFIG = {
    "company_name": "CPP",
    "api_client_id": "zUrGeLfrFqh6jcXl",
    "username": "Power-BI",
    "password": "REDACTED",
    "base_url": "https://accredo.custompak.co.nz:6569/saturn/odata4/v1",
    "client_id": "NEXIA_CLIENT1698",
    "organisation_id": "5612",
    "company_code": "CPP"  # Using company name as company code
}

# All endpoints to sample
ENDPOINTS = [
    "APBudget", "APCreditor", "APExpenseBudget", "APExpenseGroup",
    "APShipmentList", "APShipments", "APTransaction", "ARBudget",
    "ARCustomer", "ARSalesArea", "ARSalesAreaBudget", "ARSalesGroup",
    "ARSalesGroupBudget", "ARSalesPerson", "ARSalesPersonBudget",
    "ARTransaction", "CBAnalysisBudget", "CBAutomaticPayment",
    "CBBankAccount", "CBBankingItems", "CBExpenseCode", "CBTransaction",
    "CBTransfer", "COBranch", "CODepartment", "COUser", "FAAsset",
    "FATransaction", "GLAccount", "GLTransaction", "GSTTransaction",
    "ICBudget", "ICManufactureBatch", "ICProduct", "ICStockGroup",
    "ICTransaction", "INInvoice", "JCBatch", "JCBudget", "JCDisbursement",
    "JCJob", "JCTimeSheet", "JCTransaction", "OEOrder", "POOrder", "POOrderList"
]

# Sample data directory
SAMPLE_DATA_DIR = "/Users/haipham/DuAn/upwork/etani/etl-packages/dynamic_integrations/sample_data"


def get_oauth2_token():
    """
    Get OAuth2 access token using password grant flow
    """
    token_url = f"{ACCREDO_CONFIG['base_url'].replace('/odata4/v1', '')}/oauth2/v1/token"

    token_data = {
        "grant_type": "password",
        "client_id": ACCREDO_CONFIG["api_client_id"],
        "username": ACCREDO_CONFIG["username"],
        "password": ACCREDO_CONFIG["password"]
    }

    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json"
    }

    try:
        print(f"🔐 Attempting OAuth2 token request to: {token_url}")
        response = requests.post(token_url, data=token_data, headers=headers, timeout=30, verify=SSL_VERIFY)

        print(f"Token response status: {response.status_code}")
        print(f"Token response headers: {dict(response.headers)}")

        if response.status_code == 200:
            token_info = response.json()
            print(f"✅ OAuth2 token obtained successfully")
            return token_info.get("access_token")
        else:
            print(f"❌ Failed to get OAuth2 token: {response.status_code}")
            print(f"Response: {response.text}")
            return None

    except requests.exceptions.RequestException as e:
        print(f"❌ Error getting OAuth2 token: {str(e)}")
        return None


def make_api_request(endpoint, access_token=None, use_direct_auth=False):
    """
    Make API request to Accredo endpoint
    """
    company_code = ACCREDO_CONFIG["company_code"]
    base_url = ACCREDO_CONFIG["base_url"]

    # Construct URL
    url = f"{base_url}/Company('{company_code}')/{endpoint}"

    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "User-Agent": "Etani-ETL/1.0"
    }

    params = {}
    auth = None

    # Add authentication
    if access_token:
        params["access_token"] = access_token
    elif use_direct_auth:
        # Try basic auth as fallback
        auth = (ACCREDO_CONFIG["username"], ACCREDO_CONFIG["password"])

    # Add OData parameters to limit results
    params["$top"] = 1  # Only get 1 record for sample

    try:
        print(f"🔍 Requesting: {url}")
        print(f"   Parameters: {params}")

        if use_direct_auth and auth:
            response = requests.get(url, params=params, headers=headers, auth=auth, timeout=30, verify=SSL_VERIFY)
        else:
            response = requests.get(url, params=params, headers=headers, timeout=30, verify=SSL_VERIFY)

        print(f"   Status: {response.status_code}")

        if response.status_code == 200:
            return response.json()
        else:
            print(f"   Error response: {response.text}")
            return None

    except requests.exceptions.RequestException as e:
        print(f"   Request error: {str(e)}")
        return None


def make_direct_auth_request(endpoint):
    """
    Make API request using only basic authentication (no OAuth2)
    """
    company_code = ACCREDO_CONFIG["company_code"]
    base_url = ACCREDO_CONFIG["base_url"]

    # Construct URL
    url = f"{base_url}/Company('{company_code}')/{endpoint}"

    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "User-Agent": "Etani-ETL/1.0",
        "Cache-Control": "no-cache"
    }

    # Basic authentication
    auth = (ACCREDO_CONFIG["username"], ACCREDO_CONFIG["password"])

    # OData parameters to limit results
    params = {
        "$top": 1,  # Only get 1 record for sample
        "$format": "json"
    }

    try:
        print(f"🔍 Direct Auth Request: {url}")
        print(f"   Auth User: {ACCREDO_CONFIG['username']}")
        print(f"   Parameters: {params}")

        response = requests.get(
            url,
            params=params,
            headers=headers,
            auth=auth,
            timeout=30,
            verify=SSL_VERIFY
        )

        print(f"   Status: {response.status_code}")
        print(f"   Response Headers: {dict(response.headers)}")

        if response.status_code == 200:
            return response.json()
        elif response.status_code == 401:
            print(f"   🔒 Authentication failed - Invalid credentials")
            return None
        elif response.status_code == 403:
            print(f"   🚫 Access forbidden - User may not have permission")
            return None
        else:
            print(f"   ❌ Error response: {response.text[:500]}")
            return None

    except requests.exceptions.SSLError as e:
        print(f"   🔒 SSL Error: {str(e)}")
        return None
    except requests.exceptions.ConnectionError as e:
        print(f"   🌐 Connection Error: {str(e)}")
        return None
    except requests.exceptions.Timeout as e:
        print(f"   ⏰ Timeout Error: {str(e)}")
        return None
    except requests.exceptions.RequestException as e:
        print(f"   ❌ Request error: {str(e)}")
        return None




def save_sample_file(endpoint, api_command, sample_data):
    """
    Save sample data to file in specified format
    """
    # Create accredo subdirectory
    accredo_dir = Path(SAMPLE_DATA_DIR) / "accredo"
    accredo_dir.mkdir(parents=True, exist_ok=True)

    filename = f"{endpoint.lower()}_sample.text"
    filepath = accredo_dir / filename

    content = f"""# Accredo API Sample Data - {endpoint}
# Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## API Command Syntax:
{api_command}

## Sample Response:
{json.dumps(sample_data, indent=2, ensure_ascii=False) if sample_data else "No data available"}
"""

    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"💾 Saved: {filepath}")
        return True
    except Exception as e:
        print(f"❌ Error saving {filepath}: {str(e)}")
        return False


def test_direct_auth():
    """
    Test direct authentication with a single endpoint
    """
    print("🧪 Testing Direct Authentication")
    print("=" * 40)

    # Test with a simple endpoint
    test_endpoint = "COUser"  # Company Users - usually accessible

    print(f"Testing endpoint: {test_endpoint}")
    sample_data = make_direct_auth_request(test_endpoint)

    if sample_data:
        print("✅ Direct authentication successful!")
        print(f"Sample data keys: {list(sample_data.keys()) if sample_data else 'None'}")
        return True
    else:
        print("❌ Direct authentication failed")
        return False


def main(use_direct_auth_only=False):
    """
    Main execution function
    """
    print("🚀 Accredo API Sample Data Extractor")
    print("=" * 50)

    # Create sample data directory
    Path(SAMPLE_DATA_DIR).mkdir(parents=True, exist_ok=True)

    access_token = None

    if not use_direct_auth_only:
        # Try to get OAuth2 token
        print("\n1️⃣ Getting OAuth2 Access Token...")
        access_token = get_oauth2_token()

        if not access_token:
            print("⚠️  OAuth2 failed, will try direct authentication")
    else:
        print("\n1️⃣ Using Direct Authentication Only (skipping OAuth2)")

    # Process each endpoint
    print(f"\n2️⃣ Processing {len(ENDPOINTS)} Endpoints...")
    print("-" * 40)

    successful_samples = 0

    for i, endpoint in enumerate(ENDPOINTS, 1):
        print(f"\n[{i:02d}/{len(ENDPOINTS):02d}] Processing: {endpoint}")

        # Generate API command syntax
        if use_direct_auth_only:
            api_command = f"GET {{User::apiBaseURL}}Company('{{User::apiCompanyName}})/{endpoint}"
        else:
            api_command = "GET {{User::apiBaseURL}}Company('{{User::apiCompanyName}}')/" + endpoint + "?access_token={{User::apiAccessToken}}"

        # Choose authentication method
        sample_data = None
        if use_direct_auth_only:
            # Use only direct auth method
            sample_data = make_direct_auth_request(endpoint)
        else:
            # Try OAuth2 first, then fallback to direct auth
            if access_token:
                sample_data = make_api_request(endpoint, access_token=access_token)

            if not sample_data:
                sample_data = make_api_request(endpoint, use_direct_auth=True)

        # Save sample file regardless of whether we got data
        if save_sample_file(endpoint, api_command, sample_data):
            if sample_data:
                successful_samples += 1

        # Small delay to be respectful to the API
        time.sleep(0.5)

    # Summary
    print("\n" + "=" * 50)
    print("📊 SUMMARY")
    print(f"Total endpoints processed: {len(ENDPOINTS)}")
    print(f"Successful samples: {successful_samples}")
    print(f"Sample files location: {SAMPLE_DATA_DIR}/accredo/")
    print("✅ Script completed!")


if __name__ == "__main__":
    import sys

    # Check command line arguments
    if len(sys.argv) > 1:
        mode = sys.argv[1].lower()

        if mode == "test":
            # Test direct authentication only
            test_direct_auth()
        elif mode == "direct":
            # Run with direct authentication only
            main(use_direct_auth_only=True)
        elif mode == "oauth":
            # Run with OAuth2 only (no fallback)
            main(use_direct_auth_only=False)
        else:
            print("Usage:")
            print("  python get_accredo_metadata_samples.py          # Default: OAuth2 with direct auth fallback")
            print("  python get_accredo_metadata_samples.py test     # Test direct auth only")
            print("  python get_accredo_metadata_samples.py direct   # Use direct auth only (avoid license issues)")
            print("  python get_accredo_metadata_samples.py oauth    # Use OAuth2 with fallback")
    else:
        # Default: OAuth2 with direct auth fallback
        main()