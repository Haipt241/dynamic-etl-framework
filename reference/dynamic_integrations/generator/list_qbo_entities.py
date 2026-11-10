#!/usr/bin/env python3
"""
List QuickBooks Online API Entities

This script demonstrates how to list all available QBO entities and their URLs.
"""

from integration_entities import EntityWizard

def main():
    """Main function to demonstrate entity listing"""
    wizard = EntityWizard()
    
    print("QuickBooks Online API Entities")
    print("=" * 50)
    
    # Get all entities
    entities = wizard.get_available_entities("qbo")
    print(f"Total entities available: {len(entities)}")
    
    # List by categories
    categories = wizard.list_entity_categories("qbo")
    print(f"Categories: {', '.join(categories)}")
    
    # Show detailed summary
    wizard.print_entities_summary("qbo")
    
    print("\n" + "=" * 50)
    print("Example: Generate SQL for Core entities")
    print("=" * 50)
    
    # Generate SQL for just Core entities as example
    core_entities = wizard.get_entities_by_category("Core", "qbo")
    print(f"\nProcessing {len(core_entities)} Core entities...")
    
    for entity in core_entities[:2]:  # Process first 2 as example
        print(f"\n--- Processing {entity.name} ---")
        try:
            result = wizard.process_api_url(entity.url)
            print(f"✓ Successfully generated SQL for {entity.name}")
            print(f"  Description: {entity.description}")
            print(f"  Table name: {result['entity_name'].lower()}")
        except Exception as e:
            print(f"✗ Error processing {entity.name}: {e}")
    
    print("\n" + "=" * 50)
    print("Usage Examples:")
    print("  python integration_entities.py --list-entities")
    print("  python integration_entities.py --list-category Core")
    print("  python integration_entities.py --generate-category Core")
    print("  python integration_entities.py 'https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/account'")

if __name__ == "__main__":
    main()