"""Bounded, read-only document analysis feeding the existing draft review workflow."""
import copy
import hashlib
import ipaddress
import os
import shutil
import socket
import threading
import uuid
from urllib.parse import urlparse, urljoin

from . import catalog

MAX_DOCUMENT = 200_000
# Types already dispatched by the shared AuthManager; no new auth implementation here.
RUNTIME_AUTH_TYPES = set(catalog.AUTH_TYPES) | {
    'oauth2', 'dual_key', 'dual_header_auth', 'custom_request', 'wfm_oauth2',
    'myob_oauth2', 'xero_oauth2', 'unleashed_hmac_signature', 'oauth2_custom_prefix',
    'api_key_param', 'oauth2_password_grant'}


def agent_status():
    api = bool(os.getenv('ANTHROPIC_API_KEY'))
    cli = bool(shutil.which('claude'))
    model = os.getenv('ETL_ANALYSIS_MODEL', '')
    return {'ready': bool(model) if api else cli,
            'provider': 'Claude API' if api else 'Claude CLI', 'model': model,
            'message': '' if (api and model or not api and cli) else
            'Configure ANTHROPIC_API_KEY + ETL_ANALYSIS_MODEL, or install/sign in to Claude CLI in the server environment.'}


def fetch_document(url):
    """Read public text documents only, without credentials, cookies or crawling."""
    import requests
    from bs4 import BeautifulSoup
    session = requests.Session()
    session.trust_env = False
    try:
        for _ in range(4):
            parsed = urlparse(url)
            if parsed.scheme not in ('https', 'http') or not parsed.hostname or parsed.username or parsed.password:
                raise ValueError('Documentation URL must be public HTTP(S), without credentials')
            addresses = socket.getaddrinfo(parsed.hostname, parsed.port or (443 if parsed.scheme == 'https' else 80), type=socket.SOCK_STREAM)
            if not addresses or any(not ipaddress.ip_address(entry[4][0]).is_global for entry in addresses):
                raise ValueError('Documentation URL must resolve to public addresses')
            with session.get(url, timeout=(10, 25), allow_redirects=False, stream=True) as response:
                if response.is_redirect:
                    url = urljoin(url, response.headers['Location'])
                    continue
                if not response.ok:
                    raise ValueError(f'Document fetch returned HTTP {response.status_code}; paste the document instead')
                content_type = response.headers.get('Content-Type', '').lower()
                if not any(kind in content_type for kind in ('text/', 'json', 'yaml')):
                    raise ValueError('URL must return HTML/text/JSON/YAML; paste extracted PDF/Word text instead')
                chunks, size = [], 0
                for chunk in response.iter_content(8192):
                    size += len(chunk)
                    if size > MAX_DOCUMENT * 4:
                        raise ValueError('Document too large; paste only relevant sections')
                    chunks.append(chunk)
                content = b''.join(chunks).decode('utf-8', errors='replace')
                if 'html' in content_type:
                    soup = BeautifulSoup(content, 'html.parser')
                    for node in soup(['script', 'style', 'nav', 'footer']):
                        node.decompose()
                    content = soup.get_text('\n', strip=True)
                return content
        raise ValueError('Too many documentation redirects; paste the document instead')
    except requests.RequestException as error:
        raise ValueError('Cannot fetch documentation; paste its text instead') from error
    finally:
        session.close()


def analyze(data, runner=None, fetcher=None):
    from dynamic_integrations.schema_extractor import SchemaExtractor
    name = catalog.slug(data['name'])
    content = data.get('content', '')
    urls = data.get('urls', [])
    declared = data.get('declared', {})
    if not isinstance(content, str) or not isinstance(urls, list) or len(urls) > 5 or not isinstance(declared, dict):
        raise ValueError('Supply document text, at most five documentation URLs and a declaration object')
    declared = {**declared, 'integration_name': name}
    sources = []
    if content.strip():
        sources.append(('Uploaded/pasted document', content))
    for url in urls:
        sources.append((url, (fetcher or fetch_document)(url)))
    if not sources and not declared.get('description'):
        raise ValueError('Provide documentation or describe the API in the declaration form')
    combined = '\n\n'.join(f'SOURCE: {label}\n{text}' for label, text in sources)
    import json
    if len(combined) + len(json.dumps(declared)) > MAX_DOCUMENT:
        raise ValueError('Analysis input exceeds 200,000 characters; split the documentation')
    result = (runner or SchemaExtractor().analyze_document)(combined, declared)
    schema, config = result.get('schema'), result.get('config')
    if not isinstance(schema, dict) or not isinstance(config, dict) or not isinstance(schema.get('endpoints'), list):
        raise ValueError('Agent output must contain config, schema and an endpoint list')
    result = copy.deepcopy(result)
    result['name'] = name
    result['config'] = catalog.clean_config(config)
    result['config']['integration_name'] = name
    result['schema']['integration_name'] = name.upper()
    # No validation expressions or executable code are accepted from the agent.
    result['config'].pop('env_var_validations', None)
    findings = result.get('findings', [])
    if not isinstance(findings, list) or any(not isinstance(f, dict) for f in findings):
        raise ValueError('Agent findings must be a list of evidence objects')
    evidence_text = combined + '\n' + json.dumps(declared, ensure_ascii=False)
    for finding in findings:
        quote = finding.get('quote')
        finding['verified_quote'] = isinstance(quote, str) and bool(quote.strip()) and quote in evidence_text
    missing = result.get('missing_information', [])
    if not isinstance(missing, list) or any(not isinstance(item, str) for item in missing):
        raise ValueError('Agent missing_information must be a list of questions')
    result['findings'] = findings
    result['missing_information'] = missing
    result['sources'] = [{'label': label, 'sha256': hashlib.sha256(text.encode()).hexdigest(), 'characters': len(text)} for label, text in sources]
    result['validation_errors'] = []
    try:
        review_definition(result)
    except (ValueError, TypeError, KeyError) as error:
        result['validation_errors'].append(str(error))
    return result


