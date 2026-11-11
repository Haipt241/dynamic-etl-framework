#!/usr/bin/env python3
"""
Simple test for QBO Integration class structure and interface compliance
"""

import os
import sys

# Set required environment variables
os.environ['EtaniClientID'] = 'BIGOLESHOECOMPANY_CLIENT2013'
os.environ['EtaniOrganisationID'] = '7035'
os.environ['RealmID'] = '193514518158004'
os.environ['JOB_ID'] = '1'
os.environ['JOB_RUN_ID'] = '0'
os.environ['TRIGGER_TYPE'] = 'MANUAL'
os.environ['DB_Destination'] = 'EVA'

# Add path

def test_qbo_integration_structure():
    """Test QBO integration class structure"""
    print("🧪 Testing QBO Integration Class Structure")
    print("-" * 50)
    
    try:
        # Import the integration
        from dynamic_integrations.compatibility.integrations.qbo_integration import QBOIntegration
        from dynamic_integrations import BaseIntegration, IntegrationCapability
        
        print("✅ Imports successful")
        
        # Test class creation (with minimal config to avoid external dependencies)
        qbo_integration = QBOIntegration({'debug': True, 'test_mode': True})
        
        print("✅ QBO integration instance created")
        print(f"   Integration name: {qbo_integration.integration_name}")
        print(f"   Capabilities: {qbo_integration.capabilities.value}")
        print(f"   Supports UPSERT: {qbo_integration.supports_upsert()}")
        print(f"   Supports INSERT: {qbo_integration.supports_insert()}")
        
        # Test that it inherits from BaseIntegration
        assert isinstance(qbo_integration, BaseIntegration), "QBOIntegration must inherit from BaseIntegration"
        print("✅ Correctly inherits from BaseIntegration")
        
        # Test required interface methods exist
        required_methods = ['validate_configuration', 'run_full_sync', 'get_endpoints_list']
        for method in required_methods:
            assert hasattr(qbo_integration, method), f"Missing required method: {method}"
            assert callable(getattr(qbo_integration, method)), f"Method {method} is not callable"
        
        print("✅ All required interface methods present")
        
        # Test endpoints list
        endpoints = qbo_integration.get_endpoints_list()
        assert isinstance(endpoints, list), "get_endpoints_list must return a list"
        assert len(endpoints) > 0, "Must have at least one endpoint"
        
        print(f"✅ Endpoints list: {len(endpoints)} endpoints available")
        print(f"   Sample endpoints: {endpoints[:5]}")
        
        # Test configuration validation (should work even with mock config)
        try:
            is_valid = qbo_integration.validate_configuration()
            print(f"✅ Configuration validation completed: {is_valid}")
        except Exception as e:
            print(f"ℹ️  Configuration validation failed (expected with mock config): {e}")
        
        # Test capabilities
        assert qbo_integration.capabilities == IntegrationCapability.UPSERT, "QBO should be UPSERT only"
        print("✅ Capabilities correctly set to UPSERT")
        
        return True
        
    except Exception as e:
        print(f"❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_integration_agnostic_compatibility():
    """Test compatibility with integration-agnostic system"""
    print("\n🔗 Testing Integration-Agnostic Compatibility")
    print("-" * 50)
    
    try:
        from dynamic_integrations import (
            create_package_upsert, register_integration, 
            validate_integration_interface, create_integration_package
        )
        from dynamic_integrations.compatibility.integrations.qbo_integration import QBOIntegration
        
        # Test interface validation
        qbo_integration = QBOIntegration({'debug': True})
        is_valid = validate_integration_interface(qbo_integration)
        assert is_valid, "QBO integration must pass interface validation"
        print("✅ Interface validation passed")
        
        # Test registration
        register_integration('QBO', QBOIntegration)
        print("✅ Registration successful")
        
        # Test orchestrator creation with instance (new way)
        orchestrator1 = create_package_upsert(qbo_integration)
        assert orchestrator1.operation_mode.value == 'UPSERT', "Should be UPSERT mode"
        print("✅ Orchestrator creation with instance successful")
        
        # Test orchestrator creation with name (backward compatibility)
        orchestrator2 = create_package_upsert('QBO', {'debug': True})
        assert orchestrator2.operation_mode.value == 'UPSERT', "Should be UPSERT mode"
        print("✅ Orchestrator creation with name successful")
        
        # Test with create_integration_package
        orchestrator3 = create_integration_package(qbo_integration)
        assert orchestrator3.operation_mode.value == 'UPSERT', "Should auto-detect UPSERT mode"
        print("✅ Auto-detect orchestrator creation successful")
        
        return True
        
    except Exception as e:
        print(f"❌ Compatibility test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_key_methods_exist():
    """Test that key methods from original QBO - UPSERT.py exist"""
    print("\n🔧 Testing Key Methods Implementation")
    print("-" * 50)
    
    try:
        from dynamic_integrations.compatibility.integrations.qbo_integration import QBOIntegration
        
        qbo_integration = QBOIntegration({'debug': True})
        
        # Key methods that should exist (from original QBO script)
        key_methods = [
            '_qbo_api_request',           # Core API request method
            '_apply_rate_limiting',       # Rate limiting
            '_get_token_from_file',       # Token management
            '_refresh_token',             # Token refresh
            'extract_api_response',       # Main extraction method
            '_process_company_info_endpoint',  # CompanyInfo processing
            '_process_query_endpoint',    # Query endpoint processing
            '_process_report_endpoint',   # Report endpoint processing
            '_process_paginated_data_streaming',  # Pagination
            '_get_cms_details',          # CMS details
            '_load_to_stage_table',      # Stage table loading
            '_execute_stored_procedure', # SP execution
        ]
        
        missing_methods = []
        for method in key_methods:
            if not hasattr(qbo_integration, method):
                missing_methods.append(method)
        
        if missing_methods:
            print(f"⚠️  Missing methods: {missing_methods}")
        else:
            print("✅ All key methods implemented")
        
        # Test that key attributes exist
        key_attributes = [
            'integration_name', 'capabilities', 'client_id', 'client_secret',
            'realm_id', 'etani_client_id', 'etani_organisation_id', 
            'table_prefix_eva', 'error_list', 'api_calls'
        ]
        
        missing_attributes = []
        for attr in key_attributes:
            if not hasattr(qbo_integration, attr):
                missing_attributes.append(attr)
        
        if missing_attributes:
            print(f"⚠️  Missing attributes: {missing_attributes}")
        else:
            print("✅ All key attributes present")
        
        return len(missing_methods) == 0 and len(missing_attributes) == 0
        
    except Exception as e:
        print(f"❌ Key methods test failed: {str(e)}")
        return False

def main():
    """Run all tests"""
    print("🚀 QBO Integration Test Suite")
    print("=" * 60)
    
    tests = [
        test_qbo_integration_structure,
        test_integration_agnostic_compatibility,
        test_key_methods_exist
    ]
    
    results = []
    for test in tests:
        result = test()
        results.append(result)
    
    print("\n" + "=" * 60)
    print("TEST RESULTS SUMMARY")
    print("=" * 60)
    
    passed = sum(results)
    total = len(results)
    
    for i, (test, result) in enumerate(zip(tests, results), 1):
        status = "✅ PASSED" if result else "❌ FAILED"
        print(f"Test {i}: {test.__name__} - {status}")
    
    print(f"\nOverall: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! QBO integration is ready to use.")
        print("\nNext steps:")
        print("1. Set proper environment variables for QBO credentials")
        print("2. Use the integration with the dynamic orchestrator:")
        print("   from dynamic_integrations import create_package_upsert")
        print("   orchestrator = create_package_upsert('QBO', config)")
        print("   result = orchestrator.run()")
    else:
        print("❌ Some tests failed. Please review the implementation.")
    
    return passed == total

# Import path utilities for dynamic path resolution
try:
    from path_utils import setup_project_paths
except ImportError:
    try:
        from .path_utils import setup_project_paths
    except ImportError:
        # If path_utils is not available, set up paths manually
        def setup_project_paths():
            current_dir = os.path.dirname(os.path.abspath(__file__))
            etl_packages_dir = os.path.dirname(current_dir)
            project_root = os.path.dirname(etl_packages_dir)
            
            if project_root not in sys.path:
                sys.path.insert(0, project_root)
            if etl_packages_dir not in sys.path:
                sys.path.insert(0, etl_packages_dir)

# Set up project paths
setup_project_paths()

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)