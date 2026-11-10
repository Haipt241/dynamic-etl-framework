#!/usr/bin/env python3
"""Run the local web tool on Windows/macOS/Linux with the same command."""
import argparse
import multiprocessing
from pathlib import Path


def main():
    from filelock import FileLock, Timeout
    from waitress import serve
    from dotenv import load_dotenv
    load_dotenv(Path(__file__).resolve().parent / ".env", override=False)
    from web.app import create_app
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=int, default=8765)
    parser.add_argument('--data-dir', type=Path, default=Path(__file__).resolve().parent / '.etl-tool')
    args = parser.parse_args()
    args.data_dir.mkdir(parents=True, exist_ok=True)
    try:
        with FileLock(str(args.data_dir / 'server.lock'), timeout=0):
            app = create_app(args.data_dir)
            print(f'Integration Workbench: http://127.0.0.1:{args.port}', flush=True)
            try:
                serve(app, host='127.0.0.1', port=args.port, threads=8)
            finally:
                app.extensions['etl_jobs'].close()
    except Timeout:
        parser.error('Another tool server already uses this data directory')


if __name__ == '__main__':
    multiprocessing.freeze_support()
    main()
