# Dynamic ETL Framework

Baseline for developing reusable, configuration-driven integrations.

- `run_dynamic_integration.py` selects an integration and runs provisioning or incremental sync.
- `dynamic_integrations/generator/config/` defines runtime inputs and authentication for each provider.
- `dynamic_integrations/generated_integrations/` holds provider classes, endpoint schemas, and SQL templates.
- `dynamic_integrations/generator/` and `dynamic_integrations/etl/` contain the shared execution, authentication, and data-processing code.

Set the database and provider configuration through the environment and runtime parameters before attempting a sync. This baseline contains no populated provider defaults, token backups, or sample responses. Some legacy paths require their own deployment files.

Install the dependencies from `requirements.txt` and configure AWS RDS and Secrets Manager before starting the CLI. The current runner initializes database engines during imports, so even `python run_dynamic_integration.py --help` requires `USE_AWS_DB=True` and valid AWS configuration.
