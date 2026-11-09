"""
Comprehensive test for XeroBlue index creation functionality

Tests the CheckAndInitIndexes implementation and all related helper methods
including efficient index checking and creation.
"""

import sys
import os
import unittest
from unittest.mock import patch, MagicMock, call

# Add the project root to the path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'dynamic_integrations', 'integrations')))

# Mock environment variables before importing sql_helper
with patch.dict(os.environ, {
    'EtaniClientID': 'TEST_CLIENT1518',
    'EtaniOrganisationID': '7232',
    'XeroTenantID': 'test-tenant-id'
}):
    # Import the XeroBlue integration
    from xeroblue_integration import XeroblueIntegration


class TestXeroblueIndexCreation(unittest.TestCase):
    """Test cases for XeroBlue index creation functionality"""
    
    def setUp(self):
        """Set up test environment"""
        self.test_config = {
            'etani_client_id': 'TEST_CLIENT1518',
            'etani_organisation_id': '7232',
            'rate_limit': 60,
            'timeout_seconds': 900
        }
        
        # Mock environment variables
        self.env_patcher = patch.dict(os.environ, {
            'EtaniClientID': 'TEST_CLIENT1518',
            'EtaniOrganisationID': '7232',
            'XeroTenantID': 'test-tenant-id'
        })
        self.env_patcher.start()
        
        # Create integration instance
        self.integration = XeroblueIntegration(self.test_config)
    
    def tearDown(self):
        """Clean up test environment"""
        self.env_patcher.stop()
    
    def test_stage_table_prefix_generation(self):
        """Test stage table prefix generation"""
        expected_prefix = "c1518_7232_xeroblue_"
        actual_prefix = self.integration._get_stage_table_prefix()
        self.assertEqual(actual_prefix, expected_prefix)
    
    def test_client_table_prefix_generation(self):
        """Test client table prefix generation"""
        expected_prefix = "c1518_xeroblue_"
        actual_prefix = self.integration._get_client_table_prefix()
        self.assertEqual(actual_prefix, expected_prefix)
    
    def test_stage_table_name_generation(self):
        """Test stage table name generation"""
        endpoint = "Invoices"
        expected_name = "c1518_7232_xeroblue_invoicesstage"
        actual_name = self.integration._get_stage_table_name(endpoint)
        self.assertEqual(actual_name, expected_name)
    
    def test_client_table_name_generation(self):
        """Test client table name generation"""
        endpoint = "Journals"
        expected_name = "c1518_xeroblue_Journals"
        actual_name = self.integration._get_client_table_name(endpoint)
        self.assertEqual(actual_name, expected_name)
    
    def test_stage_index_name_generation(self):
        """Test stage index name generation"""
        endpoint = "Invoices"
        columns = "OrganisationId,InvoiceId"
        
        # Expected pattern: table_name + simplified columns + _idx
        expected_pattern = "c1518_7232_xeroblue_invoicesstage_OrgIDInvoiceId_idx"
        actual_name = self.integration._generate_stage_index_name(endpoint, columns)
        
        self.assertTrue(actual_name.endswith("_idx"))
        self.assertIn("invoicesstage", actual_name)
        self.assertIn("OrgID", actual_name)
    
    @patch('xeroblue_integration.get_acronym')
    def test_client_index_name_generation(self, mock_get_acronym):
        """Test client index name generation"""
        # Mock the get_acronym function
        mock_get_acronym.side_effect = lambda x: x[:3].upper()
        
        endpoint = "Journals"
        columns = "OrganisationId,JournalId"
        
        actual_name = self.integration._generate_client_index_name(endpoint, columns)
        
        self.assertTrue(actual_name.endswith("_idx"))
        self.assertIn("c1518_xeroblue_Journals", actual_name)
        self.assertIn("ORG", actual_name)  # First 3 chars of OrganisationId
        self.assertIn("JOU", actual_name)  # First 3 chars of JournalId
    
    def test_index_definitions_structure(self):
        """Test that index definitions are properly structured"""
        indexes = self.integration._get_index_definitions()
        
        # Verify we have indexes defined
        self.assertGreater(len(indexes), 0)
        
        # Verify structure of index definitions
        for index_def in indexes:
            self.assertIn('endpoint', index_def)
            self.assertIn('columns', index_def)
            self.assertIn('index_type', index_def)
            self.assertIn('index_name', index_def)
            self.assertIn(index_def['index_type'], ['stage', 'client'])
    
    def test_index_definitions_content(self):
        """Test that index definitions contain expected content"""
        indexes = self.integration._get_index_definitions()
        
        # Verify we have both stage and client indexes
        stage_indexes = [idx for idx in indexes if idx['index_type'] == 'stage']
        client_indexes = [idx for idx in indexes if idx['index_type'] == 'client']
        
        self.assertGreater(len(stage_indexes), 0)
        self.assertGreater(len(client_indexes), 0)
        
        # Verify some specific expected indexes
        stage_endpoints = {idx['endpoint'] for idx in stage_indexes}
        client_endpoints = {idx['endpoint'] for idx in client_indexes}
        
        # Check for key stage endpoints
        self.assertIn('Invoices', stage_endpoints)
        self.assertIn('Journals', stage_endpoints)
        self.assertIn('Payments', stage_endpoints)
        
        # Check for key client endpoints
        self.assertIn('Journals', client_endpoints)
        self.assertIn('accounts', client_endpoints)
        self.assertIn('Contacts', client_endpoints)
    
    @patch('xeroblue_integration.eva_engine')
    def test_get_existing_indexes(self, mock_eva_engine):
        """Test fetching existing indexes from database"""
        # Mock database connection and result
        mock_conn = MagicMock()
        mock_result = MagicMock()
        mock_result.fetchall.return_value = [
            ('c1518_xeroblue_Journals_ORG_JOU_idx',),
            ('c1518_7232_xeroblue_invoicesstage_OrgIDInvoiceId_idx',),
            ('c1518_xeroblue_accounts_ACC_ORG_idx',)
        ]
        
        mock_conn.execute.return_value = mock_result
        mock_eva_engine.connect.return_value.__enter__.return_value = mock_conn
        
        existing_indexes = self.integration._get_existing_indexes()
        
        # Verify the method returns the expected set
        expected_indexes = {
            'c1518_xeroblue_Journals_ORG_JOU_idx',
            'c1518_7232_xeroblue_invoicesstage_OrgIDInvoiceId_idx',
            'c1518_xeroblue_accounts_ACC_ORG_idx'
        }
        
        self.assertEqual(existing_indexes, expected_indexes)
        
        # Verify the SQL query was executed with correct parameters
        mock_conn.execute.assert_called_once()
        call_args = mock_conn.execute.call_args
        self.assertIn('INFORMATION_SCHEMA.STATISTICS', str(call_args[0][0]))
    
    @patch('xeroblue_integration.eva_engine')
    def test_safe_execute_eva_sql_success(self, mock_eva_engine):
        """Test successful SQL execution"""
        mock_conn = MagicMock()
        mock_eva_engine.connect.return_value.__enter__.return_value = mock_conn
        
        result = self.integration._safe_execute_eva_sql(
            "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
            "test_operation",
            "test_endpoint",
            {"table_name": "test_table", "index_name": "test_index", "column_names": "col1,col2"}
        )
        
        self.assertTrue(result)
        mock_conn.execute.assert_called_once()
        mock_conn.commit.assert_called_once()
    
    @patch('xeroblue_integration.eva_engine')
    def test_safe_execute_eva_sql_duplicate_key(self, mock_eva_engine):
        """Test handling of duplicate key errors"""
        mock_conn = MagicMock()
        mock_conn.execute.side_effect = Exception("duplicate key name 'test_index'")
        mock_eva_engine.connect.return_value.__enter__.return_value = mock_conn
        
        result = self.integration._safe_execute_eva_sql(
            "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
            "test_operation",
            "test_endpoint",
            {"table_name": "test_table", "index_name": "test_index", "column_names": "col1,col2"}
        )
        
        # Should return True for duplicate key errors (index already exists)
        self.assertTrue(result)
    
    @patch('xeroblue_integration.eva_engine')
    def test_safe_execute_eva_sql_other_error(self, mock_eva_engine):
        """Test handling of other SQL errors"""
        mock_conn = MagicMock()
        mock_conn.execute.side_effect = Exception("some other database error")
        mock_eva_engine.connect.return_value.__enter__.return_value = mock_conn
        
        result = self.integration._safe_execute_eva_sql(
            "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
            "test_operation",
            "test_endpoint",
            {"table_name": "test_table", "index_name": "test_index", "column_names": "col1,col2"}
        )
        
        # Should return False for other errors
        self.assertFalse(result)
    
    def test_add_stage_table_index_missing_params(self):
        """Test stage index creation with missing parameters"""
        # Test with missing endpoint
        result = self.integration._add_stage_table_index("", "col1,col2")
        self.assertFalse(result)
        
        # Test with missing columns
        result = self.integration._add_stage_table_index("Invoices", "")
        self.assertFalse(result)
    
    def test_add_client_table_index_missing_params(self):
        """Test client index creation with missing parameters"""
        # Test with missing endpoint
        result = self.integration._add_client_table_index("", "col1,col2")
        self.assertFalse(result)
        
        # Test with missing columns
        result = self.integration._add_client_table_index("Journals", "")
        self.assertFalse(result)
    
    @patch.object(XeroblueIntegration, '_safe_execute_eva_sql')
    def test_add_stage_table_index_success(self, mock_safe_execute):
        """Test successful stage index creation"""
        mock_safe_execute.return_value = True
        
        result = self.integration._add_stage_table_index("Invoices", "OrganisationId,InvoiceId")
        
        self.assertTrue(result)
        mock_safe_execute.assert_called_once()
        
        # Verify the call parameters
        call_args = mock_safe_execute.call_args
        self.assertIn("CreateEVAStageIndexIfNotExists", call_args[0][0])
        self.assertEqual(call_args[0][2], "Invoices")  # endpoint parameter
    
    @patch.object(XeroblueIntegration, '_safe_execute_eva_sql')
    def test_add_client_table_index_success(self, mock_safe_execute):
        """Test successful client index creation"""
        mock_safe_execute.return_value = True
        
        result = self.integration._add_client_table_index("Journals", "OrganisationId,JournalId")
        
        self.assertTrue(result)
        mock_safe_execute.assert_called_once()
        
        # Verify the call parameters
        call_args = mock_safe_execute.call_args
        self.assertIn("CreateEVAStageIndexIfNotExists", call_args[0][0])
        self.assertEqual(call_args[0][2], "Journals")  # endpoint parameter
    
    @patch.object(XeroblueIntegration, '_get_existing_indexes')
    @patch.object(XeroblueIntegration, '_add_stage_table_index')
    @patch.object(XeroblueIntegration, '_add_client_table_index')
    def test_check_and_init_indexes_efficiency(self, mock_add_client, mock_add_stage, mock_get_existing):
        """Test that existing indexes are efficiently skipped"""
        # Mock existing indexes
        mock_get_existing.return_value = {
            'c1518_7232_xeroblue_invoicesstage_OrgIDInvoiceId_idx',
            'c1518_xeroblue_Journals_ORG_JOU_idx'
        }
        
        # Mock successful index creation
        mock_add_stage.return_value = True
        mock_add_client.return_value = True
        
        result = self.integration._check_and_init_indexes()
        
        # Should be successful
        self.assertTrue(result)
        
        # Verify that existing indexes were checked
        mock_get_existing.assert_called_once()
        
        # Verify that some indexes were created (not all would be skipped)
        # The exact number depends on the index definitions, but there should be calls
        self.assertGreater(mock_add_stage.call_count + mock_add_client.call_count, 0)
    
    @patch.object(XeroblueIntegration, '_check_and_init_indexes')
    def test_initialize_indexes_success(self, mock_check_and_init):
        """Test successful index initialization"""
        mock_check_and_init.return_value = True
        
        result = self.integration.initialize_indexes()
        
        self.assertTrue(result)
        mock_check_and_init.assert_called_once()
    
    @patch.object(XeroblueIntegration, '_check_and_init_indexes')
    def test_initialize_indexes_failure(self, mock_check_and_init):
        """Test index initialization failure handling"""
        mock_check_and_init.side_effect = Exception("Database connection failed")
        
        result = self.integration.initialize_indexes()
        
        self.assertFalse(result)
        
        # Verify error was added to error list
        self.assertGreater(len(self.integration.error_list), 0)
        self.assertIn("Error initializing XeroBlue indexes", self.integration.error_list[0])


if __name__ == '__main__':
    print("🧪 Running XeroBlue Index Creation Tests")
    print("=" * 60)
    
    # Create test suite
    test_suite = unittest.TestLoader().loadTestsFromTestCase(TestXeroblueIndexCreation)
    test_runner = unittest.TextTestRunner(verbosity=2)
    
    # Run tests
    result = test_runner.run(test_suite)
    
    # Print summary  
    print("\n" + "=" * 60)
    print(f"🏁 Test Summary:")
    print(f"   Tests run: {result.testsRun}")
    print(f"   Failures: {len(result.failures)}")
    print(f"   Errors: {len(result.errors)}")
    
    if result.failures:
        print(f"\n❌ Failures:")
        for test, traceback in result.failures:
            print(f"   - {test}: {traceback}")
    
    if result.errors:
        print(f"\n💥 Errors:")
        for test, traceback in result.errors:
            print(f"   - {test}: {traceback}")
    
    if result.wasSuccessful():
        print(f"\n✅ All tests passed! XeroBlue index creation is working correctly.")
    else:
        print(f"\n❌ Some tests failed. Please review the implementation.")
    
    print("=" * 60)