import math
import os
import json

import numpy as np
import requests
import pandas as pd
from typing import Dict, List, Any
from datetime import datetime, timezone
import time
import logging

# Add parent directory to path
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from dynamic_integrations.generator.utils import Utils
from utils import ConvertDataTypes
from sql_helper import LoadToEvaStageTable, ExecuteEvaSP, get_firm_id, update_container_logs


class DataTransformer:
    """
    Data transformation component for Dynamic Integration
    Handles JSON parsing, field mapping, data filtering, and audit column addition
    """
    
    def __init__(self, integration_instance):
        """Initialize with reference to the main integration instance"""
        self.integration = integration_instance
        self.logger = integration_instance.logger
        self.config = integration_instance.config
        self.error_list = integration_instance.error_list

    def _parse_json(self, response_data: Dict, endpoint: str) -> Dict[str, pd.DataFrame]:
        """Parse JSON response using schema configuration - returns dict of all endpoints"""
        try:
            # Get transform config from schema
            schema_config = self.integration._extract_schema_config()
            transform_config = schema_config.get('transform_config', {})
            response_format = transform_config.get('response_format', 'standard')

            # Apply response format specific parsing
            records = self._extract_records_by_format(response_data, endpoint, response_format)

            # Apply schema-based field mapping
            if records:
                records = self._apply_schema_field_mapping(records, endpoint)

            # Process nested extractions if configured - collect all nested data
            all_nested_data = self._process_nested_extractions(response_data, endpoint)

            # Build result dict with main endpoint data
            result = {
                endpoint: pd.DataFrame(records) if records else pd.DataFrame()
            }
            
            # Add all nested endpoint data
            if all_nested_data:
                result.update(all_nested_data)

            # Final normalization step for all DataFrames to ensure proper JSON format
            for ep_name, df in result.items():
                if not df.empty:
                    result[ep_name] = self._normalize_all_complex_fields(df)

            return result

        except Exception as e:
            self.logger.error(f"JSON parsing failed for {endpoint}: {str(e)}")
            return {endpoint: pd.DataFrame()}

    def _normalize_all_complex_fields(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Normalize all complex fields in a DataFrame to ensure proper JSON format.
        Simply converts Python lists and dicts to proper JSON strings.
        Also handles string representations of lists like "['item1', 'item2']".
        """
        import json
        import ast

        if df.empty:
            return df

        df = df.copy()

        # Process each column in the DataFrame
        for column in df.columns:
            try:
                # Skip entirely null/empty columns
                if df[column].isna().all():
                    continue

                # Check sample values
                sample = df[column].dropna().head(1)
                if sample.empty:
                    continue

                first_value = sample.iloc[0]

                # For lists or dicts, convert to JSON
                if isinstance(first_value, (list, dict)):
                    self.logger.info(f"Converting complex objects in column '{column}' to JSON")
                    df[column] = df[column].apply(
                        lambda x: json.dumps(x) if isinstance(x, (list, dict)) and x is not None else x
                    )
                # For string representations of lists like "['item1', 'item2']"
                elif isinstance(first_value, str) and first_value.startswith("['") and first_value.endswith("']"):
                    self.logger.info(f"Converting string list representations in column '{column}' to JSON")
                    df[column] = df[column].apply(
                        lambda x: json.dumps(ast.literal_eval(x)) if isinstance(x, str) and
                                                                     x.startswith("['") and
                                                                     x.endswith("']") and
                                                                     x is not None else x
                    )
            except Exception as e:
                self.logger.warning(f"Error normalizing field '{column}': {str(e)}")
                continue

        return df

    def _extract_records_by_format(self, response_data: Dict, endpoint: str, response_format: str) -> List[Dict]:
        """Extract records based on response format with schema-first approach"""
        records = response_data

        # PRIORITY 1: Check schema root_data_field configuration
        try:
            schema = self.integration._load_schema()
            if schema and 'endpoints' in schema:
                for ep in schema['endpoints']:
                    if ep.get('name') == endpoint:
                        response_structure = ep.get('response_structure', {})
                        root_data_field = response_structure.get('root_data_field')
                        
                        if root_data_field and isinstance(records, dict):
                            extracted_records = records.get(root_data_field) if root_data_field in records else self._get_nested_field_value(records, root_data_field)
                            if extracted_records is None:
                                continue
                            self.logger.debug(f"Extracted data from schema root_data_field '{root_data_field}' for {endpoint}")
                            records = extracted_records
                            break
                        elif root_data_field:
                            self.logger.debug(f"Schema root_data_field '{root_data_field}' not found in response for {endpoint}")
                        break
        except Exception as e:
            self.logger.debug(f"Could not check schema root_data_field for {endpoint}: {e}")

        # PRIORITY 2: Legacy format detection (original logic)
        if response_format == 'qbo' or 'QueryResponse' in records:
            # QuickBooks Online format
            qr = records.get('QueryResponse', {})
            if endpoint in qr:
                records = qr[endpoint]
            else:
                # Find first array in QueryResponse
                for key, value in qr.items():
                    if isinstance(value, list):
                        records = value
                        break
                else:
                    records = []

        elif response_format == 'salesforce' and 'records' in records:
            # Salesforce format
            records = records['records']

        elif 'data' in records:
            # Standard 'data' field format
            records = records['data']

        elif endpoint.lower() in records:
            # Endpoint name as key format
            records = records[endpoint.lower()]

        elif isinstance(records, list):
            # Response is already a list
            pass

        else:
            # Single object response
            records = [records] if isinstance(records, dict) else []

        return records if isinstance(records, list) else []

    def _add_audit_columns(self, data: pd.DataFrame, endpoint: str = None) -> pd.DataFrame:
        """Add standard audit columns to DataFrame"""
        if data.empty:
            return data

        data = data.copy()

        # Clean infinity values that MySQL cannot handle
        data = self._clean_infinity_values(data)

        # Apply schema-based transformations
        data = self._apply_schema_transformations(data)

        # Handle field fallbacks based on integration configuration
        data = self._handle_field_fallbacks(data, endpoint)

        # Fix JSON serialization for complex fields (fallback)
        data = self._fix_json_serialization(data)

        # Add ClientID if not already present (check for various case variations)
        client_id_columns = [col for col in data.columns if col.lower() in ['clientid', 'client_id']]
        if not client_id_columns:
            data['ClientID'] = self.integration.clientID
        elif 'ClientID' not in data.columns:
            # Use existing column name but ensure the value is set
            existing_col = client_id_columns[0]
            data[existing_col] = self.integration.clientID

        # Add OrganisationID if not already present (check for various case variations)
        org_id_columns = [col for col in data.columns if
                          col.lower() in ['organisationid', 'organizationid']]

        # Check if schema config has usingEtaniLinkOrganisationID flag set to true
        schema = self.integration._load_schema()
        organisation_id_value = self.integration.organisationID

        if schema and schema.get('usingEtaniLinkOrganisationID', False) and hasattr(self.integration, 'etani_link_organisation_id'):
            # Use EtaniLinkOrganisationID for OrganisationID column if available
            organisation_id_value = self.integration.etani_link_organisation_id
            print(f"📊 Using EtaniLinkOrganisationID for data in transformation: {organisation_id_value}")

        if not org_id_columns:
            data['OrganisationID'] = organisation_id_value
        elif 'OrganisationID' not in data.columns:
            # Use existing column name but ensure the value is set
            existing_col = org_id_columns[0]
            data[existing_col] = organisation_id_value

        # data['LoadDate'] = datetime.now()
        # data['LoadTime'] = datetime.now().strftime('%H:%M:%S')

        # Datetime cleaning now handled by SQL procedures with CAST statements

        # Apply data type conversions with schema information
        try:
            # Get schema field information for the current endpoint
            schema_fields = self._get_schema_fields_for_endpoint(endpoint)
            data = ConvertDataTypes(data, schema_fields)
        except Exception as e:
            self.logger.warning(f"ConvertDataTypes failed: {str(e)}")

        return data

    def _get_schema_fields_for_endpoint(self, endpoint: str = None) -> dict:
        """Get schema field information for the current endpoint to guide type conversion"""
        try:
            if not endpoint:
                return None

            # Get entity schema for this endpoint
            entity_schema = self._get_entity_schema(endpoint)
            if not entity_schema or 'fields' not in entity_schema:
                return None

            # Build field info dict with types for ConvertDataTypes
            schema_fields = {}
            for field in entity_schema['fields']:
                field_name = field.get('db_column') or field.get('api_name')
                field_type = field.get('data_type', '')

                if field_name and field_type:
                    schema_fields[field_name] = {
                        'type': field_type,
                        'api_name': field.get('api_name', ''),
                        'db_column': field.get('db_column', ''),
                    }

            self.logger.debug(f"Loaded {len(schema_fields)} field types for {endpoint}")
            return schema_fields

        except Exception as e:
            self.logger.warning(f"Failed to get schema fields for {endpoint}: {str(e)}")
            return None

    def _fix_json_serialization(self, data: pd.DataFrame) -> pd.DataFrame:
        """Fix JSON serialization for complex fields in DataFrame (final fallback)"""
        if data.empty:
            return data

        data = data.copy()

        # Check each column for complex objects that need JSON serialization
        for column in data.columns:
            try:
                # Check if column contains complex objects
                sample_values = data[column].dropna()
                if not sample_values.empty:
                    first_value = sample_values.iloc[0]

                    # If it's a complex object (list or dict), handle appropriately
                    if isinstance(first_value, (list, dict)):
                        self.logger.debug(f"Handling complex data in column '{column}'")

                        if isinstance(first_value, list):
                            # Always keep lists as lists (no serialization)
                            self.logger.debug(f"Preserving list structure for column '{column}'")
                        else:
                            # Only serialize dictionaries to JSON
                            self.logger.debug(f"Serializing dict objects for column '{column}'")
                            data[column] = data[column].apply(
                                lambda x: json.dumps(x, ensure_ascii=False) if isinstance(x, dict) and x else x
                            )
                            self.logger.debug(f"✅ Fixed JSON serialization for column '{column}'")

            except Exception as e:
                self.logger.debug(f"Error handling complex data in column '{column}': {str(e)}")
                continue

        return data

    def _apply_schema_transformations(self, data: pd.DataFrame) -> pd.DataFrame:
        """Apply data transformations based on schema configuration"""
        if data.empty:
            return data

        data = data.copy()

        # Get transformation config from schema
        schema_config = self.integration._extract_schema_config()
        transform_config = schema_config.get('transform_config', {})
        field_transformations = transform_config.get('field_transformations', {})

        # Apply field-specific transformations defined in schema
        for field_name, transformation in field_transformations.items():
            if field_name in data.columns:
                data = self._apply_field_transformation(data, field_name, transformation)

        return data

    def _apply_field_transformation(self, data: pd.DataFrame, field_name: str,
                                    transformation: Dict[str, Any]) -> pd.DataFrame:
        """Apply transformation to a specific field based on schema configuration"""
        if field_name not in data.columns:
            return data

        try:
            transform_type = transformation.get('type', 'none')

            if transform_type == 'flatten_object':
                data = self._flatten_object_field(data, field_name, transformation)
            elif transform_type == 'extract_value':
                data = self._extract_value_from_field(data, field_name, transformation)
            elif transform_type == 'format_string':
                data = self._format_string_field(data, field_name, transformation)
            elif transform_type == 'json_string':
                data = self._convert_to_json_string(data, field_name)
            elif transform_type == 'none':
                pass  # No transformation needed
            else:
                self.logger.warning(f"Unknown transformation type '{transform_type}' for field '{field_name}'")

        except Exception as e:
            self.logger.warning(f"Failed to transform field '{field_name}': {str(e)}")

        return data

    def _flatten_object_field(self, data: pd.DataFrame, field_name: str, transformation: Dict[str, Any]) -> pd.DataFrame:
        """Flatten object field into separate columns based on schema configuration"""
        try:
            # Get flattening configuration from schema
            flatten_config = transformation.get('flatten_config', {})
            prefix = flatten_config.get('prefix', field_name)
            properties = flatten_config.get('properties', [])
            remove_original = flatten_config.get('remove_original', True)

            # Process each row
            for idx, row in data.iterrows():
                field_value = row[field_name]
                if field_value and isinstance(field_value, (str, dict)):
                    # Parse string as dict if needed
                    if isinstance(field_value, str):
                        try:
                            import ast
                            field_dict = ast.literal_eval(field_value)
                        except:
                            try:
                                import json
                                field_dict = json.loads(field_value)
                            except:
                                continue
                    else:
                        field_dict = field_value

                    # Extract specified properties
                    if isinstance(field_dict, dict):
                        for prop in properties:
                            col_name = f'{prefix}_{prop}' if prefix else prop
                            if col_name not in data.columns:
                                data[col_name] = None
                            data.at[idx, col_name] = field_dict.get(prop)

            # Remove original field if specified
            if remove_original:
                data = data.drop(columns=[field_name])

        except Exception as e:
            self.logger.warning(f"Failed to flatten object field '{field_name}': {str(e)}")

        return data

    def _extract_value_from_field(self, data: pd.DataFrame, field_name: str,
                                  transformation: Dict[str, Any]) -> pd.DataFrame:
        """Extract specific value from nested field based on schema configuration"""
        try:
            extract_config = transformation.get('extract_config', {})
            extract_path = extract_config.get('path', [])  # e.g., ['value'] or ['Address']
            fallback_path = extract_config.get('fallback_path', [])
            format_template = extract_config.get('format', None)  # e.g., "{value} - {name}"

            for idx, row in data.iterrows():
                field_value = row[field_name]
                if field_value and isinstance(field_value, (str, dict)):
                    # Parse string as dict if needed
                    if isinstance(field_value, str):
                        try:
                            import ast
                            field_dict = ast.literal_eval(field_value)
                        except:
                            try:
                                import json
                                field_dict = json.loads(field_value)
                            except:
                                continue
                    else:
                        field_dict = field_value

                    if isinstance(field_dict, dict):
                        # Extract value using path
                        extracted_value = self._extract_nested_value(field_dict, extract_path)

                        # Try fallback path if main path failed
                        if not extracted_value and fallback_path:
                            extracted_value = self._extract_nested_value(field_dict, fallback_path)

                        # Apply format template if specified
                        if format_template and isinstance(field_dict, dict):
                            try:
                                extracted_value = format_template.format(**field_dict)
                            except:
                                pass  # Use extracted value as is

                        data.at[idx, field_name] = extracted_value or str(field_dict)

        except Exception as e:
            self.logger.warning(f"Failed to extract value from field '{field_name}': {str(e)}")

        return data

    def _format_string_field(self, data: pd.DataFrame, field_name: str, transformation: Dict[str, Any]) -> pd.DataFrame:
        """Format field value as string based on schema configuration"""
        try:
            format_config = transformation.get('format_config', {})
            template = format_config.get('template', '{value}')

            for idx, row in data.iterrows():
                field_value = row[field_name]
                if field_value:
                    try:
                        if isinstance(field_value, dict):
                            formatted_value = template.format(**field_value)
                        else:
                            formatted_value = template.format(value=field_value)
                        data.at[idx, field_name] = formatted_value
                    except:
                        data.at[idx, field_name] = str(field_value)

        except Exception as e:
            self.logger.warning(f"Failed to format string field '{field_name}': {str(e)}")

        return data

    def _convert_to_json_string(self, data: pd.DataFrame, field_name: str) -> pd.DataFrame:
        """Convert field value to JSON string"""
        try:
            import json
            for idx, row in data.iterrows():
                field_value = row[field_name]
                if field_value:
                    if isinstance(field_value, dict):
                        # Only convert dictionaries to JSON strings
                        data.at[idx, field_name] = json.dumps(field_value)
                    elif isinstance(field_value, list):
                        # Keep lists as lists
                        pass

        except Exception as e:
            self.logger.warning(f"Failed to convert field '{field_name}' to JSON string: {str(e)}")

        return data

    def _extract_nested_value(self, data_dict: Dict, path: List[str]) -> Any:
        """Extract value from nested dictionary using path"""
        try:
            value = data_dict
            for key in path:
                if isinstance(value, dict) and key in value:
                    value = value[key]
                else:
                    return None
            return value
        except:
            return None

    def _apply_schema_field_mapping(self, records: List[Dict], endpoint: str) -> List[Dict]:
        """Apply field mapping based on schema definition"""
        try:
            # Load entity schema
            entity_schema = self._get_entity_schema(endpoint)
            if not entity_schema:
                return records

            # Get field mappings from schema
            field_mappings = self._build_field_mappings(entity_schema)
            if not field_mappings:
                return records

            # Apply mappings to each record
            mapped_records = []
            for record in records:
                mapped_record = self._map_single_record(record, field_mappings)
                mapped_records.append(mapped_record)

            return mapped_records

        except Exception as e:
            self.logger.warning(f"Failed to apply schema field mapping for {endpoint}: {str(e)}")
            return records

    def _get_entity_schema(self, endpoint: str) -> Dict:
        """Get entity-specific schema from main schema file"""
        try:
            # Load main schema file directly 
            main_schema = self.integration._load_schema()

            # Look for the endpoint in endpoints list
            endpoints = main_schema.get('endpoints', [])
            for ep in endpoints:
                if ep.get('name', '').lower() == endpoint.lower():
                    return ep

            self.logger.debug(f"Endpoint schema not found for {endpoint}")
            return {}

        except Exception as e:
            self.logger.warning(f"Failed to get entity schema for {endpoint}: {str(e)}")
            return {}

    def _build_field_mappings(self, entity_schema: Dict) -> Dict[str, str]:
        """Build field mappings from schema fields definition"""
        try:
            field_mappings = {}
            fields = entity_schema.get('fields', [])

            for field in fields:
                api_name = field.get('api_name', '')
                db_column = field.get('db_column', '').lower()  # Ensure lowercase
                field_type = field.get('type', '')

                if api_name and db_column:
                    # For split type fields, store additional metadata
                    if field_type == 'split':
                        field_mappings[api_name] = {
                            'db_column': db_column,
                            'type': 'split',
                            'field_info': field
                        }
                    else:
                        field_mappings[api_name] = db_column

            return field_mappings

        except Exception as e:
            self.logger.warning(f"Failed to build field mappings: {str(e)}")
            return {}

    def _extract_split_value(self, href_value: str, split_key: str) -> str:
        """
        Extract value from href path based on split key

        Example:
        href_value: "/api/v1.0/companies/0/jobs/23491/sections/1388/costCenters/233/schedules/2231"
        split_key: "jobs" -> returns "23491"
        split_key: "costCenters" -> returns "233"
        """
        try:
            if not href_value or not split_key:
                return None

            # Split the href by '/' to get path segments
            segments = [seg for seg in href_value.split('/') if seg]

            # Find the split_key segment and get the value after it
            for i, segment in enumerate(segments):
                if segment == split_key:
                    # Return the next segment if it exists
                    if i + 1 < len(segments):
                        return segments[i + 1]
                    break

            self.logger.debug(f"Split key '{split_key}' not found in href: {href_value}")
            return None

        except Exception as e:
            self.logger.warning(f"Failed to extract split value for key '{split_key}' from href '{href_value}': {e}")
            return None

    def _map_single_record(self, record: Dict, field_mappings: Dict[str, str]) -> Dict:
        """Map a single record using field mappings from schema"""
        if not isinstance(record, dict):
            return record

        mapped_record = {}

        # Process each field mapping
        for api_name, mapping_info in field_mappings.items():
            # Handle split type fields vs normal fields
            if isinstance(mapping_info, dict) and mapping_info.get('type') == 'split':
                # Process split type field
                db_column = mapping_info['db_column']
                field_info = mapping_info['field_info']

                # Extract source field and split key from api_name
                if '.' in api_name:
                    source_field, split_key = api_name.split('.', 1)

                    # Get the value from source field (e.g., _href)
                    source_value = self._get_nested_field_value(record, source_field)

                    if source_value:
                        # Extract split value using the split key
                        split_value = self._extract_split_value(source_value, split_key)
                        if split_value:
                            mapped_record[db_column] = split_value
                            self.logger.debug(f"Split field {api_name}: extracted '{split_value}' for {db_column}")
                        else:
                            self.logger.debug(f"Split field {api_name}: no value found for key '{split_key}' in '{source_value}'")
                    else:
                        self.logger.debug(f"Split field {api_name}: source field '{source_field}' not found")

            else:
                # Normal field processing
                db_column = mapping_info if isinstance(mapping_info, str) else mapping_info
                value = self._get_nested_field_value(record, api_name)

                if value is not None:
                    # Check if this field should be JSON serialized based on schema or data type
                    should_serialize = self._should_serialize_as_json(api_name, value, db_column)

                    # Debug logging for Invoices field
                    if api_name == 'Invoices':
                        self.logger.debug(
                            f"Processing Invoices field: should_serialize={should_serialize}, value_type={type(value)}")

                    if should_serialize:
                        if isinstance(value, (list, dict)):
                            if isinstance(value, list):
                                # Always keep list structure intact
                                mapped_record[db_column] = value
                                self.logger.debug(f"Preserved list structure for field '{api_name}'")
                            else:
                                # Serialize dictionaries to JSON
                                json_value = json.dumps(value, ensure_ascii=False) if value else None
                                mapped_record[db_column] = json_value

                                # Debug logging for Invoices field
                                if api_name == 'Invoices':
                                    self.logger.debug(
                                        f"Serialized Invoices to JSON: {json_value[:100] if json_value else 'None'}...")
                        else:
                            mapped_record[db_column] = value
                    else:
                        mapped_record[db_column] = value

        # Handle any remaining complex fields not in field mappings (fallback)
        for field_name, field_value in record.items():
            if field_name not in [mapping for mapping in field_mappings.keys()]:
                if isinstance(field_value, (list, dict)) and field_value:
                    if isinstance(field_value, list):
                        # Always keep list structure intact
                        mapped_record[field_name] = field_value
                        self.logger.debug(f"Preserved list structure for field '{field_name}' (fallback)")
                    else:
                        # Auto-serialize dict objects to JSON
                        mapped_record[field_name] = json.dumps(field_value, ensure_ascii=False)
                        self.logger.debug(f"Auto-serialized field '{field_name}' to JSON (fallback)")
                elif field_value is not None:
                    mapped_record[field_name] = field_value

        return mapped_record

    def _should_serialize_as_json(self, api_name: str, value: Any, db_column: str) -> bool:
        """Check if field should be JSON serialized based on schema configuration and data type"""
        try:
            # If value is complex object (list or dict), serialize to JSON
            if isinstance(value, (list, dict)):
                return True

            return False

        except Exception as e:
            self.logger.debug(f"Error checking JSON serialization for {api_name}: {str(e)}")
            # Default to JSON serialization for complex objects if unsure
            return isinstance(value, (list, dict))

    def _get_nested_field_value(self, record: Dict, api_name: str) -> Any:
        """Get value from nested field using dot notation (e.g., MetaData.CreateTime)"""
        try:
            if '.' not in api_name:
                # Simple field
                return record.get(api_name)

            # Nested field - traverse the path
            path_parts = api_name.split('.')
            current_value = record

            for part in path_parts:
                if isinstance(current_value, dict) and part in current_value:
                    current_value = current_value[part]
                else:
                    return None

            return current_value

        except Exception as e:
            self.logger.debug(f"Failed to get nested field value for {api_name}: {str(e)}")
            return None

    def _safe_get(self, obj: Any, key: str, default: Any = None) -> Any:
        """
        Safely get value from object with enhanced error handling and multiple fallbacks

        Args:
            obj: Source object (dict, DataFrame row, or object with attributes)
            key: Key/attribute name to retrieve
            default: Default value if key not found

        Returns:
            Retrieved value or default
        """
        try:
            if obj is None:
                return default

            # Handle dict objects
            if isinstance(obj, dict):
                return obj.get(key, default)

            # Handle pandas Series (DataFrame rows)
            elif hasattr(obj, 'get') and callable(getattr(obj, 'get')):
                return obj.get(key, default)

            # Handle objects with attributes
            elif hasattr(obj, key):
                value = getattr(obj, key)
                return value if value is not None else default

            # Handle index-based access (lists, tuples)
            elif isinstance(obj, (list, tuple)) and isinstance(key, int):
                if 0 <= key < len(obj):
                    return obj[key]
                return default

            else:
                return default

        except (AttributeError, KeyError, IndexError, TypeError):
            return default
        except Exception as e:
            self.logger.debug(f"Unexpected error in _safe_get for key '{key}': {str(e)}")
            return default

    def _handle_field_fallbacks(self, data: pd.DataFrame, endpoint: str = None) -> pd.DataFrame:
        """
        Generic field fallback system based on integration configuration

        Reads field_fallbacks from config and applies appropriate fallback strategies
        for missing or empty fields that are required by database schema.
        """
        if data.empty:
            return data

        data = data.copy()

        try:
            # Load additional fields configuration from Utils
            additional_fields = Utils.get_additional_fields_config(self.integration.integration_name)

            if not additional_fields:
                return data

            for field_name, field_config in additional_fields.items():
                # Check if this endpoint needs this field
                needs_field = self._endpoint_needs_field(endpoint, field_name)

                if needs_field:
                    # Apply additional field logic
                    data = self._apply_additional_field_logic(data, field_name, field_config, endpoint)
                else:
                    # Remove field if endpoint doesn't need it
                    if field_name in data.columns:
                        data = data.drop(columns=[field_name])
                        self.logger.debug(f"✅ Removed {field_name} column for {endpoint} (not needed)")

            return data

        except Exception as e:
            self.logger.warning(f"Error in field fallback processing: {str(e)}")
            return data

    def _filter_dataframe_columns(self, df: pd.DataFrame, endpoint: str, stage_table: str = None) -> pd.DataFrame:
        """
        Filter DataFrame to only include columns that exist in target stage table

        Prevents database insertion errors by removing validation fields and
        non-existent columns before loading to stage table.

        Args:
            df: Source DataFrame
            endpoint: API endpoint name
            stage_table: Target stage table name (optional, will auto-generate if not provided)

        Returns:
            pd.DataFrame: Filtered DataFrame with only valid columns
        """
        if df.empty:
            return df

        try:
            # Generate stage table name if not provided
            if not stage_table:
                stage_table = f"{self.integration.table_prefix_eva}{endpoint.lower()}stage"

            # Get actual stage table columns using schema or database query
            valid_columns = self._get_stage_table_columns(stage_table, endpoint)

            # Define columns to always exclude (validation/system fields)
            excluded_columns = {
                'HasValidationErrors', 'ValidationErrors', 'Warnings',
                'domain', 'sparse', 'DirtyState'
            }

            # Apply exclusions from config
            config_excluded = self._get_excluded_fields_from_config()
            excluded_columns.update(config_excluded)

            # Get DataFrame columns
            df_columns = set(df.columns)

            # Create mapping from API field names to DB column names
            df_to_db_mapping = self._create_api_to_db_column_mapping(df_columns, valid_columns, endpoint)
            
            # Filter: keep only columns that have valid DB mappings and aren't excluded
            if valid_columns:
                # Map DataFrame columns to DB columns and check if they exist
                valid_df_columns = set()
                for df_col in df_columns:
                    db_col = df_to_db_mapping.get(df_col, df_col)
                    if db_col in valid_columns:
                        valid_df_columns.add(df_col)
                
                final_columns = valid_df_columns - excluded_columns
                self.logger.info(f"Mapped {len(valid_df_columns)} DataFrame columns to valid DB columns for {endpoint}")
            else:
                # If no stage table info, just remove excluded columns
                final_columns = df_columns - excluded_columns
                self.logger.warning(f"No stage table column info for {endpoint}, keeping all columns except exclusions")

            # Return filtered DataFrame with renamed columns
            if final_columns:
                filtered_df = df[list(final_columns)].copy()
                
                # Rename columns from API names to DB column names for database insertion
                if valid_columns:
                    rename_mapping = {}
                    for df_col in final_columns:
                        db_col = df_to_db_mapping.get(df_col, df_col)
                        if db_col != df_col:
                            rename_mapping[df_col] = db_col
                    
                    if rename_mapping:
                        filtered_df = filtered_df.rename(columns=rename_mapping)

                self.logger.info(f"✅ Final DataFrame for {endpoint}: {len(filtered_df.columns)} columns")
                return filtered_df
            else:
                self.logger.warning(f"⚠️  No valid columns found for {endpoint}")
                return pd.DataFrame()

        except Exception as e:
            self.logger.warning(f"Column filtering failed for {endpoint}: {str(e)}, returning original DataFrame")
            return df

    def _get_stage_table_columns(self, stage_table: str, endpoint: str) -> set:
        """
        Get actual column names from stage table - ALWAYS query database first

        Priority: Database query > Entity schema as fallback
        """
        try:
            # PRIMARY: Query database first for accurate column list
            try:
                from sql_helper import eva_engine
                from sqlalchemy import text

                query = text("""
                             SELECT COLUMN_NAME
                             FROM INFORMATION_SCHEMA.COLUMNS
                             WHERE TABLE_SCHEMA = DATABASE()
                               AND TABLE_NAME = :table_name
                             ORDER BY COLUMN_NAME
                             """)

                with eva_engine.connect() as conn:
                    result = conn.execute(query, {'table_name': stage_table})
                    db_columns = {row[0] for row in result}
                    if db_columns:
                        self.logger.debug(f"✅ Got {len(db_columns)} columns from DATABASE for {stage_table}")
                        self.logger.debug(f"DB columns: {sorted(list(db_columns))}")
                        return db_columns
                    else:
                        self.logger.warning(f"⚠️ Table {stage_table} not found in database")

            except Exception as e:
                self.logger.warning(f"Database query failed for {stage_table}: {str(e)}")

            # FALLBACK: Try entity schema if database query fails
            entity_schema = self._get_entity_schema(endpoint)
            if entity_schema and 'fields' in entity_schema:
                schema_columns = set()
                for field in entity_schema['fields']:
                    db_column = field.get('db_column', field.get('api_name', ''))
                    if db_column:
                        schema_columns.add(db_column.lower())  # Ensure lowercase

                # Add standard audit columns
                schema_columns.update(['ClientID', 'OrganisationID', 'LoadDate', 'LoadTime'])

                if schema_columns:
                    self.logger.debug(f"📄 Fallback: Got {len(schema_columns)} columns from entity schema for {endpoint}")
                    return schema_columns

            self.logger.warning(f"❌ No column information found for {stage_table}")
            return set()

        except Exception as e:
            self.logger.warning(f"Could not get stage table columns for {stage_table}: {str(e)}")
            return set()

    def _get_excluded_fields_from_config(self) -> set:
        """Get excluded fields from integration configuration"""
        try:
            # Try to load config using Utils
            config = Utils.load_integration_config(self.integration.integration_name.upper())
            excluded_fields = config.get('exclude_fields', [])
            return set(excluded_fields)
        except Exception as e:
            self.logger.debug(f"Could not load excluded fields from config: {str(e)}")
            return set()

    def _endpoint_needs_field(self, endpoint: str, field_name: str) -> bool:
        """Check if endpoint stage table has specified field column"""
        if not endpoint or not field_name:
            return False

        try:
            # Generate stage table name
            stage_table = f"{self.integration.table_prefix_eva}{endpoint.lower()}stage"

            # Get stage table columns
            valid_columns = self._get_stage_table_columns(stage_table, endpoint)

            # Check if field exists in stage table schema
            has_field = field_name in valid_columns if valid_columns else False

            self.logger.debug(f"Endpoint {endpoint} {field_name} check: {has_field}")
            return has_field

        except Exception as e:
            self.logger.debug(f"Error checking {field_name} requirement for {endpoint}: {str(e)}")
            return False

    def _apply_additional_field_logic(self, data: pd.DataFrame, field_name: str,
                                      field_config: Dict[str, Any], endpoint: str) -> pd.DataFrame:
        """Apply additional field logic based on configuration"""
        if field_name not in data.columns or data[field_name].isna().all():
            self.logger.info(f"{field_name} missing for {endpoint}, applying additional field logic...")

            # Try fallback sources in order
            fallback_sources = field_config.get('fallback_sources', [])
            field_populated = False

            for fallback_source in fallback_sources:
                if fallback_source in data.columns and not data[fallback_source].isna().all():
                    data[field_name] = data[fallback_source]
                    self.logger.info(f"✅ {field_name} populated from {fallback_source}")
                    field_populated = True
                    break

            # Auto-generate if no fallback worked and auto_generate is set
            if not field_populated and field_config.get('auto_generate'):
                auto_generate = field_config.get('auto_generate')

                if auto_generate == 'sequential':
                    # Generate sequential numbers
                    data[field_name] = range(1, len(data) + 1)
                    self.logger.info(f"✅ {field_name} auto-generated sequentially")
                    field_populated = True
                elif auto_generate == 'timestamp':
                    # Generate current timestamp
                    from datetime import datetime
                    data[field_name] = datetime.now()
                    self.logger.info(f"✅ {field_name} auto-generated as timestamp")
                    field_populated = True

            # Apply default value if nothing else worked
            if not field_populated:
                default_value = field_config.get('default_value', 1)
                data[field_name] = default_value
                self.logger.info(f"✅ {field_name} set to default value: {default_value}")

        # Apply data type conversion
        if field_name in data.columns:
            data_type = field_config.get('data_type', 'string')
            try:
                if data_type == 'integer':
                    data[field_name] = pd.to_numeric(data[field_name], errors='coerce').fillna(
                        field_config.get('default_value', 1)
                    ).astype(int)
                elif data_type == 'datetime':
                    if field_config.get('default_value') == 'CURRENT_TIMESTAMP':
                        from datetime import datetime
                        data[field_name] = datetime.now()
                    else:
                        data[field_name] = pd.to_datetime(data[field_name], errors='coerce')
                elif data_type == 'float':
                    data[field_name] = pd.to_numeric(data[field_name], errors='coerce').fillna(
                        field_config.get('default_value', 0.0)
                    ).astype(float)
                elif data_type == 'string':
                    data[field_name] = data[field_name].astype(str)
            except Exception as e:
                self.logger.warning(f"Failed to convert {field_name} to {data_type}: {str(e)}")
                data[field_name] = field_config.get('default_value', 1)

        return data

    def _create_api_to_db_column_mapping(self, df_columns: set, db_columns: set, endpoint: str) -> dict:
        """
        Create mapping from API field names to database column names
        
        Handles case conversion from snake_case (API) to PascalCase (DB)
        """
        mapping = {}
        
        try:
            # Get entity schema for accurate mapping
            entity_schema = self._get_entity_schema(endpoint)
            if entity_schema and 'fields' in entity_schema:
                # Use schema mapping as primary source
                for field in entity_schema['fields']:
                    api_name = field.get('api_name', '')
                    db_column = field.get('db_column', '').lower()  # Ensure lowercase
                    if api_name and db_column:
                        mapping[api_name] = db_column
            
            # Create fallback mapping for any unmapped columns
            for df_col in df_columns:
                if df_col not in mapping:
                    # Convert snake_case to PascalCase
                    pascal_case = self._convert_to_pascal_case(df_col)
                    
                    # Check if this PascalCase version exists in DB
                    if pascal_case in db_columns:
                        mapping[df_col] = pascal_case
                    else:
                        # Keep original if no better mapping found
                        mapping[df_col] = df_col
            
            self.logger.debug(f"Created {len(mapping)} column mappings for {endpoint}")
            return mapping
            
        except Exception as e:
            self.logger.warning(f"Error creating column mapping for {endpoint}: {str(e)}")
            # Return identity mapping as fallback
            return {col: col for col in df_columns}
    
    def _convert_to_pascal_case(self, snake_case: str) -> str:
        """Convert snake_case to PascalCase"""
        if not snake_case:
            return snake_case
            
        # Handle special cases first
        if snake_case.lower() in ['clientid', 'organisationid']:
            return snake_case.upper() if snake_case.lower() == 'clientid' else 'OrganisationID'
        
        # Standard conversion: split by underscore and capitalize each part
        parts = snake_case.split('_')
        return ''.join(word.capitalize() for word in parts)

    def _process_nested_extractions(self, response_data: Dict, endpoint: str) -> Dict[str, pd.DataFrame]:
        """
        Entry point for processing nested extractions for a given endpoint.
        Extracts nested fields recursively based on schema config.

        Args:
            response_data: API response for this endpoint
            endpoint: name of the current endpoint

        Returns:
            A dictionary of {table_name: pd.DataFrame} for all nested extracted tables
        """
        try:
            main_records = self._extract_records_by_format(response_data, endpoint, 'standard')
            if not main_records:
                return {}

            # Begin recursive extraction
            return self._extract_nested_records(endpoint, main_records)

        except Exception as e:
            self.logger.error(f"Error processing nested extractions for {endpoint}: {str(e)}")
            return {}

    def _extract_nested_records(self, endpoint: str, parent_records: List[Dict]) -> Dict[str, pd.DataFrame]:
        """
        Recursively extracts all nested tables defined in schema for a given endpoint.

        Args:
            endpoint: parent endpoint name
            parent_records: list of records from parent endpoint

        Returns:
            Dictionary of table_name → pd.DataFrame for all levels of nested data
        """
        all_nested_data = {}

        # Load schema to get nested_extractions
        schema = self.integration._load_schema()
        if not schema or 'endpoints' not in schema:
            return {}

        # Find current endpoint config
        endpoint_config = next((ep for ep in schema['endpoints'] if ep.get('name') == endpoint), None)
        if not endpoint_config or 'nested_extractions' not in endpoint_config:
            return {}

        for extraction in endpoint_config['nested_extractions']:
            table_name = extraction.get('table_name')
            source_field = extraction.get('source_field')
            extraction_type = extraction.get('extraction_type', 'standard')
            target_field = extraction.get('target_field')

            if not table_name or not source_field:
                continue

            nested_records = []
            for record in parent_records:
                # Use dot notation support for source_field access
                nested_data = self._get_nested_field_value(record, source_field)

                # Handle case where nested_data might be a JSON string that needs to be deserialized
                if nested_data and isinstance(nested_data, str):
                    try:
                        # Try to parse as JSON string without differentiating between array/object
                        parsed_data = json.loads(nested_data)
                        nested_data = parsed_data
                        self.logger.info(f"Successfully parsed nested_data string as JSON")
                    except json.JSONDecodeError as e:
                        self.logger.debug(f"Failed to parse nested data as JSON: {str(e)[:100]}...")
                        # Keep as string if parsing fails

                if nested_data:
                    # Add all ancestor foreign keys for this virtual endpoint
                    ancestor_ids = self._get_ancestor_foreign_keys(table_name, record, endpoint)

                    # Handle different extraction types
                    if extraction_type == 'array_to_records' and target_field:
                        # Special case: convert array of primitives to individual records
                        # e.g., WorkItemsKey: ["key1", "key2", "key3"] ->
                        # [{WorkItemKey: "key1", TimesheetKey: "parent_key"}, {WorkItemKey: "key2", TimesheetKey: "parent_key"}]
                        if isinstance(nested_data, list):
                            for item in nested_data:
                                # Create a new record for each array item
                                new_record = {target_field: item}
                                # Add all ancestor foreign keys
                                for fk_field, fk_value in ancestor_ids.items():
                                    new_record[fk_field] = fk_value
                                nested_records.append(new_record)
                    else:
                        # Standard extraction logic with list preservation
                        if isinstance(nested_data, list):
                            # Apply schema mapping while preserving list structure
                            nested_data = self._apply_schema_field_mapping(nested_data, table_name)
                            for item in nested_data:
                                if isinstance(item, dict):
                                    # Add all ancestor foreign keys to the nested item
                                    for fk_field, fk_value in ancestor_ids.items():
                                        item[fk_field] = fk_value
                                    nested_records.append(item)
                        elif isinstance(nested_data, dict):
                            # Add all ancestor foreign keys to the nested item
                            for fk_field, fk_value in ancestor_ids.items():
                                nested_data[fk_field] = fk_value
                            nested_records.append(nested_data)

            if not nested_records:
                continue

            # Remove already-processed nested fields in children if needed
            child_endpoint_config = next((ep for ep in schema['endpoints'] if ep.get('name') == table_name), None)
            child_nested_fields = []
            if child_endpoint_config:
                child_nested_fields = [n.get('source_field') for n in
                                       child_endpoint_config.get('nested_extractions', [])]

            cleaned_nested_records = []
            for record in nested_records:
                cleaned_record = record.copy()
                for field in child_nested_fields:
                    if field in cleaned_record:
                        del cleaned_record[field]
                cleaned_nested_records.append(cleaned_record)

            # Save this level
            nested_df = pd.DataFrame(cleaned_nested_records)
            if not nested_df.empty:
                all_nested_data[table_name] = nested_df
                self.logger.debug(f"✅ Extracted {len(nested_df)} records for table {table_name}")

            # Recursively extract deeper levels
            deeper_nested = self._extract_nested_records(table_name, nested_records)
            all_nested_data.update(deeper_nested)

        return all_nested_data
    
    def _get_ancestor_foreign_keys(self, virtual_table_name: str, current_record: Dict, current_endpoint: str) -> Dict[str, str]:
        """
        Get all ancestor foreign keys for a virtual endpoint by tracing hierarchy backwards
        
        Args:
            virtual_table_name: Name of the virtual endpoint table (e.g., 'InvoiceJobsTasks')
            current_record: Current record being processed (contains current level IDs)
            current_endpoint: Current endpoint name (e.g., 'InvoiceJobs')
        
        Returns:
            Dict with foreign key field names and their values
            e.g., {'invoicesId': 'uuid123', 'invoicejobsId': 'uuid456'}
        """
        ancestor_fks = {}
        
        try:
            # Load schema and foreign key pattern once for the entire method
            schema = self.integration._load_schema()
            fk_pattern = schema.get('metadata', {}).get('foreign_key_pattern', '') if schema else ''
            # Tool-generated schemas explicitly identify their source key and inherited FKs.
            current_schema = next((ep for ep in (schema or {}).get('endpoints', [])
                                   if ep.get('name') == current_endpoint), {})
            identity = current_schema.get('identity_field')
            if identity:
                fields = current_schema.get('fields', [])
                mapped = next((f.get('db_column') for f in fields if f.get('api_name') == identity), identity)
                value = self._get_nested_field_value(current_record, identity)
                if value is None:
                    value = next((v for k, v in current_record.items() if k.lower() == mapped.lower()), None)
                ancestor_fks = {f['api_name']: next((v for k, v in current_record.items()
                                                   if k.lower() == f['api_name'].lower()), None)
                                for f in fields if f.get('is_foreign_key')}
                ancestor_fks[f"{current_endpoint.lower()}Id"] = value
                return ancestor_fks

            # Build hierarchy chain by tracing backwards from virtual table
            hierarchy_chain = []
            current_virtual = virtual_table_name
            
            # Trace backwards to build full hierarchy
            while current_virtual:
                hierarchy_chain.insert(0, current_virtual)
                current_virtual = self._find_root_endpoint_for_virtual(current_virtual)
                
                # Avoid infinite loop - if parent is same as current, break
                if current_virtual and current_virtual == hierarchy_chain[0]:
                    break
            
            self.logger.debug(f"Built hierarchy for {virtual_table_name}: {hierarchy_chain}")
            
            # Find current endpoint position in hierarchy
            current_level_index = -1
            for i, level in enumerate(hierarchy_chain):
                if level.lower() == current_endpoint.lower():
                    current_level_index = i
                    break
            
            if current_level_index == -1:
                # Fallback to simple parent ID logic
                parent_id_value = None

                # Use fk_pattern loaded at method start
                if fk_pattern:
                    # Try custom foreign key pattern first (e.g., "Key" for Karbon)
                    # Handle plural/singular variations (e.g., Timesheets -> TimesheetKey, TimesheetsKey)
                    endpoint_key_patterns = [
                        f"{current_endpoint}{fk_pattern}",  # TimesheetsKey
                        f"{current_endpoint.rstrip('s')}{fk_pattern}",  # TimesheetKey (remove trailing 's')
                    ]

                    # Try case-insensitive match for all possible patterns
                    for pattern in endpoint_key_patterns:
                        for field_name, field_value in current_record.items():
                            if field_name.lower() == pattern.lower():
                                parent_id_value = field_value
                                break
                        if parent_id_value:  # Found a match, break outer loop
                            break

                # If no custom pattern match, use standard id fields
                if not parent_id_value:
                    id_fields = ['uuid', 'Uuid', 'UUID', 'id', 'Id', 'ID', 'UID']
                    parent_id_value = next(
                        (current_record.get(field) for field in id_fields if current_record.get(field)), None)

                # Determine field name based on whether we found a custom pattern match
                if fk_pattern and parent_id_value and any(
                    field_name.lower() == pattern.lower() for pattern in [
                        f"{current_endpoint}{fk_pattern}",
                        f"{current_endpoint.rstrip('s')}{fk_pattern}"
                    ] for field_name in current_record.keys()
                ):
                    parent_id_field = f"{current_endpoint}{fk_pattern}"
                else:
                    parent_id_field = f"{current_endpoint.lower()}Id"

                ancestor_fks[parent_id_field] = parent_id_value
                return ancestor_fks
            
            # Build ancestor foreign keys up to current level (inclusive)
            # Use fk_pattern loaded at method start

            for i in range(current_level_index + 1):
                ancestor_level = hierarchy_chain[i]
                # Use custom pattern if available, otherwise use standard Id suffix
                if fk_pattern:
                    ancestor_fk_field = f"{ancestor_level}{fk_pattern}"
                else:
                    ancestor_fk_field = f"{ancestor_level.lower()}Id"
                
                if i == current_level_index:
                    # Current level - get ID from current record
                    ancestor_id = None
                    # Use fk_pattern loaded at method start
                    if fk_pattern:
                        # Try custom foreign key pattern first (e.g., "Key" for Karbon)
                        # Handle plural/singular variations (e.g., Timesheets -> TimesheetKey, TimesheetsKey)
                        level_key_patterns = [
                            f"{ancestor_level}{fk_pattern}",  # TimesheetsKey
                            f"{ancestor_level.rstrip('s')}{fk_pattern}",  # TimesheetKey (remove trailing 's')
                        ]

                        # Try case-insensitive match for all possible patterns
                        for pattern in level_key_patterns:
                            for field_name, field_value in current_record.items():
                                if field_name.lower() == pattern.lower():
                                    ancestor_id = field_value
                                    break
                            if ancestor_id:  # Found a match, break outer loop
                                break

                    # If no custom pattern match, use standard id fields
                    if not ancestor_id:
                        id_fields = ['uuid', 'Uuid', 'UUID', 'id', 'Id', 'ID', 'UID']
                        ancestor_id = next(
                            (current_record.get(field) for field in id_fields if current_record.get(field)), None)
                    if ancestor_id:
                        ancestor_fks[ancestor_fk_field] = ancestor_id
                else:
                    # Previous levels - try to get from current record
                    possible_field_names = [
                        ancestor_fk_field,  # invoicesId
                        f"{ancestor_level.lower()}Uuid",  # invoicesUuid
                        f"{ancestor_level.lower()}_id",  # invoices_id
                    ]

                    # Use fk_pattern loaded at method start
                    if fk_pattern:
                        # Handle plural/singular variations (e.g., Timesheets -> TimesheetKey, TimesheetsKey)
                        custom_key_patterns = [
                            f"{ancestor_level}{fk_pattern}",  # TimesheetsKey
                            f"{ancestor_level.rstrip('s')}{fk_pattern}",  # TimesheetKey (remove trailing 's')
                        ]
                        # Insert custom patterns at the beginning (try first)
                        for pattern in reversed(custom_key_patterns):  # Reverse to maintain order when inserting at 0
                            possible_field_names.insert(0, pattern)

                    ancestor_id = None
                    for field_name in possible_field_names:
                        # Try exact match first
                        if field_name in current_record:
                            ancestor_id = current_record[field_name]
                            break
                        # Try case-insensitive match for custom pattern
                        elif fk_pattern and field_name.endswith(fk_pattern):
                            for record_field_name, record_field_value in current_record.items():
                                if record_field_name.lower() == field_name.lower():
                                    ancestor_id = record_field_value
                                    break
                            if ancestor_id:
                                break

                    if ancestor_id:
                        ancestor_fks[ancestor_fk_field] = ancestor_id
            
            return ancestor_fks
            
        except Exception as e:
            self.logger.error(f"Error getting ancestor foreign keys for {virtual_table_name}: {e}")
            # Fallback to simple parent ID logic
            parent_id_value = current_record.get('uuid') or current_record.get('id') or current_record.get('Id')
            parent_id_field = f"{current_endpoint.lower()}Id"
            return {parent_id_field: parent_id_value}
    
    
    def _find_root_endpoint_for_virtual(self, virtual_table_name: str) -> str:
        """Find the root endpoint that contains this virtual endpoint"""
        try:
            schema = self.integration._load_schema()
            if not schema:
                return ""
            
            # Check all endpoints for nested_extractions
            for endpoint in schema.get('endpoints', []):
                nested_extractions = endpoint.get('nested_extractions', [])
                for extraction in nested_extractions:
                    if extraction.get('table_name', '').lower() == virtual_table_name.lower():
                        return endpoint.get('name', '')
                        
            # Check virtual endpoints for nested_extractions (for deeper levels)  
            for endpoint in schema.get('endpoints', []):
                if endpoint.get('is_virtual_endpoint', False):
                    nested_extractions = endpoint.get('nested_extractions', [])
                    for extraction in nested_extractions:
                        if extraction.get('table_name', '').lower() == virtual_table_name.lower():
                            # This virtual endpoint contains our target - need to find ITS root
                            return self._find_root_endpoint_for_virtual(endpoint.get('name', ''))
            
            return ""
            
        except Exception as e:
            self.logger.error(f"Error finding root endpoint for {virtual_table_name}: {e}")
            return ""

    def _clean_infinity_values(self, data: pd.DataFrame) -> pd.DataFrame:
        """Clean infinity values that MySQL cannot handle"""
        if data.empty:
            return data

        try:
            # Replace inf and -inf with None (NULL in MySQL)
            for column in data.columns:
                if data[column].dtype in ['float64', 'float32', 'int64', 'int32']:
                    # Check for infinity values
                    if data[column].isin([np.inf, -np.inf, math.inf, -math.inf]).any():
                        inf_count = data[column].isin([np.inf, -np.inf, math.inf, -math.inf]).sum()
                        self.logger.warning(f"🔢 Found {inf_count} infinity values in column '{column}', replacing with NULL")

                        # Replace infinity with None
                        data[column] = data[column].replace([np.inf, -np.inf, math.inf, -math.inf], None)

            return data

        except Exception as e:
            self.logger.warning(f"Error cleaning infinity values: {e}")
            return data