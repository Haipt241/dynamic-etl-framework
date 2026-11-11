import re
from pathlib import Path

from dynamic_integrations.generator.prompt_builder import PromptBuilder
from dynamic_integrations.generator.utils import Utils


class GeneratorHandlers:
    def __init__(self, force: bool = False):
        self.force = force

    @staticmethod
    def handle_sql(schemas, sql_type: str = None):
        """
        Handle SQL generation using unified approach (template-first + LLM verification)
        
        Args:
            schemas: Schema data
            sql_type: Type of SQL to generate (stage, prod, view, procedure)
        """
        integration = schemas[0].get("integration_name", "").lower()
        if not integration:
            raise ValueError("integration_name is required in schema but was not found")
        
        print(f"🔥 Generating {sql_type} SQL for {integration} using UNIFIED approach")
        print(f"🚀 Template-first + LLM verification for optimal results & efficiency")
        
        try:
            # Use new unified SQL generator
            from dynamic_integrations.generator.unified_sql_generator import UnifiedSQLGenerator
            
            # Set up paths
            base_dir = Path(__file__).parent.parent
            schema_dir = base_dir / "generated_integrations" / integration / "schemas"
            output_dir = base_dir / "generated_integrations" / integration / "sql"
            
            # Create unified generator
            generator = UnifiedSQLGenerator(
                integration_name=integration,
                use_llm_verification=True  # Enable LLM verification by default
            )
            
            # Generate SQL file
            result_file = generator.generate_sql_type(schema_dir, output_dir, sql_type)
            
            print(f"✅ Unified SQL generation completed: {result_file}")
            return result_file
            
        except Exception as e:
            print(f"❌ Unified SQL generation failed: {e}")
            return None
    
    def handle_dynamic_integration_file(self, schemas):
        """Generate a compatibility adapter for the explicit CLI generation option."""
        if not schemas or not schemas[0].get("integration_name"):
            raise ValueError("integration_name is required to generate an adapter")

        integration = schemas[0]["integration_name"].lower()
        if not re.fullmatch(r"[a-z][a-z0-9_]*", integration):
            raise ValueError(f"Invalid integration name: {integration}")

        path = Path("generated_integrations") / integration / f"{integration}_integration.py"
        if path.exists() and not self.force:
            print(f"Integration file already exists: {path}")
            return

        template = Path(__file__).with_name("integration_template.py").read_text(encoding="utf-8")
        content = template.replace("__INTEGRATION_NAME_LOWER__", integration)
        content = content.replace("__INTEGRATION_NAME__", integration.upper())
        compile(content, str(path), "exec")
        Utils.write_file_if_not_exists(path, content, self.force)
        print(f"Integration adapter generated: {path}")

    def handle_test(self, schemas):
        for schema in schemas:
            integration = schema.get("integration_name", "").lower()
            if not integration:
                raise ValueError("integration_name is required in schema but was not found")
            test_path = Path(f"tests/integration/test_{integration}_integration.py")
            if self.force or not test_path.exists():
                prompt = PromptBuilder.build_test_prompt(schema)
                response = Utils.run_claude_prompt(prompt)
                clean_python_code = Utils.extract_python_code(response)
                Utils.write_file_if_not_exists(test_path, clean_python_code, self.force)