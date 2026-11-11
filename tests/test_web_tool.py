"""Offline acceptance checks: no provider API or production database is called."""
import json
import multiprocessing
import os
import re
import sys
import threading
import time
from pathlib import Path
from types import SimpleNamespace

import pytest

from web.app import create_app
from web.catalog import clean_config, generate_sql, infer, load_provider, providers
from web.jobs import JobManager, RedactedLog, run_job
from web.store import Store


def draft():
    return infer({'name': 'web_test', 'base_url': 'https://example.test', 'endpoint': 'Orders',
                  'data_path': 'data.items', 'sample': {'data': {'items': [
                      {'id': 'o1', 'active': True, 'customer': {'name': 'A'},
                       'lines': [{'id': 'l1', 'qty': 2}], 'tags': ['a']},
                      {'id': 'o2', 'active': False, 'later': 42, 'lines': []}
                  ]}}})


@pytest.fixture
def client(tmp_path):
    app = create_app(tmp_path)
    with app.test_client() as client:
        page = client.get('/').data.decode()
        token = re.search(r'name="tool-token" content="([^"]+)"', page).group(1)
        client.environ_base['HTTP_X_TOOL_TOKEN'] = token
        yield client, app
    app.extensions['etl_jobs'].close()


def test_sample_schema_and_nested_contract():
    value = draft()
    main, child = value['schema']['endpoints']
    fields = {field['api_name']: field for field in main['fields']}
    assert fields['active']['data_type'] == 'BOOLEAN'
    assert fields['later']['nullable'] is True
    assert fields['customer.name']['db_column'] == 'customer_name'
    assert fields['tags']['data_type'] == 'TEXT'
    assert main['nested_extractions'] == [{'table_name': 'Orders_lines', 'source_field': 'lines'}]
    assert child['is_virtual_endpoint']
    assert 'ordersId' in child['database_schema']['primary_key']
    assert main['response_structure']['root_data_field'] == 'data.items'
    sql = generate_sql(value)
    assert set(sql) == {'stage', 'prod', 'view', 'procedure'}
    assert 'orders_lines' in sql['stage']
    assert 'ordersid' in sql['stage'].lower()


@pytest.mark.parametrize('rows', [[], [1], ['invalid']])
def test_reject_unusable_samples(rows):
    with pytest.raises(ValueError):
        infer({'name': 'empty', 'base_url': 'https://example.test', 'sample': rows})


def test_all_existing_provider_assets_remain_usable():
    for provider in providers():
        value = load_provider(provider['name'])
        assert all(generate_sql(value).values())
        assert all(v['default_value'] == '' for v in clean_config(value['config']).get('env_vars_config', {}).values())
    assert len(providers()) == 21


def test_http_review_template_and_persistent_version(client):
    http, app = client
    value = draft()
    assert http.post('/api/definitions', json=value).status_code == 400
    value['templates'] = {'stage': '-- custom wrapper\n{{generated_sql}}'}
    result = http.post('/api/preview', json=value)
    assert result.status_code == 200
    assert result.json['sql']['stage'].startswith('-- custom wrapper')
    result = http.post('/api/definitions', json={**value, 'reviewed': True})
    assert result.status_code == 201
    saved = Store(app.extensions['etl_store'].directory).definition(result.json['id'])
    assert saved['sql']['stage'].startswith('-- custom wrapper')
    assert http.get('/api/definitions').json[0]['id'] == saved['id']
    value['templates']['stage'] = '{% invalid_tag %}'
    assert http.post('/api/preview', json=value).status_code == 400


def test_request_boundaries(client):
    http, _ = client
    page = http.get('/').data.decode()
    assert 'id="language"' in page
    assert 'id="provider"' not in page and 'id="load-provider"' not in page
    assert http.get('/api/providers').status_code == 404
    assert http.get('/api/providers/simpro').status_code == 404
    assert http.get('/api/providers', headers={'X-Tool-Token': ''}).status_code == 403
    assert http.get('/api/providers', headers={'Host': 'evil.example'}).status_code == 403
    assert http.post('/api/jobs', json={'definition_id': 'missing'}).status_code == 400
    assert http.get('/api/jobs/../../etc/passwd/log').status_code in (400, 404)
    value = draft()
    value['name'] = '../../outside'
    assert http.post('/api/preview', json=value).status_code == 400


