#!/usr/bin/env python3
"""
VinSight API Metadata Fetcher
Fetches metadata for all VinSight endpoints and saves to JSON file
"""

import requests
import json
import time
from typing import Dict, List, Any

class VinSightMetadataFetcher:
    def __init__(self, base_url: str = "https://app.vinsight.net"):
        self.base_url = base_url
        self.session = requests.Session()
        self.endpoints = [
            "AuditLogEntries", "Addons", "Aliases", "AnalysisCodes", "AnalysisSetEntries",
            "AnalysisSets", "Attachments", "Categories", "Company", "Components",
            "ContactActivities", "ContactCategories", "Contacts", "Currencies", "Dashboards",
            "Divisions", "Documents", "DuePayments", "ExpressionDefinitions", "LedgerAccounts",
            "NeedsReview", "PaymentTerms", "ProductCategories", "ProductDetail",
            "PurchaseOrderItems", "PurchaseOrderReceiptItems", "PurchaseOrderReceipts",
            "PurchaseOrders", "Regions", "ResourceCollections", "Roles", "SalesOrderDespatches",
            "SalesOrderDespatchItems", "SalesOrderItems", "SalesOrders", "StockGroups",
            "StockItemComponents", "StockItemLocations", "StockItemMovements", "StockItemPrices",
            "StockItems", "StockLocations", "StockTransfers", "StoredObjects", "TaxAreas",
            "TaxRateEntries", "TaxRates", "Translations", "UnitsOfMeasure", "Users",
            "Varieties", "WineDesignations", "WinefileUpload", "WineryOperationTypes",
            "WineryOperationVarianceCodes", "Wines", "WineStatuses", "XeroTaxRates"
        ]

    def set_authentication(self, api_key: str = None, access_token: str = None):
        """Set authentication headers"""
        if access_token:
            self.session.headers.update({
                'Authorization': f'Bearer {access_token}',
                'Accept': 'application/json'
            })
        elif api_key:
            self.session.params.update({'api-key': api_key})
        else:
            print("Warning: No authentication provided")

    def fetch_endpoint_metadata(self, endpoint: str) -> Dict[str, Any]:
        """Fetch metadata for a specific endpoint"""
        url = f"{self.base_url}/{endpoint}"

        try:
            # Try both $metadata and regular call with Accept header
            metadata_url = f"{url}?$metadata"

            print(f"🔍 Fetching metadata for {endpoint}...")
            response = self.session.get(metadata_url, timeout=30)

            if response.status_code == 200:
                try:
                    return {
                        "endpoint": endpoint,
                        "url": url,
                        "metadata_url": metadata_url,
                        "status": "success",
                        "content_type": response.headers.get('content-type', ''),
                        "metadata": response.json() if 'json' in response.headers.get('content-type', '') else response.text
                    }
                except json.JSONDecodeError:
                    return {
                        "endpoint": endpoint,
                        "url": url,
                        "metadata_url": metadata_url,
                        "status": "success_text",
                        "content_type": response.headers.get('content-type', ''),
                        "metadata": response.text
                    }
            else:
                return {
                    "endpoint": endpoint,
                    "url": url,
                    "metadata_url": metadata_url,
                    "status": "error",
                    "status_code": response.status_code,
                    "error": response.text
                }

        except requests.exceptions.RequestException as e:
            return {
                "endpoint": endpoint,
                "url": url,
                "metadata_url": f"{url}?$metadata",
                "status": "error",
                "error": str(e)
            }

    def fetch_all_metadata(self) -> Dict[str, Any]:
        """Fetch metadata for all endpoints"""
        results = {
            "base_url": self.base_url,
            "total_endpoints": len(self.endpoints),
            "fetch_timestamp": time.strftime('%Y-%m-%d %H:%M:%S'),
            "endpoints": []
        }

        print(f"🚀 Starting metadata fetch for {len(self.endpoints)} endpoints...")

        for i, endpoint in enumerate(self.endpoints, 1):
            print(f"📡 Progress: {i}/{len(self.endpoints)} - {endpoint}")

            metadata = self.fetch_endpoint_metadata(endpoint)
            results["endpoints"].append(metadata)

            # Rate limiting - be gentle with their API
            time.sleep(0.5)

        # Summary
        successful = sum(1 for ep in results["endpoints"] if ep["status"] in ["success", "success_text"])
        failed = len(self.endpoints) - successful

        results["summary"] = {
            "successful": successful,
            "failed": failed,
            "success_rate": f"{successful/len(self.endpoints)*100:.1f}%"
        }

        print(f"✅ Completed: {successful} successful, {failed} failed")
        return results

    def save_to_file(self, metadata: Dict[str, Any], filename: str = "vinsight_endpoints_metadata.json"):
        """Save metadata to JSON file"""
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(metadata, f, indent=2, ensure_ascii=False)
        print(f"💾 Metadata saved to {filename}")

def main():
    print("🍷 VinSight API Metadata Fetcher")
    print("=" * 50)

    fetcher = VinSightMetadataFetcher()

    # Authentication setup
    print("\n🔐 Authentication Setup:")
    print("1. API Key (query parameter)")
    print("2. OAuth Access Token")
    print("3. Skip authentication (may fail)")

    auth_choice = input("\nEnter choice (1/2/3): ").strip()

    if auth_choice == "1":
        api_key = input("Enter API Key: ").strip()
        fetcher.set_authentication(api_key=api_key)
    elif auth_choice == "2":
        access_token = input("Enter Access Token: ").strip()
        fetcher.set_authentication(access_token=access_token)
    else:
        print("⚠️ No authentication provided - some endpoints may fail")

    # Fetch metadata
    print(f"\n🔍 Fetching metadata for {len(fetcher.endpoints)} endpoints...")
    metadata = fetcher.fetch_all_metadata()

    # Save to file
    filename = f"vinsight_endpoints_metadata_{time.strftime('%Y%m%d_%H%M%S')}.json"
    fetcher.save_to_file(metadata, filename)

    # Display summary
    print(f"\n📊 Summary:")
    print(f"Total endpoints: {metadata['total_endpoints']}")
    print(f"Successful: {metadata['summary']['successful']}")
    print(f"Failed: {metadata['summary']['failed']}")
    print(f"Success rate: {metadata['summary']['success_rate']}")

    if metadata['summary']['failed'] > 0:
        print(f"\n❌ Failed endpoints:")
        for ep in metadata['endpoints']:
            if ep['status'] == 'error':
                print(f"  - {ep['endpoint']}: {ep.get('error', 'Unknown error')}")

if __name__ == "__main__":
    main()