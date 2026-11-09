# Archived Demo Scripts

This directory contains older demo and simulation scripts that predate the integration-agnostic architecture transformation.

## Files in this Directory

### `run_integration.py`
- **Purpose**: Simple entry point for plug-and-play ETL system
- **Type**: Command-line interface for running integrations
- **Status**: Pre-integration-agnostic architecture
- **Usage**: `python run_integration.py --integration XEROBLUE --endpoints Organisations,Accounts`

### `run_xeroblue_etl_simulation.py` 
- **Purpose**: Simulate XeroBlue ETL process with production-like configuration
- **Type**: ETL simulation script
- **Status**: Legacy simulation tool
- **Usage**: Demonstrates how the system would work in production

## Why These are Archived

These scripts were created before the **integration-agnostic architecture transformation** and represent older approaches to running integrations. While they may still be functional, they are not part of the current integration-agnostic design pattern.

## Current Integration-Agnostic Approach

For current integration testing and demonstration, use the files in:
- `/home/jepilor/etl 1.0/etl_packages/demo/` - Current integration-agnostic demos and tests

The current approach uses:
```python
# NEW Integration-Agnostic Pattern
xeroblue_integration = XeroblueIntegration(config)
orchestrator = create_package_upsert(xeroblue_integration)
```

Instead of older patterns that may be found in these archived files.

## Relationship to Main Project

These archived scripts show the evolution of the ETL system and may be useful for:
- Understanding the system's development history
- Comparing old vs new approaches
- Reference for migration patterns

However, for active development and testing, use the current integration-agnostic architecture in the main `/demo/` directory.