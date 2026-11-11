"""Isolated processes invoke the original workflow. No ETL implementation here."""
import contextlib
import json
import multiprocessing
import os
import shutil
import threading
import time
from pathlib import Path

from .catalog import PROVIDERS
from .store import Store


class RedactedLog:
    def __init__(self, path, parameters):
        self.path = path
        self.pending = ''
        self.secrets = sorted({str(v) for v in parameters.values() if v not in ('', None)}, key=len, reverse=True)
        self.secrets += [v for k, v in os.environ.items() if v and any(s in k.lower() for s in ('secret', 'password', 'token', 'api_key'))]

    def write(self, value):
        self.pending += value
        if '\n' in self.pending or len(self.pending) > 32768:
            self.flush()
        return len(value)

    def flush(self):
        value, self.pending = self.pending, ''
        for secret in self.secrets:
            value = value.replace(secret, '[redacted]')
        mode = 'w' if self.path.exists() and self.path.stat().st_size > 1_000_000 else 'a'
        with self.path.open(mode, encoding='utf-8') as stream:
            stream.write(value)


def run_job(directory, ident, definition, parameters, mode, interval, stop):
    parent = multiprocessing.parent_process()
    if parent is not None:
        def watch_parent():
            while parent.is_alive():
                time.sleep(2)
            os._exit(1)  # Do not leave ETL running after the controlling server disappears.
        threading.Thread(target=watch_parent, daemon=True).start()
    store = Store(directory)
    job_dir = Path(directory) / 'jobs' / ident
    job_dir.mkdir(parents=True, exist_ok=True)
    log = RedactedLog(job_dir / 'run.log', parameters)
    with contextlib.redirect_stdout(log), contextlib.redirect_stderr(log):
        try:
            name = definition['name']
            runtime = job_dir / 'runtime'
            provider = runtime / 'generated_integrations' / name
            source = PROVIDERS / name
            if source.is_dir():
                shutil.copytree(source, provider, ignore=shutil.ignore_patterns('__pycache__'))
            (provider / 'schemas').mkdir(parents=True, exist_ok=True)
            (provider / 'sql').mkdir(exist_ok=True)
            configs = runtime / 'generator' / 'config'
            configs.mkdir(parents=True)
            (configs / f'{name}_config.json').write_text(json.dumps(definition['config']))
            (provider / 'schemas' / f'{name}_schema.json').write_text(json.dumps(definition['schema']))
            for kind, sql in definition['sql'].items():
                (provider / 'sql' / f'create_{kind}_table.sql').write_text(sql)
            # Set every parameter before imports which initialize legacy DB clients.
            os.environ.update({k: str(v) for k, v in parameters.items()})
            os.environ['ETL_RUNTIME_DIR'] = str(runtime)
            os.chdir(job_dir)
            from dynamic_integrations.runtime.workflow import IntegrationWorkflowOrchestrator
            cycles, failures = 0, 0
            while not stop.is_set():
                store.update_job(ident, 'running', cycles=cycles)
                print(f'Cycle {cycles + 1}: {name} / {mode}', flush=True)
                result = IntegrationWorkflowOrchestrator(name, mode, parameters).run()
                sync = result.get('sync_result', result.get('steps', {}).get('integration_sync', {})).get('result', {})
                status = sync.get('status')
                if result.get('status') != 'success' or status not in ('completed',):
                    failures += 1
                    print('Workflow did not fully complete. See endpoint errors above.', flush=True)
                    if mode == 'insert' or not interval or failures >= 3:
                        store.update_job(ident, 'partial' if status == 'completed_with_errors' else 'failed', cycles=cycles)
                        return
                    delay = min(300, 15 * 2 ** (failures - 1))
                    store.update_job(ident, 'retrying', cycles=cycles, attempt=failures, next_run=time.time() + delay)
                    stop.wait(delay)
                    continue
                cycles += 1
                failures = 0
                if not interval:
                    store.update_job(ident, 'completed', cycles=cycles, records=sync.get('total_records_processed', 0))
                    return
                mode = 'upsert'
                store.update_job(ident, 'waiting', cycles=cycles, next_run=time.time() + interval)
                stop.wait(interval)
            store.update_job(ident, 'cancelled', cycles=cycles)
        except Exception as error:
            print(f'{type(error).__name__}: {error}', flush=True)
            store.update_job(ident, 'failed', error='Worker failed; see redacted log')
        finally:
            log.flush()
            # Runtime config may have been populated by a legacy adapter. Do not retain it.
            shutil.rmtree(job_dir / 'runtime', ignore_errors=True)


class JobManager:
    def __init__(self, store):
        self.store = store
        self.context = multiprocessing.get_context('spawn')
        self.running = {}
        self.lock = threading.RLock()
        store.recover()

    def start(self, definition, parameters, mode, interval, saved_job_id=None):
        if mode not in ('insert', 'upsert') or interval < 0 or (interval and interval < 10):
            raise ValueError('Mode must be insert/upsert; repeat interval must be 0 or at least 10 seconds')
        # Only known config inputs may become environment variables.
        allowed = set(definition['config'].get('required_env_vars', []))
        allowed.update(f.get('env_var') for f in definition['config'].get('env_vars_config', {}).values())
        if set(parameters) - allowed:
            raise ValueError('Unknown runtime parameters')
        for key in definition['config'].get('required_env_vars', []):
            if not parameters.get(key) and not os.getenv(key):
                raise ValueError(f'Missing required parameter: {key}')
        target = (definition['name'], parameters.get('EtaniClientID', os.getenv('EtaniClientID')),
                  parameters.get('EtaniOrganisationID', os.getenv('EtaniOrganisationID')))
        with self.lock:
            self.reap()
            if any(item[2] == target for item in self.running.values()):
                raise ValueError('A job is already running for this provider/client/organisation')
            if len(self.running) >= 4:
                raise ValueError('Maximum 4 simultaneous jobs; stop a job first')
            ident = self.store.create_job(definition, saved_job_id, mode, interval)
            event = self.context.Event()
            process = self.context.Process(target=run_job, args=(str(self.store.directory), ident, definition,
                                                                parameters, mode, interval, event), daemon=True)
            try:
                process.start()
            except Exception:
                self.store.update_job(ident, 'failed', error='Could not start worker')
                raise
            self.running[ident] = (process, event, target)
            return ident

    def reap(self):
        with self.lock:
            statuses = {j['id']: j['status'] for j in self.store.jobs()}
            for ident, (process, _, _) in list(self.running.items()):
                if not process.is_alive():
                    process.join()
                    if statuses.get(ident) in ('queued', 'running', 'waiting', 'retrying'):
                        self.store.update_job(ident, 'interrupted', exitcode=process.exitcode)
                    self.running.pop(ident)

    def stop(self, ident):
        with self.lock:
            item = self.running.pop(ident, None)
            if not item:
                raise ValueError('Job is not running')
            process, event, _ = item
            event.set()
            process.join(timeout=1)
            if process.is_alive():
                process.terminate()
                process.join(timeout=5)
            if process.is_alive():
                process.kill()
                process.join()
            shutil.rmtree(self.store.directory / 'jobs' / ident / 'runtime', ignore_errors=True)
            self.store.update_job(ident, 'cancelled', note='In-flight work may be partial; reconcile before resuming')

    def close(self):
        for ident in list(self.running):
            self.stop(ident)
