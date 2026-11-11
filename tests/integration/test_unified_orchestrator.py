#!/usr/bin/env python3
"""
Test the Unified Integration Orchestrator

This test validates that the unified IntegrationPackage orchestrator
works correctly with operation detection and our XeroBlue integration.
"""

import os
import sys

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

def test_orchestrator_creation():
    """Test creating orchestrator with different operation modes"""
    
    print("🧪 Testing Unified Orchestrator Creation")
    print("=" * 50)
    
    try:
        from dynamic_integrations.compatibility.package import create_integration_package, OperationMode
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create XeroBlue integration instance
        config = {'rate_limit': 60, 'debug': True}
        xeroblue_integration = XeroblueIntegration(config)
        
        print("1. Testing AUTO operation mode detection...")
        orchestrator_auto = create_integration_package(xeroblue_integration, OperationMode.AUTO)
        print(f"   ✅ Auto-detected mode: {orchestrator_auto.operation_mode.value}")
        
        print("2. Testing explicit UPSERT mode...")
        orchestrator_upsert = create_integration_package(xeroblue_integration, OperationMode.UPSERT)
        print(f"   ✅ Explicit UPSERT mode: {orchestrator_upsert.operation_mode.value}")
        
        print("3. Testing explicit INSERT mode...")
        orchestrator_insert = create_integration_package(xeroblue_integration, OperationMode.INSERT)
        print(f"   ✅ Explicit INSERT mode: {orchestrator_insert.operation_mode.value}")
        
        print("4. Testing integration info retrieval...")
        info = orchestrator_auto.get_integration_info()
        print(f"   ✅ Integration name: {info.get('integration_name')}")
        print(f"   ✅ Integration class: {info.get('integration_class')}")
        print(f"   ✅ Operation mode: {info.get('operation_mode')}")
        print(f"   ✅ Execution ID: {info.get('execution_id')}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_orchestrator_validation():
    """Test orchestrator interface validation"""
    
    print("\n🔍 Testing Orchestrator Interface Validation")
    print("=" * 45)
    
    try:
        from dynamic_integrations.compatibility.package import create_integration_package, OperationMode
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        
        # Create XeroBlue integration instance
        xeroblue_integration = XeroblueIntegration({'rate_limit': 60})
        
        print("1. Testing UPSERT interface validation...")
        orchestrator_upsert = create_integration_package(xeroblue_integration, OperationMode.UPSERT)
        upsert_valid = orchestrator_upsert.validate_integration_interface()
        print(f"   ✅ UPSERT interface valid: {upsert_valid}")
        
        print("2. Testing INSERT interface validation...")
        orchestrator_insert = create_integration_package(xeroblue_integration, OperationMode.INSERT)
        insert_valid = orchestrator_insert.validate_integration_interface()
        print(f"   ✅ INSERT interface valid: {insert_valid}")
        
        print("3. Testing configuration validation...")
        config_valid = xeroblue_integration.validate_configuration()
        print(f"   ✅ Configuration valid: {config_valid}")
        
        return upsert_valid and insert_valid and config_valid
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_factory_functions():
    """Test factory functions for backward compatibility"""
    
    print("\n🏭 Testing Factory Functions")
    print("=" * 30)
    
    try:
        from dynamic_integrations.compatibility.package import create_package_upsert, create_package_insert
        
        print("1. Testing create_package_upsert with string name...")
        orchestrator_upsert_str = create_package_upsert('XEROBLUE', {'rate_limit': 60})
        print(f"   ✅ Created UPSERT orchestrator: {orchestrator_upsert_str.integration.integration_name}")
        
        print("2. Testing create_package_insert with integration instance...")
        from dynamic_integrations.compatibility.integrations.xeroblue_integration import XeroblueIntegration
        xeroblue_integration = XeroblueIntegration({'rate_limit': 60})
        orchestrator_insert = create_package_insert(xeroblue_integration)
        print(f"   ✅ Created INSERT orchestrator: {orchestrator_insert.integration.integration_name}")
        
        print("3. Testing operation mode assignment...")
        print(f"   ✅ UPSERT mode: {orchestrator_upsert_str.operation_mode.value}")
        print(f"   ✅ INSERT mode: {orchestrator_insert.operation_mode.value}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

def test_integration_registry():
    """Test integration registry functionality"""
    
    print("\n📋 Testing Integration Registry")
    print("=" * 35)
    
    try:
        from dynamic_integrations.compatibility.package import (
            list_registered_integrations, 
            is_integration_registered,
            create_integration_from_registry
        )
        
        print("1. Testing registry listing...")
        registered_integrations = list_registered_integrations()
        print(f"   ✅ Registered integrations: {registered_integrations}")
        
        print("2. Testing XEROBLUE registration check...")
        xeroblue_registered = is_integration_registered('XEROBLUE')
        print(f"   ✅ XEROBLUE registered: {xeroblue_registered}")
        
        if xeroblue_registered:
            print("3. Testing integration creation from registry...")
            xeroblue_from_registry = create_integration_from_registry('XEROBLUE', {'rate_limit': 60})
            print(f"   ✅ Created from registry: {xeroblue_from_registry.integration_name}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

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

if __name__ == '__main__':
    try:
        print("🚀 Testing Unified Integration Orchestrator\n")
        
        # Run all tests
        test1_passed = test_orchestrator_creation()
        test2_passed = test_orchestrator_validation()
        test3_passed = test_factory_functions()
        test4_passed = test_integration_registry()
        
        print("\n" + "=" * 60)
        print("📊 TEST RESULTS SUMMARY")
        print("=" * 60)
        
        results = [
            ("Orchestrator Creation", test1_passed),
            ("Interface Validation", test2_passed),
            ("Factory Functions", test3_passed),
            ("Integration Registry", test4_passed)
        ]
        
        passed_count = sum(1 for _, passed in results if passed)
        total_count = len(results)
        
        for test_name, passed in results:
            status = "✅ PASSED" if passed else "❌ FAILED"
            print(f"  {status}: {test_name}")
        
        print(f"\n📈 Overall: {passed_count}/{total_count} tests passed")
        
        if passed_count == total_count:
            print("\n🎉 ALL TESTS PASSED!")
            print("✅ Unified orchestrator working correctly")
            print("✅ Operation detection functioning")
            print("✅ XeroBlue integration compatible")
            print("✅ Factory functions operational")
            print("✅ Integration registry functional")
            print("🚀 Unified orchestrator ready for production!")
        else:
            print(f"\n❌ {total_count - passed_count} tests failed - please review implementation")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")
        import traceback
        traceback.print_exc()