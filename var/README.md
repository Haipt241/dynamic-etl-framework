# Runtime data

Generated logs, API samples, retry failures and new web state are stored here.
Set `ETL_DATA_DIR` to choose another location. Each web worker uses its own data directory.
Existing `.etl-tool` state is still read in place to avoid moving an active SQLite database.
These files are not source code and are excluded from Git.
