"""Saved job lifecycle and real concurrent worker acceptance, without vendor/DB calls."""
import json
import re
import sqlite3

import pytest

from web.app import create_app
from web.catalog import infer, generate_sql
from web.job_definitions import validate_job, resolve_parameters
from web.jobs import JobManager
from web.store import Store


def definition(store):
    value = infer({'name': 'saved_test', 'base_url': 'https://example.test', 'endpoint': 'Orders',
                   'sample': [{'id': '1', 'amount': 10}]})
    value['sql'] = generate_sql(value)
    value['id'] = store.save(value)
    return value


def job_body(value, org='1'):
    return {'name': 'Orders '+org, 'definition_id': value['id'], 'mode': 'upsert', 'interval': 10,
            'bindings': {'EtaniClientID': {'value': 'TEST_CLIENT1'},
                         'EtaniOrganisationID': {'value': org},
                         'SAVED_TEST_API_KEY': {'env': 'VENDOR_KEY'}}}


def probe_worker(directory, ident, definition, parameters, mode, interval, event):
    store = Store(directory)
    store.update_job(ident, 'running', org=parameters['EtaniOrganisationID'])
    event.wait(15)
    store.update_job(ident, 'completed')


def test_saved_jobs_survive_restart_and_runs_are_separate(tmp_path, monkeypatch):
    import web.jobs
    monkeypatch.setattr(web.jobs, 'run_job', probe_worker)
    monkeypatch.setenv('VENDOR_KEY', 'private-credential')
    store = Store(tmp_path)
    value = definition(store)
    first = store.save_job(validate_job(job_body(value), value))
    second = store.save_job(validate_job(job_body(value, '2'), value))
    store = Store(tmp_path)
    assert len(store.saved_jobs()) == 2
    assert (tmp_path / 'definitions' / value['id'] / 'stage.sql').is_file()
    manager = JobManager(store)
    try:
        def start(ident):
            job = store.saved_job(ident)
            return manager.start(value, resolve_parameters(job, value, {}), job['mode'], job['interval'], ident)
        run1, run2 = start(first), start(second)
        assert manager.running[run1][0].pid != manager.running[run2][0].pid
        with pytest.raises(ValueError, match='already running'):
            start(first)
        manager.stop(run1)
        assert manager.running[run2][0].is_alive()
        again = start(first)
        assert again != run1
        assert {row['saved_job_id'] for row in store.jobs()} == {first, second}
        assert b'private-credential' not in store.path.read_bytes()
    finally:
        manager.close()
    assert len(Store(tmp_path).saved_jobs()) == 2


def test_saved_job_http_detail_and_initialize(tmp_path, monkeypatch):
    calls = []
    class Manager:
        def __init__(self, store): pass
        def start(self, definition, parameters, mode, interval, saved_job_id=None):
            calls.append((definition, parameters, mode, interval, saved_job_id))
            return 'run-id'
        def close(self): pass
    app = create_app(tmp_path, manager_factory=Manager)
    store = app.extensions['etl_store']; value = definition(store)
    with app.test_client() as client:
        page = client.get('/').data.decode()
        assert all(f'id="tab-{tab}"' in page for tab in ('prepare', 'saved-jobs', 'monitor'))
        client.environ_base['HTTP_X_TOOL_TOKEN'] = re.search(r'name="tool-token" content="([^"]+)"', page)[1]
        body = job_body(value)
        response = client.post('/api/saved-jobs', json=body)
        assert response.status_code == 201
        ident = response.json['id']
        assert not calls
        detail = client.get('/api/saved-jobs/'+ident).json
        assert detail['definition']['schema'] == value['schema']
        assert detail['definition']['sql'] == value['sql']
        assert client.post(f'/api/saved-jobs/{ident}/run', json={}).status_code == 400
        launch = {'confirm_write': True, 'parameters': {'SAVED_TEST_API_KEY': 'temporary-secret'}}
        assert client.post(f'/api/saved-jobs/{ident}/run', json=launch).status_code == 202
        assert calls[-1][2:] == ('upsert', 10, ident)
        assert client.post(f'/api/saved-jobs/{ident}/run', json={**launch, 'initialize': True}).status_code == 202
        assert calls[-1][2:] == ('insert', 0, ident)
        assert b'temporary-secret' not in store.path.read_bytes()
        body['bindings']['SAVED_TEST_API_KEY'] = {'value': 'never-persist'}
        assert client.post('/api/saved-jobs', json=body).status_code == 400
        assert b'never-persist' not in store.path.read_bytes()


def test_existing_run_database_migrates_without_loss(tmp_path):
    path = tmp_path / 'tool.sqlite3'
    with sqlite3.connect(path) as db:
        db.execute('CREATE TABLE jobs (id TEXT PRIMARY KEY, definition_id TEXT, name TEXT, status TEXT, created REAL, updated REAL, body TEXT)')
        db.execute("INSERT INTO jobs VALUES ('old','version','provider','completed',1,1,'{}')")
    store = Store(tmp_path)
    assert store.jobs()[0]['id'] == 'old'
    assert store.jobs()[0]['saved_job_id'] is None
    assert store.saved_jobs() == []


def test_missing_reference_does_not_silently_use_other_secret(tmp_path, monkeypatch):
    store = Store(tmp_path); value = definition(store); body = validate_job(job_body(value), value)
    monkeypatch.delenv('VENDOR_KEY', raising=False)
    with pytest.raises(ValueError, match='Missing environment reference'):
        resolve_parameters(body, value, {})
