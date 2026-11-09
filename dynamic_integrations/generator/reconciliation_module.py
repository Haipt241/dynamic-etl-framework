"""
Reconciliation Module for Dynamic Integration ETL Pipeline

This module provides endpoint-based reconciliation between API response counts
and production table counts, triggering full reloads when mismatches are detected.

Author: ETL Development Team
Created: 2026-01-07
"""

import logging
from dataclasses import dataclass
from enum import Enum
from typing import Dict, Any, Optional, List
import traceback
import json
import os
from datetime import datetime

# Configure logging
logger = logging.getLogger(__name__)


class ReconciliationType(Enum):
    """Supported reconciliation types for different API patterns."""
    API_TOTAL_COUNT = "api_total_count"      # MYOB-style direct "Count" field in response body
    API_HEADER_COUNT = "api_header_count"    # SimPro-style total count in response headers
    API_CALCULATED_COUNT = "api_calculated_count"  # WFM-style calculated from pagination meta
    DISABLED = "disabled"                    # Skip reconciliation


@dataclass
class ReconciliationResult:
    """Result of reconciliation check with action indicators."""
    endpoint: str
    api_count: Optional[int]
    production_count: int
    mismatch_detected: bool
    requires_reload: bool
    message: str
    error: Optional[str] = None

    @property
    def count_difference(self) -> Optional[int]:
        """Calculate the difference between API and production counts."""
        if self.api_count is not None:
            return abs(self.api_count - self.production_count)
        return None


class ReconciliationConfig:
    """Configuration parser and validator for reconciliation settings."""

    def __init__(self, config: Dict[str, Any]):
        """Initialize reconciliation configuration.

        Args:
            config: Integration configuration dict containing reconciliation settings
        """
        self.raw_config = config
        self.reconciliation_config = config.get('reconciliation', {})
        self._validate_config()

    def _validate_config(self):
        """Validate reconciliation configuration structure."""
        if not isinstance(self.reconciliation_config, dict):
            raise ValueError("Reconciliation config must be a dictionary")

        # Set defaults
        self.enabled = self.reconciliation_config.get('enabled', False)
        self.type = ReconciliationType(self.reconciliation_config.get('type', 'disabled'))
        self.field_mapping = self.reconciliation_config.get('field_mapping', {})
        self.endpoints = self.reconciliation_config.get('endpoints', {})
        self.mismatch_tolerance = self.reconciliation_config.get('mismatch_tolerance', 0)
        self.retry_attempts = self.reconciliation_config.get('retry_attempts', 1)

        # Validate field mapping for API_TOTAL_COUNT
        if self.type == ReconciliationType.API_TOTAL_COUNT:
            if not self.field_mapping.get('total_count_field'):
                logger.warning("Reconciliation enabled but no total_count_field specified")

        # Validate field mapping for API_HEADER_COUNT
        elif self.type == ReconciliationType.API_HEADER_COUNT:
            if not self.field_mapping.get('total_count_header'):
                logger.warning("Reconciliation enabled but no total_count_header specified")

        # Validate field mapping for API_CALCULATED_COUNT
        elif self.type == ReconciliationType.API_CALCULATED_COUNT:
            required_fields = ['total_pages_field', 'per_page_field']
            missing_fields = [field for field in required_fields if not self.field_mapping.get(field)]
            if missing_fields:
                logger.warning(f"Reconciliation enabled but missing required fields: {missing_fields}")

    def is_endpoint_enabled(self, endpoint: str) -> bool:
        """Check if reconciliation is enabled for a specific endpoint.

        Args:
            endpoint: Endpoint name to check

        Returns:
            bool: True if reconciliation is enabled for this endpoint
        """
        if not self.enabled:
            return False

        # Endpoints is always a list - check if endpoint is in the list
        if isinstance(self.endpoints, list):
            return endpoint in self.endpoints
        else:
            # If no endpoints config, default to enabled for all
            return True

    def get_total_count_field(self, endpoint: str = None) -> str:
        """Get the total count field name for extraction.

        Args:
            endpoint: Optional endpoint name (unused in current implementation)

        Returns:
            str: Field name to extract total count from API response
        """
        return self.field_mapping.get('total_count_field', 'Count')

    def get_total_count_header(self, endpoint: str = None) -> str:
        """Get the total count header name for extraction from response headers.

        Args:
            endpoint: Optional endpoint name (unused in current implementation)

        Returns:
            str: Header name to extract total count from API response headers
        """
        return self.field_mapping.get('total_count_header', 'Result-Total')

    def get_fallback_headers(self, endpoint: str = None) -> List[str]:
        """Get fallback header names if primary header is not available.

        Args:
            endpoint: Optional endpoint name (unused in current implementation)

        Returns:
            List[str]: List of fallback header names to try
        """
        return self.reconciliation_config.get('fallback_headers', [])

    def get_total_pages_field(self, endpoint: str = None) -> str:
        """Get the field path for total pages in pagination meta.

        Args:
            endpoint: Optional endpoint name (unused in current implementation)

        Returns:
            str: Field path to extract total pages (e.g., 'meta.pagination.total_pages')
        """
        return self.field_mapping.get('total_pages_field', 'meta.pagination.total_pages')

    def get_per_page_field(self, endpoint: str = None) -> str:
        """Get the field path for per page count in pagination meta.

        Args:
            endpoint: Optional endpoint name (unused in current implementation)

        Returns:
            str: Field path to extract per page count (e.g., 'meta.pagination.per_page')
        """
        return self.field_mapping.get('per_page_field', 'meta.pagination.per_page')



