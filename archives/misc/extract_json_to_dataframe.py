from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from azure.storage.fileshare import ShareFileClient, ShareClient
import pandas as pd
import json
import requests
import base64
import config

server_eva = config.MYSQL_SERVER_NAME
database_eva = config.MYSQL_SERVER_EVA_DATABASE
database_cms = config.MYSQL_SERVER_CMS_DATABASE
username_eva = config.MYSQL_SERVER_USERNAME
password_eva = config.MYSQL_SERVER_PASSWORD
ssl_cert = config.MYSQL_SERVER_SSL_CERT

StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName = config.FILE_SHARE_NAME
OldFileShareName = 'xerobluedwrefreshtoken'

client_id = config.XERO_CLIENT_ID
client_secret = config.XERO_CLIENT_SECRET

cms_connection_params = {
    "host": server_eva,
    "user": username_eva,
    "password": password_eva,
    "database": database_cms,
    "ssl": {"ca": ssl_cert},
    "autocommit": True,
}

cms_engine = create_engine(
    f"mysql+pymysql://{cms_connection_params['user']}:{cms_connection_params['password']}@{cms_connection_params['host']}/{cms_connection_params['database']}",
    connect_args={
        "ssl": cms_connection_params["ssl"],
        "autocommit": cms_connection_params["autocommit"],
    },
    pool_size=10,          # Adjust pool size as needed
    max_overflow=5,        # Extra connections beyond the pool size
    pool_timeout=30,       # Wait time for a connection
    pool_recycle=3600,     # Recycle connections every 1 hour
)


def ReadMySQLTable(query):
    engine = cms_engine
    
    try:
        # Fetch data into a DataFrame
        with engine.connect() as connection:
            df = pd.read_sql(query, connection)

    except SQLAlchemyError as e:
        print(f"Error: {str(e)}")
        return None

    finally:
        engine.dispose()
        return df

def ExtractTokenFromFiddler(code):
    with open(f'fiddler_log/{code}.json', 'r') as f:
        d = json.load(f)
        
    df = pd.json_normalize(d['entries'])
    df_filter = df[['request.url','request.headers', 'response.content.text']]
    df_filter.columns = ['requesturl','requestheaders','responsecontent']
    df_tokenrequest = df_filter.query('requesturl == "https://identity.xero.com/connect/token"')
    df_orgdetails = df_filter.query('requesturl == "https://api.xero.com/api.xro/2.0/Organisation"')

    #Tokenrequest - extract access and refresh token
    TokenRequest = []
    for index, row in df_tokenrequest.iterrows():
        token = row['responsecontent']
        if 'access_token' in token:
            token = json.loads(token)
            access_token = token['access_token']
            refresh_token = token['refresh_token']
            TokenRequest.append({'access_token':access_token,'refresh_token':refresh_token})
        
    df_tokenrequest = pd.DataFrame(TokenRequest)

    #Orgdetails - extract access token, organisation name and organisation ID
    Orgdetails = []
    for index, row in df_orgdetails.iterrows():
        token = row['requestheaders'][0]
        token = json.loads(str(token).replace("'","\""))
        access_token = token['value'].replace('Bearer ', '')
        org = row['responsecontent']
        org = json.loads(org)
        for line in org.get('Organisations', []):
            organisation_name = line['Name']
            organisation_id = line['OrganisationID']
            Orgdetails.append({'access_token':access_token,'organisation_name':organisation_name,'organisation_id':organisation_id})

    df_orgdetails = pd.DataFrame(Orgdetails)

    df_joined = pd.merge(df_tokenrequest, df_orgdetails, on='access_token')
    df_joined.columns = ['access_token','refresh_token','tenant_name','tenant_id']

    return df_joined

def ExtractOrgDetailsFromCMS(code):
    sqlScript = f"""
    SELECT 
        CONCAT(
            replace(upper(f.code),'-',''),
            '_CLIENT',
            IFNULL(JSON_EXTRACT(c.Details, '$.Legacy.id'),CAST(cs.`Client` AS CHAR(10)))
        ) AS ClientID,
        IFNULL(JSON_EXTRACT(cs.Details, '$.Legacy.id'),CAST(cs.id AS CHAR(10))) AS OrganisationID,
        JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.Organisation')) AS tenant_name,	
        JSON_UNQUOTE(JSON_EXTRACT(cs.Details, '$.tenantId')) AS tenant_id
    FROM client_service cs
    JOIN client c ON cs.`Client` = c.id
    JOIN accounting_firm f ON cs.AccountingFirm = f.id
    WHERE f.`Status` <> 2
    AND cs.`Status` <> 2
    AND c.`Status` <> 2
    AND service = 1
    AND replace(lower(f.code),'-','') = '{code}'
    #AND REPLACE(JSON_EXTRACT(cs.Details, '$.dbDestination'),'"','')='DW'
    """
    df = ReadMySQLTable(sqlScript)
    
    return df

def GetNewToken(refresh_token, TokenFileName):
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
    open(f'token/{TokenFileName}', 'w+').write(json.dumps(json_response))
    status_code = response.status_code

    if status_code == 200:
        token_file_name = TokenFileName
        share_file_client = ShareFileClient.from_connection_string(
            f"DefaultEndpointsProtocol=https;AccountName={StorageAccountName};AccountKey={StorageAccessKey};BlobEndpoint=https://{StorageAccountName}.file.core.windows.net/",
            FileShareName,
            token_file_name
        )
        data = json.dumps(json_response).encode('utf-8')
        share_file_client.upload_file(data)

        return token_file_name, json_response['access_token'], json_response['refresh_token']
    else:
        return json_response['error_description']

def GetDWTokenFileList(code):
    share_client = ShareClient(account_url=f"https://{StorageAccountName}.file.core.windows.net/",share_name=OldFileShareName,credential=StorageAccessKey)
    try:
        files = []
        file_list = share_client.list_directories_and_files()
        for file in file_list:
            filename = file.name
            #print(f"File: {filename}")
            files.append(filename)
        filtered_files = [filename for filename in files if str(code).upper() in filename]
            
        df = pd.DataFrame(filtered_files, columns=['FileName'])
        df['ClientID'] = df['FileName'].apply(lambda x: x.split('_')[1] + '_' + x.split('_')[2] if len(x.split('_')) > 2 else None)
        df['OrganisationID'] = df['FileName'].apply(lambda x: x.split('_')[3].split('.')[0] if len(x.split('_')) > 3 else None)
        df = df.drop(columns=['FileName'])
        
        return df
    except Exception as e:
        print(f"An error occurred: {e}")
        return None





FirmCode = 'ahp'

#d = GetNewToken(
#        refresh_token='REDACTED', 
#        TokenFileName='BLUMETRIC_CLIENT1982_6949.txt'
#    )
#print(d)

df_token = ExtractTokenFromFiddler(FirmCode)
df_orgdtls = ExtractOrgDetailsFromCMS(FirmCode)
df_orgdtls = pd.merge(df_orgdtls, df_token, on=['tenant_id'])

#compare DW Token list and Extracted Tokens
df_oldtoken = GetDWTokenFileList(FirmCode)
df_orgdtls = pd.merge(df_orgdtls, df_oldtoken, on=['ClientID','OrganisationID'])


for index, row in df_orgdtls.iterrows():
    refresh_token = row['refresh_token']
    TokenFileName = f"{row['ClientID']}_{row['OrganisationID']}.txt"
    print(refresh_token, TokenFileName)
    d = GetNewToken(refresh_token, TokenFileName)
    
print(df_orgdtls)

