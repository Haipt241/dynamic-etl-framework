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


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def data_directory(*parts):
    """Writable data, isolated per worker when a runtime snapshot is active."""
    override = os.environ.get("ETL_DATA_DIR")
    runtime = os.environ.get("ETL_RUNTIME_DIR")
    base = Path(override) if override else (Path(runtime).parent / "data" if runtime else PROJECT_ROOT / "var")
    return base.joinpath(*parts)


def web_data_directory():
    """Keep existing saved definitions accessible until an explicit state migration."""
    legacy = PROJECT_ROOT / ".etl-tool"
    current = data_directory("web")
    return legacy if legacy.exists() and not current.exists() else current
