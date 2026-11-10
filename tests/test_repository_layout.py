"""Offline regression for moved modules and isolated runtime data."""
import os
from pathlib import Path
import subprocess
import sys

from dynamic_integrations.paths import data_directory

ROOT = Path(__file__).resolve().parents[1]


def test_cli_and_installed_provider_compatibility():
    result = subprocess.run([sys.executable, 'tests/support/layout_regression.py'],
                            cwd=ROOT, capture_output=True, text=True, timeout=60)
    assert result.returncode == 0, result.stdout + result.stderr
    assert 'Generated providers imported and assets validated: 21' in result.stdout


def test_data_paths_are_isolated(monkeypatch, tmp_path):
    monkeypatch.delenv('ETL_DATA_DIR', raising=False)
    monkeypatch.delenv('ETL_RUNTIME_DIR', raising=False)
    assert data_directory('logs') == ROOT / 'var' / 'logs'
    monkeypatch.setenv('ETL_RUNTIME_DIR', str(tmp_path / 'job' / 'runtime'))
    assert data_directory('json') == tmp_path / 'job' / 'data' / 'json'
    monkeypatch.setenv('ETL_DATA_DIR', str(tmp_path / 'custom'))
    assert data_directory('logs') == tmp_path / 'custom' / 'logs'


def test_value_conversions_do_not_initialize_database():
    result = subprocess.run([sys.executable, '-c',
        'import sys; from dynamic_integrations.etl.value_utils import ConvertDataTypes; '
        'assert "dynamic_integrations.database.sql_helper" not in sys.modules'],
        cwd=ROOT, capture_output=True, text=True, timeout=30)
    assert result.returncode == 0, result.stderr
