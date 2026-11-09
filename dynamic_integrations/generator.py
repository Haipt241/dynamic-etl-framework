"""
⚠️  DEPRECATION NOTICE ⚠️
=======================
This script (generator.py) contains legacy modes that are now handled by the unified workflow.

🔄 MIGRATION GUIDE:
- OLD: python generator.py schema.json --sql
- NEW: python run_dynamic_integration.py --integration INTEGRATION_NAME --mode insert --param key=value

- OLD: python generator.py https://api.docs --dynamic-integration-file
- NEW: Use schema_extractor.py first, then run_dynamic_integration.py

For the complete unified workflow, use:
    python run_dynamic_integration.py --help

Legacy modes will be maintained for compatibility but new development should use run_dynamic_integration.py
=======================
"""

import argparse
import sys
import os
import json
from pathlib import Path
from typing import Dict, List, Optional, Union
from urllib.parse import urlparse

from archives.legacy_etl.integration_entities_qbo import EntityWizard
from archives.legacy_etl.integration_entities_xero import XeroEntityWizard
from archives.legacy_etl.integrations_entities_dynamic import DynamicEntityWizard, MySQLTableGenerator, \
    SQLAlchemyModelGenerator

# Add parent directory to path
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, parent_dir)

from schema_extractor import SchemaExtractor
from generator.controller import GeneratorController
from generator.utils import Utils


