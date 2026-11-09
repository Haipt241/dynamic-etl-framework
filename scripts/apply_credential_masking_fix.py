"""
Apply credential masking fix to all generated integration files

This script updates the setup_configuration() method in all generated integrations
to mask sensitive credentials (secrets, passwords, tokens, keys) in logs.
"""

import os
import re
from pathlib import Path

# Old pattern to find
OLD_PATTERN = r"""                # Log source of value for debugging
                source = 'environment' if os\.getenv\(env_var\) else 'config default'
                print\(f"📝 \{attr_name\}: \{value\} \(from \{source\}\)"\)"""

# New replacement with masking
NEW_PATTERN = """                # Log source of value for debugging (mask sensitive fields)
                source = 'environment' if os.getenv(env_var) else 'config default'

                # Sensitive fields that should be masked
                sensitive_fields = ['secret', 'password', 'token', 'key', 'credential']
                is_sensitive = any(field in attr_name.lower() for field in sensitive_fields)

                if is_sensitive and value:
                    # Mask sensitive values - show only first 4 and last 4 chars
                    if len(str(value)) > 12:
                        masked_value = f"{str(value)[:4]}...{str(value)[-4:]}"
                    else:
                        masked_value = "***"
                    print(f"📝 {attr_name}: {masked_value} (from {source}) [MASKED]")
                else:
                    print(f"📝 {attr_name}: {value} (from {source})")"""

def apply_fix_to_file(filepath):
    """Apply credential masking fix to a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check if already fixed
        if '[MASKED]' in content:
            return 'already_fixed'

        # Check if pattern exists
        if 'print(f"📝 {attr_name}: {value} (from {source}")' not in content:
            return 'pattern_not_found'

        # Replace the pattern
        # Use a simpler string replacement since regex is complex with formatting
        old_lines = [
            "                # Log source of value for debugging",
            "                source = 'environment' if os.getenv(env_var) else 'config default'",
            '                print(f"📝 {attr_name}: {value} (from {source}")'
        ]

        # Also try pattern without the comment
        old_lines_no_comment = [
            "                source = 'environment' if os.getenv(env_var) else 'config default'",
            '                print(f"📝 {attr_name}: {value} (from {source}")'
        ]

        new_lines = [
            "                # Log source of value for debugging (mask sensitive fields)",
            "                source = 'environment' if os.getenv(env_var) else 'config default'",
            "",
            "                # Sensitive fields that should be masked",
            "                sensitive_fields = ['secret', 'password', 'token', 'key', 'credential']",
            "                is_sensitive = any(field in attr_name.lower() for field in sensitive_fields)",
            "",
            "                if is_sensitive and value:",
            "                    # Mask sensitive values - show only first 4 and last 4 chars",
            "                    if len(str(value)) > 12:",
            '                        masked_value = f"{str(value)[:4]}...{str(value)[-4:]}"',
            "                    else:",
            '                        masked_value = "***"',
            '                    print(f"📝 {attr_name}: {masked_value} (from {source}) [MASKED]")',
            "                else:",
            '                    print(f"📝 {attr_name}: {value} (from {source}")'
        ]

        old_block = '\n'.join(old_lines)
        old_block_no_comment = '\n'.join(old_lines_no_comment)
        new_block = '\n'.join(new_lines)

        if old_block in content:
            content = content.replace(old_block, new_block)

            # Write back
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)

            return 'fixed'
        elif old_block_no_comment in content:
            # Pattern without comment found, add comment in replacement
            content = content.replace(old_block_no_comment, new_block)

            # Write back
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)

            return 'fixed'
        else:
            return 'pattern_mismatch'

    except Exception as e:
        return f'error: {e}'

def main():
    # Find all integration files
    base_dir = Path(__file__).parent.parent / 'dynamic_integrations' / 'generated_integrations'

    integration_files = list(base_dir.glob('*/*_integration.py'))

    print(f"Found {len(integration_files)} integration files")
    print("=" * 80)

    results = {
        'fixed': [],
        'already_fixed': [],
        'pattern_not_found': [],
        'pattern_mismatch': [],
        'error': []
    }

    for filepath in integration_files:
        integration_name = filepath.parent.name
        result = apply_fix_to_file(filepath)

        if result.startswith('error'):
            results['error'].append((integration_name, result))
            status = "[ERROR]"
        elif result == 'fixed':
            results['fixed'].append(integration_name)
            status = "[FIXED]"
        elif result == 'already_fixed':
            results['already_fixed'].append(integration_name)
            status = "[OK] Already fixed"
        elif result == 'pattern_not_found':
            results['pattern_not_found'].append(integration_name)
            status = "[SKIP] Pattern not found"
        else:
            results['pattern_mismatch'].append(integration_name)
            status = "[SKIP] Pattern mismatch"

        print(f"{status:20} {integration_name}")

    print("\n" + "=" * 80)
    print("SUMMARY:")
    print(f"  Fixed: {len(results['fixed'])}")
    print(f"  Already fixed: {len(results['already_fixed'])}")
    print(f"  Pattern not found: {len(results['pattern_not_found'])}")
    print(f"  Pattern mismatch: {len(results['pattern_mismatch'])}")
    print(f"  Errors: {len(results['error'])}")

    if results['fixed']:
        print(f"\nSuccessfully applied credential masking to {len(results['fixed'])} integrations")

if __name__ == '__main__':
    main()
