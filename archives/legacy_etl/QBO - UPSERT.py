from azure.storage.fileshare import ShareFileClient
from datetime import datetime, timezone
import json, re, math
import requests
import base64
import pandas as pd
import numpy as np
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

from sql_helper import eva_engine, cms_engine, LoggingDetails, update_container_logs, ExecuteEvaSP, ExecuteCMSSP, ReadMySQLTable, get_firm_id, LoadToEvaStageTable
from utils import get_value, ConvertDataTypes

# Force print statements to display in docker 
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    stream=sys.stdout
)
logger = logging.getLogger(__name__)
logging.info("Logging to stdout")

# QBO API Details
client_id = config.QBO_CLIENT_ID
client_secret = config.QBO_CLIENT_SECRET

# Database Connection Details
server = config.SQL_SERVER_NAME
database = config.SQL_SERVER_DATABASE
username = config.SQL_SERVER_USERNAME
password = config.SQL_SERVER_PASSWORD 

# Azure File Share Details
StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName = config.FILE_SHARE_NAME

# Get environment variables
# DB_Destination = os.getenv('DB_Destination', 'EVA')
# JOB_ID = os.getenv('JOB_ID', '1')
# JOB_RUN_ID = os.getenv('JOB_RUN_ID', '0')
# TRIGGER_TYPE = os.getenv('TRIGGER_TYPE', 'MANUAL')
# EtaniClientID = os.getenv('EtaniClientID')
# EtaniOrganisationID = os.getenv('EtaniOrganisationID')
# RealmID = os.getenv('RealmID')

# Hardcoded values for testing
DB_Destination = 'EVA'
JOB_ID = 1
JOB_RUN_ID = 7035
TRIGGER_TYPE = 'MANUAL'
EtaniClientID = 'BIGOLESHOECOMPANY_CLIENT2013'
EtaniOrganisationID = '7035'
RealmID = '193514518158004' #'9341454308572010' 

Reset_Mode = os.getenv("Reset_Mode", False)
log_id = str(uuid.uuid1())
FirmId = 0

# Configure table prefixes
try:
    client_number = EtaniClientID[EtaniClientID.find('CLIENT') + len('CLIENT'):]
    if not client_number:
        raise ValueError("Could not extract client number from EtaniClientID")
    TablePrefixEVA = 'c' + client_number + '_' + str(EtaniOrganisationID) + '_qbo_'
    TableClientEVA = f"c{client_number}_qbo_"
    ClientIdNumber = client_number
except Exception as e:
    print(f"Error processing EtaniClientID: {e}")
    print(f"EtaniClientID value: {EtaniClientID}")
    raise

# Make executor global/shared to handle concurrent calls
executor = concurrent.futures.ThreadPoolExecutor(max_workers=30) 
error_list = []

class QBORequestsManager:
    def __init__(self, endpoint, params=None, if_modified_since=None, id=None):
        self.endpoint = endpoint
        self.params = params
        self.if_modified_since = if_modified_since
        self.id = id
        self.data = None

    def __enter__(self):
        self.data = QBORequests(self.endpoint, self.params, self.if_modified_since, self.id)
        return self.data

    def __exit__(self, exc_type, exc_value, traceback):
        print("Cleaning up DataFrame")
        del self.data
        return False  # Propagate any exceptions

class QBOAPI:
    def __init__(self):
        self.api_calls = 0
        self.last_reset = time.time()

    def qbo_requests(self, endpoint, params=None, if_modified_since=None, id=None):
        TaskName = "QBO API Requests"
        current_time = time.time()
        if current_time - self.last_reset >= 60:
            self.api_calls = 0
            self.last_reset = current_time

        if self.api_calls >= 60:
            time.sleep(60 - (current_time - self.last_reset))
            self.api_calls = 0
            self.last_reset = time.time()

        self.api_calls += 1

        # Report API endpoints
        ReportAPI = {
            'BalanceSheet', 'ProfitAndLoss', 'CashFlow', 'TrialBalance', 'GeneralLedger',
            # 'AccountListDetail', 'APAgingDetail', 'APAgingSummary', 'ARAgingDetail', 'ARAgingSummary',  # These return 400 Bad Request
            'VendorBalanceDetail', 'CustomerBalanceDetail', 'InventoryValuationSummary',
            'BankStatement', 'BankSummary', 'BudgetSummary', 'ExecutiveSummary'
        }

        # Make the API call
        with lock:
            OldToken = GetTokenFromFile(TokenFileName)
            if OldToken is None:
                print(f"Error: Could not get token from file {TokenFileName}")
                return None
                
            NewToken = GetNewToken(OldToken[1])
            if isinstance(NewToken[0], dict) and NewToken[0].get('error') == 'invalid_grant': 
                ExecuteCMSSP(f"Update client_service SET status = 13 where Id = '{EtaniOrganisationID}'", "client_service", error_list, True)
                params = {
                    "p_integration": "QBO",
                    "p_organisation_id": EtaniOrganisationID,
                    "p_client_id": ClientIdNumber,
                    "p_firm_id": FirmId,
                    "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                    "p_status": "Failed",
                    "p_log_id": log_id,
                    "p_remarks": "Invalid Grant or Token"
                }
                update_container_logs(params)
                return None
        
        if endpoint in ReportAPI:
            get_url = f'https://quickbooks.api.intuit.com/v3/company/{RealmID}/reports/{endpoint}'
        else:
            get_url = f'https://quickbooks.api.intuit.com/v3/company/{RealmID}/query'
        
        if id:
            get_url += '/' + id
        if params:
            get_url += '?' + urllib.parse.urlencode(params)

        LoggingDetails(TaskName, f"{endpoint} - Get API Response from : {get_url}", JOB_ID, JOB_RUN_ID, error_list)
        
        headers = {
            'Authorization': 'REDACTED' + NewToken[0],
            'Accept': 'application/json',
            'Cache-Control': 'no-cache'
        }

        try:
            response = requests.get(get_url, headers=headers, timeout=900)
            response.raise_for_status()
            json_response = response.json()
            
            # Save response to file for debugging
            os.makedirs('json', exist_ok=True)
            try:
                with open(f'json/{TablePrefixEVA}_{endpoint.replace("/", "_")}_response.json', 'w+') as outfile:
                    json.dump(json_response, outfile)
            except PermissionError:
                print(f"Warning: Cannot write JSON file for {endpoint} - permission denied, continuing without file...")
            except Exception as e:
                print(f"Warning: Error writing JSON file for {endpoint}: {e}, continuing...")
            
            if endpoint in ReportAPI:
                QBOData = pd.DataFrame([json_response])  # Wrap in list for consistent handling
            else:
                # Check if QueryResponse exists and contains data for the endpoint
                if 'QueryResponse' in json_response:
                    QueryResponse = json_response['QueryResponse']
                    if endpoint in QueryResponse and QueryResponse[endpoint]:
                        QBOData = pd.DataFrame(QueryResponse[endpoint])
                    else:
                        print(f"{endpoint} - No data found in QueryResponse")
                        QBOData = pd.DataFrame()
                else:
                    print(f"{endpoint} - QueryResponse not found in API response")
                    QBOData = pd.DataFrame()
                    
        except requests.exceptions.Timeout:
            LoggingDetails(TaskName, "Request timed out.", JOB_ID, JOB_RUN_ID, error_list)
            error_list.append("API Request Timeout")
            raise
        except requests.exceptions.RequestException as e:
            LoggingDetails(TaskName, f"Request failed: {e}", JOB_ID, JOB_RUN_ID, error_list)
            error_list.append("API Request Failed")
            raise
        
        return QBOData

qbo_api = QBOAPI()

def get_paginated_data(endpoint, base_query, max_results=1000):
    """Helper function to handle pagination for QBO API endpoints - DEPRECATED for memory reasons"""
    combined_data = []
    start_position = 1
    
    while True:
        # Build query with pagination
        params = {'query': f'{base_query} STARTPOSITION {start_position} MAXRESULTS {max_results}'}
        
        with QBORequestsManager(endpoint, params) as Page_Data:
            if Page_Data.empty:
                break
            
            page_count = len(Page_Data)
            print(f"{endpoint} - Retrieved page starting at {start_position}, {page_count} records")
            
            # Add page data to combined results
            for index, record in Page_Data.iterrows():
                # Skip if record is not a dict (could be float/NaN)
                if not isinstance(record, pd.Series):
                    continue
                combined_data.append(record)
            
            # Check if we got fewer records than requested (end of data)
            if page_count < max_results:
                break
            
            # Move to next page
            start_position += max_results
    
    return combined_data

def process_paginated_data_streaming(endpoint, base_query, processor_func, stage_table, load_type='Full', max_results=1000):
    """Stream-process paginated data to avoid memory issues"""
    start_position = 1
    total_processed = 0
    page_number = 1
    
    try:
        # Clear staging table for full loads
        if load_type == 'Full':
            try:
                with eva_engine.connect() as conn:
                    conn.execute(text(f"TRUNCATE TABLE {stage_table}"))
                    conn.commit()
                print(f"{endpoint} - Table {stage_table} truncated.")
            except Exception as e:
                print(f"Warning: Could not truncate {stage_table}: {e}")
        
        while True:
            # Build query with pagination
            params = {'query': f'{base_query} STARTPOSITION {start_position} MAXRESULTS {max_results}'}
            
            with QBORequestsManager(endpoint, params) as Page_Data:
                # Handle case where API call failed (token issues, etc.)
                if Page_Data is None:
                    print(f"{endpoint} - API call failed at page {page_number}, stopping pagination")
                    break
                
                if Page_Data.empty:
                    break
                
                page_count = len(Page_Data)
                print(f"{endpoint} - Retrieved page {page_number} starting at {start_position}, {page_count} records")
                
                # Process current page data
                page_processed_data = []
                for index, record in Page_Data.iterrows():
                    # Skip if record is not a dict (could be float/NaN)
                    if not isinstance(record, pd.Series):
                        continue
                        
                    # Process this record using the provided processor function
                    processed_records = processor_func(record)
                    if processed_records:
                        if isinstance(processed_records, list):
                            page_processed_data.extend(processed_records)
                        else:
                            page_processed_data.append(processed_records)
                
                # Write this page to staging table if we have data
                if page_processed_data:
                    df_page = pd.DataFrame(page_processed_data)
                    converted_data = ConvertDataTypes(df_page, endpoint)
                    
                    write_mode = "append"  # Always append for streaming
                    LoadToEvaStageTable(converted_data, endpoint, write_mode, stage_table, error_list)
                    
                    page_processed_count = len(converted_data)
                    total_processed += page_processed_count
                    print(f"{endpoint} - Page {page_number}: Processed {page_processed_count} records, Total: {total_processed}")
                
                # Check if we got fewer records than requested (end of data)
                if page_count < max_results:
                    break
                
                # Move to next page
                start_position += max_results
                page_number += 1
        
        print(f"{endpoint} - Streaming complete. Total processed: {total_processed} records")
        return total_processed
        
    except Exception as e:
        print(f"{endpoint} - An error occurred during streaming: {str(e)}")
        print(f"{endpoint} - Streaming stopped. Records processed so far: {total_processed}")
        return total_processed

def GetTokenFromFile(TokenFileName):
    # Azure File Share connection settings
    storage_account_name = StorageAccountName
    storage_account_key = StorageAccessKey
    file_share_name = FileShareName

    try:
        # Create a ShareFileClient object
        share_file_client = ShareFileClient.from_connection_string(
            f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storage_account_key};BlobEndpoint=https://{storage_account_name}.file.core.windows.net/",
            file_share_name,
            TokenFileName
        )

        # Get a file stream
        downloader = share_file_client.download_file()

        # Read the file contents from the stream
        file_contents = downloader.readall().decode('utf-8')
        
        # Save old token for debugging with error handling
        try:
            os.makedirs('token', exist_ok=True)
            old_token_path = f'token/{TokenFileName.replace(".txt", "_old.txt")}'
            with open(old_token_path, 'w+', encoding='utf-8') as f:
                f.write(file_contents)
        except Exception as token_save_error:
            print(f"Warning: Could not save old token file: {token_save_error}")
            # Continue execution as this is not critical

        # Check if file is empty
        if not file_contents.strip():
            print(f"Warning: Token file {TokenFileName} is empty")
            return None

        # Parse the file contents as JSON
        try:
            json_response = json.loads(file_contents)
            return [json_response['access_token'], json_response['refresh_token'], json_response['refresh_token']]
        except json.JSONDecodeError as e:
            print(f"Error parsing token file {TokenFileName}: {str(e)}")
            return None
    except Exception as e:
        print(f"Error reading token file {TokenFileName}: {str(e)}")
        return None

def GetNewToken(refresh_token):
    TaskName = 'GetNewToken'
    
    b64_id_secret = base64.b64encode(bytes(client_id + ':' + client_secret, 'utf-8')).decode('utf-8')
    token_refresh_url = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer'
    response = requests.post(token_refresh_url,
                            headers = {
                                'Authorization' : 'REDACTED' + b64_id_secret,
                                'Accept': 'application/json'
                            },
                            data = {
                                'grant_type' : 'refresh_token',
                                'refresh_token' : refresh_token
                            })
    json_response = response.json()
    try:
        token_path = f'token/{TokenFileName.replace(".txt", "_new.txt")}'
        with open(token_path, 'w+') as f:
            f.write(json.dumps(json_response))
    except Exception as e:
        print(f"Warning: Could not save token to file: {e}")
    status_code = response.status_code

    # Azure File Share connection settings
    storage_account_name = StorageAccountName
    storage_account_key = StorageAccessKey
    file_share_name = FileShareName

    if status_code == 200:
        # Write the new token to the Azure File Share
        token_file_name = TokenFileName
        share_file_client = ShareFileClient.from_connection_string(
            f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storage_account_key};BlobEndpoint=https://{storage_account_name}.file.core.windows.net/",
            file_share_name,
            token_file_name
        )
        data = json.dumps(json_response).encode('utf-8')
        share_file_client.upload_file(data)

        return [json_response['access_token'], json_response['refresh_token']]
    else:
        return json_response, "error"

def QBORequests(endpoint, params=None, if_modified_since=None, id=None):
    return qbo_api.qbo_requests(endpoint, params, if_modified_since, id)

def GetMaxFilterParameter(prod_table, filter_column, endpoint, client_id, organisation_id, error_list):
    """Get the maximum value for incremental loads"""
    try:
        query = f"SELECT IFNULL(MAX({filter_column}), '1970-01-01') as `MaxValue` FROM {prod_table} WHERE OrganisationID = {LegacyOrganisationID}"
        df = ReadMySQLTable(query, endpoint, client_id, organisation_id, error_list)
        return df.loc[0, 'MaxValue'] if not df.empty else None
    except Exception as e:
        error_list.append(f"Error getting max filter parameter for {prod_table}: {str(e)}")
        return None

def GetProdCount(ProdTable):
    """Get the count of records in the production table for the current organisation."""
    try:
        query = f'SELECT COUNT(*) as Count FROM {ProdTable} WHERE OrganisationID = {LegacyOrganisationID}'
        dfProdCount = ReadMySQLTable(query, 'GetProdCount', EtaniClientID, EtaniOrganisationID, error_list)
        return dfProdCount.loc[0, 'Count'] if not dfProdCount.empty else 0
    except Exception as e:
        error_list.append(f"Error getting production count for {ProdTable}: {str(e)}")
        return 0

def LogLastRefreshDate(prod_table, stage_table, load_type, status, endpoint, destination, start_date, stage_count=0, prod_count=0, error_details=''):
    """Log refresh status to tracking table"""
    try:
        # Implementation for logging refresh dates
        print(f"Logging refresh: {endpoint} - {status} - Stage: {stage_count}, Prod: {prod_count}")
    except Exception as e:
        error_list.append(f"Error logging refresh date: {str(e)}")

