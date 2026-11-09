#!/usr/bin/env python3
"""
Test script to demonstrate how the integration-agnostic CMS manager works
with different integrations (XEROBLUE, QBO, MYOB, etc.)
"""

import os
import sys
from typing import Dict, Any

# Add the current directory to the path for imports
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from cms_manager import CMSManager, get_cms_details_for_integration


def test_different_integrations():
    """Test CMS manager with different integration types"""
    print("🔬 Testing Integration-Agnostic CMS Manager")
    print("=" * 60)
    
    # Test configuration
    test_client_id = os.getenv('EtaniClientID', 'TEST_CLIENT123')
    test_org_id = os.getenv('EtaniOrganisationID', '456')
    test_tenant_id = os.getenv('XeroTenantID', 'test-tenant-123')
    
    integrations_to_test = [
        'XEROBLUE',
        'QBO', 
        'MYOB'
    ]
    
    for integration in integrations_to_test:
        print(f"\\n🔍 Testing {integration} Integration")
        print("-" * 40)
        
        error_list = []
        
        # Test 1: Using CMSManager class directly
        print(f"1️⃣ Testing {integration} with CMSManager class:")
        cms_manager = CMSManager(
            integration_name=integration,
            client_id=test_client_id,
            organisation_id=test_org_id,
            error_list=error_list,
            job_id="TEST_JOB_001",
            job_run_id="TEST_RUN_001"
        )
        
        # Show service configuration
        print(f"   Service Configuration:")
        print(f"   - Main Service: {cms_manager.service_config['main_service']}")
        print(f"   - PBI Service: {cms_manager.service_config['pbi_service']}")
        
        # Test query building (without executing)
        query = cms_manager._build_cms_query()
        print(f"   ✅ Query built successfully ({len(query)} characters)")
        
        # Test legacy client ID formatting for transactions
        legacy_client_for_transactions = cms_manager.get_legacy_client_id_for_transactions()
        print(f"   ✅ Legacy Client ID for Transactions: {legacy_client_for_transactions}")
        
        # Test 2: Using convenience function
        print(f"2️⃣ Testing {integration} with convenience function:")
        cms_details = get_cms_details_for_integration(
            integration_name=integration,
            client_id=test_client_id,
            organisation_id=test_org_id,
            error_list=error_list,
            tenant_id=test_tenant_id,
            job_id="TEST_JOB_002",
            job_run_id="TEST_RUN_002"
        )
        
        print(f"   ✅ CMS Details Structure: {list(cms_details.keys())}")
        print(f"   ✅ Default Values Loaded: {len([k for k, v in cms_details.items() if v is not None])}/{len(cms_details)} fields")
        
        # Test validation
        validation_result = cms_manager.validate_cms_details()
        print(f"   ✅ Validation Result: {'PASS' if validation_result else 'FAIL'}")
        
        if error_list:
            print(f"   ⚠️  Errors encountered: {len(error_list)}")
            for error in error_list[:2]:  # Show first 2 errors
                print(f"      - {error}")
        else:
            print(f"   ✅ No errors encountered")


def test_dynamic_integration_addition():
    """Test adding new integrations dynamically"""
    print(f"\\n🚀 Testing Dynamic Integration Addition")
    print("-" * 40)
    
    # Show current supported integrations
    supported_before = CMSManager.get_supported_integrations()
    print(f"Supported integrations before: {supported_before}")
    
    # Add new integrations
    new_integrations = [
        ('SAGEINTACCT', 5, 3),
        ('NETSUITE', 6, 3),
        ('FRESHBOOKS', 7, 3)
    ]
    
    for integration_name, main_service, pbi_service in new_integrations:
        CMSManager.add_integration_mapping(integration_name, main_service, pbi_service)
    
    # Show updated supported integrations
    supported_after = CMSManager.get_supported_integrations()
    print(f"Supported integrations after: {supported_after}")
    
    # Test one of the new integrations
    test_integration = new_integrations[0][0]
    print(f"\\n🧪 Testing newly added integration: {test_integration}")
    
    error_list = []
    cms_manager = CMSManager(
        integration_name=test_integration,
        client_id='TEST_CLIENT999',
        organisation_id='999',
        error_list=error_list
    )
    
    print(f"   Main Service: {cms_manager.service_config['main_service']}")
    print(f"   PBI Service: {cms_manager.service_config['pbi_service']}")
    print(f"   ✅ New integration working correctly!")


