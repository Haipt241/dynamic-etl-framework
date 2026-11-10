"""Resolve runtime assets, optionally inside an isolated web job snapshot."""
import os
from pathlib import Path

def integration_root():
    override = os.environ.get("ETL_RUNTIME_DIR")
    return Path(override) if override else Path(__file__).resolve().parent

def provider_directory(provider):
    return integration_root() / "generated_integrations" / provider.lower()

def provider_config_path(provider):
    return integration_root() / "generator" / "config" / f"{provider.lower()}_config.json"
