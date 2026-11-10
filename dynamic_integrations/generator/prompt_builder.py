class PromptBuilder:
    """Build prompts for the optional test generator."""

    @staticmethod
    def build_test_prompt(schema: dict) -> str:
        """
        Build prompt for generating test files
        
        Args:
            schema: Schema data containing integration information
            
        Returns:
            str: Prompt for LLM to generate test code
        """
        integration_name = schema.get("integration_name", "unknown")
        endpoints = schema.get("endpoints", [])
        
        endpoint_names = [ep.get("name", "unknown") for ep in endpoints]
        endpoints_list = "\n".join([f"- {name}" for name in endpoint_names])
        
        return f"""
            Generate comprehensive unit tests for the {integration_name} integration.
            
            ## Integration Details:
            - Integration Name: {integration_name}
            - Endpoints: {endpoints_list}
            
            ## Test Requirements:
            1. Test all major methods of the integration class
            2. Mock external API calls
            3. Test error handling
            4. Test data transformation
            5. Use pytest framework
            6. Include setup and teardown methods
            
            ## Output Requirements:
            - Complete Python test file
            - Use pytest and unittest.mock
            - Include proper imports
            - Test both success and failure scenarios
            - **NO** markdown code blocks
            - **NO** explanations
            
            Generate the test file:
            """.strip()