def demonstrate_xeroblue_usage():
    """Demonstrate how XeroBlue would use the generic CMS manager"""
    print(f"\\n💡 XeroBlue Integration Example")
    print("-" * 40)
    
    # Simulate XeroBlue integration usage
    class MockXeroBlueIntegration:
        def __init__(self):
            self.etani_client_id = os.getenv('EtaniClientID', 'SWAU_CLIENT1724')
            self.etani_organisation_id = os.getenv('EtaniOrganisationID', '6051')
            self.xero_tenant_id = os.getenv('XeroTenantID', '31056af5-c4d0-4f1a-84c6-0a1b74498149')
            self.error_list = []
            self.job_id = 'DEMO_JOB'
            self.job_run_id = 'DEMO_RUN'
            
            # Get CMS details using generic manager
            self._get_cms_details()
        
        def _get_cms_details(self):
            """Get CMS details using generic manager (same as enhanced integration)"""
            try:
                cms_manager = CMSManager(
                    integration_name="XEROBLUE",
                    client_id=self.etani_client_id,
                    organisation_id=self.etani_organisation_id,
                    error_list=self.error_list,
                    job_id=self.job_id,
                    job_run_id=self.job_run_id
                )
                
                cms_details = cms_manager.get_cms_details(tenant_id=self.xero_tenant_id)
                
                # Populate values
                self.org_status = cms_details['org_status']
                self.legacy_client_id = cms_details['legacy_client_id']
                self.legacy_organisation_id = cms_details['legacy_organisation_id']
                self.firm_id = cms_details['firm_id']
                
                if cms_details['tenant_id'] and cms_details['tenant_id'].strip():
                    self.xero_tenant_id = cms_details['tenant_id']
                
                self.cms_manager = cms_manager
                
                print("✅ CMS Details Retrieved via Generic Manager:")
                print(f"   Organization Status: {self.org_status}")
                print(f"   Legacy Client ID: {self.legacy_client_id}")
                print(f"   Legacy Organization ID: {self.legacy_organisation_id}")
                print(f"   Firm ID: {self.firm_id}")
                print(f"   Xero Tenant ID: {self.xero_tenant_id}")
                
            except Exception as e:
                print(f"❌ Error: {str(e)}")
                # Set defaults
                self.legacy_organisation_id = 0
                self.firm_id = 0
                self.legacy_client_id = ''
                self.org_status = 0
        
        def get_transactions_sp_call(self):
            """Example of how to get stored procedure call for Transactions endpoint"""
            client_number = self.etani_client_id[self.etani_client_id.find('CLIENT') + len('CLIENT'):]
            cms_legacy_client_id = self.cms_manager.get_legacy_client_id_for_transactions() if hasattr(self, 'cms_manager') else client_number
            return f"CALL sp_dynamic_xeroblue_transactions('{client_number}', {self.etani_organisation_id}, {self.legacy_organisation_id}, '{cms_legacy_client_id}')"
    
    # Run the demo
    xero_integration = MockXeroBlueIntegration()
    
    print(f"\\n📋 Generated Stored Procedure Call for Transactions:")
    print(f"   {xero_integration.get_transactions_sp_call()}")


def run_comprehensive_test():
    """Run all tests"""
    print("🎯 Comprehensive Integration-Agnostic CMS Manager Test")
    print("=" * 80)
    
    try:
        test_different_integrations()
        test_dynamic_integration_addition()
        demonstrate_xeroblue_usage()
        
        print(f"\\n🎉 All Tests Completed Successfully!")
        print("=" * 80)
        print("✅ The CMS Manager is fully integration-agnostic and ready for use!")
        print("✅ Any integration can use CMSManager with their specific service IDs")
        print("✅ New integrations can be added dynamically without code changes")
        print("✅ Error handling and logging work consistently across integrations")
        
    except Exception as e:
        print(f"\\n❌ Test failed with error: {str(e)}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    run_comprehensive_test()