"""
Mock CMS Manager for testing purposes
This is a placeholder implementation that will be replaced with the actual CMS manager
"""

import os
from typing import Dict, Any, List

class CMSManager:
    """Mock CMS Manager for testing"""
    
    def __init__(self, integration_name: str, client_id: str, organisation_id: str, 
                 error_list: List[str], job_id: str = None, job_run_id: str = None):
        self.integration_name = integration_name
        self.client_id = client_id
        self.organisation_id = organisation_id
        self.error_list = error_list
        self.job_id = job_id
        self.job_run_id = job_run_id
    
    def get_cms_details(self, tenant_id: str = None) -> Dict[str, Any]:
        """Mock implementation that returns default values"""
        client_number = self.client_id.replace('CLIENT', '') if 'CLIENT' in self.client_id else self.client_id
        
        return {
            'org_status': 1,
            'legacy_client_id': f'test_client_{client_number}',
            'legacy_organisation_id': int(self.organisation_id),
            'firm_id': 1,
            'tenant_id': tenant_id or 'test-tenant-id'
        }
    
    def get_legacy_client_id_for_transactions(self) -> str:
        """Mock implementation for transactions legacy client ID"""
        client_number = self.client_id.replace('CLIENT', '') if 'CLIENT' in self.client_id else self.client_id
        return f'test_client_{client_number}'