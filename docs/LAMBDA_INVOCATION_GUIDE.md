# Lambda Invocation Guide - Database-Driven Parameter Fetching

## Overview

The ETL container now supports **database-driven parameter fetching**, enabling Lambda to spawn ECS tasks with minimal parameters (just `org_id`). The container queries the database to determine:

1. Which integration to run (based on `service_id` mapping)
2. Client identification (`EtaniClientID`, `client_id`, `firm_id`)
3. Integration credentials (API keys, tokens, refresh tokens, etc.)
4. All other integration-specific parameters

This eliminates the need for Lambda to know about integration-specific parameters, simplifying scheduling logic.

---

## Architecture

### Old Pattern (Manual Parameters)
```
Lambda → ECS Task
  ↓
  Environment Variables:
    - EtaniClientID=DOUGLASINNOVATION_CLIENT2022
    - EtaniOrganisationID=7102
    - tidywork_api_key=xxx
    - tidywork_domain=yyy
    - (many more...)
```

### New Pattern (Database-Driven)
```
Lambda → ECS Task
  ↓
  Environment Variables:
    - EtaniOrganisationID=7102  (ONLY THIS!)

Container queries vibedb_cms.client_service:
  - Fetches service_id=62 → maps to integration=tidywork
  - Fetches client_id, firm_id, firm_code
  - Builds EtaniClientID=DOUGLASINNOVATION_CLIENT2022
  - Extracts credentials from apiConnectionInfo JSON field
  - Runs tidywork integration with full parameter set
```

---

## Lambda Query Pattern

Lambda should query `vibedb_cms.client_service` to find active integrations:

```sql
SELECT
    cs.id as org_id,
    cs.Service as service_id,
    cs.Status as status
FROM vibedb_cms.client_service cs
INNER JOIN vibedb_cms.accountingfirm af ON cs.AccountingFirm = af.id
WHERE cs.Status IN (1, 9, 12)           -- Active, Provisioning, Updating
    AND af.database = 'AWS'              -- Only AWS-based clients
    AND cs.Service IN (4, 8, 14, 16, 17, ...) -- Dynamic integration service IDs
ORDER BY cs.id;
```

For each matching record, Lambda spawns an ECS task with:
- `EtaniOrganisationID={org_id}`
- Mode: `upsert` (for incremental syncs)

---

## Local Testing

### Test Parameter Fetcher
```powershell
$env:USE_AWS_DB="True"; python test_org_fetcher.py
```

### Run Integration with --org-id
```powershell
# TidyWork (service_id=62, org_id=7102)
$env:USE_AWS_DB="True"; python run_dynamic_integration.py --org-id 7102 --mode upsert

# QBO (service_id=4)
$env:USE_AWS_DB="True"; python run_dynamic_integration.py --org-id 7035 --mode upsert

# FYI (service_id=72)
$env:USE_AWS_DB="True"; python run_dynamic_integration.py --org-id 2951 --mode upsert
```

### Traditional Method (Still Supported)
```powershell
# Explicit parameters (old way)
$env:USE_AWS_DB="True"; python run_dynamic_integration.py --integration tidywork --mode upsert `
  --param EtaniClientID=DOUGLASINNOVATION_CLIENT2022 `
  --param EtaniOrganisationID=7102 `
  --param tidywork_api_key=xxx `
  --param tidywork_domain=yyy
```

---

## ECS Task Definition (Container Override)

When Lambda spawns an ECS task, use container overrides:

```python
import boto3
import json

ecs = boto3.client('ecs', region_name='ap-southeast-2')

response = ecs.run_task(
    cluster='etl-cluster',
    taskDefinition='etl-dynamic-worker:latest',
    launchType='FARGATE',
    networkConfiguration={
        'awsvpcConfiguration': {
            'subnets': ['subnet-xxx'],
            'securityGroups': ['sg-xxx'],
            'assignPublicIp': 'ENABLED'
        }
    },
    overrides={
        'containerOverrides': [
            {
                'name': 'etl-dynamic-worker',
                'command': [
                    'python',
                    'run_dynamic_integration.py',
                    '--org-id', '7102',
                    '--mode', 'upsert'
                ],
                'environment': [
                    {'name': 'USE_AWS_DB', 'value': 'True'},
                    {'name': 'EtaniOrganisationID', 'value': '7102'}
                ]
            }
        ]
    }
)
```

