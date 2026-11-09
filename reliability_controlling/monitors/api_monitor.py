"""
API retry monitor

Specialized monitor for API operations with HTTP-specific tracking.
Handles gateway errors, timeouts, and other API-specific retry scenarios.
"""

from typing import Dict, Any, Optional
from .base_monitor import BaseRetryMonitor, RetryAttempt, OperationRecord


class APIMonitor(BaseRetryMonitor):
    """
    Monitor for API retry operations
    
    Tracks HTTP-specific metrics like status codes, response times,
    and gateway errors. Useful for monitoring API calls that may
    encounter 502, 503, 504 errors, timeouts, and connection issues.
    """
    
    def __init__(self, operation_name: str, config: Optional[Any] = None,
                 integration_name: Optional[str] = None):
        """Initialize API monitor"""
        super().__init__(operation_name, config, integration_name)
        
        # API-specific statistics
        self._http_status_counts: Dict[int, int] = {}
        self._timeout_count = 0
        self._connection_error_count = 0
        self._gateway_error_count = 0
    
    def log_http_error(self, attempt_number: int, status_code: int, 
                      response_time: Optional[float] = None,
                      delay_seconds: Optional[float] = None) -> None:
        """
        Log an HTTP error attempt
        
        Args:
            attempt_number: The attempt number
            status_code: HTTP status code received
            response_time: Response time in seconds
            delay_seconds: Delay before next retry
        """
        # Track status code statistics
        self._http_status_counts[status_code] = self._http_status_counts.get(status_code, 0) + 1
        
        # Track gateway errors specifically (502, 503, 504)
        if status_code in [502, 503, 504]:
            self._gateway_error_count += 1
        
        # Create exception representation
        exception_msg = f"HTTP {status_code}"
        if response_time:
            exception_msg += f" (response_time: {response_time:.2f}s)"
        
        # Add to current operation context
        if self.current_operation:
            if 'http_errors' not in self.current_operation.context:
                self.current_operation.context['http_errors'] = []
            
            self.current_operation.context['http_errors'].append({
                'attempt': attempt_number,
                'status_code': status_code,
                'response_time': response_time
            })
        
        # Create mock exception for base logging
        class HTTPError(Exception):
            def __init__(self, status_code: int, response_time: Optional[float] = None):
                self.status_code = status_code
                self.response_time = response_time
                super().__init__(f"HTTP {status_code}")
        
        mock_exception = HTTPError(status_code, response_time)
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_timeout_error(self, attempt_number: int, timeout_type: str = "general",
                         timeout_seconds: Optional[float] = None,
                         delay_seconds: Optional[float] = None) -> None:
        """
        Log a timeout error
        
        Args:
            attempt_number: The attempt number
            timeout_type: Type of timeout (connect, read, general)
            timeout_seconds: Timeout value that was exceeded
            delay_seconds: Delay before next retry
        """
        self._timeout_count += 1
        
        exception_msg = f"Timeout ({timeout_type})"
        if timeout_seconds:
            exception_msg += f" after {timeout_seconds}s"
        
        # Add to current operation context
        if self.current_operation:
            if 'timeouts' not in self.current_operation.context:
                self.current_operation.context['timeouts'] = []
                
            self.current_operation.context['timeouts'].append({
                'attempt': attempt_number,
                'timeout_type': timeout_type,
                'timeout_seconds': timeout_seconds
            })
        
        # Create mock exception for base logging
        class TimeoutError(Exception):
            pass
        
        mock_exception = TimeoutError(exception_msg)
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_connection_error(self, attempt_number: int, error_type: str = "connection",
                           delay_seconds: Optional[float] = None) -> None:
        """
        Log a connection error
        
        Args:
            attempt_number: The attempt number
            error_type: Type of connection error
            delay_seconds: Delay before next retry
        """
        self._connection_error_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'connection_errors' not in self.current_operation.context:
                self.current_operation.context['connection_errors'] = []
                
            self.current_operation.context['connection_errors'].append({
                'attempt': attempt_number,
                'error_type': error_type
            })
        
        # Create mock exception for base logging
        class ConnectionError(Exception):
            pass
        
        mock_exception = ConnectionError(f"Connection error: {error_type}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get API-specific statistics"""
        base_stats = super().get_statistics()
        
        # Add API-specific metrics
        api_stats = {
            'http_status_counts': dict(self._http_status_counts),
            'timeout_count': self._timeout_count,
            'connection_error_count': self._connection_error_count,
            'gateway_error_count': self._gateway_error_count,
            'most_common_status_code': None,
            'gateway_error_rate': 0.0
        }
        
        # Find most common status code
        if self._http_status_counts:
            most_common = max(self._http_status_counts.items(), key=lambda x: x[1])
            api_stats['most_common_status_code'] = most_common[0]
        
        # Calculate gateway error rate
        total_errors = sum(self._http_status_counts.values())
        if total_errors > 0:
            api_stats['gateway_error_rate'] = round(
                (self._gateway_error_count / total_errors) * 100, 2
            )
        
        # Merge with base statistics
        base_stats.update(api_stats)
        return base_stats
    
    # Implementation of abstract methods
    
    def _log_operation_start(self) -> None:
        """Log API operation start"""
        print(f"🌐 API Monitor: Starting operation '{self.operation_name}'")
        
        # Try to integrate with sql_helper logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="API_RETRY_START",
                StatusMessage=f"Starting API operation: {self.operation_name}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "API_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_attempt(self, attempt: RetryAttempt) -> None:
        """Log API retry attempt"""
        status_emoji = "❌" if attempt.exception_type else "✅"
        delay_info = f" (delay: {attempt.delay_seconds:.2f}s)" if attempt.delay_seconds else ""
        
        print(f"🌐 API Monitor: {status_emoji} Attempt {attempt.attempt_number} "
              f"for '{self.operation_name}'{delay_info}")
        
        if attempt.exception_type:
            print(f"   Error: {attempt.exception_type} - {attempt.exception_message}")
    
    def _log_success(self) -> None:
        """Log API operation success"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" in {duration:.2f}s" if duration else ""
        
        print(f"🌐 API Monitor: ✅ Operation '{self.operation_name}' succeeded "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        
        # Try to integrate with sql_helper logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="API_RETRY_SUCCESS",
                StatusMessage=f"API operation succeeded: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts)",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "API_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_failure(self, exception: Exception) -> None:
        """Log API operation failure"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" after {duration:.2f}s" if duration else ""
        
        print(f"🌐 API Monitor: ❌ Operation '{self.operation_name}' failed "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        print(f"   Final error: {type(exception).__name__} - {str(exception)}")
        
        # Try to integrate with sql_helper logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="API_RETRY_FAILURE",
                StatusMessage=f"API operation failed: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts) - {str(exception)}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[str(exception)],
                integration_name=self.integration_name or "API_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_operation_end(self, operation: OperationRecord) -> None:
        """Log API operation end"""
        status = "SUCCESS" if operation.success else "FAILURE"
        duration_str = f" ({operation.duration_seconds:.2f}s)" if operation.duration_seconds else ""
        
        print(f"🌐 API Monitor: Operation '{operation.operation_name}' ended - "
              f"{status}{duration_str}")
        
        # Print summary of API-specific errors if any occurred
        context = operation.context
        if context.get('http_errors'):
            print(f"   HTTP errors: {len(context['http_errors'])}")
        if context.get('timeouts'):
            print(f"   Timeouts: {len(context['timeouts'])}")  
        if context.get('connection_errors'):
            print(f"   Connection errors: {len(context['connection_errors'])}")