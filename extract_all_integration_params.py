"""
Extract required parameters from all integration config files
"""
import json
from pathlib import Path

config_dir = Path(__file__).parent / 'dynamic_integrations' / 'generator' / 'config'

# service_id mapping (from cms_manager.py)
SERVICE_MAPPINGS = {
    'cin7': 27,
    'cin7_dear': 14,
    'deputy': 23,
    'dq_myobar': 7,
    'fyi': 72,
    'hubspot': 9,
    'jobman': 8,  # Not in SERVICE_MAPPINGS, guessing
    'karbon_hq': 50,
    'keypay': 57,
    'myob_detailed': 71,
    'payroll_au': 21,
    'payroll_nz': 21,
    'qbo': 4,
    'shopify': 38,
    'simpro': 16,
    'tidywork': 62,
    'unleashed': 17,
    'vinsight': 43,
    'wfm': 69,
    'xeroproject': 25
}

print("=" * 100)
print("INTEGRATION PARAMETERS EXTRACTION")
print("=" * 100)

results = []

for config_file in sorted(config_dir.glob('*_config.json')):
    integration_name = config_file.stem.replace('_config', '')

    with open(config_file, 'r', encoding='utf-8') as f:
        config = json.load(f)

    env_vars_config = config.get('env_vars_config', {})

    # Skip standard parameters
    skip_params = ['etani_client_id', 'etani_organisation_id', 'db_destination',
                   'trigger_type', 'reset_mode']

    # Get integration-specific parameters
    integration_params = []
    for key in env_vars_config.keys():
        if key not in skip_params:
            integration_params.append(key)

    service_id = SERVICE_MAPPINGS.get(integration_name, 'UNKNOWN')

    results.append({
        'service_id': service_id,
        'integration_name': integration_name,
        'config_file': config_file.name,
        'params': integration_params
    })

# Sort by service_id
results.sort(key=lambda x: x['service_id'] if isinstance(x['service_id'], int) else 9999)

print("\n" + "=" * 100)
print("SQL UPDATE STATEMENTS FOR SERVICE TABLE")
print("=" * 100)
print()

for r in results:
    if r['service_id'] != 'UNKNOWN':
        print(f"UPDATE vibedb_cms.service SET integration_name='{r['integration_name']}', config_file_name='{r['config_file']}', is_dynamic_integration=TRUE WHERE id={r['service_id']};")

print("\n" + "=" * 100)
print("REQUIRED PARAMETERS BY INTEGRATION (for Details column)")
print("=" * 100)
print()

for r in results:
    print(f"\n-- {r['integration_name'].upper()} (service_id={r['service_id']})")
    print(f"-- Config file: {r['config_file']}")
    if r['params']:
        print(f"-- Required Details JSON keys: {', '.join(r['params'])}")
        print(f"-- Example:")
        example_json = {param: f"<{param}_value>" for param in r['params']}
        print(f"--   {json.dumps(example_json, indent=4).replace(chr(10), chr(10) + '--   ')}")
    else:
        print(f"-- No integration-specific parameters required")

print("\n" + "=" * 100)
print("COMPLETE PARAMETER LIST")
print("=" * 100)
print()

for r in results:
    if r['params']:
        print(f"{r['integration_name']:20} (service_id={str(r['service_id']):3}): {', '.join(r['params'])}")