def review_definition(data):
    """Validate edited output before adopting it; PK review still happens next."""
    definition = {key: copy.deepcopy(data[key]) for key in ('name', 'schema', 'config')}
    if (catalog.PROVIDERS / catalog.slug(definition['name'])).exists():
        raise ValueError('Choose a new integration name; installed provider schemas cannot be overwritten')
    catalog.validate(definition, require_primary_keys=False)
    config = definition['config']
    if config.get('auth_type') not in RUNTIME_AUTH_TYPES:
        raise ValueError('Unknown auth type: add a runtime auth handler before applying this integration.')
    if not isinstance(config.get('env_vars_config'), dict) or not config['env_vars_config']:
        raise ValueError('Configure credential and client/organisation environment variable references')
    for field in config['env_vars_config'].values():
        if not isinstance(field, dict) or not isinstance(field.get('env_var'), str) or not field['env_var'].strip():
            raise ValueError('Each runtime parameter must reference a named environment variable')
    config.pop('env_var_validations', None)
    definition['config'] = catalog.clean_config(config)
    base = definition['schema']['api_config']['base_url'].rstrip('/')
    endpoints = {e['name']: e for e in definition['schema']['endpoints']}
    child_parents = {}
    for parent in endpoints.values():
        for nested in parent.get('nested_extractions', []):
            child = nested.get('table_name')
            if child not in endpoints or not endpoints[child].get('is_virtual_endpoint') or not nested.get('source_field'):
                raise ValueError(f'{parent["name"]}: invalid nested extraction target')
            if child in child_parents:
                raise ValueError(f'{child}: child table has multiple parents')
            child_parents[child] = parent['name']
    for child in child_parents:
        visited, current = set(), child
        while current in child_parents:
            if current in visited:
                raise ValueError('Nested extraction contains a cycle')
            visited.add(current)
            current = child_parents[current]
    for endpoint in definition['schema']['endpoints']:
        if endpoint.get('is_virtual_endpoint') and endpoint['name'] not in child_parents:
            raise ValueError(f'{endpoint["name"]}: virtual table has no parent')
        if endpoint.get('is_virtual_endpoint'):
            continue
        details = endpoint.get('api_details', {})
        path = details.get('path', '')
        if details.get('method', 'GET').upper() != 'GET':
            raise ValueError(f'{endpoint["name"]}: only GET is supported by this preparation flow')
        if path.startswith(base + '/'):
            path = path[len(base):]
            details['path'] = path
        if not path.startswith('/') or path.startswith('//') or '#' in path:
            raise ValueError(f'{endpoint["name"]}: enter a /path under the base URL')
        if 'exact_url' in details:
            raise ValueError('Use endpoint paths under the common base URL')
    return definition


class AnalysisTasks:
    """One analysis at a time, independent of ETL workers; no unbounded queue."""
    def __init__(self, analyzer=analyze):
        self.analyzer = analyzer
        self.lock = threading.Lock()
        self.tasks = {}

    def start(self, data):
        with self.lock:
            if any(t['status'] == 'running' for t in self.tasks.values()):
                raise ValueError('An analysis is already running; wait for its result')
            ident = uuid.uuid4().hex
            # Keep only the last 10 in-memory drafts. Never write raw docs to the repo.
            while len(self.tasks) >= 10:
                self.tasks.pop(next(iter(self.tasks)))
            self.tasks[ident] = {'id': ident, 'status': 'running'}
        def run():
            try:
                result = self.analyzer(data)
                outcome = {'status': 'completed', 'result': result}
            except (ValueError, KeyError, TypeError) as error:
                outcome = {'status': 'failed', 'error': str(error)}
            except Exception:
                outcome = {'status': 'failed', 'error': 'Analysis failed or timed out. Check agent setup and retry with a smaller document.'}
            with self.lock:
                self.tasks[ident].update(outcome)
        threading.Thread(target=run, daemon=True, name='document-analysis').start()
        return ident

    def get(self, ident):
        with self.lock:
            if ident not in self.tasks:
                raise ValueError('Analysis not found; the server may have restarted')
            return copy.deepcopy(self.tasks[ident])
