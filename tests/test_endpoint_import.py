"""Offline multi-endpoint import and SQL regression tests."""
import json
import pytest
from web.importer import discover
from web.catalog import infer, generate_sql


def test_openapi_to_multiple_tables():
    def operation(sample):
        return {'get': {'responses': {'200': {'content': {'application/json': {'example': sample}}}}}}
    document = {'openapi': '3.0.3', 'servers': [{'url': 'https://example.test/v1'}], 'paths': {
        '/orders': operation({'data': [{'id': 'o1', 'lines': [{'id': 'l1'}]}]}),
        '/customers': operation([{'id': 'c1', 'name': 'A'}]),
        '/delete': {'delete': {}}}}
    imported = discover(json.dumps(document))
    assert [r['name'] for r in imported['endpoints']] == ['orders', 'customers']
    assert imported['endpoints'][0]['data_path'] == 'data'
    result = infer({'name': 'bulk_test', **imported})
    assert [e['name'] for e in result['schema']['endpoints']] == ['orders', 'orders_lines', 'customers']
    assert result['config']['response_config'] == {}
    sql = generate_sql(result)['prod'].lower()
    assert 'orders' in sql and 'customers' in sql and 'orders_lines' in sql


def test_postman_and_raw_do_not_invent_urls():
    result = discover(json.dumps({'info': {}, 'item': [{'name': 'Get Customers', 'request': {'method': 'GET', 'url': 'https://example.test/customers'}, 'response': [{'code': 200, 'body': '[{"id": 1}]'}]}]}))
    assert result['base_url'] == 'https://example.test'
    assert result['endpoints'][0]['name'] == 'get_customers'
    result = discover('[{"id": 1}]', 'SalesOrders.json')
    assert result['endpoints'][0]['name'] == 'sales_orders'
    assert result['endpoints'][0]['path'] == ''
    assert result['warnings']


def test_text_and_yaml_and_missing_examples():
    text = discover('See https://docs.test\nGET https://api.test/v1/orders\nGET https://api.test/v1/orders', 'api.md')
    assert len(text['endpoints']) == 1
    assert 'sample' not in text['endpoints'][0]
    yaml = discover('openapi: 3.0.3\npaths:\n  /items:\n    get:\n      responses: {}', 'api.yaml')
    assert yaml['endpoints'][0]['name'] == 'items'
    assert 'sample' not in yaml['endpoints'][0]


def test_multi_endpoint_validation_and_url_normalization():
    data = {'name': 'bulk_test', 'base_url': 'https://example.test/v1', 'endpoints': [
        {'name': 'orders', 'url': 'https://example.test/v1/orders?active=true', 'sample': [{'id': 'a'}]},
        {'name': 'customers', 'path': '/customers', 'data_path': 'result.items', 'sample': {'result': {'items': [{'id': 'b'}]}}}]}
    result = infer(data)
    assert result['schema']['endpoints'][0]['api_details']['path'] == '/orders?active=true'
    assert result['schema']['endpoints'][1]['response_structure']['root_data_field'] == 'result.items'
    data['endpoints'][1]['name'] = 'ORDERS'
    with pytest.raises(ValueError, match='Duplicate table'):
        infer(data)
    data['endpoints'][1]['name'] = 'customers'
    data['endpoints'][0]['url'] = 'https://other.test/orders'
    with pytest.raises(ValueError, match='base URL'):
        infer(data)
    del data['endpoints'][0]['sample']
    data['endpoints'][0]['url'] = '/orders'
    with pytest.raises(ValueError, match='Sample JSON'):
        infer(data)


def test_import_names_collision_and_nested_collision():
    result = discover(json.dumps({'endpoints': [{'name': 'Sales-Orders', 'path': '/a'}, {'name': 'sales_orders', 'path': '/b'}]}))
    assert [r['name'] for r in result['endpoints']] == ['sales_orders', 'sales_orders_2']
    with pytest.raises(ValueError, match='Duplicate table'):
        infer({'name': 'bulk_test', 'base_url': 'https://example.test', 'endpoints': [
            {'name': 'orders', 'path': '/orders', 'sample': [{'id': 1, 'lines': [{'id': 2}]}]},
            {'name': 'orders_lines', 'path': '/lines', 'sample': [{'id': 3}]}]})


def test_invalid_yaml_is_a_validation_error():
    with pytest.raises(ValueError, match='Invalid YAML'):
        discover('openapi: [', 'api.yaml')


def test_multi_response_roots_in_existing_transformer():
    import subprocess
    import sys
    script = '''
import types, sys, logging
fake = types.ModuleType('dynamic_integrations.database.sql_helper')
fake.__getattr__ = lambda name: (lambda *a, **k: None)
sys.modules['dynamic_integrations.database.sql_helper'] = fake
from web.catalog import infer
from dynamic_integrations.etl.data_transformation import DataTransformer
from dynamic_integrations.etl.extractors.url_builder import URLBuilder
rows = [{'name':'orders','path':'/orders?active=true','data_path':'data.items','sample':{'data':{'items':[{'id':'O1'}]}}},
        {'name':'customers','path':'/customers','data_path':'results','sample':{'results':[{'id':'C1'}]}}]
d = infer({'name':'bulk_test','base_url':'https://example.test','endpoints':rows})
i = types.SimpleNamespace(logger=logging.getLogger('test'),config={},error_list=[],integration_name='BULK_TEST',_load_schema=lambda:d['schema'],_extract_schema_config=lambda:{})
transformer=DataTransformer(i)
for row, expected in zip(rows, ['O1','C1']):
    output=transformer._parse_json(row['sample'],row['name'])
    assert output[row['name']].iloc[0]['id']==expected
builder=URLBuilder(i)
url,_=builder._build_standard_url('https://example.test','orders')
assert url=='https://example.test/orders?active=true'
d['schema']['endpoints'][0]['api_details']['date_filter']='since=2020'
url,_=builder._build_standard_url('https://example.test','orders')
assert url=='https://example.test/orders?active=true&since=2020'
'''
    subprocess.run([sys.executable, '-c', script], check=True, timeout=30)
