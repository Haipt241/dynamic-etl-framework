#!/usr/bin/env python3
"""
Fixed script to correctly extract columns from CREATE_Table_Script.txt and compare with endpoints.json
"""
import json
import re
import os

def extract_table_columns_fixed(sql_script_path):
    """Extract table names and their columns from SQL CREATE TABLE script with correct regex"""
    tables_columns = {}

    with open(sql_script_path, 'r', encoding='utf-16') as f:
        content = f.read()

    # Split content by CREATE TABLE statements
    create_table_pattern = r'CREATE\s+TABLE\s+\[Vinsight_([^\]]+)\]\s+\((.*?)\)'
    matches = re.findall(create_table_pattern, content, re.IGNORECASE | re.DOTALL)

    for table_name, table_body in matches:
        if table_name.endswith('STAGE'):
            continue  # Skip staging tables

        print(f"\n🔍 Processing table: Vinsight_{table_name}")

        # Extract column names from table body
        # Pattern matches:    [ColumnName] datatype,
        column_pattern = r'\s*\[([^\]]+)\]\s+[^,\)]+[,\)]'
        column_matches = re.findall(column_pattern, table_body)

        # Clean up columns and exclude standard fields
        columns = []
        for col in column_matches:
            col = col.strip()
            if col and col not in ['ClientID', 'OrganisationID']:
                columns.append(col)

        tables_columns[table_name] = columns
        print(f"   📋 Found {len(columns)} columns: {columns[:5]}{'...' if len(columns) > 5 else ''}")

    return tables_columns

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
    }

    return mapping.get(endpoint_name, endpoint_name)

def load_endpoints(endpoints_path):
    """Load original endpoints.json"""
    with open(endpoints_path, 'r') as f:
        data = json.load(f)
    return data

def compare_tables_endpoints(tables_columns, endpoints_data):
    """Compare extracted table columns with endpoints"""
    print("\n" + "="*80)
    print("🔍 DETAILED COMPARISON RESULTS")
    print("="*80)

    comparison_results = {}

    for table_name, sql_columns in tables_columns.items():
        endpoint_name = map_table_to_endpoint(table_name)

        # Find matching endpoint
        matching_endpoint = None
        for endpoint in endpoints_data['endpoints']:
            if endpoint['name'] == endpoint_name:
                matching_endpoint = endpoint
                break

        if not matching_endpoint:
            print(f"\n❌ NO ENDPOINT: {table_name} -> {endpoint_name}")
            continue

        # Get field names from endpoint
        endpoint_fields = [field['api_name'] for field in matching_endpoint['fields']]

        # Compare columns
        sql_columns_set = set(sql_columns)
        endpoint_fields_set = set(endpoint_fields)

        # Standard fields to always keep
        standard_fields = {'ClientID', 'OrganisationID', '$id', 'Id', 'EntryNum'}

        # Fields missing in endpoint but present in SQL
        missing_in_endpoint = sql_columns_set - endpoint_fields_set

        # Fields in endpoint but not in SQL
        extra_in_endpoint = endpoint_fields_set - sql_columns_set - standard_fields

        # Required fields = SQL columns + standard fields
        required_fields = sql_columns_set | standard_fields

        print(f"\n📋 {endpoint_name} (Table: {table_name})")
        print(f"   🗄️  SQL columns: {len(sql_columns)}")
        print(f"   🔗 Endpoint fields: {len(endpoint_fields)}")
        print(f"   ✅ Required fields: {len(required_fields)}")

        if missing_in_endpoint:
            print(f"   ⚠️  Missing in endpoint ({len(missing_in_endpoint)}): {list(missing_in_endpoint)[:5]}{'...' if len(missing_in_endpoint) > 5 else ''}")

        if extra_in_endpoint:
            print(f"   🗑️  Extra in endpoint ({len(extra_in_endpoint)}): {list(extra_in_endpoint)[:5]}{'...' if len(extra_in_endpoint) > 5 else ''}")

        comparison_results[endpoint_name] = {
            'required_fields': required_fields,
            'missing_in_endpoint': missing_in_endpoint,
            'extra_in_endpoint': extra_in_endpoint,
            'sql_columns_count': len(sql_columns),
            'endpoint_fields_count': len(endpoint_fields)
        }

    return comparison_results

def create_corrected_endpoints(endpoints_data, comparison_results):
    """Create corrected endpoints.json keeping all necessary fields"""
    corrected_data = endpoints_data.copy()

    print("\n" + "="*80)
    print("✂️ FILTERING ENDPOINTS")
    print("="*80)

    for endpoint in corrected_data['endpoints']:
        endpoint_name = endpoint['name']

        if endpoint_name in comparison_results:
            result = comparison_results[endpoint_name]
            required_fields = result['required_fields']

            # Keep only required fields
            original_count = len(endpoint['fields'])
            endpoint['fields'] = [
                field for field in endpoint['fields']
                if field['api_name'] in required_fields
            ]
            new_count = len(endpoint['fields'])

            if original_count != new_count:
                print(f"📝 {endpoint_name}: {original_count} → {new_count} fields")
            else:
                print(f"✅ {endpoint_name}: {new_count} fields (no change)")

    return corrected_data

def main():
    base_path = "/Users/haipham/DuAn/upwork/etani/etl-packages/dynamic_integrations/generated_integrations/vinsight/schemas"
    sql_script_path = os.path.join(base_path, "CREATE_Table_Script.txt")
    endpoints_path = os.path.join(base_path, "endpoints.json")

    print("🔍 Extracting table columns from SQL script (FIXED VERSION)...")
    tables_columns = extract_table_columns_fixed(sql_script_path)

    print(f"\n📊 EXTRACTION SUMMARY:")
    print(f"   Found {len(tables_columns)} tables")

    print("\n📖 Loading original endpoints.json...")
    endpoints_data = load_endpoints(endpoints_path)
    print(f"   Found {len(endpoints_data['endpoints'])} endpoints")

    print("\n🔍 Comparing tables with endpoints...")
    comparison_results = compare_tables_endpoints(tables_columns, endpoints_data)

    print("\n✂️ Creating corrected endpoints...")
    corrected_data = create_corrected_endpoints(endpoints_data, comparison_results)

    # Save corrected data
    corrected_path = os.path.join(base_path, "endpoints_corrected.json")
    with open(corrected_path, 'w') as f:
        json.dump(corrected_data, f, indent=2)

    print(f"\n✅ Corrected endpoints saved to: endpoints_corrected.json")

    # Summary statistics
    print(f"\n📈 FINAL SUMMARY:")
    total_endpoints_processed = len(comparison_results)
    total_fields_before = sum(r['endpoint_fields_count'] for r in comparison_results.values())
    total_sql_columns = sum(r['sql_columns_count'] for r in comparison_results.values())

    print(f"   📋 Processed endpoints: {total_endpoints_processed}")
    print(f"   🗄️  Total SQL columns: {total_sql_columns}")
    print(f"   📊 Original endpoint fields: {total_fields_before}")

if __name__ == "__main__":
    main()