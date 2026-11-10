"""Reusable job configuration, separate from individual worker executions."""
import os
import re

# Only routing/time values may be persisted literally. Auth values use references.
LITERAL_PARAMETERS = {'EtaniClientID', 'EtaniClientName', 'EtaniOrganisationID',
                      'EtaniOrganisationName', 'RealmID', 'TenantID', 'FirmCode',
                      'modified_on_gte', 'modified_on_lte', 'time_from', 'time_to'}


def parameter_names(definition):
    config = definition['config']
    return set(config.get('required_env_vars', [])) | {
        field['env_var'] for field in config.get('env_vars_config', {}).values() if field.get('env_var')}


def validate_job(data, definition):
    name = str(data.get('name', '')).strip()
    mode = data.get('mode', 'upsert')
    interval = int(data.get('interval', 0))
    if not name or len(name) > 120:
        raise ValueError('Job name must contain 1–120 characters')
    if mode not in ('insert', 'upsert') or interval < 0 or (interval and interval < 10):
        raise ValueError('Mode must be insert/upsert; repeat interval must be 0 or at least 10 seconds')
    bindings = data.get('bindings', {})
    if not isinstance(bindings, dict) or set(bindings) - parameter_names(definition):
        raise ValueError('Unknown job parameters')
    clean = {}
    for key, binding in bindings.items():
        if not isinstance(binding, dict) or set(binding) not in ({'env'}, {'value'}):
            raise ValueError('Each parameter needs an environment reference or a value')
        if 'env' in binding:
            value = binding['env']
            if not isinstance(value, str) or not re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*', value):
                raise ValueError('Invalid environment reference')
            clean[key] = {'env': value}
        else:
            if key not in LITERAL_PARAMETERS:
                raise ValueError('Authentication parameters must use environment references')
            if not isinstance(binding['value'], str) or len(binding['value']) > 1000:
                raise ValueError('Invalid parameter value')
            clean[key] = {'value': binding['value']}
    return {'name': name, 'definition_id': definition['id'], 'integration_name': definition['name'], 'mode': mode,
            'interval': interval, 'bindings': clean}


def resolve_parameters(job, definition, overrides):
    if not isinstance(overrides, dict) or set(overrides) - parameter_names(definition):
        raise ValueError('Unknown runtime parameters')
    values = {}
    for key, binding in job['bindings'].items():
        if key in overrides:
            continue
        if 'value' in binding:
            values[key] = binding['value']
        else:
            value = os.getenv(binding['env'])
            if value:
                values[key] = value
            elif key in definition['config'].get('required_env_vars', []):
                raise ValueError(f'Missing environment reference: {binding["env"]}')
    for key, value in overrides.items():
        if not isinstance(value, str):
            raise ValueError('Runtime parameters must be strings')
        values[key] = value
    return values
