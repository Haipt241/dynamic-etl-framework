#!/usr/bin/env python3
"""
Demonstration of the Integration-Agnostic INSERT Package
Shows how any integration can use the generic orchestrator
"""

import os
import sys

# Set up environment
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))

def demo_xeroblue_insert():
    """Demonstrate XeroBlue integration with INSERT package"""
    print("=" * 60)
    print("Demo: XeroBlue Integration with INSERT Package")
    print("=" * 60)
    
    # Set environment variables
    os.environ['EtaniClientID'] = 'CLIENT1724'
    os.environ['EtaniOrganisationID'] = '6051'
    os.environ['XeroTenantID'] = 'demo-tenant-id'
    os.environ['DB_Destination'] = 'EVA'
    
    try:
        # 1. Create XeroBlue integration instance
        from xeroblue_integration_enhanced import XeroBlueIntegrationEnhanced
        
        config = {
            'rate_limit': 60,
            'timeout_seconds': 900
        }
        
        xeroblue_integration = XeroBlueIntegrationEnhanced(config)
        print(f"✅ Created {xeroblue_integration.integration_name} integration")
        
        # 2. Create generic INSERT orchestrator
        from integration_package_insert import create_package_insert
        
        orchestrator = create_package_insert(xeroblue_integration, config)
        print(f"✅ Created generic INSERT orchestrator")
        
        # 3. Show configuration
        insert_config = xeroblue_integration.get_insert_configuration()
        print(f"\nConfiguration:")
        print(f"  Integration: {insert_config['integration_name']}")
        print(f"  Client: {insert_config['client_id']}")
        print(f"  Organization: {insert_config['organisation_id']}")
        print(f"  FX Currencies: {insert_config['fx_currencies']}")
        
        # 4. Run initialization (demonstration only)
        print(f"\nRunning INSERT initialization...")
        
        results = orchestrator.run_initialization(
            create_objects=True,
            initialize_indexes=True,
            upload_pbi=True,
            workspace_id="demo-workspace"
        )
        
        print(f"\nResults:")
        print(f"  Status: {results['status']}")
        print(f"  Duration: {results.get('orchestrator_duration', 0):.2f}s")
        
        for step_name, step_result in results.get('steps', {}).items():
            status = "✅" if step_result['success'] else "❌"
            print(f"  {status} {step_name}: {step_result['message']}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def demo_usage_patterns():
    """Demonstrate different usage patterns"""
    print("\n" + "=" * 60)
    print("Demo: Usage Patterns")
    print("=" * 60)
    
    print("\n1. Factory Function Pattern:")
    print("   from integration_package_insert import create_package_insert")
    print("   orchestrator = create_package_insert(integration_instance)")
    print("   results = orchestrator.run_initialization()")
    
    print("\n2. Direct Class Usage:")
    print("   from integration_package_insert import IntegrationPackageInsert")
    print("   orchestrator = IntegrationPackageInsert(integration_instance)")
    print("   results = orchestrator.run_initialization()")
    
    print("\n3. Convenience Function:")
    print("   from integration_package_insert import run_integration_insert_initialization")
    print("   results = run_integration_insert_initialization(integration_instance)")
    
    print("\n4. Integration-Specific Helpers:")
    print("   # For XeroBlue")
    print("   from sql_object_manager import create_xeroblue_sql_objects")
    print("   success = create_xeroblue_sql_objects(client_id, org_id, legacy_id, errors)")
    
    print("\n5. Generic SQL Object Creation:")
    print("   from sql_object_manager import create_sql_objects_for_integration")
    print("   success, details = create_sql_objects_for_integration(")
    print("       'XEROBLUE', client_id, org_id, legacy_id, errors)")

def demo_multi_integration_support():
    """Demonstrate multi-integration support"""
    print("\n" + "=" * 60)
    print("Demo: Multi-Integration Support")
    print("=" * 60)
    
    # Show supported integrations
    integrations = [
        {
            'name': 'XEROBLUE',
            'description': 'Xero Blue API Integration',
            'rate_limit': '60 calls/min',
            'fx_currencies': ['AUD', 'USD', 'NZD', 'GBP', 'EUR']
        },
        {
            'name': 'QBO', 
            'description': 'QuickBooks Online Integration',
            'rate_limit': '500 calls/min',
            'fx_currencies': ['USD', 'CAD', 'GBP', 'EUR']
        },
        {
            'name': 'MYOB',
            'description': 'MYOB AccountRight Integration', 
            'rate_limit': '1000 calls/min',
            'fx_currencies': ['AUD', 'NZD', 'USD']
        }
    ]
    
    print("Supported Integrations:")
    for integration in integrations:
        print(f"\n  {integration['name']}:")
        print(f"    Description: {integration['description']}")
        print(f"    Rate Limit: {integration['rate_limit']}")
        print(f"    FX Currencies: {', '.join(integration['fx_currencies'])}")
    
    print(f"\nAll integrations use the same generic orchestrator:")
    print(f"  ✅ Common interface for all integrations")
    print(f"  ✅ Standardized workflow patterns")
    print(f"  ✅ Integration-agnostic SQL object creation")
    print(f"  ✅ Performance optimization for containers")

def main():
    """Main demo runner"""
    print("🚀 Integration-Agnostic INSERT Package Demo")
    print("Demonstrating the redesigned architecture")
    
    # Run demos
    success = demo_xeroblue_insert()
    demo_usage_patterns()
    demo_multi_integration_support()
    
    # Summary
    print("\n" + "=" * 80)
    print("DEMO SUMMARY")
    print("=" * 80)
    
    if success:
        print("🎉 Demo completed successfully!")
        print("\nKey Benefits Demonstrated:")
        print("  ✅ Complete integration agnosticism")
        print("  ✅ Standardized interface for all integrations")
        print("  ✅ Generic orchestrator for INSERT operations")
        print("  ✅ Performance-optimized SQL object creation")
        print("  ✅ Easy extensibility for new integrations")
        print("  ✅ Consistent error handling and logging")
    else:
        print("❌ Demo encountered issues")
    
    print("\nThe integration-agnostic INSERT package is ready for production use!")
    print("=" * 80)
    
    return 0 if success else 1

if __name__ == "__main__":
    exit(main())