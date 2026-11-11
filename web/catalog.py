"""Provider discovery, draft validation and the existing SQL generator bridge."""
import copy
import json
import re
from pathlib import Path
from tempfile import TemporaryDirectory
from urllib.parse import urlparse

ROOT = Path(__file__).resolve().parents[1]
PROVIDERS = ROOT / 'dynamic_integrations' / 'generated_integrations'
CONFIGS = ROOT / 'dynamic_integrations' / 'generator' / 'config'
SQL_TYPES = ('stage', 'prod', 'view', 'procedure')
AUTH_TYPES = ('api_key', 'bearer_token', 'basic_auth', 'header_token')


def slug(value):
    if not isinstance(value, str) or not re.fullmatch(r'[a-z][a-z0-9_]{0,39}', value):
        raise ValueError('Name must use lowercase letters, numbers and underscores (max 40)')
    return value


def load_provider(name):
    name = slug(name)
    return {'name': name,
            'schema': json.loads((PROVIDERS / name / 'schemas' / f'{name}_schema.json').read_text()),
            'config': json.loads((CONFIGS / f'{name}_config.json').read_text())}


def providers():
    result = []
    for path in sorted(PROVIDERS.iterdir()):
        if not (path / 'schemas' / f'{path.name}_schema.json').exists():
            continue
        data = load_provider(path.name)
        result.append({'name': path.name, 'auth': data['config'].get('auth_type'),
                       'endpoints': len(data['schema']['endpoints'])})
    return result


def clean_config(config):
    config = copy.deepcopy(config)
    config.pop('client_credentials', None)
    for definition in config.get('env_vars_config', {}).values():
        definition['default_value'] = ''
    return config


def validate(definition, require_primary_keys=True):
    slug(definition['name'])
    schema, config = definition['schema'], definition['config']
    if not isinstance(schema, dict) or not isinstance(config, dict):
        raise ValueError('Schema and configuration must be objects')
    url = urlparse(schema.get('api_config', {}).get('base_url', ''))
    if url.scheme not in ('http', 'https') or not url.hostname or url.username:
        raise ValueError('API base URL must be an HTTP(S) URL without embedded credentials')
    endpoints = schema.get('endpoints', [])
    if not endpoints:
        raise ValueError('At least one endpoint is required')
    # Unchanged installed schemas retain their legacy contract and SQL assets.
    if (PROVIDERS / definition['name']).is_dir():
        original = load_provider(definition['name'])
        if schema == original['schema']:
            return definition
    names = set()
    for endpoint in endpoints:
        name = endpoint.get('name', '')
        if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', name) or name.lower() in names:
            raise ValueError('Endpoint names must be unique SQL identifiers')
        names.add(name.lower())
        columns = set()
        for field in endpoint.get('fields', []):
            column = field.get('db_column', '')
            if not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]{0,63}', column) or column.lower() in columns:
                raise ValueError(f'Invalid or duplicate column in {name}: {column}')
            columns.add(column.lower())
            if not re.fullmatch(r'(?:VARCHAR\(\d+\)|CHAR\(\d+\)|DECIMAL\(\d+,\s*\d+\)|INT|INTEGER|BIGINT|SMALLINT|DOUBLE|FLOAT|BOOLEAN|BOOL|TEXT|LONGTEXT|MEDIUMTEXT|DATETIME|TIMESTAMP|DATE|JSON|JSONB)', field.get('data_type', '').upper()):
                raise ValueError(f'Unsupported SQL type: {field.get("data_type")}')
        if not columns:
            raise ValueError(f'No columns defined for {name}')
        if require_primary_keys:
            keys = [field for field in endpoint['fields'] if field.get('is_primary_key')]
            if not any(f['db_column'].lower() not in ('clientid', 'organisationid') for f in keys):
                raise ValueError(f'Select a primary key for table {name} in the schema review')
            for field in keys:
                if field.get('nullable') or field.get('sample_has_nulls'):
                    raise ValueError(f'Primary key cannot be nullable: {name}.{field["db_column"]}')
                if field.get('is_json_value') or field['data_type'].upper() in ('TEXT', 'LONGTEXT', 'MEDIUMTEXT', 'JSON', 'JSONB'):
                    raise ValueError(f'Primary key needs an indexable scalar type: {name}.{field["db_column"]}')
            selected = [f['db_column'] for f in keys]
            if endpoint.get('database_schema', {}).get('primary_key') != selected:
                raise ValueError(f'Primary key metadata differs from selected columns in {name}')

    return definition


