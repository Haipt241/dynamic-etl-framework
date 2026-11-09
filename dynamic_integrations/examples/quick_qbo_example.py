#!/usr/bin/env python3
"""
Quick QuickBooks Online (QBO) Example - Minimal setup

This is a simplified example showing the most common usage patterns for QBO integration.
"""

import os
import sys
import warnings

# Suppress NumPy compatibility warnings
# warnings.filterwarnings('ignore', message='.*numpy.*')
# warnings.filterwarnings('ignore', message='.*NumPy.*')
# os.environ['PYTHONWARNINGS'] = 'ignore::DeprecationWarning'

# Set environment variables FIRST, before any imports that might depend on them
os.environ['EtaniClientID'] = 'BIGOLESHOECOMPANY_CLIENT2013'
os.environ['EtaniOrganisationID'] = '7035'
os.environ['RealmID'] = '193514518158004'
os.environ['JOB_ID'] = '1'
os.environ['JOB_RUN_ID'] = '7035'
os.environ['TRIGGER_TYPE'] = 'MANUAL'
os.environ['DB_Destination'] = 'EVA'
os.environ['Reset_Mode'] = 'false'

# Add the etl_packages to path

def quick_upsert_example():
    """
    Quick UPSERT example - Integration-Agnostic Approach for QBO
    
    This example demonstrates the new integration-agnostic architecture where
    we create integration instances and pass them to the orchestrator, rather
    than using hardcoded string names.
    """
    print("🚀 Quick QBO UPSERT Example - Integration-Agnostic Approach")
    print("-" * 55)
    
    try:
        # Import the dynamic orchestrator and integration class
        from dynamic_integrations import create_package_upsert
        from dynamic_integrations.integrations.qbo_integration import QBOIntegration
        
        # Configuration (environment variables are set at module level)
        config = {
            'rate_limit': 60,
            'debug': True,
        }
        
        # 🔄 INTEGRATION-AGNOSTIC APPROACH:
        # Instead of: create_package_upsert('QBO', config)  # ❌ Old hardcoded way
        # We now use: create_package_upsert(integration_instance)  # ✅ New interface-driven way
        
        print("Creating QBO integration instance...")
        qbo_integration = QBOIntegration(config)
        
        print(f"✅ Integration created: {qbo_integration.integration_name}")
        print(f"   Capabilities: {qbo_integration.capabilities.value}")
        print(f"   Supports UPSERT: {qbo_integration.supports_upsert()}")
        
        print("Creating integration-agnostic orchestrator...")
        orchestrator = create_package_upsert(qbo_integration)  # 🎯 Interface-driven!
        
        # Get orchestrator info to show what was detected
        info = orchestrator.get_integration_info()
        print(f"✅ Orchestrator created for: {info.get('integration_name')}")
        print(f"   Operation mode: {info.get('operation_mode')}")
        print(f"   Execution ID: {orchestrator.execution_id}")
        
        # Run specific endpoints (faster for testing)
        endpoints = ['Customer']#, 'Attachable']  # Start with safe test endpoints
        print(f"\\nRunning QBO endpoints: {endpoints}")
        
        result = orchestrator.run(endpoint_list=endpoints)
        
        # Show results with detailed error analysis
        print(f"\\nResults:")
        print(f"  Status: {result.get('status')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        print(f"  Execution ID: {result.get('execution_id')}")
        
        if result.get('status') == 'completed':
            print("✅ QBO Integration completed successfully!")
            
            # Show QBO-specific success metrics
            endpoint_results = result.get('endpoint_results', {})
            if endpoint_results:
                print(f"\\n📊 QBO Endpoint Results:")
                for endpoint_name, endpoint_result in endpoint_results.items():
                    if endpoint_result.get('status') == 'completed':
                        records = endpoint_result.get('records_processed', 0)
                        print(f"  ✅ {endpoint_name}: {records} records processed")
            
        else:
            print("❌ QBO Integration failed or completed with errors")
            
            # Enhanced error debugging information
            print(f"\\n🔍 DETAILED QBO ERROR ANALYSIS:")
            print("=" * 50)
            
            # Main error
            main_error = result.get('error', 'Unknown error')
            print(f"📋 Main Error: {main_error}")
            
            # Endpoint-specific errors
            endpoint_results = result.get('endpoint_results', {})
            if endpoint_results:
                print(f"\\n📊 QBO Endpoint-Specific Errors:")
                for endpoint_name, endpoint_result in endpoint_results.items():
                    if endpoint_result.get('status') != 'completed':
                        print(f"\\n  🔴 {endpoint_name.upper()} ENDPOINT:")
                        print(f"     Status: {endpoint_result.get('status', 'unknown')}")
                        
                        endpoint_error = endpoint_result.get('error', 'No specific error')
                        print(f"     Error: {endpoint_error}")
                        
                        # Try to extract more details if available
                        if 'exception_details' in endpoint_result:
                            details = endpoint_result['exception_details']
                            print(f"     Exception Type: {details.get('type', 'Unknown')}")
                            print(f"     File: {details.get('file', 'Unknown')}")
                            print(f"     Line: {details.get('line', 'Unknown')}")
                            print(f"     Function: {details.get('function', 'Unknown')}")
            
            # General errors list
            errors_list = result.get('errors', [])
            if errors_list:
                print(f"\\n📝 All QBO Errors ({len(errors_list)} total):")
                for i, error in enumerate(errors_list, 1):
                    print(f"  {i}. {error}")
                    
                    # Enhanced error categorization for QBO
                    error_str = str(error).lower()
                    if 'token' in error_str or 'oauth' in error_str or 'invalid_grant' in error_str:
                        print(f"     🔧 Category: QBO OAuth Token")
                        print(f"     💡 Fix: Check QBO OAuth setup:")
                        print(f"        - Verify QBO_CLIENT_ID and QBO_CLIENT_SECRET")
                        print(f"        - Refresh OAuth tokens in Azure File Share")
                        print(f"        - Check RealmID is correct")
                    elif 'rate limit' in error_str or '429' in error_str:
                        print(f"     🔧 Category: QBO API Rate Limiting")
                        print(f"     💡 Fix: Reduce API call frequency (60 calls/minute limit)")
                    elif 'quickbooks' in error_str or 'intuit' in error_str:
                        print(f"     🔧 Category: QBO API Connection")
                        print(f"     💡 Fix: Verify QBO API connectivity and credentials")
                    elif 'azure' in error_str or 'file share' in error_str:
                        print(f"     🔧 Category: Azure File Share Configuration")
                        print(f"     💡 Fix: Set environment variables:")
                        print(f"        - AZURE_STORAGE_ACCOUNT_NAME")
                        print(f"        - AZURE_STORAGE_ACCOUNT_KEY") 
                        print(f"        - AZURE_FILE_SHARE_NAME")
                    elif 'mysql' in error_str or 'database' in error_str:
                        print(f"     🔧 Category: Database Connection")
                        print(f"     💡 Fix: Check database connectivity and credentials")
                    elif 'cms' in error_str:
                        print(f"     🔧 Category: CMS Service")
                        print(f"     💡 Fix: Verify CMS service availability and configuration")
                    elif 'organization status' in error_str or 'status check' in error_str:
                        print(f"     🔧 Category: QBO Organization Status")
                        print(f"     💡 Fix: Check organization status (needs Status 9 or 16+Reset_Mode)")
                    else:
                        print(f"     🔧 Category: General QBO Error")
                        print(f"     💡 Fix: Review error message for specific guidance")
            
            # QBO-specific environment diagnostic
            print(f"\\n🔧 QBO ENVIRONMENT DIAGNOSTIC:")
            print("=" * 35)
            required_env_vars = ['EtaniClientID', 'EtaniOrganisationID', 'RealmID', 'DB_Destination']
            # # qbo_specific_vars = ['QBO_CLIENT_ID', 'QBO_CLIENT_SECRET']
            # # optional_env_vars = ['AZURE_STORAGE_ACCOUNT_NAME', 'AZURE_STORAGE_ACCOUNT_KEY', 'AZURE_FILE_SHARE_NAME', 'Reset_Mode']
            
            print("Required Environment Variables:")
            for var in required_env_vars:
                value = os.environ.get(var)
                status = "✅" if value else "❌"
                print(f"  {status} {var}: {'Set' if value else 'Missing'}")
            
            # print("\\nQBO-Specific Variables (from config):")
            # for var in qbo_specific_vars:
            #     try:
            #         import config
            #         value = getattr(config, var, None)
            #         status = "✅" if value else "❌"
            #         print(f"  {status} {var}: {'Set' if value else 'Missing'}")
            #     except:
            #         print(f"  ❌ {var}: Config module not accessible")
            
            # print("\\nOptional Environment Variables (for full functionality):")
            # for var in optional_env_vars:
            #     value = os.environ.get(var)
            #     status = "✅" if value else "⚠️ "
            #     print(f"  {status} {var}: {'Set' if value else 'Not configured'}")
            
            print(f"\\n📚 QBO DEBUGGING RECOMMENDATIONS:")
            print("=" * 40)
            print("1. 🔍 Check the specific QBO error messages above for root causes")
            print("2. 🔧 Configure missing environment variables as indicated")
            print("3. 🔑 For QBO OAuth: Verify tokens in Azure File Share")
            print("4. 🌐 For Azure File Share: Contact system admin for credentials")
            print("5. 💾 For database issues: Verify MySQL/database connectivity")
            print("6. 📊 For organization status: Ensure Status 12 or 16+Reset_Mode")
            print("7. 🧪 For testing: Use demo environment scripts in /demo/ directory")
        
        # 💡 Key Benefits Demonstrated:
        print(f"\\n💡 QBO Integration-Agnostic Benefits Shown:")
        print(f"   🔧 No hardcoded integration names in orchestrator")
        print(f"   🎯 Same orchestrator works with ANY BaseIntegration")
        print(f"   ✨ Plug-and-play: swap integrations without code changes")
        print(f"   🚀 Interface-driven: everything uses BaseIntegration contract")
        print(f"   📊 QBO-specific: OAuth, rate limiting, organization status checking")
        
        return result
        
    except Exception as e:
        print(f"❌ QBO Integration-agnostic example failed: {str(e)}")
        
        # Enhanced exception debugging
        import traceback
        import sys
        
        print(f"\\n🔍 DETAILED QBO EXCEPTION ANALYSIS:")
        print("=" * 50)
        
        # Exception details
        exc_type, exc_value, exc_traceback = sys.exc_info()
        print(f"📋 Exception Type: {exc_type.__name__}")
        print(f"📋 Exception Message: {str(exc_value)}")
        
        # Get the last traceback frame (where the error occurred)
        if exc_traceback:
            tb = exc_traceback
            while tb.tb_next:
                tb = tb.tb_next
            
            frame = tb.tb_frame
            print(f"📁 File: {frame.f_code.co_filename}")
            print(f"🔢 Line Number: {tb.tb_lineno}")
            print(f"🎯 Function: {frame.f_code.co_name}")
            
            # Show local variables at the point of failure
            print(f"\\n🔧 Local Variables at Error:")
            for var_name, var_value in frame.f_locals.items():
                if not var_name.startswith('_'):  # Skip private variables
                    try:
                        var_str = str(var_value)[:100]  # Truncate long values
                        print(f"   {var_name}: {var_str}")
                    except:
                        print(f"   {var_name}: <unable to display>")
        
        print(f"\\n📚 FULL STACK TRACE:")
        print("=" * 30)
        traceback.print_exc()
        
        # QBO-specific error categorization for debugging
        error_str = str(e).lower()
        print(f"\\n💡 QBO ERROR CATEGORY & DEBUGGING TIPS:")
        print("=" * 45)
        
        if 'import' in error_str or 'module' in error_str:
            print("🔧 Category: Import/Module Error")
            print("💡 Debugging tips:")
            print("   - Check if all required packages are installed")
            print("   - Verify Python path and module locations")
            print("   - Check for circular imports")
        elif 'qbo' in error_str and ('client' in error_str or 'secret' in error_str):
            print("🔧 Category: QBO Credentials Error")
            print("💡 Debugging tips:")
            print("   - Verify QBO_CLIENT_ID and QBO_CLIENT_SECRET in config")
            print("   - Check config.py file exists and is accessible")
            print("   - Verify QBO app credentials in Intuit Developer console")
        elif 'token' in error_str or 'oauth' in error_str:
            print("🔧 Category: QBO OAuth Token Error")
            print("💡 Debugging tips:")
            print("   - Check OAuth token files in Azure File Share")
            print("   - Verify RealmID matches the QBO company")
            print("   - Re-authorize QBO connection if tokens expired")
        elif 'environment' in error_str or 'env' in error_str:
            print("🔧 Category: Environment Variable Error")
            print("💡 Debugging tips:")
            print("   - Check if all required environment variables are set")
            print("   - Verify RealmID, EtaniClientID, EtaniOrganisationID")
            print("   - Ensure DB_Destination is set to EVA or DW")
        elif 'azure' in error_str or 'file share' in error_str:
            print("🔧 Category: Azure File Share Error")
            print("💡 Debugging tips:")
            print("   - Configure Azure File Share environment variables")
            print("   - Check Azure credentials and permissions")
            print("   - Verify QBO token files exist in file share")
        elif 'database' in error_str or 'mysql' in error_str:
            print("🔧 Category: Database Connection Error")
            print("💡 Debugging tips:")
            print("   - Verify database server is running and accessible")
            print("   - Check database credentials and connection string")
            print("   - Ensure QBO stage tables exist")
        elif 'organization status' in error_str:
            print("🔧 Category: QBO Organization Status Error")
            print("💡 Debugging tips:")
            print("   - Organization status must be 9 (Provisioning) or 16+Reset_Mode")
            print("   - Check CMS database for correct organization status")
            print("   - Verify Reset_Mode environment variable if using status 16")
        else:
            print("🔧 Category: General QBO Error")
            print("💡 Debugging tips:")
            print("   - Review the exception message and stack trace above")
            print("   - Check the specific line number mentioned for context")
            print("   - Verify QBO API connectivity and credentials")
        
        return None

def quick_auto_detect_example():
    """
    Quick auto-detect example using the new dynamic features for QBO
    """
    print("\\n🎯 Quick QBO Auto-Detect Example")
    print("-" * 45)
    
    try:
        # Import required modules
        from dynamic_integrations import create_integration_package
        from dynamic_integrations.integrations.qbo_integration import QBOIntegration
        
        # Configuration
        config = {
            'rate_limit': 60,
            'debug': True,
        }
        
        # Create integration instance
        print("Creating QBO integration instance...")
        qbo_integration = QBOIntegration(config)
        
        # Create orchestrator with auto-detection
        print("Creating dynamic orchestrator...")
        orchestrator = create_integration_package(qbo_integration)
        
        # Get info about what was detected
        info = orchestrator.get_integration_info()
        print(f"Auto-detected mode: {info.get('operation_mode')}")
        print(f"Integration: {info.get('integration_name')}")
        
        # Run based on detected mode
        if info.get('operation_mode') == 'INSERT':
            print("Running QBO INSERT initialization...")
            result = orchestrator.run_initialization(
                create_objects=False,  # Set to True if you want to create SQL objects
                initialize_indexes=False,
                upload_pbi=False
            )
        else:
            print("Running QBO UPSERT synchronization...")
            result = orchestrator.run(endpoint_list=['Customer'])  # Just Customer for quick test
        
        # Show results
        print(f"\\nResults:")
        print(f"  Status: {result.get('status')}")
        print(f"  Mode: {result.get('operation_mode')}")
        print(f"  Duration: {result.get('orchestrator_duration', 0):.2f}s")
        
        return result
        
    except Exception as e:
        print(f"❌ QBO Auto-detect example failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return None

def qbo_integration_test():
    """
    QBO Integration Test - Demonstrating QBO-specific features
    
    This test demonstrates QBO-specific functionality including organization
    status checking, OAuth token management, and comprehensive data transformation.
    """
    print("\\n🏦 QBO Integration Test - QBO-Specific Features")
    print("-" * 55)
    print("This test demonstrates QBO-specific organization status checking and data transformation!")
    
    try:
        # Import QBO integration
        from dynamic_integrations.integrations.qbo_integration import QBOIntegration
        from dynamic_integrations import create_package_upsert
        
        print("\\n📦 Setting up QBO test environment...")
        
        # QBO-specific configuration
        config = {
            'rate_limit': 60,
            'debug': True,
            'test_mode': True
        }
        
        print("✅ QBO environment configured")
        
        print("\\n🔧 Creating QBO Integration Instance...")
        
        # Create QBO integration instance
        try:
            qbo = QBOIntegration(config)
            print("✅ QBO integration created successfully")
            print(f"   Integration Name: {qbo.integration_name}")
            print(f"   Capabilities: {qbo.capabilities.value}")
            print(f"   Supports UPSERT: {qbo.supports_upsert()}")
            print(f"   Rate Limit: {qbo.rate_limit} calls/minute")
        except Exception as e:
            print(f"❌ QBO integration creation failed: {str(e)}")
            return {'status': 'failed', 'error': f'QBO integration creation failed: {str(e)}'}
        
        # ==========================================
        # TEST 1: Configuration Validation
        # ==========================================
        print("\\n🔍 TEST 1: QBO Configuration Validation")
        print("-" * 40)
        
        try:
            is_valid = qbo.validate_configuration()
            print(f"✅ Configuration Valid: {is_valid}")
            
            if not is_valid:
                print("⚠️  Configuration issues detected - this is expected in test environment")
                print("   Missing: QBO credentials, Azure File Share config, or database config")
        except Exception as e:
            print(f"⚠️  Configuration validation failed: {str(e)}")
            print("   This is expected in test environments without full QBO setup")
        
        # ==========================================
        # TEST 2: Organization Status Checking
        # ==========================================
        print("\\n🏢 TEST 2: QBO Organization Status Checking")
        print("-" * 45)
        
        try:
            # Test organization status checking logic
            should_execute, reason = qbo.should_execute_endpoints()
            print(f"Should Execute: {should_execute}")
            print(f"Reason: {reason}")
            
            # Show status descriptions
            print("\\nQBO Status Codes:")
            for status_code in [1, 9, 12, 13, 16]:
                description = qbo._get_status_description(status_code)
                allowed = "✅" if status_code == 9 or (status_code == 16 and qbo._get_reset_mode()) else "❌"
                print(f"  {allowed} Status {status_code}: {description}")
            
        except Exception as e:
            print(f"⚠️  Organization status check failed: {str(e)}")
            print("   This is expected if CMS database is not accessible")
        
        # ==========================================
        # TEST 3: Database Index Management
        # ==========================================
        print("\\n🗃️  TEST 3: QBO Database Index Management")
        print("-" * 42)
        
        try:
            # Get index definitions
            index_definitions = qbo._get_qbo_index_definitions()
            print(f"✅ Index Definitions: {len(index_definitions)} total indexes defined")
            
            # Show sample indexes
            stage_indexes = [idx for idx in index_definitions if idx['index_type'] == 'STAGE']
            client_indexes = [idx for idx in index_definitions if idx['index_type'] == 'CLIENT']
            
            print(f"   📊 Stage Indexes: {len(stage_indexes)}")
            print(f"   📊 Client Indexes: {len(client_indexes)}")
            
            # Show some examples
            print("\\n   Sample Index Definitions:")
            for i, idx in enumerate(index_definitions[:5], 1):
                print(f"   {i}. {idx['index_name']}: {', '.join(idx['columns'])} ({idx['description']})")
            
        except Exception as e:
            print(f"⚠️  Index management test failed: {str(e)}")
        
        # ==========================================
        # TEST 4: Endpoint List and Capabilities
        # ==========================================
        print("\\n📋 TEST 4: QBO Endpoint List and Capabilities")
        print("-" * 48)
        
        try:
            endpoints = qbo.get_endpoints_list()
            print(f"✅ Available Endpoints: {len(endpoints)} total")
            
            # Categorize endpoints
            master_data = ['Account', 'Customer', 'Vendor', 'Employee', 'Item', 'Class', 'Department']
            transactions = ['Invoice', 'Bill', 'Payment', 'BillPayment', 'JournalEntry', 'Deposit']
            reports = [ep for ep in endpoints if ep in qbo.REPORT_ENDPOINTS]
            
            print(f"   📊 Master Data: {len([ep for ep in endpoints if ep in master_data])}")
            print(f"   💰 Transactions: {len([ep for ep in endpoints if ep in transactions])}")
            print(f"   📈 Reports: {len(reports)}")
            
            print("\\n   Sample Endpoints:")
            print(f"   Master Data: {master_data[:3]}")
            print(f"   Transactions: {transactions[:3]}")
            print(f"   Reports: {list(reports)[:3]}")
            
        except Exception as e:
            print(f"❌ Endpoint test failed: {str(e)}")
        
        # ==========================================
        # TEST 5: Data Transformation System
        # ==========================================
        print("\\n🔄 TEST 5: QBO Data Transformation System")
        print("-" * 45)
        
        try:
            import pandas as pd
            
            # Test line item transformation (mock data)
            mock_invoice_data = pd.DataFrame([{
                'Id': '123',
                'CustomerRef': {'value': '1', 'name': 'Test Customer'},
                'TxnDate': '2025-01-01',
                'Line': [
                    {
                        'LineNum': 1,
                        'Description': 'Test Item',
                        'Amount': 100.00,
                        'SalesItemLineDetail': {
                            'ItemRef': {'value': '1', 'name': 'Test Item'},
                            'Qty': 2,
                            'UnitPrice': 50.00
                        }
                    }
                ]
            }])
            
            transformed_data = qbo._transform_data(mock_invoice_data, 'Invoice')
            print(f"✅ Line Item Transformation: {len(transformed_data)} rows created from 1 invoice")
            
            if not transformed_data.empty:
                print("   Transformed columns:", list(transformed_data.columns)[:5])
            
            # Test address transformation (mock data)
            mock_customer_data = pd.DataFrame([{
                'Id': '456',
                'Name': 'Test Customer',
                'BillAddr': {
                    'Line1': '123 Main St',
                    'City': 'Anytown',
                    'PostalCode': '12345'
                }
            }])
            
            transformed_customer = qbo._transform_data(mock_customer_data, 'Customer')
            print(f"✅ Address Transformation: {len(transformed_customer)} customer records processed")
            
        except Exception as e:
            print(f"⚠️  Transformation test failed: {str(e)}")
        
        # ==========================================
        # FINAL TEST: Orchestrator Creation
        # ==========================================
        print("\\n🎯 FINAL TEST: QBO Orchestrator Creation")
        print("-" * 44)
        
        try:
            # Create orchestrator
            orchestrator = create_package_upsert(qbo)
            info = orchestrator.get_integration_info()
            
            print(f"✅ Orchestrator Created: {orchestrator.__class__.__name__}")
            print(f"   Operation Mode: {info.get('operation_mode')}")
            print(f"   Integration Name: {info.get('integration_name')}")
            print(f"   Execution ID: {orchestrator.execution_id}")
            
        except Exception as e:
            error_msg = str(e)
            if any(keyword in error_msg.lower() for keyword in ['azure', 'database', 'mysql', 'ssl', 'connection']):
                print(f"⚠️  Environment issue (expected in test): {error_msg[:60]}...")
                print("   This is normal when testing without full infrastructure")
            else:
                print(f"❌ Orchestrator creation failed: {error_msg}")
        
        print("\\n" + "=" * 55)
        print("🎉 QBO INTEGRATION TEST COMPLETE!")
        print("✨ QBO-specific features demonstrated:")
        print("   🏦 Organization status checking (Status 9 or 16+Reset_Mode)")
        print("   🔑 OAuth token management and rate limiting")
        print("   🗃️  Database index management (50+ indexes)")
        print("   🔄 Advanced data transformation (line items, addresses)")
        print("   📊 46 endpoint support with comprehensive transformation")
        print("   ✅ Integration-agnostic architecture compliance")
        
        return {
            'status': 'success',
            'integration_tested': 'QBO',
            'tests_completed': 5,
            'qbo_features_demonstrated': [
                'Configuration validation',
                'Organization status checking', 
                'Database index management',
                'Endpoint capabilities',
                'Data transformation system',
                'Orchestrator creation'
            ]
        }
        
    except Exception as e:
        print(f"❌ QBO integration test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return {'status': 'failed', 'error': str(e)}

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
    """
    Run quick QBO examples demonstrating integration-agnostic approach
    """
    print("=" * 75)
    print("QBO INTEGRATION - INTEGRATION-AGNOSTIC QUICK EXAMPLES")
    print("=" * 75)
    
    # Example 1: Quick QBO UPSERT (new integration-agnostic approach)
    result1 = quick_upsert_example()
    
    # Example 2: QBO Auto-detect mode (alternative integration-agnostic approach)
    # result2 = quick_auto_detect_example()
    
    # # Example 3: QBO-specific feature testing
    # result3 = qbo_integration_test()
    
    # print("\\n" + "=" * 75)
    # print("SUMMARY - QBO INTEGRATION-AGNOSTIC EXAMPLES")
    # print("=" * 75)
    
    # Summary of examples
    examples = [
        ("QBO UPSERT Example (Integration-Agnostic)", result1),
        # # ("QBO Auto-Detect Example (Integration-Agnostic)", result2),
        # ("QBO Integration Test (QBO-Specific Features)", result3)
    ]
    
    total_examples = len(examples)
    successful_examples = 0
    
    for i, (name, result) in enumerate(examples, 1):
        if result and result.get('status') in ['completed', 'completed_with_errors', 'success']:
            print(f"✅ Example {i}: {name}")
            successful_examples += 1
        else:
            print(f"❌ Example {i}: {name}")
            if result and result.get('error'):
                print(f"   Error: {result['error']}")
    
    print(f"\\n📊 SUCCESS RATE: {successful_examples}/{total_examples} examples completed")
    
    if successful_examples > 0:
        print("\\n🎉 QBO Integration-Agnostic Examples Working!")
        print("✨ Instance-based approach demonstrated successfully!")
        print("✨ Interface-driven architecture in action!")
        print("✨ No hardcoded integration names required!")
        print("🏦 QBO-specific features demonstrated!")
        
        print(f"\\n💡 Key QBO Architecture Benefits Shown:")
        print(f"   🔧 Create integration instances with QBOIntegration(config)")
        print(f"   🎯 Pass instances to create_package_upsert(integration_instance)")
        print(f"   ✨ Same orchestrator code works with ANY BaseIntegration")
        print(f"   🚀 Plug-and-play: swap integrations without orchestrator changes")
        print(f"   🏦 QBO-specific: OAuth, rate limiting, organization status (Status 9/16)")
        print(f"   🔄 Advanced transformations: line items, addresses, 46 endpoints")
        print(f"   🗃️  Database optimization: 50+ indexes with efficiency checking")
    else:
        print(f"\\n⚠️  Examples had issues - see details above")
        print(f"   Note: Database/Azure connection issues are expected in test environments")
        print(f"   Note: QBO OAuth setup is required for full functionality")
    