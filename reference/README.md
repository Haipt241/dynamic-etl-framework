# Reference material

Historical examples, one-off scripts, manual SQL revisions and design notes are collected here. They are not part of the supported runtime. Paths inside these snapshots are historical; do not execute them as deployment scripts.

Live provider adapters, schemas and SQL remain in `dynamic_integrations/generated_integrations/` because the existing CLI still loads them. They are not disposable reference files. `dynamic_integrations/discovery/` contains the active discovery helpers formerly under `archives/legacy_etl/`. Deleting either requires migration and parity tests first.

The active runtime is organized as follows:

| Location | Responsibility |
| --- | --- |
| `run_dynamic_integration.py` | Existing INSERT/UPSERT entry point |
| `dynamic_integrations/generated_integrations/` | Existing provider adapters and runtime assets |
| `dynamic_integrations/generator/` | Shared adapter, auth, rate limiting, reconciliation, SQL generation |
| `dynamic_integrations/etl/` | Extraction, pagination, nested records, transformation |
| `dynamic_integrations/powerbi/` | Existing downstream publishing |
| `reliability_controlling/` | Retry strategies and monitors |
| `sql_helper.py`, `config.py` | Existing database infrastructure |
| `scripts/` | Operational utilities |
| `tests/` | Regression checks |

Removed dead code: unused WriteCoordinator, discarded adapter/auth/pagination code generation, duplicate schema conversion in handlers, unreachable controller branch. Public compatibility APIs and dynamically selected provider methods are retained. Static absence of direct calls is not sufficient evidence to delete a callback or CLI entry point.
