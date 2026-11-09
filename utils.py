import pandas as pd
import re, math, json
from datetime import datetime, timezone
from decimal import InvalidOperation
import os
import numpy as np

EtaniClientID = os.getenv('EtaniClientID')
EtaniOrganisationID = os.getenv('EtaniOrganisationID')


# EtaniClientID = os.getenv('EtaniClientID')
# EtaniOrganisationID = os.getenv('EtaniOrganisationID')
# XeroTenantID = os.getenv('XeroTenantID')

def identify_type(value):
    if isinstance(value, bool):
        return "Boolean"
    elif isinstance(value, float):
        return "Float"
    elif isinstance(value, int):  # Ensure integers aren't mistaken for floats
        return "Integer"
    elif isinstance(value, str):
        return "String"
    elif isinstance(value, datetime):
        return "Datetime"
    else:
        return "Unknown Type"


# def get_value(obj, key, default=None):
#     """Retrieves a value from the dictionary, applying type validation."""
#     try:
#         if obj is None:
#             return default

#         # Try dictionary access first (most common case)
#         try:
#             if hasattr(obj, 'get'):
#                 value = obj.get(key, default)
#             else:
#                 # Handle strings that might be Python dict or JSON
#                 if isinstance(obj, str) and obj.strip().startswith('{'):
#                     try:
#                         # First try JSON parsing (double quotes)
#                         import json
#                         parsed = json.loads(obj)
#                     except:
#                         try:
#                             # If JSON fails, try Python dict parsing (single quotes)
#                             import ast
#                             parsed = ast.literal_eval(obj)
#                         except:
#                             return default

#                     if isinstance(parsed, dict):
#                         value = parsed.get(key, default)
#                     else:
#                         return default
#                 else:
#                     return default
#         except:
#             return default

#         # Handle NaN/None cases explicitly
#         if pd.isna(value):
#             return default

#         # For numpy arrays specifically (to avoid truth value ambiguity)
#         if hasattr(value, '__array__') and not isinstance(value, (int, float, str, bool)):
#             return value.tolist()

#         data_type = identify_type(value)
#         if data_type == "Boolean":
#             return bool(value)
#         elif data_type == "Float":
#             return validate_float(value)
#         elif data_type == "Integer":
#             return validate_integer(value)
#         elif data_type == "Datetime":
#             return validate_datetime(value)
#         else:
#             # Attempt to parse as datetime, fallback to string
#             parsed_date = validate_datetime(value)
#             return parsed_date if parsed_date is not None else str(value)
#     except Exception as e:
#         print(f"Exception in get_value for key '{key}': {str(e)}")
#         return default

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
        # print(f"error converting datetime: {ex}")
        return None  # Return NULL equivalent for invalid values
    except:
        return None


def validate_float(value):
    try:
        # Convert to Decimal, ensuring valid numeric format
        return float(value)
    except (TypeError, ValueError, InvalidOperation):
        # Default to None if value is missing or invalid
        return 0


def validate_integer(value):
    try:
        # Convert to Decimal, ensuring valid numeric format
        return int(value)
    except (TypeError, ValueError, InvalidOperation):
        # Default to None if value is missing or invalid
        return 0


def get_value(obj, key, default=''):
    return str(obj.get(key, default) or default) if not pd.isna(obj.get(key)) else default


def get_nested_value(data, keys, default=''):
    """Safely get nested values from a dictionary."""
    if not isinstance(data, dict):
        return default
    for key in keys:
        data = data.get(key, {})
        if not isinstance(data, dict):
            return default
    return data


# def get_nested_value(data, keys, default=''):
#     """Safely get nested values from a dictionary."""
#     if not isinstance(data, dict):
#         return default
#     for key in keys:
#         data = data.get(key, {})
#         if not isinstance(data, dict):
#             return default
#     return data

# def ConvertDataTypes(df):

#     print("Converting Data Types to Match Stage Table")

