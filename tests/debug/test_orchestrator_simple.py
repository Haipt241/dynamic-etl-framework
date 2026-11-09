#!/usr/bin/env python3
"""
Simple test of the Unified Integration Orchestrator
"""

import os
import sys

# Set environment variables
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')

def test_basic_import():
    """Test basic import of orchestrator components"""
    
    print("🧪 Testing Basic Orchestrator Import")
    print("=" * 40)
    
    try:
        print("1. Testing IntegrationPackage import...")
        from dynamic_integrations.IntegrationPackage import IntegrationPackage, OperationMode
        print("   ✅ IntegrationPackage imported successfully")
        
        print("2. Testing factory function import...")
        from dynamic_integrations.IntegrationPackage import create_integration_package
        print("   ✅ Factory functions imported successfully")
        
        print("3. Testing OperationMode enum...")
        print(f"   ✅ Available modes: {[mode.value for mode in OperationMode]}")
        
        return True
        
    except Exception as e:
        print(f"   ❌ Import failed: {str(e)}")
        return False

def test_basic_orchestrator():
    """Test basic orchestrator creation"""
    
    print("\n🔧 Testing Basic Orchestrator Creation")
    print("=" * 40)
    
    try:
        from dynamic_integrations.IntegrationPackage import IntegrationPackage, OperationMode
        from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
        
        print("1. Creating XeroBlue integration...")
        # Proper initialization with minimal config to avoid full setup
        config = {'rate_limit': 60, 'apply_default_values': False}
        xeroblue = XeroblueIntegration(config)
        print(f"   ✅ XeroBlue integration created: {xeroblue.integration_name}")
        
        print("2. Creating orchestrator...")
        # Use explicit mode to avoid auto-detection complexity
        orchestrator = IntegrationPackage(xeroblue, OperationMode.UPSERT)
        print(f"   ✅ Orchestrator created with mode: {orchestrator.operation_mode.value}")
        
        print("3. Testing execution ID generation...")
        print(f"   ✅ Execution ID: {orchestrator.execution_id}")
        
        print("4. Testing integration capabilities...")
        print(f"   ✅ Integration capabilities: {xeroblue.capabilities.value}")
        
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
        print("🚀 Simple Unified Orchestrator Test\n")
        
        test1_passed = test_basic_import()
        test2_passed = test_basic_orchestrator()
        
        print("\n" + "=" * 50)
        print("📊 SIMPLE TEST RESULTS")
        print("=" * 50)
        
        if test1_passed and test2_passed:
            print("✅ ALL BASIC TESTS PASSED!")
            print("✅ Unified orchestrator imports working")
            print("✅ Basic orchestrator creation working")
            print("🚀 Ready to proceed with next steps!")
        else:
            print("❌ Some tests failed")
            
    except Exception as e:
        print(f"❌ Test suite failed: {str(e)}")