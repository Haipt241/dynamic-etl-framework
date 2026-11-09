"""
Test script to demonstrate SQL error logging functionality
"""
import os
import sys

# Set up environment
os.environ['USE_AWS_DB'] = 'True'
os.environ['AWS_ACCESS_KEY_ID'] = 'REDACTED'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'REDACTED'
os.environ['DB_Destination'] = 'EVA'
os.environ['JOB_ID'] = '999'
os.environ['JOB_RUN_ID'] = '999999'
os.environ['TRIGGER_TYPE'] = 'TEST'
os.environ['EtaniClientID'] = 'BIGOLESHOECOMPANY_CLIENT1518'
os.environ['EtaniOrganisationID'] = '5393'
os.environ['XeroTenantID'] = 'test'

# Import after setting env vars
from sql_helper import log_sql_error, SQL_ERROR_LOG_DIR
from sqlalchemy.exc import ProgrammingError
from datetime import datetime

def test_sql_error_logging():
    """Test the SQL error logging functionality"""

    print("="*80)
    print("SQL Error Logging Test")
    print("="*80)
    print(f"\nLog directory: {SQL_ERROR_LOG_DIR}")
    print(f"Environment: AWS RDS Aurora")
    print(f"Client ID: BIGOLESHOECOMPANY_CLIENT1518")
    print(f"Organization ID: 5393\n")

    # Test 1: Simulate a table not found error
    print("Test 1: Simulating table not found error...")
    try:
        raise ProgrammingError(
            statement="SELECT * FROM non_existent_table WHERE id = 1",
            params={'id': 1},
            orig=Exception("(1146, \"Table 'vibedb_BIGOLESHOECOMPANY.non_existent_table' doesn't exist\")")
        )
    except ProgrammingError as e:
        log_sql_error(
            sql_query="SELECT * FROM non_existent_table WHERE id = :id",
            error=e,
            database_name="vibedb_BIGOLESHOECOMPANY",
            params={'id': 1},
            context="test_sql_error_logging - Test 1"
        )
        print("✓ Table not found error logged")

    # Test 2: Simulate a complex INSERT query error
    print("\nTest 2: Simulating INSERT query error...")
    long_query = """
    INSERT INTO c1518_xeroblue_accounts
    (AccountID, Code, Name, Type, TaxType, Description, Class, Status,
     SystemAccount, EnablePaymentsToAccount, ShowInExpenseClaims, BankAccountNumber,
     CurrencyCode, ReportingCode, ReportingCodeName, HasAttachments, UpdatedDateUTC,
     AddToWatchlist, ValidationType, xero_tenant_id)
    VALUES
    (:param_0, :param_1, :param_2, :param_3, :param_4, :param_5, :param_6, :param_7,
     :param_8, :param_9, :param_10, :param_11, :param_12, :param_13, :param_14, :param_15,
     :param_16, :param_17, :param_18, :param_19)
    """
    try:
        raise ProgrammingError(
            statement=long_query,
            params={'table': 'c1518_xeroblue_accounts', 'rows': 150},
            orig=Exception("(1062, \"Duplicate entry '123' for key 'PRIMARY'\")")
        )
    except ProgrammingError as e:
        log_sql_error(
            sql_query=long_query,
            error=e,
            database_name="vibedb_BIGOLESHOECOMPANY",
            params={'table': 'c1518_xeroblue_accounts', 'rows': 150, 'write_mode': 'append'},
            context="LoadToEvaStageTable - accounts"
        )
        print("✓ INSERT query error logged")

    # Test 3: Simulate a stored procedure error
    print("\nTest 3: Simulating stored procedure error...")
    sp_query = "CALL sp_dynamic_xeroblue_invoices('1518', 5393, 12345)"
    try:
        raise ProgrammingError(
            statement=sp_query,
            params=None,
            orig=Exception("(1305, \"PROCEDURE vibedb_BIGOLESHOECOMPANY.sp_dynamic_xeroblue_invoices does not exist\")")
        )
    except ProgrammingError as e:
        log_sql_error(
            sql_query=sp_query,
            error=e,
            database_name="vibedb_BIGOLESHOECOMPANY",
            params=None,
            context="ExecuteEvaSP - invoices"
        )
        print("✓ Stored procedure error logged")

    # Show log file location
    log_date = datetime.now().strftime('%Y-%m-%d')
    log_filename = f"sql_errors_{log_date}.log"
    log_filepath = os.path.join(SQL_ERROR_LOG_DIR, log_filename)

    print("\n" + "="*80)
    print("Test Complete!")
    print("="*80)
    print(f"\nLog file created at:")
    print(f"  {log_filepath}")

    # Show file size
    if os.path.exists(log_filepath):
        file_size = os.path.getsize(log_filepath)
        print(f"\nLog file size: {file_size:,} bytes")

        # Show last few lines
        print("\nLast 20 lines of log file:")
        print("-"*80)
        with open(log_filepath, 'r') as f:
            lines = f.readlines()
            for line in lines[-20:]:
                print(line, end='')
    else:
        print("\n⚠ Warning: Log file not found!")

    print("\n" + "="*80)
    print("You can view the full log with:")
    print(f"  cat '{log_filepath}'")
    print("="*80)

if __name__ == "__main__":
    try:
        test_sql_error_logging()
    except Exception as e:
        print(f"\n❌ Test failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
