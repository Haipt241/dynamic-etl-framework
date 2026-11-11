# Dynamic Integration Package

A unified, dynamic orchestrator for integration operations that can handle both **INSERT** and **UPSERT** operations seamlessly.

## Overview

This package combines the functionality of the original `integration_package_insert.py` and `IntegrationPackageUpsert.py` into a single, dynamic class that can automatically detect the operation mode or allow explicit specification.

## Key Features

- **Dynamic Operation Mode**: Auto-detect INSERT or UPSERT operations based on integration capabilities
- **Unified Interface**: Single class combining all methods from both original classes
- **Backward Compatibility**: Maintains compatibility with existing factory functions
- **Integration-Agnostic**: Works with any integration that follows the standardized interface
- **Comprehensive Logging**: Enhanced logging with operation mode awareness
- **Error Handling**: Robust error handling across all operation modes

## File Structure

```
dynamic_integrations/
├── __init__.py                              # Package initialization
├── IntegrationPackage.py                    # Main unified orchestrator class
├── cms_manager.py                           # CMS management utilities
├── sql_object_manager.py                    # SQL object management utilities
├── integrations/                           # Integration implementations
│   ├── __init__.py
│   ├── xeroblue_integration.py
│   └── ... (other integration files)
└── README.md                               # This file
```

## Operation Modes

### 1. AUTO Mode (Default)
Automatically detects operation mode based on available integration methods:
- **INSERT**: If integration has `get_insert_configuration()` method
- **UPSERT**: If integration has `run_full_sync()` method
- **Default**: UPSERT if both or neither are available

### 2. INSERT Mode
Handles INSERT operations with:
- SQL object creation
- Index initialization  
- PowerBI template upload
- Integration-specific INSERT logic

### 3. UPSERT Mode
Handles UPSERT operations with:
- Full synchronization
- Single endpoint processing
- Data extraction and loading
- Integration-specific UPSERT logic

## Usage Examples

### Basic Usage with Auto-Detection

```python
from etl_packages.dynamic_integrations import create_integration_package

# Auto-detect operation mode
orchestrator = create_integration_package(integration_instance)

# For INSERT operations (auto-detected)
result = orchestrator.run_initialization()

# For UPSERT operations (auto-detected)  
result = orchestrator.run()
```

### Explicit Operation Mode

```python
from etl_packages.dynamic_integrations import create_integration_package, OperationMode

# Explicit INSERT mode
orchestrator = create_integration_package(
    integration_instance, 
    operation_mode=OperationMode.INSERT
)
result = orchestrator.run_initialization()

# Explicit UPSERT mode
orchestrator = create_integration_package(
    integration_instance,
    operation_mode=OperationMode.UPSERT  
)
result = orchestrator.run()
```

### Backward Compatibility

```python
# Original INSERT factory function (still works)
from etl_packages.dynamic_integrations import create_package_insert
orchestrator = create_package_insert(integration_instance)
result = orchestrator.run_initialization()

# Original UPSERT factory function (still works)
from etl_packages.dynamic_integrations import create_package_upsert
orchestrator = create_package_upsert('XEROBLUE', config)
result = orchestrator.run()
```

### Convenience Functions

```python
from etl_packages.dynamic_integrations import (
    run_integration_insert_initialization,
    run_integration_upsert
)

# Direct INSERT execution
result = run_integration_insert_initialization(
    integration_instance,
    create_objects=True,
    initialize_indexes=True,
    upload_pbi=False
)

# Direct UPSERT execution
result = run_integration_upsert(
    'XEROBLUE',
    endpoint_list=['contacts', 'invoices'],
    config={'rate_limit': 60}
)
```

## Integration Interface Requirements

### For INSERT Operations
**Required:**
- `integration_name`: str attribute
- `validate_configuration()`: bool method  
- `get_insert_configuration()`: Dict method

**Optional:**
- `create_sql_objects()`: bool method
- `initialize_indexes()`: bool method
- `upload_powerbi_template()`: bool method

### For UPSERT Operations
**Required:**
- `integration_name`: str attribute
- `validate_configuration()`: bool method
- `run_full_sync(endpoint_list)`: Dict method

**Optional:**
- `extract_api_response(endpoint)`: Dict method

## Class Methods

### Core Methods
- `validate_integration_interface()` - Validates integration interface
- `get_integration_info()` - Returns integration metadata

### INSERT Methods
- `run_initialization()` - Main INSERT entry point
- `create_sql_objects()` - Creates SQL objects
- `initialize_indexes()` - Initializes indexes
- `upload_powerbi_template()` - Uploads PowerBI templates

### UPSERT Methods
- `run()` - Main UPSERT entry point
- `run_single_endpoint()` - Processes single endpoint

### Factory Functions
- `create_integration_package()` - Main factory with auto-detection
- `create_package_insert()` - INSERT-specific factory
- `create_package_upsert()` - UPSERT-specific factory

## Configuration

```python
config = {
    'rate_limit': 60,
    'timeout_seconds': 900,
    'debug': True,
    'parallel_execution': True,
    'workspace_id': 'powerbi-workspace-id'
}
```

## Error Handling

The orchestrator provides comprehensive error handling:
- Interface validation errors
- Configuration validation errors
- Operation-specific errors
- Integration execution errors

All errors include:
- Error message and type
- Execution ID for tracking
- Operation mode context
- Integration name
- Execution duration

## Logging

Enhanced logging includes:
- Operation mode awareness
- Execution tracking with unique IDs
- Step-by-step progress
- Success/failure indicators
- Performance metrics

## Version History

- **v3.0.0**: Dynamic unified orchestrator combining INSERT and UPSERT operations
- **v2.0.0**: Original separate INSERT and UPSERT orchestrators
- **v1.0.0**: Basic integration support

## Supported Integrations

- **XEROBLUE**: Xero Blue integration with enhanced features
- **MYOB**: Coming soon
- **XERO_CUSTOM**: Coming soon

## Testing

```python
# Run the module directly for testing
python IntegrationPackage.py

# Test with specific integration
from etl_packages.dynamic_integrations import create_integration_package
from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration

integration = XeroblueIntegration({'debug': True})
orchestrator = create_integration_package(integration, 'AUTO')
info = orchestrator.get_integration_info()
print(info)
```

## Dependencies

- `cms_manager.py` - CMS management utilities
- `sql_object_manager.py` - SQL object management
- `integrations/` - Integration-specific implementations
- Standard Python libraries: `os`, `sys`, `time`, `logging`, `typing`, `datetime`, `enum`

## Contributing

When adding new integrations:
1. Implement the required interface methods
2. Add to the factory function in `create_package_upsert()`
3. Update supported integrations list
4. Add tests for the new integration

## Support

For issues or questions:
- Check the original implementation files for reference
- Review the integration interface requirements
- Examine the logging output for debugging
- Test with `operation_mode='AUTO'` for troubleshooting