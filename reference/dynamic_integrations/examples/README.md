# Dynamic Integration Examples

This folder contains practical examples demonstrating how to use the Dynamic Integration Package orchestrator with various integrations, particularly Xero Blue.

## 📁 Example Files

### 1. `quick_xeroblue_example.py`
**Quick start example for common use cases**

- ✅ **Minimal setup** - Get started quickly
- ✅ **UPSERT example** - Most common operation
- ✅ **Auto-detect example** - New dynamic feature
- ✅ **Simple configuration** - Easy to understand

**Best for:** First-time users, quick testing, common scenarios

### 2. `example_xeroblue_dynamic.py`
**Comprehensive examples showing all capabilities**

- ✅ **5 detailed examples** - Complete feature coverage
- ✅ **All operation modes** - INSERT, UPSERT, AUTO
- ✅ **Error handling** - Production-ready patterns
- ✅ **Logging setup** - Full debugging support
- ✅ **Backward compatibility** - Migration examples

**Best for:** Advanced users, production deployment, learning all features

## 🚀 Quick Start

### Prerequisites

1. **Environment Setup:**
   ```bash
   cd "/home/jepilor/etl 1.0/etl_packages"
   ```

2. **Set Environment Variables:**
   ```bash
   export EtaniClientID="YOUR_CLIENT_ID"
   export EtaniOrganisationID="YOUR_ORG_ID"
   export XeroTenantID="YOUR_XERO_TENANT_ID"
   export JOB_ID="0"
   export JOB_RUN_ID="0"
   export TRIGGER_TYPE="MANUAL"
   export DB_Destination="DW"
   ```

3. **Run Quick Example:**
   ```bash
   python dynamic_integrations/examples/quick_xeroblue_example.py
   ```

## 📖 Usage Examples

### Example 1: Quick UPSERT (Most Common)
```python
from dynamic_integrations import create_package_upsert

# Simple configuration
config = {'rate_limit': 60, 'debug': True}

# Create orchestrator
orchestrator = create_package_upsert('XEROBLUE', config)

# Run specific endpoints
result = orchestrator.run(endpoint_list=['contacts', 'accounts'])

print(f"Status: {result.get('status')}")
```

### Example 2: Auto-Detect Mode (New Feature)
```python
from dynamic_integrations import create_integration_package
from dynamic_integrations.integrations.xeroblue_integration import XeroblueIntegration

# Create integration instance
xeroblue = XeroblueIntegration(config)

# Auto-detect operation mode
orchestrator = create_integration_package(xeroblue)

# Run based on detected mode
if orchestrator.operation_mode.value == 'INSERT':
    result = orchestrator.run_initialization()
else:
    result = orchestrator.run()
```

### Example 3: Explicit INSERT Mode
```python
from dynamic_integrations import create_integration_package, OperationMode

# Explicit INSERT mode for new client setup
orchestrator = create_integration_package(
    xeroblue_integration,
    operation_mode=OperationMode.INSERT
)

# Create SQL objects and initialize
result = orchestrator.run_initialization(
    create_objects=True,
    initialize_indexes=True,
    upload_pbi=False
)
```

### Example 4: Single Endpoint Processing
```python
# Test or debug a specific endpoint
orchestrator = create_integration_package(xeroblue_integration)
result = orchestrator.run_single_endpoint('contacts')
```

## 🔧 Configuration Options

### Basic Configuration
```python
config = {
    'rate_limit': 60,           # API rate limit per minute
    'timeout_seconds': 900,     # Request timeout
    'debug': True,              # Enable debug logging
    'parallel_execution': True  # Enable parallel processing
}
```

### Environment Variables
| Variable | Description | Example |
|----------|-------------|---------|
| `EtaniClientID` | Client identifier | `BIGOLESHOECOMPANY_CLIENT1518` |
| `EtaniOrganisationID` | Organization ID | `5393` |
| `XeroTenantID` | Xero tenant ID | `your-tenant-id` |
| `JOB_ID` | Job identifier | `0` |
| `JOB_RUN_ID` | Job run identifier | `0` |
| `TRIGGER_TYPE` | Trigger type | `MANUAL` |
| `DB_Destination` | Database destination | `DW` |

## 🎯 Operation Modes

### AUTO Mode (Recommended)
- **Automatically detects** whether to use INSERT or UPSERT
- **Smart detection** based on available integration methods
- **Failsafe default** to UPSERT if uncertain

