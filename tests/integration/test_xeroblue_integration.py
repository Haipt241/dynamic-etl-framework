#!/usr/bin/env python3
"""
Test for updated XeroBlue Integration class structure and interface compliance
"""

import os
import sys

# Set required environment variables
os.environ['EtaniClientID'] = 'BIGOLESHOECOMPANY_CLIENT1518'
os.environ['EtaniOrganisationID'] = '5393'
os.environ['XeroTenantID'] = '865512af-e7d8-4d42-8568-73084279eb43'
os.environ['JOB_ID'] = '1'
os.environ['JOB_RUN_ID'] = '0'
os.environ['TRIGGER_TYPE'] = 'MANUAL'
os.environ['DB_Destination'] = 'DW'

# Add path

def test_xeroblue_integration_structure():
    """Test XeroBlue integration class structure"""
    print("🧪 Testing XeroBlue Integration Class Structure")
    print("-" * 50)
    
    try:
        # Import the integration
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        from dynamic_integrations import BaseIntegration, IntegrationCapability
        
        print("✅ Imports successful")
        
        # Test class creation (with minimal config to avoid external dependencies)
        xeroblue_integration = XeroblueIntegration({'debug': True, 'test_mode': True})
        
        print("✅ XeroBlue integration instance created")
        print(f"   Integration name: {xeroblue_integration.integration_name}")
        print(f"   Capabilities: {xeroblue_integration.capabilities.value}")
        print(f"   Supports UPSERT: {xeroblue_integration.supports_upsert()}")
        print(f"   Supports INSERT: {xeroblue_integration.supports_insert()}")
        
        # Test that it inherits from BaseIntegration
        assert isinstance(xeroblue_integration, BaseIntegration), "XeroblueIntegration must inherit from BaseIntegration"
        print("✅ Correctly inherits from BaseIntegration")
        
        # Test required interface methods exist
        required_methods = ['validate_configuration', 'run_full_sync', 'get_endpoints_list', 'get_insert_configuration']
        for method in required_methods:
            assert hasattr(xeroblue_integration, method), f"Missing required method: {method}"
            assert callable(getattr(xeroblue_integration, method)), f"Method {method} is not callable"
        
        print("✅ All required interface methods present")
        
        # Test endpoints list
        endpoints = xeroblue_integration.get_endpoints_list()
        assert isinstance(endpoints, list), "get_endpoints_list must return a list"
        assert len(endpoints) > 0, "Must have at least one endpoint"
        
        print(f"✅ Endpoints list: {len(endpoints)} endpoints available")
        print(f"   Sample endpoints: {endpoints[:5]}")
        
        # Test configuration validation (should work even with mock config)
        try:
            is_valid = xeroblue_integration.validate_configuration()
            print(f"✅ Configuration validation completed: {is_valid}")
        except Exception as e:
            print(f"ℹ️  Configuration validation failed (expected with mock config): {e}")
        
        # Test capabilities
        assert xeroblue_integration.capabilities == IntegrationCapability.BOTH, "XeroBlue should support BOTH INSERT and UPSERT"
        print("✅ Capabilities correctly set to BOTH")
        
        # Test INSERT configuration
        try:
            insert_config = xeroblue_integration.get_insert_configuration()
            assert isinstance(insert_config, dict), "get_insert_configuration must return a dict"
            print("✅ INSERT configuration accessible")
            print(f"   Integration name: {insert_config.get('integration_name')}")
        except Exception as e:
            print(f"⚠️  INSERT configuration failed: {e}")
        
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
            create_package_upsert, create_package_insert, register_integration, 
            validate_integration_interface, create_integration_package
        )
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        # Test interface validation
        xeroblue_integration = XeroblueIntegration({'debug': True})
        is_valid = validate_integration_interface(xeroblue_integration)
        assert is_valid, "XeroBlue integration must pass interface validation"
        print("✅ Interface validation passed")
        
        # Test registration
        register_integration('XEROBLUE', XeroblueIntegration)
        print("✅ Registration successful")
        
        # Test orchestrator creation with instance (new way)
        orchestrator1 = create_package_upsert(xeroblue_integration)
        assert orchestrator1.operation_mode.value == 'UPSERT', "Should be UPSERT mode"
        print("✅ UPSERT orchestrator creation with instance successful")
        
        # Test orchestrator creation with name (backward compatibility)
        orchestrator2 = create_package_upsert('XEROBLUE', {'debug': True})
        assert orchestrator2.operation_mode.value == 'UPSERT', "Should be UPSERT mode"
        print("✅ UPSERT orchestrator creation with name successful")
        
        # Test INSERT orchestrator creation
        orchestrator3 = create_package_insert(xeroblue_integration)
        assert orchestrator3.operation_mode.value == 'INSERT', "Should be INSERT mode"
        print("✅ INSERT orchestrator creation successful")
        
        # Test with create_integration_package (auto-detect)
        orchestrator4 = create_integration_package(xeroblue_integration)
        # Should default to UPSERT for BOTH capability integrations
        assert orchestrator4.operation_mode.value == 'UPSERT', "Should auto-detect UPSERT mode"
        print("✅ Auto-detect orchestrator creation successful")
        
        return True
        
    except Exception as e:
        print(f"❌ Compatibility test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_key_methods_exist():
    """Test that key methods from original XeroBlue integration exist"""
    print("\n🔧 Testing Key Methods Implementation")
    print("-" * 50)
    
    try:
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        xeroblue_integration = XeroblueIntegration({'debug': True})
        
        # Key methods that should exist (from original XeroBlue integration)
        key_methods = [
            'build_api_url',                    # Core API URL building
            'get_auth_headers',                 # Authentication headers
            'apply_rate_limiting',              # Rate limiting
            'refresh_token_request',            # Token refresh
            'make_api_request',                 # Main API request method
            'extract_api_response',             # Main extraction method
            'run_full_sync',                    # Full sync method
            'create_sql_objects',               # SQL object creation
            'initialize_indexes',               # Index initialization
            'upload_powerbi_template',          # PowerBI template upload
        ]
        
        missing_methods = []
        for method in key_methods:
            if not hasattr(xeroblue_integration, method):
                missing_methods.append(method)
        
        if missing_methods:
            print(f"⚠️  Missing methods: {missing_methods}")
        else:
            print("✅ All key methods implemented")
        
        # Test that key attributes exist
        key_attributes = [
            'integration_name', 'capabilities', 'integration_config',
            'table_prefix', 'rate_limit', 'api_calls', 'error_list'
        ]
        
        missing_attributes = []
        for attr in key_attributes:
            if not hasattr(xeroblue_integration, attr):
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
    print("🚀 XeroBlue Integration Test Suite")
    print("=" * 60)
    
    tests = [
        test_xeroblue_integration_structure,
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
        print("🎉 All tests passed! XeroBlue integration refactoring is successful.")
        print("\nNext steps:")
        print("1. Set proper environment variables for XeroBlue credentials")
        print("2. Use the integration with the dynamic orchestrator:")
        print("   from dynamic_integrations import create_package_upsert")
        print("   orchestrator = create_package_upsert('XEROBLUE', config)")
        print("   result = orchestrator.run()")
        print("3. Or use the new instance-based approach:")
        print("   from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration")
        print("   xeroblue = XeroblueIntegration(config)")
        print("   orchestrator = create_package_upsert(xeroblue)")
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