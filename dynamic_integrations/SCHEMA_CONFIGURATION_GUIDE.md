# Dynamic Integration Schema Configuration Guide

## 📝 Schema Overview

The schema file defines how the dynamic integration system interacts with APIs, processes data, and stores it in the database. It's the central configuration that controls the entire ETL pipeline.

### Basic Schema Structure

```json
{
  "integration_name": "YOUR_INTEGRATION",
  "api_config": {
    "base_url": "https://api.example.com/v1/",
    "authentication": { ... },
    "pagination": { ... }
  },
  "endpoints": [ ... ]
}
```

## 🔧 API Configuration Keys

### `api_config.base_url`
**Purpose**: Base URL for all API endpoints
```json
"base_url": "https://api.example.com/v1/"
```

### `api_config.authentication`
**Purpose**: Define authentication method and credentials template
```json
"authentication": {
  "type": "bearer_token",           // Authentication type
  "header": "Authorization",        // Header name for auth
  "format": "Bearer {token}"        // Token format template
}
```

### `api_config.pagination`
**Purpose**: Configure how API handles pagination
```json
"pagination": {
  "type": "offset",                 // Pagination strategy
  "limit_param": "limit",           // Parameter name for page size
  "offset_param": "offset",         // Parameter name for offset
  "default_limit": 100              // Default page size
}
```

## 🔑 Critical Endpoint Configuration Keys

### 1. `default_params` - Auto-Add URL Parameters
**Purpose**: Automatically add parameters to every API call for this endpoint
**Use Case**: Always expand nested data, apply filters, or set default options

```json
{
  "api_details": {
    "path": "/orders",
    "default_params": {
      "$expand": "items,payments",    // Always expand related data
      "$filter": "status eq 'active'" // Always filter active records
    }
  }
}
```
**Result**: Every API call becomes `/orders?$expand=items,payments&$filter=status eq 'active'&limit=100`

### 2. `nested_extractions` - Multi-Dataset from Single API Call
**Purpose**: Extract multiple database tables from one API response
**Use Case**: APIs that return main object with nested arrays

```json
{
  "nested_extractions": [
    {
      "table_name": "OrderItems",     // Target table name
      "source_field": "items"        // JSON field containing array data
    },
    {
      "table_name": "OrderPayments", 
      "source_field": "payments"
    }
  ]
}
```
**Behavior**: 
- 1 API call to `/orders?$expand=items,payments`
- Main order data → `Orders` table
- `items` array → `OrderItems` table  
- `payments` array → `OrderPayments` table

### 3. `is_virtual_endpoint` - Skip API Calls
**Purpose**: Mark endpoints that don't need separate API calls
**Use Case**: Data populated by nested_extractions from other endpoints

```json
{
  "name": "OrderItems",
  "is_virtual_endpoint": true        // Don't make API calls for this
}
```
**Behavior**:
- OrderItems won't appear in integration endpoint processing list
- Data comes from Orders endpoint via nested_extractions
- Database tables still created and populated

### 4. `is_child_endpoint` - Parent-Child Processing
**Purpose**: Process endpoints that require parent IDs from other tables
**Use Case**: APIs with detail endpoints like `/customers/{id}` that need customer IDs first

```json
{
  "name": "CustomerDetails",
  "is_child_endpoint": true,
  "child_endpoint_config": [{
    "parent_table": "customers",      // Get IDs from this table
    "parent_id_column": "customer_id", // Column containing parent ID
    "child_endpoint_type": "url_based" // How to use the ID
  }],
  "api_details": {
    "path": "/customers/{customer_id}" // URL template with placeholder
  }
}
```
**Behavior**:
- System queries `customers` table for all `customer_id` values
- Makes separate API call for each ID: `/customers/123`, `/customers/456`, etc.
- Saves detailed data to `CustomerDetails` table

### 5. `response_structure` - Data Extraction Rules
**Purpose**: Tell system how to find data in API response
**Use Case**: Different APIs wrap data differently

```json
{
  "response_structure": {
    "root_data_field": "data",        // Where to find the actual data
    "is_array": true,                 // Data is an array
    "nested_objects": ["address"],    // Fields that are objects
    "array_fields": ["tags", "skills"] // Fields that are arrays
  }
}
```

**Data Location Examples**:
```json
// root_data_field: "data"
{"data": [{"id": 1}, {"id": 2}]}

// root_data_field: "results.items"  
{"results": {"items": [{"id": 1}]}}

// root_data_field: ""
[{"id": 1}, {"id": 2}]               // Direct array response
```

