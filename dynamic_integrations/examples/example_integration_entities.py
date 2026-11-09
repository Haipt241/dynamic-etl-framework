#!/usr/bin/env python3
"""
Example usage of the Integration Entities Generator

This script demonstrates how to use the EntityWizard to generate
MySQL tables and SQLAlchemy models from API documentation URLs.
"""

from integration_entities import EntityWizard, EntitySchema, FieldSchema

def example_qbo_urls():
    """Example QuickBooks Online API entity URLs"""
    return [
        "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/account",
        "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/customer",
        "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/invoice",
        "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/item",
        "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/vendor",
    ]

def create_sample_entity_manually():
    """Create a sample entity schema manually for testing"""
    fields = [
        FieldSchema(name="Id", field_type="string", required=True, description="Unique identifier"),
        FieldSchema(name="Name", field_type="string", required=True, description="Account name"),
        FieldSchema(name="AccountType", field_type="string", description="Type of account"),
        FieldSchema(name="Balance", field_type="decimal", description="Current balance"),
        FieldSchema(name="Active", field_type="boolean", description="Whether account is active"),
        FieldSchema(name="CreateTime", field_type="datetime", description="Creation timestamp"),
        FieldSchema(name="MetaData", field_type="object", description="Metadata information"),
        FieldSchema(name="Tags", field_type="array", description="Array of tags"),
    ]
    
    return EntitySchema(
        name="Account",
        fields=fields,
        description="Chart of accounts entity for QuickBooks Online",
        table_name="qbo_accounts"
    )

def demo_manual_entity_generation():
    """Demonstrate manual entity generation"""
    print("=== Manual Entity Generation Demo ===")
    print()
    
    # Create wizard with table prefix
    wizard = EntityWizard(table_prefix="qbo_")
    
    # Create sample entity
    schema = create_sample_entity_manually()
    
    # Generate MySQL table
    mysql_table = wizard.mysql_generator.generate_create_table(schema)
    
    # Generate SQLAlchemy model
    sqlalchemy_model = wizard.model_generator.generate_model_class(schema)
    
    print(f"Entity: {schema.name}")
    print(f"Description: {schema.description}")
    print()
    
    print("=== Generated MySQL Table ===")
    print(mysql_table)
    print()
    
    print("=== Generated SQLAlchemy Model ===")
    print(sqlalchemy_model)
    print()

def demo_url_processing():
    """Demonstrate URL processing (may have limited success due to parsing complexity)"""
    print("=== URL Processing Demo ===")
    print()
    
    wizard = EntityWizard(table_prefix="qbo_")
    
    # Try to process a QBO URL
    test_url = "https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/account"
    
    try:
        result = wizard.process_api_url(test_url)
        print(f"Successfully processed: {test_url}")
        print(f"Entity: {result['entity_name']}")
        print()
        print("MySQL Table:")
        print(result['mysql_table'])
        print()
        print("SQLAlchemy Model:")
        print(result['sqlalchemy_model'])
        
    except Exception as e:
        print(f"Error processing URL: {e}")
        print("This is expected as the parser needs enhancement for complex documentation.")

def demo_batch_processing():
    """Demonstrate batch processing of multiple URLs"""
    print("=== Batch Processing Demo ===")
    print()
    
    wizard = EntityWizard(table_prefix="qbo_")
    urls = example_qbo_urls()[:3]  # Process first 3 URLs
    
    print(f"Processing {len(urls)} URLs...")
    
    results = wizard.batch_process_urls(urls)
    
    for i, result in enumerate(results):
        print(f"\n--- Result {i+1} ---")
        if 'error' in result:
            print(f"Error: {result['error']}")
        else:
            print(f"Entity: {result.get('entity_name', 'Unknown')}")
            print("Table created successfully" if 'mysql_table' in result else "No table generated")

def main():
    """Main demonstration function"""
    print("Integration Entities Generator - Example Usage")
    print("=" * 50)
    print()
    
    # Run manual entity generation demo
    demo_manual_entity_generation()
    
    print("\n" + "=" * 50)
    
    # Run URL processing demo
    demo_url_processing()
    
    print("\n" + "=" * 50)
    
    # Run batch processing demo
    demo_batch_processing()
    
    print("\n" + "=" * 50)
    print("Demo completed!")

if __name__ == "__main__":
    main()