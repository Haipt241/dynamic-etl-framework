#!/usr/bin/env python3
"""
Script to add child_endpoint_config to KeyPay schema endpoints
"""
import json
import re

def add_child_endpoint_config():
    # Read the current schema
    schema_path = "/Users/haipham/DuAn/upwork/etani/etl-packages/dynamic_integrations/generated_integrations/keypay/schemas/keypay_schema.json"

    with open(schema_path, 'r', encoding='utf-8') as f:
        schema = json.load(f)

    # Process each endpoint
    for endpoint in schema['endpoints']:
        endpoint_name = endpoint['name']
        path = endpoint['api_details']['path']

        # Skip Business endpoint (it's the root)
        if endpoint_name == "Business":
            continue

        # Skip if already has child_endpoint_config
        if 'is_child_endpoint' in endpoint:
            continue

        # Determine parent relationships based on path
        child_configs = []

        # Check for businessId
        if '{businessId}' in path:
            child_configs.append({
                "parent_table": "business",
                "parent_id_column": "Id",
                "parent_id_source": "businessId",
                "map_id_to_column": "BusinessId",
                "child_endpoint_type": "url_based"
            })

        # Check for payRunId
        if '{payRunId}' in path:
            child_configs.append({
                "parent_table": "payrun",
                "parent_id_column": "Id",
                "parent_id_source": "payRunId",
                "map_id_to_column": "PayRunId",
                "child_endpoint_type": "url_based"
            })

        # Check for employeeId
        if '{employeeId}' in path:
            child_configs.append({
                "parent_table": "employee",
                "parent_id_column": "Id",
                "parent_id_source": "employeeId",
                "map_id_to_column": "EmployeeId",
                "child_endpoint_type": "url_based"
            })

        # Add child endpoint configuration if any parent relationships found
        if child_configs:
            endpoint['is_child_endpoint'] = True
            endpoint['child_endpoint_config'] = child_configs
            print(f"Added child config to {endpoint_name}: {[c['parent_table'] for c in child_configs]}")

    # Write back the updated schema
    with open(schema_path, 'w', encoding='utf-8') as f:
        json.dump(schema, f, indent=2, ensure_ascii=False)

    print(f"\nCompleted! Updated {len([e for e in schema['endpoints'] if 'is_child_endpoint' in e])} endpoints")

if __name__ == "__main__":
    add_child_endpoint_config()