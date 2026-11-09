from azure.storage.fileshare import ShareFileClient
import json
import requests
import base64
import pandas as pd
import pyodbc
import re
import urllib.parse
import config
import time

# in Powershel terminal run ".venv/Scripts/Activate.ps1"
# run "pip install -r requirements.txt" to download the imported libraries

# MYOB API Details
client_id = config.MYOB_BUSINESS_CLIENT_ID
client_secret = config.MYOB_BUSINESS_CLIENT_SECRET

# Database Connection Details
server = config.SQL_SERVER_NAME
database = config.SQL_SERVER_DATABASE
username = config.SQL_SERVER_USERNAME
password = config.SQL_SERVER_PASSWORD 

#  Azure File Share Details
StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName= config.FILE_SHARE_NAME

# Org Integration Details
EtaniClientID = 'BIGOLESHOECOMPANY_CLIENT1661'
EtaniOrganisationID = '6679'
MYOBCFToken = ''
MYOBUrl = 'https://arl2.api.myob.com/accountright/75fa8a5e-dd0e-4de1-aee0-bbd69d9f4eb8'

TablePrefix = EtaniClientID + '_' + EtaniOrganisationID + '_MYOBAR_'
TokenFileName = f'{EtaniClientID}_{EtaniOrganisationID}.txt'
#TokenFilePath = config.TOKEN_FILE_PATH

#ResponseFilePath = r'C:\Users\jefrey\Desktop\ETL_PYTHON APP\api_response'

class MYOBARAPI:
    def __init__(self):
        self.api_calls = 0
        self.last_reset = time.time()

    def myobar_requests(self, endpoint, params=None):
        current_time = time.time()
        if current_time - self.last_reset >= 60:
            self.api_calls = 0
            self.last_reset = current_time

        if self.api_calls >= 60:
            time.sleep(60 - (current_time - self.last_reset))
            self.api_calls = 0
            self.last_reset = time.time()

        self.api_calls += 1

        # Make the API call
        OldToken = GetTokenFromFile(TokenFileName)
        NewToken = GetNewToken(OldToken[1])
        MYOB_CFToken = MYOBCFToken

        get_url = MYOBUrl +'/'+ endpoint
        if params:
            get_url += '?' + urllib.parse.urlencode(params)

        print('Get API Response from :', get_url)

        response = requests.get(get_url,
                               headers={
                                   'Authorization': 'REDACTED' + NewToken[0],
                                   'x-myobapi-key': client_id,
                                   'x-myobapi-version': 'v2',
                                   'x-myobapi-cftoken': MYOB_CFToken,
                               })
        json_response = response.json()
        #print(json_response)
        MYOBARData = pd.DataFrame(json_response['Items'])
        MYOBARData = MYOBARData.assign( NextPageLink = str(json_response.get('NextPageLink', '') if json_response else ''),Count = int(json_response.get('Count', 0) if json_response and json_response.get('Count') is not None else 0)
)
        print("Saved MYOB API Response: " + endpoint, len(MYOBARData))

        return MYOBARData

myobar_api = MYOBARAPI()

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

    # Parse the file contents as JSON
    json_response = json.loads(file_contents)

    return [json_response['access_token'], json_response['refresh_token'], json_response['refresh_token']]

def GetNewToken(refresh_token):
    
    print("Request New Access Token using Refresh Token")

    token_refresh_url = 'https://secure.myob.com/oauth2/v1/authorize'
    response = requests.post(token_refresh_url,
                            data = {
                                'client_id' : client_id,
                                'client_secret' : client_secret,
                                'grant_type' : 'refresh_token',
                                'refresh_token' : refresh_token
                            })
    json_response = response.json()
    #print(json_response)

    # Azure File Share connection settings
    storage_account_name = StorageAccountName
    storate_account_key = StorageAccessKey
    file_share_name = FileShareName
    
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

def MYOBARRequests(endpoint, params=None):
    return myobar_api.myobar_requests(endpoint, params)

