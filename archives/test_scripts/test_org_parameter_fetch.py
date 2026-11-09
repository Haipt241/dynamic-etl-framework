"""
Test org parameter fetcher with exact matching
"""
import os

os.environ['USE_AWS_DB'] = 'True'

from dynamic_integrations.org_parameter_fetcher import fetch_parameters_from_database

print("=" * 80)
print("TEST: ORG PARAMETER FETCHER")
print("=" * 80)

# Test with TidyWork (org_id=7102, service_id=62)
result = fetch_parameters_from_database('7102')

if result['success']:
    print(f"\n✅ SUCCESS")
    print(f"Integration: {result['integration']}")
    print(f"Service ID: {result['service_id']}")
    print(f"Status: {result['status']}")
    print(f"\nParameters extracted:")
    for key, value in result['parameters'].items():
        # Mask sensitive values
        if any(x in key.lower() for x in ['token', 'key', 'secret', 'password']):
            display_value = f"{value[:10]}..." if len(str(value)) > 10 else "***"
        else:
            display_value = value
        print(f"  {key}: {display_value}")
else:
    print(f"\n❌ FAILED")
    print(f"Error: {result['error']}")
