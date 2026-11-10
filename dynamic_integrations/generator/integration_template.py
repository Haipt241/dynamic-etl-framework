"""Compatibility adapter generated for callers that still import a provider class."""

from dynamic_integrations.generator.configured_integration import ConfiguredIntegration


class __INTEGRATION_NAME__Integration(ConfiguredIntegration):
    def __init__(self, config=None, *, refresh_token=None):
        super().__init__(
            "__INTEGRATION_NAME_LOWER__", config, refresh_token=refresh_token
        )


if __name__ == "__main__":
    from dynamic_integrations import create_package_upsert

    integration = __INTEGRATION_NAME__Integration({"rate_limit": 100, "debug": True})
    if integration.validate_configuration():
        print(create_package_upsert(integration).run())
    else:
        print("Configuration invalid:", integration.error_list)