---

## Service ID → Integration Mapping

The container uses this mapping to determine which integration to run:

| Service ID | Integration Name | Description |
|------------|------------------|-------------|
| 1 | xeroblue | Xero Blue |
| 2 | myob | MYOB AccountRight |
| 4 | qbo | QuickBooks Online |
| 7 | dq_myobar | MYOB Business |
| 8 | jobman | JobMan (if implemented) |
| 9 | hubspot | HubSpot CRM |
| 14 | cin7_dear | Cin7 DEAR Inventory |
| 16 | simpro | SimPro |
| 17 | unleashed | Unleashed |
| 21 | payroll_au | Xero Payroll AU/NZ |
| 23 | deputy | Deputy |
| 25 | xeroproject | Xero Projects |
| 27 | cin7 | Cin7 |
| 38 | shopify | Shopify |
| 43 | vinsight | Vinsight |
| 50 | karbon_hq | Karbon |
| 57 | keypay | KeyPay |
| 62 | tidywork | TidyWork |
| 69 | wfm | WorkflowMax |
| 71 | myob_detailed | MYOB Detailed |
| 72 | fyi | FYI Elite |

*Note: Add new integrations to `dynamic_integrations/org_parameter_fetcher.py:SERVICE_TO_INTEGRATION`*

---

## apiConnectionInfo JSON Structure

**IMPORTANT:** JSON keys MUST match config file keys exactly (no pattern matching).

Credentials are stored in `vibedb_cms.client_service.apiConnectionInfo` as JSON:

### TidyWork (service_id=62)
```json
{
  "tidywork_api_key": "REDACTED",
  "tidywork_domain": "douglasinnovation.tidywork.com.au"
}
```

### FYI (service_id=72)
```json
{
  "access_id": "xxxxxxxxxxxxx",
  "access_secret": "xxxxxxxxxxxxx"
}
```

### QuickBooks Online (service_id=4)
```json
{
  "realm_id": "123456789",
  "refresh_token": "REDACTED"
}
```

### Xero (service_id=1)
```json
{
  "xero_tenant_id": "865512af-e7d8-4d42-8568-73084279eb43",
  "refresh_token": "xxxxxxxxxxxxx"
}
```

### Karbon (service_id=50)
```json
{
  "access_key": "xxxxxxxxxxxxx",
  "bearer": "xxxxxxxxxxxxx"
}
```

*Note: JSON keys must EXACTLY match the keys in `{integration}_config.json` env_vars_config section. See [DATABASE_PARAMETER_SETUP.md](DATABASE_PARAMETER_SETUP.md) for complete list.*

---

## Status Validation

The container validates organization status before running:

| Status | Name | Action |
|--------|------|--------|
| 1 | Active | ✅ Allow (UPSERT mode) |
| 9 | Provisioning New Data | ✅ Allow (INSERT mode) |
| 12 | Updating Data | ✅ Allow (UPSERT mode) |
| 13 | Disconnected | ❌ Reject |
| 16 | Resetting Data | ⚠️  Require `Reset_Mode=true` |

---

## Lambda Example (Python)

Complete Lambda function to schedule dynamic integrations:

```python
import boto3
import json
from datetime import datetime

def lambda_handler(event, context):
    """
    Lambda function to schedule dynamic ETL integrations

    Trigger:
        - EventBridge cron (hourly)
        - Manual invocation with filters

    Event Format:
        {
            "integration_types": ["dynamic"],
            "service_ids": [62, 72, 50],  # Optional filter
            "org_ids": [7102, 2951]       # Optional filter
        }
    """

    rds_data = boto3.client('rds-data', region_name='ap-southeast-2')
    ecs = boto3.client('ecs', region_name='ap-southeast-2')

    # Extract filters from event
    service_ids = event.get('service_ids', [])
    org_ids = event.get('org_ids', [])

    # Build query to find active integrations
    query = """
        SELECT
            cs.id as org_id,
            cs.Service as service_id,
            cs.Status as status
        FROM vibedb_cms.client_service cs
        INNER JOIN vibedb_cms.accountingfirm af ON cs.AccountingFirm = af.id
        WHERE cs.Status IN (1, 9, 12)
            AND af.database = 'AWS'
    """

    # Add filters if provided
    if service_ids:
        query += f" AND cs.Service IN ({','.join(map(str, service_ids))})"
    if org_ids:
        query += f" AND cs.id IN ({','.join(map(str, org_ids))})"

    query += " ORDER BY cs.id"

    # Execute query
    response = rds_data.execute_statement(
        resourceArn='arn:aws:rds:ap-southeast-2:870551425938:cluster:vibecfo-db-cluster',
        secretArn='arn:aws:secretsmanager:ap-southeast-2:870551425938:secret:rds!cluster-e715bbba-8b9f-43d1-8820-0f1b72fda546',
        database='vibedb_cms',
        sql=query
    )

    # Process results and spawn ECS tasks
    tasks_spawned = []

    for record in response['records']:
        org_id = record[0]['longValue']
        service_id = record[1]['longValue']
        status = record[2]['longValue']

        print(f"Spawning task for org_id={org_id}, service_id={service_id}, status={status}")

        # Spawn ECS task
        ecs_response = ecs.run_task(
            cluster='etl-cluster',
            taskDefinition='etl-dynamic-worker:latest',
            launchType='FARGATE',
            networkConfiguration={
                'awsvpcConfiguration': {
                    'subnets': ['subnet-xxx'],
                    'securityGroups': ['sg-xxx'],
                    'assignPublicIp': 'ENABLED'
                }
            },
            overrides={
                'containerOverrides': [
                    {
                        'name': 'etl-dynamic-worker',
                        'command': [
                            'python',
                            'run_dynamic_integration.py',
                            '--org-id', str(org_id),
                            '--mode', 'insert' if status == 9 else 'upsert'
                        ],
                        'environment': [
                            {'name': 'USE_AWS_DB', 'value': 'True'},
                            {'name': 'EtaniOrganisationID', 'value': str(org_id)}
                        ]
                    }
                ]
            }
        )

        tasks_spawned.append({
            'org_id': org_id,
            'service_id': service_id,
            'task_arn': ecs_response['tasks'][0]['taskArn']
        })

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': f'Spawned {len(tasks_spawned)} ECS tasks',
            'tasks': tasks_spawned,
            'timestamp': datetime.now().isoformat()
        })
    }
```

### Lambda Invocation Examples

```python
import boto3
import json

lambda_client = boto3.client('lambda', region_name='ap-southeast-2')

# Fire all dynamic integrations
lambda_client.invoke(
    FunctionName='etl-unified-scheduler',
    InvocationType='Event',
    Payload=json.dumps({
        'integration_types': ['dynamic']
    })
)

# Fire specific org
lambda_client.invoke(
    FunctionName='etl-unified-scheduler',
    InvocationType='Event',
    Payload=json.dumps({
        'integration_types': ['dynamic'],
        'org_ids': [7102]
    })
)

# Fire specific service types (e.g., FYI only)
lambda_client.invoke(
    FunctionName='etl-unified-scheduler',
    InvocationType='Event',
    Payload=json.dumps({
        'integration_types': ['dynamic'],
        'service_ids': [72]
    })
)
```

### One-Liner Lambda Invocations (for testing)

```python
# Fire all dynamic integrations
python -c "import boto3,json; boto3.client('lambda',region_name='ap-southeast-2').invoke(FunctionName='etl-unified-scheduler',InvocationType='Event',Payload=json.dumps({'integration_types':['dynamic']}))"

# Fire specific org
python -c "import boto3,json; boto3.client('lambda',region_name='ap-southeast-2').invoke(FunctionName='etl-unified-scheduler',InvocationType='Event',Payload=json.dumps({'integration_types':['dynamic'],'org_ids':[7102]}))"

# Fire specific service (FYI only)
python -c "import boto3,json; boto3.client('lambda',region_name='ap-southeast-2').invoke(FunctionName='etl-unified-scheduler',InvocationType='Event',Payload=json.dumps({'integration_types':['dynamic'],'service_ids':[72]}))"
```