def test_job_snapshot_and_partial_status(tmp_path, monkeypatch):
    store = Store(tmp_path)
    value = draft()
    value['sql'] = generate_sql(value)
    value['id'] = store.save(value)
    ident = store.create_job(value)
    observed = {}
    class Runner:
        def __init__(self, name, mode, parameters):
            from dynamic_integrations.paths import provider_config_path, provider_directory
            observed['config'] = provider_config_path(name)
            observed['schema'] = provider_directory(name) / 'schemas' / f'{name}_schema.json'
            assert observed['schema'].is_file()
            assert str(tmp_path) in str(observed['config'])
        def run(self):
            print('secret: do-not-persist')
            return {'status': 'success', 'sync_result': {'result': {'status': 'completed_with_errors'}}}
    with monkeypatch.context() as patch:
        patch.setitem(sys.modules, 'dynamic_integrations.runtime.workflow', SimpleNamespace(IntegrationWorkflowOrchestrator=Runner))
        patch.chdir(tmp_path)
        patch.setenv('ETL_RUNTIME_DIR', 'before')
        run_job(str(tmp_path), ident, value, {'WEB_TEST_API_KEY': 'do-not-persist'}, 'upsert', 0, threading.Event())
    assert store.jobs()[0]['status'] == 'partial'
    log = (tmp_path / 'jobs' / ident / 'run.log').read_text()
    assert 'do-not-persist' not in log and '[redacted]' in log
    assert not (tmp_path / 'jobs' / ident / 'runtime').exists()


def test_insert_result_and_recurring_upsert(tmp_path, monkeypatch):
    store = Store(tmp_path)
    value = draft(); value['sql'] = generate_sql(value); value['id'] = store.save(value)
    ident = store.create_job(value)
    modes = []
    class Stop:
        stopped = False
        def is_set(self): return self.stopped
        def wait(self, delay):
            if len(modes) == 2: self.stopped = True
    class Runner:
        def __init__(self, name, mode, parameters): modes.append(mode)
        def run(self):
            sync = {'result': {'status': 'completed'}}
            return {'status': 'success', 'steps': {'integration_sync': sync}} if modes[-1] == 'insert' else {'status': 'success', 'sync_result': sync}
    with monkeypatch.context() as patch:
        patch.setitem(sys.modules, 'dynamic_integrations.runtime.workflow', SimpleNamespace(IntegrationWorkflowOrchestrator=Runner))
        patch.chdir(tmp_path); patch.setenv('ETL_RUNTIME_DIR', 'before')
        run_job(str(tmp_path), ident, value, {}, 'insert', 10, Stop())
    assert modes == ['insert', 'upsert']
    assert store.jobs()[0]['details']['cycles'] == 2


def probe_worker(directory, ident, definition, parameters, mode, interval, event):
    """Real spawned process, but deliberately no ETL/network calls."""
    store = Store(directory)
    store.update_job(ident, 'running')
    event.wait(10)
    store.update_job(ident, 'completed')


def test_spawn_isolation_duplicate_guard_and_stop(tmp_path, monkeypatch):
    import web.jobs
    monkeypatch.setattr(web.jobs, 'run_job', probe_worker)
    store = Store(tmp_path)
    manager = JobManager(store)
    value = draft(); value['id'] = store.save(value)
    params = {'EtaniClientID': 'TEST_CLIENT1', 'EtaniOrganisationID': '1', 'WEB_TEST_API_KEY': 'secret'}
    try:
        first = manager.start(value, params, 'upsert', 0)
        with pytest.raises(ValueError, match='already running'):
            manager.start(value, params, 'upsert', 0)
        second = manager.start(value, {**params, 'EtaniOrganisationID': '2'}, 'upsert', 0)
        assert manager.running[first][0].pid != manager.running[second][0].pid
        manager.stop(first); manager.stop(second)
        assert {job['status'] for job in store.jobs()} == {'cancelled'}
        assert b'secret' not in store.path.read_bytes()
    finally:
        manager.close()


def test_restart_marks_unfinished_jobs(tmp_path):
    store = Store(tmp_path)
    value = draft(); value['id'] = store.save(value)
    job = store.create_job(value)
    store.update_job(job, 'running')
    manager = JobManager(store)
    assert store.jobs()[0]['status'] == 'interrupted'
    manager.close()


