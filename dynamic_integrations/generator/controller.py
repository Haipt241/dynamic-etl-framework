"""
Enhanced Generator Controller

Enhanced version that supports both legacy schema-based generation and unified API-based generation
"""

import json
import os
import sys
from pathlib import Path

from dynamic_integrations.generator.handlers import GeneratorHandlers

# Add parent directory to path
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parent_dir)



class GeneratorController:
    """
    Enhanced controller that supports legacy schema-based generation
    """
    
    def __init__(self, args=None):
        """Initialize controller with args from generator.py"""
        self.args = args
        self.handlers = None
        self.schema_path = None
        self.generate_sql = False
        self.generate_test = False
        self.force = False
    
    def load_schema(self):
        """Load schema from JSON file"""
        with open(self.schema_path, 'r') as f:
            data = json.load(f)
        return data if isinstance(data, list) else [data]
    
    def run(self):
        """Run legacy schema-based generation using passed args"""
        
        # Validate args were passed
        if not self.args:
            raise ValueError("Args must be provided to GeneratorController")
        
        # Set up paths and flags using generator.py args
        self.schema_path = Path(self.args.input)  # Use 'input' from generator.py
        self.generate_sql = self.args.sql
        self.generate_test = self.args.test
        self.force = self.args.force
        
        # Initialize handlers
        self.handlers = GeneratorHandlers(force=self.force)
        
        print("🔧 Running Generator Controller in Legacy Mode")
        print(f"📄 Schema file: {self.schema_path}")
        
        try:
            # Validate schema file exists
            if not self.schema_path.exists():
                raise FileNotFoundError(f"Schema file not found: {self.schema_path}")
            
            # Load schemas
            schemas = self.load_schema()
            
            # Generate SQL files
            if self.generate_sql:
                sql_flags = {
                    'stage': getattr(self.args, 'stage', False),
                    'prod': getattr(self.args, 'prod', False),
                    'view': getattr(self.args, 'view', False),
                    'procedure': getattr(self.args, 'procedure', False)
                }
                selected_sql_types = [k for k, v in sql_flags.items() if v]
                if not selected_sql_types:
                    selected_sql_types = ['stage', 'prod', 'view', 'procedure']

                for sql_type in selected_sql_types:
                    print(f"\n🚀 Generating SQL ({sql_type})...")
                    self.handlers.handle_sql(schemas, sql_type)

            # Generate test files
            if self.generate_test:
                print("\n🚀 Generating unit tests...")
                self.handlers.handle_test(schemas)
            
            print(f"\n✅ Legacy generation completed!")
            
        except Exception as e:
            print(f"❌ Legacy generation failed: {str(e)}")
            raise


def main():
    """Main function for command-line usage"""
    
    print("❌ GeneratorController should not be run directly.")
    print("Use generator.py instead:")
    print("  python generator.py schema.json --legacy --sql --integration")
    sys.exit(1)


if __name__ == "__main__":
    main()