def ConvertDataTypes(df):
    
    print("Converting Data Types to Match Stage Table")

    for col in df.columns:
        #print(df[col])
        if df[col].dtype == bool:
            df[col] = df[col].astype(int)
        elif df[col].dtype == int:
            df[col] = df[col].astype(int)
        elif df[col].dtype == float:  # Handle float values
            df[col] = df[col].astype(float)
        elif df[col].str.contains('/Date\(', na=False).any():  # Check for JSON date string format
            df[col] = df[col].apply(lambda x: pd.to_datetime(int(re.search(r'\((\d+)\+', x).group(1)) / 1000, unit='s', errors='coerce'))  # Convert epoch to datetime
        elif df[col].dtype == object:
            # Check if column contains ISO 8601 date strings
            if df[col].str.match(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?$', na=False).any():
                # Remove milliseconds (decimal part) before conversion
                df[col] = df[col].str.replace(r'\.\d{1,3}$', '', regex=True)  # Remove decimal and milliseconds
                df[col] = pd.to_datetime(df[col], errors='coerce')  # 'coerce' will convert invalid dates to NaT
                df[col] = df[col].replace({pd.NaT: None})  # Replace NaT with None for SQL NULL
            # Check if column contains JSON array
            elif df[col].apply(lambda x: isinstance(x, list)).any():
                # Convert JSON array to string
                df[col] = df[col].apply(lambda x: str(x))
            else:
                # Convert object columns to strings, replacing NaN values with None
                df[col] = df[col].astype(str).where(pd.notnull(df[col]), None)
    
    df = df.assign(ClientID = EtaniClientID, OrganisationID = int(EtaniOrganisationID)) # Insert ClientID and OrganisationID
    
    print("Done Converting Data")

    return df

def LoadToStageTable(df, endpoint):
    endpointName = endpoint.split('/')[1] if "/" in endpoint else  endpoint

    TableName = TablePrefix + endpointName + 'STAGE'

    print("Load data to Stage TABLE: " + TableName)

    connection_string = 'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={};DATABASE={};UID={};PWD={};Unicode=True;LongAsMax=yes'.format(server, database, username, password)
    cnxn = pyodbc.connect(connection_string)
    cnxn.autocommit = True
    cursor = cnxn.cursor()
    cursor.fast_executemany = True

    # Truncate Stage table:
    cursor.execute('TRUNCATE TABLE ' + TableName)

    # Create a SQL query to insert data into the table
    columns = ', '.join('['+df.columns+']')
    query = f"INSERT INTO {TableName} ({columns}) VALUES ({', '.join(['?' for _ in range(len(df.columns))])})"

    # Prepare the data for insertion
    data = [tuple(row) for row in df.values]

    # Insert data in batches of 100 rows
    batch_size = 1000
    for i in range(0, len(data), batch_size):
        batch = data[i:i+batch_size]
        #print(query)
        cursor.executemany(query, batch)
        print('Inserted Rows : ', i+len(batch), '/', len(data))

    cursor.close()
    cnxn.close()

    print("Successfully loaded data to Stage TABLE: " + TableName)

def ExecuteSP(procedure_name):
    # Establish a connection to the database
    connection_string = 'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={};DATABASE={};UID={};PWD={};Unicode=True;LongAsMax=yes'.format(server, database, username, password)
    cnxn = pyodbc.connect(connection_string)
    cnxn.autocommit = True
    cursor = cnxn.cursor()
    cursor.fast_executemany = True

    # Execute the stored procedure
    cursor.execute(f"EXEC {procedure_name}")
    
    print(f"Stored procedure '{procedure_name}' executed successfully.")

    # Close the cursor and connection
    cursor.close()
    cnxn.close()

def ExtractAPIResponse(endpoint):
        
    if endpoint == 'Contact':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, contacts in All_Data.iterrows():
                contacts_data = {
                    'P_NextPageLink': contacts.get('NextPageLink', ''),
                    'P_Count': int(contacts.get('Count', '')),
                    'P_Items_UID': str(contacts.get('UID', '')),
                    'P_Items_CompanyName': str(contacts.get('CompanyName', '')),
                    'P_Items_IsIndividual': contacts.get('IsIndividual', ''),
                    'P_Items_DisplayID': str(contacts.get('DisplayID', '')),
                    'P_Items_IsActive': contacts.get('IsActive', ''),
                    'P_Items_Notes': contacts.get('Notes', ''),
                    'P_Items_Identifiers': contacts.get('Identifiers', ''),
                    'P_Items_CustomList1': contacts.get('Custom List 1', ''),
                    'P_Items_CustomList2': contacts.get('Custom List 2', ''),
                    'P_Items_CustomList3': contacts.get('Custom List 3', ''),
                    'P_Items_CustomField1': contacts.get('Custom Field 1', ''),
                    'P_Items_CustomField2': contacts.get('Custom Field 2', ''),
                    'P_Items_CustomField3': contacts.get('Custom Field 3', ''),
                    'P_Items_CurrentBalance': float(contacts.get('CurrentBalance', '0')),
                    'P_Items_Type': str(contacts.get('Type', '')),
                    'P_Items_LastModified': contacts.get('LastModified', ''),
                    'P_Items_PhotoURI': contacts.get('PhotoURI', ''),
                    'P_Items_URI': contacts.get('URI', ''),
                    'P_Items_RowVersion': str(contacts.get('RowVersion', ''))
                }
                Addresses = contacts['Addresses']
                for i, address in enumerate(Addresses):
                    contacts_data[f'Location'] = int(address.get('Location', '0'))
                    contacts_data[f'Street'] = str(address.get('Street', ''))
                    contacts_data[f'City'] = str(address.get('City', ''))
                    contacts_data[f'State'] = str(address.get('State', ''))
                    contacts_data[f'PostCode'] = str(address.get('PostCode', ''))
                    contacts_data[f'Country'] = str(address.get('Country', ''))
                    contacts_data[f'Phone1'] = str(address.get('Phone1', ''))
                    contacts_data[f'Phone2'] = str(address.get('Phone2', ''))
                    contacts_data[f'Phone3'] = str(address.get('Phone3', ''))
                    contacts_data[f'Fax'] = str(address.get('Fax', ''))
                    contacts_data[f'Email'] = str(address.get('Email', ''))
                    contacts_data[f'Website'] = str(address.get('Website', ''))
                    contacts_data[f'ContactName'] = str(address.get('ContactName', ''))
                    contacts_data[f'Salutation'] = str(address.get('Salutation', ''))

           
                combined_data.append(contacts_data)
 
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'Contacts'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Sale/Invoice':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, saleinvoice in All_Data.iterrows():
                saleinvoice_data = {
                    'UID': str(saleinvoice.get('UID', '') or ''),
                    'Number': str(saleinvoice.get('Number', '') or ''),
                    'Date': saleinvoice.get('Date', ''),
                    'CustomerPurchaseOrderNumber': str(saleinvoice.get('CustomerPurchaseOrderNumber', '') or ''),
                    'PromisedDate': saleinvoice.get('PromisedDate', ''),
                    'BalanceDueAmount': float(saleinvoice.get('BalanceDueAmount', '0') or '0'),
                    'BalanceDueAmountForeign': float(saleinvoice.get('BalanceDueAmountForeign', '0') or '0'),
                    'Status': str(saleinvoice.get('Status', '') or ''),
                    'ShipToAddress': str(saleinvoice.get('ShipToAddress', '') or ''),
                    'IsTaxInclusive': saleinvoice.get('IsTaxInclusive', ''),
                    'Subtotal': float(saleinvoice.get('Subtotal', '0') or '0'),
                    'SubtotalForeign': float(saleinvoice.get('SubtotalForeign', '0') or '0'),
                    'Freight': float(saleinvoice.get('Freight', '0') or '0'),
                    'FreightForeign': float(saleinvoice.get('FreightForeign', '0') or '0'),
                    'TotalTax': float(saleinvoice.get('TotalTax', '0') or '0'),
                    'TotalTaxForeign': float(saleinvoice.get('TotalTaxForeign', '0') or '0'),
                    'TotalAmount': float(saleinvoice.get('TotalAmount', '0') or '0'),
                    'TotalAmountForeign': float(saleinvoice.get('TotalAmountForeign', '0') or '0'),
                    'Comment': saleinvoice.get('Comment', ''),
                    'ShippingMethod': str(saleinvoice.get('ShippingMethod', '') or ''),
                    'JournalMemo': str(saleinvoice.get('JournalMemo', '') or ''),
                    'ReferralSource': str(saleinvoice.get('ReferralSource', '') or ''),
                    'InvoiceDeliveryStatus': str(saleinvoice.get('InvoiceDeliveryStatus', '') or ''),
                    'LastPaymentDate': saleinvoice.get('LastPaymentDate', ''),
                    'InvoiceType': str(saleinvoice.get('InvoiceType', '') or ''),
                    'OnlinePaymentMethod': str(saleinvoice.get('OnlinePaymentMethod', '') or ''),
                    'CurrencyExchangeRate': float(saleinvoice.get('CurrencyExchangeRate', '0') or '0'),
                    'URI': str(saleinvoice.get('URI', '') or ''),
                    'RowVersion': str(saleinvoice.get('RowVersion', '') or ''), 
                    'LastModified': saleinvoice.get('LastModified', ''),
                } 
                Customer = saleinvoice['Customer']
                if  Customer is not None:
                    saleinvoice_data[f'Customer.UID'] = str(Customer.get('UID', '') or '')
                    saleinvoice_data[f'Customer.Name'] = str(Customer.get('Name', '') or '')
                    saleinvoice_data[f'Customer.DisplayID'] = str(Customer.get('DisplayID', '') or '')
                    saleinvoice_data[f'Customer.URI'] = str(Customer.get('URI', '') or '')

                Terms = saleinvoice['Terms']
                if  Terms is not None:
                    saleinvoice_data[f'Terms.PaymentIsDue'] = str(Terms.get('PaymentIsDue', '') or '')
                    saleinvoice_data[f'Terms.DiscountDate'] = int(Terms.get('DiscountDate', 0))
                    saleinvoice_data[f'Terms.BalanceDueDate'] = int(Terms.get('BalanceDueDate', 0))
                    saleinvoice_data[f'Terms.DiscountForEarlyPayment'] = float(Terms.get('DiscountForEarlyPayment', '0') or '0')
                    saleinvoice_data[f'Terms.MonthlyChargeForLatePayment'] = float(Terms.get('MonthlyChargeForLatePayment', '0') or '0')
                    saleinvoice_data[f'Terms.DiscountExpiryDate'] = Terms.get('DiscountExpiryDate', '')
                    saleinvoice_data[f'Terms.Discount'] = float(Terms.get('Discount', '0') or '0')
                    saleinvoice_data[f'Terms.DueDate'] = Terms.get('DueDate', '')
                    saleinvoice_data[f'Terms.FinanceCharge'] = float(Terms.get('FinanceCharge', '0') or '0')

                FreightTaxCode = saleinvoice['FreightTaxCode']
                if  FreightTaxCode is not None:
                    saleinvoice_data[f'FreightTaxCode.UID'] = str(FreightTaxCode.get('UID', '') or '')
                    saleinvoice_data[f'FreightTaxCode.Code'] = str(FreightTaxCode.get('Code', '') or '')
                    saleinvoice_data[f'FreightTaxCode.URI'] = str(FreightTaxCode.get('URI', '') or '')
                
                Category = saleinvoice['Category']
                if  Category is not None:
                    saleinvoice_data[f'Category.UID'] = str(Category.get('UID', '') or '')
                    saleinvoice_data[f'Category.Name'] = str(Category.get('Name', '') or '')
                    saleinvoice_data[f'Category.DisplayID'] = str(Category.get('DisplayID', '') or '')
                    saleinvoice_data[f'Category.URI'] = str(Category.get('URI', '') or '')
                
                Salesperson = saleinvoice['Salesperson']
                if  Salesperson is not None:
                    saleinvoice_data[f'Salesperson.UID'] = str(Salesperson.get('UID', '') or '')
                    saleinvoice_data[f'Salesperson.Name'] = str(Salesperson.get('Name', '') or '')
                    saleinvoice_data[f'Salesperson.DisplayID'] = str(Salesperson.get('DisplayID', '') or '')
                    saleinvoice_data[f'Salesperson.URI'] = str(Salesperson.get('URI', '') or '')

                Order = saleinvoice['Order']
                if  Order is not None:
                    saleinvoice_data[f'Order.UID'] = str(Order.get('UID', '') or '')
                    saleinvoice_data[f'Order.Number'] = str(Order.get('Number', '') or '')
                    saleinvoice_data[f'Order.URI'] = str(Order.get('URI', '') or '')

                ForeignCurrency = saleinvoice['ForeignCurrency']
                if  ForeignCurrency is not None:
                    saleinvoice_data[f'ForeignCurrency.UID'] = str(ForeignCurrency.get('UID', '') or '')
                    saleinvoice_data[f'ForeignCurrency.Code'] = str(ForeignCurrency.get('Code', '') or '')
                    saleinvoice_data[f'ForeignCurrency.CurrencyName'] = str(ForeignCurrency.get('CurrencyName', '') or '')
                    saleinvoice_data[f'ForeignCurrency.URI'] = str(ForeignCurrency.get('URI', '') or '')

                combined_data.append(saleinvoice_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'SaleInvoices'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            ##SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            ##ExecuteSP(SPName)

    elif endpoint == 'Sale/CustomerPayment':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, customerpayments in All_Data.iterrows():
                for line in customerpayments.get('Invoices', []):  
                    customerpayments_data = {
                    'P_Items_UID': str(customerpayments.get('UID', '') or ''),
                    'P_Items_URI': str(customerpayments.get('URI', '') or ''),
                    'P_Items_RowVersion': str(customerpayments.get('RowVersion', '') or ''),
                    'P_NextPageLink': str(customerpayments.get('NextPageLink', '') or ''),
                    'P_Count': str(customerpayments.get('Count', '') or ''),
                    'P_Items_DepositTo': str(customerpayments.get('DepositTo', '') or ''),
                    'P_Items_ReceiptNumber': str(customerpayments.get('ReceiptNumber', '') or ''),
                    'P_Items_Date': customerpayments.get('Date', ''),
                    'P_Items_AmountReceived': float(customerpayments.get('AmountReceived', '0') or '0'),
                    'P_Items_AmountReceivedForeign': float(customerpayments.get('AmountReceivedForeign', '0') or '0'),
                    'P_Items_PaymentMethod': str(customerpayments.get('PaymentMethod', '') or ''),
                    'P_Items_Memo': str(customerpayments.get('Memo', '') or ''),
                    'P_Items_TransactionUID': str(customerpayments.get('TransactionUID', '') or ''),
                    'P_Items_CurrencyExchangeRate': float(customerpayments.get('CurrencyExchangeRate', '0') or '0'),
                    'RowID': str(line.get('RowID', '') or ''),
                    'Number': str(line.get('Number', '') or ''),
                    'UID': str(line.get('UID', '') or ''),
                    'AmountApplied': float(line.get('AmountApplied', '0') or '0'),
                    'AmountAppliedForeign': float(line.get('AmountAppliedForeign', '0') or '0'),
                    'Type': str(line.get('Type', '') or ''),
                    'Uri': str(line.get('Uri', '') or '')           
                    }
                    Account = customerpayments['Account']
                    if  Account is not None:
                        customerpayments_data[f'P_Items_Account_UID'] = str(Account.get('UID', '') or '')
                        customerpayments_data[f'P_Items_Account_Name'] = str(Account.get('Name', '') or '')
                        customerpayments_data[f'P_Items_Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                        customerpayments_data[f'P_Items_Account_URI'] = str(Account.get('URI', '') or '')
                    Customer = customerpayments['Customer']
                    if  Customer is not None:
                        customerpayments_data[f'P_Items_Customer_UID'] = str(Customer.get('UID', '') or '')
                        customerpayments_data[f'P_Items_Customer_Name'] = str(Customer.get('Name', '') or '')
                        customerpayments_data[f'P_Items_Customer_DisplayID'] = str(Customer.get('DisplayID', '') or '')
                        customerpayments_data[f'P_Items_Customer_URI'] = str(Customer.get('URI', '') or '')
                    ForeignCurrency = customerpayments['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        customerpayments_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                        customerpayments_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                        customerpayments_data[f'P_Items_ForeignCurrency_Name'] = str(ForeignCurrency.get('Name', '') or '')
                        customerpayments_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(customerpayments_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'SaleCustomerPayment'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Sale/CreditRefund':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, creditrefund in All_Data.iterrows():
                    creditrefund_data = {
                    'NextPageLink': str(creditrefund.get('NextPageLink', '') or ''),
                    'Count': str(creditrefund.get('Count', '') or ''),
                    'Number': str(creditrefund.get('Number', '') or ''),
                    'UID': str(creditrefund.get('UID', '') or ''),
                    'Payee': str(creditrefund.get('Payee', '') or ''),
                    'Date': creditrefund.get('Date', ''),
                    'Amount': float(creditrefund.get('Amount', '0') or '0'),
                    'Memo': str(creditrefund.get('Memo', '') or ''),
                    'ChequePrinted': creditrefund.get('ChequePrinted', ''),
                    'DeliveryStatus': str(creditrefund.get('DeliveryStatus', '') or ''),
                    'URI': str(creditrefund.get('URI', '') or ''),
                    'RowVersion': str(creditrefund.get('RowVersion', '') or '')       
                    }
                    Account = creditrefund['Account']
                    if  Account is not None:
                        creditrefund_data[f'Account_UID'] = str(Account.get('UID', '') or '')
                        creditrefund_data[f'Account_Name'] = str(Account.get('Name', '') or '')
                        creditrefund_data[f'Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                        creditrefund_data[f'Account_URI'] = str(Account.get('URI', '') or '')
                    Invoice = creditrefund['Invoice']
                    if  Invoice is not None:
                        creditrefund_data[f'Customer_UID'] = str(Invoice.get('UID', '') or '')
                        creditrefund_data[f'Customer_Number'] = str(Invoice.get('Number', '') or '')
                        creditrefund_data[f'Customer_URI'] = str(Invoice.get('URI', '') or '')    
                    Customer = creditrefund['Customer']
                    if  Customer is not None:
                        creditrefund_data[f'Customer_UID'] = str(Customer.get('UID', '') or '')
                        creditrefund_data[f'Customer_Name'] = str(Customer.get('Name', '') or '')
                        creditrefund_data[f'Customer_DisplayID'] = str(Customer.get('DisplayID', '') or '')
                        creditrefund_data[f'Customer_URI'] = str(Customer.get('URI', '') or '')
                    ForeignCurrency = creditrefund['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        creditrefund_data[f'ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                        creditrefund_data[f'ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                        creditrefund_data[f'ForeignCurrency_Name'] = str(ForeignCurrency.get('Name', '') or '')
                        creditrefund_data[f'ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(creditrefund_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'SaleCreditRefund'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Sale/CreditSettlement':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            combined_data = []
            for index, creditsettlement in All_Data.iterrows():
                for line in creditsettlement.get('Lines', []):
                    creditsettlement_data = {
                    'P_Items_UID': str(creditsettlement.get('UID', '') or ''),
                    'P_Items_Number': str(creditsettlement.get('Number', '') or ''),
                    'P_Items_Date': creditsettlement.get('Date', ''),
                    'P_Items_CreditAmount': float(creditsettlement.get('CreditAmount', '0') or '0'),
                    'P_Items_Memo': str(creditsettlement.get('Memo', '') or ''),
                    'P_Items_URI': str(creditsettlement.get('URI', '') or ''),
                    'P_Items_RowVersion': str(creditsettlement.get('RowVersion', '') or ''),
                    'P_NextPageLink': str(creditsettlement.get('NextPageLink', '') or ''),
                    'P_Count': str(creditsettlement.get('Count', '') or ''),
                    'Type': str(line.get('Type', '') or ''),
                    'Sale.UID': str(line.get('Sale', {}).get('UID', '') or ''),
                    'Sale.Number': str(line.get('Sale', {}).get('Number', '') or ''),
                    'Sale.URI': str(line.get('Sale', {}).get('URI', '') or ''),
                    'AmountApplied': float(line.get('AmountApplied', '0') or '0')         
                    }                         
                    CreditFromInvoice = creditsettlement['CreditFromInvoice']
                    if  CreditFromInvoice is not None:
                        creditsettlement_data[f'P_Items_CreditFromInvoice_UID'] = str(CreditFromInvoice.get('UID', '') or '')
                        creditsettlement_data[f'P_Items_CreditFromInvoice_Number'] = str(CreditFromInvoice.get('Number', '') or '')
                        creditsettlement_data[f'P_Items_CreditFromInvoice_URI'] = str(CreditFromInvoice.get('URI', '') or '')   
                    Customer = creditsettlement['Customer']
                    if  Customer is not None:
                        creditsettlement_data[f'P_Items_Customer_UID'] = str(Customer.get('UID', '') or '')
                        creditsettlement_data[f'P_Items_Customer_Name'] = str(Customer.get('Name', '') or '')
                        creditsettlement_data[f'P_Items_Customer_DisplayID'] = str(Customer.get('DisplayID', '') or '')
                        creditsettlement_data[f'P_Items_Customer_URI'] = str(Customer.get('URI', '') or '')
                    ForeignCurrency = creditsettlement['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        creditsettlement_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                        creditsettlement_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                        creditsettlement_data[f'P_Items_ForeignCurrency_Name'] = str(ForeignCurrency.get('Name', '') or '')
                        creditsettlement_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(creditsettlement_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'SaleCreditSettlement'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Purchase/Bill':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, purchasebill in All_Data.iterrows():
                purchasebill_data = {
                    'RowVersion': purchasebill.get('RowVersion', ''),
                    'UID': purchasebill.get('UID', ''),
                    'Number': purchasebill.get('Number', ''),
                    'Date': purchasebill.get('Date', ''),
                    'SupplierInvoiceNumber': purchasebill.get('SupplierInvoiceNumber', ''),
                    'ShipToAddress': purchasebill.get('ShipToAddress', ''),
                    'IsTaxInclusive': purchasebill.get('IsTaxInclusive', ''),
                    'IsReportable': purchasebill.get('IsReportable', ''),
                    'Subtotal': purchasebill.get('Subtotal', ''),
                    'SubtotalForeign': purchasebill.get('SubtotalForeign', ''),
                    'Freight': purchasebill.get('Freight', ''),
                    'FreightForeign': purchasebill.get('Freight', ''),
                    'TotalTax': purchasebill.get('TotalTax', ''),
                    'TotalTaxForeign': purchasebill.get('TotalTax', ''),
                    'TotalAmount': purchasebill.get('TotalAmount', ''),
                    'TotalAmountForeign': purchasebill.get('TotalAmount', ''),
                    'Comment': purchasebill.get('Comment', ''),
                    'ShippingMethod': purchasebill.get('ShippingMethod', ''),
                    'PromisedDate': purchasebill.get('PromisedDate', ''),
                    'JournalMemo': purchasebill.get('JournalMemo', ''),
                    'BillDeliveryStatus': purchasebill.get('BillDeliveryStatus', ''),
                    'AppliedToDate': purchasebill.get('AppliedToDate', ''),
                    'AppliedToDateForeign': purchasebill.get('AppliedToDateDate', ''),
                    'BalanceDueAmount': purchasebill.get('BalanceDueAmount', ''),
                    'BalanceDueAmountForeign': purchasebill.get('BalanceDueAmountDate', ''),
                    'Status': purchasebill.get('Status', ''),
                    'LastPaymentDate': purchasebill.get('LastPaymentDate', ''),
                    'BillType': purchasebill.get('BillType', ''),
                    'URI': purchasebill.get('URI', ''),
                    'CurrencyExchangeRate': purchasebill.get('CurrencyExchangeRate', '')       
                }
                Supplier = purchasebill['Supplier']
                if  Supplier is not None:
                    purchasebill_data[f'Supplier.UID'] = str(Supplier.get('UID', '') or '')
                    purchasebill_data[f'Supplier.Name'] = str(Supplier.get('Name', '') or '')
                    purchasebill_data[f'Supplier.DisplayID'] = str(Supplier.get('DisplayID', '') or '')
                    purchasebill_data[f'Supplier.URI'] = str(Supplier.get('URI', '') or '')
                Terms = purchasebill['Terms']
                if  Terms is not None:
                    purchasebill_data[f'Terms.PaymentIsDue'] = str(Terms.get('PaymentIsDue', '') or '')
                    purchasebill_data[f'Terms.DiscountDate'] = int(Terms.get('DiscountDate', 0))
                    purchasebill_data[f'Terms.BalanceDueDate'] = int(Terms.get('BalanceDueDate', 0))
                    purchasebill_data[f'Terms.DiscountForEarlyPayment'] = float(Terms.get('DiscountForEarlyPayment', '0') or '0')
                    purchasebill_data[f'Terms.MonthlyChargeForLatePayment'] = float(Terms.get('MonthlyChargeForLatePayment', '0') or '0')
                    purchasebill_data[f'Terms.DiscountExpiryDate'] = Terms.get('DiscountExpiryDate', '')
                    purchasebill_data[f'Terms.Discount'] = float(Terms.get('Discount', '0') or '0')
                    purchasebill_data[f'Terms.DiscountForeign'] = float(Terms.get('DiscountForeign', '0') or '0')
                    purchasebill_data[f'Terms.DueDate'] = Terms.get('DueDate', '')
                    purchasebill_data[f'Terms.FinanceCharge'] = float(Terms.get('FinanceCharge', '0') or '0')
                FreightTaxCode = purchasebill['FreightTaxCode']
                if  FreightTaxCode is not None:
                    purchasebill_data[f'FreightTaxCode.UID'] = str(FreightTaxCode.get('UID', '') or '')
                    purchasebill_data[f'FreightTaxCode.Code'] = str(FreightTaxCode.get('Code', '') or '')
                    purchasebill_data[f'FreightTaxCode.URI'] = str(FreightTaxCode.get('URI', '') or '')
                Category = purchasebill['Category']
                if  Category is not None:
                    purchasebill_data[f'Category.UID'] = str(Category.get('UID', '') or '')
                    purchasebill_data[f'Category.Name'] = str(Category.get('Name', '') or '')
                    purchasebill_data[f'Category.DisplayID'] = str(Category.get('DisplayID', '') or '')
                    purchasebill_data[f'Category.URI'] = str(Category.get('URI', '') or '')    
                Order = purchasebill['Order']
                if  Order is not None:
                    purchasebill_data[f'Order.UID'] = str(Order.get('UID', '') or '')
                    purchasebill_data[f'Order.Number'] = str(Order.get('Number', '') or '')
                    purchasebill_data[f'Order.URI'] = str(Order.get('URI', '') or '')
                    #'Order': purchasebill.get('Order', ''),
                ForeignCurrency = purchasebill['ForeignCurrency']
                if  ForeignCurrency is not None:
                    purchasebill_data[f'ForeignCurrency.UID'] = str(ForeignCurrency.get('UID', '') or '')
                    purchasebill_data[f'ForeignCurrency.Code'] = str(ForeignCurrency.get('Code', '') or '')
                    purchasebill_data[f'ForeignCurrency.CurrencyName'] = str(ForeignCurrency.get('CurrencyName', '') or '')
                    purchasebill_data[f'ForeignCurrency.URI'] = str(ForeignCurrency.get('URI', '') or '')
                combined_data.append(purchasebill_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'PurchaseBill'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Purchase/SupplierPayment':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, billpayments in All_Data.iterrows():
                for line in billpayments.get('Lines', []):  
                    billpayments_data = {
                    'RowVersion': billpayments.get('RowVersion', ''),
                    'P_Items_UID': billpayments.get('UID', ''),
                    'P_Items_Date': billpayments.get('Date', ''),
                    'P_Items_DeliveryStatus': billpayments.get('DeliveryStatus', ''),
                    'P_Items_URI': billpayments.get('URI', ''),
                    'P_Items_RowVersion': billpayments.get('RowVersion', ''),
                    'P_NextPageLink': billpayments.get('NextPageLink', ''),
                    'P_Count': billpayments.get('Count', ''),
                    'RowID': billpayments.get('RowID', ''),
                    'Type': billpayments.get('Type', ''),
                    'P_Items_PayFrom': billpayments.get('PayFrom', ''),
                    'P_Items_PayeeAddress': billpayments.get('PayeeAddress', ''),
                    'P_Items_StatementParticulars': billpayments.get('StatementParticulars', ''),
                    'P_Items_PaymentNumber': billpayments.get('PaymentNumber', ''),
                    'P_Items_AmountPaid': billpayments.get('AmountPaid', ''),
                    'P_Items_Memo': billpayments.get('Memo', ''),
                    'Purchase.UID': billpayments.get('Purchase.UID', ''),
                    'Purchase.Number': billpayments.get('Purchase.Number', ''),
                    'Purchase.URI': billpayments.get('Purchase.URI', ''),
                    'AmountApplied': billpayments.get('AmountApplied', ''),
                    'Purchase': billpayments.get('Purchase', '')             
                    }
                    Account = billpayments['Account']
                    if  Account is not None:
                        billpayments_data[f'P_Items_Account_UID'] = str(Account.get('UID', '') or '')
                        billpayments_data[f'P_Items_Account_Name'] = str(Account.get('Name', '') or '')
                        billpayments_data[f'P_Items_Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                        billpayments_data[f'P_Items_Account_URI'] = str(Account.get('URI', '') or '')
                    Supplier = billpayments['Supplier']
                    if  Supplier is not None:
                        billpayments_data[f'P_Items_Supplier_UID'] = str(Supplier.get('UID', '') or '')
                        billpayments_data[f'P_Items_Supplier_Name'] = str(Supplier.get('Name', '') or '')
                        billpayments_data[f'P_Items_Supplier_DisplayID'] = str(Supplier.get('DisplayID', '') or '')
                        billpayments_data[f'P_Items_Supplier_URI'] = str(Supplier.get('URI', '') or '')
                    ForeignCurrency = billpayments['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        billpayments_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                        billpayments_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                        billpayments_data[f'P_Items_ForeignCurrency_Name'] = str(ForeignCurrency.get('Name', '') or '')
                        billpayments_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(billpayments_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'PurchaseSupplierPayment'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            ExecuteSP(SPName)

    elif endpoint == 'Purchase/DebitRefund':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, debitrefund in All_Data.iterrows():
                    debitrefund_data = {
                    'RowVersion': str(debitrefund.get('RowVersion', '') or ''),
                    'UID': str(debitrefund.get('UID', '') or ''),
                    'DepositTo': str(debitrefund.get('DepositTo', '') or ''),
                    'Number': str(debitrefund.get('Number', '') or ''),
                    'Date': debitrefund.get('Date', ''),
                    'Amount': float(debitrefund.get('Amount', '0') or '0'),
                    'Memo': str(debitrefund.get('Memo', '') or ''),
                    'PaymentMethod': str(debitrefund.get('PaymentMethod', '') or ''),
                    'URI': str(debitrefund.get('URI', '') or ''),
                    'NextPageLink': str(debitrefund.get('NextPageLink', '') or ''),
                    'Count': str(debitrefund.get('Count', '') or '')        
                    }
                    Account = debitrefund['Account']
                    if  Account is not None:
                        debitrefund_data[f'Account_UID'] = str(Account.get('UID', '') or '')
                        debitrefund_data[f'Account_Name'] = str(Account.get('Name', '') or '')
                        debitrefund_data[f'Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                        debitrefund_data[f'Account_URI'] = str(Account.get('URI', '') or '')
                    Bill = debitrefund['Bill']
                    if  Bill is not None:
                        debitrefund_data[f'Bill.UID'] = str(Bill.get('UID', '') or '')
                        debitrefund_data[f'Bill.Number'] = str(Bill.get('Number', '') or '')
                        debitrefund_data[f'Bill.URI'] = str(Bill.get('URI', '') or '')    
                    Supplier = debitrefund['Supplier']
                    if  Supplier is not None:
                        debitrefund_data[f'Supplier.UID'] = str(Supplier.get('UID', '') or '')
                        debitrefund_data[f'Supplier.Name'] = str(Supplier.get('Name', '') or '')
                        debitrefund_data[f'Supplier.DisplayID'] = str(Supplier.get('DisplayID', '') or '')
                        debitrefund_data[f'Supplier.URI'] = str(Supplier.get('URI', '') or '')
                    ForeignCurrency = debitrefund['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        debitrefund_data[f'ForeignCurrency.UID'] = str(ForeignCurrency.get('UID', '') or '')
                        debitrefund_data[f'ForeignCurrency.Code'] = str(ForeignCurrency.get('Code', '') or '')
                        debitrefund_data[f'ForeignCurrency.Name'] = str(ForeignCurrency.get('Name', '') or '')
                        debitrefund_data[f'ForeignCurrency.URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(debitrefund_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)


        # 4. Load data to Stage Table
            endpoint = 'PurchaseDebitRefund'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            ExecuteSP(SPName)

    elif endpoint == 'Purchase/DebitSettlement':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, debitsettlement in All_Data.iterrows():
                for line in debitsettlement.get('Lines', []):  
                    debitsettlement_data = {
                    'P_Items_UID': str(debitsettlement.get('UID', '') or ''),
                    'P_Items_Number': str(debitsettlement.get('Number', '') or ''),
                    'P_Items_Date': debitsettlement.get('Date', ''),
                    'P_Items_DebitAmount': float(debitsettlement.get('DebitAmount', '0') or '0'),
                    'P_Items_Memo': str(debitsettlement.get('Memo', '') or ''),
                    'P_Items_URI': str(debitsettlement.get('URI', '') or ''),
                    'P_Items_RowVersion': str(debitsettlement.get('RowVersion', '') or ''),
                    'P_NextPageLink': str(debitsettlement.get('NextPageLink', '') or ''),
                    'P_Count': str(debitsettlement.get('Count', '') or ''),
                    'Type': str(line.get('Type', '') or ''),
                    'Purchase.UID': str(line.get('Purchase', {}).get('UID', '') or ''),
                    'Purchase.Number': str(line.get('Purchase', {}).get('Number', '') or ''),
                    'Purchase.URI': str(line.get('Purchase', {}).get('URI', '') or ''),
                    'AmountApplied': float(line.get('AmountApplied', '0') or '0')                 
                    }
                    DebitFromBill = debitsettlement['DebitFromBill']
                    if  DebitFromBill is not None:
                        debitsettlement_data[f'P_Items_DebitFromBill_UID'] = str(DebitFromBill.get('UID', '') or '')
                        debitsettlement_data[f'P_Items_DebitFromBill_Number'] = str(DebitFromBill.get('Number', '') or '')
                        debitsettlement_data[f'P_Items_DebitFromBill_URI'] = str(DebitFromBill.get('URI', '') or '')   
                    Supplier = debitsettlement['Supplier']
                    if  Supplier is not None:
                        debitsettlement_data[f'P_Items_Customer_UID'] = str(Supplier.get('UID', '') or '')
                        debitsettlement_data[f'P_Items_Customer_Name'] = str(Supplier.get('Name', '') or '')
                        debitsettlement_data[f'P_Items_Customer_DisplayID'] = str(Supplier.get('DisplayID', '') or '')
                        debitsettlement_data[f'P_Items_Customer_URI'] = str(Supplier.get('URI', '') or '')
                    ForeignCurrency = debitsettlement['ForeignCurrency']
                    if  ForeignCurrency is not None:
                        debitsettlement_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                        debitsettlement_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                        debitsettlement_data[f'P_Items_ForeignCurrency_Name'] = str(ForeignCurrency.get('Name', '') or '')
                        debitsettlement_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')
                    combined_data.append(debitsettlement_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'PurchaseDebitSettlement'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/Account':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, accounts in All_Data.iterrows():
                accounts_data = {
                    'UID': accounts.get('UID', ''),
                    'Name': accounts.get('Name', ''),
                    'DisplayID': accounts.get('Display ID', ''),
                    'Classification': accounts.get('Classification', ''),
                    'Type': accounts.get('Type', ''),
                    'Number': accounts.get('Number', ''),
                    'Description': accounts.get('Description', ''),
                    'IsActive': accounts.get('Is Active', ''),
                    'Level': accounts.get('Level', ''),
                    'OpeningBalance': accounts.get('OpeningBalance', ''),
                    'CurrentBalance': accounts.get('CurrentBalance', ''),
                    'IsHeader': accounts.get('IsHeader', ''),
                    'LastReconciledDate': accounts.get('LastReconciledDate', ''),
                    'URI': accounts.get('URI', ''),
                    'RowVersion': accounts.get('RowVersion', ''),
                    'LastModified': accounts.get('LastModified', '')        
                }
                ParentAccount = accounts['ParentAccount']
                if  ForeignCurrency is not None:
                    accounts_data[f'ParentAccount.UID'] = str(ParentAccount.get('UID', '') or '')
                    accounts_data[f'ParentAccount.Name'] = str(ParentAccount.get('Name', '') or '')
                    accounts_data[f'ParentAccount.DisplayID'] = str(ParentAccount.get('DisplayID', '') or '')
                    accounts_data[f'ParentAccount.URI'] = str(ParentAccount.get('URI', '') or '')
                TaxCode = accounts['TaxCode']
                if  ForeignCurrency is not None:
                    accounts_data[f'TaxCode.UID'] = str(TaxCode.get('UID', '') or '')
                    accounts_data[f'TaxCode.Code'] = str(TaxCode.get('Code', '') or '')
                    accounts_data[f'TaxCode.URI'] = str(TaxCode.get('URI', '') or '')
                BankingDetails = accounts['BankingDetails']
                if  ForeignCurrency is not None:
                    accounts_data[f'BankingDetails.BSBNumber'] = str(BankingDetails.get('BSBNumber', '') or '')
                    accounts_data[f'BankingDetails.BankAccountNumber'] = str(BankingDetails.get('BankAccountNumber', '') or '')
                    accounts_data[f'BankingDetails.BankAccountName'] = str(BankingDetails.get('BankAccountName', '') or '')
                    accounts_data[f'BankingDetails.CompanyTradingName'] = str(BankingDetails.get('CompanyTradingName', '') or '')

                    accounts_data[f'BankingDetails.BankCode'] = str(BankingDetails.get('BankCode', '') or '')
                    accounts_data[f'BankingDetails.CreateBankFiles'] = str(BankingDetails.get('CreateBankFiles', '') or '')
                    accounts_data[f'BankingDetails.DirectEntryUserId'] = str(BankingDetails.get('DirectEntryUserId', '') or '')
                    accounts_data[f'BankingDetails.IncludeSelfBalancingTransaction'] = str(BankingDetails.get('IncludeSelfBalancingTransaction', '') or '')
                    accounts_data[f'BankingDetails.StatementParticulars'] = str(BankingDetails.get('StatementParticulars', '') or '') 
                    accounts_data[f'BankingDetails.StatementCode'] = str(BankingDetails.get('StatementCode', '') or '')
                    accounts_data[f'BankingDetails.StatementReference'] = str(BankingDetails.get('StatementReference', '') or '')   
                ForeignCurrency = accounts['ForeignCurrency']
                if  ForeignCurrency is not None:
                    accounts_data[f'ForeignCurrency.UID'] = str(ForeignCurrency.get('UID', '') or '')
                    accounts_data[f'ForeignCurrency.Code'] = str(ForeignCurrency.get('Code', '') or '')
                    accounts_data[f'ForeignCurrency.CurrencyName'] = str(ForeignCurrency.get('CurrencyName', '') or '')
                    accounts_data[f'ForeignCurrency.URI'] = str(ForeignCurrency.get('URI', '') or '')
                combined_data.append(accounts_data)
            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'Accounts'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/AccountBudget':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, accountbudget in All_Data.iterrows():
                # Line Items
                for line in accountbudget.get('Lines', []):  # handle missing 'JournalLines' column
                    accountbudget_data = {
                    'P_NextPageLink': accountbudget.get('NextPageLink', ''),
                    'P_Count': accountbudget.get('Count', ''),
                    'P_Items_FinancialYear': accountbudget.get('FinancialYear', ''),
                    'P_Items_LastMonthInFinancialYear': accountbudget.get('LastMonthInFinancialYear', ''),
                    'P_Items_URI': accountbudget.get('URI', ''),

                    'P_Items_Budgets_Account_UID': line.get('Budgets Account_UID', ''),
                    'P_Items_Budgets_Account_Name': line.get('Budgets Account Name', ''),
                    'P_Items_Budgets_Account_DisplayID': line.get('Budgets Account DisplayID', ''),
                    'P_Items_Budgets_Account_URI': line.get('Budgets Account URI', ''),

                    'Year': accountbudget.get('Year', ''),
                    'Month': accountbudget.get('Month', ''),
                    'Amount': accountbudget.get('Amount', '')        
                    }
                    combined_data.append(accountbudget_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'AccountBudget'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/Category':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, category in All_Data.iterrows():
                    category_data = {
                    'UID': str(category.get('UID', '')),
                    'URI': str(category.get('URI', '')),
                    'RowVersion': str(category.get('RowVersion', '')),
                    'DisplayID': str(category.get('DisplayID', '')),
                    'Name': str(category.get('Name', '')),
                    'Description': str(category.get('Description', '')),
                    'IsActive': category.get('IsActive', '')        
                    }
                    combined_data.append(category_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'Category'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/GeneralJournal':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            combined_data = []
            for index, generaljournal in All_Data.iterrows():
                for line in generaljournal.get('Lines', []):    
                    generaljournal_data = {
                    'P_Items_UID': str(generaljournal.get('UID', '') or ''),
                    'P_Items_DisplayID': str(generaljournal.get('DisplayID', '') or ''),
                    'P_Items_DateOccurred': generaljournal.get('Date Occurred', ''),
                    'P_Items_IsTaxInclusive': generaljournal.get('IsTaxInclusive', ''),
                    'P_Items_Memo': str(generaljournal.get('Memo', '') or ''),
                    'P_Items_GSTReportingMethod': str(generaljournal.get('GSTReportingMethod', '') or ''),
                    'P_Items_IsYearEndAdjustment': generaljournal.get('IsYearEndAdjustment', ''),
                    'P_Items_URI': str(generaljournal.get('URI', '') or ''),
                    'CurrencyExchangeRate': float(generaljournal.get('CurrencyExchangeRate', '0') or '0'),
                    'P_Items_RowVersion': str(generaljournal.get('RowVersion', '') or ''),
                    'P_NextPageLink': str(generaljournal.get('NextPageLink', '') or ''),
                    'P_Count': str(generaljournal.get('Count', '') or ''),                   
                    'RowID': int(line.get('RowID', '') or ''),
                    'Account.UID': str(line.get('Account', {}).get('UID', '') or ''),
                    'Account.Name': str(line.get('Account', {}).get('Name', '') or ''),
                    'Account.DisplayID': str(line.get('Account', {}).get('DisplayID', '') or ''),
                    'Account.URI': str(line.get('Account', {}).get('URI', '') or ''),
                    'Memo': line.get('Memo', ''),
                    'TaxCode.UID': str(line.get('TaxCode', {}).get('UID', '') or ''),
                    'TaxCode.Code': str(line.get('TaxCode', {}).get('Code', '') or ''),
                    'TaxCode.URI': str(line.get('TaxCode', {}).get('URI', '') or ''),
                    'Amount': float(line.get('Amount', '0') or '0'),
                    'AmountForeign': float(line.get('AmountForeign', '0') or '0'),
                    'IsCredit': line.get('IsCredit', ''),
                    'TaxAmount': float(line.get('TaxAmount', '') or '0'),
                    'TaxAmountForeign': float(line.get('TaxAmountForeign', '0') or '0'),
                    'IsOverriddenTaxAmount': line.get('IsOverriddenTaxAmount', ''),
                    'UnitCount': float(line.get('UnitCount', '0') or '0'),
                    'RowVersion': str(line.get('RowVersion', '') or '')
                }
                Category = generaljournal['Category']
                if  Category is not None:
                    generaljournal_data[f'Category.UID'] = str(Category.get('UID', '') or '')
                    generaljournal_data[f'Category.Name'] = str(Category.get('Name', '') or '')
                    generaljournal_data[f'Category.URI'] = str(Category.get('URI', '') or '')
                Job = generaljournal['Job']
                if  Job is not None:
                    generaljournal_data[f'P_Items_Job.UID'] = str(Job.get('UID', '') or '')
                    generaljournal_data[f'P_Items_Job.Number'] = str(Job.get('Number', '') or '')
                    generaljournal_data[f'P_Items_Job.Name'] = str(Job.get('Name', '') or '')
                    generaljournal_data[f'P_Items_Job.URI'] = str(Job.get('URI', '') or '')
                combined_data.append(generaljournal_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'GeneralJournal'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/Job':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, job in All_Data.iterrows():
                    job_data = {
                    'RowVersion': job.get('RowVersion', ''),
                    'UID': job.get('UID', ''),
                    'Number': job.get('Number', ''),
                    'IsHeader': job.get('IsHeader', ''),
                    'Name': job.get('Name', ''),
                    'Description': job.get('Description', ''),
                    'PercentComplete': job.get('PercentComplete', ''),
                    'StartDate': job.get('StartDate', ''),
                    'FinishDate': job.get('FinishDate', ''),
                    'Contact': job.get('Contact', ''),
                    'Manager': job.get('Manager', ''),
                    'IsActive': job.get('Is Active', ''),
                    'TrackReimbursables': job.get('TrackReimbursables', ''),
                    'URI': job.get('URI', ''),
                    'LastModified': job.get('LastModified', '')        
                    }
                    LinkedCustomer = job['LinkedCustomer']
                    if  LinkedCustomer is not None:
                        job_data[f'LinkedCustomer.UID'] = str(LinkedCustomer.get('UID', '') or '')
                        job_data[f'LinkedCustomer.Name'] = str(LinkedCustomer.get('Name', '') or '')
                        job_data[f'LinkedCustomer.DisplayID'] = str(LinkedCustomer.get('DisplayID', '') or '')
                        job_data[f'LinkedCustomer.URI'] = str(LinkedCustomer.get('URI', '') or '')
                    ParentJob = job['ParentJob']
                    if  ParentJob is not None:
                        job_data[f'ParentJob.UID'] = str(ParentJob.get('UID', '') or '')
                        job_data[f'ParentJob.Number'] = str(ParentJob.get('Number', '') or '')
                        job_data[f'ParentJob.Name'] = str(ParentJob.get('Name', '') or '')
                        job_data[f'ParentJob.URI'] = str(ParentJob.get('URI', '') or '')
                        combined_data.append(job_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'Job'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/JournalTransaction':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            combined_data = []
            for index, journal in All_Data.iterrows():
                for line in journal.get('Lines', []):  
                    journal_line_data = {
                    'P_Items_UID': str(journal.get('UID', '') or ''),
                    'P_Items_DisplayID': str(journal.get('DisplayID', '') or ''),
                    'P_Items_JournalType': str(journal.get('JournalType', '') or ''),
                    'P_Items_DateOccurred': journal.get('DateOccurred', ''),
                    'P_Items_DatePosted': journal.get('DatePosted', ''),
                    'P_Items_Description': str(journal.get('Description', '') or ''),
                    'Amount': float(line.get('Amount', '0') or '0'),
                    'IsCredit': line.get('IsCredit', ''),
                    'LineDescription': str(line.get('LineDescription', '') or ''),
                    'ReconciledDate': line.get('ReconciledDate', ''),
                    'P_Items_URI': str(journal.get('URI', '') or ''),
                    'P_Items_RowVersion': str(journal.get('RowVersion', '') or '')
                    }
                    SourceTransaction = journal['SourceTransaction']
                    if  SourceTransaction is not None:
                        journal_line_data[f'P_Items_SourceTransaction_UID'] = str(SourceTransaction.get('UID', '') or '')
                        journal_line_data[f'P_Items_SourceTransaction_TransactionType'] = str(SourceTransaction.get('TransactionType', '') or '')
                        journal_line_data[f'P_Items_SourceTransaction_URI'] = str(SourceTransaction.get('URI', '') or '')
                    Account = journal['Account']
                    if  Account is not None:
                        journal_line_data[f'Account.UID'] = str(Account.get('UID', '') or '')
                        journal_line_data[f'Account.Name'] = str(Account.get('Name', '') or '')
                        journal_line_data[f'Account.DisplayID'] = str(Account.get('DisplayID', '') or '')
                        journal_line_data[f'Account.URI'] = str(Account.get('URI', '') or '')
                    if 'Job' in line and line['Job'] != None:
                        Job = line['Job']
                        journal_line_data[f'Job.UID'] = Job.get('UID', '')
                        journal_line_data[f'Job.Number'] = Job.get('Number', '')
                        journal_line_data[f'Job.Name'] = Job.get('Name', '')
                        journal_line_data[f'Job.URI'] = Job.get('URI', '')

                    combined_data.append(journal_line_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'GeneralLedger/JobBudget':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, jobbudget in All_Data.iterrows():
                for line in jobbudget.get('Lines', []):  # handle missing 'JournalLines' column
                    jobbudget_data = {
                    'UID': str(jobbudget.get('UID', '') or ''),
                    'URI': str(jobbudget.get('URI', '') or ''),
                    'Account_UID': str(line.get('Account', {}).get('UID', '') or ''),
                    'Account_Name': str(line.get('Account', {}).get('Name', '') or ''),
                    'Account_DisplayID': str(line.get('Account', {}).get('DisplayID', '') or ''),
                    'Account_URI': str(line.get('Account', {}).get('URI', '') or ''),
                    'Amount': float(line.get('Amount', '0') or '0'),
                    'P_Items_RowVersion': str(jobbudget.get('RowVersion', '') or ''),
                    'P_NextPageLink': str(jobbudget.get('NextPageLink', '') or ''),
                    'P_Count': str(jobbudget.get('Count', '') or '')        
                }
                Job = jobbudget['Job']
                if  Job is not None:
                    jobbudget_data[f'Job_UID'] = str(Job.get('UID', '') or '')
                    jobbudget_data[f'Job_Number'] = str(Job.get('Number', '') or '')
                    jobbudget_data[f'Job_Name'] = str(Job.get('Name', '') or '')
                    jobbudget_data[f'Job_URI'] = str(Job.get('URI', '') or '')        
                combined_data.append(jobbudget_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'JobBudget'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Banking/SpendMoneyTxn':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, bankingspendmoney in All_Data.iterrows():
                for line in bankingspendmoney.get('Lines', []):  
                    bankingspendmoney_data = {
                    'P_Items_UID': str(bankingspendmoney.get('UID', '')or ''),
                    'P_Items_PayFrom': str(bankingspendmoney.get('PayFrom', '')or ''),
                    'P_Items_PayeeAddress': str(bankingspendmoney.get('PayeeAddress', '')or ''),
                    'P_Items_StatementParticulars': str(bankingspendmoney.get('StatementParticulars', '')or ''),
                    'P_Items_StatementCode': str(bankingspendmoney.get('StatementCode', '')or ''),
                    'P_Items_StatementReference': str(bankingspendmoney.get('StatementReference', '')or ''),
                    'P_Items_PaymentNumber': str(bankingspendmoney.get('PaymentNumber', ''or '')),
                    'P_Items_Date': bankingspendmoney.get('Date', ''),
                    'P_Items_AmountPaid': float(bankingspendmoney.get('AmountPaid', '0')or '0'),
                    'P_Items_IsTaxInclusive': bankingspendmoney.get('IsTaxInclusive', ''),
                    'P_Items_TotalTax': float(bankingspendmoney.get('TotalTax', '0')or '0'),
                    'P_Items_Memo': str(bankingspendmoney.get('Memo', '')or ''),
                    'P_Items_ChequePrinted': str(bankingspendmoney.get('ChequePrinted', '')or ''),
                    'P_Items_DeliveryStatus': str(bankingspendmoney.get('DeliveryStatus', '')or ''),
                    'P_Items_URI': str(bankingspendmoney.get('URI', '')or ''),
                    'P_Items_RowVersion': str(bankingspendmoney.get('RowVersion', '')or ''),
                    'P_NextPageLink': str(bankingspendmoney.get('PageLink', '')or ''),
                    'P_Count': str(bankingspendmoney.get('Count', '')or ''),
                    'RowID': int(line.get('Row ID', '')or ''),
                    'TaxCode.UID': str(line.get('TaxCode', {}).get('UID', '') or ''),
                    'TaxCode.Code': str(line.get('TaxCode', {}).get('Code', '') or ''),
                    'TaxCode.URI': str(line.get('TaxCode', {}).get('URI', '') or ''),
                    'Account_UID': str(line.get('Account', {}).get('UID', '') or ''),
                    'Account_Name': str(line.get('Account', {}).get('Name', '') or ''),
                    'Account_DisplayID': str(line.get('Account', {}).get('DisplayID', '') or ''),
                    'Account_URI': str(line.get('Account', {}).get('URI', '') or ''),
                    'RowVersion': str(line.get('Row Version', '')or ''),
                    'Amount': float(line.get('Amount', '0')or '0'),
                    'UnitCount': float(line.get('UnitCount', '0')or '0'),
                    'Memo': line.get('Memo', ''),
                    'Job_UID': str(line.get('Job', {}).get('UID', '') or ''),
                    'Job_Name': str(line.get('Job', {}).get('Name', '') or ''),
                    'Job_Number': str(line.get('Job', {}).get('Number', '') or ''),
                    'Job_URI': str(line.get('Job', {}).get('URI', '') or '')
                 }
                Account = bankingspendmoney['Account']
                if  Account is not None:
                    bankingspendmoney_data[f'P_Items_Account_UID'] = str(Account.get('UID', '') or '')
                    bankingspendmoney_data[f'P_Items_Account_Name'] = str(Account.get('Name', '') or '')
                    bankingspendmoney_data[f'P_Items_Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                    bankingspendmoney_data[f'P_Items_Account_URI'] = str(Account.get('URI', '') or '')
                Contact = bankingspendmoney['Contact']
                if  Contact is not None:
                    bankingspendmoney_data[f'P_Items_Contact_Type'] = str(Contact.get('Type', '') or '')
                    bankingspendmoney_data[f'P_Items_Contact_UID'] = str(Contact.get('UID', '') or '')
                    bankingspendmoney_data[f'P_Items_Contact_Name'] = str(Contact.get('Name', '') or '')
                    bankingspendmoney_data[f'P_Items_Contact_DisplayID'] = str(Contact.get('DisplayID', '') or '')
                    bankingspendmoney_data[f'P_Items_Contact_URI'] = str(Contact.get('URI', '') or '')
                Category = bankingreceivemoney['Category']
                if  Category is not None:
                    bankingspendmoney_data[f'P_Items_Category_UID'] = str(Category.get('UID', '') or '')
                    bankingspendmoney_data[f'P_Items_Category_Name'] = str(Category.get('Name', '') or '')
                    bankingspendmoney_data[f'P_Items_Category_DisplayID'] = str(Category.get('DisplayID', '') or '')
                    bankingspendmoney_data[f'P_Items_Category_URI'] = str(Category.get('URI', '') or '')
                ForeignCurrency = bankingreceivemoney['ForeignCurrency']
                if  ForeignCurrency is not None:
                    bankingspendmoney_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                    bankingspendmoney_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                    bankingspendmoney_data[f'P_Items_ForeignCurrency_CurrencyName'] = str(ForeignCurrency.get('CurrencyName', '') or '')
                    bankingspendmoney_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '') 
                    combined_data.append(journal_line_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'BankingSpendMoney'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Banking/ReceiveMoneyTxn':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, bankingreceivemoney in All_Data.iterrows():
                for line in bankingreceivemoney.get('Lines', []):  
                    bankingreceivemoney_data = {
                    'P_Items_UID': str(bankingreceivemoney.get('UID', '')or ''), 
                    'P_Items_DepositTo': str(bankingreceivemoney.get('DepositTo', '')or ''),
                    'P_Items_ReceiptNumber': str(bankingreceivemoney.get('ReceiptNumber', '')or ''),
                    'P_Items_Date': bankingreceivemoney.get('Date', ''),
                    'P_Items_AmountReceived': float(bankingreceivemoney.get('AmountReceived', '0')or '0'),
                    'P_Items_IsTaxInclusive': bankingreceivemoney.get('IsTaxInclusive', ''),
                    'P_Items_TotalTax': float(bankingreceivemoney.get('TotalTax', '0')or '0'),
                    'P_Items_PaymentMethod': str(bankingreceivemoney.get('PaymentMethod', '')or ''),
                    'P_Items_Memo': str(bankingreceivemoney.get('Items Memo', '')or ''),
                    'P_Items_URI': str(bankingreceivemoney.get('URI', '')or ''),
                    'P_Items_RowVersion': str(bankingreceivemoney.get('RowVersion', '')or ''),
                    'P_NextPageLink': str(bankingreceivemoney.get('NextPageLink', '')or ''),
                    'P_Count': str(bankingreceivemoney.get('Count', '')or ''),
                    'RowID': int(line.get('RowId', '')or ''),
                    'Account.UID': str(line.get('Account', {}).get('UID', '') or ''),
                    'Account.Name': str(line.get('Account', {}).get('Name', '') or ''),
                    'Account.DisplayID': str(line.get('Account', {}).get('DisplayID', '') or ''),
                    'Account.URI': str(line.get('Account', {}).get('URI', '') or ''),
                    'Job_UID': str(line.get('Job', {}).get('UID', '') or ''),
                    'Job_Name': str(line.get('Job', {}).get('Name', '') or ''),
                    'Job_Number': str(line.get('Job', {}).get('Number', '') or ''),
                    'Job_URI': str(line.get('Job', {}).get('URI', '') or ''),
                    'TaxCode.UID': str(line.get('TaxCode', {}).get('UID', '') or ''),
                    'TaxCode.Code': str(line.get('TaxCode', {}).get('Code', '') or ''),
                    'TaxCode.URI': str(line.get('TaxCode', {}).get('URI', '') or ''),
                    'Memo': line.get('Memo', ''),
                    'Amount': float(line.get('Amount', '0')or '0'),
                    'UnitCount': float(line.get('UnitCount', '0')or '0'),
                    'RowVersion': str(line.get('RowVersion', '')or '')
                }
                Account = bankingreceivemoney['Account']
                if  Account is not None:
                    bankingreceivemoney_data[f'P_Items_Account_UID'] = str(Account.get('UID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Account_Name'] = str(Account.get('Name', '') or '')
                    bankingreceivemoney_data[f'P_Items_Account_DisplayID'] = str(Account.get('DisplayID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Account_URI'] = str(Account.get('URI', '') or '')
                Contact = bankingreceivemoney['Contact']
                if  Contact is not None:
                    bankingreceivemoney_data[f'P_Items_Contact_Type'] = str(Contact.get('Type', '') or '')
                    bankingreceivemoney_data[f'P_Items_Contact_UID'] = str(Contact.get('UID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Contact_Name'] = str(Contact.get('Name', '') or '')
                    bankingreceivemoney_data[f'P_Items_Contact_DisplayID'] = str(Contact.get('DisplayID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Contact_URI'] = str(Contact.get('URI', '') or '')
                Category = bankingreceivemoney['Category']
                if  Category is not None:
                    bankingreceivemoney_data[f'P_Items_Category_UID'] = str(Category.get('UID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Category_Name'] = str(Category.get('Name', '') or '')
                    bankingreceivemoney_data[f'P_Items_Category_DisplayID'] = str(Category.get('DisplayID', '') or '')
                    bankingreceivemoney_data[f'P_Items_Category_URI'] = str(Category.get('URI', '') or '')
                ForeignCurrency = bankingreceivemoney['ForeignCurrency']
                if  ForeignCurrency is not None:
                    bankingreceivemoney_data[f'P_Items_ForeignCurrency_UID'] = str(ForeignCurrency.get('UID', '') or '')
                    bankingreceivemoney_data[f'P_Items_ForeignCurrency_Code'] = str(ForeignCurrency.get('Code', '') or '')
                    bankingreceivemoney_data[f'P_Items_ForeignCurrency_CurrencyName'] = str(ForeignCurrency.get('CurrencyName', '') or '')
                    bankingreceivemoney_data[f'P_Items_ForeignCurrency_URI'] = str(ForeignCurrency.get('URI', '') or '')

                    combined_data.append(bankingreceivemoney_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            endpoint = 'BankingReceiveMoney'
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'Company':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, company in All_Data.iterrows():
                    company_data = {
                    'RowVersion': str(company.get('RowVersion', '')),    
                    'CompanyName': str(company.get('CompanyName', '')),
                    'SerialNumber': int(company.get('SerialNumber', '')),
                    'Address': str(company.get('Address', '')),
                    'FaxNumber': str(company.get('FaxNumber', '')),
                    'EmailAddress': str(company.get('EmailAddress', '')),
                    'ABNOrTFN': str(company.get('ABNOrTFN', '')),
                    'ABNBranch': str(company.get('ABNBranch', '')),
                    'ACN': str(company.get('ACN', '')),
                    'SalesTaxNumber': str(company.get('SalesTaxNumber', '')),
                    'PayeeNumber': str(company.get('PayeeNumber', '')),
                    'ReadOnly': str(company.get('ReadOnly', ''))      
                    }
                    combined_data.append(company_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)

    elif endpoint == 'CompanyPreferences':

        # 1. Request API Call
            All_Data = MYOBARRequests(endpoint)
        
        # 2. Convert data frame data type to SQL data type
            #All_Data = pd.concat(All_Data, ignore_index=True)
            combined_data = []
            for index, companypreferences in All_Data.iterrows():
                    companypreferences_data = {
                    'RowVersion': str(companypreferences.get('RowVersion', '') or ''),
                    'ReportsAndForms.ReportTaxablePayments': str(companypreferences.get('ReportsAndForms.ReportTaxablePayments', '') or ''), 
                    'ReportsAndForms.EmailDefaults.Sales.Invoice.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Invoice.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Invoice.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Invoice.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Invoice.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Invoice.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.Sales.Order.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Order.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Order.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Order.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Order.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Order.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.Sales.Quote.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Quote.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Quote.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Quote.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Sales.Quote.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Sales.Quote.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Bill.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Bill.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Bill.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Bill.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Bill.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Bill.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Order.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Order.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Order.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Order.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Order.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Order.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Quote.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Quote.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Quote.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Quote.Message', '') or ''),
                    'ReportsAndForms.EmailDefaults.Purchases.Quote.IncludeNumberInSubject': companypreferences.get('ReportsAndForms.EmailDefaults.Purchases.Quote.IncludeNumberInSubject', ''),
                    'ReportsAndForms.EmailDefaults.PaySlips.Subject': str(companypreferences.get('ReportsAndForms.EmailDefaults.PaySlips.Subject', '') or ''),
                    'ReportsAndForms.EmailDefaults.PaySlips.Message': str(companypreferences.get('ReportsAndForms.EmailDefaults.PaySlips.Message', '') or ''),
                    'Banking.PreferToReceiveMoneyIntoUndepositedFunds': companypreferences.get('Banking.PreferToReceiveMoneyIntoUndepositedFunds', ''),
                    'Sales.Terms.PaymentIsDue': str(companypreferences.get('Sales.Terms.PaymentIsDue', '') or ''),
                    'Sales.Terms.DiscountDate': int(companypreferences.get('Sales.Terms.DiscountDate', '') or ''),
                    'Sales.Terms.BalanceDueDate': int(companypreferences.get('Sales.Terms.BalanceDueDate', '') or ''),
                    'Sales.Terms.DiscountForEarlyPayment': float(companypreferences.get('Sales.Terms.DiscountForEarlyPayment', '')or '0'),
                    'Sales.Terms.MonthlyChargeForLatePayment': float(companypreferences.get('Sales.Terms.MonthlyChargeForLatePayment', '0') or '0'),
                    'Sales.Terms.PriceLevel': str(companypreferences.get('Sales.Terms.PriceLevel', '') or ''),
                    'Sales.Terms.TaxCode.UID': str(companypreferences.get('Sales.Terms.TaxCode.UID', '') or ''),
                    'Sales.Terms.TaxCode.Code': str(companypreferences.get('Sales.Terms.TaxCode.Code', '') or ''),
                    'Sales.Terms.TaxCode.URI': str(companypreferences.get('Sales.Terms.TaxCode.URI', '') or ''),
                    'Sales.Terms.UseCustomerTaxCode': companypreferences.get('Sales.Terms.UseCustomerTaxCode', ''),
                    'Sales.Terms.FreightTaxCode.UID': str(companypreferences.get('Sales.Terms.FreightTaxCode.UID', '') or ''),
                    'Sales.Terms.FreightTaxCode.Code': str(companypreferences.get('Sales.Terms.FreightTaxCode.Code', '') or ''),
                    'Sales.Terms.FreightTaxCode.URI': str(companypreferences.get('Sales.Terms.FreightTaxCode.URI', '') or ''),
                    'Sales.Terms.CreditLimit': float(companypreferences.get('Sales.Terms.CreditLimit', '0') or '0'),
                    'Purchases.Terms.PaymentIsDue': str(companypreferences.get('Purchases.Terms.PaymentIsDue', '') or ''),
                    'Purchases.Terms.DiscountDate': int(companypreferences.get('Purchases.Terms.DiscountDate', '') or ''),
                    'Purchases.Terms.BalanceDueDate': int(companypreferences.get('Purchases.Terms.BalanceDueDate', '') or ''),
                    'Purchases.Terms.DiscountForEarlyPayment': float(companypreferences.get('Purchases.Terms.DiscountForEarlyPayment', '0') or '0'),
                    'Purchases.Terms.TaxCode.UID': str(companypreferences.get('Purchases.Terms.TaxCode.UID', '') or ''),
                    'Purchases.Terms.TaxCode.Code': str(companypreferences.get('Purchases.Terms.TaxCode.Code', '') or ''),
                    'Purchases.Terms.TaxCode.URI': str(companypreferences.get('Purchases.Terms.TaxCode.URI', '') or ''),
                    'Purchases.Terms.UseSupplierTaxCode': companypreferences.get('Purchases.Terms.UseSupplierTaxCode', ''),
                    'Purchases.Terms.FreightTaxCode.UID': str(companypreferences.get('Purchases.Terms.FreightTaxCode.UID', '') or ''),
                    'Purchases.Terms.FreightTaxCode.Code': str(companypreferences.get('Purchases.Terms.FreightTaxCode.Code', '') or ''),
                    'Purchases.Terms.FreightTaxCode.URI': str(companypreferences.get('Purchases.Terms.FreightTaxCode.URI', '') or ''),
                    'Purchases.Terms.CreditLimit': float(companypreferences.get('Purchases.Terms.CreditLimit', '0') or '0'),
                    'Timesheets.UseTimesheetsFor': str(companypreferences.get('Timesheets.UseTimesheetsFor', '') or ''),   
                    'Timesheets.WeekStartsOn': str(companypreferences.get('Timesheets.WeekStartsOn', '') or '')        
                    }
                    System = companypreferences['System']
                    if  System is not None:
                        companypreferences_data[f'System.CategoryTracking'] = str(System.get('CategoryTracking', '') or '')
                        companypreferences_data[f'System.TransactionsCannotBeChangedMustBeReversed'] = System.get('TransactionsCannotBeChangedMustBeReversed', '') 
                        companypreferences_data[f'System.LockPeriodPriorTo'] = System.get('LockPeriodPriorTo', '') 
                        combined_data.append(companypreferences_data)

            Combined_Data = pd.DataFrame(combined_data)
            ConvertedData = ConvertDataTypes(Combined_Data)

        # 4. Load data to Stage Table
            LoadToStageTable(ConvertedData, endpoint)
        
        # 5. Transform and Load Stage data to Prod Table
            #SPName = EtaniClientID + '.uspUpsert_MYOBAR_' + endpoint + '_' + EtaniOrganisationID
            #ExecuteSP(SPName)        


# refresh_token = 'REDACTED'
# result = GetNewToken(refresh_token)
# print(result)

ExtractAPIResponse('Contact')
#ExtractAPIResponse('Sale/Invoice')
#ExtractAPIResponse('Sale/CustomerPayment')
#ExtractAPIResponse('Sale/CreditRefund')
#ExtractAPIResponse('Sale/CreditSettlement')
#ExtractAPIResponse('Purchase/Bill')
#ExtractAPIResponse('Purchase/SupplierPayment')
#ExtractAPIResponse('Purchase/DebitRefund')
#ExtractAPIResponse('Purchase/DebitSettlement')
#ExtractAPIResponse('GeneralLedger/Accounts')
#ExtractAPIResponse('GeneralLedger/AccountBudget')
#ExtractAPIResponse('GeneralLedger/GeneralJournal')
#ExtractAPIResponse('GeneralLedger/Job')
#ExtractAPIResponse('GeneralLedger/JournalTransaction')
#ExtractAPIResponse('GeneralLedger/JobBudget')
#ExtractAPIResponse('Banking/SpendMoneyTxn')
#ExtractAPIResponse('Banking/ReceiveMoneyTxn')
#ExtractAPIResponse('Company')
#ExtractAPIResponse('CompanyPreferences')

print("Completed API Data Refresh");