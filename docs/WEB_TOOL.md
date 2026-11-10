# Integration Workbench

## Run locally

Use Python 3.10 or newer. The Python server and browser UI use the same code on Windows, macOS and Linux. Windows execution still needs validation on a Windows machine; it uses `multiprocessing` spawn and Waitress rather than Unix-only process APIs.

macOS / Linux:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python run_web.py
```

Windows PowerShell:

```powershell
py -3 -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
.venv\Scripts\python.exe run_web.py
```

Open http://127.0.0.1:8765. Select **Tiếng Việt / English** in the header; the selection is remembered in this browser. The embedded workflow guide is available in both languages. See [the bilingual user workflow](USER_WORKFLOW.md). `--port` and `--data-dir` are optional. The server binds only to loopback and uses a per-session request token. It is a local single-user tool, not a public multi-user deployment. UI/schema/SQL design does not require an AWS or DB connection. Executing a job uses the existing MySQL/AWS infrastructure, credentials and external services. Existing native DB drivers (including ODBC if required by the selected workflow) must be installed on each OS.

## Workflow

1. Enter API base URL, GET path, authentication method, pagination parameters, rate limit, response data path and a sample JSON payload, or open a definition previously saved in the tool. The 21 legacy integrations are retained internally for regression comparison and are not offered as user-selectable templates.
2. Analyze samples. All supplied records contribute fields. Nested objects flatten into columns. Arrays of objects with an `id` generate virtual endpoints and `nested_extractions`; other arrays stay JSON text. Unknown/mixed types are conservative TEXT and need review. Samples cannot establish complete fields, source uniqueness or production schema stability.
3. Add further endpoints using the checkbox. Review columns/types/keys in the table. Advanced schema/config fields remain available for provider-specific pagination, OAuth, transforms and reconciliation.
4. Preview stage/prod/view/procedure SQL. Existing providers with unchanged schemas use their original SQL assets. New schemas use `UnifiedSQLGenerator` without AI. Imported SQL templates use sandboxed Jinja with `integration_name`, `entities` (each entity has `name` and `fields`) and `generated_sql`. A wrapper can use `{{generated_sql}}`; a replacement can loop over entities and fields. Unknown template variables fail preview. Existing database placeholders such as `{clientID}` remain literal until execution. Imported SQL is user-authored code and must be reviewed before execution.
5. Save an immutable definition version. Secrets must be entered in runtime parameter inputs or the server environment, not embedded in advanced schema/config JSON. Normal env defaults and the historical `client_credentials` block are removed from saved config.
6. In the preparation tab, create a named saved job pinned to the reviewed integration version. Save client/organisation values and environment references for credentials, a mode and an optional repeat interval. In Saved jobs, open the detail panel and start that job. Initialize DB performs one INSERT run; normal execution uses the saved mode. Confirm DB writes explicitly. **The existing INSERT SQL contains DROP TABLE. Review it and use a dedicated destination for initial validation.**
7. Inspect status and redacted logs, or stop the job. Closing a browser tab leaves the server running. Graceful server shutdown stops workers; an unexpected server restart marks unfinished jobs interrupted. Resume is an explicit new run, not a claim of exactly-once recovery.

## Components

| Location | Responsibility / reused component |
| --- | --- |
| `run_web.py` | Waitress entry point, single-server file lock, dotenv |
| `web/app.py` | Local HTTP API and request validation |
| `web/catalog.py` | Provider listing, validation, bridge to SchemaExtractor and UnifiedSQLGenerator |
| `web/store.py` | SQLite integration versions, reusable jobs, execution history, versioned schema/config/SQL files |
| `web/job_definitions.py` | Job validation and environment references; authentication values are never persisted |
| `web/jobs.py` | Spawned worker processes, snapshots, repeat/stop, redacted logs |
| `web/templates/`, `web/static/` | Browser UI, no build step or CDN |
| `dynamic_integrations/paths.py` | Shared resolution of original or job-local runtime assets |
| `dynamic_integrations/schema_extractor.py` | Existing discovery plus offline sample-to-schema API |
| `dynamic_integrations/discovery/` | Existing CLI discovery helpers, moved out of archives |
| `dynamic_integrations/generator/` | Schema/config and SQL generation |
| `dynamic_integrations/runtime/` | Shared workflow, configured adapter, rate limit, reconciliation and child endpoints |
| `dynamic_integrations/auth/` | Authentication, token refresh and token locking |
| `dynamic_integrations/database/`, `monitoring/`, `storage/`, `reliability/` | Reused infrastructure services |
| `dynamic_integrations/compatibility/` | Historical package orchestration and provider-specific logic |
| `dynamic_integrations/etl/` | Existing extraction and transformation, including nested data |
| `reference/` | Historical examples, manual SQL and one-off scripts; not runtime |

All installed provider Python adapters remain in their original runtime package for compatibility. They are actively loaded; they cannot be deleted with the reference folder. Existing public package exports initialize lazily so opening the UI does not initialize DB clients. Registry initialization remains intact when callers request the historical package API.

Each job has a private asset snapshot and process environment. Web workers resolve runtime config values in memory without rewriting provider files. The manager prevents simultaneous jobs for the same provider/client/organisation and allows at most four jobs. Providers sharing a vendor/account quota may still need a shared limiter across processes; the existing per-integration limiter is reused, not replaced by a global quota service.

## Reliability and current limits

- Request-level rate limiting, retry and reconciliation use existing ETL behavior. The UI does not claim to verify all source data independently.
- Repeated jobs run sequential cycles. After successful INSERT, subsequent cycles use UPSERT. Failed repeated UPSERT cycles retry up to three attempts with backoff; failed INSERT is not automatically replayed. `completed_with_errors` is partial, never green success.
- Job state persists in SQLite; page-level checkpoints and automatic recovery across server crashes remain future work. API-specific incremental behavior depends on the configured provider.
- Stopping a running worker can leave partial database work. Reconcile before resuming.
- Default new-provider form supports GET, page/offset pagination and four simple auth modes. OAuth/custom request methods require compatible configuration through the advanced editor. API probing, a visual reconcile screen, schema migrations and arbitrary DB destinations are not implemented.
- When editing legacy schemas, validation may expose existing duplicate fields or provider-specific types; unchanged providers retain their original schemas/SQL. No provider migration has been assumed.

## Offline validation

```sh
python -m pytest -q tests/test_web_tool.py tests/fixes/test_simple_null_filtering.py tests/fixes/test_date_comparison_fix.py tests/unit/test_convert_data_types.py
```

Tests cover schema inference/nested contracts, original provider SQL, review/save/template paths, process spawning, duplicate-job prevention, cancellation, partial results, recurring INSERT→UPSERT and recovery metadata. Provider API calls and actual DB writes are not exercised by these tests.

## Saved jobs and runs

`GET/POST /api/saved-jobs` lists/creates reusable jobs. `GET /api/saved-jobs/<id>` returns the pinned integration definition and reviewed SQL. `POST /api/saved-jobs/<id>/run` starts a fresh worker execution; `initialize: true` selects one INSERT cycle. Optional runtime overrides are not persisted.

`GET /api/jobs` remains the run-history endpoint. Every new execution links to `saved_job_id` and records mode/interval. Existing run history is migrated additively; previously saved integration versions remain accessible. Legacy direct-run API requests remain supported, but the UI uses saved jobs.

New versions materialize `definitions/<version>/schema.json`, `config.json`, and stage/prod/view/procedure SQL under the web data directory. Workers use their own runtime snapshots. Saved jobs persist across server restarts, while interrupted executions require an explicit restart. The manager currently supports four concurrent worker processes, with a provider/client/organisation duplicate guard. This is a local process manager, not a distributed queue or cron service.

## Import API documents and multiple endpoints

Preparation now accepts OpenAPI/Swagger JSON/YAML, Postman collections with saved JSON
responses, an endpoint manifest (`base_url`, `endpoints` with `name`, `url`/`path`,
`sample`, optional `data_path`), raw JSON, or text containing explicit `GET https://...`
lines. This parser runs locally without an LLM or API calls. Only GET is supported.
OpenAPI examples are read from response media examples; schema-only definitions,
external references and arbitrary PDF/Word/prose are not converted automatically.
Missing samples and URL variables are reported for review. Raw JSON cannot reveal
an API URL: supply the URL, and review the proposed response data path.

Names proposed by document import use lowercase snake_case (max 48 characters),
with `_2`, `_3` for duplicate proposals. Nested table names follow the existing
`parent_array_field` convention; the combined schema rejects any table collision.
The existing SQL generator adds the client/organisation/integration prefixes.
Manual endpoint names and saved legacy schemas retain their original names.

Alternatively paste Tab/pipe-separated `name | /path | data.path` rows or import
an endpoint list JSON file. Upload multiple sample files named after endpoints
(e.g. `orders.json`, `customers.json`). Review/edit each row, then Analyze all
endpoints, review table columns and composite PKs, preview SQL, save the version,
and save/run a job as before. All endpoints share base URL, auth and pagination;
absolute endpoint URLs must be under the configured base URL. Different hosts
require separate integrations. Samples are used for inference and are not saved
in published versions; loading a version restores all endpoint paths and schemas.