#     for col in df.columns:
#         #print(df[col])
#         if df[col].dtype == bool:
#             df[col] = df[col].astype(int)
#         elif df[col].dtype == int:
#             df[col] = df[col].astype(int)
#         elif df[col].dtype == float:  # Handle float values
#             df[col] = df[col].astype(float)
#         elif df[col].astype(str).str.contains('/Date\\(', na=False).any():  # Check for JSON date string format
#             df[col] = df[col].apply(lambda x: pd.to_datetime(int(re.search(r'\((\d+)\+', str(x)).group(1)) / 1000, unit='s', errors='coerce')
#             if re.search(r'\((\d+)\+', str(x)) else pd.NaT) # Convert epoch to datetime
#         elif df[col].dtype == object:
#             # Check if column contains ISO 8601 date strings
#             if df[col].str.match(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,3})?$', na=False).any():
#                 # Remove milliseconds (decimal part) before conversion
#                 df[col] = df[col].str.replace(r'\.\d{1,3}$', '', regex=True)  # Remove decimal and milliseconds
#                 df[col] = pd.to_datetime(df[col], errors='coerce')  # 'coerce' will convert invalid dates to NaT
#                 df[col] = df[col].replace({pd.NaT: None})  # Replace NaT with None for SQL NULL
#             # Check if column contains JSON array
#             elif df[col].apply(lambda x: isinstance(x, list)).any():
#                 # Convert JSON array to string
#                 df[col] = df[col].apply(lambda x: str(x))
#             else:
#                 # Convert object columns to strings, replacing NaN values with None
#                 df[col] = df[col].astype(str).where(pd.notnull(df[col]), None)

#     df = df.assign(ClientID = EtaniClientID, OrganisationID = int(EtaniOrganisationID)
#          if EtaniOrganisationID is not None else 0
#          ) # Insert ClientID and OrganisationID

#     print("Done Converting Data")

#     return df


def is_iso_datetime(s):
    pattern = r'^\d{4}-\d{2}-\d{2}([ T]\d{2}:\d{2}(:\d{2})?(\.\d+)?(Z|[+\-]\d{2}:\d{2})?)?$'
    return bool(re.match(pattern, s))


def is_json(s):
    try:
        json.loads(s)
        return True
    except (ValueError, TypeError):
        return False


