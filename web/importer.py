"""Offline discovery of reviewable endpoint drafts; never executes imported requests."""
import json
import re
from urllib.parse import urlparse


def table_name(value):
    value = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', value)
    value = re.sub(r'[^a-zA-Z0-9_]+', '_', value).strip('_').lower()
    if not value or value[0].isdigit():
        value = 'table_' + value
    return value[:48]


def data_path(sample):
    """Suggest only an unambiguous object-array location; user reviews it."""
    if isinstance(sample, list):
        return ''
    candidates = []
    def walk(value, path):
        if isinstance(value, list):
            if value and all(isinstance(item, dict) for item in value):
                candidates.append(path)
        elif isinstance(value, dict):
            for key, child in value.items():
                walk(child, f'{path}.{key}' if path else key)
    walk(sample, '')
    return candidates[0] if len(candidates) == 1 else ''


def discover(content, filename='input.json'):
    if not isinstance(content, str) or len(content) > 4_000_000:
        raise ValueError('Import must be text, up to 4 MB')
    try:
        doc = json.loads(content)
    except json.JSONDecodeError:
        doc = None
        if filename.lower().endswith(('.yaml', '.yml')) or re.match(r'\s*(openapi|swagger):', content):
            import yaml
            try:
                doc = yaml.safe_load(content)
            except yaml.YAMLError as error:
                raise ValueError('Invalid YAML document') from error
    rows, warnings, used = [], [], set()
    base = ''

    def add(name, url='', sample=None, source='', root=None):
        original = table_name(name)
        name, suffix = original, 2
        while name in used:
            name = f'{original}_{suffix}'
            suffix += 1
        used.add(name)
        row = {'name': name, 'path': url, 'data_path': root if root is not None else data_path(sample), 'source': source}
        if sample is not None:
            row['sample'] = sample
        else:
            warnings.append(f'{name}: missing response sample; add it before schema inference')
        if not url:
            warnings.append(f'{name}: missing URL/path')
        if '{' in url:
            warnings.append(f'{name}: resolve URL variables or configure parent traversal before running')
        rows.append(row)

    if isinstance(doc, dict) and ('openapi' in doc or 'swagger' in doc):
        base = (doc.get('servers') or [{}])[0].get('url', '')
        if not base and doc.get('host'):
            base = (doc.get('schemes') or ['https'])[0] + '://' + doc['host'] + doc.get('basePath', '')
        for path, methods in doc.get('paths', {}).items():
            operation = methods.get('get')
            if not isinstance(operation, dict):
                continue
            response = next((v for k,v in operation.get('responses', {}).items() if str(k).startswith('2')), {})
            media = response.get('content', {}).get('application/json', {})
            example = media.get('example')
            if example is None:
                example = next((v['value'] for v in media.get('examples', {}).values() if isinstance(v, dict) and 'value' in v), None)
            if example is None:
                example = response.get('examples', {}).get('application/json')
            if example is None:
                example = media.get('schema', {}).get('example')
            server = (operation.get('servers') or methods.get('servers') or [{}])[0].get('url')
            add(path, (server.rstrip('/') + path) if server else path, example, 'OpenAPI GET')
        warnings.append('Only GET operations imported. Schema-only definitions and external $ref are not synthesized into samples; provide real response samples.')
    elif isinstance(doc, dict) and 'item' in doc and 'info' in doc:
        def walk(items):
            for item in items:
                if 'item' in item:
                    walk(item['item'])
                    continue
                request = item.get('request', {})
                if not isinstance(request, dict) or request.get('method', 'GET').upper() != 'GET':
                    continue
                url = request.get('url', '')
                if isinstance(url, dict):
                    url = url.get('raw', '')
                sample = None
                for response in item.get('response', []):
                    if 200 <= response.get('code', 200) < 300:
                        try:
                            sample = json.loads(response.get('body', ''))
                            break
                        except (TypeError, json.JSONDecodeError):
                            pass
                add(item.get('name', url), url, sample, 'Postman GET')
        walk(doc['item'])
        warnings.append('Auth secrets and request headers were not imported. Resolve Postman variables before inference.')
    elif isinstance(doc, dict) and isinstance(doc.get('endpoints'), list):
        base = doc.get('base_url', '')
        for row in doc['endpoints']:
            add(row.get('name') or row.get('endpoint') or row.get('path', 'table'), row.get('url') or row.get('path', ''), row.get('sample'), 'Endpoint manifest', row.get('data_path'))
    elif doc is not None:
        add(filename.rsplit('.', 1)[0], sample=doc, source='Raw JSON')
    else:
        # Deliberately require explicit GET, rather than treating every link as an API.
        for url in dict.fromkeys(re.findall(r'\bGET\s+(https?://[^\s<>"\x27`]+)', content, re.I)):
            parsed = urlparse(url)
            add(parsed.path or 'records', url, source='Text: explicit GET URL')
        warnings.append('Text discovery recognizes explicit GET https://... lines only. Review URLs and attach JSON response samples; prose/PDF is not interpreted.')
    if not rows:
        raise ValueError('No supported GET endpoints found. Import OpenAPI, Postman, an endpoint manifest, raw JSON, or text containing GET URLs.')
    if not base:
        origins = {f'{urlparse(r["path"]).scheme}://{urlparse(r["path"]).netloc}' for r in rows if urlparse(r['path']).scheme in ('http', 'https')}
        if len(origins) == 1:
            base = origins.pop()
    return {'base_url': base, 'endpoints': rows, 'warnings': warnings}