class ReconciliationModule:
    """
    Main reconciliation module for endpoint-based data integrity checks.

    This module integrates into the ETL pipeline to compare API response counts
    against production table counts and trigger full reloads when mismatches are detected.
    """

    def __init__(self, integration_config: Dict[str, Any], integration_instance):
        """Initialize reconciliation module with configuration.

        Args:
            integration_config: Complete integration configuration dictionary
            integration_instance: Reference to main integration instance for callbacks
        """
        self.integration_instance = integration_instance
        self.config = ReconciliationConfig(integration_config)

        # Track endpoints that remain failed after retry attempts
        self.failed_endpoints: List[Dict[str, Any]] = []

        logger.info(f"ReconciliationModule initialized - "
                   f"Enabled: {self.config.enabled}, Type: {self.config.type.value}")

    def check_reconciliation(self, endpoint: str, production_count: int) -> ReconciliationResult:
        """
        Core reconciliation logic to compare API count vs production count.

        Args:
            endpoint: Endpoint name being reconciled
            production_count: Count of records in production table

        Returns:
            ReconciliationResult: Result with mismatch detection and action indicators
        """
        try:
            # Check if reconciliation is enabled for this endpoint
            if not self.config.is_endpoint_enabled(endpoint):
                return ReconciliationResult(
                    endpoint=endpoint,
                    api_count=None,
                    production_count=production_count,
                    mismatch_detected=False,
                    requires_reload=False,
                    message=f"Reconciliation disabled for endpoint {endpoint}"
                )

            # Get API total count by calling API directly
            api_count = self._get_api_total_count(endpoint)

            if api_count is None:
                return ReconciliationResult(
                    endpoint=endpoint,
                    api_count=None,
                    production_count=production_count,
                    mismatch_detected=False,
                    requires_reload=False,
                    message=f"Could not extract API total count for {endpoint}",
                    error="API count extraction failed"
                )

            # Compare counts - must be exact match
            mismatch_detected = api_count != production_count

            if mismatch_detected:
                difference = abs(api_count - production_count)
                message = (f"Count mismatch detected for {endpoint}: "
                          f"API={api_count}, Production={production_count}, "
                          f"Difference={difference}")
                logger.warning(message)

                return ReconciliationResult(
                    endpoint=endpoint,
                    api_count=api_count,
                    production_count=production_count,
                    mismatch_detected=True,
                    requires_reload=True,
                    message=message
                )
            else:
                message = (f"Reconciliation successful for {endpoint}: "
                          f"API={api_count}, Production={production_count}")
                logger.info(message)

                return ReconciliationResult(
                    endpoint=endpoint,
                    api_count=api_count,
                    production_count=production_count,
                    mismatch_detected=False,
                    requires_reload=False,
                    message=message
                )

        except Exception as e:
            error_message = f"Reconciliation error for {endpoint}: {str(e)}"
            logger.error(f"{error_message}\n{traceback.format_exc()}")

            return ReconciliationResult(
                endpoint=endpoint,
                api_count=None,
                production_count=production_count,
                mismatch_detected=False,
                requires_reload=False,
                message=error_message,
                error=str(e)
            )

    @staticmethod
    def trigger_full_reload(endpoint: str, integration_instance) -> int:
        """
        Trigger immediate full reload for an endpoint when mismatch is detected.

        Args:
            endpoint: Endpoint name to reload
            integration_instance: Integration instance for reload operations

        Returns:
            int: New production count after reload, or original count if reload failed
        """
        try:
            logger.info(f"Starting full reload for {endpoint} due to count mismatch")

            # Log reconciliation reload start
            integration_instance.log_endpoint_step(
                endpoint, 'Reconciliation_Reload_Started', 'Full',
                error_message=f"Triggering full reload due to count mismatch"
            )

            # Get original production count for comparison
            original_count = integration_instance._get_production_table_count(endpoint)

            # Force full load mode (disable UPSERT) for this reload
            original_upsert_mode = getattr(integration_instance, 'upsert_mode', False)
            integration_instance.upsert_mode = False

            try:
                # Extract data with full load
                result = integration_instance.extractor.extract_api_response(
                    endpoint, upsert_mode=False
                )

                if result.get('success', False):
                    # Get stage count from reload result (RefreshRowCount)
                    stage_count = result.get('stage_count', result.get('records_processed', 0))

                    # Get new production count after reload
                    new_count = integration_instance._get_production_table_count(endpoint)

                    logger.info(f"Full reload completed for {endpoint}: "
                               f"Original={original_count}, New={new_count}, Stage={stage_count}")

                    # Log successful reload completion with stage count and RefreshDetail
                    refresh_detail = f"Reconciliation-triggered full reload: {original_count} → {new_count} records"
                    integration_instance.log_endpoint_step(
                        endpoint, 'Reconciliation_Reload_Completed', 'Full',
                        stage_count=stage_count,
                        total_count=new_count,
                        error_message=refresh_detail
                    )

                    return new_count
                else:
                    error_msg = f"Full reload failed for {endpoint}: {result.get('error', 'Unknown error')}"
                    logger.error(error_msg)

                    # Log failed reload
                    integration_instance.log_endpoint_step(
                        endpoint, 'Failed', 'Full',
                        error_message=error_msg
                    )

                    return original_count

            finally:
                # Restore original UPSERT mode
                integration_instance.upsert_mode = original_upsert_mode

        except Exception as e:
            error_message = f"Full reload error for {endpoint}: {str(e)}"
            logger.error(f"{error_message}\n{traceback.format_exc()}")

            # Log reload error
            integration_instance.log_endpoint_step(
                endpoint, 'Failed', 'Full',
                error_message=error_message
            )

            # Return original production count if reload completely failed
            return integration_instance._get_production_table_count(endpoint)

    def _get_api_total_count(self, endpoint: str) -> Optional[int]:
        """Get total count by calling API with clean URL (reuse existing URL builder)."""
        if self.config.type == ReconciliationType.API_TOTAL_COUNT:
            return self._get_api_response_body_count(endpoint)
        elif self.config.type == ReconciliationType.API_HEADER_COUNT:
            return self._get_api_response_header_count(endpoint)
        elif self.config.type == ReconciliationType.API_CALCULATED_COUNT:
            return self._get_api_calculated_count(endpoint)
        else:
            return None

    def _get_api_response_body_count(self, endpoint: str) -> Optional[int]:
        """Get total count from API response body (original implementation)."""
        try:
            # Reuse existing URL builder logic
            integration = self.integration_instance
            clean_url, _ = integration.extractor.url_builder.build_api_url(endpoint, params={})

            # Call API
            import requests
            auth_headers = integration.get_auth_headers()
            response = requests.get(clean_url, headers=auth_headers, timeout=30)
            response.raise_for_status()
            data = response.json()

            # Extract count from response body
            count_field = self.config.get_total_count_field(endpoint)
            if count_field in data:
                return int(data[count_field])
            return None

        except Exception as e:
            return None

    def _get_api_response_header_count(self, endpoint: str) -> Optional[int]:
        """Get total count from API response headers (new implementation for SimPro-style APIs)."""
        try:
            # Reuse existing URL builder logic
            integration = self.integration_instance
            clean_url, _ = integration.extractor.url_builder.build_api_url(endpoint, params={})

            # Call API
            import requests
            auth_headers = integration.get_auth_headers()
            response = requests.get(clean_url, headers=auth_headers, timeout=30)
            response.raise_for_status()

            # Create case-insensitive header lookup
            headers_lower = {k.lower(): v for k, v in response.headers.items()}

            # Try primary header first
            primary_header = self.config.get_total_count_header(endpoint).lower()
            if primary_header in headers_lower:
                try:
                    return int(headers_lower[primary_header])
                except (ValueError, TypeError):
                    pass

            # Try fallback headers from config
            fallback_headers = self.config.get_fallback_headers(endpoint)
            for fallback_header in fallback_headers:
                fallback_header_lower = fallback_header.lower()
                if fallback_header_lower in headers_lower:
                    try:
                        return int(headers_lower[fallback_header_lower])
                    except (ValueError, TypeError):
                        continue

            # Log available headers for debugging
            available_headers = list(response.headers.keys())
            logger.warning(f"No total count header found for {endpoint}. Available headers: {available_headers}")
            return None

        except Exception as e:
            logger.error(f"Error getting API header count for {endpoint}: {e}")
            return None

    def _get_api_calculated_count(self, endpoint: str) -> Optional[int]:
        """Get total count by calculating from pagination metadata (WFM-style APIs)."""
        try:
            integration = self.integration_instance

            # Get pagination config from integration schema
            schema_config = integration._extract_schema_config()
            pagination_config = schema_config.get('api_config', {}).get('pagination', {})
            if not pagination_config:
                pagination_config = schema_config.get('pagination_config', {})

            if not pagination_config:
                logger.warning(f"No pagination config found for {endpoint}")
                return None

            # Build page 1 URL with correct pagination params
            base_url, _ = integration.extractor.url_builder.build_api_url(endpoint)

            # Use query_builder to build pagination params (same logic as data extraction)
            limit = pagination_config.get('page_size', 250)  # Use configured page size
            page_1_params = integration.extractor.query_builder.build_pagination_params(pagination_config, 1, limit)

            import requests
            auth_headers = integration.get_auth_headers()
            auth_type = integration.config.get('auth_type', 'api_key')

            # Call page 1 API with correct pagination handling
            if auth_type == 'custom_request':
                # For custom_request: pass params in request body
                response = requests.post(base_url, headers=auth_headers, json=page_1_params, timeout=30)
            else:
                # For standard REST: build URL with params
                page_1_url = self._build_paginated_url(base_url, page_1_params)
                response = requests.get(page_1_url, headers=auth_headers, timeout=30)

            response.raise_for_status()
            data = response.json()

            # Extract pagination fields from page 1
            total_pages = self._extract_nested_field(data, self.config.get_total_pages_field(endpoint))
            per_page_first = self._extract_nested_field(data, self.config.get_per_page_field(endpoint))

            if total_pages is None or per_page_first is None:
                logger.warning(f"Could not extract pagination metadata for {endpoint}. total_pages={total_pages}, per_page_first={per_page_first}")
                return None

            total_pages = int(total_pages)
            per_page_first = int(per_page_first)

            if total_pages == 1:
                # Single page - per_page_first is the total count
                logger.info(f"Single page count for {endpoint}: {per_page_first}")
                return per_page_first

            # Multi-page - call last page to get its per_page
            last_page_params = integration.extractor.query_builder.build_pagination_params(pagination_config, total_pages, limit)

            if auth_type == 'custom_request':
                last_response = requests.post(base_url, headers=auth_headers, json=last_page_params, timeout=30)
            else:
                last_page_url = self._build_paginated_url(base_url, last_page_params)
                last_response = requests.get(last_page_url, headers=auth_headers, timeout=30)

            last_response.raise_for_status()
            last_data = last_response.json()

            # Get per_page from last page metadata
            per_page_last = self._extract_nested_field(last_data, self.config.get_per_page_field(endpoint))

            if per_page_last is None:
                logger.warning(f"Could not extract per_page from last page for {endpoint}")
                return None

            per_page_last = int(per_page_last)

            # Calculate total: per_page_first * (total_pages - 1) + per_page_last
            calculated_total = per_page_first * (total_pages - 1) + per_page_last

            logger.info(f"Calculated count for {endpoint}: {per_page_first} * ({total_pages} - 1) + {per_page_last} = {calculated_total}")
            return calculated_total

        except Exception as e:
            logger.error(f"Error calculating API count for {endpoint}: {e}")
            return None

    def _build_paginated_url(self, base_url: str, params: Dict[str, Any]) -> str:
        """Build URL with pagination parameters (reuse logic from data_extraction)."""
        import urllib.parse

        if not base_url or not params:
            return base_url

        query_string = urllib.parse.urlencode(params)
        separator = '&' if '?' in base_url else '?'
        return f"{base_url}{separator}{query_string}"

    def _extract_nested_field(self, data: dict, field_path: str) -> any:
        """Extract value from nested dictionary using dot notation (e.g., 'meta.pagination.total_pages')."""
        try:
            current = data
            for key in field_path.split('.'):
                if isinstance(current, dict) and key in current:
                    current = current[key]
                else:
                    return None
            return current
        except Exception:
            return None

    def add_failed_endpoint(self, endpoint: str, api_count: Optional[int], production_count: int, error_message: str):
        """Add an endpoint to the failed endpoints list.

        Args:
            endpoint: Name of the failed endpoint
            api_count: API count (can be None if API call failed)
            production_count: Production table count
            error_message: Description of the failure
        """
        # Remove existing entry for this endpoint (if any)
        self.remove_failed_endpoint(endpoint)

        # Add new failure entry
        failed_entry = {
            "endpoint": endpoint,
            "api_count": api_count,
            "production_count": production_count,
            "error_message": error_message,
            "timestamp": datetime.now().isoformat(),
            "difference": abs(api_count - production_count) if api_count is not None else None
        }

        self.failed_endpoints.append(failed_entry)
        logger.warning(f"Added {endpoint} to failed endpoints list: {error_message}")

    def remove_failed_endpoint(self, endpoint: str):
        """Remove an endpoint from the failed endpoints list (when retry succeeds).

        Args:
            endpoint: Name of the endpoint to remove
        """
        original_count = len(self.failed_endpoints)
        self.failed_endpoints = [ep for ep in self.failed_endpoints if ep['endpoint'] != endpoint]

        if len(self.failed_endpoints) < original_count:
            logger.info(f"Removed {endpoint} from failed endpoints list (retry successful)")

    def get_failed_endpoints_count(self) -> int:
        """Get the count of endpoints that remain failed.

        Returns:
            int: Number of endpoints with unresolved reconciliation issues
        """
        return len(self.failed_endpoints)

    def save_failed_endpoints_report(self) -> Optional[str]:
        """Save failed endpoints to a JSON file and log the filename.

        Returns:
            str: Path to the saved report file, or None if no failures to report
        """
        if not self.failed_endpoints:
            logger.info("No failed endpoints to report - all reconciliations successful or resolved")
            return None

        try:
            # Generate filename with timestamp and integration name
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            integration_name = getattr(self.integration_instance, 'integration_name', 'unknown')
            filename = f"reconciliation_failures_{integration_name}_{timestamp}.json"

            # Save to current working directory or a reports directory
            filepath = os.path.join(os.getcwd(), filename)

            # Prepare report data
            report_data = {
                "report_timestamp": datetime.now().isoformat(),
                "integration_name": integration_name,
                "total_failed_endpoints": len(self.failed_endpoints),
                "failed_endpoints": self.failed_endpoints,
                "summary": {
                    "endpoints_with_count_mismatch": [
                        ep for ep in self.failed_endpoints
                        if ep.get('api_count') is not None and ep.get('difference') is not None
                    ],
                    "endpoints_with_api_errors": [
                        ep for ep in self.failed_endpoints
                        if ep.get('api_count') is None
                    ]
                }
            }

            # Write to file
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(report_data, f, indent=2, ensure_ascii=False)

            # Log the filename for user visibility
            logger.error(f"❌ RECONCILIATION FAILURES DETECTED: {len(self.failed_endpoints)} endpoints failed")
            logger.error(f"📄 Failed endpoints report saved to: {filepath}")
            logger.error(f"📊 Summary: {len(report_data['summary']['endpoints_with_count_mismatch'])} count mismatches, "
                        f"{len(report_data['summary']['endpoints_with_api_errors'])} API errors")

            return filepath

        except Exception as e:
            error_msg = f"Failed to save reconciliation failures report: {str(e)}"
            logger.error(f"{error_msg}\n{traceback.format_exc()}")
            return None