"""
API exception handler

Specialized handler for API-related exceptions including HTTP errors,
timeouts, and gateway issues. Follows enterprise patterns for API retry logic.
"""

from typing import Dict, Any, Optional, List, Type

import requests

from .base_handler import BaseExceptionHandler
from ..core.exceptions import APIRetryableError


class APIExceptionHandler(BaseExceptionHandler):
    """
    Handler for API-related exceptions
    
    Handles HTTP status codes, timeouts, connection errors, and other
    API-specific issues with appropriate retry strategies.
    """
    
    # HTTP status codes that should trigger retry
    RETRYABLE_STATUS_CODES = {
        429,  # Too Many Requests
        500,  # Internal Server Error
        502,  # Bad Gateway
        503,  # Service Unavailable
        504,  # Gateway Timeout
    }
    
    # Status codes that should NOT trigger retry
    NON_RETRYABLE_STATUS_CODES = {
        400,  # Bad Request
        401,  # Unauthorized
        403,  # Forbidden
        404,  # Not Found
        405,  # Method Not Allowed
        409,  # Conflict
        422,  # Unprocessable Entity
    }
    
    def __init__(self, next_handler: Optional[BaseExceptionHandler] = None,
                 custom_retryable_codes: Optional[List[int]] = None,
                 custom_non_retryable_codes: Optional[List[int]] = None):
        """
        Initialize API handler
        
        Args:
            next_handler: Next handler in the chain
            custom_retryable_codes: Additional status codes to retry on
            custom_non_retryable_codes: Additional status codes to not retry on
        """
        super().__init__(next_handler)
        
        # Allow customization of status codes
        if custom_retryable_codes:
            self.RETRYABLE_STATUS_CODES = self.RETRYABLE_STATUS_CODES.union(set(custom_retryable_codes))
        if custom_non_retryable_codes:
            self.NON_RETRYABLE_STATUS_CODES = self.NON_RETRYABLE_STATUS_CODES.union(set(custom_non_retryable_codes))
    
    def can_handle(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> bool:
        """Check if this is an API-related exception"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Check for HTTP-related exceptions
        if any(term in exception_name for term in [
            'http', 'request', 'connection', 'timeout', 'url'
        ]):
            return True
        
        # Check for specific HTTP status codes in message
        if any(f" {code}" in exception_message for code in self.RETRYABLE_STATUS_CODES):
            return True
        
        # Check for common API error patterns
        if any(term in exception_message for term in [
            'gateway', 'server error', 'service unavailable', 
            'too many requests', 'rate limit', 'connection reset',
            'connection refused', 'connection timeout', 'read timeout'
        ]):
            return True
        
        # Check for specific exception types (if available)
        try:
            if isinstance(exception, (
                requests.RequestException,
                requests.HTTPError, 
                requests.ConnectionError,
                requests.Timeout,
                requests.ConnectTimeout,
                requests.ReadTimeout
            )):
                return True
        except ImportError:
            pass
        
        return False
    
    def _handle_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Handle API exception"""
        result = {
            'handler': self.get_handler_name(),
            'exception_type': type(exception).__name__,
            'should_retry': False,
            'delay_seconds': 0.0,
            'reason': 'Unknown API error',
            'category': 'api_error'
        }
        
        # Extract status code if available
        status_code = self._extract_status_code(exception)
        if status_code:
            result['status_code'] = status_code
            result['category'] = self._categorize_status_code(status_code)
        
        # Determine if should retry
        result['should_retry'] = self._should_retry_api_exception(exception, status_code, context)
        
        # Set reason and delay
        if result['should_retry']:
            result['reason'] = self._get_retry_reason(exception, status_code)
            result['delay_seconds'] = self._calculate_api_delay(exception, status_code, context)
        else:
            result['reason'] = self._get_no_retry_reason(exception, status_code)
        
        return result

    @staticmethod
    def _extract_status_code(exception: Exception) -> Optional[int]:
        """Extract HTTP status code from exception"""
        # Try to get from requests exceptions
        if hasattr(exception, 'response'):
            response = getattr(exception, 'response', None)
            if response is not None and hasattr(response, 'status_code'):
                return getattr(response, 'status_code', None)
        
        # Try to parse from exception message
        import re
        message = str(exception)
        
        # Look for patterns like "HTTP 500", "Status 502", "Code: 503"
        patterns = [
            r'(?:HTTP|Status|Code)(?:\s*:)?\s*(\d{3})',
            r'(\d{3})\s*(?:Server Error|Gateway|Service)',
            r'HTTP\s*(\d{3})'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, message, re.IGNORECASE)
            if match:
                try:
                    return int(match.group(1))
                except (ValueError, IndexError):
                    continue
        
        return None
    
    def _categorize_status_code(self, status_code: int) -> str:
        """Categorize status code"""
        if status_code in [502, 503, 504]:
            return 'gateway_error'
        elif status_code == 429:
            return 'rate_limit'
        elif status_code in [500, 501, 502, 503, 504, 505]:
            return 'server_error'
        elif status_code in [400, 401, 403, 404, 405, 409, 422]:
            return 'client_error'
        else:
            return 'unknown_error'
    
    def _should_retry_api_exception(self, exception: Exception, status_code: Optional[int], 
                                   context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if API exception should trigger retry"""
        # Don't retry if explicitly non-retryable
        if status_code and status_code in self.NON_RETRYABLE_STATUS_CODES:
            return False
        
        # Retry if explicitly retryable
        if status_code and status_code in self.RETRYABLE_STATUS_CODES:
            return True
        
        # Check for timeout-related errors (always retry)
        exception_message = str(exception).lower()
        if any(term in exception_message for term in [
            'timeout', 'connection reset', 'connection refused'
        ]):
            return True
        
        # Check for connection errors (always retry)
        exception_name = type(exception).__name__.lower()
        if any(term in exception_name for term in [
            'connectionerror', 'timeout'
        ]):
            return True
        
        # Default to retry for unknown API errors
        return True
    
    def _calculate_api_delay(self, exception: Exception, status_code: Optional[int],
                           context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay for API retry"""
        base_delay = 1.0
        
        # Longer delays for different types of errors
        if status_code == 429:  # Rate limit
            base_delay = 5.0
        elif status_code in [502, 503, 504]:  # Gateway errors
            base_delay = 3.0
        elif status_code == 500:  # Internal server error
            base_delay = 2.0
        elif 'timeout' in str(exception).lower():  # Timeout errors
            base_delay = 2.0
        
        # Check for Retry-After header if available
        if hasattr(exception, 'response'):
            response = getattr(exception, 'response', None)
            if response is not None and hasattr(response, 'headers'):
                headers = getattr(response, 'headers', None)
                if headers and hasattr(headers, 'get'):
                    retry_after = headers.get('Retry-After')
                    if retry_after:
                        try:
                            return float(retry_after)
                        except (ValueError, TypeError):
                            pass
        
        # Get attempt number from context for exponential backoff
        attempt_number = context.get('attempt_number', 1) if context else 1
        delay = base_delay * (1.5 ** (attempt_number - 1))
        
        # Cap maximum delay
        return min(delay, 60.0)
    
    def _get_retry_reason(self, exception: Exception, status_code: Optional[int]) -> str:
        """Get reason for retrying"""
        if status_code == 429:
            return "Rate limit exceeded - will retry with backoff"
        elif status_code in [502, 503, 504]:
            return f"Gateway error (HTTP {status_code}) - service may be temporarily unavailable"
        elif status_code == 500:
            return "Internal server error - may be temporary"
        elif 'timeout' in str(exception).lower():
            return "Request timeout - will retry with increased timeout"
        elif 'connection' in str(exception).lower():
            return "Connection error - network or service issue may be temporary"
        else:
            return "API error that may be temporary"
    
    def _get_no_retry_reason(self, exception: Exception, status_code: Optional[int]) -> str:
        """Get reason for not retrying"""
        if status_code in [400, 422]:
            return "Bad request - fix request parameters"
        elif status_code in [401, 403]:
            return "Authentication/authorization error - check credentials"
        elif status_code == 404:
            return "Resource not found - check URL/endpoint"
        elif status_code == 409:
            return "Conflict - resource state issue"
        else:
            return "Client error - fix request before retrying"
    
    def should_retry(self, exception: Exception, attempt_number: int,
                    context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if should retry with attempt limit"""
        if not self.can_handle(exception, context):
            return False
        
        # Don't exceed maximum attempts
        max_attempts = 5  # API operations can have more attempts
        if attempt_number >= max_attempts:
            return False
        
        # Use detailed retry logic
        handling_result = self._handle_exception(exception, context)
        return handling_result.get('should_retry', False)
    
    def calculate_delay(self, exception: Exception, attempt_number: int,
                       base_delay: float = 1.0, context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay with API-specific logic"""
        if not self.can_handle(exception, context):
            return super().calculate_delay(exception, attempt_number, base_delay, context)
        
        # Add attempt number to context
        if context is None:
            context = {}
        context['attempt_number'] = attempt_number
        
        status_code = self._extract_status_code(exception)
        return self._calculate_api_delay(exception, status_code, context)
    
    def transform_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Exception:
        """Transform to API-specific retryable exception"""
        if not self.can_handle(exception, context):
            return exception
        
        status_code = self._extract_status_code(exception)
        handling_result = self._handle_exception(exception, context)
        retry_after = handling_result.get('delay_seconds', 0.0)
        
        return APIRetryableError(
            message=str(exception),
            status_code=status_code,
            retry_after=retry_after
        )
    
    def get_supported_exceptions(self) -> List[Type[Exception]]:
        """Get supported exception types"""
        supported = [Exception]  # Fallback for any exception
        
        try:
            import requests
            supported.extend([
                requests.RequestException,
                requests.HTTPError,
                requests.ConnectionError,
                requests.Timeout,
                requests.ConnectTimeout,
                requests.ReadTimeout
            ])
        except ImportError:
            pass
        
        return supported