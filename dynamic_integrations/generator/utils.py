import os
import re
import shutil
import subprocess
import time
import json
import sys
from pathlib import Path
from typing import List, Dict

# Import enterprise retry system
try:
    sys.path.insert(0, str(Path(__file__).parent.parent.parent))  # Add etl-packages root
    from reliability_controlling.core.exceptions import GenerationRetryableError
    from reliability_controlling import enterprise_retry, RetryStrategy
except ImportError:
    print("⚠️ Enterprise retry system not found, using fallback")
    enterprise_retry = lambda **kwargs: lambda func: func  # Fallback decorator
    
    # Fallback exception
    class GenerationRetryableError(Exception):
        pass

class Utils:

    @staticmethod
    def normalize_field_name(field_name: str) -> str:
        """
        Normalize field name for comparison by:
        1. Removing underscores
        2. Converting to lowercase
        
        Args:
            field_name: Original field name
            
        Returns:
            Normalized field name for comparison
        """
        return field_name.replace('_', '').lower()
    
    @staticmethod
    def is_field_match(target_field: str, actual_field: str) -> bool:
        """
        Check if two field names match using flexible comparison:
        1. Direct match (case insensitive)
        2. Match after removing underscores and converting to lowercase
        3. Match with plural variations (adding 's' or 'es')
        
        Examples:
            manager_user matches ManagerUser
            user matches users
            category matches categories
            
        Args:
            target_field: Field name we're looking for (e.g., 'manager_user')
            actual_field: Field name from API response (e.g., 'ManagerUser')
            
        Returns:
            True if fields match, False otherwise
        """
        # Direct case-insensitive match
        if target_field.lower() == actual_field.lower():
            return True
            
        # Normalize both fields (remove underscores, lowercase)
        target_normalized = Utils.normalize_field_name(target_field)
        actual_normalized = Utils.normalize_field_name(actual_field)
        
        # Direct normalized match
        if target_normalized == actual_normalized:
            return True
            
        # Check plural variations
        # Check if actual is plural of target
        if (actual_normalized == target_normalized + 's' or 
            actual_normalized == target_normalized + 'es'):
            return True
            
        # Check if target is plural of actual
        if (target_normalized == actual_normalized + 's' or 
            target_normalized == actual_normalized + 'es'):
            return True
            
        return False

    @staticmethod
    def _is_meaningful_value(value) -> bool:
        """
        Check if a value is meaningful (not null, empty, or NaN)
        
        Args:
            value: Value to check
            
        Returns:
            True if value has meaningful content, False otherwise
        """
        import math
        
        # Check for None
        if value is None:
            return False
            
        # Check for empty string
        if value == "":
            return False
            
        # Check for empty dict or list
        if value == {} or value == []:
            return False
            
        # Check for pandas NaN (float nan)
        if isinstance(value, float) and math.isnan(value):
            return False
            
        # Check for string representations of null/nan
        if isinstance(value, str):
            value_lower = value.lower().strip()
            if value_lower in ['nan', 'null', 'none', 'n/a', '']:
                return False
                
        return True

    @staticmethod
    def extract_json_field_samples(page_records: List[Dict], json_fields: List[str], 
                                  filled_json_fields: set, endpoint: str = "", 
                                  logger=None) -> Dict[str, any]:
        """
        Extract JSON field samples from page records using flexible field matching.
        This is shared logic used by both API processing and local file processing.
        
        Args:
            page_records: List of record dictionaries to process
            json_fields: List of JSON field names to look for
            filled_json_fields: Set to track which fields have been found (modified in place)
            endpoint: Endpoint name for logging (optional)
            logger: Logger instance (optional)
            
        Returns:
            Dict with field_name -> sample_value mapping
        """
        json_samples = {}
        
        for record in page_records:
            # Check if this record has any JSON fields we haven't found yet
            for json_field in json_fields:
                if json_field in filled_json_fields:
                    continue
                
                # Find field using flexible matching
                found_value = None
                matched_key = None
                
                for record_key, record_value in record.items():
                    if Utils.is_field_match(json_field, record_key):
                        found_value = record_value
                        matched_key = record_key
                        break
                
                if found_value is not None:
                    # Check if JSON field has meaningful value (not null, not empty, not NaN)
                    if Utils._is_meaningful_value(found_value):
                        filled_json_fields.add(json_field)
                        json_samples[json_field] = found_value
                        if logger:
                            logger.debug(f"Found JSON field '{json_field}' as '{matched_key}' in {endpoint}")
            
            # Early exit if all JSON fields are found
            if len(filled_json_fields) >= len(json_fields):
                break
        
        return json_samples

    @staticmethod
    def convert_raw_response_to_records(raw_json: Dict, endpoint: str = None) -> List[Dict]:
        """
        Convert raw API response to list of records, handling various response formats.

        Args:
            raw_json: Raw API response data
            endpoint: Optional endpoint name to check for endpoint-specific root field

        Returns:
            List of record dictionaries
        """
        page_records = []

        if isinstance(raw_json, dict):
            # First try endpoint-specific root field if available
            if endpoint:
                # Check for endpoint name in lowercase (e.g., "orders" for Orders endpoint)
                endpoint_lower = endpoint.lower()
                if endpoint_lower in raw_json and isinstance(raw_json[endpoint_lower], list):
                    page_records = raw_json[endpoint_lower]
                    return page_records

            # Fallback to common patterns
            # OData format: {"values": [...]}
            if "values" in raw_json and isinstance(raw_json["values"], list):
                page_records = raw_json["values"]
            # Generic format: {"data": [...]}
            elif "data" in raw_json and isinstance(raw_json["data"], list):
                page_records = raw_json["data"]
            # Direct object
            elif any(isinstance(v, (dict, list)) for v in raw_json.values()):
                page_records = [raw_json]
        elif isinstance(raw_json, list):
            page_records = raw_json

        return page_records

    @staticmethod
    def chunk_schema(schemas: List[Dict], chunk_size: int = 10) -> List[List[Dict]]:
        return [schemas[i:i + chunk_size] for i in range(0, len(schemas), chunk_size)]

    @staticmethod
    def extract_sql_blocks(content: str) -> str:
        """
        Extract SQL blocks from content with robust execution error handling
        
        Returns:
            str: Extracted SQL content, or empty string if execution errors prevent extraction
        """
        # Early detection of execution errors that make content unusable
        execution_error_indicators = [
            "Execution error",
            "I apologize for the error",
            "There was an error executing",
            "Error: Unable to",
            "I encountered an error",
            "Something went wrong"
        ]
        
        # Check if the entire response is essentially an execution error
        content_lines = content.strip().split('\n')
        error_line_count = 0
        total_non_empty_lines = 0
        
        for line in content_lines:
            if line.strip():
                total_non_empty_lines += 1
                if any(indicator in line for indicator in execution_error_indicators):
                    error_line_count += 1
        
        # If more than 50% of non-empty lines contain execution errors, raise retryable exception
        if total_non_empty_lines > 0 and (error_line_count / total_non_empty_lines) > 0.5:
            error_density = error_line_count / total_non_empty_lines
            error_msg = f"High execution error density detected: {error_line_count}/{total_non_empty_lines} lines contain errors (density: {error_density:.2f})"
            print(f"⚠️ {error_msg}")
            print("🔄 Triggering enterprise retry mechanism")
            raise GenerationRetryableError(error_msg)
        
        # Extract SQL blocks using regex
        matches = re.findall(r"```(?:sql)?\n(.*?)```", content, re.DOTALL)
        sql_content = "\n\n".join(m.strip() for m in matches) if matches else content.strip()
        
        # Convert placeholders back to original format
        sql_content = sql_content.replace("CLIENTID_PLACEHOLDER", "{clientID}")
        sql_content = sql_content.replace("ORGID_PLACEHOLDER", "{orgID}")
        
        # Check for execution errors and filter them out
        if any(indicator in sql_content for indicator in execution_error_indicators):
            print("⚠️ Warning: Execution error found in SQL content, filtering out error lines...")
            original_length = len(sql_content)
            
            # Split by lines and filter out lines with execution errors
            lines = sql_content.split('\n')
            filtered_lines = []
            error_lines_count = 0
            
            # Enhanced filtering with better error detection patterns
            error_patterns = [
                "Execution error",
                "Error:",
                "I apologize",
                "I encountered",
                "Something went wrong",
                "Unable to execute",
                "There was an error",
                "I'm sorry"
            ]
            
            for line in lines:
                line_lower = line.lower()
                is_error_line = any(pattern.lower() in line_lower for pattern in error_patterns)
                
                if is_error_line:
                    error_lines_count += 1
                    continue
                elif line.strip():  # Keep non-empty, non-error lines
                    filtered_lines.append(line)
                else:
                    # Keep empty lines for proper SQL formatting
                    filtered_lines.append(line)
            
            sql_content = '\n'.join(filtered_lines)
            print(f"🔍 Filtered out {error_lines_count} error lines")
            print(f"🔍 After filtering: {len(sql_content)} characters remaining (was {original_length})")
            
            # If filtering resulted in mostly empty content, try multiple alternative approaches
            if len(sql_content.strip()) < 100:  # Less than 100 chars is likely insufficient
                print("⚠️ Filtering resulted in minimal content, trying alternative extraction methods...")
                
                # Method 1: Extract SQL statements by keywords
                sql_keywords = ['DROP', 'CREATE', 'SELECT', 'FROM', 'WHERE', 'INSERT', 'UPDATE', 'DELETE', 'ALTER', 'INDEX', 'PRIMARY KEY']
                sql_lines = []
                
                for line in lines:
                    line_upper = line.upper().strip()
                    if (any(keyword in line_upper for keyword in sql_keywords) and 
                        not any(pattern.lower() in line.lower() for pattern in error_patterns)):
                        sql_lines.append(line)
                
                if sql_lines:
                    sql_content = '\n'.join(sql_lines)
                    print(f"🔍 Method 1: Found {len(sql_lines)} SQL statement lines ({len(sql_content)} chars)")
                else:
                    # Method 2: Look for complete SQL blocks (CREATE TABLE ... );
                    sql_blocks = re.findall(r'((?:DROP|CREATE|ALTER)\s+.*?;)', content, re.DOTALL | re.IGNORECASE)
                    if sql_blocks:
                        sql_content = '\n\n'.join(sql_blocks)
                        print(f"🔍 Method 2: Found {len(sql_blocks)} complete SQL blocks ({len(sql_content)} chars)")
                    else:
                        print("⚠️ No valid SQL statements found after all extraction attempts")
                        return ""
        
        # Final validation: ensure we have meaningful SQL content
        if not sql_content.strip():
            print("⚠️ Final validation failed: no SQL content extracted")
            return ""
        
        # Check that we have actual SQL statements, not just comments
        sql_statement_patterns = [r'CREATE\s+TABLE', r'DROP\s+TABLE', r'CREATE\s+VIEW', r'CREATE\s+PROCEDURE']
        has_sql_statements = any(re.search(pattern, sql_content, re.IGNORECASE) for pattern in sql_statement_patterns)
        
        if not has_sql_statements:
            print("⚠️ Final validation failed: no recognizable SQL statements found")
            return ""
        
        print(f"✅ Successfully extracted SQL content ({len(sql_content)} characters)")
        return sql_content

    @staticmethod
    def extract_python_code(content: str) -> str:
        """
        Extract Python code from LLM response, removing markdown code blocks and execution errors
        
        Args:
            content: Raw LLM response content
            
        Returns:
            str: Clean Python code without markdown blocks
        """
        # Check for execution errors first
        if "Execution error" in content:
            print("⚠️ Warning: Execution error found in content, filtering out error lines...")
            # Filter out lines containing execution errors
            lines = content.split('\n')
            clean_lines = []
            for line in lines:
                if "Execution error" not in line and not line.strip().startswith("Error:"):
                    clean_lines.append(line)
            content = '\n'.join(clean_lines)
        
        # Remove markdown code blocks if present
        if content.strip().startswith('```python'):
            # Find the opening ```python and closing ```
            start_marker = '```python'
            end_marker = '```'
            
            start_idx = content.find(start_marker)
            if start_idx != -1:
                # Find content after ```python
                code_start = start_idx + len(start_marker)
                # Find the closing ```
                end_idx = content.find(end_marker, code_start)
                if end_idx != -1:
                    python_code = content[code_start:end_idx].strip()
                else:
                    # No closing ```, take everything after ```python
                    python_code = content[code_start:].strip()
            else:
                python_code = content.strip()
        elif content.strip().startswith('```') and content.strip().endswith('```'):
            # Generic code block without language specification
            lines = content.strip().split('\n')
            if len(lines) > 2:
                # Remove first and last lines (the ``` markers)
                python_code = '\n'.join(lines[1:-1])
            else:
                python_code = content.strip()
        else:
            # No markdown blocks, return as is
            python_code = content.strip()
        
        # Additional cleanup
        python_code = python_code.strip()
        
        # Remove any remaining ``` at start or end
        if python_code.startswith('```'):
            python_code = python_code[3:].strip()
        if python_code.endswith('```'):
            python_code = python_code[:-3].strip()
        
        # Final check for execution errors and other LLM artifacts
        if "Execution error" in python_code:
            print("⚠️ Warning: Execution error still present after cleaning, removing...")
            lines = python_code.split('\n')
            clean_lines = [line for line in lines if "Execution error" not in line]
            python_code = '\n'.join(clean_lines)
        
        # Remove common LLM artifacts that can cause syntax errors
        artifacts_to_remove = [
            "I can see you've shared some code",
            "What would you like me to help you with",
            "These methods handle:",
            "1. `get_specific_endpoints()`",
            "2. `transform_data()`",
            "3. `validate_response()`",
            "I apologize",
            "Let me help you",
            "Here's the code"
        ]
        
        lines = python_code.split('\n')
        clean_lines = []
        for line in lines:
            # Skip lines that contain LLM artifacts
            if any(artifact in line for artifact in artifacts_to_remove):
                continue
            clean_lines.append(line)
        
        python_code = '\n'.join(clean_lines)
        
        # Validate syntax before returning
        try:
            import ast
            ast.parse(python_code)
            print("✅ Generated Python code syntax is valid")
        except SyntaxError as e:
            print(f"⚠️ Warning: Generated Python code has syntax error: {e}")
            print("Attempting to fix common issues...")
            
            # Try to fix common syntax issues
            lines = python_code.split('\n')
            fixed_lines = []
            for line in lines:
                # Skip lines that don't look like Python code
                if (not line.strip() or 
                    line.strip().startswith('#') or
                    line.strip().startswith('def ') or
                    line.strip().startswith('class ') or
                    line.strip().startswith('return ') or
                    line.strip().startswith('if ') or
                    line.strip().startswith('else') or
                    line.strip().startswith('elif ') or
                    line.strip().startswith('try:') or
                    line.strip().startswith('except ') or
                    line.strip().startswith('finally:') or
                    line.strip().startswith('import ') or
                    line.strip().startswith('from ') or
                    line.strip() in ['pass', '}', '{', ')', '(', ']', '['] or
                    '=' in line or
                    line.strip().endswith(':') or
                    line.strip().endswith(',') or
                    line.strip().endswith(')') or
                    line.strip().endswith(']') or
                    line.strip().endswith('}') or
                    line.strip().endswith('"') or
                    line.strip().endswith("'") or
                    line.strip().isdigit() or
                    line.strip().startswith('"""') or
                    line.strip().startswith("'''") or
                    line.strip().endswith('"""') or
                    line.strip().endswith("'''")):
                    fixed_lines.append(line)
                else:
                    print(f"⚠️ Skipping potentially problematic line: {line}")
            
            python_code = '\n'.join(fixed_lines)
            
            # Try to parse again
            try:
                ast.parse(python_code)
                print("✅ Fixed Python code syntax is now valid")
            except SyntaxError as e:
                print(f"⚠️ Could not fix syntax error: {e}")
                print("Returning empty string to prevent syntax errors")
                return ""
            
        return python_code

    @staticmethod
    def run_claude_prompt(prompt: str) -> str:
        # Temporary mock for testing when Claude CLI not available
        if not shutil.which("claude"):
            print("🔄 Claude CLI not found")

        # Original Claude CLI method

        start_time = time.time()
        print(f"🤖 Starting Claude prompt execution...")
        print(f"🔍 Prompt length: {len(prompt)} characters")

        # Clean the prompt to avoid special character issues
        cleaned_prompt = Utils._clean_prompt_for_subprocess(prompt.strip())

        result = subprocess.run(
            ["claude"],
            input=cleaned_prompt,
            text=True,
            capture_output=True,
            timeout=900,  # Increased to 15 minutes for complex integration generation
            encoding='utf-8',
            errors='replace'  # Handle encoding issues gracefully
        )

        execution_time = time.time() - start_time
        print(f"⏱️ Claude execution completed in {execution_time:.2f} seconds")

        if result.returncode != 0:
            error_msg = f"Claude CLI failed with return code {result.returncode}"
            if result.stderr:
                error_msg += f": {result.stderr}"
            if result.stdout:
                error_msg += f"\nStdout: {result.stdout}"
            print(f"❌ Claude CLI Error: {error_msg}")
            raise RuntimeError(error_msg)

        response = result.stdout.strip()
        
        # Enhanced execution error detection
        execution_error_indicators = [
            "Execution error",
            "I apologize for the error",
            "There was an error executing",
            "Error: Unable to",
            "I encountered an error",
            "Something went wrong",
            "I'm sorry, but I can't",
            "I cannot execute"
        ]
        
        # Check for execution errors in response
        has_execution_error = any(indicator in response for indicator in execution_error_indicators)
        
        if has_execution_error:
            print(f"⚠️ Warning: Claude response contains execution error")
            print(f"Response preview: {response[:500]}...")
            
            # Analyze error density to determine if retry is worthwhile
            response_lines = response.split('\n')
            error_line_count = 0
            total_lines = len([line for line in response_lines if line.strip()])
            
            for line in response_lines:
                if any(indicator in line for indicator in execution_error_indicators):
                    error_line_count += 1
            
            error_density = error_line_count / total_lines if total_lines > 0 else 1.0
            print(f"🔍 Error analysis: {error_line_count}/{total_lines} lines contain errors (density: {error_density:.2f})")
            
            # If error density is very high (>80%), raise retryable exception
            if error_density > 0.8:
                error_msg = f"Very high error density detected: {error_line_count}/{total_lines} lines contain errors (density: {error_density:.2f})"
                print(f"🚨 {error_msg} - triggering enterprise retry")
                raise GenerationRetryableError(error_msg)
            
        return response

    @staticmethod
    def _clean_prompt_for_subprocess(prompt: str) -> str:
        """Clean prompt to avoid subprocess issues with special characters"""
        # Replace problematic characters that might cause subprocess issues
        cleaned = prompt
        
        # Handle curly braces that might be interpreted as shell variables
        cleaned = cleaned.replace("{clientID}", "CLIENTID_PLACEHOLDER")
        cleaned = cleaned.replace("{orgID}", "ORGID_PLACEHOLDER")
        cleaned = cleaned.replace("{{clientID}}", "CLIENTID_PLACEHOLDER")
        cleaned = cleaned.replace("{{orgID}}", "ORGID_PLACEHOLDER")
        
        # Add clear instruction to handle placeholders in output
        instruction = """
IMPORTANT: In your SQL output, replace:
- CLIENTID_PLACEHOLDER with {clientID}
- ORGID_PLACEHOLDER with {orgID}

"""
        
        return instruction + cleaned

    @staticmethod
    def load_integration_config(integration_name: str) -> Dict:
        """Load integration-specific configuration from config file (always fresh)"""

        from dynamic_integrations.paths import provider_config_path
        config_file = provider_config_path(integration_name)

        try:
            if os.path.exists(config_file):
                with open(config_file, 'r', encoding='utf-8') as f:
                    config = json.load(f)
                    if os.environ.get('ETL_RUNTIME_DIR'):
                        for field in config.get('env_vars_config', {}).values():
                            env_var = field.get('env_var')
                            if env_var and env_var in os.environ:
                                field['default_value'] = os.environ[env_var]
                    return config
            else:
                print(f"[WARNING] Config file not found for {integration_name}: {config_file}")
                return {}
        except Exception as e:
            print(f"[ERROR] Error loading config for {integration_name}: {str(e)}")
            return {}

    @staticmethod
    def get_additional_fields_config(integration_name: str) -> Dict[str, Dict]:
        """Get additional fields configuration from integration config"""
        try:
            config = Utils.load_integration_config(integration_name.upper())
            additional_fields = config.get('additional_fields', {})
            return additional_fields
        except Exception as e:
            print(f"[ERROR] Could not load additional fields for {integration_name}: {str(e)}")
            return {}

    @staticmethod
    def apply_endpoint_exclusions(endpoints: List[str], integration_name: str) -> List[str]:
        """Apply exclude_endpoints filter from integration config"""
        try:
            config = Utils.load_integration_config(integration_name.upper())
            exclude_endpoints = config.get('exclude_endpoints', [])
            
            if exclude_endpoints:
                filtered_endpoints = [ep for ep in endpoints if ep not in exclude_endpoints]
                print(f"📝 Excluded {integration_name} endpoints: {exclude_endpoints}")
                print(f"📝 Final {integration_name} endpoints: {filtered_endpoints}")
                return filtered_endpoints
            else:
                return endpoints
                
        except Exception as e:
            print(f"⚠️ Could not apply endpoint exclusions for {integration_name}: {e}")
            return endpoints

    @staticmethod
    def append_to_file(file_path: Path, content: str):
        file_path.parent.mkdir(parents=True, exist_ok=True)
        with open(file_path, "a", encoding="utf-8") as f:
            f.write(content.strip() + "\n\n")

    @staticmethod
    def write_file_if_not_exists(file_path: Path, content: str, force: bool = False):
        file_path.parent.mkdir(parents=True, exist_ok=True)
        if force or not file_path.exists():
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(content.strip() + "\n")

    @staticmethod
    def fetch_web_content(url: str) -> str:
        """Fetch content from a web URL using urllib (built-in library)"""
        try:
            import urllib.request
            import urllib.parse
            import urllib.error
            
            # Set user agent to avoid blocking
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
            
            print(f"🌐 Fetching content from: {url}")
            
            # Create request with headers
            req = urllib.request.Request(url, headers=headers)
            
            # Make request with timeout
            with urllib.request.urlopen(req, timeout=30) as response:
                # Read and decode content
                content = response.read().decode('utf-8', errors='ignore')
                
            print(f"✅ Successfully fetched {len(content)} characters from {url}")
            
            # Basic content validation
            if len(content) < 100:
                print(f"⚠️ Warning: Content seems very short ({len(content)} chars)")
            
            return content
                
        except Exception as e:
            print(f"❌ Error fetching web content from {url}: {str(e)}")
            return ""
    
    @staticmethod
    def split_stage_prod_sql(combined_sql: str) -> Dict[str, str]:
        """
        Split combined stage+prod SQL response into separate stage and prod SQL
        
        Args:
            combined_sql: Combined SQL containing both stage and prod tables
            
        Returns:
            Dict with 'stage' and 'prod' keys containing respective SQL
        """
        import re
        
        result = {'stage': '', 'prod': ''}
        
        # Split by comments that indicate entity sections
        # Look for patterns like "-- EntityName (Stage)" and "-- EntityName (Production)"
        sections = re.split(r'(--\s*\w+\s*\([^)]+\))', combined_sql)
        
        current_stage_parts = []
        current_prod_parts = []
        current_type = None
        
        for section in sections:
            section = section.strip()
            if not section:
                continue
                
            # Check if this is a header comment
            if section.startswith('--') and ('(Stage)' in section or '(Production)' in section):
                if '(Stage)' in section:
                    current_type = 'stage'
                elif '(Production)' in section:
                    current_type = 'prod'
                
                # Add the header to appropriate section
                if current_type == 'stage':
                    current_stage_parts.append(section)
                elif current_type == 'prod':
                    current_prod_parts.append(section)
            else:
                # This is SQL content, add to current type
                if current_type == 'stage':
                    current_stage_parts.append(section)
                elif current_type == 'prod':
                    current_prod_parts.append(section)
        
        # Join the parts
        result['stage'] = '\n\n'.join(current_stage_parts).strip()
        result['prod'] = '\n\n'.join(current_prod_parts).strip()
        
        # Fallback: if splitting failed, try alternate approach
        if not result['stage'] or not result['prod']:
            print("⚠️ Primary split method failed, trying fallback approach")
            
            # Look for stage tables (containing "stage" in table name)
            stage_matches = re.findall(r'(--[^-]*\(Stage\).*?(?=--[^-]*\(Production\)|$))', combined_sql, re.DOTALL | re.IGNORECASE)
            prod_matches = re.findall(r'(--[^-]*\(Production\).*?(?=--[^-]*\(Stage\)|--[^-]*\(Production\)|$))', combined_sql, re.DOTALL | re.IGNORECASE)
            
            if stage_matches:
                result['stage'] = '\n\n'.join(stage_matches).strip()
            if prod_matches:
                result['prod'] = '\n\n'.join(prod_matches).strip()
        
        # Add headers if missing
        if result['stage'] and not result['stage'].startswith('--'):
            result['stage'] = '-- Stage Tables\n-- Auto-generated - DO NOT EDIT MANUALLY\n\n' + result['stage']
        
        if result['prod'] and not result['prod'].startswith('--'):
            result['prod'] = '-- Prod Tables\n-- Auto-generated - DO NOT EDIT MANUALLY\n\n' + result['prod']
        
        return result

    @staticmethod
    def get_json_fields_from_schema(schema_data: Dict, endpoint_name: str = None) -> List[Dict]:
        """
        Extract JSON/JSONB field information from schema data

        Args:
            schema_data: Schema dictionary (can be endpoint schema or full schema with endpoints)
            endpoint_name: If provided, find fields for specific endpoint in full schema

        Returns:
            List of dicts with JSON field info: [{'api_name': str, 'data_type': str, 'db_column': str, ...}]
        """
        json_fields = []

        try:
            # If endpoint_name provided, this is a full schema - find the specific endpoint
            if endpoint_name and 'endpoints' in schema_data:
                for ep in schema_data.get('endpoints', []):
                    if ep.get('name') == endpoint_name:
                        fields = ep.get('fields', [])
                        break
                else:
                    return []  # Endpoint not found
            else:
                # This is already an endpoint schema or full schema without specific endpoint
                fields = schema_data.get('fields', [])

            # Extract JSON/JSONB fields
            for field in fields:
                data_type = field.get('data_type', '').upper()
                if data_type in ['JSON', 'JSONB']:
                    api_name = field.get('api_name') or field.get('name')
                    if api_name:
                        json_fields.append({
                            'api_name': api_name,
                            'data_type': data_type,
                            'db_column': field.get('db_column'),
                            'field_info': field
                        })

            return json_fields

        except Exception as e:
            print(f"❌ Error extracting JSON fields: {str(e)}")
            return []