def ConvertDataTypes(df, schema_fields=None):
    # First replace all nan values and infinity values with None (which will become NULL in MySQL)
    df = df.replace({np.nan: None, pd.NaT: None, np.inf: None, -np.inf: None, math.inf: None, -math.inf: None})

    for column in df.columns:
        series = df[column]

        if series.isna().all():
            continue

        non_null = series.dropna()

        if len(non_null) == 0:
            continue

        # Check for integration date format like /Date(1516756671000)/
        if any(isinstance(x, str) and re.match(r"/Date\(\d+(?:[+-]\d{4})?\)/", x) for x in non_null):
            print(f"  Converting integration date format in column: {column}")
            try:
                df[column] = series.apply(lambda x: validate_datetime(x) if pd.notna(x) else None)
                continue
            except Exception as e:
                print(f"  Warning: Could not convert {column} dates: {e}")
                pass

        # Check for ISO datetime strings
        if all(isinstance(x, str) and is_iso_datetime(x) for x in non_null):
            try:
                # Try multiple datetime parsing approaches
                def parse_flexible_datetime(dt_str):
                    if pd.isna(dt_str) or dt_str is None:
                        return None

                    # List of datetime formats to try (ordered by most common first)
                    formats = [
                        # ISO 8601 formats with T separator
                        '%Y-%m-%dT%H:%M:%S.%f',  # 2016-08-18T09:32:11.923456
                        '%Y-%m-%dT%H:%M:%S',  # 2016-08-18T09:32:11
                        '%Y-%m-%dT%H:%M',  # 2016-08-18T09:32

                        # ISO 8601 with timezone
                        '%Y-%m-%dT%H:%M:%S.%fZ',  # 2016-08-18T09:32:11.923Z
                        '%Y-%m-%dT%H:%M:%SZ',  # 2016-08-18T09:32:11Z
                        '%Y-%m-%dT%H:%M:%S+00:00',  # 2016-08-18T09:32:11+00:00
                        '%Y-%m-%dT%H:%M:%S-00:00',  # 2016-08-18T09:32:11-00:00

                        # Standard space-separated formats
                        '%Y-%m-%d %H:%M:%S.%f',  # 2016-08-18 09:32:11.923456
                        '%Y-%m-%d %H:%M:%S',  # 2016-08-18 09:32:11
                        '%Y-%m-%d %H:%M',  # 2016-08-18 09:32

                        # Date only formats
                        '%Y-%m-%d',  # 2016-08-18
                        '%Y/%m/%d',  # 2016/08/18
                        '%m/%d/%Y',  # 08/18/2016
                        '%d/%m/%Y',  # 18/08/2016
                        '%d-%m-%Y',  # 18-08-2016

                        # Date with time (US format)
                        '%m/%d/%Y %H:%M:%S',  # 08/18/2016 09:32:11
                        '%d/%m/%Y %H:%M:%S',  # 18/08/2016 09:32:11
                        '%d-%m-%Y %H:%M:%S',  # 18-08-2016 09:32:11

                        # Alternative separators
                        '%Y.%m.%d',  # 2016.08.18
                        '%Y.%m.%d %H:%M:%S',  # 2016.08.18 09:32:11

                        # Compact formats
                        '%Y%m%d',  # 20160818
                        '%Y%m%d%H%M%S',  # 20160818093211

                        # RFC formats
                        '%a, %d %b %Y %H:%M:%S',  # Fri, 18 Aug 2016 09:32:11
                        '%d %b %Y %H:%M:%S',  # 18 Aug 2016 09:32:11
                        '%b %d, %Y %H:%M:%S',  # Aug 18, 2016 09:32:11

                        # Excel/CSV common formats
                        '%m-%d-%Y %H:%M:%S',  # 08-18-2016 09:32:11
                        '%m-%d-%Y',  # 08-18-2016
                    ]

                    for fmt in formats:
                        try:
                            from datetime import datetime
                            parsed = datetime.strptime(str(dt_str).strip(), fmt)
                            return parsed.strftime('%Y-%m-%d %H:%M:%S')
                        except ValueError:
                            continue

                df[column] = series.apply(parse_flexible_datetime)
                continue
            except Exception:
                pass

        # Check for JSON strings
        if all(isinstance(x, str) and is_json(x) for x in non_null):
            try:
                df[column] = series.apply(lambda x: json.dumps(json.loads(x)) if pd.notna(x) else None)
                continue
            except Exception:
                pass

        # Check for boolean values
        bool_set = {'true', 'false', '1', '0', 'yes', 'no'}
        if all(str(x).strip().lower() in bool_set for x in non_null):
            df[column] = series.apply(
                lambda x: 1 if str(x).strip().lower() in ['true', '1', 'yes'] else 0 if pd.notna(x) else 0)
            continue

        # Try numeric coercion only if schema indicates this field should be numeric
        if schema_fields and column in schema_fields:
            field_info = schema_fields[column]
            field_type = field_info.get('type', '').upper()

            # Only attempt numeric conversion for explicitly numeric types
            if field_type in ['DECIMAL', 'INT', 'BIGINT', 'FLOAT', 'DOUBLE', 'NUMERIC', 'INTEGER']:
                try:
                    numeric_series = pd.to_numeric(series, errors='coerce')
                    if not numeric_series.isna().all():  # Only convert if we have some valid numbers
                        # For numeric columns, replace NaN with None instead of 0.0 to avoid inf issues
                        df[column] = numeric_series.replace({np.nan: None})
                        continue
                except Exception:
                    pass
        # For string columns, ensure proper handling of None values
        df[column] = series.astype(str).replace({'nan': None, 'None': None, '': None})

    return df.replace({np.nan: None, pd.NaT: None})


def get_acronym(column_name):
    words = re.findall(r'[A-Z]?[a-z]+|[A-Z]+(?=[A-Z]?[a-z])',
                       column_name)  # Handles camelCase, PascalCase, and snake_case
    return ''.join(word[0].upper() for word in words)


def format_timestamp(dt: datetime, fmt: str = None) -> str:
    """
    Format datetime according to schema format for API requests

    Args:
        dt: Datetime object to format
        fmt: Schema format string (e.g., 'YYYY-MM-DDTHH:mm:ss+00:00')

    Returns:
        Formatted timestamp string
    """
    if fmt:
        # Convert schema format to Python strftime format
        python_format = fmt.replace('YYYY', '%Y').replace('MM', '%m').replace('DD', '%d').replace('HH', '%H').replace(
            'mm', '%M').replace('ss', '%S')
        # Handle timezone format (+00:00)
        if '+00:00' in python_format:
            python_format = python_format.replace('+00:00', '%z')
            # For timezone format, ensure datetime has timezone info
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
            return dt.strftime(python_format)
        else:
            return dt.strftime(python_format)
    else:
        # Default ISO format
        return dt.strftime('%Y-%m-%dT%H:%M:%S')