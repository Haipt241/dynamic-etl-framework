from azure.storage.fileshare import ShareFileClient
from datetime import datetime, timezone
import json, re, math
import requests
import base64
import pandas as pd
import pyodbc
import urllib.parse
import config
import time
import pymysql
import concurrent.futures
import os
import logging
import sys, uuid
from decimal import Decimal, InvalidOperation
from filelock import FileLock
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError, ProgrammingError, OperationalError
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type
from typing import Set, Dict

from sql_helper import eva_engine, cms_engine, LoggingDetails, update_container_logs, ExecuteEvaSP, ExecuteCMSSP, ReadMySQLTable, get_firm_id, LoadToEvaStageTable, USE_AWS_DB, query_client, submit_query_logs, start_container_log, complete_container_log, CONTAINER_LOG_ID

import sql_object_scripts as sqlobj
# Query monitoring client is initialized in sql_helper

#forcing print statements to display in docker 
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    stream=sys.stdout  # Logs to stdout
)
logger = logging.getLogger(__name__)
logging.info("Logging to stdout")




# Xero API Details
client_id = config.XERO_CLIENT_ID
client_secret = config.XERO_CLIENT_SECRET

# Database Connection Details
server = config.SQL_SERVER_NAME
database = config.SQL_SERVER_DATABASE
username = config.SQL_SERVER_USERNAME
password = config.SQL_SERVER_PASSWORD 
#  Azure File Share Details
StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName= config.FILE_SHARE_NAME
BlobContainerName= config.BLOB_CONTAINER_NAME

# DB_Destination = os.getenv('DB_Destination')
# # print(f"DB_Destination: {DB_Destination}")
# JOB_ID = os.getenv('JOB_ID')
# JOB_RUN_ID = os.getenv('JOB_RUN_ID')
# TRIGGER_TYPE = os.getenv('TRIGGER_TYPE')
# # Org Integration Details
# EtaniClientID = os.getenv('EtaniClientID')
# EtaniOrganisationID = os.getenv('EtaniOrganisationID')
# XeroTenantID = os.getenv('XeroTenantID')

LegacyOrganisationID = 0
log_id = str(uuid.uuid1())
FirmId = 0

# Query monitoring client is imported from sql_helper

DB_Destination = 'EVA'
JOB_ID = 1
JOB_RUN_ID = 0
TRIGGER_TYPE = 'RECONCILIATION'
# Org Integration Details



#lock = FileLock(f"{TokenFileName}.lock")


#make executor global/shared to handle concurrent calls
executor = concurrent.futures.ThreadPoolExecutor(max_workers=30) 
error_list = []

class XeroRequestsManager:
    def __init__(self, endpoint, params=None, if_modified_since=None, id=None):
        self.endpoint = endpoint
        self.params = params
        self.if_modified_since = if_modified_since
        self.id = id
        self.data = None

    def __enter__(self):
        self.data = XeroRequests(self.endpoint, self.params, self.if_modified_since, self.id)
        return self.data

    def __exit__(self, exc_type, exc_value, traceback):
        print("Cleaning up DataFrame")
        del self.data
        return False  # Propagate any exceptions

class XeroAPI:
    def __init__(self):
        self.api_calls = 0
        self.last_reset = time.time()

    def xero_requests(self, endpoint, params=None, if_modified_since=None, id=None):
        TaskName = "xero_requests"
        current_time = time.time()
        if current_time - self.last_reset >= 60:
            self.api_calls = 0
            self.last_reset = current_time
            time.sleep(0.5) #sleep for 0.5 seconds to avoid rate limiting

        if self.api_calls >= 60:
            time.sleep(60 - (current_time - self.last_reset))
            self.api_calls = 0
            self.last_reset = time.time()

        self.api_calls += 1

        ReportAPI = {
            'BalanceSheet', 'BankStatement', 'BankSummary', 'TrialBalance', 'BudgetSummary', 'ExecutiveSummary', 'ProfitAndLoss'
        }

        # Make the API call
        #lock the file to avoid race conditions in multi process calls
        with lock:
            OldToken = GetTokenFromFile(TokenFileName)
            NewToken = GetNewToken(OldToken[1])
            if isinstance(NewToken[0], dict) and NewToken[0].get('error') == 'invalid_grant': 
                ExecuteCMSSP(f"Update client_service SET status = 13 where Id = {EtaniOrganisationID}", "client_service", error_list, True)
                params = {
                    "p_integration": "XEROBLUE",
                    "p_organisation_id": EtaniOrganisationID,
                    "p_client_id": ClientIdNumber,
                    "p_firm_id": FirmId,
                    "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_status": "Failed",
                    "p_log_id": log_id,
                    "p_remarks": "Invalid Grant or Token" if "Invalid Grant or Token" else f"Endpoint: {endpoint}"
                }
                update_container_logs(params)
            
            
        xero_tenant_id = XeroTenantID
        if endpoint in ReportAPI:
            get_url = 'https://api.xero.com/api.xro/2.0/Reports/' + endpoint
        else:
            get_url = 'https://api.xero.com/api.xro/2.0/' + endpoint
        if id:
            get_url += '/' + id
        if params:
            get_url += '?' + urllib.parse.urlencode(params)

        LoggingDetails(TaskName, f"{endpoint} - Get API Response from : {get_url}", JOB_ID, JOB_RUN_ID, error_list)
        
        headers = {
                    'Authorization': 'REDACTED' + NewToken[0],
                    'Xero-tenant-id': xero_tenant_id,
                    'Accept': 'application/json'
                }
        
        #print(f"Xero Request headers : {headers}")        

        # Add "If-Modified-Since" header if provided
        if if_modified_since:
            headers['If-Modified-Since'] = if_modified_since

        try:
            response = requests.get(get_url, headers=headers, timeout=900)  # Set timeout here
            print(response.headers)
            response.raise_for_status()  # Raise an error for HTTP codes 4xx/5xx
            json_response = response.json()
            with open(f'json/{TablePrefixEVA}_{endpoint.replace("/", "_")}_response.json', 'w+') as outfile:
                json.dump(json_response, outfile)
            if endpoint in ReportAPI:
                XeroData = pd.DataFrame(json_response['Reports'])
            else:
                XeroData = pd.DataFrame(json_response[endpoint])
        except requests.exceptions.Timeout:
            LoggingDetails(TaskName, "Request timed out.", JOB_ID, JOB_RUN_ID, error_list)
            error_list.append("API Request Timeout")
            raise
        except requests.exceptions.RequestException as e:
            LoggingDetails(TaskName, f"Request failed: {e}", JOB_ID, JOB_RUN_ID, error_list)
            error_list.append("API Request Failed")
            raise
        

        #LoggingDetails(TaskName, f"{endpoint} - Saved API Response: {len(XeroData)}")
        
        return XeroData

xero_api = XeroAPI()


    
def GetTokenFromFile(TokenFileName):

    # Azure File Share connection settings
    storage_account_name = StorageAccountName
    storate_account_key = StorageAccessKey
    file_share_name = FileShareName

    # Create a ShareFileClient object
    share_file_client = ShareFileClient.from_connection_string(
        f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storate_account_key};BlobEndpoint=https://{storage_account_name}.file.core.windows.net/",
        file_share_name,
        TokenFileName
    )

    # Get a file stream
    downloader = share_file_client.download_file()

    # Read the file contents from the stream
    file_contents = downloader.readall().decode('utf-8')
    open(f'token/{TokenFileName.replace(".txt", "_old.txt")}', 'w+').write(file_contents)

    # Parse the file contents as JSON
    json_response = json.loads(file_contents)

    return [json_response['access_token'], json_response['refresh_token'], json_response['refresh_token']]

def GetNewToken(refresh_token):
    TaskName = 'GetNewToken'
    #print("Request New Access Token using Refresh Token")

    b64_id_secret = base64.b64encode(bytes(client_id + ':' + client_secret, 'utf-8')).decode('utf-8')
    token_refresh_url = 'https://identity.xero.com/connect/token'
    response = requests.post(token_refresh_url,
                            headers = {
                                'Authorization' : 'REDACTED' + b64_id_secret,
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            data = {
                                'grant_type' : 'refresh_token',
                                'refresh_token' : refresh_token
                            })
    json_response = response.json()
    open(f'token/{TokenFileName.replace(".txt", "_new.txt")}', 'w+').write(json.dumps(json_response))
    status_code = response.status_code

    # Azure File Share connection settings
    storage_account_name = StorageAccountName
    storate_account_key = StorageAccessKey
    file_share_name = FileShareName

    #LoggingDetails(TaskName, f"{endpoint} - Request New Access Token using Refresh Token - Status Code: {status_code}")
    if status_code == 200:
        # Write the new token to the Azure File Share
        token_file_name = TokenFileName
        share_file_client = ShareFileClient.from_connection_string(
            f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storate_account_key};BlobEndpoint=https://{storage_account_name}.file.core.windows.net/",
            file_share_name,
            token_file_name
        )
        data = json.dumps(json_response).encode('utf-8')
        share_file_client.upload_file(data)

        return [json_response['access_token'], json_response['refresh_token']]
    else:
        return json_response, "error"

def XeroRequests(endpoint, params=None, if_modified_since=None, id=None):
    return xero_api.xero_requests(endpoint, params, if_modified_since, id)

def safe_datetime_conversion(x):
    try:
         # Handle None, NaN, or equivalent invalid values
        if pd.isna(x) or str(x).strip().lower() in ('nan', 'none', 'null', ''):
            return None  

        x = str(x)  # Ensure it's a string before regex check
        if re.search(r'\((\d+)', x):  # Check for JSON date format like "/Date(1625097600000)/"
            timestamp = int(re.search(r'\((\d+)', x).group(1)) / 1000
            return pd.to_datetime(timestamp, unit='s', errors='coerce')

        # Ensure x is a valid date string before conversion
        if re.match(r'^\d{4}-\d{2}-\d{2}', x) or "T" in x:  # Check for YYYY-MM-DD format
            return pd.to_datetime(x, errors='coerce', utc=True)

        return x  # If not a date, return original value
    except Exception:
        return None  # Return None for problematic values