class UnifiedETLGenerator:
    """
    Unified ETL Generator tối ưu hóa để tận dụng existing infrastructure
    """
    
    def __init__(self, output_base_dir: str = "./generated_integrations"):
        """Initialize unified generator"""
        self.output_base_dir = Path(output_base_dir)
        self.utils = Utils()
        
        # Initialize existing components
        self.qbo_wizard = EntityWizard()
        self.xero_wizard = XeroEntityWizard()
        self.dynamic_wizard = DynamicEntityWizard()
        self.schema_extractor = SchemaExtractor()
        
        # Initialize generators từ existing entity files
        self.mysql_generator = MySQLTableGenerator()
        self.sqlalchemy_generator = SQLAlchemyModelGenerator()
        
        print("🚀 Unified ETL Generator initialized")
    
    def generate_from_api_docs(self, 
                              api_documentation_url: str,
                              integration_name: Optional[str] = None,
                              entity_limit: Union[int, str] = "all",
                              auto_discover: bool = True) -> Dict:
        """
        Generate complete integration từ API documentation
        
        Args:
            api_documentation_url: URL to API documentation
            integration_name: Custom integration name
            entity_limit: Number of entities to process
            auto_discover: Whether to auto-discover entities from API docs
            
        Returns:
            Dict containing generation results
        """
        
        print(f"🔥 Generating integration from API documentation...")
        print(f"📄 API URL: {api_documentation_url}")
        print(f"🔍 Auto-discover: {auto_discover}")
        
        # Step 1: Discover entities from API documentation
        if auto_discover:
            entities_data = self._discover_entities_from_api(api_documentation_url, entity_limit)
        else:
            entities_data = self._use_predefined_entities(api_documentation_url, entity_limit)
        
        if integration_name:
            entities_data['integration_name'] = integration_name.upper()
        
        integration_name = entities_data['integration_name']
        
        # Step 2: Generate all files
        generated_files = self._generate_integration_files(entities_data, integration_name)
        
        # Step 3: Create package info
        package_info = {
            'integration_name': integration_name,
            'api_documentation_url': api_documentation_url,
            'entity_count': len(entities_data.get('entities', [])),
            'generated_files': generated_files,
            'output_directory': str(self.output_base_dir / integration_name.lower()),
            'auto_discovered': auto_discover
        }
        
        print(f"🎉 Integration generated successfully!")
        print(f"📦 Integration: {integration_name}")
        print(f"📁 Location: {package_info['output_directory']}")
        print(f"📊 Entities: {package_info['entity_count']}")
        
        return package_info
    
    def _discover_entities_from_api(self, api_url: str, entity_limit: Union[int, str]) -> Dict:
        """Discover entities from API documentation using multiple approaches"""
        
        print(f"🔍 Auto-discovering entities from API documentation...")
        
        # Approach 1: Use AI schema extractor
        try:
            ai_schemas = self.schema_extractor.extract_schemas(api_url, entity_limit, use_dynamic_parser=False)
            print(f"🧠 AI discovered {len(ai_schemas.get('endpoints', []))} entities")
            ai_entities = ai_schemas.get('endpoints', [])
        except Exception as e:
            print(f"⚠️ AI extraction failed: {str(e)}")
            ai_entities = []
        
        # Approach 2: Use dynamic parser for HTML-based discovery
        try:
            dynamic_result = self.dynamic_wizard.discover_api(api_url)
            print(f"🕷️ Dynamic parser discovered {len(dynamic_result.get('entities', []))} entities")
            dynamic_entities = dynamic_result.get('entities', [])
        except Exception as e:
            print(f"⚠️ Dynamic parser failed: {str(e)}")
            dynamic_entities = []
        
        # Combine and process discovered entities
        all_entities = []
        
        # Process AI entities first (higher quality)
        for ai_entity in ai_entities:
            processed_entity = self._process_ai_entity(ai_entity)
            if processed_entity:
                all_entities.append(processed_entity)
        
        # Add dynamic entities if not already covered
        for dynamic_entity in dynamic_entities:
            if not any(entity['name'] == dynamic_entity.get('name') for entity in all_entities):
                processed_entity = self._process_dynamic_entity(dynamic_entity)
                if processed_entity:
                    all_entities.append(processed_entity)
        
        # Apply entity limit
        if entity_limit != "all":
            all_entities = all_entities[:int(entity_limit)]
        
        # Determine integration name
        integration_name = ai_schemas.get('integration_name', 'UNKNOWN') if ai_entities else 'DISCOVERED'
        
        return {
            'integration_name': integration_name,
            'entities': all_entities,
            'discovery_method': 'auto_discovery',
            'ai_entities': len(ai_entities),
            'dynamic_entities': len(dynamic_entities)
        }
    
    def _use_predefined_entities(self, api_url: str, entity_limit: Union[int, str]) -> Dict:
        """Use predefined entities based on API type detection"""
        
        api_type = self._detect_api_type(api_url)
        print(f"🎯 Detected API type: {api_type}")
        
        if api_type == 'qbo':
            entities = self.qbo_wizard.get_available_entities('qbo')
            integration_name = 'QBO'
        elif api_type == 'xero':
            entities = self.xero_wizard.get_available_entities('xero')
            integration_name = 'XERO'
        else:
            # Fallback to auto-discovery
            return self._discover_entities_from_api(api_url, entity_limit)
        
        # Apply entity limit
        if entity_limit != "all":
            entities = entities[:int(entity_limit)]
        
        # Process predefined entities
        processed_entities = []
        for entity in entities:
            try:
                if api_type == 'qbo':
                    result = self.qbo_wizard.process_api_url(entity.url)
                elif api_type == 'xero':
                    result = self.xero_wizard.process_api_url(entity.url)
                
                processed_entities.append({
                    'name': entity.name,
                    'description': entity.description,
                    'category': entity.category,
                    'mysql_table': result['mysql_table'],
                    'sqlalchemy_model': result['sqlalchemy_model']
                })
                print(f"✅ Processed {entity.name}")
            except Exception as e:
                print(f"❌ Failed to process {entity.name}: {str(e)}")
                continue
        
        return {
            'integration_name': integration_name,
            'entities': processed_entities,
            'discovery_method': 'predefined_entities',
            'total_available': len(entities)
        }
    
    def _detect_api_type(self, api_url: str) -> str:
        """Detect API type from URL"""
        domain = urlparse(api_url).netloc.lower()
        
        if 'intuit.com' in domain or 'quickbooks' in domain:
            return 'qbo'
        elif 'xero.com' in domain:
            return 'xero'
        else:
            return 'unknown'
    
    def _process_ai_entity(self, ai_entity: Dict) -> Optional[Dict]:
        """Process AI-discovered entity"""
        
        try:
            # Generate MySQL table using existing generator
            mysql_table = self.mysql_generator.generate_create_table_sql(
                table_name=f"c{{clientID}}_{{orgID}}_{{integration}}_{ai_entity['name'].lower()}stage",
                fields=ai_entity.get('fields', [])
            )
            
            # Generate SQLAlchemy model using existing generator
            sqlalchemy_model = self.sqlalchemy_generator.generate_sqlalchemy_model(
                class_name=ai_entity['name'],
                table_name=f"c{{clientID}}_{{integration}}_{ai_entity['name'].lower()}",
                fields=ai_entity.get('fields', [])
            )
            
            return {
                'name': ai_entity['name'],
                'description': ai_entity.get('description', ''),
                'category': ai_entity.get('entity_type', 'unknown'),
                'mysql_table': mysql_table,
                'sqlalchemy_model': sqlalchemy_model,
                'source': 'ai_discovery'
            }
        except Exception as e:
            print(f"❌ Error processing AI entity {ai_entity.get('name')}: {str(e)}")
            return None
    
    def _process_dynamic_entity(self, dynamic_entity: Dict) -> Optional[Dict]:
        """Process dynamic-discovered entity"""
        
        try:
            # Simplified processing for dynamic entities
            return {
                'name': dynamic_entity.get('name', 'Unknown'),
                'description': dynamic_entity.get('description', ''),
                'category': dynamic_entity.get('category', 'unknown'),
                'mysql_table': f"-- Table for {dynamic_entity.get('name', 'Unknown')} (dynamic discovery)",
                'sqlalchemy_model': f"# Model for {dynamic_entity.get('name', 'Unknown')} (dynamic discovery)",
                'source': 'dynamic_discovery'
            }
        except Exception as e:
            print(f"❌ Error processing dynamic entity {dynamic_entity.get('name')}: {str(e)}")
            return None
    
    def _generate_integration_files(self, entities_data: Dict, integration_name: str) -> Dict:
        """Generate all integration files"""
        
        integration_dir = self.output_base_dir / integration_name.lower()
        integration_dir.mkdir(parents=True, exist_ok=True)
        
        generated_files = {}
        
        # Generate SQL files
        generated_files['sql'] = self._generate_sql_files(entities_data, integration_name, integration_dir)
        
        # Generate schema files
        generated_files['schemas'] = self._generate_schema_files(entities_data, integration_name, integration_dir)
        
        # Generate integration class
        generated_files['integration'] = self._generate_integration_class(entities_data, integration_name, integration_dir)
        
        # Generate README
        generated_files['readme'] = self._generate_readme(entities_data, integration_name, integration_dir)
        
        return generated_files
    
    def _generate_sql_files(self, entities_data: Dict, integration_name: str, integration_dir: Path) -> List[str]:
        """Generate SQL files following QBO format"""
        
        sql_files = []
        sql_dir = integration_dir / "sql"
        sql_dir.mkdir(exist_ok=True)
        
        # Generate create_stage_table.sql
        stage_file = sql_dir / "create_stage_table.sql"
        stage_content = self._generate_stage_tables_sql(entities_data, integration_name)
        with open(stage_file, 'w') as f:
            f.write(stage_content)
        sql_files.append(str(stage_file))
        
        # Generate create_prod_table.sql
        prod_file = sql_dir / "create_prod_table.sql"
        prod_content = self._generate_prod_tables_sql(entities_data, integration_name)
        with open(prod_file, 'w') as f:
            f.write(prod_content)
        sql_files.append(str(prod_file))
        
        return sql_files
    
    def _generate_stage_tables_sql(self, entities_data: Dict, integration_name: str) -> str:
        """Generate staging tables SQL"""
        
        content = [
            f"-- Auto-generated Staging Tables for {integration_name}",
            f"-- Generated by Unified ETL Generator",
            f"-- Discovery method: {entities_data.get('discovery_method', 'unknown')}",
            ""
        ]
        
        for entity in entities_data.get('entities', []):
            entity_name = entity['name'].lower()
            content.append(f"-- {entity['name']} (Stage)")
            content.append(f"DROP TABLE IF EXISTS c{{clientID}}_{{orgID}}_{integration_name.lower()}_{entity_name}stage;")
            content.append("")
            content.append(f"CREATE TABLE c{{clientID}}_{{orgID}}_{integration_name.lower()}_{entity_name}stage (")
            content.append("    id VARCHAR(255),")
            content.append("    name VARCHAR(255),")
            content.append("    ClientID VARCHAR(255),")
            content.append("    OrganisationID VARCHAR(255),")
            content.append("    PRIMARY KEY (id),")
            content.append("    INDEX idx_org (OrganisationID)")
            content.append(");")
            content.append("")
        
        return "\n".join(content)
    
    def _generate_prod_tables_sql(self, entities_data: Dict, integration_name: str) -> str:
        """Generate production tables SQL"""
        
        content = [
            f"-- Auto-generated Production Tables for {integration_name}",
            f"-- Generated by Unified ETL Generator",
            ""
        ]
        
        for entity in entities_data.get('entities', []):
            entity_name = entity['name'].lower()
            content.append(f"-- {entity['name']} (Production)")
            content.append(f"DROP TABLE IF EXISTS c{{clientID}}_{integration_name.lower()}_{entity_name};")
            content.append("")
            content.append(f"CREATE TABLE c{{clientID}}_{integration_name.lower()}_{entity_name} (")
            content.append("    id VARCHAR(255) NOT NULL,")
            content.append("    name VARCHAR(255),")
            content.append("    ClientID VARCHAR(255),")
            content.append("    OrganisationID INT,")
            content.append("    PRIMARY KEY (id),")
            content.append("    INDEX idx_org (OrganisationID)")
            content.append(");")
            content.append("")
        
        return "\n".join(content)
    
    def _generate_schema_files(self, entities_data: Dict, integration_name: str, integration_dir: Path) -> List[str]:
        """Generate JSON schema files"""
        
        schema_files = []
        schemas_dir = integration_dir / "schemas"
        schemas_dir.mkdir(exist_ok=True)
        
        # Generate master schema file
        master_schema = {
            "integration_name": integration_name,
            "discovery_method": entities_data.get('discovery_method', 'unknown'),
            "entity_count": len(entities_data.get('entities', [])),
            "entities": [
                {
                    "name": entity['name'],
                    "description": entity.get('description', ''),
                    "category": entity.get('category', 'unknown'),
                    "source": entity.get('source', 'unknown')
                }
                for entity in entities_data.get('entities', [])
            ]
        }
        
        master_file = schemas_dir / f"{integration_name.lower()}_schema.json"
        with open(master_file, 'w') as f:
            json.dump(master_schema, f, indent=2)
        schema_files.append(str(master_file))
        
        return schema_files
    
    def _generate_integration_class(self, entities_data: Dict, integration_name: str, integration_dir: Path) -> str:
        """Generate integration class"""
        
        class_content = f'''"""
{integration_name} Integration

Auto-generated integration class for {integration_name}.
Generated by Unified ETL Generator.
"""

from typing import Dict, List

class {integration_name}Integration:
    """
    {integration_name} Integration Class
    
    Generated with {len(entities_data.get('entities', []))} entities
    """
    
    def __init__(self, config: Dict):
        self.config = config
        self.integration_name = "{integration_name}"
        print(f"🔧 Initialized {integration_name} integration")
    
    def get_endpoints_list(self) -> List[str]:
        """Get list of available endpoints"""
        return [
{self._generate_endpoints_list(entities_data.get('entities', []))}
        ]
    
    def run_full_sync(self) -> Dict:
        """Run full synchronization"""
        return {{
            'integration_name': self.integration_name,
            'endpoints': self.get_endpoints_list(),
            'status': 'success',
            'message': 'Sync completed successfully'
        }}
'''
        
        integration_file = integration_dir / f"{integration_name.lower()}_integration.py"
        with open(integration_file, 'w') as f:
            f.write(class_content)
        
        return str(integration_file)
    
    def _generate_endpoints_list(self, entities: List[Dict]) -> str:
        """Generate endpoints list code"""
        lines = []
        for entity in entities:
            lines.append(f'            "{entity["name"].lower()}",')
        return '\n'.join(lines)
    
    def _generate_readme(self, entities_data: Dict, integration_name: str, integration_dir: Path) -> str:
        """Generate README"""
        
        entities_list = "\n".join([
            f"- **{entity['name']}** ({entity.get('category', 'unknown')}): {entity.get('description', 'No description')}" 
            for entity in entities_data.get('entities', [])
        ])
        
        readme_content = f'''# {integration_name} Integration
            Auto-generated ETL integration for {integration_name}.
            
            ## Overview
            
            - **Generated by**: Unified ETL Generator
            - **Discovery method**: {entities_data.get('discovery_method', 'unknown')}
            - **Entity count**: {len(entities_data.get('entities', []))}
            
            ## Entities
            
            {entities_list}
            
            ## Usage
            
            ```python
            from {integration_name.lower()}_integration import {integration_name}Integration
            
            # Initialize
            config = {{
                'client_id': 'your_client_id',
                'client_secret': 'your_client_secret',
                'organisation_id': 1
            }}
            
            integration = {integration_name}Integration(config)
            
            # Run sync
            result = integration.run_full_sync()
            ```
            
            ## File Structure
            
            ```
            {integration_name.lower()}/
            ├── sql/
            │   ├── create_stage_table.sql    # Staging table definitions
            │   └── create_prod_table.sql     # Production table definitions
            ├── schemas/
            │   └── {integration_name.lower()}_schema.json  # Master schema
            ├── {integration_name.lower()}_integration.py  # Main integration class
            └── README.md                     # This file
            ```
            
            Generated by Unified ETL Generator System
        '''
        
        readme_file = integration_dir / "README.md"
        with open(readme_file, 'w') as f:
            f.write(readme_content)
        
        return str(readme_file)


