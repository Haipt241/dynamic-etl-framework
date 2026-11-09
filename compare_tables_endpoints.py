#!/usr/bin/env python3
"""
Script to compare CREATE_Table_Script.txt with endpoints.json and filter unnecessary fields
"""
import json
import re
import os

def extract_table_columns(sql_script_path):
    """Extract table names and their columns from SQL CREATE TABLE script"""
    tables_columns = {}

    with open(sql_script_path, 'r', encoding='utf-16') as f:
        content = f.read()

    # Find all CREATE TABLE statements (non-STAGE tables only)
    table_pattern = r'CREATE\s+TABLE\s+\[Vinsight_([^\]]+)\]\s+\(\s*(.*?)\s*\)'
    matches = re.findall(table_pattern, content, re.IGNORECASE | re.DOTALL)

    for table_name, columns_text in matches:
        if table_name.endswith('STAGE'):
            continue  # Skip staging tables

        # Extract column definitions
        columns = []
        column_pattern = r'\[\s*([^\]]+)\s*\]\s+[^\[\(,\)]+(?:,|$)'
        column_matches = re.findall(column_pattern, columns_text, re.IGNORECASE)

        for col in column_matches:
            col = col.strip()
            if col and col not in ['ClientID', 'OrganisationID']:  # Standard fields
                columns.append(col)

        tables_columns[table_name] = columns
        print(f"Table: Vinsight_{table_name} - Columns: {len(columns)}")

    return tables_columns

def load_endpoints(endpoints_path):
    """Load endpoints.json"""
    with open(endpoints_path, 'r') as f:
        data = json.load(f)
    return data

def map_table_to_endpoint(table_name):
    """Map table name to endpoint name"""
    # Remove 'Vinsight_' prefix and convert to endpoint naming
    endpoint_name = table_name.replace('Vinsight_', '')

    # Handle special mappings
    mapping = {
        'ContactActivities': 'ContactActivity',
        'Currencies': 'Currency',
        'Addons': 'Addon',
        'Aliases': 'Alias',
        # Add more mappings as needed
    }

    return mapping.get(endpoint_name, endpoint_name)

def compare_and_filter(tables_columns, endpoints_data):
    """Compare tables with endpoints and show differences"""
    print("\n=== COMPARISON RESULTS ===")

    required_fields_by_endpoint = {}

    for table_name, sql_columns in tables_columns.items():
        endpoint_name = map_table_to_endpoint(table_name)

        # Find matching endpoint
        matching_endpoint = None
        for endpoint in endpoints_data['endpoints']:
            if endpoint['name'] == endpoint_name:
                matching_endpoint = endpoint
                break

        if not matching_endpoint:
            print(f"\n❌ No endpoint found for table: {table_name} (looking for: {endpoint_name})")
            continue

        # Get field names from endpoint
        endpoint_fields = [field['api_name'] for field in matching_endpoint['fields']]

        # Compare
        sql_columns_set = set(sql_columns)
        endpoint_fields_set = set(endpoint_fields)

        # Fields in SQL but not in endpoint
        missing_in_endpoint = sql_columns_set - endpoint_fields_set

        # Fields in endpoint but not in SQL (these should be removed)
        extra_in_endpoint = endpoint_fields_set - sql_columns_set

        # Standard fields to keep
        standard_fields = {'ClientID', 'OrganisationID', '$id', 'Id', 'EntryNum'}
        extra_in_endpoint = extra_in_endpoint - standard_fields

        print(f"\n📋 {endpoint_name} (Table: {table_name})")
        print(f"   SQL columns: {len(sql_columns)}")
        print(f"   Endpoint fields: {len(endpoint_fields)}")

        if missing_in_endpoint:
            print(f"   ⚠️  Missing in endpoint: {list(missing_in_endpoint)[:5]}...")

        if extra_in_endpoint:
            print(f"   🗑️  Extra in endpoint (should remove): {len(extra_in_endpoint)} fields")
            print(f"       {list(extra_in_endpoint)[:10]}...")

        # Store required fields for this endpoint
        required_fields = sql_columns_set | standard_fields
        required_fields_by_endpoint[endpoint_name] = required_fields

    return required_fields_by_endpoint

def filter_endpoints(endpoints_data, required_fields_by_endpoint):
    """Filter endpoints.json to keep only required fields"""
    filtered_data = endpoints_data.copy()

    for endpoint in filtered_data['endpoints']:
        endpoint_name = endpoint['name']

        if endpoint_name in required_fields_by_endpoint:
            required_fields = required_fields_by_endpoint[endpoint_name]

            # Filter fields
            original_count = len(endpoint['fields'])
            endpoint['fields'] = [
                field for field in endpoint['fields']
                if field['api_name'] in required_fields
            ]
            filtered_count = len(endpoint['fields'])

            print(f"📝 {endpoint_name}: {original_count} → {filtered_count} fields")

    return filtered_data

def main():
    base_path = "/Users/haipham/DuAn/upwork/etani/etl-packages/dynamic_integrations/generated_integrations/vinsight/schemas"
    sql_script_path = os.path.join(base_path, "CREATE_Table_Script.txt")
    endpoints_path = os.path.join(base_path, "endpoints.json")

    print("🔍 Extracting table columns from SQL script...")
    tables_columns = extract_table_columns(sql_script_path)

    print("\n📖 Loading endpoints.json...")
    endpoints_data = load_endpoints(endpoints_path)

    print(f"\n📊 Found {len(tables_columns)} tables and {len(endpoints_data['endpoints'])} endpoints")

    print("\n🔍 Comparing and filtering...")
    required_fields = compare_and_filter(tables_columns, endpoints_data)

    print("\n✂️ Filtering endpoints.json...")
    filtered_data = filter_endpoints(endpoints_data, required_fields)

    # Save filtered data
    filtered_path = os.path.join(base_path, "endpoints_filtered.json")
    with open(filtered_path, 'w') as f:
        json.dump(filtered_data, f, indent=2)

    print(f"\n✅ Filtered endpoints saved to: endpoints_filtered.json")

if __name__ == "__main__":
    main()