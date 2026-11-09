#!/usr/bin/env python3
"""
Config Updater for Dynamic Integrations - Generic Version

Simple script to update integration config.json files with dynamic parameters.
No longer relies on hardcoded environment variables.

Usage:
    python update_config.py --integration qbo --param EtaniClientID=CLIENT123 --param RealmID=456
    python update_config.py --integration xero --param EtaniClientID=CLIENT123 --param XeroTenantID=789 --dry-run
    python update_config.py --integration qbo --restore
"""

import argparse
import sys
import json
from pathlib import Path
from datetime import datetime

def log(message: str, level: str = "INFO"):
    """Log message with timestamp"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] [{level}] {message}")

def update_integration_config(integration_name: str, params: dict = None, dry_run: bool = False, restore: bool = False) -> bool:
    """Update integration configuration with provided parameters"""
    try:
        project_root = Path(__file__).parent
        config_path = project_root / "dynamic_integrations" / "generator" / "config" / f"{integration_name}_config.json"
        backup_path = config_path.with_suffix('.json.backup')
        
        if restore:
            if not backup_path.exists():
                log(f"No backup found: {backup_path}", "ERROR")
                return False
            
            import shutil
            shutil.copy2(backup_path, config_path)
            log("Config restored from backup")
            return True
        
        if not config_path.exists():
            log(f"Config file not found: {config_path}", "ERROR")
            return False
        
        if not params:
            log("No parameters provided", "WARN")
            return False
        
        log(f"Updating config with {len(params)} parameters:")
        for key, value in params.items():
            # Mask sensitive values for logging
            display_value = value if len(str(value)) < 20 else f"{str(value)[:10]}...{str(value)[-5:]}"
            log(f"  {key} = {display_value}")
        
        if dry_run:
            log("DRY RUN - No changes will be made")
            return True
        
        # Load config
        with open(config_path, 'r') as f:
            config = json.load(f)
        
        # Create backup
        import shutil
        shutil.copy2(config_path, backup_path)
        log(f"Created backup: {backup_path}")
        
        # Update config values
        updated_count = 0
        if 'env_vars_config' in config:
            for config_key, var_config in config['env_vars_config'].items():
                # Try to match parameter by env_var name or config key
                env_var_name = var_config.get('env_var', '')
                
                # Check if we have a parameter that matches this config
                param_value = None
                if env_var_name in params:
                    param_value = params[env_var_name]
                elif config_key.upper() in params:
                    param_value = params[config_key.upper()]
                elif config_key in params:
                    param_value = params[config_key]
                
                if param_value is not None:
                    # Convert string values to appropriate types
                    if config_key == 'reset_mode':
                        param_value = str(param_value).lower() in ('true', '1', 'yes', 'on')
                    elif config_key in ['etani_organisation_id', 'job_id', 'job_run_id']:
                        try:
                            param_value = int(param_value)
                        except ValueError:
                            log(f"Warning: Could not convert {config_key}={param_value} to integer", "WARN")
                    
                    var_config['default_value'] = param_value
                    log(f"Updated config: {config_key} = {param_value}")
                    updated_count += 1
        
        if updated_count == 0:
            log("No config values were updated - check parameter names", "WARN")
            return False
        
        # Save updated config
        with open(config_path, 'w') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
        
        log(f"Successfully updated {updated_count} config values in {config_path}")
        return True
        
    except Exception as e:
        log(f"Error updating config: {e}", "ERROR")
        import traceback
        traceback.print_exc()
        return False

def parse_params(param_list):
    """Parse parameter list in format KEY=VALUE into dictionary"""
    params = {}
    for param in param_list:
        if '=' not in param:
            print(f"Warning: Invalid parameter format '{param}', expected KEY=VALUE")
            continue
        key, value = param.split('=', 1)
        params[key.strip()] = value.strip()
    return params

def main():
    parser = argparse.ArgumentParser(
        description='Update integration config with dynamic parameters',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python update_config.py --integration qbo --param EtaniClientID=CLIENT123 --param RealmID=456
  python update_config.py --integration xero --param EtaniClientID=CLIENT123 --param XeroTenantID=789 --dry-run
  python update_config.py --integration qbo --restore
        """
    )
    
    parser.add_argument('--integration', '-i', required=True,
                       help='Integration name (must match config file name)')
    parser.add_argument('--param', '-p', action='append', default=[],
                       help='Parameter in format KEY=VALUE (can be used multiple times)')
    parser.add_argument('--dry-run', '-d', action='store_true',
                       help='Show what would be updated without making changes')
    parser.add_argument('--restore', '-r', action='store_true',
                       help='Restore config from backup instead of updating')
    
    args = parser.parse_args()
    
    log(f"Config Updater for {args.integration} integration")
    
    # Parse parameters
    params = parse_params(args.param)
    
    success = update_integration_config(
        args.integration, 
        params=params,
        dry_run=args.dry_run,
        restore=args.restore
    )
    
    if success:
        log("Config update completed successfully")
    else:
        log("Config update failed", "ERROR")
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()