def main():
    """Main entry point"""
    
    parser = argparse.ArgumentParser(
        description="ETL Generator - Generate integrations from API documentation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
            Examples:
              # 1. API Documentation Mode (default) - Auto-discover entities from API docs
              python generator.py https://developer.intuit.com/app/developer/qbo/docs --auto-discover
            
              # 2. API Documentation Mode with custom settings  
              python generator.py https://api.example.com/docs --integration-name MyAPI --entities 10
            
              # 3. API Documentation Mode with predefined entities (for QBO/Xero)
              python generator.py https://developer.xero.com/documentation --no-auto-discover
            
              # 4. Schema Extraction Mode - Extract schemas only (no file generation)
              python generator.py https://api.example.com/docs --extract-only
              
              
              # 5. Dynamic Integration File Mode - Generate Python file that inherits from DynamicIntegration
              python generator.py schema.json --dynamic-integration-file --force
              
              # 6. Dynamic Integration File Mode - Generate from API URL
              python generator.py https://api.example.com/docs --dynamic-integration-file --integration-name MyAPI
            
              # 7. Schema-Based Mode - Generate from schema JSON using existing templates
              python generator.py schema.json --sql
                    """
    )
    
    # Input source
    parser.add_argument("input", help="API documentation URL or schema JSON file")
    
    # Generation modes
    parser.add_argument("--auto-discover", action="store_true", default=True, help="Auto-discover entities from API docs (default)")
    
    parser.add_argument("--no-auto-discover", action="store_true", help="Use predefined entities (QBO/Xero only)")
    
    parser.add_argument("--extract-only", action="store_true", help="Extract schemas only (no file generation)")
    
    parser.add_argument("--dynamic-integration-file", action="store_true", help="Generate dynamic integration Python file that inherits from DynamicIntegration")
    
    # Generation options
    parser.add_argument("--integration-name", help="Custom integration name")
    
    parser.add_argument("--entities", default="all", help="Number of entities to process ('all' or integer)")
    
    parser.add_argument("--output", help="Output directory")
    
    # Legacy options
    parser.add_argument("--sql", action="store_true", help="Generate SQL files")
    
    parser.add_argument("--test", action="store_true", help="Generate test files")
    
    # SQL-specific options
    parser.add_argument("--stage", action="store_true", help="Generate stage tables")
    
    parser.add_argument("--prod", action="store_true", help="Generate production tables")
    
    parser.add_argument("--view", action="store_true", help="Generate view tables")
    
    parser.add_argument("--procedure", action="store_true", help="Generate stored procedures")
    
    parser.add_argument("--force", action="store_true", help="Force overwrite existing files")
    
    args = parser.parse_args()
    
    # Handle help
    if len(sys.argv) == 1:
        parser.print_help()
        return
    
    try:
        # Determine mode and run
        if args.extract_only:
            # Schema extraction only
            run_schema_extraction(args)
        elif args.dynamic_integration_file:
            # Dynamic integration file generation mode
            run_dynamic_integration_file_mode(args)
        elif Path(args.input).suffix == '.json':
            # Schema-based generation mode
            run_schema_based_mode(args)
        else:
            # Unified API documentation mode
            run_unified_mode(args)
            
    except KeyboardInterrupt:
        print("\n⚠️ Generation interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


def run_schema_extraction(args):
    """Run schema extraction only"""
    
    print("🔍 Running schema extraction...")
    
    extractor = SchemaExtractor()
    schemas = extractor.extract_schemas(
        documentation_url=args.input,
        entity_limit=args.entities
    )
    
    print(f"✅ Schema extraction completed!")
    print(f"📦 Integration: {schemas.get('integration_name', 'Unknown')}")
    print(f"📊 Entities: {len(schemas.get('endpoints', []))}")


def run_unified_mode(args):
    """Run unified API documentation generation mode"""
    
    print("🚀 Running API documentation generation mode...")
    
    # Create generator
    output_dir = args.output or "./generated_integrations"
    generator = UnifiedETLGenerator(output_base_dir=output_dir)
    
    # Determine auto-discover setting
    auto_discover = args.auto_discover and not args.no_auto_discover
    
    # Generate integration
    result = generator.generate_from_api_docs(
        api_documentation_url=args.input,
        integration_name=args.integration_name,
        entity_limit=args.entities,
        auto_discover=auto_discover
    )
    
    print(f"🎉 SUCCESS: Integration generated!")
    print(f"📦 Integration: {result['integration_name']}")
    print(f"📁 Location: {result['output_directory']}")
    print(f"📊 Entities: {result['entity_count']}")
    print(f"🔍 Auto-discovered: {result['auto_discovered']}")


def run_dynamic_integration_file_mode(args):
    """Run dynamic integration file generation mode"""
    
    print("🔄 Running dynamic integration file generation mode...")
    
    from dynamic_integrations.generator.handlers import GeneratorHandlers
    
    # If input is a schema file, load it
    if Path(args.input).suffix == '.json':
        print(f"📄 Loading schema from: {args.input}")
        with open(args.input, 'r') as f:
            schema_data = json.load(f)
        
        # Ensure it's a list
        if not isinstance(schema_data, list):
            schema_data = [schema_data]
        
        # Override integration name if provided
        if args.integration_name:
            schema_data[0]['integration_name'] = args.integration_name
        
        # Use handlers for dynamic integration file generation
        handlers = GeneratorHandlers(force=args.force)
        handlers.handle_dynamic_integration_file(schema_data)
    
    else:
        # If input is URL, first extract schema then process
        print(f"🌐 Extracting schema from URL: {args.input}")
        
        extractor = SchemaExtractor()
        schemas = extractor.extract_schemas(
            documentation_url=args.input,
            entity_limit=args.entities
        )
        
        # Convert to list format expected by handlers
        integration_name = args.integration_name or schemas.get('integration_name', 'Unknown')
        schema_list = [{
            'integration_name': integration_name,
            'endpoints': schemas.get('endpoints', []),
            'api_config': schemas.get('api_config', {})
        }]
        
        # Use handlers for dynamic integration file generation
        handlers = GeneratorHandlers(force=args.force)
        handlers.handle_dynamic_integration_file(schema_list)
    
    print("✅ Dynamic integration file generation completed!")


def run_schema_based_mode(args):
    """Run schema-based generation mode (using existing templates)"""
    
    print("🔧 Running schema-based generation mode...")
    
    # Create controller for schema-based mode with args
    controller = GeneratorController(args)
    controller.run()
    
    print("✅ Schema-based generation completed!")


if __name__ == "__main__":
    main()