### 6. Field Configuration - Data Types & Constraints
**Purpose**: Define how API fields map to database columns

```json
{
  "fields": [
    {
      "api_name": "customer_id",        // Field name in API response
      "db_column": "CustomerID",        // Column name in database
      "data_type": "NVARCHAR(50)",      // SQL data type
      "is_primary_key": true,           // Create PRIMARY KEY constraint
      "is_flatten": false               // Handle nested objects
    },
    {
      "api_name": "address",
      "db_column": "Address", 
      "data_type": "JSON",              // Store as JSON
      "is_flatten": false               // Keep object structure
    }
  ]
}
```

**Key Field Flags**:
- `is_primary_key: true` → Creates PRIMARY KEY constraint
- `data_type: "JSON"` + `is_flatten: false` → Store complex objects as JSON
- `is_flatten: true` → Convert objects to flat strings

### 7. `query_parameters.incremental_sync` - UPSERT Support
**Purpose**: Configure endpoint for incremental synchronization using timestamps
**Use Case**: Enable UPSERT mode with automatic timestamp filtering for delta updates

```json
{
  "api_details": {
    "path": "/timeentries",
    "query_parameters": {
      "incremental_sync": {
        "timestamp_field": "modified_on_gte",           // API parameter name for filtering
        "timestamp_format": "YYYY-MM-DDTHH:mm:ss+00:00", // Format required by API
        "description": "Filter records modified since timestamp"  // Human description
      },
      "required": ["action"],
      "optional": ["modified_on_gte", "modified_on_lte", "page", "per_page"]
    }
  }
}
```

**Incremental Sync Fields**:
- `timestamp_field` → API parameter name used for timestamp filtering (e.g., `modified_on_gte`, `updated_since`)
- `timestamp_format` → Timestamp format expected by API (converts from ISO to API format)
- `description` → Human-readable explanation of the parameter's purpose

**UPSERT Behavior**:
1. **Auto-Detection**: System queries `MAX(EtlUpdateTime)` from production table
2. **Custom Override**: User can provide `time-from` parameter to bypass database query
3. **Format Conversion**: Timestamps automatically formatted according to `timestamp_format`
4. **Fallback**: If no incremental sync config, endpoint uses full load

### 8. `query_parameters.required` & `optional` - API Parameters
**Purpose**: Define which parameters the API endpoint accepts
**Use Case**: Documentation and validation of API parameter requirements

```json
{
  "api_details": {
    "query_parameters": {
      "required": [
        "action"                        // Must be provided for every API call
      ],
      "optional": [
        "modified_on_gte",              // Timestamp filter (used by incremental_sync)
        "modified_on_lte",              // End timestamp filter  
        "page",                         // Pagination parameter
        "per_page",                     // Page size parameter
        "status",                       // Optional status filter
        "client_id"                     // Optional client filter
      ]
    }
  }
}
```

**Parameter Types**:
- `required` → Parameters that must be included in every API call
- `optional` → Parameters that can be included based on business logic or user input

## 🔄 Authentication Types

### Bearer Token
```json
{
  "authentication": {
    "type": "bearer_token",
    "header": "Authorization",
    "format": "Bearer {token}"
  }
}
```

### API Key
```json
{
  "authentication": {
    "type": "api_key", 
    "header": "X-API-Key",
    "format": "{key}"
  }
}
```

### Dual Key (Multiple Headers)
```json
{
  "authentication": {
    "type": "dual_key"
  },
  "headers": {
    "Authorization": "Bearer {{access_token}}",
    "X-Tenant-Key": "{{tenant_key}}"
  }
}
```

## 📋 Common Configuration Patterns

### Pattern 1: Simple List Endpoint
```json
{
  "name": "Products",
  "api_details": {
    "path": "/products"
  },
  "response_structure": {
    "root_data_field": "data",
    "is_array": true
  }
}
```

### Pattern 2: Expand Related Data
```json
{
  "name": "Orders", 
  "api_details": {
    "path": "/orders",
    "default_params": {
      "$expand": "customer,items"
    }
  },
  "nested_extractions": [
    {
      "table_name": "OrderItems",
      "source_field": "items"
    }
  ]
}
```