---

## Benefits

### For Lambda
- **Simpler logic**: No need to know integration-specific parameters
- **Fewer environment variables**: Only pass `org_id`
- **Easier maintenance**: Adding new integrations doesn't require Lambda updates
- **Reduced payload size**: Smaller task definitions

### For Container
- **Single source of truth**: All parameters in database
- **Consistent parameter naming**: Integration-specific extraction logic
- **Easier debugging**: All parameters logged at startup
- **Centralized credential management**: Update credentials in CMS, not in code

### For Operations
- **Easier credential rotation**: Update `apiConnectionInfo` in database
- **Better auditability**: Track which org ran which integration
- **Simplified scheduling**: Lambda queries database for active integrations
- **Reduced coupling**: Lambda doesn't need to understand integration requirements

---

## Migration Path

### Phase 1: Dual Support (Current)
- Both `--org-id` and explicit `--param` modes work
- Lambda can use either pattern
- Existing scripts continue working

### Phase 2: Populate apiConnectionInfo
- Migrate existing credentials to `apiConnectionInfo` JSON field
- Test with `test_org_fetcher.py` for each integration
- Verify parameter extraction logic

### Phase 3: Lambda Cutover
- Update Lambda to use `--org-id` pattern
- Remove integration-specific parameter logic from Lambda
- Monitor logs for missing credentials

### Phase 4: Deprecate Explicit Params (Future)
- Remove `--param` support after all integrations migrated
- Enforce database-driven pattern
- Simplify run_dynamic_integration.py

---

## Troubleshooting

### Error: "No active client_service record found"
- Check `vibedb_cms.client_service` has record with `id={org_id}`
- Verify `Status IN (1, 9, 12)`
- Check `accountingfirm.database = 'AWS'`

### Error: "Unknown service_id=X"
- Add mapping to `org_parameter_fetcher.py:SERVICE_TO_INTEGRATION`
- Ensure integration name matches generated integration directory

### Error: "Missing integration-specific parameters"
- Check `apiConnectionInfo` JSON field has required credentials
- Add extraction logic to `_extract_integration_params()` if new integration
- Test with `test_org_fetcher.py`

### Warning: "Organization status is X (expected 1, 9, or 12)"
- Status 13 (Disconnected): Integration will not run
- Status 16 (Resetting): Requires `Reset_Mode=true` environment variable
- Update status in CMS before running integration

---

## Adding New Integrations

1. **Add service mapping** in `org_parameter_fetcher.py`:
   ```python
   SERVICE_TO_INTEGRATION = {
       ...
       99: 'new_integration',
   }
   ```

2. **Add parameter extraction** in `_extract_integration_params()`:
   ```python
   elif integration_name == 'new_integration':
       params['api_key'] = connection_data.get('apiKey', '')
       params['domain'] = connection_data.get('domain', '')
   ```

3. **Test locally**:
   ```powershell
   $env:USE_AWS_DB="True"; python test_org_fetcher.py
   ```

4. **Update CMS** with credentials:
   ```sql
   UPDATE vibedb_cms.client_service
   SET apiConnectionInfo = '{"apiKey": "xxx", "domain": "yyy"}'
   WHERE id = {org_id};
   ```

5. **Run integration**:
   ```powershell
   $env:USE_AWS_DB="True"; python run_dynamic_integration.py --org-id {org_id} --mode upsert
   ```

---

## See Also

- [DYNAMIC_INTEGRATION_SETUP_GUIDE.md](DYNAMIC_INTEGRATION_SETUP_GUIDE.md) - Setting up new integrations
- [RUN_DYNAMIC_INTEGRATION_GUIDE.md](RUN_DYNAMIC_INTEGRATION_GUIDE.md) - Running integrations
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Deploying to AWS