def ExtractAPIResponse(endpoint):
    """
    Main function to extract data from QBO API for any endpoint
    """
    try:
        LoadType = ''
        StageCount = 0
        ProdCount = 0
        StartUTCDate = datetime.now(timezone.utc)
        StageTable = TablePrefixEVA + endpoint.lower() + 'stage'
        SPName = 'sp_dynamic_qbo_' + endpoint.lower()
        ProdTable = TablePrefixEVA.replace('_'+str(EtaniOrganisationID), '') + endpoint.lower()
        
        # Log start
        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Started', endpoint, 'EVA', StartUTCDate)
        
        if endpoint == 'CompanyInfo':
            LoadType = 'Full'
            params = {'query': 'SELECT * FROM CompanyInfo'}
            
            with QBORequestsManager(endpoint, params) as All_Data:
                combined_data = []
                for index, org in All_Data.iterrows():
                    # Extract all addresses
                    company_addr = org.get('CompanyAddr', {}) if get_value(org, 'CompanyAddr', None) is not None else {}
                    legal_addr = org.get('LegalAddr', {}) if get_value(org, 'LegalAddr', None) is not None else {}
                    cust_comm_addr = org.get('CustomerCommunicationAddr', {}) if get_value(org, 'CustomerCommunicationAddr', None) is not None else {}
                    
                    # Extract other nested objects
                    primary_phone = org.get('PrimaryPhone', {}) if get_value(org, 'PrimaryPhone', None) is not None else {}
                    email = org.get('Email', {}) if get_value(org, 'Email', None) is not None else {}
                    web_addr = org.get('WebAddr', {}) if get_value(org, 'WebAddr', None) is not None else {}
                    
                    base_data = {
                        # Basic fields - PascalCase as per table structure
                        'Id': get_value(org, 'Id', ''),
                        'SyncToken': get_value(org, 'SyncToken', ''),
                        'CompanyName': get_value(org, 'CompanyName', ''),
                        'LegalName': get_value(org, 'LegalName', ''),
                        'CompanyStartDate': get_value(org, 'CompanyStartDate', None),
                        'Country': get_value(org, 'Country', ''),
                        'FiscalYearStartMonth': get_value(org, 'FiscalYearStartMonth', ''),
                        'EmployerId': get_value(org, 'EmployerId', ''),
                        'SupportedLanguages': get_value(org, 'SupportedLanguages', ''),
                        'sparse': get_value(org, 'sparse', False),
                        'domain': get_value(org, 'domain', ''),
                        'nameValue': json.dumps(org.get('NameValue', [])),  # Convert array to JSON string
                        
                        # CompanyAddr fields - PascalCase with underscores to match table structure
                        'CompanyAddr_Id': get_value(company_addr, 'Id', ''),
                        'CompanyAddr_Line1': get_value(company_addr, 'Line1', ''),
                        'CompanyAddr_Line2': get_value(company_addr, 'Line2', ''),
                        'CompanyAddr_Line3': get_value(company_addr, 'Line3', ''),
                        'CompanyAddr_Line4': get_value(company_addr, 'Line4', ''),
                        'CompanyAddr_Line5': get_value(company_addr, 'Line5', ''),
                        'CompanyAddr_City': get_value(company_addr, 'City', ''),
                        'CompanyAddr_Country': get_value(company_addr, 'Country', ''),
                        'CompanyAddr_CountrySubDivisionCode': get_value(company_addr, 'CountrySubDivisionCode', ''),
                        'CompanyAddr_PostalCode': get_value(company_addr, 'PostalCode', ''),
                        'CompanyAddr_Lat': get_value(company_addr, 'Lat', ''),
                        'CompanyAddr_Long': get_value(company_addr, 'Long', ''),
                        
                        # CustomerCommunicationAddr fields - PascalCase with underscores
                        'CustomerCommunicationAddr_Id': get_value(cust_comm_addr, 'Id', ''),
                        'CustomerCommunicationAddr_Line1': get_value(cust_comm_addr, 'Line1', ''),
                        'CustomerCommunicationAddr_City': get_value(cust_comm_addr, 'City', ''),
                        'CustomerCommunicationAddr_Country': get_value(cust_comm_addr, 'Country', ''),
                        'CustomerCommunicationAddr_CountrySubDivisionCode': get_value(cust_comm_addr, 'CountrySubDivisionCode', ''),
                        'CustomerCommunicationAddr_PostalCode': get_value(cust_comm_addr, 'PostalCode', ''),
                        
                        # LegalAddr fields - PascalCase with underscores
                        'LegalAddr_Id': get_value(legal_addr, 'Id', ''),
                        'LegalAddr_Line1': get_value(legal_addr, 'Line1', ''),
                        'LegalAddr_City': get_value(legal_addr, 'City', ''),
                        'LegalAddr_Country': get_value(legal_addr, 'Country', ''),
                        'LegalAddr_CountrySubDivisionCode': get_value(legal_addr, 'CountrySubDivisionCode', ''),
                        'LegalAddr_PostalCode': get_value(legal_addr, 'PostalCode', ''),
                        'LegalAddr_Lat': get_value(legal_addr, 'Lat', ''),
                        'LegalAddr_Long': get_value(legal_addr, 'Long', ''),
                        
                        # Contact information fields - PascalCase with underscores
                        'PrimaryPhone_FreeFormNumber': get_value(primary_phone, 'FreeFormNumber', ''),
                        'Email_Address': get_value(email, 'Address', ''),
                        'WebAddr_URI': get_value(web_addr, 'URI', ''),
                        
                        # Metadata fields - PascalCase with underscores
                        'MetaData_CreateTime': get_value(org.get('MetaData', {}), 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(org.get('MetaData', {}), 'LastUpdatedTime', None),
                        
                        # System fields - PascalCase
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                # Load to stage
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'InProgress', endpoint, 'EVA', StartUTCDate, StageCount)
                
                # Execute stored procedure
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Account':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Account WHERE Active in (false, true) ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for account in paginated_data:
                base_data = {
                    'Id': get_value(account, 'Id', ''),
                    'Name': get_value(account, 'Name', ''),
                    'SyncToken': get_value(account, 'SyncToken', ''),
                    'Active': get_value(account, 'Active', False),
                    'SubAccount': get_value(account, 'SubAccount', False),
                    'Classification': get_value(account, 'Classification', ''),
                    'AccountType': get_value(account, 'AccountType', ''),
                    'AccountSubType': get_value(account, 'AccountSubType', ''),
                    'CurrentBalance': get_value(account, 'CurrentBalance', 0.0),
                    'CurrentBalanceWithSubAccounts': get_value(account, 'CurrentBalanceWithSubAccounts', 0.0),
                    'FullyQualifiedName': get_value(account, 'FullyQualifiedName', ''),
                    'domain': get_value(account, 'domain', ''),
                    'sparse': get_value(account, 'sparse', False),
                    'ClientID': EtaniClientID,
                    'OrganisationID': LegacyOrganisationID
                }
                
                # Handle CurrencyRef
                currency_ref = account.get('CurrencyRef', {}) if get_value(account, 'CurrencyRef', None) is not None else {}
                base_data.update({
                    'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                    'CurrencyRef_name': get_value(currency_ref, 'name', '')
                })
                
                # Handle MetaData  
                metadata = account.get('MetaData', {}) if get_value(account, 'MetaData', None) is not None else {}
                base_data.update({
                    'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                    'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                })
                
                combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Customer':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Customer ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for customer in paginated_data:
                    base_data = {
                        'Id': get_value(customer, 'Id', ''),
                        'SyncToken': get_value(customer, 'SyncToken', ''),
                        'DisplayName': get_value(customer, 'DisplayName', ''),
                        'GivenName': get_value(customer, 'GivenName', ''),
                        'FamilyName': get_value(customer, 'FamilyName', ''),
                        'CompanyName': get_value(customer, 'CompanyName', ''),
                        'PrintOnCheckName': get_value(customer, 'PrintOnCheckName', ''),
                        'Active': get_value(customer, 'Active', False),
                        'Taxable': get_value(customer, 'Taxable', False),
                        'Job': get_value(customer, 'Job', False),
                        'BillWithParent': get_value(customer, 'BillWithParent', False),
                        'Balance': get_value(customer, 'Balance', 0.0),
                        'BalanceWithJobs': get_value(customer, 'BalanceWithJobs', 0.0),
                        'PreferredDeliveryMethod': get_value(customer, 'PreferredDeliveryMethod', ''),
                        'sparse': get_value(customer, 'sparse', False),
                        'domain': get_value(customer, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle BillAddr and ShipAddr - matching SQL table structure exactly
                    bill_addr = customer.get('BillAddr', {}) if get_value(customer, 'BillAddr', None) is not None else {}
                    ship_addr = customer.get('ShipAddr', {}) if get_value(customer, 'ShipAddr', None) is not None else {}
                    
                    # BillAddr fields
                    for i in range(1, 6):
                        base_data[f'BillAddr_Line{i}'] = get_value(bill_addr, f'Line{i}', '')
                    base_data.update({
                        'BillAddr_Id': get_value(bill_addr, 'Id', ''),
                        'BillAddr_City': get_value(bill_addr, 'City', ''),
                        'BillAddr_Country': get_value(bill_addr, 'Country', ''),
                        'BillAddr_CountrySubDivisionCode': get_value(bill_addr, 'CountrySubDivisionCode', ''),
                        'BillAddr_PostalCode': get_value(bill_addr, 'PostalCode', '')
                    })
                    
                    # ShipAddr fields
                    for i in range(1, 6):
                        base_data[f'ShipAddr_Line{i}'] = get_value(ship_addr, f'Line{i}', '')
                    base_data.update({
                        'ShipAddr_Id': get_value(ship_addr, 'Id', ''),
                        'ShipAddr_City': get_value(ship_addr, 'City', ''),
                        'ShipAddr_Country': get_value(ship_addr, 'Country', ''),
                        'ShipAddr_CountrySubDivisionCode': get_value(ship_addr, 'CountrySubDivisionCode', ''),
                        'ShipAddr_PostalCode': get_value(ship_addr, 'PostalCode', '')
                    })
                    
                    # Handle CurrencyRef
                    currency_ref = customer.get('CurrencyRef', {}) if get_value(customer, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_name': get_value(currency_ref, 'name', ''),
                        'CurrencyRef_value': get_value(currency_ref, 'value', '')
                    })
                    
                    # Handle additional customer fields
                    base_data.update({
                        'MiddleName': get_value(customer, 'MiddleName', ''),
                        'Suffix': get_value(customer, 'Suffix', ''),
                        'IsProject': get_value(customer, 'IsProject', False),
                        'FullyQualifiedName': get_value(customer, 'FullyQualifiedName', ''),
                        'Level': get_value(customer, 'Level', 0),
                        'Notes': get_value(customer, 'Notes', '')
                    })
                    
                    # Handle phone numbers
                    primary_phone = customer.get('PrimaryPhone', {}) if get_value(customer, 'PrimaryPhone', None) is not None else {}
                    alternate_phone = customer.get('AlternatePhone', {}) if get_value(customer, 'AlternatePhone', None) is not None else {}
                    mobile_phone = customer.get('Mobile', {}) if get_value(customer, 'Mobile', None) is not None else {}
                    fax_phone = customer.get('Fax', {}) if get_value(customer, 'Fax', None) is not None else {}
                    
                    base_data.update({
                        'PrimaryPhone_FreeFormNumber': get_value(primary_phone, 'FreeFormNumber', ''),
                        'AlternatePhone_FreeFormNumber': get_value(alternate_phone, 'FreeFormNumber', ''),
                        'Mobile_FreeFormNumber': get_value(mobile_phone, 'FreeFormNumber', ''),
                        'Fax_FreeFormNumber': get_value(fax_phone, 'FreeFormNumber', '')
                    })
                    
                    # Handle email and web address
                    email = customer.get('PrimaryEmailAddr', {}) if get_value(customer, 'PrimaryEmailAddr', None) is not None else {}
                    web_addr = customer.get('WebAddr', {}) if get_value(customer, 'WebAddr', None) is not None else {}
                    base_data.update({
                        'PrimaryEmailAddr_Address': get_value(email, 'Address', ''),
                        'WebAddr_URI': get_value(web_addr, 'URI', '')
                    })
                    
                    # Handle references
                    tax_ref = customer.get('DefaultTaxCodeRef', {}) if get_value(customer, 'DefaultTaxCodeRef', None) is not None else {}
                    parent_ref = customer.get('ParentRef', {}) if get_value(customer, 'ParentRef', None) is not None else {}
                    sales_term_ref = customer.get('SalesTermRef', {}) if get_value(customer, 'SalesTermRef', None) is not None else {}
                    payment_method_ref = customer.get('PaymentMethodRef', {}) if get_value(customer, 'PaymentMethodRef', None) is not None else {}
                    
                    base_data.update({
                        'DefaultTaxCodeRef_value': get_value(tax_ref, 'value', ''),
                        'ParentRef_value': get_value(parent_ref, 'value', ''),
                        'SalesTermRef_value': get_value(sales_term_ref, 'value', ''),
                        'PaymentMethodRef_value': get_value(payment_method_ref, 'value', '')
                    })
                    
                    # Handle MetaData
                    metadata = customer.get('MetaData', {}) if get_value(customer, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Vendor':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Vendor ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for vendor in paginated_data:
                    base_data = {
                        'Id': get_value(vendor, 'Id', ''),
                        'SyncToken': get_value(vendor, 'SyncToken', ''),
                        'Title': get_value(vendor, 'Title', ''),
                        'GivenName': get_value(vendor, 'GivenName', ''),
                        'MiddleName': get_value(vendor, 'MiddleName', ''),
                        'FamilyName': get_value(vendor, 'FamilyName', ''),
                        'Suffix': get_value(vendor, 'Suffix', ''),
                        'CompanyName': get_value(vendor, 'CompanyName', ''),
                        'DisplayName': get_value(vendor, 'DisplayName', ''),
                        'PrintOnCheckName': get_value(vendor, 'PrintOnCheckName', ''),
                        'Active': get_value(vendor, 'Active', False),
                        'Vendor1099': get_value(vendor, 'Vendor1099', False),
                        'Balance': get_value(vendor, 'Balance', 0.0),
                        'TaxIdentifier': get_value(vendor, 'TaxIdentifier', ''),
                        'AcctNum': get_value(vendor, 'AcctNum', ''),
                        'BillRate': get_value(vendor, 'BillRate', 0.0),
                        'sparse': get_value(vendor, 'sparse', False),
                        'domain': get_value(vendor, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle BillAddr - complete field mapping
                    addr = vendor.get('BillAddr', {}) if get_value(vendor, 'BillAddr', None) is not None else {}
                    for i in range(1, 6):
                        base_data[f'BillAddr_Line{i}'] = get_value(addr, f'Line{i}', '')
                    base_data.update({
                        'BillAddr_Id': get_value(addr, 'Id', ''),
                        'BillAddr_City': get_value(addr, 'City', ''),
                        'BillAddr_Country': get_value(addr, 'Country', ''),
                        'BillAddr_CountrySubDivisionCode': get_value(addr, 'CountrySubDivisionCode', ''),
                        'BillAddr_PostalCode': get_value(addr, 'PostalCode', '')
                    })
                    
                    # Handle CurrencyRef
                    currency_ref = vendor.get('CurrencyRef', {}) if get_value(vendor, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_name': get_value(currency_ref, 'name', ''),
                        'CurrencyRef_value': get_value(currency_ref, 'value', '')
                    })
                    
                    # Handle phone numbers
                    primary_phone = vendor.get('PrimaryPhone', {}) if get_value(vendor, 'PrimaryPhone', None) is not None else {}
                    alternate_phone = vendor.get('AlternatePhone', {}) if get_value(vendor, 'AlternatePhone', None) is not None else {}
                    mobile_phone = vendor.get('Mobile', {}) if get_value(vendor, 'Mobile', None) is not None else {}
                    fax_phone = vendor.get('Fax', {}) if get_value(vendor, 'Fax', None) is not None else {}
                    
                    base_data.update({
                        'PrimaryPhone_FreeFormNumber': get_value(primary_phone, 'FreeFormNumber', ''),
                        'AlternatePhone_FreeFormNumber': get_value(alternate_phone, 'FreeFormNumber', ''),
                        'Mobile_FreeFormNumber': get_value(mobile_phone, 'FreeFormNumber', ''),
                        'Fax_FreeFormNumber': get_value(fax_phone, 'FreeFormNumber', '')
                    })
                    
                    # Handle email and web address
                    email = vendor.get('PrimaryEmailAddr', {}) if get_value(vendor, 'PrimaryEmailAddr', None) is not None else {}
                    web_addr = vendor.get('WebAddr', {}) if get_value(vendor, 'WebAddr', None) is not None else {}
                    base_data.update({
                        'PrimaryEmailAddr_Address': get_value(email, 'Address', ''),
                        'WebAddr_URI': get_value(web_addr, 'URI', '')
                    })
                    
                    # Handle TermRef
                    term_ref = vendor.get('TermRef', {}) if get_value(vendor, 'TermRef', None) is not None else {}
                    base_data['TermRef_value'] = get_value(term_ref, 'value', '')
                    
                    # Handle MetaData
                    metadata = vendor.get('MetaData', {}) if get_value(vendor, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Item':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Item ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for item in paginated_data:
                    base_data = {
                        'Id': get_value(item, 'Id', ''),
                        'SyncToken': get_value(item, 'SyncToken', ''),
                        'Name': get_value(item, 'Name', ''),
                        'Sku': get_value(item, 'Sku', ''),
                        'Description': get_value(item, 'Description', ''),
                        'Active': get_value(item, 'Active', False),
                        'SubItem': get_value(item, 'SubItem', False),
                        'Level': get_value(item, 'Level', 0),
                        'FullyQualifiedName': get_value(item, 'FullyQualifiedName', ''),
                        'Taxable': get_value(item, 'Taxable', False),
                        'SalesTaxIncluded': get_value(item, 'SalesTaxIncluded', False),
                        'UnitPrice': get_value(item, 'UnitPrice', 0.0),
                        'Type': get_value(item, 'Type', ''),
                        'PurchaseDesc': get_value(item, 'PurchaseDesc', ''),
                        'PurchaseTaxIncluded': get_value(item, 'PurchaseTaxIncluded', False),
                        'PurchaseCost': get_value(item, 'PurchaseCost', 0.0),
                        'TrackQtyOnHand': get_value(item, 'TrackQtyOnHand', False),
                        'QtyOnHand': get_value(item, 'QtyOnHand', 0.0),
                        'InvStartDate': get_value(item, 'InvStartDate', None),
                        'ReorderPoint': get_value(item, 'ReorderPoint', 0.0),
                        'ManPartNum': get_value(item, 'ManPartNum', ''),
                        'sparse': get_value(item, 'sparse', False),
                        'domain': get_value(item, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle IncomeAccountRef
                    income_ref = item.get('IncomeAccountRef', {}) if get_value(item, 'IncomeAccountRef', None) is not None else {}
                    base_data.update({
                        'IncomeAccountRef_value': get_value(income_ref, 'value', ''),
                        'IncomeAccountRef_name': get_value(income_ref, 'name', '')
                    })
                    
                    # Handle ExpenseAccountRef
                    expense_ref = item.get('ExpenseAccountRef', {}) if get_value(item, 'ExpenseAccountRef', None) is not None else {}
                    base_data.update({
                        'ExpenseAccountRef_value': get_value(expense_ref, 'value', ''),
                        'ExpenseAccountRef_name': get_value(expense_ref, 'name', '')
                    })
                    
                    # Handle AssetAccountRef
                    asset_ref = item.get('AssetAccountRef', {}) if get_value(item, 'AssetAccountRef', None) is not None else {}
                    base_data['AssetAccountRef_value'] = get_value(asset_ref, 'value', '')
                    
                    # Handle additional references
                    parent_ref = item.get('ParentRef', {}) if get_value(item, 'ParentRef', None) is not None else {}
                    asset_ref = item.get('AssetAccountRef', {}) if get_value(item, 'AssetAccountRef', None) is not None else {}
                    deposit_ref = item.get('DepositToAccountRef', {}) if get_value(item, 'DepositToAccountRef', None) is not None else {}
                    sales_tax_ref = item.get('SalesTaxCodeRef', {}) if get_value(item, 'SalesTaxCodeRef', None) is not None else {}
                    purchase_tax_ref = item.get('PurchaseTaxCodeRef', {}) if get_value(item, 'PurchaseTaxCodeRef', None) is not None else {}
                    class_ref = item.get('ClassRef', {}) if get_value(item, 'ClassRef', None) is not None else {}
                    vendor_ref = item.get('PrefVendorRef', {}) if get_value(item, 'PrefVendorRef', None) is not None else {}
                    
                    base_data.update({
                        'ParentRef_value': get_value(parent_ref, 'value', ''),
                        'AssetAccountRef_value': get_value(asset_ref, 'value', ''),
                        'DepositToAccountRef_value': get_value(deposit_ref, 'value', ''),
                        'SalesTaxCodeRef_value': get_value(sales_tax_ref, 'value', ''),
                        'PurchaseTaxCodeRef_value': get_value(purchase_tax_ref, 'value', ''),
                        'ClassRef_value': get_value(class_ref, 'value', ''),
                        'PrefVendorRef_value': get_value(vendor_ref, 'value', '')
                    })
                    
                    # Handle MetaData
                    metadata = item.get('MetaData', {}) if get_value(item, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Employee':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Employee ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for employee in paginated_data:
                    base_data = {
                        'Id': get_value(employee, 'Id', ''),
                        'SyncToken': get_value(employee, 'SyncToken', ''),
                        'Organization': get_value(employee, 'Organization', False),
                        'Title': get_value(employee, 'Title', ''),
                        'GivenName': get_value(employee, 'GivenName', ''),
                        'MiddleName': get_value(employee, 'MiddleName', ''),
                        'FamilyName': get_value(employee, 'FamilyName', ''),
                        'Suffix': get_value(employee, 'Suffix', ''),
                        'DisplayName': get_value(employee, 'DisplayName', ''),
                        'PrintOnCheckName': get_value(employee, 'PrintOnCheckName', ''),
                        'Active': get_value(employee, 'Active', False),
                        'EmployeeNumber': get_value(employee, 'EmployeeNumber', ''),
                        'SSN': get_value(employee, 'SSN', ''),
                        'BillableTime': get_value(employee, 'BillableTime', False),
                        'BillRate': get_value(employee, 'BillRate', 0.0),
                        'BirthDate': get_value(employee, 'BirthDate', None),
                        'Gender': get_value(employee, 'Gender', ''),
                        'HiredDate': get_value(employee, 'HiredDate', None),
                        'ReleasedDate': get_value(employee, 'ReleasedDate', None),
                        'V4IDPseudonym': get_value(employee, 'V4IDPseudonym', ''),
                        'sparse': get_value(employee, 'sparse', False),
                        'domain': get_value(employee, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle phone numbers
                    primary_phone = employee.get('PrimaryPhone', {}) if get_value(employee, 'PrimaryPhone', None) is not None else {}
                    mobile_phone = employee.get('Mobile', {}) if get_value(employee, 'Mobile', None) is not None else {}
                    
                    base_data.update({
                        'PrimaryPhone_FreeFormNumber': get_value(primary_phone, 'FreeFormNumber', ''),
                        'Mobile_FreeFormNumber': get_value(mobile_phone, 'FreeFormNumber', '')
                    })
                    
                    # Handle email
                    email = employee.get('PrimaryEmailAddr', {}) if get_value(employee, 'PrimaryEmailAddr', None) is not None else {}
                    base_data['PrimaryEmailAddr_Address'] = get_value(email, 'Address', '')
                    
                    # Handle PrimaryAddr
                    addr = employee.get('PrimaryAddr', {}) if get_value(employee, 'PrimaryAddr', None) is not None else {}
                    base_data.update({
                        'PrimaryAddr_Id': get_value(addr, 'Id', ''),
                        'PrimaryAddr_Line1': get_value(addr, 'Line1', ''),
                        'PrimaryAddr_Line2': get_value(addr, 'Line2', ''),
                        'PrimaryAddr_Line3': get_value(addr, 'Line3', ''),
                        'PrimaryAddr_Line4': get_value(addr, 'Line4', ''),
                        'PrimaryAddr_Line5': get_value(addr, 'Line5', ''),
                        'PrimaryAddr_City': get_value(addr, 'City', ''),
                        'PrimaryAddr_Country': get_value(addr, 'Country', ''),
                        'PrimaryAddr_CountrySubDivisionCode': get_value(addr, 'CountrySubDivisionCode', ''),
                        'PrimaryAddr_PostalCode': get_value(addr, 'PostalCode', '')
                    })
                    
                    # Handle MetaData
                    metadata = employee.get('MetaData', {}) if get_value(employee, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint in ['Class', 'Department']:
            LoadType = 'Full'
            base_query = f'SELECT * FROM {endpoint} ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for entity in paginated_data:
                    base_data = {
                        'Id': get_value(entity, 'Id', ''),
                        'SyncToken': get_value(entity, 'SyncToken', ''),
                        'Name': get_value(entity, 'Name', ''),
                        'FullyQualifiedName': get_value(entity, 'FullyQualifiedName', ''),
                        'Active': get_value(entity, 'Active', False),
                        'sparse': get_value(entity, 'sparse', False),
                        'domain': get_value(entity, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    if endpoint == 'Class':
                        base_data['SubClass'] = get_value(entity, 'SubClass', False)
                    elif endpoint == 'Department':
                        base_data['SubDepartment'] = get_value(entity, 'SubDepartment', False)
                    
                    # Handle ParentRef
                    parent_ref = entity.get('ParentRef', {}) if get_value(entity, 'ParentRef', None) is not None else {}
                    base_data['ParentRef_value'] = get_value(parent_ref, 'value', '')
                    
                    # Handle MetaData
                    metadata = entity.get('MetaData', {}) if get_value(entity, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint in ['TaxCode', 'TaxRate', 'Term', 'PaymentMethod']:
            LoadType = 'Full'
            base_query = f'SELECT * FROM {endpoint} ORDERBY Metadata.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for entity in paginated_data:
                    base_data = {
                        'Id': get_value(entity, 'Id', ''),
                        'SyncToken': get_value(entity, 'SyncToken', ''),
                        'Name': get_value(entity, 'Name', ''),
                        'Active': get_value(entity, 'Active', False),
                        'sparse': get_value(entity, 'sparse', False),
                        'domain': get_value(entity, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    if endpoint == 'TaxCode':
                        base_data.update({
                            'Description': get_value(entity, 'Description', ''),
                            'Hidden': get_value(entity, 'Hidden', False),
                            'Taxable': get_value(entity, 'Taxable', False),
                            'TaxGroup': get_value(entity, 'TaxGroup', False)
                        })
                        # Handle SalesTaxRateList and PurchaseTaxRateList
                        sales_tax_list = entity.get('SalesTaxRateList', {}).get('TaxRateDetail', []) if entity.get('SalesTaxRateList') else []
                        purchase_tax_list = entity.get('PurchaseTaxRateList', {}).get('TaxRateDetail', []) if entity.get('PurchaseTaxRateList') else []
                        
                        if sales_tax_list and len(sales_tax_list) > 0:
                            first_sales = sales_tax_list[0]
                            base_data.update({
                                'SalesTaxRateList_TaxRateDetail_TaxRateRef_value': get_value(first_sales.get('TaxRateRef', {}), 'value', ''),
                                'SalesTaxRateList_TaxRateDetail_TaxRateRef_name': get_value(first_sales.get('TaxRateRef', {}), 'name', ''),
                                'SalesTaxRateList_TaxRateDetail_TaxTypeApplicable': get_value(first_sales, 'TaxTypeApplicable', ''),
                                'SalesTaxRateList_TaxRateDetail_TaxOrder': get_value(first_sales, 'TaxOrder', 0)
                            })
                        
                        if purchase_tax_list and len(purchase_tax_list) > 0:
                            first_purchase = purchase_tax_list[0]
                            base_data.update({
                                'PurchaseTaxRateList_TaxRateDetail_TaxRateRef_value': get_value(first_purchase.get('TaxRateRef', {}), 'value', ''),
                                'PurchaseTaxRateList_TaxRateDetail_TaxRateRef_name': get_value(first_purchase.get('TaxRateRef', {}), 'name', ''),
                                'PurchaseTaxRateList_TaxRateDetail_TaxTypeApplicable': get_value(first_purchase, 'TaxTypeApplicable', ''),
                                'PurchaseTaxRateList_TaxRateDetail_TaxOrder': get_value(first_purchase, 'TaxOrder', 0)
                            })
                    
                    elif endpoint == 'TaxRate':
                        base_data.update({
                            'Description': get_value(entity, 'Description', ''),
                            'RateValue': get_value(entity, 'RateValue', 0.0),
                            'SpecialTaxType': get_value(entity, 'SpecialTaxType', ''),
                            'DisplayType': get_value(entity, 'DisplayType', '')
                        })
                        
                        # Handle references
                        agency_ref = entity.get('AgencyRef', {}) if get_value(entity, 'AgencyRef', None) is not None else {}
                        tax_return_ref = entity.get('TaxReturnLineRef', {}) if get_value(entity, 'TaxReturnLineRef', None) is not None else {}
                        base_data.update({
                            'AgencyRef_value': get_value(agency_ref, 'value', ''),
                            'TaxReturnLineRef_value': get_value(tax_return_ref, 'value', '')
                        })
                        
                        # Handle EffectiveTaxRate (can be dict or list)
                        effective_rate_raw = entity.get('EffectiveTaxRate')
                        if isinstance(effective_rate_raw, list) and len(effective_rate_raw) > 0:
                            effective_rate = effective_rate_raw[0]  # Take first item if it's a list
                        elif isinstance(effective_rate_raw, dict):
                            effective_rate = effective_rate_raw
                        else:
                            effective_rate = {}
                        
                        base_data.update({
                            'EffectiveTaxRate_RateValue': get_value(effective_rate, 'RateValue', 0.0) if effective_rate else 0.0,
                            'EffectiveTaxRate_EffectiveDate': get_value(effective_rate, 'EffectiveDate', None) if effective_rate else None
                        })
                    
                    elif endpoint == 'Term':
                        base_data.update({
                            'Type': get_value(entity, 'Type', ''),
                            'DiscountPercent': get_value(entity, 'DiscountPercent', 0.0),
                            'DueDays': get_value(entity, 'DueDays', 0),
                            'DiscountDays': get_value(entity, 'DiscountDays', 0),
                            'DayOfMonthDue': get_value(entity, 'DayOfMonthDue', 0),
                            'DueNextMonthDays': get_value(entity, 'DueNextMonthDays', 0),
                            'DiscountDayOfMonth': get_value(entity, 'DiscountDayOfMonth', 0)
                        })
                    
                    elif endpoint == 'PaymentMethod':
                        base_data['Type'] = get_value(entity, 'Type', '')
                    
                    # Handle MetaData
                    metadata = entity.get('MetaData', {}) if get_value(entity, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Invoice':
            def process_invoice_record(invoice):
                """Process a single invoice record and return list of line items"""
                processed_lines = []
                
                # Skip if invoice is not a proper pandas Series or dict-like object
                if not isinstance(invoice, (pd.Series, dict)):
                    print(f"Skipping invalid invoice data type: {type(invoice)}")
                    return []
                
                # Ensure invoice has get method (handle both Series and dict)
                if hasattr(invoice, 'get'):
                    lines = invoice.get('Line', []) or []
                else:
                    print(f"Skipping invoice without get method: {type(invoice)}")
                    return []
                    
                # Process each line item
                for line in lines:
                    base_data = {
                        'Id': get_value(invoice, 'Id', ''),
                        'SyncToken': get_value(invoice, 'SyncToken', ''),
                        'DocNumber': get_value(invoice, 'DocNumber', ''),
                        'TxnDate': get_value(invoice, 'TxnDate', None),
                        'DueDate': get_value(invoice, 'DueDate', None),
                        'TotalAmt': get_value(invoice, 'TotalAmt', 0.0),
                        'Balance': get_value(invoice, 'Balance', 0.0),
                        'ApplyTaxAfterDiscount': get_value(invoice, 'ApplyTaxAfterDiscount', False),
                        'PrintStatus': get_value(invoice, 'PrintStatus', ''),
                        'EmailStatus': get_value(invoice, 'EmailStatus', ''),
                        'BillEmail_Address': get_value(invoice.get('BillEmail', {}), 'Address', ''),
                        'DeliveryInfo_DeliveryType': get_value(invoice.get('DeliveryInfo', {}), 'DeliveryType', ''),
                        'sparse': get_value(invoice, 'sparse', False),
                        'domain': get_value(invoice, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Line item details
                    base_data.update({
                        'Line_Id': get_value(line, 'Id', ''),
                        'Line_LineNum': get_value(line, 'LineNum', 0),
                        'Line_Description': get_value(line, 'Description', ''),
                        'Line_Amount': get_value(line, 'Amount', 0.0),
                        'Line_DetailType': get_value(line, 'DetailType', '')
                    })
                    
                    # Handle SalesItemLineDetail
                    if line.get('DetailType') == 'SalesItemLineDetail':
                        detail = line.get('SalesItemLineDetail', {})
                        base_data.update({
                            'Line_SalesItemLineDetail_ItemRef_value': get_value(detail.get('ItemRef', {}), 'value', ''),
                            'Line_SalesItemLineDetail_ItemRef_name': get_value(detail.get('ItemRef', {}), 'name', ''),
                            'Line_SalesItemLineDetail_Qty': get_value(detail, 'Qty', 0),
                            'Line_SalesItemLineDetail_UnitPrice': get_value(detail, 'UnitPrice', 0.0),
                            'Line_SalesItemLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', '')
                        })
                    
                    # Handle CustomerRef
                    customer_ref = invoice.get('CustomerRef', {}) if get_value(invoice, 'CustomerRef', None) is not None else {}
                    base_data.update({
                        'CustomerRef_value': get_value(customer_ref, 'value', ''),
                        'CustomerRef_name': get_value(customer_ref, 'name', '')
                    })
                    
                    # Handle CurrencyRef
                    currency_ref = invoice.get('CurrencyRef', {}) if get_value(invoice, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                        'CurrencyRef_name': get_value(currency_ref, 'name', '')
                    })
                    
                    # Handle MetaData
                    metadata = invoice.get('MetaData', {}) if get_value(invoice, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    processed_lines.append(base_data)
                
                return processed_lines
            
            # Check if we should do incremental load
            MaxDate = GetMaxFilterParameter(ProdTable, 'MetaData_LastUpdatedTime', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            LoadType = 'Incremental' if MaxDate else 'Full'
            
            if LoadType == 'Incremental':
                # Format MaxDate for QBO API (ISO 8601 format with timezone)
                try:
                    formatted_date = pd.to_datetime(MaxDate).strftime('%Y-%m-%dT%H:%M:%S-00:00')
                    base_query = f"SELECT * FROM Invoice WHERE MetaData.LastUpdatedTime > '{formatted_date}' ORDERBY MetaData.LastUpdatedTime"
                except:
                    # Fallback to full load if date formatting fails
                    base_query = "SELECT * FROM Invoice ORDERBY MetaData.LastUpdatedTime"
                    LoadType = 'Full'
            else:
                base_query = "SELECT * FROM Invoice ORDERBY MetaData.LastUpdatedTime"
            
            # Use streaming processing
            StageCount = process_paginated_data_streaming(
                endpoint=endpoint,
                base_query=base_query,
                processor_func=process_invoice_record,
                stage_table=StageTable,
                load_type=LoadType,
                max_results=1000
            )
            
            # Execute stored procedure and finish
            ExecuteEvaSP(f"CALL {SPName}('{endpoint.lower()}', '{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            ProdCount = GetProdCount(ProdTable)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Payment':
            # Check if we should do incremental load
            MaxDate = GetMaxFilterParameter(ProdTable, 'MetaData_LastUpdatedTime', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            LoadType = 'Incremental' if MaxDate else 'Full'
            
            if LoadType == 'Incremental':
                # Format MaxDate for QBO API (ISO 8601 format with timezone)
                try:
                    formatted_date = pd.to_datetime(MaxDate).strftime('%Y-%m-%dT%H:%M:%S-00:00')
                    base_query = f"SELECT * FROM Payment WHERE MetaData.LastUpdatedTime > '{formatted_date}' ORDERBY MetaData.LastUpdatedTime"
                except:
                    # Fallback to full load if date formatting fails
                    base_query = "SELECT * FROM Payment ORDERBY MetaData.LastUpdatedTime"
                    LoadType = 'Full'
            else:
                base_query = "SELECT * FROM Payment ORDERBY MetaData.LastUpdatedTime"
            
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for payment in paginated_data:
                    base_data = {
                        'Id': get_value(payment, 'Id', ''),
                        'SyncToken': get_value(payment, 'SyncToken', ''),
                        'TxnDate': get_value(payment, 'TxnDate', None),
                        'TotalAmt': get_value(payment, 'TotalAmt', 0.0),
                        'UnappliedAmt': get_value(payment, 'UnappliedAmt', 0.0),
                        'ProcessPayment': get_value(payment, 'ProcessPayment', False),
                        'PaymentRefNum': get_value(payment, 'PaymentRefNum', ''),
                        'PrivateNote': get_value(payment, 'PrivateNote', ''),
                        'sparse': get_value(payment, 'sparse', False),
                        'domain': get_value(payment, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle CustomerRef
                    customer_ref = payment.get('CustomerRef', {}) if get_value(payment, 'CustomerRef', None) is not None else {}
                    base_data.update({
                        'CustomerRef_value': get_value(customer_ref, 'value', ''),
                        'CustomerRef_name': get_value(customer_ref, 'name', '')
                    })
                    
                    # Handle DepositToAccountRef
                    deposit_ref = payment.get('DepositToAccountRef', {}) if get_value(payment, 'DepositToAccountRef', None) is not None else {}
                    base_data.update({
                        'DepositToAccountRef_value': get_value(deposit_ref, 'value', ''),
                        'DepositToAccountRef_name': get_value(deposit_ref, 'name', '')
                    })
                    
                    # Handle PaymentMethodRef
                    method_ref = payment.get('PaymentMethodRef', {}) if get_value(payment, 'PaymentMethodRef', None) is not None else {}
                    base_data['PaymentMethodRef_value'] = get_value(method_ref, 'value', '')
                    
                    # Handle CurrencyRef
                    currency_ref = payment.get('CurrencyRef', {}) if get_value(payment, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                        'CurrencyRef_name': get_value(currency_ref, 'name', ''),
                        'ExchangeRate': get_value(payment, 'ExchangeRate', 1.0)
                    })
                    
                    # Handle Line items (linked transactions)
                    for line in payment.get('Line', []) or []:
                        line_data = base_data.copy()
                        line_data.update({
                            'Line_Amount': get_value(line, 'Amount', 0.0),
                            'Line_LinkedTxn_TxnId': get_value(line.get('LinkedTxn', [{}])[0], 'TxnId', '') if line.get('LinkedTxn') else '',
                            'Line_LinkedTxn_TxnType': get_value(line.get('LinkedTxn', [{}])[0], 'TxnType', '') if line.get('LinkedTxn') else ''
                        })
                        
                        # Handle MetaData
                        metadata = payment.get('MetaData', {}) if get_value(payment, 'MetaData', None) is not None else {}
                        line_data.update({
                            'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                            'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                        })
                        
                        combined_data.append(line_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "append" if LoadType == 'Incremental' else "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{endpoint.lower()}', '{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Bill':
            def process_bill_record(bill):
                """Process a single bill record and return list of line items"""
                processed_lines = []
                
                # Process each line item
                for line_index, line in enumerate(bill.get('Line', []) or []):
                    if not isinstance(line, dict):
                        continue
                        
                    base_data = {
                        'Id': get_value(bill, 'Id', ''),
                        'SyncToken': get_value(bill, 'SyncToken', ''),
                        'DocNumber': get_value(bill, 'DocNumber', ''),
                        'TxnDate': get_value(bill, 'TxnDate', None),
                        'DueDate': get_value(bill, 'DueDate', None),
                        'TotalAmt': get_value(bill, 'TotalAmt', 0.0),
                        'Balance': get_value(bill, 'Balance', 0.0),
                        'PrivateNote': get_value(bill, 'PrivateNote', ''),
                        'ExchangeRate': get_value(bill, 'ExchangeRate', 1.0),
                        'sparse': get_value(bill, 'sparse', False),
                        'domain': get_value(bill, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Line item details
                    base_data.update({
                        'LineId': f"{get_value(bill, 'Id')}_{line_index}",
                        'Line_Id': get_value(line, 'Id', ''),
                        'Line_LineNum': get_value(line, 'LineNum', line_index),
                        'Line_Description': get_value(line, 'Description', ''),
                        'Line_Amount': get_value(line, 'Amount', 0.0),
                        'Line_DetailType': get_value(line, 'DetailType', '')
                    })
                        
                    # Handle AccountBasedExpenseLineDetail
                    if line.get('DetailType') == 'AccountBasedExpenseLineDetail':
                        detail = line.get('AccountBasedExpenseLineDetail', {})
                        base_data.update({
                            'AccountBasedExpenseLineDetail_AccountRef_value': get_value(detail.get('AccountRef', {}), 'value', ''),
                            'AccountBasedExpenseLineDetail_AccountRef_name': get_value(detail.get('AccountRef', {}), 'name', ''),
                            'AccountBasedExpenseLineDetail_BillableStatus': get_value(detail, 'BillableStatus', ''),
                            'AccountBasedExpenseLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', '')
                        })
                    
                    # Handle ItemBasedExpenseLineDetail
                    elif line.get('DetailType') == 'ItemBasedExpenseLineDetail':
                        detail = line.get('ItemBasedExpenseLineDetail', {})
                        base_data.update({
                            'ItemBasedExpenseLineDetail_ItemRef_value': get_value(detail.get('ItemRef', {}), 'value', ''),
                            'ItemBasedExpenseLineDetail_ItemRef_name': get_value(detail.get('ItemRef', {}), 'name', ''),
                            'ItemBasedExpenseLineDetail_Qty': get_value(detail, 'Qty', 0),
                            'ItemBasedExpenseLineDetail_UnitPrice': get_value(detail, 'UnitPrice', 0.0),
                            'ItemBasedExpenseLineDetail_BillableStatus': get_value(detail, 'BillableStatus', ''),
                            'ItemBasedExpenseLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', '')
                        })
                    
                    # Handle VendorRef
                    vendor_ref = bill.get('VendorRef', {}) if get_value(bill, 'VendorRef', None) is not None else {}
                    base_data.update({
                        'VendorRef_value': get_value(vendor_ref, 'value', ''),
                        'VendorRef_name': get_value(vendor_ref, 'name', '')
                    })
                    
                    # Handle APAccountRef
                    ap_ref = bill.get('APAccountRef', {}) if get_value(bill, 'APAccountRef', None) is not None else {}
                    base_data.update({
                        'APAccountRef_value': get_value(ap_ref, 'value', ''),
                        'APAccountRef_name': get_value(ap_ref, 'name', '')
                    })
                    
                    # Handle CurrencyRef
                    currency_ref = bill.get('CurrencyRef', {}) if get_value(bill, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                        'CurrencyRef_name': get_value(currency_ref, 'name', '')
                    })
                    
                    # Handle MetaData
                    metadata = bill.get('MetaData', {}) if get_value(bill, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    processed_lines.append(base_data)
                
                return processed_lines
            
            # Use streaming processing
            LoadType = 'Full'
            base_query = 'SELECT * FROM Bill ORDERBY MetaData.LastUpdatedTime'
            
            print(f"{endpoint} - Starting streaming pagination processing")
            StageCount = process_paginated_data_streaming(
                endpoint=endpoint,
                base_query=base_query,
                processor_func=process_bill_record,
                stage_table=StageTable,
                load_type=LoadType,
                max_results=1000
            )
            
            # Execute stored procedure and finish  
            ExecuteEvaSP(f"CALL {SPName}('{endpoint.lower()}', '{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            ProdCount = GetProdCount(ProdTable)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'JournalEntry':
            def process_journal_record(journal):
                """Process a single journal entry record and return list of line items"""
                processed_lines = []
                
                # Process each line item
                for line in journal.get('Line', []) or []:
                    base_data = {
                        'Id': get_value(journal, 'Id', ''),
                        'JournalEntryId': get_value(journal, 'Id', ''),
                        'SyncToken': get_value(journal, 'SyncToken', ''),
                        'TxnDate': get_value(journal, 'TxnDate', None),
                        'DocNumber': get_value(journal, 'DocNumber', ''),
                        'PrivateNote': get_value(journal, 'PrivateNote', ''),
                        'ExchangeRate': get_value(journal, 'ExchangeRate', 1.0),
                        'Adjustment': get_value(journal, 'Adjustment', False),
                        'HomeCurrencyAdjustment': get_value(journal, 'HomeCurrencyAdjustment', False),
                        'sparse': get_value(journal, 'sparse', False),
                        'domain': get_value(journal, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Line details
                    base_data.update({
                        'Line_Id': get_value(line, 'Id', ''),
                        'Line_Description': get_value(line, 'Description', ''),
                        'Line_Amount': get_value(line, 'Amount', 0.0),
                        'Line_DetailType': get_value(line, 'DetailType', ''),
                        'Line_PostingType': get_value(line.get('JournalEntryLineDetail', {}), 'PostingType', '')
                    })
                    
                    # Handle JournalEntryLineDetail
                    line_detail = line.get('JournalEntryLineDetail', {}) if get_value(line, 'JournalEntryLineDetail', None) is not None else {}
                    
                    # AccountRef
                    account_ref = line_detail.get('AccountRef', {}) if get_value(line_detail, 'AccountRef', None) is not None else {}
                    base_data.update({
                        'Line_JournalEntryLineDetail_AccountRef_value': get_value(account_ref, 'value', ''),
                        'Line_JournalEntryLineDetail_AccountRef_name': get_value(account_ref, 'name', '')
                    })
                    
                    # ClassRef
                    class_ref = line_detail.get('ClassRef', {}) if get_value(line_detail, 'ClassRef', None) is not None else {}
                    base_data.update({
                        'Line_JournalEntryLineDetail_ClassRef_value': get_value(class_ref, 'value', ''),
                        'Line_JournalEntryLineDetail_ClassRef_name': get_value(class_ref, 'name', '')
                    })
                    
                    # DepartmentRef
                    dept_ref = line_detail.get('DepartmentRef', {}) if get_value(line_detail, 'DepartmentRef', None) is not None else {}
                    base_data.update({
                        'Line_JournalEntryLineDetail_DepartmentRef_value': get_value(dept_ref, 'value', ''),
                        'Line_JournalEntryLineDetail_DepartmentRef_name': get_value(dept_ref, 'name', '')
                    })
                    
                    # EntityRef
                    entity_ref = line_detail.get('EntityRef', {}) if get_value(line_detail, 'EntityRef', None) is not None else {}
                    base_data.update({
                        'Line_JournalEntryLineDetail_EntityRef_value': get_value(entity_ref, 'value', ''),
                        'Line_JournalEntryLineDetail_EntityRef_type': get_value(entity_ref, 'type', ''),
                        'Line_JournalEntryLineDetail_EntityRef_name': get_value(entity_ref, 'name', '')
                    })
                    
                    # Handle CurrencyRef
                    currency_ref = journal.get('CurrencyRef', {}) if get_value(journal, 'CurrencyRef', None) is not None else {}
                    base_data.update({
                        'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                        'CurrencyRef_name': get_value(currency_ref, 'name', '')
                    })
                    
                    # Handle MetaData
                    metadata = journal.get('MetaData', {}) if get_value(journal, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    processed_lines.append(base_data)
                
                return processed_lines
            
            # Check if we should do incremental load
            MaxDate = GetMaxFilterParameter(ProdTable, 'MetaData_LastUpdatedTime', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            LoadType = 'Incremental' if MaxDate else 'Full'
            
            if LoadType == 'Incremental':
                # Format MaxDate for QBO API (ISO 8601 format with timezone)
                try:
                    formatted_date = pd.to_datetime(MaxDate).strftime('%Y-%m-%dT%H:%M:%S-00:00')
                    base_query = f"SELECT * FROM JournalEntry WHERE MetaData.LastUpdatedTime > '{formatted_date}' ORDERBY MetaData.LastUpdatedTime"
                except:
                    # Fallback to full load if date formatting fails
                    base_query = "SELECT * FROM JournalEntry ORDERBY MetaData.LastUpdatedTime"
                    LoadType = 'Full'
            else:
                base_query = "SELECT * FROM JournalEntry ORDERBY MetaData.LastUpdatedTime"
            
            # Use streaming processing
            StageCount = process_paginated_data_streaming(
                endpoint=endpoint,
                base_query=base_query,
                processor_func=process_journal_record,
                stage_table=StageTable,
                load_type=LoadType,
                max_results=1000
            )
            
            # Execute stored procedure and finish
            ExecuteEvaSP(f"CALL {SPName}('{endpoint.lower()}', '{ClientIdNumber}', {EtaniOrganisationID}, {LegacyOrganisationID})", endpoint, error_list, True)
            ProdCount = GetProdCount(ProdTable)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint in ['SalesReceipt', 'Estimate', 'CreditMemo', 'RefundReceipt']:
            # Similar structure to Invoice but with specific handling for each type
            MaxDate = GetMaxFilterParameter(ProdTable, 'MetaData_LastUpdatedTime', endpoint, EtaniClientID, EtaniOrganisationID, error_list)
            LoadType = 'Incremental' if MaxDate else 'Full'
            
            if LoadType == 'Incremental':
                # Format MaxDate for QBO API (ISO 8601 format with timezone)
                try:
                    formatted_date = pd.to_datetime(MaxDate).strftime('%Y-%m-%dT%H:%M:%S-00:00')
                    params = {'query': f"SELECT * FROM {endpoint} WHERE MetaData.LastUpdatedTime > '{formatted_date}' ORDERBY MetaData.LastUpdatedTime"}
                except:
                    # Fallback to full load if date formatting fails
                    params = {'query': f"SELECT * FROM {endpoint} ORDERBY MetaData.LastUpdatedTime"}
                    LoadType = 'Full'
            else:
                params = {'query': f"SELECT * FROM {endpoint} ORDERBY MetaData.LastUpdatedTime"}
            
            with QBORequestsManager(endpoint, params) as All_Data:
                combined_data = []
                for index, txn in All_Data.iterrows():
                    # Skip if txn is not a proper pandas Series or dict-like object
                    if not isinstance(txn, (pd.Series, dict)):
                        print(f"Skipping invalid {endpoint} data type: {type(txn)}")
                        continue
                    
                    # Ensure txn has get method (handle both Series and dict)
                    if not hasattr(txn, 'get'):
                        print(f"Skipping {endpoint} without get method: {type(txn)}")
                        continue
                        
                    lines = txn.get('Line', []) or []
                    # Process each line item
                    for line in lines:
                        base_data = {
                            'Id': get_value(txn, 'Id', ''),
                            'SyncToken': get_value(txn, 'SyncToken', ''),
                            'DocNumber': get_value(txn, 'DocNumber', ''),
                            'TxnDate': get_value(txn, 'TxnDate', None),
                            'TotalAmt': get_value(txn, 'TotalAmt', 0.0),
                            'sparse': get_value(txn, 'sparse', False),
                            'domain': get_value(txn, 'domain', ''),
                            'ClientID': EtaniClientID,
                            'OrganisationID': LegacyOrganisationID
                        }
                        
                        # Add endpoint-specific fields
                        if endpoint in ['SalesReceipt', 'RefundReceipt']:
                            base_data.update({
                                'Balance': get_value(txn, 'Balance', 0.0),
                                'PaymentRefNum': get_value(txn, 'PaymentRefNum', '')
                            })
                            
                            # Handle payment method and deposit account
                            payment_method_ref = txn.get('PaymentMethodRef', {}) if get_value(txn, 'PaymentMethodRef', None) is not None else {}
                            deposit_ref = txn.get('DepositToAccountRef', {}) if get_value(txn, 'DepositToAccountRef', None) is not None else {}
                            base_data.update({
                                'PaymentMethodRef_value': get_value(payment_method_ref, 'value', ''),
                                'PaymentMethodRef_name': get_value(payment_method_ref, 'name', ''),
                                'DepositToAccountRef_value': get_value(deposit_ref, 'value', ''),
                                'DepositToAccountRef_name': get_value(deposit_ref, 'name', '')
                            })
                        
                        elif endpoint == 'Estimate':
                            base_data.update({
                                'ExpirationDate': get_value(txn, 'ExpirationDate', None),
                                'TxnStatus': get_value(txn, 'TxnStatus', ''),
                                'AcceptedBy': get_value(txn, 'AcceptedBy', ''),
                                'AcceptedDate': get_value(txn, 'AcceptedDate', None)
                            })
                        
                        elif endpoint == 'CreditMemo':
                            base_data['Balance'] = get_value(txn, 'Balance', 0.0)
                        
                        # Common fields for all transaction types
                        if endpoint != 'RefundReceipt':  # RefundReceipt doesn't have HomeTotalAmt
                            base_data['HomeTotalAmt'] = get_value(txn, 'HomeTotalAmt', 0.0)
                        
                        # Handle customer reference
                        customer_ref = txn.get('CustomerRef', {}) if get_value(txn, 'CustomerRef', None) is not None else {}
                        base_data.update({
                            'CustomerRef_value': get_value(customer_ref, 'value', ''),
                            'CustomerRef_name': get_value(customer_ref, 'name', '')
                        })
                        
                        # Handle currency
                        currency_ref = txn.get('CurrencyRef', {}) if get_value(txn, 'CurrencyRef', None) is not None else {}
                        base_data.update({
                            'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                            'CurrencyRef_name': get_value(currency_ref, 'name', ''),
                            'ExchangeRate': get_value(txn, 'ExchangeRate', 1.0)
                        })
                        
                        # Line item details
                        base_data.update({
                            'Line_Id': get_value(line, 'Id', ''),
                            'Line_LineNum': get_value(line, 'LineNum', 0),
                            'Line_Description': get_value(line, 'Description', ''),
                            'Line_Amount': get_value(line, 'Amount', 0.0),
                            'Line_DetailType': get_value(line, 'DetailType', '')
                        })
                        
                        # Handle SalesItemLineDetail
                        if line.get('DetailType') == 'SalesItemLineDetail':
                            detail = line.get('SalesItemLineDetail', {})
                            base_data.update({
                                'Line_SalesItemLineDetail_ItemRef_value': get_value(detail.get('ItemRef', {}), 'value', ''),
                                'Line_SalesItemLineDetail_ItemRef_name': get_value(detail.get('ItemRef', {}), 'name', ''),
                                'Line_SalesItemLineDetail_ClassRef_value': get_value(detail.get('ClassRef', {}), 'value', ''),
                                'Line_SalesItemLineDetail_ClassRef_name': get_value(detail.get('ClassRef', {}), 'name', ''),
                                'Line_SalesItemLineDetail_Qty': get_value(detail, 'Qty', 0),
                                'Line_SalesItemLineDetail_UnitPrice': get_value(detail, 'UnitPrice', 0.0),
                                'Line_SalesItemLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', ''),
                                'Line_SalesItemLineDetail_ServiceDate': get_value(detail, 'ServiceDate', None)
                            })
                        
                        # Handle addresses
                        bill_addr = txn.get('BillAddr', {}) if get_value(txn, 'BillAddr', None) is not None else {}
                        ship_addr = txn.get('ShipAddr', {}) if get_value(txn, 'ShipAddr', None) is not None else {}
                        
                        # Add address fields (first 5 lines for each)
                        for addr_type, addr_data in [('BillAddr', bill_addr), ('ShipAddr', ship_addr)]:
                            for i in range(1, 6):
                                base_data[f'{addr_type}_Line{i}'] = get_value(addr_data, f'Line{i}', '')
                            base_data.update({
                                f'{addr_type}_Id': get_value(addr_data, 'Id', ''),
                                f'{addr_type}_City': get_value(addr_data, 'City', ''),
                                f'{addr_type}_Country': get_value(addr_data, 'Country', ''),
                                f'{addr_type}_CountrySubDivisionCode': get_value(addr_data, 'CountrySubDivisionCode', ''),
                                f'{addr_type}_PostalCode': get_value(addr_data, 'PostalCode', '')
                            })
                        
                        # Handle common fields
                        base_data.update({
                            'PrintStatus': get_value(txn, 'PrintStatus', ''),
                            'EmailStatus': get_value(txn, 'EmailStatus', ''),
                            'BillEmail_Address': get_value(txn.get('BillEmail', {}), 'Address', ''),
                            'GlobalTaxCalculation': get_value(txn, 'GlobalTaxCalculation', ''),
                            'ApplyTaxAfterDiscount': get_value(txn, 'ApplyTaxAfterDiscount', False),
                            'TransactionLocationType': get_value(txn, 'TransactionLocationType', '')
                        })
                        
                        # Handle tax details
                        tax_detail = txn.get('TxnTaxDetail', {}) if get_value(txn, 'TxnTaxDetail', None) is not None else {}
                        base_data.update({
                            'TxnTaxDetail_TxnTaxCodeRef_value': get_value(tax_detail.get('TxnTaxCodeRef', {}), 'value', ''),
                            'TxnTaxDetail_TotalTax': get_value(tax_detail, 'TotalTax', 0.0)
                        })
                        
                        # Handle customer memo
                        customer_memo = txn.get('CustomerMemo', {}) if get_value(txn, 'CustomerMemo', None) is not None else {}
                        base_data['CustomerMemo_value'] = get_value(customer_memo, 'value', '')
                        
                        # Handle MetaData
                        metadata = txn.get('MetaData', {}) if get_value(txn, 'MetaData', None) is not None else {}
                        base_data.update({
                            'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                            'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                        })
                        
                        combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "append" if LoadType == 'Incremental' else "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'BillPayment':
            def process_billpayment_record(payment):
                """Process a single bill payment record and return list of line items"""
                processed_lines = []
                
                # Skip if payment is not a proper dict-like object
                if not hasattr(payment, 'get'):
                    return processed_lines
                
                # Process each Line item (linked bills)
                lines = payment.get('Line', []) if hasattr(payment, 'get') else []
                for line in lines or []:
                    base_data = {
                        'Id': get_value(payment, 'Id', ''),
                        'SyncToken': get_value(payment, 'SyncToken', ''),
                        'TxnDate': get_value(payment, 'TxnDate', None),
                        'PayType': get_value(payment, 'PayType', ''),
                        'DocNumber': get_value(payment, 'DocNumber', ''),
                        'PrivateNote': get_value(payment, 'PrivateNote', ''),
                        'TotalAmt': get_value(payment, 'TotalAmt', 0.0),
                        'ProcessBillPayment': get_value(payment, 'ProcessBillPayment', False),
                        'ExchangeRate': get_value(payment, 'ExchangeRate', 1.0),
                        'TransactionLocationType': get_value(payment, 'TransactionLocationType', ''),
                        'sparse': get_value(payment, 'sparse', False),
                        'domain': get_value(payment, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Line details
                    base_data['Line_Amount'] = get_value(line, 'Amount', 0.0)
                    
                    # LinkedTxn array (get first item)
                    linked_txns = line.get('LinkedTxn', []) if hasattr(line, 'get') else []
                    if linked_txns and isinstance(linked_txns, list) and len(linked_txns) > 0:
                        linked_txn = linked_txns[0]
                        base_data.update({
                            'Line_LinkedTxn_TxnId': get_value(linked_txn, 'TxnId', ''),
                            'Line_LinkedTxn_TxnType': get_value(linked_txn, 'TxnType', '')
                        })
                    
                    # Handle references
                    vendor_ref = payment.get('VendorRef', {}) if hasattr(payment, 'get') and get_value(payment, 'VendorRef', None) is not None else {}
                    dept_ref = payment.get('DepartmentRef', {}) if hasattr(payment, 'get') and get_value(payment, 'DepartmentRef', None) is not None else {}
                    ap_ref = payment.get('APAccountRef', {}) if hasattr(payment, 'get') and get_value(payment, 'APAccountRef', None) is not None else {}
                    currency_ref = payment.get('CurrencyRef', {}) if hasattr(payment, 'get') and get_value(payment, 'CurrencyRef', None) is not None else {}
                    
                    base_data.update({
                        'VendorRef_value': get_value(vendor_ref, 'value', ''),
                        'VendorRef_name': get_value(vendor_ref, 'name', ''),
                        'DepartmentRef_value': get_value(dept_ref, 'value', ''),
                        'DepartmentRef_name': get_value(dept_ref, 'name', ''),
                        'APAccountRef_value': get_value(ap_ref, 'value', ''),
                        'APAccountRef_name': get_value(ap_ref, 'name', ''),
                        'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                        'CurrencyRef_name': get_value(currency_ref, 'name', '')
                    })
                    
                    # Handle payment method specific fields
                    if hasattr(payment, 'get') and payment.get('CheckPayment'):
                        check_payment = payment.get('CheckPayment', {})
                        bank_ref = check_payment.get('BankAccountRef', {}) if hasattr(check_payment, 'get') else {}
                        base_data.update({
                            'CheckPayment_BankAccountRef_value': get_value(bank_ref, 'value', ''),
                            'CheckPayment_BankAccountRef_name': get_value(bank_ref, 'name', ''),
                            'CheckPayment_PrintStatus': get_value(check_payment, 'PrintStatus', '')
                        })
                    elif hasattr(payment, 'get') and payment.get('CreditCardPayment'):
                        cc_payment = payment.get('CreditCardPayment', {})
                        cc_ref = cc_payment.get('CCAccountRef', {}) if hasattr(cc_payment, 'get') else {}
                        base_data.update({
                            'CreditCardPayment_CCAccountRef_value': get_value(cc_ref, 'value', ''),
                            'CreditCardPayment_CCAccountRef_name': get_value(cc_ref, 'name', '')
                        })
                    
                    # Handle MetaData
                    metadata = payment.get('MetaData', {}) if hasattr(payment, 'get') and get_value(payment, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    processed_lines.append(base_data)
                
                return processed_lines
            
            # Use streaming processing
            LoadType = 'Full'
            base_query = 'SELECT * FROM BillPayment ORDERBY MetaData.LastUpdatedTime'
            
            StageCount = process_paginated_data_streaming(
                endpoint=endpoint,
                base_query=base_query,
                processor_func=process_billpayment_record,
                stage_table=StageTable,
                load_type=LoadType,
                max_results=1000
            )
            
            # Execute stored procedure and finish
            ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
            ProdCount = GetProdCount(ProdTable)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint in ['VendorCredit', 'Purchase', 'PurchaseOrder']:
            LoadType = 'Full'
            params = {'query': f'SELECT * FROM {endpoint}'}
            
            try:
                with QBORequestsManager(endpoint, params) as All_Data:
                    combined_data = []
                    if All_Data is None or All_Data.empty:
                        print(f"{endpoint} - No data retrieved from API")
                        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Failed', endpoint, 'EVA', StartUTCDate, 0, 0)
                    else:
                        for index, txn in All_Data.iterrows():
                            # Skip if txn is not a proper pandas Series or dict-like object
                            if not isinstance(txn, (pd.Series, dict)):
                                print(f"Skipping invalid {endpoint} data type: {type(txn)}")
                                continue
                            
                            # Ensure txn has get method (handle both Series and dict)
                            if not hasattr(txn, 'get'):
                                print(f"Skipping {endpoint} without get method: {type(txn)}")
                                continue
                            
                            # Process each line item
                            lines = txn.get('Line', []) if hasattr(txn, 'get') else []
                            if not lines:
                                # Create a dummy line if no lines exist
                                lines = [{}]
                            
                            for line_index, line in enumerate(lines or []):
                                if not isinstance(line, dict):
                                    line = {}  # Convert to empty dict instead of skipping
                                
                                base_data = {
                                    'Id': get_value(txn, 'Id', ''),
                                    'SyncToken': get_value(txn, 'SyncToken', ''),
                                    'DocNumber': get_value(txn, 'DocNumber', ''),
                                    'TxnDate': get_value(txn, 'TxnDate', None),
                                    'TotalAmt': get_value(txn, 'TotalAmt', 0.0),
                                    'PrivateNote': get_value(txn, 'PrivateNote', ''),
                                    'ExchangeRate': get_value(txn, 'ExchangeRate', 1.0),
                                    'GlobalTaxCalculation': get_value(txn, 'GlobalTaxCalculation', ''),
                                    'TransactionLocationType': get_value(txn, 'TransactionLocationType', ''),
                                    'sparse': get_value(txn, 'sparse', False),
                                    'domain': get_value(txn, 'domain', ''),
                                    'ClientID': EtaniClientID,
                                    'OrganisationID': LegacyOrganisationID
                                }
                                
                                # Add endpoint-specific fields
                                if endpoint == 'VendorCredit':
                                    base_data['Balance'] = get_value(txn, 'Balance', 0.0)
                                elif endpoint == 'Purchase':
                                    purchase_ex = txn.get('PurchaseEx', {}) if hasattr(txn, 'get') else {}
                                    base_data.update({
                                        'PaymentType': get_value(txn, 'PaymentType', ''),
                                        'Credit': get_value(txn, 'Credit', False),
                                        'PrintStatus': get_value(txn, 'PrintStatus', ''),
                                        'PurchaseEx_Any': json.dumps(purchase_ex)
                                    })
                                elif endpoint == 'PurchaseOrder':
                                    po_email = txn.get('POEmail', {}) if hasattr(txn, 'get') else {}
                                    memo = txn.get('Memo', {}) if hasattr(txn, 'get') else {}
                                    po_ex = txn.get('POEx', {}) if hasattr(txn, 'get') else {}
                                    base_data.update({
                                        'DueDate': get_value(txn, 'DueDate', None),
                                        'POStatus': get_value(txn, 'POStatus', ''),
                                        'POEmail_Address': get_value(po_email, 'Address', ''),
                                        'EmailStatus': get_value(txn, 'EmailStatus', ''),
                                        'Memo_value': get_value(memo, 'value', ''),
                                        'POEx_Any': json.dumps(po_ex)
                                    })
                                
                                # Line item details - Use Line.Id from API as primary LineId
                                api_line_id = get_value(line, 'Id', '')
                                txn_id = get_value(txn, 'Id', '') or 'unknown'
                                
                                # Use API Line.Id if available, otherwise generate
                                if api_line_id:
                                    line_id = f"{txn_id}_{api_line_id}"
                                else:
                                    line_id = f"{txn_id}_{line_index + 1}"  # Use 1-based indexing
                                
                                # Multiple fallbacks to ensure LineId is NEVER null
                                if not line_id or line_id == '_1' or line_id == 'None_1':
                                    line_id = f"unknown_{line_index + 1}"
                                
                                if not line_id or len(str(line_id).strip()) == 0:
                                    line_id = f"fallback_{endpoint}_{line_index + 1}"
                                
                                # Absolute final fallback - NEVER allow NULL
                                if not line_id:
                                    line_id = f"emergency_{line_index + 1}"
                                    
                                # Debug: Print LineId for troubleshooting
                                if endpoint == 'PurchaseOrder' and line_index == 0:
                                    print(f"DEBUG: PurchaseOrder LineId: '{line_id}' (API Line.Id: '{api_line_id}', txn_id: '{txn_id}')")
                                
                                base_data.update({
                                    'LineId': line_id,
                                    'Line_Id': get_value(line, 'Id', ''),
                                    'Line_LineNum': get_value(line, 'LineNum', line_index),
                                    'Line_Description': get_value(line, 'Description', ''),
                                    'Line_Amount': get_value(line, 'Amount', 0.0),
                                    'Line_DetailType': get_value(line, 'DetailType', '')
                                })
                                
                                # Handle AccountBasedExpenseLineDetail
                                if line.get('DetailType') == 'AccountBasedExpenseLineDetail':
                                    detail = line.get('AccountBasedExpenseLineDetail', {})
                                    base_data.update({
                                        'AccountBasedExpenseLineDetail_AccountRef_value': get_value(detail.get('AccountRef', {}), 'value', ''),
                                        'AccountBasedExpenseLineDetail_AccountRef_name': get_value(detail.get('AccountRef', {}), 'name', ''),
                                        'AccountBasedExpenseLineDetail_BillableStatus': get_value(detail, 'BillableStatus', ''),
                                        'AccountBasedExpenseLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', ''),
                                        'AccountBasedExpenseLineDetail_TaxAmount': get_value(detail, 'TaxAmount', 0.0),
                                        'AccountBasedExpenseLineDetail_ClassRef_value': get_value(detail.get('ClassRef', {}), 'value', ''),
                                        'AccountBasedExpenseLineDetail_ClassRef_name': get_value(detail.get('ClassRef', {}), 'name', ''),
                                        'AccountBasedExpenseLineDetail_CustomerRef_value': get_value(detail.get('CustomerRef', {}), 'value', ''),
                                        'AccountBasedExpenseLineDetail_CustomerRef_name': get_value(detail.get('CustomerRef', {}), 'name', '')
                                    })
                                
                                # Handle ItemBasedExpenseLineDetail
                                elif line.get('DetailType') == 'ItemBasedExpenseLineDetail':
                                    detail = line.get('ItemBasedExpenseLineDetail', {})
                                    base_data.update({
                                        'ItemBasedExpenseLineDetail_ItemRef_value': get_value(detail.get('ItemRef', {}), 'value', ''),
                                        'ItemBasedExpenseLineDetail_ItemRef_name': get_value(detail.get('ItemRef', {}), 'name', ''),
                                        'ItemBasedExpenseLineDetail_ClassRef_value': get_value(detail.get('ClassRef', {}), 'value', ''),
                                        'ItemBasedExpenseLineDetail_ClassRef_name': get_value(detail.get('ClassRef', {}), 'name', ''),
                                        'ItemBasedExpenseLineDetail_UnitPrice': get_value(detail, 'UnitPrice', 0.0),
                                        'ItemBasedExpenseLineDetail_Qty': get_value(detail, 'Qty', 0),
                                        'ItemBasedExpenseLineDetail_TaxCodeRef_value': get_value(detail.get('TaxCodeRef', {}), 'value', ''),
                                        'ItemBasedExpenseLineDetail_CustomerRef_value': get_value(detail.get('CustomerRef', {}), 'value', ''),
                                        'ItemBasedExpenseLineDetail_CustomerRef_name': get_value(detail.get('CustomerRef', {}), 'name', ''),
                                        'ItemBasedExpenseLineDetail_BillableStatus': get_value(detail, 'BillableStatus', '')
                                    })
                                
                                # Handle vendor/entity references
                                if endpoint in ['VendorCredit', 'PurchaseOrder']:
                                    vendor_ref = txn.get('VendorRef', {}) if hasattr(txn, 'get') and get_value(txn, 'VendorRef', None) is not None else {}
                                    base_data.update({
                                        'VendorRef_value': get_value(vendor_ref, 'value', ''),
                                        'VendorRef_name': get_value(vendor_ref, 'name', '')
                                    })
                                elif endpoint == 'Purchase':
                                    entity_ref = txn.get('EntityRef', {}) if hasattr(txn, 'get') and get_value(txn, 'EntityRef', None) is not None else {}
                                    base_data.update({
                                        'EntityRef_value': get_value(entity_ref, 'value', ''),
                                        'EntityRef_name': get_value(entity_ref, 'name', ''),
                                        'EntityRef_type': get_value(entity_ref, 'type', '')
                                    })
                                    account_ref = txn.get('AccountRef', {}) if hasattr(txn, 'get') and get_value(txn, 'AccountRef', None) is not None else {}
                                    base_data.update({
                                        'AccountRef_value': get_value(account_ref, 'value', ''),
                                        'AccountRef_name': get_value(account_ref, 'name', '')
                                    })
                                
                                # Handle common references
                                ap_ref = txn.get('APAccountRef', {}) if hasattr(txn, 'get') and get_value(txn, 'APAccountRef', None) is not None else {}
                                dept_ref = txn.get('DepartmentRef', {}) if hasattr(txn, 'get') and get_value(txn, 'DepartmentRef', None) is not None else {}
                                currency_ref = txn.get('CurrencyRef', {}) if hasattr(txn, 'get') and get_value(txn, 'CurrencyRef', None) is not None else {}
                                
                                if endpoint in ['VendorCredit', 'PurchaseOrder']:
                                    base_data.update({
                                        'APAccountRef_value': get_value(ap_ref, 'value', ''),
                                        'APAccountRef_name': get_value(ap_ref, 'name', '')
                                    })
                                
                                base_data.update({
                                    'DepartmentRef_value': get_value(dept_ref, 'value', ''),
                                    'DepartmentRef_name': get_value(dept_ref, 'name', ''),
                                    'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                                    'CurrencyRef_name': get_value(currency_ref, 'name', '')
                                })
                                
                                # Handle tax details
                                txn_tax_detail = txn.get('TxnTaxDetail', {}) if hasattr(txn, 'get') else {}
                                if txn_tax_detail and isinstance(txn_tax_detail, dict):
                                    txn_tax_code_ref = txn_tax_detail.get('TxnTaxCodeRef', {}) if hasattr(txn_tax_detail, 'get') else {}
                                    base_data.update({
                                        'TxnTaxDetail_TxnTaxCodeRef_value': get_value(txn_tax_code_ref, 'value', ''),
                                        'TxnTaxDetail_TotalTax': get_value(txn_tax_detail, 'TotalTax', 0.0)
                                    })
                                
                                # Handle LinkedTxn for PurchaseOrder
                                if endpoint == 'PurchaseOrder':
                                    linked_txns = txn.get('LinkedTxn', []) if hasattr(txn, 'get') else []
                                    if linked_txns and isinstance(linked_txns, list) and len(linked_txns) > 0:
                                        linked_txn = linked_txns[0]
                                        base_data.update({
                                            'LinkedTxn_TxnId': get_value(linked_txn, 'TxnId', ''),
                                            'LinkedTxn_TxnType': get_value(linked_txn, 'TxnType', ''),
                                            'LinkedTxn_TxnLineId': get_value(linked_txn, 'TxnLineId', '')
                                        })
                                
                                # Handle addresses for VendorCredit and Purchase
                                if endpoint in ['VendorCredit', 'Purchase']:
                                    vendor_addr = txn.get('VendorAddr', {}) if hasattr(txn, 'get') and get_value(txn, 'VendorAddr', None) is not None else {}
                                    for i in range(1, 6):
                                        base_data[f'VendorAddr_Line{i}'] = get_value(vendor_addr, f'Line{i}', '')
                                    base_data.update({
                                        'VendorAddr_Id': get_value(vendor_addr, 'Id', ''),
                                        'VendorAddr_City': get_value(vendor_addr, 'City', ''),
                                        'VendorAddr_Country': get_value(vendor_addr, 'Country', ''),
                                        'VendorAddr_CountrySubDivisionCode': get_value(vendor_addr, 'CountrySubDivisionCode', ''),
                                        'VendorAddr_PostalCode': get_value(vendor_addr, 'PostalCode', '')
                                    })
                                    if endpoint == 'VendorCredit':
                                        base_data.update({
                                            'VendorAddr_Lat': get_value(vendor_addr, 'Lat', ''),
                                            'VendorAddr_Long': get_value(vendor_addr, 'Long', '')
                                        })
                                
                                # Handle ShipAddr for PurchaseOrder
                                if endpoint == 'PurchaseOrder':
                                    for addr_type in ['VendorAddr', 'ShipAddr']:
                                        addr = txn.get(addr_type, {}) if hasattr(txn, 'get') and get_value(txn, addr_type, None) is not None else {}
                                        for i in range(1, 6):
                                            base_data[f'{addr_type}_Line{i}'] = get_value(addr, f'Line{i}', '')
                                        base_data.update({
                                            f'{addr_type}_Id': get_value(addr, 'Id', ''),
                                            f'{addr_type}_City': get_value(addr, 'City', ''),
                                            f'{addr_type}_Country': get_value(addr, 'Country', ''),
                                            f'{addr_type}_CountrySubDivisionCode': get_value(addr, 'CountrySubDivisionCode', ''),
                                            f'{addr_type}_PostalCode': get_value(addr, 'PostalCode', '')
                                        })
                                
                                # Handle MetaData
                                metadata = txn.get('MetaData', {}) if hasattr(txn, 'get') and get_value(txn, 'MetaData', None) is not None else {}
                                base_data.update({
                                    'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                                    'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                                })
                                
                                combined_data.append(base_data)
                        
                        # Process data
                        if combined_data:
                            Combined_Data = pd.DataFrame(combined_data)
                            ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                            
                            WriteMode = "overwrite"
                            LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                            StageCount = len(ConvertedData)
                            
                            ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                            ProdCount = GetProdCount(ProdTable)
                            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
            except Exception as e:
                print(f"{endpoint} - Error during processing: {str(e)}")
                import traceback
                traceback.print_exc()
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Failed', endpoint, 'EVA', StartUTCDate, 0, 0)
                
        elif endpoint == 'Deposit':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Deposit ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for deposit in paginated_data:
                    # Process each line item
                    for line_index, line in enumerate(deposit.get('Line', []) or []):
                        if not isinstance(line, dict):
                            continue
                            
                        base_data = {
                            'Id': get_value(deposit, 'Id', ''),
                            'SyncToken': get_value(deposit, 'SyncToken', ''),
                            'TxnDate': get_value(deposit, 'TxnDate', None),
                            'TotalAmt': get_value(deposit, 'TotalAmt', 0.0),
                            'HomeTotalAmt': get_value(deposit, 'HomeTotalAmt', 0.0),
                            'ExchangeRate': get_value(deposit, 'ExchangeRate', 1.0),
                            'PrivateNote': get_value(deposit, 'PrivateNote', ''),
                            'GlobalTaxCalculation': get_value(deposit, 'GlobalTaxCalculation', ''),
                            'TxnStatus': get_value(deposit, 'TxnStatus', ''),
                            'TransactionLocationType': get_value(deposit, 'TransactionLocationType', ''),
                            'sparse': get_value(deposit, 'sparse', False),
                            'domain': get_value(deposit, 'domain', ''),
                            'ClientID': EtaniClientID,
                            'OrganisationID': LegacyOrganisationID
                        }
                        
                        # Line item details
                        base_data.update({
                            'LineId': f"{get_value(deposit, 'Id')}_{line_index}",
                            'Line_Id': get_value(line, 'Id', ''),
                            'Line_LineNum': get_value(line, 'LineNum', line_index),
                            'Line_Description': get_value(line, 'Description', ''),
                            'Line_Amount': get_value(line, 'Amount', 0.0),
                            'Line_DetailType': get_value(line, 'DetailType', '')
                        })
                        
                        # Handle LinkedTxn
                        linked_txns = line.get('LinkedTxn', [])
                        if linked_txns and isinstance(linked_txns, list) and len(linked_txns) > 0:
                            linked_txn = linked_txns[0]
                            base_data.update({
                                'Line_LinkedTxn_TxnId': get_value(linked_txn, 'TxnId', ''),
                                'Line_LinkedTxn_TxnType': get_value(linked_txn, 'TxnType', ''),
                                'Line_LinkedTxn_TxnLineId': get_value(linked_txn, 'TxnLineId', '')
                            })
                        
                        # Handle DepositLineDetail
                        if line.get('DetailType') == 'DepositLineDetail':
                            detail = line.get('DepositLineDetail', {})
                            entity = detail.get('Entity', {})
                            base_data.update({
                                'DepositLineDetail_Entity_value': get_value(entity, 'value', ''),
                                'DepositLineDetail_Entity_name': get_value(entity, 'name', ''),
                                'DepositLineDetail_Entity_type': get_value(entity, 'type', ''),
                                'DepositLineDetail_ClassRef_value': get_value(detail.get('ClassRef', {}), 'value', ''),
                                'DepositLineDetail_ClassRef_name': get_value(detail.get('ClassRef', {}), 'name', ''),
                                'DepositLineDetail_AccountRef_value': get_value(detail.get('AccountRef', {}), 'value', ''),
                                'DepositLineDetail_AccountRef_name': get_value(detail.get('AccountRef', {}), 'name', ''),
                                'DepositLineDetail_PaymentMethodRef_value': get_value(detail.get('PaymentMethodRef', {}), 'value', ''),
                                'DepositLineDetail_PaymentMethodRef_name': get_value(detail.get('PaymentMethodRef', {}), 'name', ''),
                                'DepositLineDetail_CheckNum': get_value(detail, 'CheckNum', ''),
                                'DepositLineDetail_TxnType': get_value(detail, 'TxnType', '')
                            })
                        
                        # Handle references
                        deposit_to_ref = deposit.get('DepositToAccountRef', {}) if get_value(deposit, 'DepositToAccountRef', None) is not None else {}
                        currency_ref = deposit.get('CurrencyRef', {}) if get_value(deposit, 'CurrencyRef', None) is not None else {}
                        dept_ref = deposit.get('DepartmentRef', {}) if get_value(deposit, 'DepartmentRef', None) is not None else {}
                        
                        base_data.update({
                            'DepositToAccountRef_value': get_value(deposit_to_ref, 'value', ''),
                            'DepositToAccountRef_name': get_value(deposit_to_ref, 'name', ''),
                            'CurrencyRef_value': get_value(currency_ref, 'value', ''),
                            'CurrencyRef_name': get_value(currency_ref, 'name', ''),
                            'DepartmentRef_value': get_value(dept_ref, 'value', ''),
                            'DepartmentRef_name': get_value(dept_ref, 'name', '')
                        })
                        
                        # Handle CashBack
                        cash_back = deposit.get('CashBack', {})
                        if cash_back:
                            base_data.update({
                                'CashBack_AccountRef_value': get_value(cash_back.get('AccountRef', {}), 'value', ''),
                                'CashBack_AccountRef_name': get_value(cash_back.get('AccountRef', {}), 'name', ''),
                                'CashBack_Amount': get_value(cash_back, 'Amount', 0.0),
                                'CashBack_Memo': get_value(cash_back, 'Memo', '')
                            })
                        
                        # Handle tax details
                        txn_tax_detail = deposit.get('TxnTaxDetail', {})
                        if txn_tax_detail:
                            base_data.update({
                                'TxnTaxDetail_TxnTaxCodeRef_value': get_value(txn_tax_detail.get('TxnTaxCodeRef', {}), 'value', ''),
                                'TxnTaxDetail_TotalTax': get_value(txn_tax_detail, 'TotalTax', 0.0)
                            })
                        
                        # Handle MetaData
                        metadata = deposit.get('MetaData', {}) if get_value(deposit, 'MetaData', None) is not None else {}
                        base_data.update({
                            'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                            'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                        })
                        
                        combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Transfer':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Transfer ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for transfer in paginated_data:
                    base_data = {
                        'Id': get_value(transfer, 'Id', ''),
                        'SyncToken': get_value(transfer, 'SyncToken', ''),
                        'TxnDate': get_value(transfer, 'TxnDate', None),
                        'Amount': get_value(transfer, 'Amount', 0.0),
                        'PrivateNote': get_value(transfer, 'PrivateNote', ''),
                        'sparse': get_value(transfer, 'sparse', False),
                        'domain': get_value(transfer, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle account references
                    from_ref = transfer.get('FromAccountRef', {}) if get_value(transfer, 'FromAccountRef', None) is not None else {}
                    to_ref = transfer.get('ToAccountRef', {}) if get_value(transfer, 'ToAccountRef', None) is not None else {}
                    base_data.update({
                        'FromAccountRef_value': get_value(from_ref, 'value', ''),
                        'FromAccountRef_name': get_value(from_ref, 'name', ''),
                        'ToAccountRef_value': get_value(to_ref, 'value', ''),
                        'ToAccountRef_name': get_value(to_ref, 'name', '')
                    })
                    
                    # Handle MetaData
                    metadata = transfer.get('MetaData', {}) if get_value(transfer, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'TimeActivity':
            LoadType = 'Full'
            base_query = 'SELECT * FROM TimeActivity ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for activity in paginated_data:
                    base_data = {
                        'Id': get_value(activity, 'Id', ''),
                        'SyncToken': get_value(activity, 'SyncToken', ''),
                        'TxnDate': get_value(activity, 'TxnDate', None),
                        'NameOf': get_value(activity, 'NameOf', ''),
                        'HourlyRate': get_value(activity, 'HourlyRate', 0.0),
                        'BreakHours': get_value(activity, 'BreakHours', 0),
                        'BreakMinutes': get_value(activity, 'BreakMinutes', 0),
                        'StartTime': get_value(activity, 'StartTime', None),
                        'EndTime': get_value(activity, 'EndTime', None),
                        'Hours': get_value(activity, 'Hours', 0),
                        'Minutes': get_value(activity, 'Minutes', 0),
                        'Description': get_value(activity, 'Description', ''),
                        'Billable': get_value(activity, 'Billable', False),
                        'BillableStatus': get_value(activity, 'BillableStatus', ''),
                        'Taxable': get_value(activity, 'Taxable', False),
                        'sparse': get_value(activity, 'sparse', False),
                        'domain': get_value(activity, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle references
                    employee_ref = activity.get('EmployeeRef', {}) if get_value(activity, 'EmployeeRef', None) is not None else {}
                    vendor_ref = activity.get('VendorRef', {}) if get_value(activity, 'VendorRef', None) is not None else {}
                    customer_ref = activity.get('CustomerRef', {}) if get_value(activity, 'CustomerRef', None) is not None else {}
                    item_ref = activity.get('ItemRef', {}) if get_value(activity, 'ItemRef', None) is not None else {}
                    class_ref = activity.get('ClassRef', {}) if get_value(activity, 'ClassRef', None) is not None else {}
                    payroll_ref = activity.get('PayrollItemRef', {}) if get_value(activity, 'PayrollItemRef', None) is not None else {}
                    dept_ref = activity.get('DepartmentRef', {}) if get_value(activity, 'DepartmentRef', None) is not None else {}
                    
                    base_data.update({
                        'EmployeeRef_value': get_value(employee_ref, 'value', ''),
                        'EmployeeRef_name': get_value(employee_ref, 'name', ''),
                        'VendorRef_value': get_value(vendor_ref, 'value', ''),
                        'VendorRef_name': get_value(vendor_ref, 'name', ''),
                        'CustomerRef_value': get_value(customer_ref, 'value', ''),
                        'CustomerRef_name': get_value(customer_ref, 'name', ''),
                        'ItemRef_value': get_value(item_ref, 'value', ''),
                        'ItemRef_name': get_value(item_ref, 'name', ''),
                        'ClassRef_value': get_value(class_ref, 'value', ''),
                        'ClassRef_name': get_value(class_ref, 'name', ''),
                        'PayrollItemRef_value': get_value(payroll_ref, 'value', ''),
                        'PayrollItemRef_name': get_value(payroll_ref, 'name', ''),
                        'DepartmentRef_value': get_value(dept_ref, 'value', ''),
                        'DepartmentRef_name': get_value(dept_ref, 'name', '')
                    })
                    
                    # Handle MetaData
                    metadata = activity.get('MetaData', {}) if get_value(activity, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Budget':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Budget ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for budget in paginated_data:
                    # Process each budget detail line
                    budget_details = budget.get('BudgetDetail', []) or []
                    if budget_details:
                        for detail in budget_details:
                            base_data = {
                                'Id': get_value(budget, 'Id', ''),
                                'SyncToken': get_value(budget, 'SyncToken', ''),
                                'Name': get_value(budget, 'Name', ''),
                                'StartDate': get_value(budget, 'StartDate', None),
                                'EndDate': get_value(budget, 'EndDate', None),
                                'BudgetType': get_value(budget, 'BudgetType', ''),
                                'Active': get_value(budget, 'Active', False),
                                'sparse': get_value(budget, 'sparse', False),
                                'domain': get_value(budget, 'domain', ''),
                                'ClientID': EtaniClientID,
                                'OrganisationID': LegacyOrganisationID
                            }
                            
                            # Budget detail fields
                            base_data.update({
                                'BudgetDetail_BudgetDate': get_value(detail, 'BudgetDate', None),
                                'BudgetDetail_Amount': get_value(detail, 'Amount', 0.0),
                                'BudgetDetail_AccountRef_value': get_value(detail.get('AccountRef', {}), 'value', ''),
                                'BudgetDetail_AccountRef_name': get_value(detail.get('AccountRef', {}), 'name', ''),
                                'BudgetDetail_CustomerRef_value': get_value(detail.get('CustomerRef', {}), 'value', ''),
                                'BudgetDetail_CustomerRef_name': get_value(detail.get('CustomerRef', {}), 'name', ''),
                                'BudgetDetail_ClassRef_value': get_value(detail.get('ClassRef', {}), 'value', ''),
                                'BudgetDetail_ClassRef_name': get_value(detail.get('ClassRef', {}), 'name', ''),
                                'BudgetDetail_DepartmentRef_value': get_value(detail.get('DepartmentRef', {}), 'value', ''),
                                'BudgetDetail_DepartmentRef_name': get_value(detail.get('DepartmentRef', {}), 'name', '')
                            })
                            
                            # Handle MetaData
                            metadata = budget.get('MetaData', {}) if get_value(budget, 'MetaData', None) is not None else {}
                            base_data.update({
                                'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                                'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                            })
                            
                            combined_data.append(base_data)
                    else:
                        # If no budget details, create one row with basic data
                        base_data = {
                            'Id': get_value(budget, 'Id', ''),
                            'SyncToken': get_value(budget, 'SyncToken', ''),
                            'Name': get_value(budget, 'Name', ''),
                            'StartDate': get_value(budget, 'StartDate', None),
                            'EndDate': get_value(budget, 'EndDate', None),
                            'BudgetType': get_value(budget, 'BudgetType', ''),
                            'Active': get_value(budget, 'Active', False),
                            'sparse': get_value(budget, 'sparse', False),
                            'domain': get_value(budget, 'domain', ''),
                            'ClientID': EtaniClientID,
                            'OrganisationID': LegacyOrganisationID
                        }
                        
                        # Handle MetaData
                        metadata = budget.get('MetaData', {}) if get_value(budget, 'MetaData', None) is not None else {}
                        base_data.update({
                            'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                            'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                        })
                        
                        combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'CompanyCurrency':
            LoadType = 'Full'
            base_query = 'SELECT * FROM CompanyCurrency ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for currency in paginated_data:
                    base_data = {
                        'Id': get_value(currency, 'Id', ''),
                        'SyncToken': get_value(currency, 'SyncToken', ''),
                        'Code': get_value(currency, 'Code', ''),
                        'Name': get_value(currency, 'Name', ''),
                        'Active': get_value(currency, 'Active', False),
                        'sparse': get_value(currency, 'sparse', False),
                        'domain': get_value(currency, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle MetaData
                    metadata = currency.get('MetaData', {}) if get_value(currency, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'ExchangeRate':
            LoadType = 'Full'
            base_query = 'SELECT * FROM ExchangeRate ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for rate in paginated_data:
                    base_data = {
                        'SourceCurrencyCode': get_value(rate, 'SourceCurrencyCode', ''),
                        'TargetCurrencyCode': get_value(rate, 'TargetCurrencyCode', ''),
                        'Rate': get_value(rate, 'Rate', 0.0),
                        'AsOfDate': get_value(rate, 'AsOfDate', None),
                        'sparse': get_value(rate, 'sparse', False),
                        'domain': get_value(rate, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # ExchangeRate doesn't have MetaData
                    metadata = rate.get('MetaData', {}) if get_value(rate, 'MetaData', None) is not None else {}
                    if metadata:
                        base_data.update({
                            'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                            'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                        })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Preferences':
            LoadType = 'Full'
            base_query = 'SELECT * FROM Preferences ORDERBY MetaData.LastUpdatedTime'
            paginated_data = get_paginated_data(endpoint, base_query, max_results=1000)
            
            combined_data = []
            for prefs in paginated_data:
                    base_data = {
                        'Id': get_value(prefs, 'Id', ''),
                        'SyncToken': get_value(prefs, 'SyncToken', ''),
                        'AccountingInfoPrefs': json.dumps(prefs.get('AccountingInfoPrefs', {})),
                        'ProductAndServicesPrefs': json.dumps(prefs.get('ProductAndServicesPrefs', {})),
                        'SalesFormsPrefs': json.dumps(prefs.get('SalesFormsPrefs', {})),
                        'EmailMessagesPrefs': json.dumps(prefs.get('EmailMessagesPrefs', {})),
                        'VendorAndPurchasesPrefs': json.dumps(prefs.get('VendorAndPurchasesPrefs', {})),
                        'TimeTrackingPrefs': json.dumps(prefs.get('TimeTrackingPrefs', {})),
                        'TaxPrefs': json.dumps(prefs.get('TaxPrefs', {})),
                        'CurrencyPrefs': json.dumps(prefs.get('CurrencyPrefs', {})),
                        'ReportPrefs': json.dumps(prefs.get('ReportPrefs', {})),
                        'OtherPrefs': json.dumps(prefs.get('OtherPrefs', {})),
                        'sparse': get_value(prefs, 'sparse', False),
                        'domain': get_value(prefs, 'domain', ''),
                        'ClientID': EtaniClientID,
                        'OrganisationID': LegacyOrganisationID
                    }
                    
                    # Handle MetaData
                    metadata = prefs.get('MetaData', {}) if get_value(prefs, 'MetaData', None) is not None else {}
                    base_data.update({
                        'MetaData_CreateTime': get_value(metadata, 'CreateTime', None),
                        'MetaData_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                    })
                    
                    combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint == 'Attachable':
            def process_attachable_record(attachable):
                """Process a single attachable record"""
                base_data = {
                    'Id': get_value(attachable, 'Id', ''),
                    'SyncToken': get_value(attachable, 'SyncToken', ''),
                    'FileName': get_value(attachable, 'FileName', ''),
                    'ContentType': get_value(attachable, 'ContentType', ''),
                    'Size': get_value(attachable, 'Size', 0),
                    'Note': get_value(attachable, 'Note', ''),
                    'PlaceName': get_value(attachable, 'PlaceName', ''),
                    'sparse': get_value(attachable, 'sparse', False),
                    'domain': get_value(attachable, 'domain', ''),
                    'ClientID': EtaniClientID,
                    'OrganisationID': LegacyOrganisationID
                }
                
                # Handle LatLong
                lat_long = attachable.get('LatLong', {}) if get_value(attachable, 'LatLong', None) is not None else {}
                base_data.update({
                    'LatLong_Value': get_value(lat_long, 'Value', ''),
                    'LatLong_Lat': get_value(lat_long, 'Lat', 0.0),
                    'LatLong_Long': get_value(lat_long, 'Long', 0.0)
                })
                
                # Handle AttachableRef (usually just one, not array)
                attachable_ref = attachable.get('AttachableRef', {}) if get_value(attachable, 'AttachableRef', None) is not None else {}
                if isinstance(attachable_ref, list) and len(attachable_ref) > 0:
                    attachable_ref = attachable_ref[0]
                
                entity_ref = attachable_ref.get('EntityRef', {}) if attachable_ref else {}
                base_data.update({
                    'AttachableRef_EntityRef_Type': get_value(entity_ref, 'Type', ''),
                    'AttachableRef_EntityRef_Value': get_value(entity_ref, 'Value', ''),
                    'AttachableRef_EntityRef_Name': get_value(entity_ref, 'Name', ''),
                    'AttachableRef_IncludeOnSend': get_value(attachable_ref, 'IncludeOnSend', False) if attachable_ref else False
                })
                
                # Handle MetaData (note the lowercase field names for Attachable)
                metadata = attachable.get('MetaData', {}) if get_value(attachable, 'MetaData', None) is not None else {}
                base_data.update({
                    'metadata_CreateTime': get_value(metadata, 'CreateTime', None),
                    'metadata_LastUpdatedTime': get_value(metadata, 'LastUpdatedTime', None)
                })
                
                return [base_data]  # Return as list for consistency with other processors
            
            LoadType = 'Full'
            base_query = 'SELECT * FROM Attachable ORDERBY MetaData.LastUpdatedTime'
            
            print(f"{endpoint} - Starting streaming pagination processing")
            StageCount = process_paginated_data_streaming(
                endpoint=endpoint,
                base_query=base_query,
                processor_func=process_attachable_record,
                stage_table=StageTable,
                load_type=LoadType,
                max_results=1000
            )
            
            # Execute stored procedure and finish  
            ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
            ProdCount = GetProdCount(ProdTable)
            LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                
        elif endpoint in ['BalanceSheet', 'ProfitAndLoss', 'CashFlow', 'TrialBalance', 'GeneralLedger', 'VendorBalanceDetail', 'CustomerBalanceDetail', 'InventoryValuationSummary']:
            # Report endpoints
            LoadType = 'Full'
            params = {}
            
            # Add required parameters for specific reports
            if endpoint in ['APAgingDetail', 'APAgingSummary', 'ARAgingDetail', 'ARAgingSummary']:
                # Aging reports may require date parameters
                params['report_date'] = datetime.now().strftime('%Y-%m-%d')
                params['aging_method'] = 'Report_Date'
            elif endpoint == 'AccountListDetail':
                # AccountListDetail may require specific parameters
                params['columns'] = 'account_num,account_name,account_type'
            
            with QBORequestsManager(endpoint, params) as All_Data:
                combined_data = []
                
                if not All_Data.empty:
                    report_data = All_Data.iloc[0]
                    
                    # Extract header information
                    header = report_data.get('Header', {})
                    report_name = get_value(header, 'ReportName', '')
                    currency = get_value(header, 'Currency', '')
                    start_period = get_value(header, 'StartPeriod', '')
                    end_period = get_value(header, 'EndPeriod', '')
                    time = get_value(header, 'Time', '')
                    
                    # Extract options
                    options = []
                    for option in header.get('Option', []) or []:
                        if isinstance(option, dict):
                            options.append({
                                'Name': option.get('Name', ''),
                                'Value': option.get('Value', '')
                            })
                    
                    # Extract column headers
                    columns = report_data.get('Columns', {})
                    column_headers = []
                    for col in columns.get('Column', []) or []:
                        if isinstance(col, dict):
                            column_headers.append({
                                'ColTitle': col.get('ColTitle', ''),
                                'ColType': col.get('ColType', '')
                            })
                    
                    # Process rows
                    rows = report_data.get('Rows', {}).get('Row', []) or []
                    for row_index, row in enumerate(rows):
                        if not isinstance(row, dict):
                            continue
                        
                        row_id = get_value(row, 'id', f'row_{row_index}')
                        row_type = get_value(row, 'type', '')
                        row_group = get_value(row, 'group', '')
                        row_header = get_value(row, 'header', False)
                        row_summary = get_value(row, 'summary', False)
                        
                        # Process column data
                        col_data_list = row.get('ColData', []) or []
                        
                        base_data = {
                            'ReportName': report_name,
                            'Currency': currency,
                            'Time': time,
                            'Row_Id': row_id,
                            'Row_Type': row_type,
                            'Row_Group': row_group,
                            'Row_Header': row_header,
                            'Row_Summary': row_summary,
                            'ClientID': EtaniClientID,
                            'OrganisationID': LegacyOrganisationID
                        }
                        
                        # Add date fields based on endpoint
                        if endpoint == 'InventoryValuationSummary':
                            base_data['AsOfDate'] = get_value(header, 'AsOfDate', '')
                        else:
                            base_data['StartPeriod'] = start_period
                            base_data['EndPeriod'] = end_period
                        
                        # Add endpoint-specific fields for aging reports
                        if endpoint in ['APAgingSummary', 'ARAgingSummary']:
                            base_data['DateMacro'] = get_value(header, 'DateMacro', '')
                        
                        # Add column data dynamically based on report type
                        if endpoint == 'AccountListDetail':
                            # AccountListDetail has specific Account_Name and Account_Type columns
                            if len(col_data_list) >= 1:
                                base_data['Account_Name'] = get_value(col_data_list[0], 'value', '')
                            if len(col_data_list) >= 2:
                                base_data['Account_Type'] = get_value(col_data_list[1], 'value', '')
                        
                        elif endpoint in ['APAgingDetail', 'ARAgingDetail']:
                            # Aging detail reports have specific structures
                            entity_type = 'Vendor' if endpoint == 'APAgingDetail' else 'Customer'
                            if len(col_data_list) >= 1:
                                base_data[f'{entity_type}_Name'] = get_value(col_data_list[0], 'value', '')
                            if len(col_data_list) >= 2:
                                base_data['Aging_Period'] = get_value(col_data_list[1], 'value', '')
                            if len(col_data_list) >= 3:
                                base_data['Amount'] = get_value(col_data_list[2], 'value', 0.0)
                        
                        elif endpoint in ['APAgingSummary', 'ARAgingSummary']:
                            # Aging summary reports have Current, Period1-4, and Total columns
                            entity_type = 'Vendor' if endpoint == 'APAgingSummary' else 'Customer'
                            if len(col_data_list) >= 1:
                                base_data[f'{entity_type}_Name'] = get_value(col_data_list[0], 'value', '')
                                base_data[f'{entity_type}_Id'] = get_value(col_data_list[0], 'id', '')
                            if len(col_data_list) >= 2:
                                base_data['Current_Amount'] = get_value(col_data_list[1], 'value', 0.0)
                            if len(col_data_list) >= 3:
                                base_data['Period1_Amount'] = get_value(col_data_list[2], 'value', 0.0)
                            if len(col_data_list) >= 4:
                                base_data['Period2_Amount'] = get_value(col_data_list[3], 'value', 0.0)
                            if len(col_data_list) >= 5:
                                base_data['Period3_Amount'] = get_value(col_data_list[4], 'value', 0.0)
                            if len(col_data_list) >= 6:
                                base_data['Period4_Amount'] = get_value(col_data_list[5], 'value', 0.0)
                            if len(col_data_list) >= 7:
                                base_data['Total_Amount'] = get_value(col_data_list[6], 'value', 0.0)
                        
                        elif endpoint in ['VendorBalanceDetail', 'CustomerBalanceDetail']:
                            # Balance detail reports have specific column structures
                            standard_cols = ['Date', 'Transaction_Type', 'Num', 'Due_Date', 'Amount', 'Open_Balance', 'Balance']
                            for i, col_name in enumerate(standard_cols):
                                if i < len(col_data_list):
                                    base_data[f'Col_{col_name}'] = get_value(col_data_list[i], 'value', '')
                                    base_data[f'Col_{col_name}_id'] = get_value(col_data_list[i], 'id', '')
                        
                        elif endpoint == 'InventoryValuationSummary':
                            # Inventory valuation summary has specific columns
                            inv_cols = ['Item', 'Type', 'Qty_On_Hand', 'Avg_Cost', 'Asset_Value']
                            for i, col_name in enumerate(inv_cols):
                                if i < len(col_data_list):
                                    base_data[f'Col_{col_name}'] = get_value(col_data_list[i], 'value', '')
                                    base_data[f'Col_{col_name}_id'] = get_value(col_data_list[i], 'id', '')
                        
                        elif endpoint == 'GeneralLedger':
                            # General Ledger has specific columns
                            gl_cols = ['Date', 'Transaction_Type', 'No', 'Name', 'Memo', 'Split', 'Amount', 'Balance']
                            for i, col_name in enumerate(gl_cols):
                                if i < len(col_data_list):
                                    base_data[f'Col_{col_name}'] = get_value(col_data_list[i], 'value', '')
                                    base_data[f'Col_{col_name}_id'] = get_value(col_data_list[i], 'id', '')
                        
                        elif endpoint == 'TrialBalance':
                            # Trial Balance has specific columns
                            tb_cols = ['Account_Name', 'Debit', 'Credit', 'YTD_Debit', 'YTD_Credit']
                            for i, col_name in enumerate(tb_cols):
                                if i < len(col_data_list):
                                    base_data[f'Col_{col_name}'] = get_value(col_data_list[i], 'value', '')
                                    base_data[f'Col_{col_name}_id'] = get_value(col_data_list[i], 'id', '')
                        
                        elif endpoint in ['BalanceSheet', 'CashFlow']:
                            # BalanceSheet and CashFlow have fixed columns: Account_Name and Total
                            if len(col_data_list) >= 1:
                                base_data['Col_Account_Name'] = get_value(col_data_list[0], 'value', '')
                                base_data['Col_Account_Name_id'] = get_value(col_data_list[0], 'id', '')
                            if len(col_data_list) >= 2:
                                base_data['Col_Total'] = get_value(col_data_list[1], 'value', '')
                                base_data['Col_Total_id'] = get_value(col_data_list[1], 'id', '')
                        
                        else:
                            # Generic handling for other reports (ProfitAndLoss, etc.)
                            for col_index, col in enumerate(col_data_list):
                                if col_index < len(column_headers):
                                    col_name = column_headers[col_index]['ColTitle'].replace(' ', '_').replace('(', '').replace(')', '')
                                    base_data[f'Col_{col_name}'] = get_value(col, 'value', '')
                                    base_data[f'Col_{col_name}_id'] = get_value(col, 'id', '')
                        
                        # Add options to data
                        for opt_index, opt in enumerate(options):
                            if opt_index == 0:  # Only add first option set to avoid duplicate columns
                                base_data['Option_Name'] = opt.get('Name', '')
                                base_data['Option_Value'] = opt.get('Value', '')
                        
                        combined_data.append(base_data)
            
            # Process data
            if combined_data:
                Combined_Data = pd.DataFrame(combined_data)
                ConvertedData = ConvertDataTypes(Combined_Data, endpoint)
                
                WriteMode = "overwrite"
                LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                StageCount = len(ConvertedData)
                
                ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                ProdCount = GetProdCount(ProdTable)
                LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
        
        else:
            # Generic handler for other endpoints
            LoadType = 'Full'
            params = {'query': f'SELECT * FROM {endpoint}'}
            
            with QBORequestsManager(endpoint, params) as All_Data:
                if not All_Data.empty:
                    # Convert DataFrame directly with minimal processing
                    All_Data['ClientID'] = EtaniClientID
                    All_Data['OrganisationID'] = LegacyOrganisationID
                    
                    ConvertedData = ConvertDataTypes(All_Data, endpoint)
                    
                    WriteMode = "overwrite"
                    LoadToEvaStageTable(ConvertedData, endpoint, WriteMode, StageTable, error_list)
                    StageCount = len(ConvertedData)
                    
                    ExecuteEvaSP(f"CALL {SPName}('{ClientIdNumber}', {EtaniOrganisationID})", endpoint, error_list, True)
                    ProdCount = GetProdCount(ProdTable)
                    LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Completed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount)
                    
    except Exception as e:
        ErrorDetails = f"{endpoint} - An error occurred while processing: {str(e)}"
        print(ErrorDetails)
        LogLastRefreshDate(ProdTable, StageTable, LoadType, 'Failed', endpoint, 'EVA', StartUTCDate, StageCount, ProdCount, ErrorDetails)
        error_list.append(ErrorDetails)

def GetCMSDetails(client_id, organisation_id):
    """Get client details from CMS database"""
    endpoint = 'ETANI'
    client = client_id[client_id.find('CLIENT') + len('CLIENT'):]
    query = f'''
        SELECT 
            cs1.`Status`,
            JSON_UNQUOTE(JSON_EXTRACT(cs3.Details, '$.id')) AS PBIWorkspaceId,
            COUNT(cs2.id) AS OtherXeroRefreshes,
            CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(c.Details, '$.Legacy.id')),'{client}') AS CHAR(10)) AS LegacyClientID,
            CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs1.Details, '$.Legacy.id')), '{organisation_id}') AS CHAR(10)) AS LegacyOrganisationID,
            c.accountingFirm as FirmID,
            CAST(IFNULL(JSON_UNQUOTE(JSON_EXTRACT(cs1.Details, '$.realmId')), '') AS CHAR(100)) AS realmId
        FROM client_service cs1
        INNER JOIN client c 
            ON cs1.`Client` = c.id
        INNER JOIN client_service cs3 
            ON cs1.`Client` = cs3.`Client`
            AND cs3.`Service` = 3
            AND cs3.`Status` NOT IN (0, 2, 13) 
        LEFT JOIN client_service cs2 
            ON cs1.`Client` = cs2.`Client`
            AND cs1.`Service` = cs2.`Service`
            AND cs1.id <> cs2.id 
            AND cs2.`Status` = 12
        WHERE cs1.`Service` = 4
            AND cs1.id = '{organisation_id}'
            AND cs1.`Client` = '{client}'
        GROUP BY cs1.`Status`, cs3.Details
    '''
    
    df = ReadMySQLTable(query, endpoint, EtaniClientID, EtaniOrganisationID, error_list, IsCMS=True)
    return df

# Main execution
if __name__ == "__main__":
    # Custom status codes
    CustomStatuses = {
        1 : 'Active',
        2 : 'Inactive',
        9 : 'Provisioning New Data',
        12 : 'Updating Data',
        13 : 'Disconnected',
        16: 'Resetting Data'
    }
    
    start_time = time.time()
    print(f"Start API Data Refresh [{datetime.fromtimestamp(start_time)}]")
    
    # Initialize
    FirmId = get_firm_id(error_list, ClientIdNumber)
    params = {
        "p_integration": "QBO",
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
        # Get CMS details
        df = GetCMSDetails(EtaniClientID, EtaniOrganisationID)
        OrgStatus = df.loc[0, 'Status']
        LegacyClientID = EtaniClientID.replace(ClientIdNumber, df.loc[0, 'LegacyClientID'])
        LegacyOrganisationID = df.loc[0, 'LegacyOrganisationID']
        FirmID = df.loc[0, 'FirmID']
        RealmID = df.loc[0, 'realmId']
        TokenFileName = f'{LegacyClientID}_{LegacyOrganisationID}.txt'
        lock = FileLock(f"{TokenFileName}.lock")
        
        print(f"QBO Org Status: {CustomStatuses.get(OrgStatus, str(OrgStatus))}")
        
        if ((OrgStatus == 9) or (OrgStatus == 16 and Reset_Mode)) and DB_Destination != 'SQL':
            # Define the order of endpoints to process
            endpoints = [
                # Testing only these 3 endpoints
                'Customer',
                'PurchaseOrder', 
                'Attachable',
                
                # Hidden endpoints - uncomment to re-enable
                # # Core master data
                # 'CompanyInfo',
                # 'Account',
                # 'Vendor',
                # 'Employee',
                # 'Item',
                # 'Class',
                # 'Department',
                # 'TaxCode',
                # 'TaxRate',
                # 'Term',
                # 'PaymentMethod',
                
                # # Transactions
                # 'Invoice',
                # 'Payment',
                # 'SalesReceipt',
                # 'Estimate',
                # 'CreditMemo',
                # 'RefundReceipt',
                # 'Bill',
                # 'BillPayment',
                # 'VendorCredit',
                # 'Purchase',
                # 'Deposit',
                # 'Transfer',
                # 'JournalEntry',
                
                # # Other entities
                # 'TimeActivity',
                # 'Budget',
                # 'CompanyCurrency',
                # 'Preferences',
                
                # # Reports
                # 'BalanceSheet',
                # 'ProfitAndLoss',
                # 'CashFlow',
                # 'TrialBalance',
                # 'GeneralLedger',
                # 'VendorBalanceDetail',
                # 'CustomerBalanceDetail',
                # 'InventoryValuationSummary'
            ]
            
            # Process each endpoint
            for endpoint in endpoints:
                try:
                    print(f"\nProcessing {endpoint}...")
                    ExtractAPIResponse(endpoint)
                except Exception as e:
                    print(f"Error processing {endpoint}: {str(e)}")
                    error_list.append(f"Failed to process {endpoint}: {str(e)}")
                    continue
                    
        else:
            params = {
                "p_integration": "QBO",
                "p_organisation_id": EtaniOrganisationID,
                "p_client_id": ClientIdNumber,
                "p_firm_id": FirmId,
                "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_status": "Failed",
                "p_log_id": log_id,
                "p_remarks": f"QBO Org Status is not Loading Data Status:{OrgStatus}, ResetMode: {Reset_Mode}, endpoint: API Data"
            }
            update_container_logs(params)
            
    except Exception as e:
        print(f"Fatal error: {str(e)}")
        error_list.append(f"Fatal error: {str(e)}")
        
    finally:
        # Log completion
        end_time = time.time()
        print(f"Completed API Data Refresh (elapsed time: {(end_time - start_time)/60:.2f} minutes)")
        
        if error_list:
            errors = "\n".join(error_list)
            params = {
                "p_integration": "QBO",
                "p_organisation_id": EtaniOrganisationID,
                "p_client_id": ClientIdNumber,
                "p_firm_id": FirmId,
                "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_status": "Completed with Errors",
                "p_log_id": log_id,
                "p_remarks": f"Completed API Data Refresh (elapsed time: {(end_time - start_time)/60:.2f} minutes)\n{errors}"
            }
        else:
            params = {
                "p_integration": "QBO",
                "p_organisation_id": EtaniOrganisationID,
                "p_client_id": ClientIdNumber,
                "p_firm_id": FirmId,
                "p_start_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_end_date": datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                "p_status": "Completed",
                "p_log_id": log_id,
                "p_remarks": f"Completed API Data Refresh (elapsed time: {(end_time - start_time)/60:.2f} minutes)"
            }
        update_container_logs(params)
        
        # Cleanup executor
        executor.shutdown(wait=True)