"""Analysis orchestration tests use a fake agent, never paid API calls."""
import copy
import json
import threading
import time

import pytest
from web.analysis import analyze, review_definition, AnalysisTasks, fetch_document
from web.catalog import infer
from dynamic_integrations.schema_extractor import SchemaExtractor
from dynamic_integrations.generator.utils import Utils


def proposal():
    d = infer({'name': 'doc_test', 'base_url': 'https://api.example.test', 'endpoints': [
        {'name': 'orders', 'path': '/orders', 'sample': [{'id': 'O1', 'lines': [{'id': 'L1'}]}]},
        {'name': 'customers', 'path': '/customers', 'sample': [{'id': 'C1'}]}]})
    return {**d, 'summary': 'Two endpoints', 'findings': [
        {'topic': 'endpoint', 'value': '/orders', 'source': 'Uploaded/pasted document', 'quote': 'GET /orders'},
        {'topic': 'rate_limit', 'value': 'unknown', 'source': 'unknown', 'quote': 'unsupported quote'}],
        'missing_information': ['Confirm rate limit']}


def test_source_analysis_and_review_do_not_persist_or_call_vendor(tmp_path):
    output = proposal()
    seen = []
    def runner(text, declared):
        seen.append((text, declared))
        return output
    result = analyze({'name': 'doc_test', 'content': 'GET /orders', 'declared': {'description': 'Orders and customers'}}, runner)
    assert seen[0][1]['integration_name'] == 'doc_test'
    assert result['findings'][0]['verified_quote'] is True
    assert result['findings'][1]['verified_quote'] is False
    assert len(result['schema']['endpoints']) == 3
    assert result['sources'][0]['characters'] == 11
    assert result['validation_errors'] == []
    assert review_definition(result)['config']['auth_type'] == 'api_key'


def test_incomplete_result_remains_reviewable():
    output = proposal()
    output['schema']['api_config']['base_url'] = ''
    result = analyze({'name': 'doc_test', 'content': 'API docs'}, lambda *_: output)
    assert result['validation_errors']
    with pytest.raises(ValueError, match='base URL'):
        review_definition(result)


def test_agent_json_parsing_and_transport_reuse(monkeypatch):
    calls = []
    def fake(prompt, **kwargs):
        calls.append((prompt, kwargs))
        return '```json\n' + json.dumps(proposal()) + '\n```'
    monkeypatch.setattr(Utils, 'run_claude_prompt', fake)
    result = SchemaExtractor().analyze_document('API documents', {'integration_name': 'doc_test'})
    assert result['config'] and result['schema']
    assert calls[0][1] == {'read_only': True}
    monkeypatch.setattr(Utils, 'run_claude_prompt', lambda *_a, **_kw: '{"schema":')
    with pytest.raises(ValueError, match='invalid JSON'):
        SchemaExtractor().analyze_document('docs', {})


def test_background_analysis_limit_and_error():
    release = threading.Event()
    tasks = AnalysisTasks(lambda data: release.wait(2) or proposal())
    ident = tasks.start({})
    assert tasks.get(ident)['status'] == 'running'
    with pytest.raises(ValueError, match='already running'):
        tasks.start({})
    release.set()
    for _ in range(100):
        if tasks.get(ident)['status'] != 'running':
            break
        time.sleep(.01)
    assert tasks.get(ident)['status'] == 'completed'


def test_reject_local_doc_urls_and_unknown_auth():
    with pytest.raises(ValueError, match='public'):
        fetch_document('http://127.0.0.1:8765/')
    with pytest.raises(ValueError, match='HTTP'):
        fetch_document('file:///etc/passwd')
    output = proposal()
    output['config']['auth_type'] = 'magic_auth'
    with pytest.raises(ValueError, match='auth'):
        review_definition(output)


def test_api_agent_transport_errors_do_not_echo_secrets(monkeypatch):
    import requests
    monkeypatch.setenv('ANTHROPIC_API_KEY', 'private-test-token')
    monkeypatch.setenv('ETL_ANALYSIS_MODEL', 'configured-model')
    calls = []
    def post(url, **kwargs):
        calls.append((url, kwargs))
        return type('Response', (), {'ok': True, 'json': lambda self: {'stop_reason': 'end_turn', 'content': [{'type': 'text', 'text': '{}'}]}})()
    monkeypatch.setattr(requests, 'post', post)
    assert Utils.run_claude_prompt('document', read_only=True) == '{}'
    assert calls[0][1]['json']['model'] == 'configured-model'
    assert 'tools' not in calls[0][1]['json']
    assert calls[0][1]['timeout'] == (15, 180)


def test_http_analysis_review_and_schema_only_sql(tmp_path, monkeypatch):
    import re
    from web.app import create_app
    from web import analysis as module
    monkeypatch.setattr(module, 'agent_status', lambda: {'ready': True})
    app = create_app(tmp_path)
    app.extensions['etl_analyses'].analyzer = lambda data: proposal()
    http = app.test_client()
    token = re.search(r'name="tool-token" content="([^"]+)"', http.get('/').text)[1]
    http.environ_base['HTTP_X_TOOL_TOKEN'] = token
    response = http.post('/api/analyses', json={'name':'doc_test','content':'GET /orders'})
    assert response.status_code == 202
    for _ in range(100):
        task = http.get('/api/analyses/' + response.json['id']).json
        if task['status'] != 'running':
            break
        time.sleep(.01)
    assert task['status'] == 'completed'
    result = task['result']
    assert http.post('/api/analysis-review', json=result).status_code == 400
    reviewed = http.post('/api/analysis-review', json={**result, 'reviewed':True})
    assert reviewed.status_code == 200
    sql = http.post('/api/preview', json=reviewed.json)
    assert sql.status_code == 200 and 'orders' in sql.json['sql']['prod']
    assert app.extensions['etl_store'].definitions() == []
    app.extensions['etl_jobs'].close()
