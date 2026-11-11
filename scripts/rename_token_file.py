
# Support direct operational CLI execution.
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from azure.storage.fileshare import ShareFileClient, ShareDirectoryClient
import config

# Replace with your Azure Storage account details
StorageAccountName = config.STORAGE_ACCOUNT_NAME
StorageAccessKey = config.STORAGE_ACCOUNT_KEY
FileShareName= config.FILE_SHARE_NAME
directory_path = ''  # Use '' for the root directory

directory_client = ShareDirectoryClient.from_connection_string(
        f"DefaultEndpointsProtocol=https;AccountName={StorageAccountName};AccountKey={StorageAccessKey};BlobEndpoint=https://{StorageAccountName}.file.core.windows.net/",
        FileShareName,
        directory_path = directory_path
    )

# List files in the directory
matching_files = []

try:
    # Iterate through the files in the directory
    for file in directory_client.list_directories_and_files():
        if "RF_" in file.name:
            matching_files.append(file.name)
            print(file.name)        
    print(f"No. of files found: {len(matching_files)}")
    
    for file in matching_files:
        # Create a ShareFileClient for the file
        file_client = ShareFileClient.from_connection_string(
            f"DefaultEndpointsProtocol=https;AccountName={StorageAccountName};AccountKey={StorageAccessKey};BlobEndpoint=https://{StorageAccountName}.file.core.windows.net/",
            FileShareName,
            file
        )
        # Rename the file by appending 'RF_' to its name
        new_file_name = file.replace("RF_", "")
        file_client.rename_file(new_file_name)
        print(f"Renamed {file} to {new_file_name}")

except Exception as e:
    print(f"An error occurred: {e}")