def test_nested_samples_flow_through_existing_transformer():
    import subprocess
    script = r'''
import sys, types, logging
fake = types.ModuleType('dynamic_integrations.database.sql_helper')
fake.__getattr__ = lambda name: (lambda *a, **k: None)
sys.modules['dynamic_integrations.database.sql_helper'] = fake
from web.catalog import infer
from dynamic_integrations.etl.data_transformation import DataTransformer
sample = {'data': {'items': [{'order_key': 0, 'customer': {'name': 'A'},
          'lines': [{'id': 'L1', 'items': [{'id': 'D1'}]}]}]}}
d = infer({'name': 'smoke', 'base_url': 'https://example.test', 'endpoint': 'Orders',
           'sample': sample, 'data_path': 'data.items', 'primary_key': 'order_key'})
integration = types.SimpleNamespace(logger=logging.getLogger('test'), config={}, error_list=[],
    integration_name='SMOKE', _load_schema=lambda:d['schema'], _extract_schema_config=lambda:{})
out = DataTransformer(integration)._parse_json(sample, 'Orders')
assert len(out) == 3
assert out['Orders'].iloc[0]['customer_name'] == 'A'
assert out['Orders_lines'].iloc[0]['ordersId'] == 0
assert out['Orders_lines_items'].iloc[0]['ordersId'] == 0
assert out['Orders_lines_items'].iloc[0]['orders_linesId'] == 'L1'
child = next(e for e in d['schema']['endpoints'] if e['name'] == 'Orders_lines_items')
assert {'ordersId', 'orders_linesId'} <= {f['api_name'] for f in child['fields']}
'''
    subprocess.run([sys.executable, '-c', script], check=True, timeout=30,
                   cwd=Path(__file__).resolve().parents[1])


def test_imported_template_can_use_existing_entity_model(client):
    http, _ = client
    value = draft()
    value['templates'] = {'stage': '{% for entity in entities %}-- {{integration_name}}.{{entity.name}}: {% for field in entity.fields %}{{field.db_column}} {% endfor %}\n{% endfor %}{{generated_sql}}'}
    result = http.post('/api/preview', json=value)
    assert result.status_code == 200
    assert '-- web_test.Orders:' in result.json['sql']['stage']
    assert 'ordersId' in result.json['sql']['stage']


def test_deferred_primary_key_and_composite_sql():
    value = infer({'name': 'composite_test', 'base_url': 'https://example.test',
                   'sample': [{'order_no': 'A', 'line_no': 1}, {'order_no': 'A', 'line_no': 2}]})
    endpoint = value['schema']['endpoints'][0]
    assert endpoint['identity_field'] is None
    with pytest.raises(ValueError, match='Select a primary key'):
        generate_sql(value)
    for field in endpoint['fields']:
        field['is_primary_key'] = field['api_name'] in ('order_no', 'line_no', 'OrganisationID')
        if field['is_primary_key']:
            field['nullable'] = False
        if field['api_name'] == 'order_no':
            field['data_type'] = 'VARCHAR(255)'
    endpoint['database_schema']['primary_key'] = [f['db_column'] for f in endpoint['fields'] if f['is_primary_key']]
    sql = generate_sql(value)
    for kind in ('stage', 'prod'):
        assert 'primary key (order_no, line_no, organisationid)' in sql[kind].lower()
    endpoint['fields'][0]['nullable'] = True
    with pytest.raises(ValueError, match='cannot be nullable'):
        generate_sql(value)


def test_nested_arrays_without_parent_identity_are_preserved():
    value = infer({'name': 'unkeyed_test', 'base_url': 'https://example.test',
                   'sample': [{'code': 'A', 'lines': [{'id': 1}]}]})
    assert len(value['schema']['endpoints']) == 1
    endpoint = value['schema']['endpoints'][0]
    assert not endpoint['nested_extractions']
    assert next(f for f in endpoint['fields'] if f['api_name'] == 'lines')['is_json_value']


def test_primary_key_rejects_known_null_and_conflicting_metadata():
    value = draft()
    endpoint = value['schema']['endpoints'][0]
    endpoint['database_schema']['primary_key'] = []
    with pytest.raises(ValueError, match='metadata differs'):
        generate_sql(value)
    endpoint['database_schema']['primary_key'] = [f['db_column'] for f in endpoint['fields'] if f['is_primary_key']]
    endpoint['fields'][0]['sample_has_nulls'] = True
    with pytest.raises(ValueError, match='cannot be nullable'):
        generate_sql(value)