def ConvertDataTypes(df, endpoint):
    TaskName = "ConvertDataTypes"
    #LoggingDetails(TaskName, f"{endpoint} - Converting Data Types to Match Stage Table")
    
    for col in df.columns:
        #print(df[col], df[col].dtype)
        if df[col].dtype == bool:
            df[col] = df[col].astype(int)
        elif df[col].dtype == int:
            df[col] = df[col].astype(int)
        elif df[col].dtype == float:  # Handle float values
            df[col] = df[col].fillna(0)
            df[col] = df[col].astype(float)
        elif df[col].str.contains(r'/Date\(', na=False).any():  # Check for JSON date string format
            df[col] = df[col].fillna('')
            # df[col] = df[col].apply(lambda x: pd.to_datetime(int(re.search(r'\((\d+)', x).group(1)) / 1000, unit='s', errors='coerce') if re.search(r'\((\d+)', x) else pd.NaT)
            df[col] = df[col].apply(safe_datetime_conversion)
            df[col] = df[col].replace({pd.NaT: None})  # Replace NaT with None for SQL NULL
            df[col] = df[col].replace('', None)
        elif df[col].dtype == object:
            # Check if column contains ISO 8601 date strings
            if df[col].str.match(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?Z?$', na=False).any():
                # Remove milliseconds (decimal part) before conversion
                df[col] = df[col].str.replace(r'\.\d{1,3}$', '', regex=True)  # Remove decimal and milliseconds
                # df[col] = pd.to_datetime(df[col], errors='coerce')  # 'coerce' will convert invalid dates to NaT
                df[col] = df[col].apply(safe_datetime_conversion)
                df[col] = df[col].replace({pd.NaT: None})  # Replace NaT with None for SQL NULL
            # Check if column contains JSON array
            elif df[col].apply(lambda x: isinstance(x, list)).any():
                # Convert JSON array to string
                df[col] = df[col].apply(lambda x: str(x))
            else:
                # Convert object columns to strings, replacing NaN values with None
                df[col] = df[col].replace('nan', None)
                df[col] = df[col].astype(str).where(pd.notnull(df[col]), None)
    
    df = df.assign(ClientID = LegacyClientID, OrganisationID = int(LegacyOrganisationID)) # Insert ClientID and OrganisationID
        
    #LoggingDetails(TaskName, f"{endpoint} - Done Converting Data Types")

    return df

def Add_TableId_OrganisationId_Index(endpoint:str, tableId:str = "JournalId"):
    table_name = f"c{EtaniClientID[EtaniClientID.find('CLIENT') + len('CLIENT'):]}_xeroblue_{endpoint.lower()}"
    index_name = f"{table_name}_id_org_idx"
    column_names = f"{tableId},OrganisationId"
    # sql = f"CALL CreateEVAStageIndexIfNotExists('{table_name}', '{index_name}', '{column_names}')"
    # ExecuteEVASQL(sql, f"Add_{endpoint}_Id_OrganisationId_Index", endpoint)
    params = {
    "table_name": f"{table_name}",
    "index_name": f"{index_name}",
    "column_names": f"{column_names}"
    }
    # Use ExecuteCMSSP if AWS (procedures in vibedb_cms), otherwise use ExecuteEVASQL
    if USE_AWS_DB:
        ExecuteCMSSP(f"CreateEVAStageIndexIfNotExists('{table_name}', '{index_name}', '{column_names}')", endpoint, error_list)
    else:
        ExecuteEVASQL("CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)", f"Add_{endpoint}_Id_OrganisationId_Index", endpoint, params) 
    
def Add_StageId_Index(endpoint:str, tableId:str="JournalId"):
    table_name = f"{TablePrefixEVA}{endpoint.lower()}stage"
    index_name = f"{table_name}_stage_idx"
    column_names = f"{tableId},OrganisationId"
    params = {
    "table_name": f"{table_name}",
    "index_name": f"{index_name}",
    "column_names": f"{column_names}"
    }
    # Use ExecuteCMSSP if AWS (procedures in vibedb_cms), otherwise use ExecuteEVASQL
    if USE_AWS_DB:
        ExecuteCMSSP(f"CreateEVAStageIndexIfNotExists('{table_name}', '{index_name}', '{column_names}')", endpoint, error_list)
    else:
        ExecuteEVASQL("CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)", f"Add_{endpoint}_StageId_Index", endpoint, params) 
    
# --- Helper Functions (Corrected and Simplified) ---

# Global set to track created indexes and prevent duplicates
created_indexes: Set[str] = set()

def normalize_columns(columns: str) -> str:
    """Normalizes column names (lowercase, remove spaces, consistent separators)."""
    return columns.lower().replace(" ", "").replace("organisationid", "orgid").replace("_", "")

def get_index_key(table_name: str, columns: str) -> str:
    """Generates a unique key for an index (table:normalized_columns)."""
    return f"{table_name.lower()}:{normalize_columns(columns)}"  # Use normalized columns!

def safe_execute_eva_sql(query, operation_name, endpoint, params=None):
    """Executes an EVA SQL command, handling duplicate key errors."""
    try:
        # For AWS connections, index creation procedures are in vibedb_cms
        # So use ExecuteCMSSP instead of ExecuteEVASQL
        if USE_AWS_DB and 'CreateEVAStageIndexIfNotExists' in query:
            # Extract parameters from params dict and format as direct procedure call
            if params:
                table_name = params.get('table_name', '')
                index_name = params.get('index_name', '')
                column_names = params.get('column_names', '')
                ExecuteCMSSP(f"CreateEVAStageIndexIfNotExists('{table_name}', '{index_name}', '{column_names}')", endpoint, error_list)
            else:
                ExecuteCMSSP(query.replace('CALL ', ''), endpoint, error_list)
        else:
            ExecuteEVASQL(query, operation_name, endpoint, params)  # Pass endpoint
        return True
    except pymysql.err.OperationalError as e:  # Catch the *specific* error
        if e.args[0] == 1061:  # 1061 is the MySQL error code for "Duplicate key name"
            print(f"Index already exists - skipping: {operation_name}")
            return True  # Return True, indicating success (index already exists)
        else:
            print(f"Error in {operation_name}: {e}")
            return False # For other errors, re-raise/handle
    except Exception as e: #Keep other errors
        print(f"Error in {operation_name}: {e}")
        return False

def get_acronym(column_name):
    words = re.findall(r'[A-Z]?[a-z]+|[A-Z]+(?=[A-Z]?[a-z])', column_name)  # Handles camelCase, PascalCase, and snake_case
    return ''.join(word[0].upper() for word in words)

def Add_ClientTable_Index(endpoint: str, columns: str):
    """Creates an index on a client table, with deduplication."""
    table_name = f"{TableClientEVA}{endpoint}"
    if not endpoint or not columns:
        print("Missing parameters for Add_ClientTable_Index")
        return
    
    acronyms = [get_acronym(col) for col in columns.split(",")]
     # Create unique index name, handling potential long names:
    base_index_name = f"{table_name}_{''.join(acronyms)}"
    index_name = base_index_name[:60]  # Truncate to max length (MySQL limit)            
    index_name += "_idx"  # Consistent suffix

    columns = columns.replace(" ","")
    params = {
        "table_name": table_name,
        "index_name": index_name,
        "column_names": columns
    }
    safe_execute_eva_sql(
        "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
        f"Add_{table_name}_ClientTable_Index",  # Use full table name in operation name
        endpoint,  # Pass the endpoint parameter
        params=params  # Pass parameters correctly
    )

def Add_StageId_Generic_Index(endpoint: str, columns: str):
    """Creates an index on a stage table, with deduplication."""
    if not endpoint or not columns:
        print("Missing parameters for Add_StageId_Generic_Index")
        return
    
    table_name = f"{TablePrefixEVA}{endpoint.lower()}stage"

    #Simplified naming
    col_names = columns.replace(',','').replace('OrganisationId', 'OrgID').replace(' ','').replace('_','')
    index_name = f"{table_name}_{col_names}" #combine
    index_name = index_name[:60]  # Truncate *before* adding suffix
    index_name += "_idx"    
    columns = columns.replace(" ","")    
    params = {
        "table_name": table_name,
        "index_name": index_name,
        "column_names": columns
    }
    safe_execute_eva_sql(
        "CALL CreateEVAStageIndexIfNotExists(:table_name, :index_name, :column_names)",
        f"Add_{table_name}_Generic_Index", # Use full table name
        endpoint,  # Pass the endpoint parameter
        params=params
    )

def ExecuteEVASQL(query: str, task_name: str, endpoint: str, params=[]): # Has endpoint
    TaskName = task_name
    #LoggingDetails(TaskName, f"{endpoint} - Execute Eva Stored Procedure: {procedure_name}")    
  #  formatted_query.
    try:
        # Open a connection and execute the query
        connection = eva_engine.connect()            
        sql_query = text(query).bindparams(**params)
        if params:
            # cursor = connection.cursor()
            # cursor.callproc(query, params)  # Call procedure
            # cursor.close()
            if params:
                # Compile the query with literal binds so that parameters are inlined:
                compiled_query = sql_query.compile(
                    dialect=connection.dialect,
                    compile_kwargs={"literal_binds": True}
                )
                final_query = str(compiled_query)
                print(f"{task_name} : executing query: {final_query}")
                # Execute the fully formatted SQL string
                connection.execute(text(final_query))
        else:               
            connection.execute(sql_query)
        connection.commit()  # Commit the transaction (if needed)

        # Log success
        LoggingDetails(TaskName, f"{endpoint} - Successfully executed Eva Stored Procedure: {task_name}", JOB_ID, JOB_RUN_ID, error_list)

    except (SQLAlchemyError, ProgrammingError, OperationalError) as e:
        # Log and handle errors
        LoggingDetails(TaskName, f"{endpoint} - Failed to execute Eva stored procedure {task_name}: {str(e)}", JOB_ID, JOB_RUN_ID, error_list)
        error_list.append(f"Failed to execute EVA stored procedure: {str(e)}")
        print(f"Error: {str(e)}")    
    finally:
        # Explicitly dispose of the engine to release resources
        eva_engine.dispose()

def LogLastRefreshDate(prod_table, stage_table, load_type, step, endpoint, destination, start_date, stage_count=None, total_count=None, ErrorMessage=None):
    # spLogName = 'sp_' + TablePrefixEVA.replace('_'+str(EtaniOrganisationID), '') + 'lastrefreshdate'
    spLogName = "sp_dynamic_xeroblue_lastrefreshdate"
    ErrorMessage = ErrorMessage.replace("'", "''") if ErrorMessage is not None else None
    if step == "Started":
        spLogLastRefreshDate = f"{spLogName}({ClientIdNumber},'{prod_table}', 0, NULL, '{start_date}', NULL, NULL, '{load_type}', '{step}', {JOB_RUN_ID}, '{destination}', '{EtaniClientID}', {EtaniOrganisationID}, '{TRIGGER_TYPE}', NULL); "
        ExecuteEvaSP(spLogLastRefreshDate, endpoint, error_list)        
    elif step == "InProgress":
        print(f"{endpoint} - processing is in progress...")
    #     spLogLastRefreshDate = f"{spLogName}('{prod_table}', {stage_count}, NULL, '{start_date}', NULL, NULL, '{load_type}', '{step}', {JOB_RUN_ID}, '{destination}', '{EtaniClientID}', {EtaniOrganisationID}, '{TRIGGER_TYPE}', NULL); "
    #     ExecuteEvaSP(spLogLastRefreshDate, endpoint)
    elif step == "Completed":
        spLogLastRefreshDate = f"{spLogName}({ClientIdNumber}, '{prod_table}', {stage_count}, {total_count}, '{start_date}', UTC_TIMESTAMP(), UTC_TIMESTAMP(), '{load_type}', '{step}', {JOB_RUN_ID}, '{destination}', '{EtaniClientID}', {EtaniOrganisationID}, '{TRIGGER_TYPE}', NULL); "
        ExecuteEvaSP(spLogLastRefreshDate, endpoint, error_list)
    elif step == "Failed":
        spLogLastRefreshDate = f"{spLogName}({ClientIdNumber}, '{prod_table}', {stage_count}, {total_count}, '{start_date}', UTC_TIMESTAMP(), NULL, '{load_type}', '{step}', {JOB_RUN_ID}, '{destination}', '{EtaniClientID}', {EtaniOrganisationID}, '{TRIGGER_TYPE}', '{ErrorMessage}'); "
        ExecuteEvaSP(spLogLastRefreshDate, endpoint, error_list)
    if step == "Failed":
        params = {
                    "p_integration": "XEROBLUE",
                    "p_organisation_id": EtaniOrganisationID,
                    "p_client_id": ClientIdNumber,
                    "p_firm_id": FirmId,
                    "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_status": "Failed",
                    "p_log_id": log_id,
                    "p_remarks": f"{ErrorMessage}, Endpoint: {endpoint}"
                }
        update_container_logs(params)

def GetMaxFilterParameter(endpoint, prod_table, db_destination):
    TaskName = 'GetMaxFilterParameter'

    if endpoint in ('Invoices','CreditNotes', 'ManualJournals', 'Payments', 'BatchPayments', 'Contacts', 'PurchaseOrders'):
        FilterParameter = ''
        #LoggingDetails(TaskName, f'{endpoint} - Get Max Date from {prod_table}')
        
        Query = f"SELECT CAST(IFNULL(DATE_SUB(MAX(UpdatedDateUTC), INTERVAL 1 DAY), '2000-01-01') AS DATETIME) AS MaxDate FROM {prod_table} WHERE OrganisationID = {LegacyOrganisationID}"
        df = ReadMySQLTable(Query, endpoint, EtaniClientID, EtaniOrganisationID, error_list)

        FilterParameter = df.loc[0, 'MaxDate']
        #LoggingDetails(TaskName, f"{endpoint} - Max Date: " + str(FilterParameter))
        return FilterParameter
    
    elif endpoint in ('TransactionsBlend'):
        FilterParameter = ''
        #LoggingDetails(TaskName, f'{endpoint} - Get Max Date from {prod_table}')
        
        Query = f"SELECT CAST(IFNULL(DATE_SUB(MAX(CreatedDateUTC), INTERVAL 1 DAY), '2000-01-01') AS DATETIME) AS MaxDate FROM {prod_table} WHERE OrganisationID = {LegacyOrganisationID}"
        df = ReadMySQLTable(Query, endpoint, EtaniClientID, EtaniOrganisationID, error_list)

        FilterParameter = df.loc[0, 'MaxDate']
        #LoggingDetails(TaskName, f"{endpoint} - Max Date: " + str(FilterParameter))
        return FilterParameter
    
    elif endpoint in ('Journals', 'JournalsCash'):
        FilterParameter = 0
        #LoggingDetails(TaskName, f'{endpoint} - Get Max JournalNumber from {prod_table}')

        Query = f'SELECT IFNULL(MAX(JournalNumber), 0) as MaxJournalNumber FROM {prod_table} WHERE OrganisationID = {LegacyOrganisationID}'
        df = ReadMySQLTable(Query, endpoint, EtaniClientID, EtaniOrganisationID, error_list)
        
        FilterParameter = df.loc[0, 'MaxJournalNumber']
        #LoggingDetails(TaskName, f"{endpoint} - Max JournalNumber: " + str(FilterParameter))
        return FilterParameter
    
    elif endpoint in ('Budgets'):
        FilterParameter = ''
        #LoggingDetails(TaskName, f'{endpoint} - Get Start Date from {prod_table}')
        
        Query = f"SELECT IFNULL(YEAR(CONCAT(MAX(`BudgetLines.BudgetBalances.Period`),'-01'))-1, 2019) AS MaxYear FROM {prod_table} WHERE OrganisationID = {LegacyOrganisationID}"
        df = ReadMySQLTable(Query, endpoint, EtaniClientID, EtaniOrganisationID, error_list)

        FilterParameter = str(df.loc[0, 'MaxYear']) + '-07-01'
        #LoggingDetails(TaskName, f"{endpoint} - Start Date: " + str(FilterParameter))
        return FilterParameter

def GetCMSDetails(code, OrganisationID=0):
    endpoint = 'ETANI'
    OrganisationIDFilter = '' if OrganisationID == 0 else f"AND cs.id = {OrganisationID}"
    query = f'''
        SELECT 
            af.Code AS FirmCode,
            cs.`Status`,
            c.id AS EtaniClientID,
            cs.id AS EtaniOrganisationID,
            REPLACE(CONCAT(af.Code, '_CLIENT', CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')), cs.client) AS CHAR(10))),'-','') AS LegacyClientID,
            CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Legacy.id')), cs.id) AS CHAR(10)) AS LegacyOrganisationID,
            c.accountingFirm as FirmID,
            CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.tenantId')), '') AS CHAR(100)) AS tenantId
        FROM client_service cs
        INNER JOIN client c ON cs.`Client` = c.id
        INNER JOIN accounting_firm af ON c.AccountingFirm = af.id
        WHERE cs.`Service` = 1 and cs.Status = 1
        AND REPLACE(af.Code,'-','') = '{code.replace('-','')}'
        AND REPLACE(JSON_EXTRACT(cs.Details, '$.dbDestination'),'"','') = 'DW'
        {OrganisationIDFilter}
    '''
    
    df = ReadMySQLTable(query, '', 0, 0, error_list, IsCMS=True)

    return df

def RefreshPBIDataset(client_id, organisation_id):
    TaskName = 'RefreshPBIDataset'
    endpoint = 'ETANI'
    try:
        df = GetCMSDetails(client_id, organisation_id, XeroTenantID)
        OtherXeroRefreshes = df.loc[0, 'OtherXeroRefreshes']
        PBIWorkspaceId = df.loc[0, 'PBIWorkspaceId']
        if OtherXeroRefreshes == 0:
            #LoggingDetails(TaskName, f"{endpoint} - Generate token for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId}")
            token_refresh_url = 'https://login.windows.net/5ff8562f-e5d0-4051-8c50-950156e3dd17/oauth2/token'
            response = requests.post(token_refresh_url,
                                        data = {
                                            'grant_type' : 'password',
                                            'username' : 'developer-powerbi@vpa-account.etani.com.au',
                                            'password' : 'REDACTED',
                                            'resource' : 'https://analysis.windows.net/powerbi/api',
                                            'client_id' : '9559aaab-c759-40a1-b76a-fcbb8ddf7956',
                                            'client_secret' : 'REDACTED'
                                        })
            json_response = response.json()
            status_code = response.status_code

            if status_code == 200:
                #LoggingDetails(TaskName, f"{endpoint} - Token Generated for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId}")
                #print(json_response)
                access_token = json_response['access_token']

                datasets_url = f'https://api.powerbi.com/v1.0/myorg/groups/{PBIWorkspaceId}/datasets'
                LoggingDetails("RefreshPBIDataset", f"dataset url: {datasets_url}", JOB_ID, JOB_RUN_ID, error_list)
                response = requests.get(datasets_url, headers={'Authorization': f'Bearer {access_token}'})
                json_response = response.json()
                LoggingDetails("RefreshPBIDataset", f"response: {json_response}", JOB_ID, JOB_RUN_ID, error_list)
                status_code = response.status_code

                if status_code == 200:
                    df = pd.DataFrame(json_response['value'])
                    if len(df) > 0:
                        LoggingDetails("RefreshPBIDataset", f"root data contents: {df}", JOB_ID, JOB_RUN_ID, error_list)
                        df_filtered = df.loc[df['name'].str.contains('MASTER')].loc[df['name'].str.contains('XERO BLUE')]
                        if len(df_filtered) > 0:
                            LoggingDetails("RefreshPBIDataset", f"filtered data contents: {df_filtered}", JOB_ID, JOB_RUN_ID, error_list)
                            DatasetID = df_filtered.iloc[0]['id']

                            datasets_url = f'https://api.powerbi.com/v1.0/myorg/groups/{PBIWorkspaceId}/datasets/{DatasetID}/refreshes?$top=1'
                            response = requests.get(datasets_url, headers={'Authorization': f'Bearer {access_token}'})
                            json_response = response.json()
                            status_code = response.status_code
                            df = pd.DataFrame(json_response['value'])
                            #display(df)
                            if len(df) != 0:
                                RefreshStatus = df.iloc[0]['status']

                                if RefreshStatus != 'Unknown':
                                    datasets_url = f'https://api.powerbi.com/v1.0/myorg/groups/{PBIWorkspaceId}/datasets/{DatasetID}/refreshes'
                                    response = requests.post(datasets_url, headers={'Authorization': f'Bearer {access_token}'})
                                    a = response.json()
                                    #print(a)

                            LoggingDetails(TaskName, f"{endpoint} - Triggered Refresh of PBI Dataset for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId}", JOB_ID, JOB_RUN_ID, error_list)
            else:
                LoggingDetails(TaskName, f"{endpoint} - Failed to generate token for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId}", JOB_ID, JOB_RUN_ID, error_list)
        else:
            LoggingDetails(TaskName, f"{endpoint} - Skipping Refreshing PBI Dataset for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId} - {OtherXeroRefreshes} other refreshes in progress", JOB_ID, JOB_RUN_ID, error_list)
    except Exception as e:
        datasets_url = f'https://api.powerbi.com/v1.0/myorg/groups/{PBIWorkspaceId}/datasets/{DatasetID}/refreshes?$top=1'
        response = requests.get(datasets_url, headers={'Authorization': f'Bearer {access_token}'})
        json_response = response.json()
        status_code = response.status_code
        df = pd.DataFrame(json_response['value'])
        #display(df)
        RefreshStatus = df.iloc[0]['status']
        if RefreshStatus == 'Failed':
            LoggingDetails(TaskName, f"{endpoint} - Failed to refresh PBI Dataset for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId} - {e}", JOB_ID, JOB_RUN_ID, error_list)
            error_list.append(f"{endpoint} - Failed to refresh PBI Dataset for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId} - {e}", JOB_ID, JOB_RUN_ID, error_list)
        else:
            LoggingDetails(TaskName, f"{endpoint} - Triggered Refresh of PBI Dataset for ClientID: {client_id}, OrgID: {organisation_id}, WorkspaceID: {PBIWorkspaceId}", JOB_ID, JOB_RUN_ID, error_list)

def UpdateLastRefreshDate(refresh_status):
    endpoint = 'ETANI'
    Tablename = 'LastRefreshDate'
    ProdTable = TablePrefixEVA.replace('_'+str(EtaniOrganisationID), '') + Tablename

    if refresh_status == 'Pending':
        query = f"UPDATE {ProdTable} SET RefreshStatus = '{refresh_status}' WHERE ClientID = '{EtaniClientID}' AND OrganisationID = {EtaniOrganisationID}"
        ExecuteEvaSP(query, endpoint, error_list, True)
        query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 15 WHERE id = {EtaniOrganisationID}"
        ExecuteCMSSP(query, endpoint, error_list, True)
    elif refresh_status == 'Failed':
        query = f"UPDATE {ProdTable} SET RefreshStatus = '{refresh_status}' WHERE ClientID = '{EtaniClientID}' AND OrganisationID = {EtaniOrganisationID} AND RefreshStatus = 'Pending'"
        ExecuteEvaSP(query, endpoint, error_list, True)
    elif refresh_status == 'Completed':
        query = f"UPDATE client_service SET LastRefreshDate = UTC_TIMESTAMP(), Status = 1 WHERE id = {EtaniOrganisationID}"
        ExecuteCMSSP(query, endpoint, error_list, True)

def generate_date_ranges(begin_date, end_date, date_range='year'):
    # Convert string dates to pandas datetime
    begin_date = pd.to_datetime(begin_date)
    end_date = pd.to_datetime(end_date)
    
    # Initialize the list to store the date ranges
    date_ranges = []
    
    # Start from the begin_date and keep adding one year until we exceed end_date
    current_start_date = begin_date
    
    while current_start_date < end_date:
        if date_range == 'year':
            current_end_date = current_start_date + pd.DateOffset(years=1) - pd.DateOffset(days=1)
        elif date_range == 'quarter':
            current_end_date = current_start_date + pd.DateOffset(months=3) - pd.DateOffset(days=1)
        elif date_range == 'month':
            current_end_date = current_start_date + pd.DateOffset(months=1) - pd.DateOffset(days=1)
        
        # Ensure the end date does not exceed the specified end_date
        if current_end_date > end_date:
            current_end_date = end_date
        
        # Append the start and end date as a tuple to the list
        date_ranges.append((current_start_date.strftime('%Y-%m-%d'), current_end_date.strftime('%Y-%m-%d')))
        
        # Move to the next start date (one year later)
        current_start_date = current_end_date + pd.DateOffset(days=1)
    
    return date_ranges

def ExtractAPIResponse(endpoint):
    try:
        LoadType = ''
        StageCount = 0
        ProdCount = 0
        StartUTCDate = datetime.now(timezone.utc)
        StageTable = TablePrefixEVA + endpoint + 'STAGE'
        SPName = 'sp_' + TablePrefixEVA + endpoint
        ProdTable = TablePrefixEVA.replace('_'+str(EtaniOrganisationID), '') + endpoint
        DWProdTable = TablePrefixDW.replace('_'+str(EtaniOrganisationID), '') + endpoint
        
        if endpoint == 'Organisations':
            LoadType = 'Full'

            # 0. Log LastRefreshDate record
            StageTable = TablePrefixEVA + endpoint + 'CLIENTSSTAGE'
            SPName = SPName + 'CLIENTS'
            ProdTable = ProdTable + 'CLIENTS'
            DWProdTable = DWProdTable + 'CLIENTS'

            # Lowercase table names for MySQL Linux case-sensitivity
            StageTable = StageTable.lower()
            ProdTable = ProdTable.lower()
            DWProdTable = DWProdTable.lower()

            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, organisation in All_Data.iterrows():
                    base_data = {
                        'ShortCode': organisation.get('ShortCode', '') or '',
                        'APIKey': organisation.get('APIKey', '') or '',
                        'Name': organisation.get('Name', '') or '',
                        'LegalName': organisation.get('LegalName', '') or '',
                        'PaysTax': organisation.get('PaysTax', '') or '',
                        'Version': organisation.get('Version', '') or '',
                        'BaseCurrency': organisation.get('BaseCurrency', '') or '',
                        'CountryCode': organisation.get('CountryCode', '') or '',
                        'IsDemoCompany': organisation.get('IsDemoCompany', '') or '',
                        'OrganisationStatus': organisation.get('OrganisationStatus', '') or '',
                        'RegistrationNumber': organisation.get('RegistrationNumber', '') or '',
                        'TaxNumber': organisation.get('TaxNumber', '') or '',
                        'FinancialYearEndDay': organisation.get('FinancialYearEndDay', '') or '',
                        'FinancialYearEndMonth': organisation.get('FinancialYearEndMonth', '') or '',
                        'CreatedDateUTC': organisation.get('CreatedDateUTC', '') or '',
                        'OrganisationEntityType': organisation.get('OrganisationEntityType', '') or '',
                        'Timezone': organisation.get('Timezone', '') or '',
                        'Edition': organisation.get('Edition', '') or '',
                        'Class': organisation.get('Class', '') or '',
                        'LineOfBusiness': organisation.get('LineOfBusiness', '') or ''
                    }

                    combined_data.append(base_data)

                # 3. Convert data frame data type to SQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
                
            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('organisationsclients','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Accounts':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, account in All_Data.iterrows():
                    base_data = {
                        'AccountID': account.get('AccountID', ''),
                        'Code': account.get('Code', ''),
                        'Name': account.get('Name', ''),
                        'Status': account.get('Status', ''),
                        'Type': account.get('Type', ''),
                        'TaxType': account.get('TaxType', ''),
                        'Class': account.get('Class', ''),
                        'Description': account.get('Description', ''),
                        'SystemAccount': account.get('SystemAccount', ''),
                        'EnablePaymentsToAccount': account.get('EnablePaymentsToAccount', 0),
                        'ShowInExpenseClaims': account.get('ShowInExpenseClaims', 0),
                        'BankAccountNumber': account.get('BankAccountNumber', ''),
                        'BankAccountType': account.get('BankAccountType', ''),
                        'CurrencyCode': account.get('CurrencyCode', ''),
                        'ReportingCode': account.get('ReportingCode', ''),
                        'ReportingCodeName': account.get('ReportingCodeName', ''),
                        'HasAttachments': account.get('HasAttachments', 0),
                        'UpdatedDateUTC': validate_datetime(str(account.get('UpdatedDateUTC',''))),
                        'AddToWatchlist': account.get('AddToWatchlist', 0),

                    }
                    combined_data.append(base_data)
            
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
            
            # 5. Transform and Load Stage data to Prod Table            
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_accounts('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Invoices':
            Add_TableId_OrganisationId_Index(endpoint, "InvoiceId")
            Add_StageId_Index(endpoint, "InvoiceId")
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter if filterParameter.replace(tzinfo=timezone.utc) <= StartUTCDate else StartUTCDate
            print(f'{endpoint} - FilterParameter - {filterParameter}')
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # base_data = {}
            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:
                    # 2. Map column and extract line items
                    combined_data = []
                    for index, invoice in All_Data.iterrows():
                        for index, line in enumerate(invoice.get('LineItems', []) or [], start=1):
                            if not isinstance(line, dict):
                                continue  # Skip invalid data
                            try:
                                base_data = {
                                    'Id': str(index) + '|' + get_value(invoice, 'InvoiceID'),
                                    'InvoiceId': get_value(invoice, 'InvoiceID'),
                                    'Type': get_value(invoice,'Type'),
                                    'ContactId': get_value(invoice.get('Contact'), 'ContactID'),
                                    'ContactName': get_value(invoice.get('Contact'), 'Name'),
                                    'Date': get_value(invoice,'DateString'),
                                    'DueDate':  get_value(invoice,'DueDateString'),
                                    'LineAmountTypes':  get_value(invoice, 'LineAmountTypes'),
                                    'InvoiceNumber':  get_value(invoice, 'InvoiceNumber'),
                                    'Reference':  get_value(invoice, 'Reference'),
                                    'BrandingThemeId':  get_value(invoice, 'BrandingThemeID'),
                                    'URL':  get_value(invoice, 'Url'),
                                    'CurrencyCode':  get_value(invoice, 'CurrencyCode'),
                                    'CurrencyRate': validate_float(get_value(invoice, 'CurrencyRate', 0)),
                                    'Status':  get_value(invoice, 'Status'),
                                    'SentToContact': bool(invoice.get('SentToContact')),
                                    'ExpectedPaymentDate':  get_value(invoice, 'ExpectedPaymentDateString'),
                                    'PlannedPaymentDate':  get_value(invoice, 'PlannedPaymentDateString'),
                                    'SubTotal': validate_float(get_value(invoice, 'SubTotal')),
                                    'TotalTax': validate_float(get_value(invoice, 'TotalTax')),
                                    'Total': validate_float(get_value(invoice, 'Total')),
                                    'TotalDiscount': validate_float(get_value(invoice, 'TotalDiscount')),
                                    'HasAttachments': bool(get_value(invoice, 'HasAttachments')),
                                    'AmountDue': validate_float(get_value(invoice,'AmountDue')),
                                    'AmountPaid': validate_float(get_value(invoice, 'AmountPaid')),
                                    'CISDeduction': validate_float(get_value(invoice, 'CISDeduction')),
                                    'FullyPaidOnDate': validate_datetime(str(invoice.get('FullyPaidOnDate'))),
                                    'AmountCredited': validate_float(get_value(invoice, 'AmountCredited')),
                                    'UpdatedDateUTC': validate_datetime(str(invoice.get('UpdatedDateUTC'))),
                                    'CreditNotes': str(invoice.get('CreditNotes')) if len(invoice.get('CreditNotes')) > 0 else '[]',
                                    'Prepayments': str(invoice.get('Prepayments')) if len(invoice.get('Prepayments')) > 0 else '[]',
                                    'Payments': str(invoice.get('Payments')) if len(invoice.get('Payments')) > 0 else '[]',
                                    'Overpayments': str(invoice.get('Overpayments')) if len(invoice.get('Overpayments')) > 0 else '[]',
                                    'RepeatingInvoiceID':  get_value(invoice,'RepeatingInvoiceID'),
                                    'LineItem_LineItemId': get_value(line,'LineItemID'),
                                    'LineItem_Description': get_value(line,'Description'),
                                    'LineItem_Quantity': validate_float(get_value(line,'Quantity')),
                                    'LineItem_UnitAmount': validate_float(get_value(line,'UnitAmount')),
                                    'LineItem_ItemCode': get_value(line,'ItemCode'),
                                    'LineItem_AccountCode': get_value(line,'AccountCode'),
                                    'LineItem_TaxType': get_value(line,'TaxType'),
                                    'LineItem_TaxAmount': validate_float(get_value(line,'TaxAmount')),
                                    'LineItem_LineAmount': validate_float(get_value(line,'LineAmount')),
                                    'LineItem_DiscountRate': validate_float(get_value(line,'DiscountRate')),
                                    'LineItem_DiscountAmount': validate_float(get_value(line,'DiscountAmount'))
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and isinstance(line['Tracking'], list):
                                    tracking_categories = line['Tracking']
                                    if len(tracking_categories) > 0:
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = get_value(tracking_categories[0],'TrackingCategoryID')
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = get_value(tracking_categories[0],'Name')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionID'] = get_value(tracking_categories[0],'TrackingOptionID')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionName'] = get_value(tracking_categories[0],'Option')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = get_value(tracking_categories[1],'TrackingCategoryID')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = get_value(tracking_categories[1],'Name')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = get_value(tracking_categories[1],'TrackingOptionID')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = get_value(tracking_categories[1],'Option')
                            except Exception as ex:
                                error_list.append(f"Invoices conversion error: {str(ex)}")
                                continue
                            finally:      
                                if base_data:                              
                                    # Extract CreditnoteId values from CreditNotes JSON array and concatenate them
                                    credit_notes = invoice.get('CreditNotes', [])
                                    creditnote_ids = [credit_note.get('CreditNoteID', '') for credit_note in credit_notes]
                                    base_data['CreditNoteIds'] = ','.join(creditnote_ids)

                                    # Extract PrepaymentId values from Prepayments JSON array and concatenate them
                                    prepayments = invoice.get('Prepayments', [])
                                    prepayment_ids = [prepayment.get('PrepaymentID', '') for prepayment in prepayments]
                                    base_data['PrepaymentIds'] = ','.join(prepayment_ids)

                                    # Extract PaymentId values from Payments JSON array and concatenate them
                                    payments = invoice.get('Payments', [])
                                    payment_ids = [payment.get('PaymentID', '') for payment in payments]
                                    base_data['PaymentIds'] = ','.join(payment_ids)

                                    # Extract OverpaymentId values from Overpayments JSON array and concatenate them
                                    overpayments = invoice.get('Overpayments', [])
                                    overpayment_ids = [overpayment.get('OverpaymentID', '') for overpayment in overpayments]
                                    base_data['OverpaymentIds'] = ','.join(overpayment_ids)
                                
                                    combined_data.append(base_data)

                    # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                    # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_invoices('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'InvoiceId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'CreditNotes':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:

                    # 2. Map column and extract line items
                        combined_data = []
                        for index, creditnote in All_Data.iterrows():
                            for index, line in enumerate(creditnote.get('LineItems', []), start=1):
                                base_data = {
                                    'Id': str(index) + '|' + str(creditnote.get('CreditNoteID', '')),
                                    'CreditNoteId': str(creditnote.get('CreditNoteID', '')),
                                    'CreditNoteNumber': str(creditnote.get('CreditNoteNumber', '')),
                                    'Reference': str(creditnote.get('Reference', '')),
                                    'Type': str(creditnote.get('Type', '')),
                                    'Contact_ContactId': str((creditnote.get('Contact', '')).get('ContactID','')),
                                    'Contact_Name': str((creditnote.get('Contact', '')).get('Name','')),
                                    'Date': str(creditnote.get('DateString', '')),
                                    'Status': str(creditnote.get('Status', '')),
                                    'LineAmountTypes': str(creditnote.get('LineAmountTypes', '')),
                                    'LineItem_Description': str(line.get('Description','')),
                                    'LineItem_Quantity': float(line.get('Quantity',0)),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount',0)),
                                    'LineItem_ItemCode': str(line.get('ItemCode','')),
                                    'LineItem_AccountCode': str(line.get('AccountCode','')),
                                    'LineItem_TaxType': str(line.get('TaxType','')),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount',0)),
                                    'LineItem_LineAmount': float(line.get('LineAmount',0)),
                                    'SubTotal': float(creditnote.get('SubTotal', 0)),
                                    'TotalTax': float(creditnote.get('TotalTax', 0)),
                                    'Total': float(creditnote.get('Total', 0)),
                                    'UpdatedDateUTC': validate_datetime(str(creditnote.get('UpdatedDateUTC', ''))),
                                    'CurrencyCode': str(creditnote.get('CurrencyCode', '')),
                                    'FullyPaidOnDate': validate_datetime(str(creditnote.get('FullyPaidOnDate', ''))),
                                    'SentToContact': bool(creditnote.get('SentToContact')),
                                    'BrandingThemeId': str(creditnote.get('BrandingThemeId', '')),
                                    'CurrencyRate': float(creditnote.get('CurrencyRate', 0)),
                                    'RemainingCredit': float(creditnote.get('RemainingCredit', 0)),
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                
                                # Extract and flatten JSON Array Allocations
                                for i, allocation in enumerate(creditnote.get('Allocations', []), start=1):
                                    if i <= 10:
                                        base_data[f'Allocation{i}_AppliedAmount'] = allocation.get('Amount')
                                        base_data[f'Allocation{i}_Date'] = allocation.get('Date')
                                        base_data[f'Allocation{i}_InvoiceId'] = (allocation.get('Invoice', '')).get('InvoiceID', '') if allocation.get('Invoice') else ''
                                        base_data[f'Allocation{i}_InvoiceNumber'] = (allocation.get('Invoice', '')).get('InvoiceNumber', '')
                                    
                                combined_data.append(base_data)

                    # 3. Convert data frame data type to SQL data type
                        Combined_Data = pd.DataFrame(combined_data)
                        ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                    # 4. Load data to Stage Table
                        WriteMode = "overwrite" if page == 1 else "append"
                        LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                        StageCount += len(ConvertedData)
                        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                        # assuming 1000 is the maximum number of results per page
                        if len(All_Data) < pagesize:
                            break
                        page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_creditnotes('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'CreditNoteId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)
        
        elif endpoint == 'Overpayments':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint, params, str(MaxDate)) as All_Data:
                # 2. Map column and extract line items
                    combined_data = []
                    if len(All_Data) > 0:                        
                        for index, overpayment in All_Data.iterrows():
                            for index, line in enumerate(overpayment.get('LineItems', []), start=1):
                                base_data = {
                                    'OverpaymentId': str(overpayment.get('OverpaymentID', '')),
                                    'Date': str(overpayment.get('DateString', '')),
                                    'Type': str(overpayment.get('Type', '')),
                                    'RemainingCredit': float(overpayment.get('RemainingCredit', 0)),
                                    'Contact_ContactId': str((overpayment.get('Contact', '')).get('ContactID','')),
                                    'Contact_Name': str((overpayment.get('Contact', '')).get('Name','')),
                                    'Status': str(overpayment.get('Status', '')),
                                    'SubTotal': float(overpayment.get('SubTotal', 0)),
                                    'TotalTax': float(overpayment.get('TotalTax', 0)),
                                    'Total': float(overpayment.get('Total', 0)),
                                    'LineItem_LineItemId': str(line.get('LineItemID','')),
                                    'LineItem_Description': str(line.get('Description','')),
                                    'LineItem_Quantity': float(line.get('Quantity',0)),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount',0)),
                                    'LineItem_ItemCode': str(line.get('ItemCode','')),
                                    'LineItem_AccountCode': str(line.get('AccountCode','')),
                                    'LineItem_TaxType': str(line.get('TaxType','')),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount',0)),
                                    'LineItem_LineAmount': float(line.get('LineAmount',0)),
                                    'LineItem_DiscountRate': float(line.get('DiscountRate',0)),
                                    'LineAmountTypes': str(overpayment.get('LineAmountTypes', '')),
                                    'CurrencyCode': str(overpayment.get('CurrencyCode', '')),
                                    'CurrencyRate': validate_float(str(overpayment.get('CurrencyRate', ''))),
                                    'UpdatedDateUTC': validate_datetime(str(overpayment.get('UpdatedDateUTC', ''))),
                                    'HasAttachments': bool(overpayment.get('HasAttachments', 0)),
                                    'Payments': str(overpayment.get('Payments', ''))
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                
                                # Extract and flatten JSON Array Allocations
                                for i, allocation in enumerate(overpayment.get('Allocations', []), start=1):
                                    if i <= 10 :
                                        base_data[f'Allocation{i}_AppliedAmount'] = allocation.get('Amount', 0)
                                        base_data[f'Allocation{i}_Date'] = allocation.get('Date', '')
                                        base_data[f'Allocation{i}_InvoiceId'] = (allocation.get('Invoice', '')).get('InvoiceID', '')
                                        base_data[f'Allocation{i}_InvoiceNumber'] = (allocation.get('Invoice', '')).get('InvoiceNumber', '')
                                    
                                combined_data.append(base_data)

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_overpayments('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW') and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'OverpaymentId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Prepayments':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                combined_data = []
                with XeroRequestsManager(endpoint, params, str(MaxDate)) as All_Data:
                # 2. Map column and extract line items                
                    if len(All_Data) > 0:                        
                        for index, prepayment in All_Data.iterrows():
                            for index, line in enumerate(prepayment.get('LineItems', []), start=1):
                                base_data = {
                                    'PrepaymentId': str(prepayment.get('PrepaymentID', '')),
                                    'Date': str(prepayment.get('DateString', '')),
                                    'Reference': str(prepayment.get('Reference', '')),
                                    'Type': str(prepayment.get('Type', '')),
                                    'RemainingCredit': float(prepayment.get('RemainingCredit', 0)),
                                    'Contact_ContactId': str((prepayment.get('Contact', '')).get('ContactID','')),
                                    'Contact_Name': str((prepayment.get('Contact', '')).get('Name','')),
                                    'Status': str(prepayment.get('Status', '')),
                                    'SubTotal': float(prepayment.get('SubTotal', 0)),
                                    'TotalTax': float(prepayment.get('TotalTax', 0)),
                                    'Total': float(prepayment.get('Total', 0)),
                                    'LineItem_LineItemId': str(line.get('LineItemID','')),
                                    'LineItem_Description': str(line.get('Description','')),
                                    'LineItem_Quantity': float(line.get('Quantity',0)),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount',0)),
                                    'LineItem_ItemCode': str(line.get('ItemCode','')),
                                    'LineItem_AccountCode': str(line.get('AccountCode','')),
                                    'LineItem_TaxType': str(line.get('TaxType','')),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount',0)),
                                    'LineItem_LineAmount': float(line.get('LineAmount',0)),
                                    'LineItem_DiscountRate': float(line.get('DiscountRate',0)),
                                    'LineAmountTypes': str(prepayment.get('LineAmountTypes', '')),
                                    'CurrencyCode': str(prepayment.get('CurrencyCode', '')),
                                    'CurrencyRate': validate_float(str(prepayment.get('CurrencyRate', ''))),
                                    'UpdatedDateUTC': validate_datetime(str(prepayment.get('UpdatedDateUTC', ''))),
                                    'HasAttachments': bool(prepayment.get('HasAttachments', 0)),
                                    'Payments': str(prepayment.get('Payments', ''))
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                
                                # Extract and flatten JSON Array Allocations
                                for i, allocation in enumerate(prepayment.get('Allocations', []), start=1):
                                    if i <= 10 :
                                        base_data[f'Allocation{i}_AppliedAmount'] = allocation.get('Amount', 0)
                                        base_data[f'Allocation{i}_Date'] = allocation.get('Date', '')
                                        base_data[f'Allocation{i}_InvoiceId'] = (allocation.get('Invoice', '')).get('InvoiceID', '')
                                        base_data[f'Allocation{i}_InvoiceNumber'] = (allocation.get('Invoice', '')).get('InvoiceNumber', '')
                                    
                                combined_data.append(base_data)

                    # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                    # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_prepayments('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW') and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'PrepaymentId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'ManualJournals':
            Add_TableId_OrganisationId_Index(endpoint, "ManualJournalId")
            Add_StageId_Index(endpoint, "ManualJournalId")
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:

                # 2. Map column and extract line items
                    combined_data = []
                    for index, manualjournal in All_Data.iterrows():
                        for index, line in enumerate(manualjournal.get('JournalLines', []), start=1):
                            base_data = {
                                'Id': str(index) + '|' + str(manualjournal.get('ManualJournalID', '')),
                                'ManualJournalId': str(manualjournal.get('ManualJournalID', '')),
                                'Narration': str(manualjournal.get('Narration', '')),
                                'Date': str(manualjournal.get('Date', '')),
                                'Status': str(manualjournal.get('Status', '')),
                                'URL': str(manualjournal.get('URL', '')),
                                'ShowOnCashBasisReports': bool(manualjournal.get('ShowOnCashBasisReports', 0)),
                                'LineAmountTypes': str(manualjournal.get('LineAmountTypes', '')),
                                'UpdatedDateUTC': validate_datetime(str(manualjournal.get('UpdatedDateUTC', ''))),
                                'HasAttachments': bool(manualjournal.get('HasAttachments')),
                                'JournalLine_LineAmount': float(line.get('LineAmount', 0)),
                                'JournalLine_AccountCode': str(line.get('AccountCode', '')),
                                'JournalLine_Description': str(line.get('Description', '')),
                                'JournalLine_TaxType': str(line.get('TaxType', '')),
                                'JournalLine_TaxAmount': float(line.get('TaxAmount', 0)),
                            }
                            # Extract and flatten JSON Array Tracking Categories
                            if 'Tracking' in line and len(line['Tracking']) >= 1:
                                tracking_categories = line['Tracking']
                                base_data[f'JournalLine_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                base_data[f'JournalLine_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                base_data[f'JournalLine_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                base_data[f'JournalLine_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                if len(tracking_categories) == 2:
                                    base_data[f'JournalLine_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                    base_data[f'JournalLine_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                    base_data[f'JournalLine_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                    base_data[f'JournalLine_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')

                            combined_data.append(base_data)

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_manualjournals('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'ManualJournalId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Payments':
            Add_TableId_OrganisationId_Index(endpoint, "PaymentId")
            Add_StageId_Index(endpoint, "PaymentId")
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:                
                # 2. Map column and extract line items
                    combined_data = []
                    for index, payment in All_Data.iterrows():
                        base_data = {
                            'PaymentId': str(payment.get('PaymentID', '')),
                            'Date': str(payment.get('Date', '')),
                            'Amount': float(payment.get('Amount', 0)),
                            'CurrencyRate': float(payment.get('CurrencyRate', 0)),
                            'Reference': str(payment.get('Reference', '')),
                            'PaymentType': str(payment.get('PaymentType', '')),
                            'Status': str(payment.get('Status', '')),
                            'UpdatedDateUTC': validate_datetime(str(payment.get('UpdatedDateUTC', ''))),
                            'IsReconciled': bool(payment.get('IsReconciled')),
                            'BatchPaymentId': str(payment.get('BatchPaymentID', '')),
                            'InvoiceId': str((payment.get('Invoice', '')).get('InvoiceID', '') if payment.get('Invoice') else ''),
                            'InvoiceNumber': str((payment.get('Invoice', '')).get('InvoiceNumber', '') if payment.get('Invoice') else ''),
                            'CreditNoteId': str((payment.get('CreditNote')).get('CreditNoteID', '') if payment.get('CreditNote') else ''),
                            'CreditNoteNumber': str((payment.get('CreditNote')).get('CreditNoteNumber', '') if payment.get('CreditNote') else ''),
                            'AccountId': str((payment.get('Account', '')).get('AccountID', '')),
                            'AccountCode': str((payment.get('Account', '')).get('Code', '')),
                        }

                        combined_data.append(base_data)

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_payments('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'PaymentId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'BankTransactions':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:
                # 2. Map column and extract line items
                    combined_data = []
                    for index, banktransaction in All_Data.iterrows():
                        try:
                            # Validate data type
                            # if not isinstance(banktransaction, pd.Series) or banktransaction.isnull().any():
                            #     print(f"Skipping invalid row at index {index}: {banktransaction}")
                            #     continue
                            for line_index, line in enumerate(banktransaction.get('LineItems', []), start=1):
                                #check if line empty or not
                                line = line if isinstance(line, dict) else {}

                                # Construct base data with helper functions
                                base_data = {
                                    'Id': f"{line_index}|{get_value(banktransaction, 'BankTransactionID')}",
                                    'BankTransactionId': get_value(banktransaction, 'BankTransactionID'),
                                    'Type': str(banktransaction.get('Type', '') or ''),
                                    'Contact_ContactId': get_nested_value(banktransaction, ['Contact', 'ContactID']) if banktransaction.get('Status') != 'DELETED' else '',
                                    'Contact_ContactName': get_nested_value(banktransaction, ['Contact', 'Name']) if banktransaction.get('Status') != 'DELETED' else '',
                                    'BankAccount_AccountId': get_nested_value(banktransaction, ['BankAccount', 'AccountID']) if banktransaction.get('Status') != 'DELETED' else '',
                                    'BankAccount_AccountName': get_nested_value(banktransaction, ['BankAccount', 'Name']),
                                    'LineItem_Description': line.get('Description', '')[:255],
                                    'LineItem_Quantity': float(line.get('Quantity', 0)),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount', 0)),
                                    'LineItem_AccountCode': line.get('AccountCode', ''),
                                    'LineItem_TaxType': line.get('TaxType', ''),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount', 0)),
                                    'LineItem_LineAmount': float(line.get('LineAmount', 0)),
                                    'IsReconciled': bool(banktransaction.get('IsReconciled', False)),
                                    'Date': get_value(banktransaction, 'DateString'),
                                    'Reference': get_value(banktransaction, 'Reference'),
                                    'CurrencyRate': float(banktransaction.get('CurrencyRate', 0)),
                                    'Status': get_value(banktransaction, 'Status'),
                                    'LineAmountTypes': get_value(banktransaction, 'LineAmountTypes'),
                                    'SubTotal': float(banktransaction.get('SubTotal', 0)),
                                    'TotalTax': float(banktransaction.get('TotalTax', 0)),
                                    'Total': float(banktransaction.get('Total', 0)),
                                    'PrepaymentId': get_value(banktransaction, 'PrePaymentID'),
                                    'OverpaymentId': get_value(banktransaction, 'OverpaymentID'),
                                    'UpdatedDateUTC': validate_datetime(str(get_value(banktransaction, 'UpdatedDateUTC'))),
                                    'CurrencyCode': get_value(banktransaction, 'CurrencyCode'),
                                    'HasAttachments': bool(banktransaction.get('HasAttachments', False)),
                                }
                                """
                                 base_data = {
                                     'Id': str(index) + '|' + get_value(banktransaction, 'BankTransactionID'),
                                     'BankTransactionId': get_value(banktransaction, 'BankTransactionID'),
                                     'Type': str(banktransaction.get('Type', '') or ''),
                                     'Contact_ContactId': get_nested_value(banktransaction, ['Contact', 'ContactID']) if banktransaction.get('Status') != 'DELETED' else '', #str((banktransaction.get('Contact', '')).get('ContactID', '') if banktransaction.get('Status') != 'DELETED' else ''),
                                     'Contact_ContactName': get_nested_value(banktransaction, ['Contact', 'Name']) if banktransaction.get('Status') != 'DELETED' else '', #str((banktransaction.get('Contact', '')).get('Name', '') if banktransaction.get('Status') != 'DELETED' else ''),
                                     'BankAccount_AccountId': get_nested_value(banktransaction, ['BankAccount', 'AccountID']) if banktransaction.get('Status') != 'DELETED' else '', #str((banktransaction.get('BankAccount', '')).get('AccountID','') if banktransaction.get('BankAccount') else ''),
                                     'BankAccount_AccountName': get_nested_value(banktransaction, ['BankAccount', 'Name']) if banktransaction.get('Status') != 'DELETED' else '',#str((banktransaction.get('BankAccount', '')).get('Name','') if banktransaction.get('BankAccount') else ''),
                                     'BankAccount_Code': get_nested_value(banktransaction, ['BankAccount', 'Code']) if banktransaction.get('Status') != 'DELETED' else '',#str((banktransaction.get('BankAccount', '')).get('Code','') if banktransaction.get('BankAccount') else ''),
                                     'LineItem_LineItemId': get_value(banktransaction, 'LineItemID'),#str(line.get('LineItemID', '') or ''),
                                     'LineItem_Description': get_value(banktransaction, 'Description')[:255],#str(line.get('Description', '') or '')[:255],
                                     'LineItem_Quantity': float(line.get('Quantity', 0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'LineItem_UnitAmount': float(line.get('UnitAmount', 0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'LineItem_AccountCode': get_value(banktransaction, 'AccountCode'),#str(line.get('AccountCode', '') or ''),
                                     'LineItem_TaxType': get_value(banktransaction, 'TaxType'),#str(line.get('TaxType', '') or ''),
                                     'LineItem_TaxAmount': float(line.get('TaxAmount', 0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'LineItem_LineAmount': float(line.get('LineAmount', 0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'LineItem_ItemCode': get_value(banktransaction, 'ItemCode'),#str(line.get('ItemCode', '') or ''),
                                     'IsReconciled': bool(banktransaction.get('IsReconciled', 0) or False),
                                     'Date': get_value(banktransaction, 'DateString'),#str(banktransaction.get('DateString', '') or ''),
                                     'Reference': get_value(banktransaction, 'Reference'),#str(banktransaction.get('Reference') or '') if not pd.isna(banktransaction.get('Reference')) else '',
                                     'CurrencyRate': float(banktransaction.get('CurrencyRate', 0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'Status': get_value(banktransaction, 'Status'),#str(banktransaction.get('Status', '') or ''),
                                     'LineAmountTypes': get_value(banktransaction, 'LimeAmountTypes'),#str(banktransaction.get('LineAmountTypes', '')),
                                     'SubTotal': float(banktransaction.get('SubTotal',0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'TotalTax': float(banktransaction.get('TotalTax',0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'Total': float(banktransaction.get('Total',0) if isinstance(line, dict) and hasattr(line, 'get') else 0),
                                     'PrepaymentId': get_value(banktransaction, 'PrePaymentID'),#str(banktransaction.get('PrepaymentID', '') if banktransaction.get('PrepaymentID') else '') if not pd.isna(banktransaction.get('PrepaymentID')) else '',
                                     'OverpaymentId': get_value(banktransaction, 'OverpaymentID'),#str(banktransaction.get('OverpaymentID', '') if banktransaction.get('OverpaymentID') else '') if not pd.isna(banktransaction.get('OverpaymentID')) else '',
                                     'UpdatedDateUTC': get_value(banktransaction, 'UpdatedDateUTC'),#str(banktransaction.get('UpdatedDateUTC', '') or ''),
                                     'FullyPaidOnDate': get_value(banktransaction, 'FullyPaidOnDate'),#str(banktransaction.get('FullyPaidOnDate', '') or ''),
                                     'CurrencyCode': get_value(banktransaction, 'CurrencyCode'),#str(banktransaction.get('CurrencyCode', '') or ''),
                                     'HasAttachments': bool(banktransaction.get('HasAttachments') or False)
                                 }
                                 """
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                combined_data.append(base_data)
                        except AttributeError as e:
                            print(f"Error processing row {index}: {banktransaction}, error: {e}")
                            error_list.append(f"Error processing row {index}: {banktransaction}, error: {e}")
                            continue                                

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_banktransactions('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'BankTransactionId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Journals':
            #Initialize Journal Indexes
            # Add_TableId_OrganisationId_Index(endpoint)  # REMOVE THIS LINE
            # Add_StageId_Index(endpoint) # REMOVE THIS LINE
            offset = 0
            pagesize = 100
            StageCount = 0
            ProdCount = 0
            # 0. Get Max JournalNumber
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            offset = 0 if filterParameter <= 0 else filterParameter-1
            LoadType = 'Full' if offset == 0 else 'Latest'
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
            
            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'offset': offset}
                with XeroRequestsManager(endpoint,params) as All_Data:
        
                # 2. Map column and extract line items
                    combined_data = []
                    for index, journal in All_Data.iterrows():
                        for index, line in enumerate(journal.get('JournalLines', []), start=1):
                            base_data = {
                                'Id':  str(index) + '|' + journal.get('JournalID', ''),
                                'JournalId': journal.get('JournalID', ''),
                                'JournalDate': journal.get('JournalDate', ''),
                                'JournalNumber': journal.get('JournalNumber', ''),
                                'CreatedDateUTC': journal.get('CreatedDateUTC', ''),
                                'Reference': journal.get('Reference', ''),
                                'SourceId': journal.get('SourceID', ''),
                                'SourceType': journal.get('SourceType', ''),
                                'JournalLine_JournalLineId': line.get('JournalLineID', ''),
                                'JournalLine_Description': line.get('Description', ''),
                                'JournalLine_AccountId': line.get('AccountID', ''),
                                'JournalLine_AccountCode': line.get('AccountCode', ''),
                                'JournalLine_AccountType': line.get('AccountType', ''),
                                'JournalLine_AccountName': line.get('AccountName', ''),
                                'JournalLine_NetAmount': line.get('NetAmount', ''),
                                'JournalLine_GrossAmount': line.get('GrossAmount', ''),
                                'JournalLine_TaxAmount': line.get('TaxAmount', ''),
                                'JournalLine_TaxType': line.get('TaxType', ''),
                                'JournalLine_TaxName': line.get('TaxName', '')
                            }
                            # Extract and flatten JSON Array Tracking Categories
                            if 'TrackingCategories' in line and len(line['TrackingCategories']) >= 1:
                                tracking_categories = line['TrackingCategories']
                                base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                if len(tracking_categories) == 2:
                                    base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                            combined_data.append(base_data)

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if offset <= filterParameter else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 100 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    offset += pagesize
        
            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_journals('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            # --- STAGE TABLE INDEX CREATION (After Data Load) ---

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxJournalNumber = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f'AND JournalNumber >= {MaxJournalNumber}' if MaxJournalNumber > 0 else ''
            #    UniqueKey = 'JournalId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'JournalsCash':
            #Initialize Journal Indexes - STAGE TABLE
            # Add_TableId_OrganisationId_Index(endpoint) #Remove
            # Add_StageId_Index(endpoint) #Remove
            offset = 0
            pagesize = 100
            StageCount = 0
            ProdCount = 0
            # 0. Get Max JournalNumber
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            offset = 0 if filterParameter <= 0 else filterParameter-1
            LoadType = 'Full' if offset == 0 else 'Latest'
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
            
            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'offset': offset, 'paymentsOnly': True}
                with XeroRequestsManager(endpoint.replace('Cash', ''),params) as All_Data:        
                # 2. Map column and extract line items
                    combined_data = []
                    for index, journal in All_Data.iterrows():
                        if len(journal.get('JournalLines', [])) != 0:
                            for index, line in enumerate(journal.get('JournalLines', []), start=1):
                                base_data = {
                                    'Id':  str(index) + '|' + str(journal.get('JournalID', '')),
                                    'JournalId': str(journal.get('JournalID', '')),
                                    'JournalDate': str(journal.get('JournalDate', '')),
                                    'JournalNumber': int(journal.get('JournalNumber', '')),
                                    'CreatedDateUTC': str(journal.get('CreatedDateUTC', '')),
                                    'Reference': str(journal.get('Reference', '')),
                                    'SourceId': str(journal.get('SourceID', '')),
                                    'SourceType': str(journal.get('SourceType', '')),
                                    'JournalLine_JournalLineId': str(line.get('JournalLineID', '')),
                                    'JournalLine_Description': str(line.get('Description', '')),
                                    'JournalLine_AccountId': str(line.get('AccountID', '')),
                                    'JournalLine_AccountCode': str(line.get('AccountCode', '')),
                                    'JournalLine_AccountType': str(line.get('AccountType', '')),
                                    'JournalLine_AccountName': str(line.get('AccountName', '')),
                                    'JournalLine_NetAmount': float(line.get('NetAmount', '')),
                                    'JournalLine_GrossAmount': float(line.get('GrossAmount', '')),
                                    'JournalLine_TaxAmount': float(line.get('TaxAmount', '')),
                                    'JournalLine_TaxType': str(line.get('TaxType', '')),
                                    'JournalLine_TaxName': str(line.get('TaxName', ''))
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'TrackingCategories' in line and len(line['TrackingCategories']) >= 1:
                                    tracking_categories = line['TrackingCategories']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                combined_data.append(base_data)
                        else:
                            journal_data = {
                                'Id':  str(index) + '|' + str(journal.get('JournalID', '')),
                                'JournalId': str(journal.get('JournalID', '')),
                                'JournalDate': str(journal.get('JournalDate', '')),
                                'JournalNumber': int(journal.get('JournalNumber', '')),
                                'CreatedDateUTC': str(journal.get('CreatedDateUTC', '')),
                                'Reference': str(journal.get('Reference', '')),
                                'SourceId': str(journal.get('SourceID', '')),
                                'SourceType': str(journal.get('SourceType', ''))
                            }
                            combined_data.append(journal_data)

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if offset <= filterParameter else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 100 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    offset += pagesize
        

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_journalscash('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxJournalNumber = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f'AND JournalNumber >= {MaxJournalNumber}' if MaxJournalNumber > 0 else ''
            #    UniqueKey = 'JournalId'
            #    future = TriggerLoadToDW(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Transactions':
            TaskName = 'LoadTransactions'
            
            # 1. Load derived data to Prod Table
            LoadType = 'Full'
            # ExecuteEvaSP(SPName, endpoint)
            # ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_transactions('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID}, '{LegacyClientID}')", endpoint, True)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_transactions('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID}, '{LegacyClientID.lower()}')", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, ProdCount, ProdCount)
            LoggingDetails(TaskName, f"{endpoint} - Successfully loaded data to {ProdTable}", JOB_ID, JOB_RUN_ID, error_list)
        
        elif endpoint == 'TransactionsBlend':
            TaskName = 'LoadTransactionsBlend'

            # 1. Load derived data to Prod Table
            LoadType = 'Full'
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_transactionsblend('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, ProdCount, ProdCount)
            LoggingDetails(TaskName, f"{endpoint} - Successfully loaded data to {ProdTable}", JOB_ID, JOB_RUN_ID, error_list)
        
        elif endpoint == 'TrackingCategoryConnections':
            TaskName = 'LoadTrackingCategoryConnections'
            
            # 1. Load derived data to Prod Table
            LoadType = 'Full'
            #ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_trackingcategoryconnections('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, ProdCount, ProdCount)
            LoggingDetails(TaskName, f"{endpoint} - Successfully loaded data to {ProdTable}", JOB_ID, JOB_RUN_ID, error_list)
            
            #if DB_Destination in ('DW', 'EVADW'):
            #    LoadType = 'Full'
            #    TaskName = 'LoadDWDerivedTable'
            #    SPName = f'{EtaniClientID}.uspUpsert_XEROBLUE_TrackingCategoryConnections_py {str(EtaniOrganisationID)}'
            #    # ExecuteDWSP(SPName, endpoint)
            #    ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID})", endpoint, True)
            #    query = f"SELECT COUNT(*) as Count FROM {DWProdTable} WHERE OrganisationID = {LegacyOrganisationID}"
            #    spark_df = ReadDWTable(query, endpoint)
            #    ProdCount = spark_df.iloc[0]['Count']

            #    LoggingDetails(TaskName, f"{endpoint} - Successfully loaded data to {DWProdTable}")
            #    LogLastRefreshDate(DWProdTable, '', LoadType, 'Completed', endpoint, 'DW', StartUTCDate, ProdCount, ProdCount)


        elif endpoint == 'Budgets':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0

            # 0. Log LastRefreshDate record
            # filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            # filterParameter = '' if filterParameter is None else filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            BeginDate = '2019-07-01'
            EndDate = '2026-06-30'
            yearly_ranges = generate_date_ranges(BeginDate, EndDate, date_range='year')
            All_Data = []
            combined_data = []
            for yearly_range in yearly_ranges:
                params = {'dateFrom': yearly_range[0], 'dateTo': yearly_range[1]}
                BudgetList = XeroRequests(endpoint, params)
                for budget in BudgetList['BudgetID']:
                    Raw_Data = XeroRequests(endpoint, params, id=budget)
                    All_Data.append(Raw_Data)

            # 2. Map column and extract line items
            if len(All_Data) > 0:
                All_Data = pd.concat(All_Data, ignore_index=True)                          
                for index, budget in All_Data.iterrows():
                    if len(budget['BudgetLines']) != 0:
                        for line in budget['BudgetLines']:
                            for balance in line['BudgetBalances']:
                                base_data = {
                                    'BudgetID': str(budget.get('BudgetID', '')),
                                    'Status': str(budget.get('Status', '')),
                                    'Description': str(budget.get('Description', '')),
                                    'Type': str(budget.get('Type', '')),
                                    'UpdatedDateUTC': validate_datetime(str(budget.get('UpdatedDateUTC', ''))),
                                    'BudgetLines.AccountID': str(line.get('AccountID', '')),
                                    'BudgetLines.AccountCode': str(line.get('AccountCode', '')),
                                    'BudgetLines.BudgetBalances.Period': str(balance.get('Period', '')),
                                    'BudgetLines.BudgetBalances.Amount': float(balance.get('Amount', 0)),
                                    'BudgetLines.BudgetBalances.Notes': str(balance.get('Notes', '')),
                                }

                                if 'Tracking' in budget and budget['Tracking'] and len(budget['Tracking']) >= 1:
                                    trackings = budget['Tracking']
                                    base_data[f'Tracking.{1}.Name'] = trackings[0].get('Name', '')
                                    base_data[f'Tracking.{1}.Option'] = trackings[0].get('Option', '')
                                    base_data[f'Tracking.{1}.TrackingCategoryID'] = trackings[0].get('TrackingCategoryID', '')
                                    base_data[f'Tracking.{1}.TrackingOptionID'] = trackings[0].get('TrackingOptionID', '')
                                    if len(trackings) == 2:
                                        base_data[f'Tracking.{2}.Name'] = trackings[1].get('Name', '')
                                        base_data[f'Tracking.{2}.Option'] = trackings[1].get('Option', '')
                                        base_data[f'Tracking.{2}.TrackingCategoryID'] = trackings[1].get('TrackingCategoryID', '')
                                        base_data[f'Tracking.{2}.TrackingOptionID'] = trackings[1].get('TrackingOptionID', '')
                                
                                combined_data.append(base_data)

                    else:
                        budget_data = {
                            'BudgetID': str(budget.get('BudgetID', '')),
                            'Status': str(budget.get('Status', '')),
                            'Description': str(budget.get('Description', '')),
                            'Type': str(budget.get('Type', '')),
                            'UpdatedDateUTC': validate_datetime(str(budget.get('UpdatedDateUTC', ''))),
                        }

                        if 'Tracking' in budget and budget['Tracking'] and len(budget['Tracking']) >= 1:
                            trackings = budget['Tracking']
                            budget_data[f'Tracking.{1}.Name'] = trackings[0].get('Name', '')
                            budget_data[f'Tracking.{1}.Option'] = trackings[0].get('Option', '')
                            budget_data[f'Tracking.{1}.TrackingCategoryID'] = trackings[0].get('TrackingCategoryID', '')
                            budget_data[f'Tracking.{1}.TrackingOptionID'] = trackings[0].get('TrackingOptionID', '')
                            if len(trackings) == 2:
                                budget_data[f'Tracking.{2}.Name'] = trackings[1].get('Name', '')
                                budget_data[f'Tracking.{2}.Option'] = trackings[1].get('Option', '')
                                budget_data[f'Tracking.{2}.TrackingCategoryID'] = trackings[1].get('TrackingCategoryID', '')
                                budget_data[f'Tracking.{2}.TrackingOptionID'] = trackings[1].get('TrackingOptionID', '')

                        combined_data.append(budget_data)

                    # 3. Convert data frame data type to MYSQL data type
                #if All_Data: del All_Data
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                # display(ConvertedData)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

                # 5. Transform and Load Stage data to Prod Table
                # ExecuteEvaSP(SPName, endpoint)
                ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_budgets('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
                dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
                ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

                # 6. Load data to DW Prod
                #if DB_Destination in ('DW', 'EVADW'):
                #    MaxYear = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
                #    WriteMode = 'append'
                #    WhereClause = f"AND `BudgetLines.BudgetBalances.Period` >= '{MaxYear}'" if str(MaxYear) != '2019-07-01' and MaxYear != None else ''
                #    UniqueKey = '`BudgetLines.BudgetBalances.Period`'
                #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'BankTransfers':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            MaxDate = ''

            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:           
                # 2. Map column and extract line items
                combined_data = []
                if len(All_Data) > 0:  
                    for index, banktransfer in All_Data.iterrows():
                        base_data = {
                            'BankTransferId': str(banktransfer.get('BankTransferID', '')),
                            'FromBankAccount_Code': str((banktransfer.get('FromBankAccount', '')).get('Code', '') if banktransfer.get('FromBankAccount') else ''),
                            'FromBankAccount_Name': str((banktransfer.get('FromBankAccount', '')).get('Name', '') if banktransfer.get('FromBankAccount') else ''),
                            'FromBankAccount_AccountId': str((banktransfer.get('FromBankAccount', '')).get('AccountID', '') if banktransfer.get('FromBankAccount') else ''),
                            'ToBankAccount_Code': str((banktransfer.get('ToBankAccount', '')).get('Code', '') if banktransfer.get('ToBankAccount') else ''),
                            'ToBankAccount_Name': str((banktransfer.get('ToBankAccount', '')).get('Name', '') if banktransfer.get('ToBankAccount') else ''),
                            'ToBankAccount_AccountId': str((banktransfer.get('ToBankAccount', '')).get('AccountID', '') if banktransfer.get('ToBankAccount') else ''),
                            'Amount': float(banktransfer.get('Amount', 0)),
                            'Date': str(banktransfer.get('Date', '')),
                            'CurrencyRate': float(banktransfer.get('CurrencyRate', 0)),
                            'FromBankTransactionID': str(banktransfer.get('FromBankTransactionID', '')),
                            'ToBankTransactionID': str(banktransfer.get('ToBankTransactionID', '')),
                            'HasAttachments': bool(banktransfer.get('HasAttachments')),
                            'CreatedDateUTC': str(banktransfer.get('CreatedDateUTC', ''))
                        }
                        combined_data.append(base_data)
                
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_banktransfers('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0

            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'BankTransferId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'BatchPayments':
            Add_TableId_OrganisationId_Index(endpoint, "BatchPaymentId")
            Add_StageId_Index(endpoint, "BatchPaymentId")
            StageCount = 0
            ProdCount = 0
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint,None,str(MaxDate)) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, batchpayment in All_Data.iterrows():
                    # Extracting the main Batch Payment details
                    for index, payments in enumerate(batchpayment.get('Payments', []), start=1):
                        base_data = {
                            'Id': str(index) + '|' + str(batchpayment.get('BatchPaymentID', '')),
                            'BatchPaymentId': str(batchpayment.get('BatchPaymentID', '')),
                            'AccountId': str((batchpayment.get('Account', '')).get('AccountID', '') if batchpayment.get('Account') else ''),
                            'Particulars': str(batchpayment.get('Particulars', '')),
                            'Code': str(batchpayment.get('Code', '')),
                            'Reference': str(batchpayment.get('Reference', '')),
                            'Details': str(batchpayment.get('Details', '')),
                            'Narrative': str(batchpayment.get('Narrative', '')),
                            'Date': str(batchpayment.get('Date', '')),
                            'Payment_PaymentId': str(payments.get('PaymentID', '')),
                            'Payment_InvoiceId':str((payments.get('Invoice', '')).get('InvoiceID', '') if payments.get('Invoice') else ''),
                            'Payment_BankAccountNumber': str(payments.get('BankAccountNumber', '')),
                            'Payment_Particulars': str(payments.get('Particulars', '')),
                            'Payment_Code': str(payments.get('Code', '')),
                            'Payment_Reference': str(payments.get('Reference', '')),
                            'Payment_Details': str(payments.get('Details', '')),
                            'Payment_Amount': str(payments.get('Amount', '')),
                            'Type': str(batchpayment.get('Type', '')),
                            'Status': str(batchpayment.get('Status', '')),
                            'TotalAmount': float(batchpayment.get('TotalAmount', 0)),
                            'IsReconciled': bool(batchpayment.get('IsReconciled', False)),
                            'UpdatedDateUTC': validate_datetime(str(batchpayment.get('UpdatedDateUTC', '')))
                        }
                        combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_batchpayments('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'BatchPaymentId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'BrandingThemes':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, brand in All_Data.iterrows():
                    base_data = {
                        'BrandingThemeId': str(brand.get('BrandingThemeID', '')),
                        'Name': str(brand.get('Name', '')),
                        'SortOrder': str(brand.get('SortOrder', '')),
                        'CreatedDateUTC': str(brand.get('CreatedDateUTC', ''))
                    }
                    combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    WhereClause = ''
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Contacts':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''

            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = ''
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            print(MaxDate)

            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'includeArchived': True, 'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:            
                # 2. Map column and extract line items
                    combined_data = []
                    for index, contacts in All_Data.iterrows():
                        # Extracting the main Contacts details
                        #address
                        addresses = contacts.get('Addresses', '')
                        pobox_address = next((address for address in addresses if address.get('AddressType') == 'POBOX'), None)
                        street_address = next((address for address in addresses if address.get('AddressType') == 'STREET'), None)

                        #phone
                        phones = contacts.get('Phones', '')
                        phone_default = next((phone for phone in phones if phone.get('PhoneType') == 'DEFAULT'), None)
                        phone_fax = next((phone for phone in phones if phone.get('PhoneType') == 'FAX'), None)
                        phone_mobile = next((phone for phone in phones if phone.get('PhoneType') == 'MOBILE'), None)
                        phone_ddi = next((phone for phone in phones if phone.get('PhoneType') == 'DDI'), None)
                        
                        brandingtheme = contacts.get('BrandingTheme', '') if get_value(contacts, 'BrandingTheme') != '' else None

                        base_data = {
                            'ContactId': str(contacts.get('ContactID', '')),
                            'Name': str(contacts.get('Name', '')),
                            'AccountNumber': str(contacts.get('AccountNumber', '')),
                            'ContactNumber': str(contacts.get('ContactNumber', '')),
                            'ContactStatus': str(contacts.get('ContactStatus', '')),
                            'FirstName': str(contacts.get('FirstName', '')),
                            'LastName': str(contacts.get('LastName', '')),
                            'EmailAddress': str(contacts.get('EmailAddress', '')),
                            'SkypeUserName': str(contacts.get('SkypeUserName', '')),

                            # Contact Persons
                            'ContactPerson1_FirstName': str(contacts.get('ContactPerson1_FirstName', '')),
                            'ContactPerson1_LastName': str(contacts.get('ContactPerson1_LastName', '')),
                            'ContactPerson1_EmailAddress': str(contacts.get('ContactPerson1_EmailAddress', '')),
                            'ContactPerson1_IncludeInEmails': bool(contacts.get('ContactPerson1_IncludeInEmails', False)),
                            
                            'ContactPerson2_FirstName': str(contacts.get('ContactPerson2_FirstName', '')),
                            'ContactPerson2_LastName': str(contacts.get('ContactPerson2_LastName', '')),
                            'ContactPerson2_EmailAddress': str(contacts.get('ContactPerson2_EmailAddress', '')),
                            'ContactPerson2_IncludeInEmails': bool(contacts.get('ContactPerson2_IncludeInEmails', False)),

                            'ContactPerson3_FirstName': str(contacts.get('ContactPerson3_FirstName', '')),
                            'ContactPerson3_LastName': str(contacts.get('ContactPerson3_LastName', '')),
                            'ContactPerson3_EmailAddress': str(contacts.get('ContactPerson3_EmailAddress', '')),
                            'ContactPerson3_IncludeInEmails': bool(contacts.get('ContactPerson3_IncludeInEmails', False)),

                            'ContactPerson4_FirstName': str(contacts.get('ContactPerson4_FirstName', '')),
                            'ContactPerson4_LastName': str(contacts.get('ContactPerson4_LastName', '')),
                            'ContactPerson4_EmailAddress': str(contacts.get('ContactPerson4_EmailAddress', '')),
                            'ContactPerson4_IncludeInEmails': bool(contacts.get('ContactPerson4_IncludeInEmails', False)),

                            # Bank and Tax Information
                            'BankAccountDetails': str(contacts.get('BankAccountDetails', '')),
                            'TaxNumber': str(contacts.get('TaxNumber', '')),
                            'AccountsReceivableTaxType': str(contacts.get('AccountsReceivableTaxType', '')),
                            'AccountsPayableTaxType': str(contacts.get('AccountsPayableTaxType', '')),

                            # Street Address Information
                            'Street_AddressLine1': str(street_address.get('AddressLine1', '')) if street_address is not None else '',
                            'Street_AddressLine2': str(street_address.get('AddressLine2', '')) if street_address is not None else '',
                            'Street_AddressLine3': str(street_address.get('AddressLine3', '')) if street_address is not None else '',
                            'Street_AddressLine4': str(street_address.get('AddressLine4', '')) if street_address is not None else '',
                            'Street_City': str(street_address.get('City', '')) if street_address is not None else '',
                            'Street_Region': str(street_address.get('Region', '')) if street_address is not None else '',
                            'Street_PostalCode': str(street_address.get('PostalCode', '')) if street_address is not None else '',
                            'Street_Country': str(street_address.get('Country', '')) if street_address is not None else '',
                            'Street_AttentionTo': str(street_address.get('AttentionTo', '')) if street_address is not None else '',

                            # PO Box Address Information
                            'POBox_AddressLine1': str(pobox_address.get('AddressLine1', '')) if pobox_address is not None else '',
                            'POBox_AddressLine2': str(pobox_address.get('AddressLine2', '')) if pobox_address is not None else '',
                            'POBox_AddressLine3': str(pobox_address.get('AddressLine3', '')) if pobox_address is not None else '',
                            'POBox_AddressLine4': str(pobox_address.get('AddressLine4', '')) if pobox_address is not None else '',
                            'POBox_City': str(pobox_address.get('City', '')) if pobox_address is not None else '',
                            'POBox_Region': str(pobox_address.get('Region', '')) if pobox_address is not None else '',
                            'POBox_PostalCode': str(pobox_address.get('PostalCode', '')) if pobox_address is not None else '',
                            'POBox_Country': str(pobox_address.get('Country', '')) if pobox_address is not None else '',
                            'POBox_AttentionTo': str(pobox_address.get('AttentionTo', '')) if pobox_address is not None else '',

                            # Phone Numbers
                            'DDI_PhoneNumber': str(phone_ddi.get('PhoneNumber', '')) if phone_ddi is not None else '',
                            'DDI_PhoneAreaCode': str(phone_ddi.get('PhoneAreaCode', '')) if phone_ddi is not None else '',
                            'DDI_PhoneCountryCode': str(phone_ddi.get('PhoneCountryCode', '')) if phone_ddi is not None else '',
                            'Default_PhoneNumber': str(phone_default.get('PhoneNumber', '')) if phone_default is not None else '',
                            'Default_PhoneAreaCode': str(phone_default.get('PhoneAreaCode', '')) if phone_default is not None else '',
                            'Default_PhoneCountryCode': str(phone_default.get('PhoneCountryCode', '')) if phone_default is not None else '',
                            'Fax_PhoneNumber': str(phone_fax.get('PhoneNumber', '')) if phone_fax is not None else '',
                            'Fax_PhoneAreaCode': str(phone_fax.get('PhoneAreaCode', '')) if phone_fax is not None else '',
                            'Fax_PhoneCountryCode': str(phone_fax.get('PhoneCountryCode', '')) if phone_fax is not None else '',
                            'Mobile_PhoneNumber': str(phone_mobile.get('PhoneNumber', '')) if phone_mobile is not None else '',
                            'Mobile_PhoneAreaCode': str(phone_mobile.get('PhoneAreaCode', '')) if phone_mobile is not None else '',
                            'Mobile_PhoneCountryCode': str(phone_mobile.get('PhoneCountryCode', '')) if phone_mobile is not None else '',

                            # Additional Fields
                            'UpdatedDateUTC': validate_datetime(str(contacts.get('UpdatedDateUTC', ''))),
                            'ContactGroupId': str(contacts.get('ContactGroupId', '')),
                            'IsSupplier': bool(contacts.get('IsSupplier', False)),
                            'IsCustomer': bool(contacts.get('IsCustomer', False)),
                            'DefaultCurrency': str(contacts.get('DefaultCurrency', '')),
                            'Website': str(contacts.get('Website', '')),
                            'BrandingThemeId': str(brandingtheme.get('BrandingThemeID', '')) if brandingtheme is not None else None,
                            'BrandingThemeName': str(brandingtheme.get('Name', '')) if brandingtheme is not None else None,
                            'PurchasesDefaultAccountCode': str(contacts.get('PurchasesDefaultAccountCode', '')),
                            'SalesDefaultAccountCode': str(contacts.get('SalesDefaultAccountCode', '')),
                            'BatchPayments_BankAccountNumber': str(contacts.get('BatchPayments_BankAccountNumber', '')),
                            'BatchPayments_BankAccountName': str(contacts.get('BatchPayments_BankAccountName', '')),
                            'BatchPayments_Details': str(contacts.get('BatchPayments_Details', '')),
                            'BatchPayments_Code': str(contacts.get('BatchPayments_Code', '')),
                            'BatchPayments_Reference': str(contacts.get('BatchPayments_Reference', '')),

                            # Financial Balances
                            'Discount': float(contacts.get('Discount', 0.00)),
                            'Balances_AccountsReceivable_Outstanding': float(contacts.get('Balances_AccountsReceivable_Outstanding', 0.00)),
                            'Balances_AccountsReceivable_Overdue': float(contacts.get('Balances_AccountsReceivable_Overdue', 0.00)),
                            'Balances_AccountsPayable_Outstanding': float(contacts.get('Balances_AccountsPayable_Outstanding', 0.00)),
                            'Balances_AccountsPayable_Overdue': float(contacts.get('Balances_AccountsPayable_Overdue', 0.00)),

                            # Payment Terms
                            'PaymentTerms_Bills_Day': int(contacts.get('PaymentTerms_Bills_Day', 0)),
                            'PaymentTerms_Bills_Type': str(contacts.get('PaymentTerms_Bills_Type', '')),
                            'PaymentTerms_Sales_Day': int(contacts.get('PaymentTerms_Sales_Day', 0)),
                            'PaymentTerms_Sales_Type': str(contacts.get('PaymentTerms_Sales_Type', '')),

                            # Sales Tracking
                            'SalesTrackingCategory1_Name': str(contacts.get('SalesTrackingCategory1_Name', '')),
                            'SalesTrackingOption1_Name': str(contacts.get('SalesTrackingOption1_Name', '')),
                            'SalesTrackingCategory2_Name': str(contacts.get('SalesTrackingCategory2_Name', '')),
                            'SalesTrackingOption2_Name': str(contacts.get('SalesTrackingOption2_Name', '')),

                            # Purchase Tracking
                            'PurchaseTrackingCategory1_Name': str(contacts.get('PurchaseTrackingCategory1_Name', '')),
                            'PurchaseTrackingOption1_Name': str(contacts.get('PurchaseTrackingOption1_Name', '')),
                            'PurchaseTrackingCategory2_Name': str(contacts.get('PurchaseTrackingCategory2_Name', '')),
                            'PurchaseTrackingOption2_Name': str(contacts.get('PurchaseTrackingOption2_Name', '')),

                            # Attachments and Organization Info
                            'HasAttachments': bool(contacts.get('HasAttachments', False)),
                            'FullAddress': str(contacts.get('FullAddress', '')),
                            'RegionAddress': str(contacts.get('RegionAddress', ''))
                        }
                        combined_data.append(base_data)
                
                # 3. Convert data frame data type to MYSQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_contacts('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'ContactId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Currencies':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0

            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, currency in All_Data.iterrows():
                    base_data = {
                        'Code': str(currency.get('Code', '')),
                        'Description': str(currency.get('Description', '')),
                    }
                    combined_data.append(base_data)
            
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)
        
        elif endpoint == 'InvoicesDraft':
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''
            new_endpoint = 'Invoices'

            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
            base_data = {}
            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize, 'Statuses': 'DRAFT,SUBMITTED'}
                with XeroRequestsManager(new_endpoint,params,str(MaxDate)) as All_Data:
                # 2. Map column and extract line items
                    combined_data = []
                    if len(All_Data) > 0:                         
                        for index, invoice in All_Data.iterrows():
                            for index, line in enumerate(invoice.get('LineItems', []), start=1):
                                base_data = {
                                    'Id': str(index) + '|' +  get_value(invoice,'InvoiceID'),
                                    'InvoiceId':  get_value(invoice,'InvoiceID'),
                                    'Type':  get_value(invoice,'Type'),
                                    'ContactId': get_value(invoice.get('Contact'), 'ContactID'),
                                    'ContactName': get_value(invoice.get('Contact'), 'Name'),
                                    'Date':  get_value(invoice,'DateString'),
                                    'DueDate':  get_value(invoice,'DueDateString'),
                                    'LineAmountTypes':  get_value(invoice,'LineAmountTypes'),
                                    'InvoiceNumber':  get_value(invoice,'InvoiceNumber'),
                                    'Reference':  get_value(invoice,'Reference'),
                                    'BrandingThemeId':  get_value(invoice,'BrandingThemeId'),
                                    'URL':  get_value(invoice,'URL'),
                                    'CurrencyCode':  get_value(invoice,'CurrencyCode'),
                                    'CurrencyRate': validate_float(get_value(invoice,'CurrencyRate')),
                                    'Status':  get_value(invoice,'Status'),
                                    'SentToContact': bool(get_value(invoice,'SentToContact')),
                                    'ExpectedPaymentDate':  validate_datetime(get_value(invoice,'ExpectedPaymentDate')),
                                    'PlannedPaymentDate':  validate_datetime(get_value(invoice,'PlannedPaymentDate')),
                                    'SubTotal': validate_float(get_value(invoice,'SubTotal')),
                                    'TotalTax': validate_float(get_value(invoice,'TotalTax')),
                                    'Total': validate_float(get_value(invoice,'Total')),
                                    'TotalDiscount': validate_float(get_value(invoice,'TotalDiscount')),
                                    'HasAttachments': bool(invoice.get('HasAttachments')),
                                    'AmountDue': validate_float(get_value(invoice,'AmountDue')),
                                    'AmountPaid': validate_float(get_value(invoice,'AmountPaid')),
                                    'CISDeduction': validate_float(get_value(invoice,'CISDeduction')),
                                    'FullyPaidOnDate':  validate_datetime(get_value(invoice,'FullyPaidOnDate')),
                                    'AmountCredited': validate_float(get_value(invoice, 'AmountCredited')),
                                    'UpdatedDateUTC': validate_datetime( get_value(invoice,'UpdatedDateUTC')),
                                    'CreditNotes': invoice.get('CreditNotes', ''),
                                    'Prepayments': invoice.get('Prepayments', ''),
                                    'Payments': invoice.get('Payments', ''),
                                    'Overpayments': invoice.get('Overpayments', ''),
                                    'RepeatingInvoiceID':  get_value(invoice,'RepeatingInvoiceID'),
                                    'LineItem_LineItemId': str(line.get('LineItemID', '')),
                                    'LineItem_Description': str(line.get('Description', '')),
                                    'LineItem_Quantity': validate_float(get_value(line,'Quantity')),
                                    'LineItem_UnitAmount': validate_float(get_value(line,'UnitAmount')),
                                    'LineItem_ItemCode': str(line.get('ItemCode', '')),
                                    'LineItem_AccountCode': str(line.get('AccountCode', '')),
                                    'LineItem_TaxType': str(line.get('TaxType', '')),
                                    'LineItem_TaxAmount': validate_float(get_value(line,'TaxAmount')),
                                    'LineItem_LineAmount': validate_float(get_value(line,'LineAmount')),
                                    'LineItem_DiscountRate': validate_float(get_value(line,'DiscountRate')),
                                    'LineItem_DiscountAmount': validate_float(get_value(line,'DiscountAmount'))
                                }
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')

                                # Extract CreditnoteId values from CreditNotes JSON array and concatenate them
                                credit_notes = invoice.get('CreditNotes', [])
                                creditnote_ids = [credit_note.get('CreditNoteID', '') for credit_note in credit_notes]
                                base_data['CreditNoteIds'] = ','.join(creditnote_ids)

                                # Extract PrepaymentId values from Prepayments JSON array and concatenate them
                                prepayments = invoice.get('Prepayments', [])
                                prepayment_ids = [prepayment.get('PrepaymentID', '') for prepayment in prepayments]
                                base_data['PrepaymentIds'] = ','.join(prepayment_ids)

                                # Extract PaymentId values from Payments JSON array and concatenate them
                                payments = invoice.get('Payments', [])
                                payment_ids = [payment.get('PaymentID', '') for payment in payments]
                                base_data['PaymentIds'] = ','.join(payment_ids)

                                # Extract OverpaymentId values from Overpayments JSON array and concatenate them
                                overpayments = invoice.get('Overpayments', [])
                                overpayment_ids = [overpayment.get('OverpaymentID', '') for overpayment in overpayments]
                                base_data['OverpaymentIds'] = ','.join(overpayment_ids)
                                
                                combined_data.append(base_data)

                    # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                    # 4. Load data to Stage Table
                    WriteMode = "overwrite" if page == 1 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))

                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_invoicesdraft('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'InvoiceId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'RepeatingInvoices':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                if len(All_Data) > 0:                    
                    for index, invoice in All_Data.iterrows():
                        schedule = invoice.get('Schedule', {})
                        lineitems = invoice.get('LineItems', [])
                        base_data = {
                            'RepeatingInvoiceId':  get_nested_value(invoice,'RepeatingInvoiceID'),
                            'Type':  get_nested_value(invoice,'Type'),
                            'ContactId': get_nested_value(invoice, ['Contact', 'ContactID']),
                            'ContactName': get_nested_value(invoice, ['Contact', 'Name']),
                            'Schedule_Period': validate_int(get_nested_value(schedule,'Period')),
                            'Schedule_Unit': get_nested_value(schedule,'Unit'),
                            'Schedule_DueDate': validate_int(get_nested_value(schedule,'DueDate')),
                            'Schedule_DueDateType': get_nested_value(schedule,'DueDateType'),
                            'Schedule_StartDate': validate_datetime(get_nested_value(schedule,'StartDate')),
                            'Schedule_NextScheduledDate': validate_datetime(get_nested_value(schedule,'NextScheduledDate')),
                            'Schedule_EndDate':  validate_datetime(get_nested_value(invoice,'Schedule_EndDate')),
                            'LineItem_LineItemId': get_nested_value(lineitems[0],'LineItemID'),
                            'LineItem_Description': get_nested_value(lineitems[0],'Description'),
                            'LineItem_Quantity': validate_float(get_nested_value(lineitems[0],'Quantity')),
                            'LineItem_UnitAmount': validate_float(get_nested_value(lineitems[0],'UnitAmount')),
                            # 'LineItem_ItemCode': str(lineitems[0].get('LineItem_ItemCode', '')),
                            'LineItem_AccountCode': get_nested_value(lineitems[0],'AccountCode'),
                            'LineItem_TaxType': get_nested_value(lineitems[0],'TaxType'),
                            'LineItem_TaxAmount': validate_float(get_nested_value(lineitems[0],'TaxAmount')),
                            'LineItem_LineAmount': validate_float(get_nested_value(lineitems[0],'LineAmount')),
                            # 'LineItem_DiscountRate': float(lineitems[0].get('LineItem_DiscountRate', 0.0)),
                            'LineAmountTypes':  get_nested_value(invoice,'LineAmountTypes'),
                            'Reference':  get_nested_value(invoice,'Reference'),
                            'BrandingThemeId':  get_nested_value(invoice,'BrandingThemeId'),
                            'CurrencyCode':  get_nested_value(invoice,'CurrencyCode'),
                            'Status':  get_nested_value(invoice,'Status'),
                            'SubTotal': float(invoice.get('SubTotal', 0.0)),
                            'TotalTax': float(invoice.get('TotalTax', 0.0)),
                            'Total': float(invoice.get('Total', 0.0)),
                            'HasAttachments': validate_int(1 if bool(get_nested_value(invoice, 'HasAttachments', False)) else 0),
                            'UpdatedDateUTC': validate_datetime( get_nested_value(invoice,'UpdatedDateUTC'))
                        }
                        # Extract and flatten JSON Array Tracking Categories
                        if 'Tracking' in lineitems and len(lineitems['Tracking']) >= 1:
                            tracking_categories = lineitems['Tracking']
                            base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                            base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                            base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                            base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                            if len(tracking_categories) == 2:
                                base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                        combined_data.append(base_data)
                
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
        
            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            print(ProdCount)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'TaxRates':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, taxrate in All_Data.iterrows():
                    base_data = {
                        'Id': str(taxrate.get('Id', '')),
                        'TaxType': str(taxrate.get('TaxType', '')),
                        'Name': str(taxrate.get('Name', '')),
                        'Status': str(taxrate.get('Status', '')),
                        'ReportTaxType': str(taxrate.get('ReportTaxType', '')),
                        'CanApplyToAssets': bool(taxrate.get('CanApplyToAssets')),
                        'CanApplyToEquity': bool(taxrate.get('CanApplyToEquity')),
                        'CanApplyToExpenses': bool(taxrate.get('CanApplyToExpenses')),
                        'CanApplyToLiabilities': bool(taxrate.get('CanApplyToLiabilities')),
                        'CanApplyToRevenue': bool(taxrate.get('CanApplyToRevenue')),
                        'DisplayTaxRate': float(taxrate.get('DisplayTaxRate', 0)),
                        'EffectiveRate': float(taxrate.get('EffectiveRate', 0)),
                    }
                    if 'TaxComponents' in taxrate and taxrate['TaxComponents'] and len(taxrate['TaxComponents']) >= 1:
                        taxcomponent = taxrate['TaxComponents'][0]
                        base_data['TaxComponent_Name'] = str(taxcomponent.get('Name', ''))
                        base_data['TaxComponent_Rate'] = float(taxrate.get('Rate', 0))
                        base_data['TaxComponents_IsNonRecoverable'] = bool(taxrate.get('IsNonRecoverable'))
                        base_data['TaxComponent_IsCompound'] = bool(taxrate.get('IsCompound'))
                        base_data['TaxComponentAggregate'] = str(taxrate.get('Aggregate', ''))
                    
                    combined_data.append(base_data)
                
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                # display(ConvertedData)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            
            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Users':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, user in All_Data.iterrows():
                    base_data = {
                        'UserId': str(user.get('UserID', '')),
                        'FirstName': str(user.get('FirstName', '')),
                        'LastName': str(user.get('LastName', '')),
                        'EmailAddress': str(user.get('EmailAddress', '')),
                        'UpdatedDateUTC': validate_datetime(str(user.get('UpdatedDateUTC', ''))),
                        'IsSubscriber': bool(user.get('IsSubscriber')),
                        'OrganisationRole': str(user.get('OrganisationRole', '')),
                    }
                    combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'ContactGroups':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
    
            # 1. Request API Call
            All_Data = []
            combined_data = []
            contactgrouplist = XeroRequests(endpoint)
            if len(contactgrouplist) > 0:
                for contactgroupid in contactgrouplist['ContactGroupID']:
                    Raw_Data = XeroRequests(endpoint, id=contactgroupid)
                    All_Data.append(Raw_Data)

            # 2. Map column and extract line items
            if len(All_Data) > 0:
                All_Data = pd.concat(All_Data, ignore_index=True)                
                for index, contactgroupdetails in All_Data.iterrows():
                    base_data = {
                        'Id': get_value(contactgroupdetails, 'ContactGroupID'),
                        'Name': get_value(contactgroupdetails, 'Name'),
                        'ContactGroupId': get_value(contactgroupdetails, 'ContactGroupID'),
                        'Status': get_value(contactgroupdetails, 'Status')
                    }
                    if str(contactgroupdetails.get('Contacts')) != '':
                        for contact in contactgroupdetails.get('Contacts'):
                            base_data['Contact_ContactId'] = get_value(contact, 'ContactID')
                            base_data['Contact_Name'] = get_value(contact, 'Name')
                            combined_data.append(base_data.copy())
                    else:
                        base_data['Contact_ContactId'] = None
                        base_data['Contact_Name'] = None
                        combined_data.append(base_data.copy())

            # 3. Convert data frame data type to MYSQL data type
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

            # 4. Load data to Stage Table
            WriteMode = "overwrite"
            LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
            StageCount = len(ConvertedData)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'ExpenseClaims':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, expenseclaim in All_Data.iterrows():
                    base_data = {
                        'ExpenseClaimID': str(expenseclaim.get('ExpenseClaimID', '')),
                        'Status': str(expenseclaim.get('Status', '')),
                        'UpdatedDateUTC': validate_datetime(str(expenseclaim.get('UpdatedDateUTC', 0))),
                        'Total': float(expenseclaim.get('Total', 0)),
                        'AmountDue': float(expenseclaim.get('AmountDue', 0)),
                        'AmountPaid': float(expenseclaim.get('AmountPaid', 0)),
                        'PaymentDueDate': validate_datetime(str(expenseclaim.get('PaymentDueDate', ''))),
                        'ReportingDate': str(expenseclaim.get('ReportingDate', '')),
                        'UserId': str((expenseclaim.get('User', '').get('UserID', '')) if expenseclaim.get('User', '') else ''),
                    }
                    combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Items':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, item in All_Data.iterrows():
                    base_data = {
                        'ItemId': str(item.get('ItemID', '')),
                        'Code': str(item.get('Code', '')),
                        'InventoryAssetAccountCode': str(item.get('InventoryAssetAccountCode', 0)),
                        'Name': str(item.get('Name', 0)),
                        'PurchaseDescription': str(item.get('PurchaseDescription', 0)),
                        'PurchaseDetails_UnitPrice': str((item.get('PurchaseDetails', '').get('UnitPrice', '')) if item.get('PurchaseDetails', '') else ''),
                        'PurchaseDetails_COGSAccountCode': str((item.get('PurchaseDetails', '').get('COGSAccountCode', '')) if item.get('PurchaseDetails', '') else ''),
                        'PurchaseDetails_AccountCode': str((item.get('PurchaseDetails', '').get('AccountCode', '')) if item.get('PurchaseDetails', '') else ''),
                        'PurchaseDetails_TaxType': str((item.get('PurchaseDetails', '').get('TaxType', '')) if item.get('PurchaseDetails', '') else ''),
                        'SalesDetails_UnitPrice': str((item.get('SalesDetails', '').get('UnitPrice', '')) if item.get('SalesDetails', '') else ''),
                        'SalesDetails_COGSAccountCode': str((item.get('SalesDetails', '').get('COGSAccountCode', '')) if item.get('SalesDetails', '') else ''),
                        'SalesDetails_AccountCode': str((item.get('SalesDetails', '').get('AccountCode', '')) if item.get('SalesDetails', '') else ''),
                        'SalesDetails_TaxType': str((item.get('SalesDetails', '').get('TaxType', '')) if item.get('SalesDetails', '') else ''),
                        'IsTrackedAsInventory': bool(item.get('IsTrackedAsInventory', 0)),
                        'TotalCostPool': float(item.get('TotalCostPool', 0)),
                        'QuantityOnHand': float(item.get('QuantityOnHand', 0)),
                        'IsSold': bool(item.get('IsSold', 0)),
                        'IsPurchased': bool(item.get('IsPurchased', 0)),
                        'UpdatedDateUTC': validate_datetime(str(item.get('UpdatedDateUTC', '')))
                    }
                    combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_items('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW'):
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'PurchaseOrders':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''
            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:
                # 2. Map column and extract line items
                    combined_data = []
                    if len(All_Data) > 0:                        
                        for index, purchaseorder in All_Data.iterrows():
                            for index, line in enumerate(purchaseorder.get('LineItems', []), start=1):
                                base_data = {
                                    'Id': str(index) + '|' + str(purchaseorder.get('PurchaseOrderID', '')),
                                    'PurchaseOrderId': str(purchaseorder.get('PurchaseOrderID', '')),
                                    'PurchaseOrderNumber': str(purchaseorder.get('PurchaseOrderNumber', '')),
                                    'Reference': str(purchaseorder.get('Reference', '')),
                                    'Type': str(purchaseorder.get('Type', '')),
                                    'Contact_ContactId': str((purchaseorder.get('Contact', '')).get('ContactID','')),
                                    'Contact_Name': str((purchaseorder.get('Contact', '')).get('Name','')),
                                    'DeliveryDate': purchaseorder.get('DeliveryDateString'),
                                    'Date': str(purchaseorder.get('DateString', '')),
                                    'Status': str(purchaseorder.get('Status', '')),
                                    'LineAmountTypes': str(purchaseorder.get('LineAmountTypes', '')),
                                    'LineItem_LineItemId': str(line.get('LineItemID', '')),
                                    'LineItem_Description': str(line.get('Description', '')),
                                    'LineItem_Quantity': float(line.get('Quantity', 0)),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount', 0)),
                                    'LineItem_ItemCode': str(line.get('ItemCode', '')),
                                    'LineItem_AccountCode': str(line.get('AccountCode', '')),
                                    'LineItem_TaxType': str(line.get('TaxType', '')),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount', 0)),
                                    'LineItem_LineAmount': float(line.get('LineAmount', 0)),
                                    'LineItem_DiscountRate': float(line.get('DiscountRate', 0)),
                                    'SubTotal': float(purchaseorder.get('SubTotal', 0)),
                                    'TotalTax': float(purchaseorder.get('TotalTax', 0)),
                                    'Total': float(purchaseorder.get('Total', 0)),
                                    'UpdatedDateUTC': validate_datetime(str(purchaseorder.get('UpdatedDateUTC', ''))),
                                    'HasAttachments': bool(purchaseorder.get('HasAttachments', 0)),
                                    'CurrencyCode': str(purchaseorder.get('CurrencyCode', '')),
                                    'BrandingThemeId': str(purchaseorder.get('BrandingThemeId', '')),
                                    'CurrencyRate': float(purchaseorder.get('CurrencyRate', 0)),
                                    'TotalDiscount': float(purchaseorder.get('TotalDiscount', 0)),
                                    'SentToContact': bool(purchaseorder.get('SentToContact', 0)),
                                    'Telephone': str(purchaseorder.get('Telephone', '')),
                                    'IsDiscounted': bool(purchaseorder.get('IsDiscounted', 0)),
                                    'ExpectedArrivalDate': validate_datetime(str(purchaseorder.get('ExpectedArrivalDate', ''))),
                                    'DeliveryInstructions': str(purchaseorder.get('DeliveryInstructions', '')),
                                    'DeliveryAddress': str(purchaseorder.get('DeliveryAddress', ''))
                                }
                                
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')

                                combined_data.append(base_data)

                    # 3. Convert data frame data type to MYSQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                    # 4. Load data to Stage Table
                    WriteMode = "overwrite"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount = len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
                        
                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'PurchaseOrderId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)

        elif endpoint == 'Receipts':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                if len(All_Data) > 0:                    
                    for index, receipt in All_Data.iterrows():
                        for index, line in enumerate(receipt.get('LineItems', []), start=1):
                            base_data = {
                                'Id': str(index) + '|' + str(receipt.get('ReceiptID', '')),
                                'ReceiptId': str(receipt.get('ReceiptId', '')),
                                'Date': str(receipt.get('Date', '')),
                                'Contact_ContactId': str((receipt.get('Contact', '')).get('ContactID','')),
                                'Contact_Name': str((receipt.get('Contact', '')).get('Name','')),
                                'LineItem_Description': str(line.get('Description', '')),
                                'LineItem_UnitAmount': float(line.get('UnitAmount', 0)),
                                'LineItem_AccountCode': str(line.get('AccountCode', '')),
                                'LineItem_Quantity': float(line.get('Quantity', 0)),
                                'LineItem_TaxType': str(line.get('TaxType', '')),
                                'LineItem_LineAmount': float(line.get('LineAmount', 0)),
                                'LineItem_DiscountRate': float(line.get('DiscountRate', 0)),
                                'User_UserId': str((receipt.get('User', '').get('UserID', '')) if receipt.get('User', '') else ''),
                                'Reference': str(purchaseorder.get('Reference', '')),
                                'LineAmountTypes': str(purchaseorder.get('LineAmountTypes', '')),
                                'SubTotal': float(purchaseorder.get('SubTotal', 0)),
                                'TotalTax': float(purchaseorder.get('TotalTax', 0)),
                                'Total': float(purchaseorder.get('Total', 0)),
                                'Status': str(purchaseorder.get('Status', '')),
                                'ReceiptNumber': str(purchaseorder.get('ReceiptNumber', '')),
                                'UpdatedDateUTC': validate_datetime(str(purchaseorder.get('UpdatedDateUTC', ''))),
                                'HasAttachments': bool(purchaseorder.get('HasAttachments', 0)),
                                'URL': str(purchaseorder.get('URL', ''))
                            }
                            
                            # Extract and flatten JSON Array Tracking Categories
                            if 'Tracking' in line and len(line['Tracking']) >= 1:
                                tracking_categories = line['Tracking']
                                base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                if len(tracking_categories) == 2:
                                    base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                
                            combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0

            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'TrackingCategories':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            params = {'includeArchived': True}
            with XeroRequestsManager(endpoint, params) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                if len(All_Data) > 0:                    
                    for index, trackingcategory in All_Data.iterrows():
                        for index, line in enumerate(trackingcategory.get('Options', []), start=1):
                            base_data = {
                                'Id': str(index) + '|' + str(trackingcategory.get('TrackingCategoryID', '')),
                                'TrackingCategoryId': str(trackingcategory.get('TrackingCategoryID', '')),
                                'Name': str(trackingcategory.get('Name', '')),
                                'Status': str(trackingcategory.get('Status', '')),
                                'TrackingOptionId': str(line.get('TrackingOptionID', '')),
                                'OptionName': str(line.get('Name', '')),
                                'OptionStatus': str(line.get('Status', ''))
                            }
                
                            combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination in ('DW', 'EVADW') and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Employees':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                if len(All_Data) > 0:                    
                    for index, employee in All_Data.iterrows():
                        base_data = {
                            'EmployeeId': str(employee.get('EmployeeID', '')),
                            'Status': str(employee.get('Status', '')),
                            'FirstName': str(employee.get('FirstName', '')),
                            'LastName': str(employee.get('LastName', '')),
                            'ExternalLink_URL': str((employee.get('ExternalLink', '')).get('URL', '') if employee.get('ExternalLink', '') else ''),
                            'ExternalLink_Description': str((employee.get('ExternalLink', '')).get('Description', '') if employee.get('ExternalLink', '') else ''),
                            'UpdatedDateUTC': validate_datetime(str(employee.get('ExternalLink_Description', '')))
                        }
            
                        combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'LinkedTransactions':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000

            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint, params) as All_Data:
                # 2. Map column and extract line items
                    combined_data = []
                    if len(All_Data) > 0:                        
                        for index, linkedtransaction in All_Data.iterrows():
                            base_data = {
                                'LinkedTransactionID': str(linkedtransaction.get('LinkedTransactionID', '')),
                                'SourceTransactionID': str(linkedtransaction.get('SourceTransactionID', '')),
                                'SourceLineItemID': str(linkedtransaction.get('SourceLineItemID', '')),
                                'SourceTransactionTypeCode': str(linkedtransaction.get('SourceTransactionTypeCode', '')),
                                'ContactID': str(linkedtransaction.get('ContactID', '')),
                                'TargetTransactionID': str(linkedtransaction.get('TargetTransactionID', '')),
                                'TargetLineItemID': str(linkedtransaction.get('TargetLineItemID', '')),
                                'Status': str(linkedtransaction.get('Status', '')),
                                'Type': str(linkedtransaction.get('Type', '')),
                                'UpdatedDateUTC': validate_datetime(str(linkedtransaction.get('UpdatedDateUTC', '')))
                            }
                
                            combined_data.append(base_data)

                # 3. Convert data frame data type to MYSQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount = len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
                        
                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    WriteMode = 'append'
            #    UniqueKey = ''
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate)

        elif endpoint == 'Quotes':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            page = 1
            pagesize = 1000
            MaxDate = ''
            # 0. Log LastRefreshDate record
            filterParameter = GetMaxFilterParameter(endpoint, ProdTable, 'EVA')
            if str(filterParameter) == '2000-01-01 00:00:00':
                LoadType = 'Full'
                MaxDate = None
            else:
                LoadType = 'Latest'
                MaxDate = filterParameter
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            while True: # Loop until all data is retrieved
                params = {'page': page, 'pagesize': pagesize}
                with XeroRequestsManager(endpoint,params,str(MaxDate)) as All_Data:
            # 2. Map column and extract line items
                    combined_data = []
                    if len(All_Data) > 0:                        
                        for index, quote in All_Data.iterrows():
                            for index, line in enumerate(quote.get('LineItems', []), start=1):
                                base_data = {
                                    'Id': str(index) + '|' + str(quote.get('QuoteID', '')),
                                    'QuoteId': str(quote.get('QuoteID', '')),
                                    'Contact_ContactId': get_nested_value(quote, 'Contact, ContactID'),
                                    'Contact_Name': get_nested_value(quote, 'Contact, Name'),
                                    'Date': str(quote.get('DateString')),
                                    'ExpiryDate': str(quote.get('ExpiryDateString')),
                                    'Status': str(quote.get('Status', '')),
                                    'LineItem_LineItemId': str(line.get('LineItemID', '')),
                                    'LineItem_Description': str(line.get('Description', '')),
                                    'LineItem_Quantity': float(line.get('Quantity')),
                                    'LineItem_UnitAmount': float(line.get('UnitAmount')),
                                    'LineItem_ItemCode': str(line.get('ItemCode', '')),
                                    'LineItem_AccountCode': str(line.get('AccountCode', '')),
                                    'LineItem_TaxType': str(line.get('TaxType', '')),
                                    'LineItem_TaxAmount': float(line.get('TaxAmount')),
                                    'LineItem_LineAmount': float(line.get('LineAmount')),
                                    'LineItem_DiscountRate': float(line.get('DiscountRate')),
                                    'QuoteNumber': str(quote.get('QuoteNumber', '')),
                                    'LineAmountTypes': str(quote.get('LineAmountTypes', '')),
                                    'Reference': str(quote.get('Reference', '')),
                                    'CurrencyCode': str(quote.get('CurrencyCode', '')),
                                    'CurrencyRate': float(quote.get('CurrencyRate', 0)),
                                    'SubTotal': float(quote.get('SubTotal', 0)),
                                    'TotalTax': float(quote.get('TotalTax', 0)),
                                    'Total': float(quote.get('Total', 0)),
                                    'BrandingThemeId': str(quote.get('BrandingThemeId', '')),
                                    'TotalDiscount': float(quote.get('TotalDiscount', 0)),
                                    'Terms': str(quote.get('Terms', '')),
                                    'Title': str(quote.get('Title', '')),
                                    'Summary': str(quote.get('Summary', '')),
                                    'UpdatedDateUTC': validate_datetime(str(quote.get('UpdatedDateUTC', '')))
                                }
                                
                                # Extract and flatten JSON Array Tracking Categories
                                if 'Tracking' in line and len(line['Tracking']) >= 1:
                                    tracking_categories = line['Tracking']
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                    base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                    if len(tracking_categories) == 2:
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')

                                combined_data.append(base_data)

                    # 3. Convert data frame data type to MYSQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                    # 4. Load data to Stage Table
                    WriteMode = "overwrite"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount = len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
                    
                    # assuming 1000 is the maximum number of results per page
                    if len(All_Data) < pagesize:
                        break
                    page += 1

            # 5. Transform and Load Stage data to Prod Table
            # ExecuteEvaSP(SPName, endpoint)
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

            # 6. Load data to DW Prod
            #if DB_Destination == 'DW' and ProdCount > 0:
            #    MaxDate = GetMaxFilterParameter(endpoint, DWProdTable, 'DW')
            #    WriteMode = 'append'
            #    WhereClause = f"AND UpdatedDateUTC >= '{MaxDate}'" if str(MaxDate) != '2000-01-01 00:00:00' and MaxDate != None else ''
            #    UniqueKey = 'QuoteId'
            #    future = TriggerLoadToDWThread(endpoint, ProdTable, DWProdTable, UniqueKey, WriteMode, StartUTCDate, WhereClause)
        
        elif endpoint == 'BalanceSheet':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            
            # 0. Log LastRefreshDate record
            #timeframe=MONTH&periods=11
            params = {'timeframe': 'MONTH', 'periods': 11}
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint, params) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, Reports in All_Data.iterrows():
                    Rows = Reports.get('Rows', '')
                    for i, row in enumerate(Rows):
                        RowType = row['RowType']
                        if RowType == 'Header':
                            Cells = row['Cells']
                            base_data = {
                                'ID': i
                                ,'Title': None
                                ,'Label1': Cells[0]['Value']
                                ,'Label2': Cells[1]['Value']
                                ,'Label3': Cells[2]['Value']
                                ,'Label4': Cells[3]['Value']
                                ,'Label5': Cells[4]['Value']
                                ,'Label6': Cells[5]['Value']
                                ,'Label7': Cells[6]['Value']
                                ,'Label8': Cells[7]['Value']
                                ,'Label9': Cells[8]['Value']
                                ,'Label10': Cells[9]['Value']
                                ,'Label11': Cells[10]['Value']
                                ,'Label12': Cells[11]['Value']
                                ,'Label13': Cells[12]['Value']
                                ,'AccountId': None
                            }
                            print(base_data)
                            combined_data.append(base_data)
                        elif RowType == 'Section':
                            base_data = {
                                'ID': Row
                                ,'Title': None
                                ,'Label1': Cells[0]['Value']
                                ,'Label2': Cells[1]['Value']
                                ,'Label3': Cells[2]['Value']
                                ,'Label4': Cells[3]['Value']
                                ,'Label5': Cells[4]['Value']
                                ,'Label6': Cells[5]['Value']
                                ,'Label7': Cells[6]['Value']
                                ,'Label8': Cells[7]['Value']
                                ,'Label9': Cells[8]['Value']
                                ,'Label10': Cells[9]['Value']
                                ,'Label11': Cells[10]['Value']
                                ,'Label12': Cells[11]['Value']
                                ,'Label13': Cells[12]['Value']
                                ,'AccountId': None
                            }
                            combined_data.append(base_data)
            
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
            
            # 5. Transform and Load Stage data to Prod Table            
            ExecuteEvaSP(SPName, endpoint, error_list)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            
        elif endpoint == 'BankSummary':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            with XeroRequestsManager(endpoint) as All_Data:
                # 2. Map column and extract line items
                combined_data = []
                for index, Reports in All_Data.iterrows():
                    Rows = Reports.get('Rows', '')
                    for i, row in enumerate(Rows):
                        RowType = row['RowType']
                        if RowType == 'Section':
                            rowRows = row['Rows']
                            for i, rowrow in enumerate(rowRows, start=1):
                                Cells = rowrow['Cells']
                                if rowrow['RowType'] == 'Row':
                                    attributes = Cells[0]['Attributes']
                                    accountID = attributes[0]['Value']
                                else:
                                    accountID = None
                                base_data = {
                                    'ID': i
                                    ,'BankAccount': Cells[0]['Value']
                                    ,'AccountId': accountID
                                    ,'OpeningBalance': Cells[1]['Value']
                                    ,'CashReceived': Cells[2]['Value']
                                    ,'CashSpent': Cells[3]['Value']
                                    ,'ClosingBalance': Cells[4]['Value']
                                }
                                combined_data.append(base_data)
            
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
            
            # 5. Transform and Load Stage data to Prod Table
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            
        elif endpoint == 'TrialBalance':
            LoadType = 'Full'
            StageCount = 0
            ProdCount = 0
            
            # 0. Log LastRefreshDate record
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)

            # 1. Request API Call
            BeginDate = '2019-07-01'
            EndDate = '2026-06-30'
            All_Data = []
            combined_data = []
            monthly_ranges = generate_date_ranges(BeginDate, EndDate, date_range='month')
            for monthly_range in monthly_ranges:
                end_date = monthly_range[1]
                param = {'date': end_date}
                All_Data = XeroRequests(endpoint, param)
                
                # 2. Map column and extract line items
                if len(All_Data) > 0:
                    for index, Reports in All_Data.iterrows():
                        Rows = Reports.get('Rows', '')
                        for index, row in enumerate(Rows):
                            RowType = row['RowType']
                            if RowType == 'Section':
                                title = row['Title']
                                rowRows = row['Rows']
                                for i, rowrow in enumerate(rowRows, start=1):
                                    Cells = rowrow['Cells']
                                    if rowrow['RowType'] == 'Row':
                                        attributes = Cells[0]['Attributes']
                                        accountID = attributes[0]['Value']
                                    else:
                                        accountID = None
                                    base_data = {
                                        'ID': len(combined_data)+1
                                        ,'Date': end_date
                                        ,'Title': title
                                        ,'Account': Cells[0]['Value']
                                        ,'Debit': Cells[1]['Value']
                                        ,'Credit': Cells[2]['Value']
                                        ,'YTDDebit': Cells[3]['Value']
                                        ,'YTDCredit': Cells[4]['Value']
                                        ,'AccountId': accountID
                                    }
                                    # print(base_data)
                                    combined_data.append(base_data)
            
                # 3. Convert data frame data type to MYSQL data type
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
            
            # 5. Transform and Load Stage data to Prod Table
            ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_default('{endpoint.lower()}','{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)

    except Exception as e:
        ErrorDetails = f"{endpoint} - An error occurred while processing: {str(e)}"
        print(ErrorDetails)
        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Failed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount, ErrorDetails)
        error_list.append(ErrorDetails)

def get_nested_value(data, keys, default=""):
    """Safely get a nested value from a dictionary."""
    if not isinstance(data, dict):  
        return default  # Ensure data is a dictionary
    
    if isinstance(keys, str):  
        return str(data.get(keys, default))  # Single key case

    value = data  
    try:
        for key in keys:
            if isinstance(value, dict):
                value = value.get(key, default)  
            else:
                return default  # If a non-dict is encountered, return default
    except Exception:
        return default

    return str(value) if value is not None else default

def validate_int(value):
    try:
        # Convert to Decimal, ensuring valid numeric format
        return int(value)
    except (TypeError, ValueError, InvalidOperation):
        # Default to None if value is missing or invalid
        return 0

def validate_float(value):
    try:
        # Convert to Decimal, ensuring valid numeric format
        return float(value)
    except (TypeError, ValueError, InvalidOperation):
        # Default to None if value is missing or invalid
        return 0

def validate_datetime(date_str):
    try:
        if isinstance(date_str, tuple):  # Unpack tuple if necessary
            date_str = date_str[0]
            
        if not date_str or str(date_str).strip().lower() in ('', 'nan', 'none', 'null'):
            return None  # Handle NaN/NULL values

        if not date_str or date_str.strip() == '':
            return None  # Return NULL equivalent
        
        if isinstance(date_str, float) and math.isnan(date_str):  # Handle NaN floats
            return None
        
        # Match the Date(1518685950940+0000) format using regex
        match = re.match(r"/Date\((\d+)(?:[+-]\d{4})?\)", str(date_str))
        if match:
            timestamp_ms = int(match.group(1))  # Extract timestamp in milliseconds
            timestamp_sec = timestamp_ms / 1000  # Convert to seconds
            # return datetime.utcfromtimestamp(timestamp_sec).strftime("%Y-%m-%d %H:%M:%S")
            return datetime.fromtimestamp(timestamp_sec, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S")

        # If it's a normal datetime string, try parsing it
        return datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d %H:%M:%S")

    except (ValueError, TypeError) as ex:
        print(f"error converting datetime: {ex}")
        return None  # Return NULL equivalent for invalid values
    except:
        return None

def CheckAndInitIndexes():
    """
    Create indexes on PRODUCTION tables, with deduplication.
    Stage table indexes are handled in ExtractAPIResponse.
    """
    try:
        
        # Stage Tables
        Add_StageId_Generic_Index("overpayments","OrganisationId,OverPaymentId")
        Add_StageId_Generic_Index("overpayments","CurrencyCode,Date")        
        Add_StageId_Generic_Index("prepayments","CurrencyCode,Date")        
        Add_StageId_Generic_Index("Invoices", "InvoiceId")        
        Add_StageId_Generic_Index("ManualJournals", "ManualJournalId")
        Add_StageId_Generic_Index("Payments", "PaymentId")
        Add_StageId_Generic_Index("BankTransactions", "BankTransactionId")    
        Add_StageId_Generic_Index("BatchPayments", "BatchPaymentId")
        
        # this table is now being created and removed in the dynamic transactionsblend sp
        # Add_StageId_Generic_Index("transactionsblend","OrganisationID,JournalLine_AccountCode")
        # Add_StageId_Generic_Index("transactionsblend", "SourceId,OrganisationID,JournalDate,JournalLine_NetAmount")
        # Add_StageId_Generic_Index("transactionsblend", "ContactSource,Changes")   
        Add_StageId_Generic_Index(f"Payments","OrganisationId,PaymentId,InvoiceId,PaymentType,Amount")
        # TransactionsBlend (Production Table)
        # Add_ClientTable_Index("TransactionsBlend", "OrganisationID,JournalLine_JournalLineId")
        # Add_ClientTable_Index("TransactionsBlend", "JournalDate") # For ROW_NUMBER()
        # Add_ClientTable_Index("TransactionsBlend", "JournalLine_AccountId,OrganisationID")

        # Journals (Production Table)
        Add_ClientTable_Index("Journals", "OrganisationId, SourceId")
        Add_ClientTable_Index("Journals", "JournalLine_JournalLineId") # Crucial for joins
        Add_ClientTable_Index("Journals", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount") # For joining with Transactions
        Add_ClientTable_Index("Journals", "JournalDate")
        Add_ClientTable_Index("Journals", "JournalId") # helpful for look ups
        # --- STAGE TABLE INDEX CREATION 
        Add_StageId_Generic_Index("Journals", "OrganisationId, SourceId")
        Add_StageId_Generic_Index("Journals", "JournalLine_JournalLineId")
        Add_StageId_Generic_Index("Journals", "OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount")
        Add_StageId_Generic_Index("Journals", "JournalDate") #good to have date
        Add_StageId_Generic_Index("Journals", "JournalId") #good to have JournalID

        # JournalsCash (Production Table)
        Add_ClientTable_Index("JournalsCash", "OrganisationId, SourceId")
        Add_ClientTable_Index("JournalsCash", "JournalLine_JournalLineId") # Crucial for joins
        Add_ClientTable_Index("JournalsCash", "OrganisationID,JournalLine_AccountCode,JournalLine_NetAmount") # For joining with Transactions
        Add_ClientTable_Index("JournalsCash", "JournalDate")
        Add_ClientTable_Index("JournalsCash", "JournalId")# helpful for look ups
        # --- STAGE TABLE INDEX CREATION 
        Add_StageId_Generic_Index("JournalsCash", "OrganisationId, SourceId")
        Add_StageId_Generic_Index("JournalsCash", "JournalLine_JournalLineId")
        Add_StageId_Generic_Index("JournalsCash", "OrganisationID, JournalLine_AccountCode, JournalLine_NetAmount")
        Add_StageId_Generic_Index("JournalsCash", "JournalDate") #good to have date
        Add_StageId_Generic_Index("JournalsCash", "JournalId")#good to have JournalID

        # Transactions (Production Table)
        Add_ClientTable_Index("Transactions", "OrganisationId,Id")
        Add_ClientTable_Index("Transactions", "OrganisationID,AccountCode,LineAmount") # Composite for join

       # --- Other tables (Keep existing calls) ---        
        Add_ClientTable_Index("creditnotes","OrganisationId,CreditNoteId")        
        Add_ClientTable_Index("invoices", "OrganisationId,InvoiceId")     
        Add_ClientTable_Index("Invoices", "OrganisationId")
        Add_ClientTable_Index("Invoices", "InvoiceId")
        Add_ClientTable_Index("Invoices", "InvoiceId,UpdatedDateUTC")
        Add_ClientTable_Index("Invoices", "OrganisationID,InvoiceId")
        Add_ClientTable_Index("BankTransactions", "OrganisationId")
        Add_ClientTable_Index("BankTransactions", "BankTransactionId")
        Add_ClientTable_Index("BankTransactions", "OrganisationId,BankTransactionId")
        Add_ClientTable_Index("BankTransactions", "LineItem_LineItemId")
        Add_ClientTable_Index("BankTransactions", "BankTransactionId,LineItem_LineItemId")
        Add_ClientTable_Index("banktransfers","OrganisationId,BankTransferId")
        Add_ClientTable_Index("BatchPayments", "OrganisationId,BatchPaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,PaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,UpdatedDateUTC")
        Add_ClientTable_Index("Payments", "OrganisationID,InvoiceId,PaymentId")
        Add_ClientTable_Index("Payments", "OrganisationID,InvoiceId,PaymentType")
        Add_ClientTable_Index("accounts", "OrganisationID,Code")
        Add_ClientTable_Index("accounts", "SystemAccount")
        Add_ClientTable_Index("accounts", "AccountId,OrganisationID")
        Add_ClientTable_Index("accounts", "AccountId")  # Add this
        Add_ClientTable_Index("OverPayments", "OrganisationID,OverpaymentId")
        Add_ClientTable_Index("PrePayments", "OrganisationID,PrepaymentId")
        Add_ClientTable_Index("Contacts", "OrganisationID,ContactId")
        Add_ClientTable_Index("ManualJournals", "OrganisationId,ManualJournalId")
        Add_ClientTable_Index("organisationsclients", "OrganisationID,BaseCurrency")


    except TypeError as e:
        if "missing 1 required positional argument" in str(e):
            print(f"Error in index creation: {e}")
        else:
            raise
    except Exception as e:
        print(f"Unexpected error in CheckAndInitIndexes: {e}")

def get_value(obj, key, default=''):
    return str(obj.get(key, default) or '') if not pd.isna(obj.get(key)) else default

def get_nested_value(data, keys, default=''):
    """Safely get nested values from a dictionary."""
    if not isinstance(data, dict):
        return default
    for key in keys:
        data = data.get(key, {})
        if not isinstance(data, dict):
            return default
    return data

def check_object_exists(object_name, endpoint):
    if object_name == 'reconciliation_table':
        procedure_name = sqlobj.reconciliation_table
    ExecuteEvaSP(procedure_name, endpoint, error_list, query=True)

def get_reconciliation_details(endpoint, id=0):
    TaskName = 'get_reconciliation_details'    
    SPName = f"CALL sp_dynamic_xeroblue_reconciliation({id},'{endpoint}',{ClientIdNumber},{EtaniOrganisationID},{LegacyOrganisationID})"
    LoggingDetails(TaskName, f"{endpoint} - Executing Stored Procedure: {SPName}",  JOB_ID, JOB_RUN_ID, error_list)
    
    if endpoint in ('Journals', 'JournalsCash') and id == 0:
        dfrecon = ReadMySQLTable(f'{SPName}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
        recon_message = dfrecon.loc[0, 'comment']
        recon_id = dfrecon.loc[0, 'id']
        if 'missingJournalNumbers' in recon_message:
            recon_message_to_json = json.loads(recon_message)
            missing_ids = recon_message_to_json[0]['missingJournalNumbers']
            journalnumbers = []
            offsets = []
            for journalnumber in missing_ids:
                if '-' in journalnumber:
                    journalnumber = journalnumber.split('-')
                    min_journalnumber = int(journalnumber[0])
                    max_journalnumber = int(journalnumber[1])
                    for i in range(min_journalnumber, max_journalnumber+1):
                        journalnumbers.append(i)
                        rounded = round(i/100)*100
                        offsets.append(rounded if i > rounded else rounded-100)
                else:
                    journalnumbers.append(int(journalnumber))
                    rounded = round(int(journalnumber)/100)*100
                    offsets.append(rounded if int(journalnumber) > rounded else rounded-100)
            return journalnumbers, offsets, recon_id
        else:
            return [], [], recon_id
    else:
        dfrecon = ReadMySQLTable(f'{SPName}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)

def reconciliation_process(endpoint):
    try:
        LoadType = 'Latest'
        StageCount = 0
        ProdCount = 0
        StartUTCDate = datetime.now(timezone.utc)
        StageTable = TablePrefixEVA + endpoint + 'STAGE'
        ProdTable = TablePrefixEVA.replace('_'+str(EtaniOrganisationID), '') + endpoint
        
        if endpoint == 'Journals':
            StageCount = 0
            ProdCount = 0
            
            # 0. Get Max JournalNumber
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
            journalnumbers, offsets, recon_id = get_reconciliation_details(endpoint)
        
            # params = {'offset': 47400}
            # All_Data = XeroRequests(endpoint, params)
            
            # 1. Request API Call
            if len(offsets) > 0:
                distinct_offsets = sorted(list(set(offsets)))
                for loop, offset in enumerate(distinct_offsets):
                    params = {'offset': offset}
                    All_Data = XeroRequests(endpoint, params)
                    
                    # 2. Map column and extract line items
                    if len(All_Data) > 0:
                        All_Data = All_Data[All_Data['JournalNumber'].isin(journalnumbers)]
                        combined_data = []
                        for index, journal in All_Data.iterrows():
                            if 'JournalLineID' in journal:
                                for index, line in enumerate(journal.get('JournalLines', []), start=1):
                                    base_data = {
                                        'Id':  str(index) + '|' + journal.get('JournalID', ''),
                                        'JournalId': journal.get('JournalID', ''),
                                        'JournalDate': journal.get('JournalDate', ''),
                                        'JournalNumber': journal.get('JournalNumber', ''),
                                        'CreatedDateUTC': journal.get('CreatedDateUTC', ''),
                                        'Reference': journal.get('Reference', ''),
                                        'SourceId': journal.get('SourceID', ''),
                                        'SourceType': journal.get('SourceType', ''),
                                        'JournalLine_JournalLineId': line.get('JournalLineID', ''),
                                        'JournalLine_Description': line.get('Description', ''),
                                        'JournalLine_AccountId': line.get('AccountID', ''),
                                        'JournalLine_AccountCode': line.get('AccountCode', ''),
                                        'JournalLine_AccountType': line.get('AccountType', ''),
                                        'JournalLine_AccountName': line.get('AccountName', ''),
                                        'JournalLine_NetAmount': line.get('NetAmount', ''),
                                        'JournalLine_GrossAmount': line.get('GrossAmount', ''),
                                        'JournalLine_TaxAmount': line.get('TaxAmount', ''),
                                        'JournalLine_TaxType': line.get('TaxType', ''),
                                        'JournalLine_TaxName': line.get('TaxName', ''),
                                        'isvisible': True
                                    }
                                    # Extract and flatten JSON Array Tracking Categories
                                    if 'TrackingCategories' in line and len(line['TrackingCategories']) >= 1:
                                        tracking_categories = line['TrackingCategories']
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                        if len(tracking_categories) == 2:
                                            base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                            base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                            base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                            base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                    combined_data.append(base_data.copy())
                            else:
                                base_data = {
                                    'Id':  str(index) + '|' + journal.get('JournalID', ''),
                                    'JournalId': journal.get('JournalID', ''),
                                    'JournalDate': journal.get('JournalDate', ''),
                                    'JournalNumber': journal.get('JournalNumber', ''),
                                    'CreatedDateUTC': journal.get('CreatedDateUTC', ''),
                                    'Reference': journal.get('Reference', ''),
                                    'SourceId': journal.get('SourceID', ''),
                                    'SourceType': journal.get('SourceType', ''),
                                    'isvisible': False
                                }
                                combined_data.append(base_data.copy())

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if loop == 0 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))
        
            # 5. Transform and Load Stage data to Prod Table
            if len(journalnumbers) > 0:
                ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_journals('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            get_reconciliation_details(endpoint, recon_id)
            
        elif endpoint == 'JournalsCash':
            StageCount = 0
            ProdCount = 0
            
            # 0. Get Max JournalNumber
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
            journalnumbers, offsets, recon_id = get_reconciliation_details(endpoint)
            
            # 1. Request API Call
            if len(offsets) > 0:
                distinct_offsets = sorted(list(set(offsets)))
                for loop, offset in enumerate(distinct_offsets):
                    params = {'offset': offset, 'paymentsOnly': True}
                    All_Data = XeroRequests(endpoint.replace('Cash', ''), params)
                    
                    # 2. Map column and extract line items
                    if len(All_Data) > 0:
                        All_Data = All_Data[All_Data['JournalNumber'].isin(journalnumbers)]
                        combined_data = []
                        for index, journal in All_Data.iterrows():
                            if 'JournalLineID' in journal:
                                for index, line in enumerate(journal.get('JournalLines', []), start=1):
                                    base_data = {
                                        'Id':  str(index) + '|' + journal.get('JournalID', ''),
                                        'JournalId': journal.get('JournalID', ''),
                                        'JournalDate': journal.get('JournalDate', ''),
                                        'JournalNumber': journal.get('JournalNumber', ''),
                                        'CreatedDateUTC': journal.get('CreatedDateUTC', ''),
                                        'Reference': journal.get('Reference', ''),
                                        'SourceId': journal.get('SourceID', ''),
                                        'SourceType': journal.get('SourceType', ''),
                                        'JournalLine_JournalLineId': line.get('JournalLineID', ''),
                                        'JournalLine_Description': line.get('Description', ''),
                                        'JournalLine_AccountId': line.get('AccountID', ''),
                                        'JournalLine_AccountCode': line.get('AccountCode', ''),
                                        'JournalLine_AccountType': line.get('AccountType', ''),
                                        'JournalLine_AccountName': line.get('AccountName', ''),
                                        'JournalLine_NetAmount': line.get('NetAmount', ''),
                                        'JournalLine_GrossAmount': line.get('GrossAmount', ''),
                                        'JournalLine_TaxAmount': line.get('TaxAmount', ''),
                                        'JournalLine_TaxType': line.get('TaxType', ''),
                                        'JournalLine_TaxName': line.get('TaxName', ''),
                                        'isvisible': True
                                    }
                                    # Extract and flatten JSON Array Tracking Categories
                                    if 'TrackingCategories' in line and len(line['TrackingCategories']) >= 1:
                                        tracking_categories = line['TrackingCategories']
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryId'] = tracking_categories[0].get('TrackingCategoryID', '')
                                        base_data[f'LineItem_TrackingCategory{1}_CategoryName'] = tracking_categories[0].get('Name', '')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionID'] = tracking_categories[0].get('TrackingOptionID', '')
                                        base_data[f'LineItem_TrackingCategory{1}_OptionName'] = tracking_categories[0].get('Option', '')
                                        if len(tracking_categories) == 2:
                                            base_data[f'LineItem_TrackingCategory{2}_CategoryId'] = tracking_categories[1].get('TrackingCategoryID', '')
                                            base_data[f'LineItem_TrackingCategory{2}_CategoryName'] = tracking_categories[1].get('Name', '')
                                            base_data[f'LineItem_TrackingCategory{2}_OptionID'] = tracking_categories[1].get('TrackingOptionID', '')
                                            base_data[f'LineItem_TrackingCategory{2}_OptionName'] = tracking_categories[1].get('Option', '')
                                    combined_data.append(base_data.copy())
                            else:
                                base_data = {
                                    'Id':  str(index) + '|' + journal.get('JournalID', ''),
                                    'JournalId': journal.get('JournalID', ''),
                                    'JournalDate': journal.get('JournalDate', ''),
                                    'JournalNumber': journal.get('JournalNumber', ''),
                                    'CreatedDateUTC': journal.get('CreatedDateUTC', ''),
                                    'Reference': journal.get('Reference', ''),
                                    'SourceId': journal.get('SourceID', ''),
                                    'SourceType': journal.get('SourceType', ''),
                                    'isvisible': False
                                }
                                combined_data.append(base_data.copy())

                # 3. Convert data frame data type to SQL data type
                    Combined_Data = pd.DataFrame(combined_data)
                    ConvertedData = ConvertDataTypes(Combined_Data, endpoint)

                # 4. Load data to Stage Table
                    WriteMode = "overwrite" if loop == 0 else "append"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount += len(ConvertedData)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, str(StageCount))
        
            # 5. Transform and Load Stage data to Prod Table
            if len(journalnumbers) > 0:
                ExecuteEvaSP(f"CALL sp_dynamic_xeroblue_journalscash('{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            dfProdCount = ReadMySQLTable(f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            ProdCount = dfProdCount.loc[0, 'Count'] if dfProdCount is not None else 0
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            get_reconciliation_details(endpoint, recon_id)
    
    except Exception as e:
        ErrorDetails = f"{endpoint} - An error occurred while processing: {str(e)}"
        print(ErrorDetails)
        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Failed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount, ErrorDetails)
        error_list.append(ErrorDetails)

# Package Start
CustomStatuses = {
    1 : 'Active',
    2 : 'Inactive',
    9 : 'Provisioning New Data',
    12 : 'Updating Data',
    13 : 'Disconnected',
    16: 'Resetting Data'
}
start_time = time.time()
print(f"Start Data Reconciliation [{datetime.fromtimestamp(start_time)}]")

# Initialize container log for query monitoring
print("[Container Monitoring] Initializing container log...")
container_log_id = start_container_log(
    integration='xero_sync',
    organisation_id=int(EtaniOrganisationID),
    client_id=int(ClientIdNumber) if ClientIdNumber else None,
    job_id=int(JOB_ID) if JOB_ID else None,
    job_run_id=int(JOB_RUN_ID) if JOB_RUN_ID else None,
    trigger_type=TRIGGER_TYPE
)
if container_log_id:
    print(f"[Container Monitoring] Container log created: {container_log_id}")
else:
    print("[Container Monitoring] Container log creation skipped or failed")

#FirmId = get_firm_id(error_list, ClientIdNumber)

FirmCode = {
    'RJSANDERSON'
}
OrganisationID = 0

for code in FirmCode:
    OrganisationID = 0 if len(FirmCode) > 1 else OrganisationID
    df = GetCMSDetails(code, OrganisationID)
    for row in df.itertuples():
        try:
            OrgStatus = row.Status
            EtaniClientID = row.EtaniClientID
            EtaniOrganisationID = row.EtaniOrganisationID
            LegacyClientID = row.LegacyClientID
            LegacyOrganisationID = row.LegacyOrganisationID
            ClientIdNumber = EtaniClientID
            FirmID = row.FirmID
            XeroTenantID = row.tenantId
            TokenFileName = f'{LegacyClientID}_{LegacyOrganisationID}.txt'
            lock = FileLock(f"{TokenFileName}.lock")
        except SQLAlchemyError as sqlerr:
            LegacyOrganisationID = 0
            LoggingDetails("GetCMSDetails", f"MySQL Error: {sqlerr}", JOB_ID, JOB_RUN_ID, error_list)
            params = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Failed",
                            "p_log_id": log_id,
                            "p_remarks": f"MySQL Error: {sqlerr}, Endpoint: GETCMSDetails"
                        }
            update_container_logs(params)
            error_list.append(f"MySQL Error: {sqlerr}")
        except ProgrammingError as perr:
            LegacyOrganisationID = 0
            LoggingDetails("GetCMSDetails", f"MySQL Error: {perr}", JOB_ID, JOB_RUN_ID, error_list)                
            uparams = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Failed",
                            "p_log_id": log_id,
                            "p_remarks":  f"MySQL Error: {perr}, Endpoint: GETCMSDetails"
                        }
            update_container_logs(params)
            error_list.append(f"MySQL Error: {perr}")
        except Exception as e:
            LegacyOrganisationID = 0
            LoggingDetails("GetCMSDetails", f"MySQL Error: {e}", JOB_ID, JOB_RUN_ID, error_list)                
            params = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Failed",
                            "p_log_id": log_id,
                            "p_remarks": f"MySQL Error: {e}, Endpoint: GetCMSDetails"
                        }
            update_container_logs(params)
            error_list.append(f"MySQL Error: {e}")

        print(f"Xero Org: c{EtaniClientID} - {EtaniOrganisationID} Status: {CustomStatuses.get(OrgStatus, str(OrgStatus))}")

        TablePrefixEVA = f"c{str(EtaniClientID)}_{str(EtaniOrganisationID)}_xeroblue_"
        TableClientEVA = f"c{str(EtaniClientID)}_xeroblue_"
        
        params = {
                    "p_integration": "XEROBLUE",
                    "p_organisation_id": EtaniOrganisationID,
                    "p_client_id": ClientIdNumber,
                    "p_firm_id": FirmId,
                    "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_status": "Started",
                    "p_log_id": log_id,
                    "p_remarks": f"Start API Data Refresh [{datetime.fromtimestamp(start_time)}], Endpoint: API Data"
                }
        update_container_logs(params)
        
        try:
            if OrgStatus == 1 and DB_Destination != 'SQL':
                # check_object_exists('reconciliation_table', 'Reconciliation')
                
                reconciliation_process('Journals')
                reconciliation_process('JournalsCash')
            else:
                params = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Failed",
                            "p_log_id": log_id,
                            "p_remarks": f"Xero Org Status is not Loading Data Status:{OrgStatus}, endpoint: API Data"
                        }
                update_container_logs(params)
        finally:
            UpdateLastRefreshDate('Completed')
            end_time = time.time()

            # Submit query monitoring data if enabled
            if query_client:
                # Use CONTAINER_LOG_ID from env var if available, otherwise use local log_id
                container_log_id = CONTAINER_LOG_ID or log_id
                query_result = submit_query_logs(container_log_id)

            print(f"Completed API Data Refresh (elapsed time: {end_time - start_time} seconds)")
            if error_list:
                errors = "\n".join(error_list)
                params = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Completed with Errors",
                            "p_log_id": log_id,
                            "p_remarks": f"Completed API Data Refresh (elapsed time: {(end_time - start_time)/60} minutes)\n{errors}, endpoint: API Data"
                        }
                update_container_logs(params)
            else:    
                params = {
                            "p_integration": "XEROBLUE",
                            "p_organisation_id": EtaniOrganisationID,
                            "p_client_id": ClientIdNumber,
                            "p_firm_id": FirmId,
                            "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                            "p_status": "Completed",
                            "p_log_id": log_id,
                            "p_remarks": f"Completed API Data Refresh (elapsed time: {(end_time - start_time)/60} minutes), endpoint: API Data"
                        }
                update_container_logs(params)

#cleanup executor on app exit
import atexit
@atexit.register
def shutdown_executor():
    print("Shutting down executor...")
    executor.shutdown(wait=True)
# Package End