### Pattern 3: Child Detail Endpoint
```json
{
  "name": "CustomerProfiles",
  "is_child_endpoint": true,
  "child_endpoint_config": [{
    "parent_table": "customers",
    "parent_id_column": "id"
  }],
  "api_details": {
    "path": "/customers/{id}/profile"
  }
}
```

### Pattern 4: UPSERT-Enabled Endpoint
```json
{
  "name": "TimeEntry",
  "api_details": {
    "path": "/timeentries",
    "query_parameters": {
      "incremental_sync": {
        "timestamp_field": "modified_on_gte",
        "timestamp_format": "YYYY-MM-DDTHH:mm:ss+00:00",
        "description": "Filter records modified since timestamp"
      },
      "required": ["action"],
      "optional": ["modified_on_gte", "modified_on_lte", "page", "per_page"]
    }
  },
  "fields": [
    {
      "api_name": "id",
      "db_column": "TimeEntryID", 
      "data_type": "NVARCHAR(50)",
      "is_primary_key": true
    }
  ]
}
```

### Pattern 5: Custom Request Body (FYI-style)
```json
{
  "name": "Cabinet",
  "api_details": {
    "path": "/Cabinet/list",
    "method": "POST",
    "request_body_template": {
      "structure": {
        "action": {"value": "list"},
        "data": {
          "modified_on_gte": "",
          "modified_on_lte": "",
          "page": 1,
          "per_page": 500
        }
      }
    },
    "query_parameters": {
      "incremental_sync": {
        "timestamp_field": "modified_on_gte", 
        "timestamp_format": "YYYY-MM-DDTHH:mm:ss+00:00"
      }
    }
  }
}
```

## 🎯 Key Selection Guidelines

### Use `nested_extractions` when:
- API returns main object with nested arrays
- Want to populate multiple tables from single API call
- Nested data has independent business meaning

### Use `is_virtual_endpoint` when:
- Endpoint data comes from other endpoints
- Want database table but no separate API calls
- Always pair with `nested_extractions` in parent endpoint

### Use `is_child_endpoint` when:
- API has detail URLs requiring parent IDs
- Need to make multiple calls based on existing data
- Parent-child relationship exists

### Use `default_params` when:
- Always need same URL parameters
- Want to expand related data automatically
- Apply consistent filtering or formatting

### Use `incremental_sync` when:
- API supports timestamp-based filtering
- Want UPSERT mode with delta updates
- Need to sync only new/modified records
- API has parameters like `modified_since`, `updated_after`, `created_from`

### Use `is_primary_key` when:
- Field uniquely identifies records
- Want TRUE UPSERT (UPDATE existing, INSERT new)
- Need to prevent duplicate records in stage tables
- Field maps to database primary key constraint

## 📊 Troubleshooting

### No Data Extracted
- Check `root_data_field` matches API response structure
- Verify `is_array` setting matches response format

### Missing Related Data
- Ensure `nested_extractions` `source_field` exists in response
- Check `default_params` includes necessary expand parameters

### Child Endpoint Errors
- Verify `parent_table` name matches existing table
- Check `parent_id_column` exists and has data
- Ensure URL template `{placeholders}` match config

### Virtual Endpoint Issues  
- Virtual endpoint should not appear in processing list
- Parent endpoint must have `nested_extractions` configured
- Source field must exist in parent API response

### UPSERT Mode Issues
**No Incremental Sync**: 
- Check `incremental_sync` configuration exists in `query_parameters`
- Verify `timestamp_field` matches API parameter name
- Ensure endpoint supports timestamp filtering

**Timestamp Format Errors**:
- Check `timestamp_format` matches API requirements
- Common formats: `YYYY-MM-DDTHH:mm:ss+00:00`, `YYYY-MM-DD`, `unix_timestamp`
- System auto-converts from ISO format to schema format

**UPSERT Not Working**:
- Verify `is_primary_key: true` set on unique identifier field
- Check primary key column exists in API response data
- Without primary key, system falls back to APPEND mode

**Auto-Detection Problems**:
- Check production table exists: `c{client_number}_{integration}_{endpoint}`
- Verify `EtlUpdateTime` column exists in production table
- Ensure `OrganisationID` matches in production table query
- Use custom `time-from` parameter to bypass auto-detection

### Custom Request Body Issues (FYI-style)
- Verify `request_body_template.structure` matches API expectations
- Check authentication includes `X-Custom-Request-Body` header
- Ensure `method: "POST"` specified for custom request APIs
- Timestamp parameters automatically added to `data` section