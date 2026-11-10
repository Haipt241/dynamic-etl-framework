"""Public compatibility API, loaded lazily so design tools need no database."""
from importlib import import_module

_EXPORTS = {
    "IntegrationPackage": "IntegrationPackage", "OperationMode": "IntegrationPackage",
    "create_integration_package": "IntegrationPackage", "create_package_insert": "IntegrationPackage",
    "create_package_upsert": "IntegrationPackage", "run_integration_insert_initialization": "IntegrationPackage",
    "run_integration_upsert": "IntegrationPackage", "register_integration": "IntegrationPackage",
    "list_registered_integrations": "IntegrationPackage", "is_integration_registered": "IntegrationPackage",
    "create_integration_from_registry": "IntegrationPackage",
    "BaseIntegration": "base_integration", "IntegrationCapability": "base_integration",
    "IntegrationRegistry": "base_integration", "validate_integration_interface": "base_integration",
    "get_integration_capabilities": "base_integration", "SingletonManager": "singleton_manager",
}
__all__ = list(_EXPORTS)
__version__ = "3.1.0"

def __getattr__(name):
    if name not in _EXPORTS:
        raise AttributeError(name)
    # Preserve registry initialization for callers of the historical public API.
    import_module(f"{__name__}.IntegrationPackage")
    module = import_module(f"{__name__}.{_EXPORTS[name]}")
    # Importing a submodule sets a package attribute; restore all public exports.
    for public, source in _EXPORTS.items():
        if source == _EXPORTS[name]:
            globals()[public] = getattr(module, public)
    return globals()[name]
