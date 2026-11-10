"""
Organization Parameter Fetcher - Simple Exact Match

Fetches integration parameters from database using EXACT key matching.
JSON keys in apiConnectionInfo MUST match config keys exactly.

Example:
    apiConnectionInfo: {"tidywork_api_key": "xxx", "tidywork_domain": "yyy"}
    config env_vars_config: {"tidywork_api_key": {...}, "tidywork_domain": {...}}
    -> EXACT MATCH, extract values
"""

import os
import json
from typing import Dict, Any, Optional
from pathlib import Path
from sqlalchemy import text


class OrgParameterFetcher:
    """Fetches all integration parameters from database using exact key matching"""

    # service_id -> integration_name mapping (lazy-loaded from database)
    _SERVICE_TO_INTEGRATION = None

    def _get_service_integration_mapping(self) -> Dict[int, str]:
        """
        Get service_id -> integration_name mapping from vibedb_cms.service table
        Reuses the same CMS engine pattern as _fetch_cms_data
        """
        if self.__class__._SERVICE_TO_INTEGRATION is not None:
            return self.__class__._SERVICE_TO_INTEGRATION

        try:
            from dynamic_integrations.database.sql_helper import get_cms_engine

            engine = get_cms_engine()
            query = text("""
                SELECT id, integration_name
                FROM vibedb_cms.service
                WHERE integration_name IS NOT NULL
                ORDER BY id
            """)

            with engine.connect() as conn:
                result = conn.execute(query)
                mapping = {row[0]: row[1] for row in result}

            print(f"[OK] Loaded {len(mapping)} service integrations from database")
            self.__class__._SERVICE_TO_INTEGRATION = mapping
            return mapping

        except Exception as e:
            print(f"[ERROR] Error loading service integration mapping: {e}")
            print("[SYNC] Falling back to empty mapping")
            self.__class__._SERVICE_TO_INTEGRATION = {}
            return {}

    @property
    def SERVICE_TO_INTEGRATION(self) -> Dict[int, str]:
        """Lazy-loaded service integration mapping"""
        return self._get_service_integration_mapping()

    def __init__(self, org_id: str):
        self.org_id = org_id
        self.cms_data = None
        self.integration_name = None
        self.parameters = {}

    def fetch_all_parameters(self) -> Dict[str, Any]:
        """
        Fetch all integration parameters from database

        Returns:
            Dict containing:
                - success: bool
                - integration: integration name
                - parameters: dict of all parameters
                - error: error message if failed
        """
        try:
            print(f"[SEARCH] Fetching parameters for org_id={self.org_id}")

            # Step 1: Query CMS
            cms_data = self._fetch_cms_data()
            if not cms_data:
                return {'success': False, 'error': f'No active client_service record for org_id={self.org_id}'}

            self.cms_data = cms_data

            # Step 2: Map service_id -> integration_name
            service_id = cms_data.get('service_id')
            integration_name = self.SERVICE_TO_INTEGRATION.get(service_id)

            if not integration_name:
                return {'success': False, 'error': f'Unknown service_id={service_id}'}

            self.integration_name = integration_name
            print(f"[OK] service_id={service_id} -> integration={integration_name}")

            # Step 3: Load integration config
            config = self._load_integration_config(integration_name)
            if not config:
                return {'success': False, 'error': f'Config not found: {integration_name}_config.json'}

            # Step 4: Build EtaniClientID
            etani_client_id = self._build_etani_client_id(cms_data)

            # Step 5: Extract parameters using EXACT matching
            details_json = cms_data.get('details', {})
            integration_params = self._extract_parameters_exact_match(config, details_json)

            # Step 6: Build complete parameter set
            self.parameters = {
                'EtaniClientID': etani_client_id,
                'EtaniOrganisationID': str(self.org_id),
                **integration_params
            }

            print(f"[OK] Fetched {len(integration_params)} integration parameters")
            print(f"   Parameters: {list(self.parameters.keys())}")

            return {
                'success': True,
                'integration': integration_name,
                'parameters': self.parameters,
                'service_id': service_id,
                'status': cms_data.get('status')
            }

        except Exception as e:
            error_msg = f'Error fetching parameters for org_id={self.org_id}: {str(e)}'
            print(f"[ERROR] {error_msg}")
            import traceback
            traceback.print_exc()
            return {'success': False, 'error': error_msg}

    def _fetch_cms_data(self) -> Optional[Dict[str, Any]]:
        """Query client_service table for org details"""
        try:
            from dynamic_integrations.database.sql_helper import get_cms_engine

            engine = get_cms_engine()

            query = text("""
                SELECT
                    cs.id as org_id,
                    cs.Client as client_id,
                    cs.Service as service_id,
                    cs.Status as status,
                    cs.AccountingFirm as firm_id,
                    c.name as client_name,
                    af.Code as firm_code,
                    cs.Details
                FROM vibedb_cms.client_service cs
                INNER JOIN vibedb_cms.client c ON cs.Client = c.id
                INNER JOIN vibedb_cms.accounting_firm af ON cs.AccountingFirm = af.id
                WHERE cs.id = :org_id
                    AND cs.Status IN (1, 9, 12)
            """)

            with engine.connect() as conn:
                result = conn.execute(query, {'org_id': self.org_id})
                row = result.fetchone()

                if not row:
                    return None

                # Parse Details JSON
                details_json = row[7]
                if details_json and isinstance(details_json, str):
                    try:
                        details_json = json.loads(details_json)
                    except json.JSONDecodeError:
                        print(f"[WARNING]  Failed to parse Details JSON")
                        details_json = {}

                cms_data = {
                    'org_id': row[0],
                    'client_id': row[1],
                    'service_id': row[2],
                    'status': row[3],
                    'firm_id': row[4],
                    'client_name': row[5],
                    'firm_code': row[6],
                    'details': details_json
                }

                print(f"[OK] Found: {cms_data['client_name']} (service_id={cms_data['service_id']}, status={cms_data['status']})")
                return cms_data

        except Exception as e:
            print(f"[ERROR] Error fetching CMS data: {str(e)}")
            return None

    def _load_integration_config(self, integration_name: str) -> Optional[Dict[str, Any]]:
        """Load integration config file"""
        try:
            config_path = Path(__file__).parent / 'generator' / 'config' / f'{integration_name}_config.json'

            if not config_path.exists():
                print(f"[WARNING]  Config not found: {config_path}")
                return None

            with open(config_path, 'r', encoding='utf-8') as f:
                config = json.load(f)

            print(f"[OK] Loaded config: {config_path.name}")
            return config

        except Exception as e:
            print(f"[ERROR] Error loading config: {str(e)}")
            return None

    def _build_etani_client_id(self, cms_data: Dict[str, Any]) -> str:
        """Build EtaniClientID from firm_code + client_id"""
        firm_code = cms_data.get('firm_code', '').upper()
        client_id = cms_data.get('client_id')
        etani_client_id = f"{firm_code}_CLIENT{client_id}"
        print(f"[OK] EtaniClientID: {etani_client_id}")
        return etani_client_id

    def _extract_parameters_exact_match(self, config: Dict[str, Any],
                                       details_json: Dict[str, Any]) -> Dict[str, Any]:
        """
        Extract parameters using key matching with fallback to config defaults

        Rules:
        - First try exact match (config_key in details_json)
        - Then try common key mappings (tenantId -> xero_tenant_id, etc.)
        - Finally fallback to default_value from config
        - Skip standard params (etani_client_id, etani_organisation_id, db_destination, etc.)

        Args:
            config: Integration config dict
            details_json: Details JSON from client_service.Details column

        Returns:
            Dict of extracted parameters
        """
        params = {}
        env_vars_config = config.get('env_vars_config', {})

        # Skip these standard parameters (handled separately)
        skip_params = ['etani_client_id', 'etani_organisation_id', 'db_destination',
                      'trigger_type', 'reset_mode']

        # Key mapping for common mismatches (Details JSON key -> config key)
        # NOTE: OAuth app credentials (client_id, client_secret) are NEVER in Details JSON
        # They are application-level credentials and must come from config defaults
        key_mapping = {
            'tenantId': 'xero_tenant_id',        # Org-specific tenant ID
            'refresh_token': 'REDACTED',  # Org-specific refresh token
            'access_token': 'REDACTED',    # Org-specific access token
            # clientId in Details JSON is Etani client number (6956), NOT OAuth client_id!
            # xero_client_id must come from config default (OAuth app credential)
        }

        print(f"[SEARCH] Extracting parameters:")
        print(f"   Config keys: {[k for k in env_vars_config.keys() if k not in skip_params]}")
        print(f"   Details JSON keys: {list(details_json.keys())}")

        for config_key, config_data in env_vars_config.items():
            # Skip standard parameters
            if config_key in skip_params:
                continue

            env_var = config_data.get('env_var', '')
            default_value = config_data.get('default_value', '')
            value_found = False
            value = None

            # Check if this is a sensitive field
            sensitive_keywords = ['SECRET', 'PASSWORD', 'TOKEN', 'KEY', 'CREDENTIAL']
            is_sensitive = any(keyword in env_var.upper() for keyword in sensitive_keywords)

            # Priority 1: EXACT MATCH - Check if config_key exists in Details JSON
            if config_key in details_json:
                value = details_json[config_key]
                if value:  # Skip empty values
                    params[env_var] = str(value)
                    if is_sensitive:
                        value_str = str(value)
                        masked = f"{value_str[:4]}...{value_str[-4:]}" if len(value_str) > 12 else "***"
                        print(f"   [OK] {env_var}: EXACT MATCH (key: {config_key}) [value: {masked}] [MASKED]")
                    else:
                        print(f"   [OK] {env_var}: EXACT MATCH (key: {config_key})")
                    value_found = True

            # Priority 2: KEY MAPPING - Check if there's a mapped key
            if not value_found:
                for details_key, mapped_config_key in key_mapping.items():
                    if mapped_config_key == config_key and details_key in details_json:
                        value = details_json[details_key]
                        if value:
                            params[env_var] = str(value)
                            if is_sensitive:
                                value_str = str(value)
                                masked = f"{value_str[:4]}...{value_str[-4:]}" if len(value_str) > 12 else "***"
                                print(f"   [OK] {env_var}: MAPPED MATCH (Details key: {details_key} -> config key: {config_key}) [value: {masked}] [MASKED]")
                            else:
                                print(f"   [OK] {env_var}: MAPPED MATCH (Details key: {details_key} -> config key: {config_key})")
                            value_found = True
                            break

            # Priority 3: DEFAULT VALUE - Use config default if available
            if not value_found and default_value:
                params[env_var] = str(default_value)

                # Mask sensitive fields (secrets, tokens, passwords, keys)
                sensitive_keywords = ['SECRET', 'PASSWORD', 'TOKEN', 'KEY', 'CREDENTIAL']
                is_sensitive = any(keyword in env_var.upper() for keyword in sensitive_keywords)

                if is_sensitive:
                    # Mask: show only first 4 and last 4 characters
                    value_str = str(default_value)
                    if len(value_str) > 12:
                        masked = f"{value_str[:4]}...{value_str[-4:]}"
                    else:
                        masked = "***"
                    print(f"   [OK] {env_var}: DEFAULT VALUE from config (value: {masked}) [MASKED]")
                else:
                    print(f"   [OK] {env_var}: DEFAULT VALUE from config (value: {str(default_value)[:50]}...)")
                value_found = True

            # No value found anywhere
            if not value_found:
                # Special case: OAuth app credentials (client_id/client_secret) are loaded from Secrets Manager, not Details JSON
                oauth_app_credentials = ['XERO_CLIENT_ID', 'XERO_CLIENT_SECRET', 'QBO_CLIENT_ID', 'QBO_CLIENT_SECRET']
                if env_var in oauth_app_credentials:
                    print(f"   [SKIP] {env_var}: Not in Details JSON (will be loaded from Secrets Manager)")
                else:
                    print(f"   [WARNING] {env_var}: No match for '{config_key}' in Details JSON and no default value")

        return params


def fetch_parameters_from_database(org_id: str) -> Dict[str, Any]:
    """
    Convenience function to fetch all integration parameters

    Args:
        org_id: Organization ID

    Returns:
        Dict with success status, integration name, and parameters
    """
    fetcher = OrgParameterFetcher(org_id)
    return fetcher.fetch_all_parameters()


if __name__ == "__main__":
    # Test
    test_org_id = os.getenv('EtaniOrganisationID', '7102')

    print("=" * 80)
    print("ORG PARAMETER FETCHER - EXACT MATCH")
    print("=" * 80)

    result = fetch_parameters_from_database(test_org_id)

    if result['success']:
        print(f"\n[OK] SUCCESS")
        print(f"Integration: {result['integration']}")
        print(f"Parameters: {result['parameters']}")
    else:
        print(f"\n[ERROR] FAILED")
        print(f"Error: {result['error']}")
