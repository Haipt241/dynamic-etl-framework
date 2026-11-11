"""
Database retry monitor

Specialized monitor for database operations following enterprise patterns.
Tracks SQLAlchemy errors, connection issues, and database-specific retry scenarios.
"""

from typing import Dict, Any, Optional
from dynamic_integrations.reliability.monitors.base_monitor import BaseRetryMonitor, RetryAttempt, OperationRecord


class DatabaseMonitor(BaseRetryMonitor):
    """
    Monitor for database retry operations
    
    Tracks database-specific metrics like connection errors, deadlocks,
    timeout errors, and other SQLAlchemy-related issues.
    Follows enterprise's database operation monitoring patterns.
    """
    
    def __init__(self, operation_name: str, config: Optional[Any] = None,
                 integration_name: Optional[str] = None):
        """Initialize database monitor"""
        super().__init__(operation_name, config, integration_name)
        
        # Database-specific statistics
        self._connection_error_count = 0
        self._deadlock_count = 0
        self._timeout_count = 0
        self._integrity_error_count = 0
        self._operational_error_count = 0
        self._programming_error_count = 0
        self._sqlalchemy_error_count = 0
        
        # Track error types
        self._error_type_counts: Dict[str, int] = {}
    
    def log_database_error(self, attempt_number: int, exception: Exception,
                          error_code: Optional[str] = None,
                          query: Optional[str] = None,
                          delay_seconds: Optional[float] = None) -> None:
        """
        Log a database error attempt
        
        Args:
            attempt_number: The attempt number
            exception: The database exception that occurred
            error_code: Database-specific error code
            query: SQL query that failed (truncated for logging)
            delay_seconds: Delay before next retry
        """
        exception_type = type(exception).__name__
        
        # Count specific error types (enterprise style categorization)
        if "connection" in str(exception).lower() or "connect" in str(exception).lower():
            self._connection_error_count += 1
        elif "deadlock" in str(exception).lower():
            self._deadlock_count += 1
        elif "timeout" in str(exception).lower():
            self._timeout_count += 1
        elif "integrity" in str(exception).lower():
            self._integrity_error_count += 1
        
        # Count by exception type
        if exception_type == "OperationalError":
            self._operational_error_count += 1
        elif exception_type == "ProgrammingError":
            self._programming_error_count += 1
        elif "SQLAlchemyError" in exception_type:
            self._sqlalchemy_error_count += 1
        
        # Track all error types
        self._error_type_counts[exception_type] = self._error_type_counts.get(exception_type, 0) + 1
        
        # Add to current operation context
        if self.current_operation:
            if 'database_errors' not in self.current_operation.context:
                self.current_operation.context['database_errors'] = []
            
            error_info = {
                'attempt': attempt_number,
                'exception_type': exception_type,
                'error_code': error_code,
                'query_snippet': query[:100] + "..." if query and len(query) > 100 else query
            }
            self.current_operation.context['database_errors'].append(error_info)
        
        # Use base class logging
        self.log_attempt(attempt_number, exception, delay_seconds)
    
    def log_connection_pool_error(self, attempt_number: int, pool_status: Optional[Dict] = None,
                                 delay_seconds: Optional[float] = None) -> None:
        """
        Log a connection pool error
        
        Args:
            attempt_number: The attempt number
            pool_status: Connection pool status information
            delay_seconds: Delay before next retry
        """
        self._connection_error_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'pool_errors' not in self.current_operation.context:
                self.current_operation.context['pool_errors'] = []
                
            self.current_operation.context['pool_errors'].append({
                'attempt': attempt_number,
                'pool_status': pool_status
            })
        
        # Create mock exception for base logging
        class ConnectionPoolError(Exception):
            pass
        
        pool_info = f" (pool: {pool_status})" if pool_status else ""
        mock_exception = ConnectionPoolError(f"Connection pool exhausted{pool_info}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_transaction_rollback(self, attempt_number: int, rollback_reason: str,
                               delay_seconds: Optional[float] = None) -> None:
        """
        Log a transaction rollback
        
        Args:
            attempt_number: The attempt number
            rollback_reason: Reason for the rollback
            delay_seconds: Delay before next retry
        """
        # Add to current operation context
        if self.current_operation:
            if 'rollbacks' not in self.current_operation.context:
                self.current_operation.context['rollbacks'] = []
                
            self.current_operation.context['rollbacks'].append({
                'attempt': attempt_number,
                'reason': rollback_reason
            })
        
        # Create mock exception for base logging
        class TransactionRollbackError(Exception):
            pass
        
        mock_exception = TransactionRollbackError(f"Transaction rollback: {rollback_reason}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get database-specific statistics"""
        base_stats = super().get_statistics()
        
        # Add database-specific metrics
        db_stats = {
            'connection_error_count': self._connection_error_count,
            'deadlock_count': self._deadlock_count,
            'timeout_count': self._timeout_count,
            'integrity_error_count': self._integrity_error_count,
            'operational_error_count': self._operational_error_count,
            'programming_error_count': self._programming_error_count,
            'sqlalchemy_error_count': self._sqlalchemy_error_count,
            'error_type_counts': dict(self._error_type_counts),
            'most_common_error_type': None,
            'connection_reliability': 0.0
        }
        
        # Find most common error type
        if self._error_type_counts:
            most_common = max(self._error_type_counts.items(), key=lambda x: x[1])
            db_stats['most_common_error_type'] = most_common[0]
        
        # Calculate connection reliability (operations without connection errors)
        if self._total_operations > 0:
            operations_without_connection_errors = self._total_operations - self._connection_error_count
            db_stats['connection_reliability'] = round(
                (operations_without_connection_errors / self._total_operations) * 100, 2
            )
        
        # Merge with base statistics
        base_stats.update(db_stats)
        return base_stats
    
    # Implementation of abstract methods (enterprise style)
    
    def _log_operation_start(self) -> None:
        """Log database operation start"""
        print(f"🗄️ Database Monitor: Starting operation '{self.operation_name}'")
        
        # Try to integrate with enterprise logging (sql_helper)
        try:
            from dynamic_integrations.database.sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="DB_RETRY_START",
                StatusMessage=f"Starting database operation: {self.operation_name}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "DB_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_attempt(self, attempt: RetryAttempt) -> None:
        """Log database retry attempt"""
        status_emoji = "❌" if attempt.exception_type else "✅"
        delay_info = f" (delay: {attempt.delay_seconds:.2f}s)" if attempt.delay_seconds else ""
        
        print(f"🗄️ Database Monitor: {status_emoji} Attempt {attempt.attempt_number} "
              f"for '{self.operation_name}'{delay_info}")
        
        if attempt.exception_type:
            print(f"   Error: {attempt.exception_type} - {attempt.exception_message}")
            
            # enterprise-style detailed error categorization logging
            error_category = self._categorize_database_error(attempt.exception_type, attempt.exception_message)
            if error_category:
                print(f"   Category: {error_category}")
    
    def _log_success(self) -> None:
        """Log database operation success"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" in {duration:.2f}s" if duration else ""
        
        print(f"🗄️ Database Monitor: ✅ Operation '{self.operation_name}' succeeded "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        
        # Try to integrate with enterprise logging
        try:
            from dynamic_integrations.database.sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="DB_RETRY_SUCCESS", 
                StatusMessage=f"Database operation succeeded: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts)",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "DB_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_failure(self, exception: Exception) -> None:
        """Log database operation failure"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" after {duration:.2f}s" if duration else ""
        
        print(f"🗄️ Database Monitor: ❌ Operation '{self.operation_name}' failed "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        print(f"   Final error: {type(exception).__name__} - {str(exception)}")
        
        # Try to integrate with enterprise logging
        try:
            from dynamic_integrations.database.sql_helper import LoggingDetails
            error_list = [str(exception)]
            LoggingDetails(
                TaskName="DB_RETRY_FAILURE",
                StatusMessage=f"Database operation failed: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts) - {str(exception)}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=error_list,
                integration_name=self.integration_name or "DB_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_operation_end(self, operation: OperationRecord) -> None:
        """Log database operation end"""
        status = "SUCCESS" if operation.success else "FAILURE"
        duration_str = f" ({operation.duration_seconds:.2f}s)" if operation.duration_seconds else ""
        
        print(f"🗄️ Database Monitor: Operation '{operation.operation_name}' ended - "
              f"{status}{duration_str}")
        
        # Print summary of database-specific errors if any occurred
        context = operation.context
        if context.get('database_errors'):
            print(f"   Database errors: {len(context['database_errors'])}")
            # Show error breakdown
            error_types = {}
            for error in context['database_errors']:
                error_type = error['exception_type']
                error_types[error_type] = error_types.get(error_type, 0) + 1
            for error_type, count in error_types.items():
                print(f"     {error_type}: {count}")
                
        if context.get('pool_errors'):
            print(f"   Connection pool errors: {len(context['pool_errors'])}")
        if context.get('rollbacks'):
            print(f"   Transaction rollbacks: {len(context['rollbacks'])}")
    
    def _categorize_database_error(self, exception_type: str, exception_message: str) -> Optional[str]:
        """
        Categorize database errors (enterprise style)
        
        Returns error category for better error understanding
        """
        if not exception_message:
            return None
            
        message_lower = exception_message.lower()
        
        if "connection" in message_lower or "connect" in message_lower:
            return "Connection Issue"
        elif "deadlock" in message_lower:
            return "Deadlock"  
        elif "timeout" in message_lower:
            return "Timeout"
        elif "lock" in message_lower and "wait" in message_lower:
            return "Lock Wait Timeout"
        elif "integrity" in message_lower or "constraint" in message_lower:
            return "Data Integrity"
        elif "syntax" in message_lower:
            return "SQL Syntax Error"
        elif "permission" in message_lower or "access" in message_lower:
            return "Permission Denied"
        elif "table" in message_lower and "exist" in message_lower:
            return "Schema Issue"
        else:
            return "Other Database Error"