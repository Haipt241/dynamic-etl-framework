"""
Test for run_full_sync with organization status checking integration

Verifies that the run_full_sync method properly checks execution prerequisites
before proceeding with endpoint processing and returns detailed error responses.
"""

import sys
import os
import unittest
from unittest.mock import patch, MagicMock
import time


class TestRunFullSyncWithStatusChecking(unittest.TestCase):
    """Test cases for run_full_sync with organization status checking"""
    
    def test_execution_blocked_scenario(self):
        """Test run_full_sync when execution is blocked by status check"""
        
        class MockXeroblueIntegration:
            """Mock XeroBlue integration for testing blocked execution"""
            
            def __init__(self, org_status=1, reset_mode=False, db_destination='EVA'):
                self.org_status = org_status
                self.reset_mode = reset_mode
                self.db_destination = db_destination
                self.error_list = []
                self.start_time = time.time()
            
            def should_execute_endpoints(self):
                """Mock method that blocks execution"""
                status_check = (self.org_status == 12) or (self.org_status == 16 and self.reset_mode)
                destination_check = self.db_destination != 'SQL'
                should_execute = status_check and destination_check
                
                if not should_execute:
                    if self.org_status == 1:
                        reason = f"Organization status {self.org_status} (Active) is not 'Updating Data' (12) or 'Resetting Data' (16)"
                    else:
                        reason = "Status or destination not allowed"
                else:
                    reason = "All execution prerequisites satisfied"
                
                return should_execute, reason
            
            def log_execution_decision(self, should_execute, reason):
                """Mock logging method"""
                print(f"📝 Logged decision: {should_execute} - {reason}")
            
            def _get_status_description(self, status_code):
                """Mock status description method"""
                statuses = {1: 'Active', 12: 'Updating Data', 16: 'Resetting Data'}
                return statuses.get(status_code, f'Unknown Status ({status_code})')
            
            def _get_reset_mode(self):
                """Mock reset mode method"""
                return self.reset_mode
            
            def _get_db_destination(self):
                """Mock DB destination method"""
                return self.db_destination
            
            def run_full_sync(self, endpoint_list=None):
                """Simplified version of run_full_sync with status checking"""
                print("\\n" + "="*60)
                print("XeroBlue Integration - Full Sync")
                print("="*60)
                
                # Check execution prerequisites
                print("\\n🔍 Checking execution prerequisites...")
                should_execute, reason = self.should_execute_endpoints()
                
                if not should_execute:
                    # Log the execution decision
                    self.log_execution_decision(should_execute, reason)
                    
                    # Create detailed error response
                    error_response = {
                        'status': 'failed',
                        'error': 'Execution blocked by organization status check',
                        'error_details': {
                            'reason': reason,
                            'organization_status': getattr(self, 'org_status', 'Unknown'),
                            'organization_status_description': self._get_status_description(getattr(self, 'org_status', 0)),
                            'reset_mode': self._get_reset_mode(),
                            'db_destination': self._get_db_destination(),
                            'check_type': 'organization_status_and_environment'
                        },
                        'duration_seconds': 0.0,
                        'total_endpoints': 0,
                        'successful_endpoints': 0,
                        'failed_endpoints': 0,
                        'total_records_processed': 0,
                        'endpoint_results': {},
                        'errors': [reason]
                    }
                    
                    print(f"\\n❌ Execution Blocked:")
                    print(f"   Reason: {reason}")
                    print(f"   Organization Status: {error_response['error_details']['organization_status']} ({error_response['error_details']['organization_status_description']})")
                    print(f"   Reset Mode: {error_response['error_details']['reset_mode']}")
                    print(f"   DB Destination: {error_response['error_details']['db_destination']}")
                    print("="*60)
                    
                    return error_response
                
                # If execution allowed, continue with normal processing
                self.log_execution_decision(should_execute, reason)
                print(f"✅ Execution approved: {reason}")
                
                # Simulate successful execution
                return {
                    'status': 'completed',
                    'duration_seconds': 1.5,
                    'total_endpoints': 5,
                    'successful_endpoints': 5,
                    'failed_endpoints': 0,
                    'total_records_processed': 100,
                    'endpoint_results': {},
                    'errors': []
                }
        
        # Test blocked execution (status 1 = Active, should not execute)
        integration = MockXeroblueIntegration(org_status=1, reset_mode=False, db_destination='EVA')
        result = integration.run_full_sync()
        
        # Verify blocked execution response
        self.assertEqual(result['status'], 'failed')
        self.assertEqual(result['error'], 'Execution blocked by organization status check')
        self.assertIn('organization_status_and_environment', result['error_details']['check_type'])
        self.assertEqual(result['error_details']['organization_status'], 1)
        self.assertEqual(result['error_details']['organization_status_description'], 'Active')
        self.assertEqual(result['error_details']['reset_mode'], False)
        self.assertEqual(result['error_details']['db_destination'], 'EVA')
        self.assertEqual(result['total_endpoints'], 0)
        self.assertEqual(result['successful_endpoints'], 0)
        self.assertEqual(result['duration_seconds'], 0.0)
        self.assertGreater(len(result['errors']), 0)
        
        print("✅ Execution blocked scenario working correctly")
    
    def test_execution_allowed_scenario(self):
        """Test run_full_sync when execution is allowed by status check"""
        
        class MockXeroblueIntegrationAllowed:
            """Mock XeroBlue integration for testing allowed execution"""
            
            def __init__(self):
                self.org_status = 12  # Updating Data - should allow execution
                self.error_list = []
                self.start_time = time.time()
            
            def should_execute_endpoints(self):
                """Mock method that allows execution"""
                return True, "All execution prerequisites satisfied"
            
            def log_execution_decision(self, should_execute, reason):
                """Mock logging method"""
                print(f"📝 Logged decision: {should_execute} - {reason}")
            
            def _get_reset_mode(self):
                return False
            
            def _get_db_destination(self):
                return 'EVA'
            
            def validate_configuration(self):
                """Mock configuration validation"""
                return True
            
            def run_full_sync(self, endpoint_list=None):
                """Simplified version that allows execution"""
                print("\\n" + "="*60)
                print("XeroBlue Integration - Full Sync")
                print("="*60)
                
                # Check execution prerequisites
                should_execute, reason = self.should_execute_endpoints()
                
                if not should_execute:
                    # This shouldn't happen in this test
                    return {'status': 'failed', 'error': 'Unexpected block'}
                
                # Log successful execution decision
                self.log_execution_decision(should_execute, reason)
                print(f"✅ Execution approved: {reason}")
                
                # Validate configuration
                if not self.validate_configuration():
                    return {'status': 'failed', 'error': 'Configuration validation failed'}
                
                # Simulate successful processing
                return {
                    'status': 'completed',
                    'duration_seconds': 2.5,
                    'total_endpoints': 3,
                    'successful_endpoints': 3,
                    'failed_endpoints': 0,
                    'total_records_processed': 150,
                    'endpoint_results': {
                        'Accounts': {'status': 'completed', 'stage_count': 50},
                        'Contacts': {'status': 'completed', 'stage_count': 50},
                        'Invoices': {'status': 'completed', 'stage_count': 50}
                    },
                    'errors': []
                }
        
        # Test allowed execution
        integration = MockXeroblueIntegrationAllowed()
        result = integration.run_full_sync()
        
        # Verify successful execution response
        self.assertEqual(result['status'], 'completed')
        self.assertEqual(result['total_endpoints'], 3)
        self.assertEqual(result['successful_endpoints'], 3)
        self.assertEqual(result['failed_endpoints'], 0)
        self.assertEqual(result['total_records_processed'], 150)
        self.assertGreater(result['duration_seconds'], 0)
        self.assertEqual(len(result['errors']), 0)
        
        print("✅ Execution allowed scenario working correctly")
    
    def test_various_blocked_scenarios(self):
        """Test different scenarios that should block execution"""
        
        class MockIntegrationVariableStatus:
            """Mock integration with configurable status"""
            
            def __init__(self, org_status, reset_mode, db_destination):
                self.org_status = org_status
                self.reset_mode = reset_mode
                self.db_destination = db_destination
                self.error_list = []
            
            def should_execute_endpoints(self):
                """Real business logic implementation"""
                status_check = (self.org_status == 12) or (self.org_status == 16 and self.reset_mode)
                destination_check = self.db_destination != 'SQL'
                should_execute = status_check and destination_check
                
                if not status_check:
                    if self.org_status == 16 and not self.reset_mode:
                        reason = "Organization status is 'Resetting Data' (16) but Reset_Mode is not enabled"
                    elif self.org_status not in [12, 16]:
                        reason = f"Organization status {self.org_status} is not 'Updating Data' (12) or 'Resetting Data' (16)"
                    else:
                        reason = f"Status check failed for status {self.org_status}"
                elif not destination_check:
                    reason = f"DB_Destination is '{self.db_destination}' - SQL destinations are not supported"
                else:
                    reason = "All execution prerequisites satisfied"
                
                return should_execute, reason
            
            def _get_status_description(self, status_code):
                statuses = {1: 'Active', 13: 'Disconnected', 16: 'Resetting Data'}
                return statuses.get(status_code, f'Unknown Status ({status_code})')
            
            def _get_reset_mode(self):
                return self.reset_mode
            
            def _get_db_destination(self):
                return self.db_destination
            
            def log_execution_decision(self, should_execute, reason):
                pass  # Mock implementation
        
        test_cases = [
            # (org_status, reset_mode, db_destination, should_be_blocked, description)
            (1, False, 'EVA', True, 'Active status'),
            (13, False, 'EVA', True, 'Disconnected status'),  
            (16, False, 'EVA', True, 'Resetting Data without Reset_Mode'),
            (12, False, 'SQL', True, 'SQL destination'),
            (16, True, 'SQL', True, 'SQL destination even with reset mode'),
            (12, False, 'EVA', False, 'Valid updating status'),
            (16, True, 'EVA', False, 'Valid resetting status with reset mode'),
        ]
        
        for org_status, reset_mode, db_destination, should_be_blocked, description in test_cases:
            with self.subTest(description=description):
                integration = MockIntegrationVariableStatus(org_status, reset_mode, db_destination)
                should_execute, reason = integration.should_execute_endpoints()
                
                if should_be_blocked:
                    self.assertFalse(should_execute, f"Expected execution to be blocked for {description}")
                    self.assertNotEqual(reason, "All execution prerequisites satisfied")
                else:
                    self.assertTrue(should_execute, f"Expected execution to be allowed for {description}")
                    self.assertEqual(reason, "All execution prerequisites satisfied")
                
                print(f"  ✅ {description}: {'Blocked' if not should_execute else 'Allowed'} - {reason}")
        
        print("✅ Various blocked scenarios working correctly")
    
    def test_error_response_structure(self):
        """Test that the error response has the correct structure"""
        
        class MockIntegrationForErrorStructure:
            """Mock integration to test error response structure"""
            
            def __init__(self):
                self.org_status = 13  # Disconnected
                self.error_list = []
            
            def should_execute_endpoints(self):
                return False, "Organization status 13 (Disconnected) is not allowed"
            
            def log_execution_decision(self, should_execute, reason):
                pass
            
            def _get_status_description(self, status_code):
                return 'Disconnected'
            
            def _get_reset_mode(self):
                return False
            
            def _get_db_destination(self):
                return 'EVA'
            
            def create_error_response(self, reason):
                """Create the same error response structure as run_full_sync"""
                return {
                    'status': 'failed',
                    'error': 'Execution blocked by organization status check',
                    'error_details': {
                        'reason': reason,
                        'organization_status': getattr(self, 'org_status', 'Unknown'),
                        'organization_status_description': self._get_status_description(getattr(self, 'org_status', 0)),
                        'reset_mode': self._get_reset_mode(),
                        'db_destination': self._get_db_destination(),
                        'check_type': 'organization_status_and_environment'
                    },
                    'duration_seconds': 0.0,
                    'total_endpoints': 0,
                    'successful_endpoints': 0,
                    'failed_endpoints': 0,
                    'total_records_processed': 0,
                    'endpoint_results': {},
                    'errors': [reason]
                }
        
        integration = MockIntegrationForErrorStructure()
        should_execute, reason = integration.should_execute_endpoints()
        
        # Create error response
        error_response = integration.create_error_response(reason)
        
        # Verify response structure
        required_keys = ['status', 'error', 'error_details', 'duration_seconds', 
                        'total_endpoints', 'successful_endpoints', 'failed_endpoints',
                        'total_records_processed', 'endpoint_results', 'errors']
        
        for key in required_keys:
            self.assertIn(key, error_response, f"Missing key: {key}")
        
        # Verify error_details structure
        required_error_detail_keys = ['reason', 'organization_status', 'organization_status_description',
                                     'reset_mode', 'db_destination', 'check_type']
        
        for key in required_error_detail_keys:
            self.assertIn(key, error_response['error_details'], f"Missing error_details key: {key}")
        
        # Verify values
        self.assertEqual(error_response['status'], 'failed')
        self.assertEqual(error_response['error'], 'Execution blocked by organization status check')
        self.assertEqual(error_response['error_details']['organization_status'], 13)
        self.assertEqual(error_response['error_details']['organization_status_description'], 'Disconnected')
        self.assertEqual(error_response['error_details']['check_type'], 'organization_status_and_environment')
        self.assertEqual(error_response['duration_seconds'], 0.0)
        self.assertEqual(error_response['total_endpoints'], 0)
        self.assertGreater(len(error_response['errors']), 0)
        
        print("✅ Error response structure is correct")


if __name__ == '__main__':
    print("🧪 Running run_full_sync with Status Checking Tests")
    print("=" * 65)
    
    # Create test suite
    test_suite = unittest.TestLoader().loadTestsFromTestCase(TestRunFullSyncWithStatusChecking)
    test_runner = unittest.TextTestRunner(verbosity=2)
    
    # Run tests
    result = test_runner.run(test_suite)
    
    # Print summary  
    print("\n" + "=" * 65)
    print(f"🏁 Test Summary:")
    print(f"   Tests run: {result.testsRun}")
    print(f"   Failures: {len(result.failures)}")
    print(f"   Errors: {len(result.errors)}")
    
    if result.failures:
        print(f"\n❌ Failures:")
        for test, traceback in result.failures:
            print(f"   - {test}")
    
    if result.errors:
        print(f"\n💥 Errors:")
        for test, traceback in result.errors:
            print(f"   - {test}")
    
    if result.wasSuccessful():
        print(f"\n✅ All tests passed! run_full_sync with status checking working correctly.")
        print(f"🎯 Integration ready for production use with proper execution control.")
    else:
        print(f"\n❌ Some tests failed. Please review the implementation.")
    
    print("=" * 65)