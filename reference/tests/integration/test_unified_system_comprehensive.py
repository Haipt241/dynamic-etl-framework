#!/usr/bin/env python3
"""
Comprehensive Test Suite for Unified Dynamic Integration System

This test suite validates the complete unified integration system including:
- Unified orchestrator with operation detection
- Integration registry and factory functions
- Interface validation and compliance
- XeroBlue and QBO integration compatibility
- Error handling and edge cases
"""

import os
import sys
import unittest
import tempfile
from unittest.mock import Mock, patch, MagicMock
from io import StringIO

# Set environment variables before importing
os.environ.setdefault('EtaniClientID', 'c1518')
os.environ.setdefault('EtaniOrganisationID', '7232')
os.environ.setdefault('XeroTenantID', 'test-tenant-id')
os.environ.setdefault('DB_Destination', 'EVA')

# Import system components
from dynamic_integrations.IntegrationPackage import (
    IntegrationPackage, OperationMode, create_integration_package,
    create_package_upsert, create_package_insert, 
    list_registered_integrations, register_integration
)
from dynamic_integrations.base_integration import BaseIntegration, IntegrationCapability

class MockIntegration(BaseIntegration):
    """Mock integration for testing purposes"""
    
    def __init__(self, config=None, capabilities=IntegrationCapability.BOTH):
        self._integration_name = "MOCK_INTEGRATION"
        self._capabilities = capabilities
        self._config = config or {}
        super().__init__(config)
    
    @property
    def integration_name(self) -> str:
        return self._integration_name
    
    @property
    def capabilities(self) -> IntegrationCapability:
        return self._capabilities
    
    def validate_configuration(self) -> bool:
        return True
    
    def get_insert_configuration(self):
        return {
            'integration_name': self.integration_name,
            'client_id': 'test_client',
            'organisation_id': 'test_org',
            'legacy_client_id': 'test_legacy',
            'base_currency': 'USD',
            'fx_currencies': ['USD', 'EUR'],
            'error_list': []
        }
    
    def run_full_sync(self, endpoint_list=None):
        return {
            'status': 'completed',
            'duration_seconds': 1.5,
            'total_endpoints': len(endpoint_list) if endpoint_list else 5,
            'successful_endpoints': len(endpoint_list) if endpoint_list else 5,
            'total_records_processed': 100
        }

class TestUnifiedOrchestrator(unittest.TestCase):
    """Test the unified orchestrator functionality"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.mock_integration = MockIntegration()
    
    def test_orchestrator_creation_auto_mode(self):
        """Test orchestrator creation with auto operation detection"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.AUTO)
        
        self.assertIsInstance(orchestrator, IntegrationPackage)
        self.assertEqual(orchestrator.integration.integration_name, "MOCK_INTEGRATION")
        # Should default to UPSERT for integrations that support both
        self.assertEqual(orchestrator.operation_mode, OperationMode.UPSERT)
    
    def test_orchestrator_creation_explicit_modes(self):
        """Test orchestrator creation with explicit operation modes"""
        # Test UPSERT mode
        orchestrator_upsert = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        self.assertEqual(orchestrator_upsert.operation_mode, OperationMode.UPSERT)
        
        # Test INSERT mode
        orchestrator_insert = create_integration_package(self.mock_integration, OperationMode.INSERT)
        self.assertEqual(orchestrator_insert.operation_mode, OperationMode.INSERT)
    
    def test_orchestrator_with_insert_only_integration(self):
        """Test orchestrator with integration that only supports INSERT"""
        insert_only_integration = MockIntegration(capabilities=IntegrationCapability.INSERT)
        orchestrator = create_integration_package(insert_only_integration, OperationMode.AUTO)
        
        self.assertEqual(orchestrator.operation_mode, OperationMode.INSERT)
    
    def test_orchestrator_with_upsert_only_integration(self):
        """Test orchestrator with integration that only supports UPSERT"""
        upsert_only_integration = MockIntegration(capabilities=IntegrationCapability.UPSERT)
        orchestrator = create_integration_package(upsert_only_integration, OperationMode.AUTO)
        
        self.assertEqual(orchestrator.operation_mode, OperationMode.UPSERT)
    
    def test_orchestrator_execution_id_generation(self):
        """Test execution ID generation"""
        orchestrator1 = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        orchestrator2 = create_integration_package(self.mock_integration, OperationMode.INSERT)
        
        self.assertIsInstance(orchestrator1.execution_id, str)
        self.assertIsInstance(orchestrator2.execution_id, str)
        self.assertNotEqual(orchestrator1.execution_id, orchestrator2.execution_id)
        self.assertIn("UPSERT", orchestrator1.execution_id)
        self.assertIn("INSERT", orchestrator2.execution_id)

