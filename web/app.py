"""HTTP routes for the local integration workbench."""
from dynamic_integrations.paths import web_data_directory
import atexit
import secrets

from flask import Flask, jsonify, render_template, request

from . import catalog
from .jobs import JobManager
from .store import Store
from .job_definitions import LITERAL_PARAMETERS, validate_job, resolve_parameters


def create_app(directory=None, manager_factory=JobManager):
    app = Flask(__name__)
    app.config['MAX_CONTENT_LENGTH'] = 5 * 1024 * 1024
    token = secrets.token_urlsafe(32)
    store = Store(directory or web_data_directory())
    jobs = manager_factory(store)
    app.extensions.update(etl_store=store, etl_jobs=jobs)
    atexit.register(jobs.close)

    @app.before_request
    def local_only():
        if request.host.split(':')[0] not in ('127.0.0.1', 'localhost'):
            return jsonify(error='Use localhost'), 403
        if request.path.startswith('/api/') and not secrets.compare_digest(request.headers.get('X-Tool-Token', ''), token):
            return jsonify(error='Reload the tool page before making requests'), 403

    @app.after_request
    def response_headers(response):
        response.headers['Cache-Control'] = 'no-store'
        response.headers['X-Content-Type-Options'] = 'nosniff'
        response.headers['Content-Security-Policy'] = "default-src 'self'; script-src 'self'; style-src 'self'; frame-ancestors 'none'; base-uri 'none'"
        return response

    @app.errorhandler(ValueError)
    @app.errorhandler(KeyError)
    @app.errorhandler(TypeError)
    def invalid(error):
        return jsonify(error=str(error)), 400

    @app.errorhandler(Exception)
    def unexpected(error):
        from werkzeug.exceptions import HTTPException
        if isinstance(error, HTTPException):
            return jsonify(error=error.description), error.code
        app.logger.exception('Tool request failed')
        return jsonify(error='Operation failed. Check the server log.'), 500

    def payload():
        data = request.get_json()
        if not isinstance(data, dict):
            raise ValueError('Expected a JSON object')
        return data

    def sql_preview(data):
        definition = catalog.validate(data)
        generated = catalog.generate_sql(definition)
        templates = data.get('templates', {})
        if set(templates) - set(catalog.SQL_TYPES):
            raise ValueError('Unknown SQL template type')
        if templates:
            from dynamic_integrations.generator.unified_sql_generator import UnifiedSQLGenerator
            generator = UnifiedSQLGenerator(definition['name'], use_llm_verification=False)
            for kind, template in templates.items():
                generated[kind] = generator.render_imported_template(template, definition['schema'], generated[kind])
        return generated

    @app.get('/')
    def index():
        return render_template('index.html', token=token)

    @app.post('/api/infer')
    def infer():
        return jsonify(catalog.infer(payload()))

    @app.post('/api/preview')
    def preview():
        return jsonify(sql=sql_preview(payload()))

    @app.get('/api/definitions')
    def definitions():
        return jsonify(store.definitions())

    @app.get('/api/definitions/<ident>')
    def definition(ident):
        return jsonify(store.definition(ident))

    @app.post('/api/definitions')
    def save():
        data = payload()
        if data.get('reviewed') is not True:
            raise ValueError('Review the schema and SQL before saving')
        # Rebuild SQL on the server, preserving the exact reviewed template inputs.
        body = {key: data[key] for key in ('name', 'schema', 'config')}
        body['config'] = catalog.clean_config(body['config'])
        body['templates'] = data.get('templates', {})
        body['sql'] = sql_preview(body)
        return jsonify(id=store.save(body)), 201

    @app.get('/api/saved-jobs')
    def saved_job_list():
        return jsonify(store.saved_jobs())

    @app.get('/api/job-parameters')
    def job_parameter_policy():
        return jsonify(literal_parameters=sorted(LITERAL_PARAMETERS))

    @app.post('/api/saved-jobs')
    def save_job():
        data = payload()
        definition = store.definition(data['definition_id'])
        return jsonify(id=store.save_job(validate_job(data, definition))), 201

    @app.get('/api/saved-jobs/<ident>')
    def saved_job_detail(ident):
        job = store.saved_job(ident)
        return jsonify(job=job, definition=store.definition(job['definition_id']))

    @app.post('/api/saved-jobs/<ident>/run')
    def run_saved_job(ident):
        data = payload()
        if data.get('confirm_write') is not True:
            raise ValueError('Confirm that this job will write to the configured database')
        job = store.saved_job(ident)
        definition = store.definition(job['definition_id'])
        parameters = resolve_parameters(job, definition, data.get('parameters', {}))
        mode = 'insert' if data.get('initialize') is True else job['mode']
        # Explicit initialization runs once. Normal execution uses the saved schedule.
        interval = 0 if data.get('initialize') is True else job['interval']
        run_id = jobs.start(definition, parameters, mode, interval, saved_job_id=ident)
        return jsonify(id=run_id, saved_job_id=ident), 202

    @app.get('/api/jobs')
    def job_list():
        jobs.reap()
        return jsonify(store.jobs())

    @app.post('/api/jobs')
    def start():
        data = payload()
        definition = store.definition(data['definition_id'])
        if data.get('confirm_write') is not True:
            raise ValueError('Confirm that this job will write to the configured database')
        ident = jobs.start(definition, data.get('parameters', {}), data.get('mode', 'upsert'), int(data.get('interval', 0)))
        return jsonify(id=ident), 202

    @app.post('/api/jobs/<ident>/stop')
    def stop(ident):
        jobs.stop(ident)
        return jsonify(status='cancelled')

    @app.get('/api/jobs/<ident>/log')
    def log(ident):
        if ident not in {row['id'] for row in store.jobs()}:
            raise ValueError('Job not found')
        path = store.directory / 'jobs' / ident / 'run.log'
        if not path.exists():
            return jsonify(text='Waiting for worker output…')
        with path.open('rb') as stream:
            stream.seek(max(0, path.stat().st_size - 64000))
            return jsonify(text=stream.read().decode('utf-8', errors='replace'))

    return app
