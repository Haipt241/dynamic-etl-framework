"""Build a static, synthetic-data UI demo; never imports local runtime state/secrets."""
import json
import shutil
import sys
from jinja2 import Template
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from web.catalog import infer, generate_sql

out = ROOT / 'docs' / 'demo'
out.mkdir(parents=True, exist_ok=True)
definition = infer({'name': 'demo_orders', 'base_url': 'https://api.example.com',
    'primary_key': 'id', 'endpoints': [
        {'name': 'orders', 'path': '/orders', 'sample': [{'id': 1001, 'status': 'paid', 'total': 149.50,
            'lines': [{'id': 1, 'sku': 'DEMO-001', 'quantity': 2}]}]},
        {'name': 'customers', 'path': '/customers', 'sample': [{'id': 42, 'name': 'Example Company', 'active': True}]}]})
definition.update(id='demo-version-001', created=1794398400, templates={})
definition['sql'] = generate_sql(definition)
(out / 'fixture.js').write_text('window.DEMO_DEFINITION = ' + json.dumps(definition) + ';\n')
for name in ('app.js', 'app.css', 'i18n.js'):
    shutil.copyfile(ROOT / 'web' / 'static' / name, out / name)
html = Template((ROOT / 'web' / 'templates' / 'index.html').read_text()).render(token='static-demo')
html = html.replace('{{ token }}', 'static-demo').replace('/static/', './')
html = html.replace('<script defer src="./app.js">', '<script defer src="./fixture.js"></script><script defer src="./demo.js"></script><script defer src="./app.js">')
html = html.replace('<main>', '<main><div class="demo-banner"><strong>INTERACTIVE DEMO · synthetic data only</strong><p>Open the demo version to review tables and SQL, or select a saved job and simulate a run. No API, AI or database connections. Each simulated run completes one example cycle. Changes reset on reload. Do not enter credentials.</p><a href="../index.html">Product tour & screenshots</a></div>')
html = html.replace('href="/"', 'href="./index.html"')
html = html.replace('LOCAL TOOL', 'STATIC DEMO').replace('Local workspace', 'Demo workspace')
app_js = (out / 'app.js').read_text().replace('Job đã khởi động trong tiến trình riêng.', 'SIMULATION: one example cycle started; no real worker or database connection.')
(out / 'app.js').write_text(app_js)
html = html.replace('</head>', '<link rel="stylesheet" href="./demo.css"></head>')
(out / 'index.html').write_text(html)
print('Built synthetic demo:', out)
