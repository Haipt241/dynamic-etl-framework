# Repository layout and compatibility

The seven top-level folders are `dynamic_integrations`, `web`, `scripts`, `tests`, `docs`, `reference`, and `var`. Root files contain configuration, deployment files and the two application entry points.

## Engine ownership

| Package | Responsibility |
| --- | --- |
| `runtime` | Workflow shared by CLI/web; config-driven adapter; sync, rate limiting, reconciliation, child endpoints |
| `auth` | Authentication strategies, token managers and token locks |
| `database` | Existing SQL helper implementation and connection management |
| `monitoring` | Container/query metrics and cost tracking |
| `storage` | S3 upload implementation used by auth and operations |
| `reliability` | Existing retry strategies, handlers and monitors |
| `etl` | Extraction, transformation and common value conversions |
| `generator` | Configuration, schema-to-SQL and optional adapter generation |
| `compatibility` | Historical orchestration and QBO/Xero-specific implementations |
| `generated_integrations` | Existing installed provider adapters, schemas and SQL |

## Compatibility boundary

`python run_dynamic_integration.py ...` still uses the same arguments and workflow implementation. Web workers import that implementation from `dynamic_integrations.runtime.workflow`. The historical `dynamic_integrations` public exports and `dynamic_integrations.IntegrationPackage` import are retained. The latter is only a forwarding module, not a second implementation.

The older package orchestrator remains in `compatibility.package`: its orchestration differs from the current workflow, so it is not silently replaced. Its provider-specific logic remains executable and shares the relocated infrastructure. Existing generated providers are still preferred by the adapter factory. No provider-specific logic was discarded as part of this layout migration.

Internal imports changed: root `sql_helper`, `common_token_manager`, `utils`, monitoring modules, and `reliability_controlling` now live in the packages above. External code importing those internal module paths must update its imports. Root `config.py` stays in place. Reference files are not rewritten and are not runtime dependencies.

## Data locations

API dumps and SQL error logs are now under `var/json` and `var/logs`. `ETL_DATA_DIR` overrides the data root. Web workers default to their own job-local data folder. Provider assets continue to use `ETL_RUNTIME_DIR`, so schema/config snapshots keep their previous layout.

New web state defaults to `var/web`. Existing `.etl-tool` state is read in place while present, preserving saved definitions and avoiding an unsafe move of an active SQLite database. `--data-dir` remains supported. Do not delete runtime data as part of source cleanup.

## Validation

Run the offline acceptance checks:

```sh
python -m pytest -q tests/test_web_tool.py tests/test_repository_layout.py tests/fixes/test_simple_null_filtering.py tests/fixes/test_date_comparison_fix.py tests/unit/test_convert_data_types.py
```

The layout regression imports all 21 installed adapters, checks assets, CLI help and configured-provider parity with mocked secrets. It does not validate live vendor requests or production database writes. Three historical diagnostic scripts with pre-existing Python 3.10 syntax errors were moved to `reference/tests`.