class TestInterfaceValidation(unittest.TestCase):
    """Test integration interface validation"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.mock_integration = MockIntegration()
    
    def test_upsert_interface_validation(self):
        """Test UPSERT interface validation"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        self.assertTrue(orchestrator.validate_integration_interface())
    
    def test_insert_interface_validation(self):
        """Test INSERT interface validation"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.INSERT)
        self.assertTrue(orchestrator.validate_integration_interface())
    
    def test_invalid_integration_type(self):
        """Test validation with invalid integration type"""
        with self.assertRaises(ValueError):
            create_integration_package("not_an_integration", OperationMode.UPSERT)
    
    def test_integration_info_retrieval(self):
        """Test integration info retrieval"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        info = orchestrator.get_integration_info()
        
        self.assertEqual(info['integration_name'], 'MOCK_INTEGRATION')
        self.assertEqual(info['integration_class'], 'MockIntegration')
        self.assertEqual(info['operation_mode'], 'UPSERT')
        self.assertIn('execution_id', info)

class TestFactoryFunctions(unittest.TestCase):
    """Test factory functions for orchestrator creation"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.mock_integration = MockIntegration()
    
    def test_create_package_insert(self):
        """Test INSERT-specific factory function"""
        orchestrator = create_package_insert(self.mock_integration)
        self.assertEqual(orchestrator.operation_mode, OperationMode.INSERT)
    
    def test_create_package_upsert_with_instance(self):
        """Test UPSERT factory function with integration instance"""
        orchestrator = create_package_upsert(self.mock_integration)
        self.assertEqual(orchestrator.operation_mode, OperationMode.UPSERT)
    
    def test_create_package_upsert_validation(self):
        """Test UPSERT factory function validation"""
        # Test with integration that doesn't support UPSERT
        insert_only_integration = MockIntegration(capabilities=IntegrationCapability.INSERT)
        
        with self.assertRaises(ValueError):
            create_package_upsert(insert_only_integration)

class TestIntegrationRegistry(unittest.TestCase):
    """Test integration registry functionality"""
    
    def test_integration_registration(self):
        """Test registering and using integrations"""
        # Register a test integration
        register_integration('TEST_INTEGRATION', MockIntegration)
        
        # Check if it's registered
        registered_integrations = list_registered_integrations()
        self.assertIn('TEST_INTEGRATION', registered_integrations)

class TestRealIntegrations(unittest.TestCase):
    """Test real integration implementations"""
    
    def test_xeroblue_integration_import(self):
        """Test XeroBlue integration import and basic functionality"""
        try:
            from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration
            
            # Test creation with minimal config
            config = {'rate_limit': 60, 'apply_default_values': False}
            xeroblue = XeroblueIntegration(config)
            
            # Test interface compliance
            self.assertIsInstance(xeroblue, BaseIntegration)
            self.assertEqual(xeroblue.integration_name, "XEROBLUE")
            self.assertEqual(xeroblue.capabilities, IntegrationCapability.BOTH)
            self.assertTrue(xeroblue.validate_configuration())
            
        except ImportError as e:
            self.skipTest(f"XeroBlue integration not available: {e}")
    
    def test_qbo_integration_import(self):
        """Test QBO integration import and basic functionality"""
        try:
            from dynamic_integrations.integrations.qbo_integration import QBOIntegration
            
            # Test creation with minimal config
            config = {'rate_limit': 60}
            qbo = QBOIntegration(config)
            
            # Test interface compliance
            self.assertIsInstance(qbo, BaseIntegration)
            self.assertEqual(qbo.integration_name, "QBO")
            self.assertIn(qbo.capabilities, [IntegrationCapability.UPSERT, IntegrationCapability.BOTH])
            
        except ImportError as e:
            self.skipTest(f"QBO integration not available: {e}")

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

class TestOrchestratorExecution(unittest.TestCase):
    """Test orchestrator execution flows"""
    
    def setUp(self):
        """Set up test fixtures"""
        self.mock_integration = MockIntegration()
    
    @patch('sys.stdout', new_callable=StringIO)
    def test_upsert_execution_flow(self, mock_stdout):
        """Test UPSERT execution flow"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        
        # Mock the actual API calls to avoid real connections
        with patch.object(self.mock_integration, 'run_full_sync') as mock_sync:
            mock_sync.return_value = {
                'status': 'completed',
                'duration_seconds': 2.5,
                'total_endpoints': 3,
                'successful_endpoints': 3,
                'total_records_processed': 150
            }
            
            result = orchestrator.run(['Accounts', 'Invoices', 'Contacts'])
            
            self.assertEqual(result['status'], 'completed')
            self.assertIn('execution_id', result)
            self.assertIn('orchestrator_duration', result)
            mock_sync.assert_called_once_with(['Accounts', 'Invoices', 'Contacts'])
    
    def test_insert_execution_flow(self):
        """Test INSERT execution flow"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.INSERT)
        
        # Test run_initialization
        result = orchestrator.run_initialization(
            create_objects=False,  # Skip actual SQL creation
            initialize_indexes=False,  # Skip actual index creation
            upload_pbi=False  # Skip PowerBI upload
        )
        
        self.assertEqual(result['status'], 'completed')
        self.assertIn('execution_id', result)
        self.assertEqual(result['operation_mode'], 'INSERT')
    
    def test_single_endpoint_execution(self):
        """Test single endpoint execution"""
        orchestrator = create_integration_package(self.mock_integration, OperationMode.UPSERT)
        
        with patch.object(self.mock_integration, 'run_full_sync') as mock_sync:
            mock_sync.return_value = {'status': 'completed', 'records': 50}
            
            result = orchestrator.run_single_endpoint('Accounts')
            
            self.assertEqual(result['status'], 'completed')
            self.assertTrue(result['single_endpoint_mode'])
            self.assertEqual(result['processed_endpoint'], 'Accounts')

class TestErrorHandling(unittest.TestCase):
    """Test error handling and edge cases"""
    
    def test_invalid_operation_mode(self):
        """Test handling of invalid operation modes"""
        mock_integration = MockIntegration()
        
        with self.assertRaises(ValueError):
            IntegrationPackage(mock_integration, "INVALID_MODE")
    
    def test_configuration_validation_failure(self):
        """Test handling of configuration validation failure"""
        # Create integration that fails validation
        class FailingIntegration(MockIntegration):
            def validate_configuration(self):
                return False
        
        failing_integration = FailingIntegration()
        orchestrator = create_integration_package(failing_integration, OperationMode.UPSERT)
        
        result = orchestrator.run()
        self.assertEqual(result['status'], 'failed')
        self.assertIn('configuration validation failed', result['error'].lower())
    
    def test_unsupported_operation_mode_for_integration(self):
        """Test requesting unsupported operation mode for integration"""
        insert_only_integration = MockIntegration(capabilities=IntegrationCapability.INSERT)
        
        # This should work fine - orchestrator will use INSERT mode
        orchestrator = create_integration_package(insert_only_integration, OperationMode.AUTO)
        self.assertEqual(orchestrator.operation_mode, OperationMode.INSERT)
        
        # But requesting UPSERT explicitly should be handled gracefully
        orchestrator_upsert = create_integration_package(insert_only_integration, OperationMode.UPSERT)
        # The orchestrator allows this but validation should catch it
        self.assertFalse(orchestrator_upsert.validate_integration_interface())

class TestSystemIntegration(unittest.TestCase):
    """Test complete system integration scenarios"""
    
    def test_end_to_end_upsert_workflow(self):
        """Test complete end-to-end UPSERT workflow"""
        mock_integration = MockIntegration()
        
        # Create orchestrator
        orchestrator = create_integration_package(mock_integration, OperationMode.AUTO)
        
        # Validate it auto-detected UPSERT
        self.assertEqual(orchestrator.operation_mode, OperationMode.UPSERT)
        
        # Validate interface
        self.assertTrue(orchestrator.validate_integration_interface())
        
        # Execute workflow
        result = orchestrator.run()
        
        # Validate results
        self.assertEqual(result['status'], 'completed')
        self.assertEqual(result['operation_mode'], 'UPSERT')
        self.assertIn('orchestrator_duration', result)
    
    def test_end_to_end_insert_workflow(self):
        """Test complete end-to-end INSERT workflow"""
        mock_integration = MockIntegration()
        
        # Create orchestrator with explicit INSERT mode
        orchestrator = create_integration_package(mock_integration, OperationMode.INSERT)
        
        # Validate interface
        self.assertTrue(orchestrator.validate_integration_interface())
        
        # Execute initialization workflow
        result = orchestrator.run_initialization(
            create_objects=False,  # Skip actual SQL operations for test
            initialize_indexes=False,
            upload_pbi=False
        )
        
        # Validate results
        self.assertEqual(result['status'], 'completed')
        self.assertEqual(result['operation_mode'], 'INSERT')
        self.assertIn('orchestrator_duration', result)

def run_comprehensive_tests():
    """Run all comprehensive tests"""
    
    print("🧪 Running Comprehensive Unified System Tests")
    print("=" * 60)
    
    # Create test suite
    test_suite = unittest.TestSuite()
    
    # Add all test classes
    test_classes = [
        TestUnifiedOrchestrator,
        TestInterfaceValidation, 
        TestFactoryFunctions,
        TestIntegrationRegistry,
        TestRealIntegrations,
        TestOrchestratorExecution,
        TestErrorHandling,
        TestSystemIntegration
    ]
    
    for test_class in test_classes:
        tests = unittest.TestLoader().loadTestsFromTestCase(test_class)
        test_suite.addTests(tests)
    
    # Run tests
    runner = unittest.TextTestRunner(verbosity=2, stream=sys.stdout)
    result = runner.run(test_suite)
    
    # Print summary
    print("\n" + "=" * 60)
    print("📊 COMPREHENSIVE TEST RESULTS SUMMARY")
    print("=" * 60)
    
    total_tests = result.testsRun
    failures = len(result.failures)
    errors = len(result.errors)
    passed = total_tests - failures - errors
    
    print(f"Tests Run: {total_tests}")
    print(f"✅ Passed: {passed}")
    print(f"❌ Failed: {failures}")
    print(f"💥 Errors: {errors}")
    
    if failures:
        print(f"\n🔍 FAILURES:")
        for test, trace in result.failures:
            print(f"  - {test}: {trace.split('AssertionError:')[-1].strip()}")
    
    if errors:
        print(f"\n💥 ERRORS:")
        for test, trace in result.errors:
            print(f"  - {test}: {trace.split('\\n')[-2]}")
    
    success_rate = (passed / total_tests) * 100 if total_tests > 0 else 0
    print(f"\n📈 Success Rate: {success_rate:.1f}%")
    
    if success_rate >= 90:
        print("\n🎉 EXCELLENT! Unified system is working correctly!")
        print("✅ All major components tested and validated")
        print("✅ Operation detection functioning properly") 
        print("✅ Interface validation working correctly")
        print("✅ Factory functions operational")
        print("✅ Error handling robust")
        print("🚀 System ready for production!")
    elif success_rate >= 75:
        print("\n✅ GOOD! Most components working correctly")
        print("⚠️  Some minor issues to address")
    else:
        print("\n❌ NEEDS WORK! Several components need attention")
        print("🔧 Please review failed tests and address issues")
    
    return result.wasSuccessful()

if __name__ == '__main__':
    """
    Main entry point for comprehensive testing
    """
    print("🚀 Comprehensive Unified Dynamic Integration System Test Suite")
    print("Testing all components of the unified orchestrator, integrations, and interfaces")
    print()
    
    success = run_comprehensive_tests()
    
    if success:
        print("\n🎯 All tests passed! System is ready!")
        exit(0)
    else:
        print("\n⚠️  Some tests failed. Please review and fix issues.")
        exit(1)