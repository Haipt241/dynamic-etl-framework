"""Run an integration from its installed schema and provider configuration."""

import logging
import os
import re
from importlib import import_module

from dynamic_integrations.runtime.integration_dynamic import DynamicIntegration
from dynamic_integrations.generator.utils import Utils


class ConfiguredIntegration(DynamicIntegration):
    """Shared adapter for providers that do not need custom Python code."""

    def __init__(self, provider, config=None, *, refresh_token=None):
        self._provider = _normalize_provider(provider).upper()
        self.logger = logging.getLogger(f"DynamicIntegration.{self._provider}")
        provider_config = Utils.load_integration_config(self._provider)
        if not provider_config.get("auth_type"):
            raise ValueError(f"Missing auth_type in {provider} provider config")

        schema = self._load_schema()
        if not schema.get("api_config", {}).get("base_url") or not schema.get("endpoints"):
            raise ValueError(f"Missing API base URL or endpoints in {provider} schema")

        merged = {
            "integration_name": provider.lower(),
            "endpoints": [endpoint["name"] for endpoint in schema["endpoints"]
                          if not endpoint.get("is_virtual_endpoint")],
            "custom_procedures": [procedure["name"] for procedure in schema.get("custom_procedures", [])],
            **provider_config,
            **(config or {}),
        }
        env_fields = {}
        for name, definition in merged.get("env_vars_config", {}).items():
            env_var = definition.get("env_var")
            value = definition.get("default_value")
            if env_var:
                value = os.getenv(env_var, value)
            env_fields[name] = {**definition, "default_value": value}
        merged["env_vars_config"] = env_fields

        if refresh_token:
            self.refresh_token = refresh_token
        super().__init__(merged)

        for name, definition in env_fields.items():
            if definition["default_value"] is not None:
                setattr(self, name, definition["default_value"])

        self.table_prefix_eva = self.table_client_stage
        self.table_client_eva = self.table_client_prod

    @property
    def integration_name(self):
        return self._provider

    @property
    def integration_original_name(self):
        return self.config.get("integration_original_name", self.integration_name)

    def validate_configuration(self):
        if not super().validate_configuration():
            return False

        env_fields = self.config["env_vars_config"]
        env_values = {field["env_var"]: field["default_value"]
                      for field in env_fields.values() if field.get("env_var")}
        for name in self.config.get("required_env_vars", []):
            if env_values.get(name) in (None, "") and not os.getenv(name):
                self.error_list.append(f"Missing required parameter: {name}")
        for name, rule in self.config.get("env_var_validations", {}).items():
            value = env_values.get(name)
            if rule and value not in (None, "") and not _valid_value(rule, str(value)):
                self.error_list.append(f"Invalid parameter or unsupported validation rule: {name}")
        return not self.error_list


def _valid_value(rule, value):
    """Interpret supported legacy rules without executing Python from config."""
    if rule == "lambda x: 'CLIENT' in x":
        return "CLIENT" in value
    if rule == "lambda x: x in ['EVA', 'CMS', 'DW']":
        return value in {"EVA", "CMS", "DW"}
    if rule == "lambda x: bool(x) and len(x) > 0":
        return bool(value)
    if rule == "lambda x: x.isdigit()":
        return value.isdigit()
    if rule == "lambda x: any('.myshopify.com' in store or len(store) > 5 for store in (x if isinstance(x, list) else [x]))":
        return ".myshopify.com" in value or len(value) > 5

    if not isinstance(rule, str):
        return False

    match = re.fullmatch(
        r"lambda x: (x\.isdigit\(\) and )?len\(x\) (>=|>|==) (\d+)( and (?:'-' in x|x\.isalnum\(\)))?",
        rule,
    )
    if not match:
        return False
    digits, operator, threshold, suffix = match.groups()
    length = len(value)
    minimum = int(threshold)
    size_matches = {">=": length >= minimum, ">": length > minimum, "==": length == minimum}
    return (size_matches[operator]
            and (not digits or value.isdigit())
            and (suffix != " and '-' in x" or "-" in value)
            and (suffix != " and x.isalnum()" or value.isalnum()))


def _normalize_provider(provider):
    provider = provider.lower()
    if not re.fullmatch(r"[a-z][a-z0-9_]*", provider):
        raise ValueError(f"Invalid integration name: {provider}")
    return provider


def create_integration(provider, config=None, *, refresh_token=None):
    """Load an existing adapter or create the shared adapter from JSON."""
    provider = _normalize_provider(provider)
    package = f"dynamic_integrations.generated_integrations.{provider}"
    module_name = f"{package}.{provider}_integration"
    try:
        module = import_module(module_name)
    except ModuleNotFoundError as error:
        if error.name not in {package, module_name}:
            raise
        return ConfiguredIntegration(provider, config, refresh_token=refresh_token)

    class_name = f"{provider.upper()}Integration"
    if not hasattr(module, class_name):
        class_name = f"{provider.capitalize()}Integration"
    adapter = getattr(module, class_name)
    if refresh_token:
        return adapter(config, refresh_token=refresh_token)
    if config is not None:
        return adapter(config)
    return adapter()
