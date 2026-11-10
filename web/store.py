"""SQLite metadata only: immutable definitions and durable job status."""
import json
import sqlite3
import time
import uuid
from pathlib import Path


class Store:
    def __init__(self, directory):
        self.directory = Path(directory).resolve()
        self.directory.mkdir(parents=True, exist_ok=True)
        self.path = self.directory / 'tool.sqlite3'
        with self.connect() as db:
            db.executescript('''
                CREATE TABLE IF NOT EXISTS definitions (
                    id TEXT PRIMARY KEY, name TEXT NOT NULL, created REAL NOT NULL, body TEXT NOT NULL);
                CREATE TABLE IF NOT EXISTS jobs (
                    id TEXT PRIMARY KEY, definition_id TEXT NOT NULL, name TEXT NOT NULL,
                    status TEXT NOT NULL, created REAL NOT NULL, updated REAL NOT NULL,
                    body TEXT NOT NULL);
            ''')

    def connect(self):
        db = sqlite3.connect(self.path, timeout=30)
        db.row_factory = sqlite3.Row
        return db

    def save(self, body):
        ident = uuid.uuid4().hex
        with self.connect() as db:
            db.execute('INSERT INTO definitions VALUES (?,?,?,?)',
                       (ident, body['name'], time.time(), json.dumps(body)))
        return ident

    def definition(self, ident):
        with self.connect() as db:
            row = db.execute('SELECT * FROM definitions WHERE id=?', (ident,)).fetchone()
        if row is None:
            raise ValueError('Definition not found')
        return {'id': ident, **json.loads(row['body'])}

    def definitions(self):
        with self.connect() as db:
            return [dict(row) for row in db.execute('SELECT id,name,created FROM definitions ORDER BY created DESC')]

    def create_job(self, definition):
        ident = uuid.uuid4().hex
        now = time.time()
        with self.connect() as db:
            db.execute('INSERT INTO jobs VALUES (?,?,?,?,?,?,?)',
                       (ident, definition['id'], definition['name'], 'queued', now, now, '{}'))
        return ident

    def update_job(self, ident, status, **details):
        with self.connect() as db:
            db.execute('UPDATE jobs SET status=?,updated=?,body=? WHERE id=?',
                       (status, time.time(), json.dumps(details), ident))

    def jobs(self):
        with self.connect() as db:
            rows = db.execute('SELECT * FROM jobs ORDER BY created DESC LIMIT 100').fetchall()
        return [{**dict(row), 'details': json.loads(row['body']), 'body': None} for row in rows]

    def recover(self):
        with self.connect() as db:
            db.execute("UPDATE jobs SET status='interrupted',updated=? WHERE status IN ('queued','running','waiting','retrying')", (time.time(),))