def infer(data):
    if 'endpoints' in data:
        rows = data['endpoints']
        if not isinstance(rows, list) or not rows:
            raise ValueError('Provide a non-empty endpoint list')
        combined = None
        names = set()
        base = data['base_url'].rstrip('/')
        for index, row in enumerate(rows, 1):
            try:
                if not isinstance(row, dict):
                    raise ValueError('Endpoint must be an object')
                endpoint = row.get('name') or row.get('endpoint')
                if not endpoint:
                    raise ValueError('Endpoint name is required')
                path = row.get('url') or row.get('path')
                if not isinstance(path, str) or not path.strip():
                    raise ValueError('URL/path is required')
                path = path.strip()
                if urlparse(path).scheme:
                    if not path.startswith(base + '/'):
                        raise ValueError('Endpoint URL must be under the integration base URL')
                    path = path[len(base):]
                if not path.startswith('/') or path.startswith('//') or '#' in path:
                    raise ValueError('Use a relative /path or a URL under the base URL, without fragments')
                if any(part in ('.', '..') for part in path.split('?')[0].split('/')):
                    raise ValueError('Relative traversal is not supported')
                if 'sample' not in row:
                    raise ValueError('Sample JSON is required to infer columns')
                item = {k: v for k, v in data.items() if k != 'endpoints'}
                item.update(endpoint=endpoint, path=path, sample=row['sample'],
                            data_path=row.get('data_path', ''))
                result = infer(item)
                for table in result['schema']['endpoints']:
                    if table['name'].lower() in names:
                        raise ValueError(f'Duplicate table: {table["name"]}')
                    names.add(table['name'].lower())
                if combined is None:
                    combined = result
                    # Response roots belong to individual endpoints, not the integration.
                    combined['config']['response_config'] = {}
                else:
                    combined['schema']['endpoints'].extend(result['schema']['endpoints'])
            except (ValueError, KeyError, TypeError) as error:
                raise ValueError(f'Endpoint row {index}: {error}') from error
        return validate(combined, require_primary_keys=False)
    from dynamic_integrations.schema_extractor import SchemaExtractor
    name = slug(data['name'])
    if (PROVIDERS / name).exists():
        raise ValueError('This integration name is already in use. Choose a different name.')
    sample = data['sample']
    data_path = data.get('data_path', '').strip()
    if data_path:
        for component in data_path.split('.'):
            sample = sample[component]
    records = sample if isinstance(sample, list) else [sample]
    auth = data.get('auth', 'api_key')
    if auth not in AUTH_TYPES:
        raise ValueError('For custom/OAuth auth, clone an existing provider configuration')
    endpoint = data.get('endpoint', 'Records')
    schema = SchemaExtractor().schema_from_samples(name, data['base_url'], endpoint,
                data.get('path', '/'), records, data.get('primary_key') or 'id',
                defer_primary_key=not bool(data.get('primary_key')))
    schema['endpoints'][0]['response_structure']['root_data_field'] = data_path
    schema['api_config']['authentication']['type'] = auth
    pagination = {'type': data.get('pagination', 'page'), 'limit_param': data.get('size_param', 'limit'),
                  'offset_param': data.get('page_param', 'page'), 'default_limit': int(data.get('page_size', 100))}
    schema['api_config']['pagination'] = pagination
    schema['api_config']['rate_limiting'] = {'requests_per_minute': int(data.get('rate_limit', 60)), 'burst_limit': 1}
    fields = {'etani_client_id': {'env_var': 'EtaniClientID', 'default_value': ''},
              'etani_organisation_id': {'env_var': 'EtaniOrganisationID', 'default_value': ''}}
    token = f'{name.upper()}_API_KEY'
    fields['api_key' if auth != 'bearer_token' else f'{name}_token'] = {'env_var': token, 'default_value': ''}
    if auth == 'basic_auth':
        fields['api_username'] = {'env_var': f'{name.upper()}_USERNAME', 'default_value': ''}
    config = {'integration_name': name, 'auth_type': auth,
              'auth_config': {'api_key_env_var': token, 'access_token_env_var': token,
                              'key_name': data.get('header', 'X-API-Key'), 'header_name': data.get('header', 'X-API-Key')},
              'env_vars_config': fields, 'required_env_vars': [v['env_var'] for v in fields.values()],
              'response_config': {'response_type': 'dict' if data_path else 'list', 'response_data_field': data_path},
              'rate_limiting': schema['api_config']['rate_limiting']}
    return validate({'name': name, 'schema': schema, 'config': config}, require_primary_keys=False)


def generate_sql(definition):
    from dynamic_integrations.generator.unified_sql_generator import UnifiedSQLGenerator
    validate(definition)
    if (PROVIDERS / definition['name']).is_dir() and definition['schema'] == load_provider(definition['name'])['schema']:
        return {kind: (PROVIDERS / definition['name'] / 'sql' / f'create_{kind}_table.sql').read_text()
                for kind in SQL_TYPES}
    with TemporaryDirectory() as temp:
        root = Path(temp)
        schemas = root / 'schemas'
        schemas.mkdir()
        (schemas / f'{definition["name"]}_schema.json').write_text(json.dumps(definition['schema']))
        generator = UnifiedSQLGenerator(definition['name'], use_llm_verification=False)
        result = {}
        for kind in SQL_TYPES:
            output = generator.generate_sql_type(schemas, root / 'sql', kind)
            result[kind] = Path(output).read_text()
        return result
