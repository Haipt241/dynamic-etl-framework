import os
import sys
import pandas as pd
import json
import traceback
# import re  # <-- Ensure re is imported

# for Automation process
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from utils import ConvertDataTypes

json_folder = os.path.join(os.path.dirname(__file__), '..', 'json')
output_folder = os.path.join(os.path.dirname(__file__), '..','output')

if not os.path.exists(output_folder):
    os.makedirs(output_folder)

class TestDataTypes:
    def test_convert_datatypes(self):
        """ Iterate over JSON folder for the data to be converted to a dataframe.
            Convert each JSON file to pd.DataFrame, apply transformation, and 
            print a preview
        """
        # Delete .csv file in output folder
        # for f in os.listdir(output_folder):
        #     if f.endswith(".csv"):
        #         os.remove(os.path.join(output_folder, f))

        # Print out the path to checsk if it's correct
        print("Looking fo JSON files in:", json_folder)

        # Check if the JSON folder exists
        if not os.path.exists(json_folder):
            print(f"Error: The folder {json_folder} does not exist!")
            return

        # Iterate through files in the folder
        json_files_found = False
        for json_file in os.listdir(json_folder):
            if json_file.endswith(".json"):
                json_files_found = True
                full_path = os.path.join(json_folder, json_file)

                breakpoint()

                try:
                    # Load JSON to DataFrame
                    df = pd.read_json(full_path)

                    # Check if ClientID column is exists abd handle it
                    # if 'ClientID' in df.columns:
                    #     df['ClientID'] = df['ClientID'].astype(str)
                    # else:
                    #     print(f"Warning: 'ClientID' column not found in {json_file}. Adding defailt value.")
                    #     df['ClientID'] = 'BIGOLESHOECOMPANY_2013'

                    # Ensure EtaniClientId is exists
                    # if 'EtaniClientId' not in df.columns:
                    #     df['EtaniClientID'] = 'BIGOLESHOECOMPAY_CLIENT2013'

                    # Apply your data type conversion function
                    converted_df = ConvertDataTypes(df)

                    # Print report summary
                    print(f"Processed {json_file} - {len(converted_df)} rows")
                    print(converted_df.head(), "\n")

                    # Save to output folder
                    output_file = os.path.join(output_folder,f"converted_{json_file.replace('.json', '.csv')}")
                    converted_df.to_csv(output_file, index=False)
                    print(f"Saved: {output_file}\n")
                
                except Exception as e:
                    print(f"Error: {e}")
                    traceback.print_exc()
        
        if not json_files_found:
            print("No JSON files found in the specified folder.")

# Run the function
if __name__ == "__main__":
    tester = TestDataTypes()
    tester.test_convert_datatypes()                 


# For manual process
# Add current directory to the Python path before importing
# sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
# from utils import ConvertDataTypes

# json_folder = "json"
# json_file = "C:\Users\rhtupas\etani\etani_etl\etani-etl-python-docker\json\c2013_7035_qbo__Account_response.json" # <-- update this
# full_path = os.path.join(json_folder, json_file)

# try:
#     try:
#         # Attempt to read the JSON directly into a DataFrame
#         df = pd.read_json(full_path)
#     except ValueError as ve:
#         # If reading directly fails, use json_normalize
#         print(f" read_json failed. Trying json_normalize: {ve}")
#         with open(full_path, 'r') as f:
#             data = json.load(f)

#         # Check if the loaded data is a dictionary and has a list to normalize
#         if isinstance(data, dict):
#             # Look for a key that contains a list of items to normalize
#             for key, value in data.items():
#                 if isinstance(value, list):
#                     print(f"Found a list in the key: {key}. Normalizing...")
#                     df = pd.json_normalize(value)
#                     break
#             else:
#                 raise Exception("No list found in the JSON to normalize.")

#         elif isinstance(data, list):
#             # If the data itself is a list, normalize it directly
#             df = pd.json_normalize(data)
#         else:
#             raise Exception("Unsupported JSON structure. Could not normalize data.")

#     # Safely convert JSON date strings of the format /Date(...)+...
#     for col in df.columns:
#         try:
#             df[col] = df[col].apply(lambda x: str(x) if x is not None else '')
#             if df[col].str.contains(r"/Date\\(", na=False).any():
#                 df[col] = df[col].apply(
#                     lambda x: pd.to_datetime(
#                         int(re.search(r"\\((\\d+)\\+", x).group(1)) / 1000,
#                         unit='s', errors='coerce'
#                     ) if re.search(r"\\((\\d+)\\+", x) else pd.NaT
#                 )
#         except Exception as e:
#             print(f"Skipping column '{col}' from date conversion: {e}")

#     # Apply the ConvertDataTypes function to the DataFrame
#     converted_df = ConvertDataTypes(df)

#     # Output the number of rows processed and a preview
#     print(f"Successfully processed {json_file} — {len(converted_df)} rows")
#     print(converted_df.head(), "\n")

#     # Save the converted DataFrame to the output folder
#     output_folder = "output"
#     if not os.path.exists(output_folder):
#         os.makedirs(output_folder)

#     output_file = os.path.join(output_folder, f"converted_{json_file.replace('.json', '.csv')}")
#     converted_df.to_csv(output_file, index=False)
#     print(f"Saved to: {output_file}")

# except Exception as e:
#     print(f"Error processing {json_file}: {e}")
#     traceback.print_exc()