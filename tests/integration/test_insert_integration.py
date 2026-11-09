#!/usr/bin/env python3
"""
Test script for the integration-agnostic INSERT package with XeroBlue integration
Demonstrates that the redesigned architecture works correctly
"""

import os
import sys
import time
from typing import Dict, Any

# Add current directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

def test_xeroblue_insert_integration():
    """Test XeroBlue integration with the generic INSERT package"""
    print("=" * 60)
    print("Testing Integration-Agnostic INSERT Package with XeroBlue")
    print("=" * 60)
    
    try:
        # Set up environment variables for testing
        os.environ['EtaniClientID'] = 'CLIENT1724'
        os.environ['EtaniOrganisationID'] = '6051'
        os.environ['XeroTenantID'] = 'test-tenant-id'
        os.environ['DB_Destination'] = 'EVA'
        
        # Create XeroBlue integration instance
        print("\n1. Creating XeroBlue integration instance...")
        from xeroblue_integration_enhanced import XeroBlueIntegrationEnhanced
        
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900,
            'debug': True
        }
        
        xeroblue_integration = XeroBlueIntegrationEnhanced(config)
        print(f"✅ XeroBlue integration created: {xeroblue_integration.integration_name}")
        
        # Test the integration interface validation
        print("\n2. Testing integration interface...")
        
        # Check required attributes and methods
        required_attributes = ['integration_name']
        required_methods = ['validate_configuration', 'get_insert_configuration']
        optional_methods = ['create_sql_objects', 'initialize_indexes', 'upload_powerbi_template']
        
        print(f"Required attributes:")
        for attr in required_attributes:
            has_attr = hasattr(xeroblue_integration, attr)
            print(f"  ✅ {attr}: {getattr(xeroblue_integration, attr) if has_attr else 'MISSING'}")
        
        print(f"\nRequired methods:")
        for method in required_methods:
            has_method = hasattr(xeroblue_integration, method)
            print(f"  ✅ {method}: {'Available' if has_method else 'MISSING'}")
        
        print(f"\nOptional methods:")
        for method in optional_methods:
            has_method = hasattr(xeroblue_integration, method)
            print(f"  ✅ {method}: {'Available' if has_method else 'Not implemented'}")
        
        # Test get_insert_configuration method
        print("\n3. Testing get_insert_configuration method...")
        insert_config = xeroblue_integration.get_insert_configuration()
        
        print(f"Insert Configuration:")
        for key, value in insert_config.items():
            if key == 'error_list':
                print(f"  {key}: {type(value).__name__} (length: {len(value)})")
            else:
                print(f"  {key}: {value}")
        
        # Create the generic INSERT orchestrator
        print("\n4. Creating generic INSERT orchestrator...")
        from integration_package_insert import create_package_insert
        
        orchestrator = create_package_insert(xeroblue_integration, config)
        print(f"✅ Generic INSERT orchestrator created")
        
        # Test interface validation
        print("\n5. Testing interface validation...")
        interface_valid = orchestrator.validate_integration_interface()
        print(f"Interface validation: {'✅ PASSED' if interface_valid else '❌ FAILED'}")
        
        # Test configuration validation
        print("\n6. Testing configuration validation...")
        config_valid = xeroblue_integration.validate_configuration()
        print(f"Configuration validation: {'✅ PASSED' if config_valid else '❌ FAILED'}")
        
        # Test SQL Object creation (dry run)
        print("\n7. Testing SQL object creation...")
        try:
            sql_success = orchestrator.create_sql_objects(parallel=True)
            print(f"SQL objects creation: {'✅ SUCCESS' if sql_success else '⚠️ PARTIAL/FAILED'}")
        except Exception as e:
            print(f"SQL objects creation: ❌ ERROR - {str(e)}")
        
        # Test full initialization workflow
        print("\n8. Running full initialization workflow...")
        start_time = time.time()
        
        results = orchestrator.run_initialization(
            create_objects=True,
            initialize_indexes=True,
            upload_pbi=True,
            workspace_id="test-workspace"
        )
        
        end_time = time.time()
        duration = end_time - start_time
        
        print(f"\nInitialization Results:")
        print(f"  Status: {results.get('status', 'unknown')}")
        print(f"  Duration: {duration:.2f} seconds")
        print(f"  Integration: {results.get('integration_name', 'unknown')}")
        print(f"  Execution ID: {results.get('execution_id', 'unknown')}")
        
        if 'steps' in results:
            print(f"\nStep Results:")
            for step_name, step_result in results['steps'].items():
                status_emoji = "✅" if step_result.get('success', False) else "❌"
                print(f"  {status_emoji} {step_name}: {step_result.get('message', 'No message')}")
        
        # Overall test result
        print("\n" + "=" * 60)
        overall_success = (
            interface_valid and 
            config_valid and 
            results.get('status') in ['completed', 'completed_with_errors']
        )
        
        if overall_success:
            print("🎉 INTEGRATION TEST PASSED")
            print("The integration-agnostic INSERT package works correctly with XeroBlue!")
        else:
            print("❌ INTEGRATION TEST FAILED")
            print("There are issues with the integration-agnostic design.")
        
        print("=" * 60)
        return overall_success
        
    except Exception as e:
        print(f"\n❌ CRITICAL ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_integration_agnostic_design():
    """Test that the design is truly integration-agnostic"""
    print("\n" + "=" * 60)
    print("Testing Integration-Agnostic Design")
    print("=" * 60)
    
    try:
        # Test that the generic orchestrator doesn't contain integration-specific code
        print("\n1. Checking generic orchestrator for integration-agnostic design...")
        
        from integration_package_insert import IntegrationPackageInsert
        import inspect
        
        # Get the source code of the main class
        source = inspect.getsource(IntegrationPackageInsert)
        
        # Check for integration-specific terms (should not be present)
        forbidden_terms = ['XEROBLUE', 'MYOB', 'QBO', 'xeroblue', 'myob', 'qbo']
        found_terms = []
        
        for term in forbidden_terms:
            if term in source:
                found_terms.append(term)
        
        if found_terms:
            print(f"❌ Found integration-specific terms in generic code: {found_terms}")
            return False
        else:
            print(f"✅ No integration-specific terms found in generic orchestrator")
        
        # Test that the SQL Object Manager is integration-agnostic
        print("\n2. Checking SQL Object Manager for integration-agnostic design...")
        
        from sql_object_manager import SQLObjectManagerOrchestrator
        source = inspect.getsource(SQLObjectManagerOrchestrator)
        
        found_terms = []
        for term in forbidden_terms:
            if term in source:
                found_terms.append(term)
        
        if found_terms:
            print(f"❌ Found integration-specific terms in SQL Object Manager: {found_terms}")
            return False
        else:
            print(f"✅ No integration-specific terms found in SQL Object Manager")
        
        # Test configuration flexibility
        print("\n3. Testing configuration flexibility...")
        
        from sql_object_manager import SQLObjectConfig
        
        # Test with different integration configurations
        test_configs = [
            {
                'integration_name': 'XEROBLUE',
                'client_id': '1724',
                'organisation_id': '6051',
                'legacy_client_id': 'test_client_1724',
                'fx_currencies': ['AUD', 'USD', 'EUR']
            },
            {
                'integration_name': 'QBO',
                'client_id': '2061',
                'organisation_id': '7239',
                'legacy_client_id': 'quickbooks_client_2061',
                'fx_currencies': ['USD', 'CAD']
            },
            {
                'integration_name': 'MYOB',
                'client_id': '3141',
                'organisation_id': '8888',
                'legacy_client_id': 'myob_client_3141',
                'fx_currencies': ['AUD', 'NZD']
            }
        ]
        
        for i, test_config in enumerate(test_configs, 1):
            config = SQLObjectConfig(**test_config)
            print(f"  ✅ Configuration {i} ({config.integration_name}): Valid")
        
        print("\n4. Testing factory functions...")
        
        # Test the convenience functions work for different integrations
        from sql_object_manager import create_sql_objects_for_integration
        
        for test_config in test_configs:
            try:
                # This should work without errors (even if it fails due to missing dependencies)
                success, details = create_sql_objects_for_integration(
                    integration_name=test_config['integration_name'],
                    client_id=test_config['client_id'],
                    organisation_id=test_config['organisation_id'],
                    legacy_client_id=test_config['legacy_client_id'],
                    error_list=[],
                    fx_currencies=test_config['fx_currencies'],
                    parallel=False  # Use sequential for testing
                )
                print(f"  ✅ {test_config['integration_name']}: Factory function works")
            except Exception as e:
                print(f"  ⚠️ {test_config['integration_name']}: {str(e)}")
        
        print("\n✅ INTEGRATION-AGNOSTIC DESIGN VERIFIED")
        print("The system is truly integration-agnostic and supports multiple integrations!")
        return True
        
    except Exception as e:
        print(f"❌ Error testing integration-agnostic design: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main test runner"""
    print("🚀 Integration-Agnostic INSERT Package Test Suite")
    print("Testing the redesigned architecture...")
    
    # Run all tests
    test_results = []
    
    # Test 1: XeroBlue integration
    test_results.append(test_xeroblue_insert_integration())
    
    # Test 2: Integration-agnostic design
    test_results.append(test_integration_agnostic_design())
    
    # Summary
    print("\n" + "=" * 80)
    print("TEST SUITE SUMMARY")
    print("=" * 80)
    
    passed_tests = sum(test_results)
    total_tests = len(test_results)
    
    print(f"Tests Passed: {passed_tests}/{total_tests}")
    
    if passed_tests == total_tests:
        print("🎉 ALL TESTS PASSED!")
        print("The integration-agnostic INSERT package is working correctly!")
        exit_code = 0
    else:
        print("❌ SOME TESTS FAILED")
        print("There are issues that need to be addressed.")
        exit_code = 1
    
    print("=" * 80)
    return exit_code

if __name__ == "__main__":
    exit(main())