### INSERT Mode
- **New client setup** - Creates SQL objects, indexes, etc.
- **Infrastructure initialization** - Sets up database structure
- **One-time operation** - Usually run once per client

### UPSERT Mode
- **Data synchronization** - Updates existing data
- **Regular operations** - Run on schedule for data updates
- **Most common use case** - Daily/hourly data sync

## 📊 Example Outputs

### Successful UPSERT
```
✅ UPSERT Example: completed
Status: completed
Duration: 45.23s
Endpoints: 3/3 successful
Records: 1,247 processed
```

### Successful INSERT
```
✅ INSERT Example: completed
Status: completed
Duration: 120.45s
✅ sql_objects: SQL objects created successfully
✅ indexes: Indexes initialized successfully
❌ powerbi: PowerBI template upload skipped
```

### Error Example
```
❌ Integration failed: completed_with_errors
Error: Rate limit exceeded
Duration: 15.67s
```

## 🚨 Common Issues & Solutions

### 1. Import Errors
**Problem:** `ModuleNotFoundError: No module named 'dynamic_integrations'`

**Solution:**
```bash
# Make sure you're in the right directory
cd "/home/jepilor/etl 1.0/etl_packages"

# Or add to Python path
export PYTHONPATH="/home/jepilor/etl 1.0/etl_packages:$PYTHONPATH"
```

### 2. Missing Environment Variables
**Problem:** `TypeError: unsupported operand type(s) for +: 'NoneType' and 'str'`

**Solution:**
```bash
# Set required environment variables
export EtaniClientID="YOUR_CLIENT_ID"
export EtaniOrganisationID="YOUR_ORG_ID"
# ... etc
```

### 3. Authentication Issues
**Problem:** `Authentication failed` or `Invalid token`

**Solution:**
- Check your Xero tenant ID
- Verify token files exist in `/token/` directory
- Ensure token files are not expired

### 4. Database Connection Issues
**Problem:** `Connection refused` or `Database error`

**Solution:**
- Verify database connection settings
- Check `DB_Destination` environment variable
- Ensure database server is accessible

## 🏃‍♂️ Running Examples

### Quick Test (Recommended)
```bash
cd "/home/jepilor/etl 1.0/etl_packages"
python dynamic_integrations/examples/quick_xeroblue_example.py
```

### Comprehensive Test
```bash
cd "/home/jepilor/etl 1.0/etl_packages"
python dynamic_integrations/examples/example_xeroblue_dynamic.py
```

### Individual Example Sections
```bash
# Edit the example file to uncomment only the examples you want:
# results['auto_detect'] = example_1_auto_detect_mode()
# results['explicit_upsert'] = example_2_explicit_upsert_mode()
# etc.
```

## 📝 Creating Your Own Examples

### Template Structure
```python
#!/usr/bin/env python3
import os
import sys

# Add path
sys.path.append('/home/jepilor/etl 1.0/etl_packages')

# Import orchestrator
from dynamic_integrations import create_integration_package

def your_example():
    """Your custom example"""
    try:
        # Your code here
        config = {'debug': True}
        # ... implementation
        
        return result
    except Exception as e:
        print(f"❌ Example failed: {str(e)}")
        return None

if __name__ == "__main__":
    your_example()
```

## 📚 Additional Resources

- **Main Documentation:** `../README.md`
- **Integration Package:** `../IntegrationPackage.py`
- **Original Files:** `../original_*.py` (for reference)
- **Log Files:** Check current directory for `*.log` files after running

## 💡 Tips & Best Practices

1. **Start with Quick Example** - Get familiar with basic usage
2. **Use Auto-Detect Mode** - Let the orchestrator choose the right mode
3. **Test with Single Endpoints** - Debug issues with specific endpoints
4. **Check Logs** - Enable debug mode for troubleshooting
5. **Set Environment Variables** - Use proper configuration management
6. **Handle Errors Gracefully** - Always check result status
7. **Use Appropriate Mode** - INSERT for setup, UPSERT for sync

## 🆘 Support

If you encounter issues:

1. **Check the logs** - Look for detailed error messages
2. **Verify configuration** - Ensure all environment variables are set
3. **Test connectivity** - Verify database and API access
4. **Review examples** - Compare your code with working examples
5. **Check original files** - Reference `original_*.py` for legacy behavior

---

**Happy integrating! 🚀**