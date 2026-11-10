"""
Database exception handler

Specialized handler for database-related exceptions following enterprise patterns.
Handles SQLAlchemy errors, connection issues, and database-specific retry scenarios.
"""

from typing import Dict, Any, Optional, List, Type

import pymysql

from dynamic_integrations.reliability.handlers.base_handler import BaseExceptionHandler
from dynamic_integrations.reliability.core.exceptions import DatabaseRetryableError
from sqlalchemy.exc import (
    SQLAlchemyError, OperationalError, ProgrammingError,
    IntegrityError, DataError, DatabaseError
)


class DatabaseExceptionHandler(BaseExceptionHandler):
    """
    Handler for database-related exceptions
    
    Handles SQLAlchemy errors, connection issues, deadlocks, timeouts,
    and other database-specific issues with appropriate retry strategies.
    Follows enterprise database error handling patterns.
    """
    
    # Database errors that should trigger retry
    RETRYABLE_ERROR_PATTERNS = [
        # Connection errors
        'connection', 'connect', 'lost connection', 'broken pipe',
        'connection reset', 'connection refused', 'connection timeout',
        
        # Deadlock errors
        'deadlock', 'lock wait timeout', 'lock timeout',
        
        # Timeout errors  
        'timeout', 'query timeout', 'execution timeout',
        
        # Temporary errors
        'temporary', 'transient', 'retry',
        
        # Server errors
        'server has gone away', 'server closed', 'server shutdown',
        
        # Pool errors
        'pool', 'connection pool'
    ]
    
    # Errors that should NOT trigger retry
    NON_RETRYABLE_ERROR_PATTERNS = [
        # Syntax errors
        'syntax error', 'sql syntax', 'parse error',
        
        # Permission errors
        'access denied', 'permission denied', 'unauthorized',
        
        # Data integrity errors (depending on context)
        'unique constraint', 'foreign key constraint', 
        'check constraint', 'not null constraint',
        
        # Schema errors
        'table does not exist', 'column does not exist',
        'database does not exist', 'unknown column',
        
        # Data type errors
        'data too long', 'out of range', 'invalid data type'
    ]
    
    def can_handle(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> bool:
        """Check if this is a database-related exception"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Check for SQLAlchemy exceptions
        if any(term in exception_name for term in [
            'sqlalchemy', 'operational', 'programming', 'database',
            'integrity', 'connection', 'timeout'
        ]):
            return True
        
        # Check for database-related terms in message
        if any(pattern in exception_message for pattern in [
            'mysql', 'postgresql', 'sqlite', 'oracle', 'sql server',
            'connection', 'database', 'query', 'table', 'column'
        ]):
            return True
        
        # Check for specific SQLAlchemy exception types (if available)
        try:
            if isinstance(exception, (
                SQLAlchemyError, OperationalError, ProgrammingError,
                IntegrityError, DataError, DatabaseError
            )):
                return True
        except ImportError:
            pass
        
        # Check for PyMySQL/pymysql exceptions
        try:
            if isinstance(exception, pymysql.Error):
                return True
        except ImportError:
            pass
        
        return False
    
    def _handle_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Handle database exception"""
        result = {
            'handler': self.get_handler_name(),
            'exception_type': type(exception).__name__,
            'should_retry': False,
            'delay_seconds': 0.0,
            'reason': 'Unknown database error',
            'category': 'database_error'
        }
        
        # Extract error details
        error_code = self._extract_error_code(exception)
        if error_code:
            result['error_code'] = error_code
        
        # Categorize the error
        result['category'] = self._categorize_database_error(exception)
        
        # Determine if should retry
        result['should_retry'] = self._should_retry_database_exception(exception, context)
        
        # Set reason and delay
        if result['should_retry']:
            result['reason'] = self._get_retry_reason(exception)
            result['delay_seconds'] = self._calculate_database_delay(exception, context)
        else:
            result['reason'] = self._get_no_retry_reason(exception)
        
        return result
    
    def _extract_error_code(self, exception: Exception) -> Optional[str]:
        """Extract database error code from exception"""
        # Try to get error code from different database drivers
        if hasattr(exception, 'orig') and hasattr(exception.orig, 'args'):
            # SQLAlchemy wrapped exception
            args = exception.orig.args
            if args and isinstance(args[0], (int, str)):
                return str(args[0])
        
        if hasattr(exception, 'args') and exception.args:
            # Direct database exception
            first_arg = exception.args[0]
            if isinstance(first_arg, (int, str)):
                return str(first_arg)
        
        return None
    
    def _categorize_database_error(self, exception: Exception) -> str:
        """Categorize database error (enterprise style)"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Connection issues
        if any(term in exception_message for term in [
            'connection', 'connect', 'lost connection', 'broken pipe'
        ]) or 'connection' in exception_name:
            return 'connection_error'
        
        # Deadlocks
        if any(term in exception_message for term in [
            'deadlock', 'lock wait', 'lock timeout'
        ]):
            return 'deadlock'
        
        # Timeouts
        if 'timeout' in exception_message or 'timeout' in exception_name:
            return 'timeout'
        
        # Integrity constraints
        if any(term in exception_message for term in [
            'constraint', 'unique', 'foreign key', 'check constraint'
        ]) or 'integrity' in exception_name:
            return 'integrity_error'
        
        # Programming errors (SQL syntax, etc.)
        if any(term in exception_message for term in [
            'syntax', 'parse', 'column', 'table does not exist'
        ]) or 'programming' in exception_name:
            return 'programming_error'
        
        # Operational errors (general database issues)
        if 'operational' in exception_name:
            return 'operational_error'
        
        return 'unknown_database_error'
    
    def _should_retry_database_exception(self, exception: Exception, 
                                       context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if database exception should trigger retry (enterprise logic)"""
        exception_message = str(exception).lower()
        
        # Don't retry non-retryable patterns
        if any(pattern in exception_message for pattern in self.NON_RETRYABLE_ERROR_PATTERNS):
            return False
        
        # Retry retryable patterns
        if any(pattern in exception_message for pattern in self.RETRYABLE_ERROR_PATTERNS):
            return True
        
        # Check specific exception types (enterprise approach)
        exception_name = type(exception).__name__
        
        # Always retry these (matching enterprise retry patterns)
        if exception_name in ['OperationalError', 'ProgrammingError', 'SQLAlchemyError']:
            # But not if it's a clear programming error
            if not any(pattern in exception_message for pattern in [
                'syntax error', 'table does not exist', 'column does not exist'
            ]):
                return True
        
        # Check for specific error codes that should be retried
        error_code = self._extract_error_code(exception)
        if error_code:
            # MySQL error codes that should be retried
            retryable_codes = [
                '1040',  # Too many connections
                '1205',  # Lock wait timeout
                '1213',  # Deadlock  
                '2003',  # Can't connect to server
                '2006',  # Server has gone away
                '2013',  # Lost connection during query
            ]
            if error_code in retryable_codes:
                return True
        
        # Default to not retry for unknown database errors
        return False
    
    def _calculate_database_delay(self, exception: Exception, 
                                context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay for database retry (enterprise style)"""
        exception_message = str(exception).lower()
        base_delay = 2.0  # Enterprise pattern starts with lighter delays
        
        # Longer delays for different types of errors
        if 'deadlock' in exception_message:
            base_delay = 1.0  # Quick retry for deadlocks
        elif 'connection' in exception_message:
            base_delay = 5.0  # Longer for connection issues
        elif 'timeout' in exception_message:
            base_delay = 3.0  # Medium for timeouts
        elif 'server has gone away' in exception_message:
            base_delay = 10.0  # Long for server issues
        
        # Get attempt number from context for exponential backoff (enterprise style)
        attempt_number = context.get('attempt_number', 1) if context else 1
        
        # Enterprise pattern uses exponential backoff with configurable parameters
        # We use a more moderate approach: multiplier=2, min=base_delay, max=300
        delay = base_delay * (2 ** (attempt_number - 1))
        
        # Cap maximum delay (enterprise pattern uses max=300)
        return min(delay, 300.0)
    
    def _get_retry_reason(self, exception: Exception) -> str:
        """Get reason for retrying"""
        exception_message = str(exception).lower()
        
        if 'connection' in exception_message:
            return "Database connection error - may recover automatically"
        elif 'deadlock' in exception_message:
            return "Database deadlock detected - will retry transaction"
        elif 'timeout' in exception_message:
            return "Database operation timeout - will retry with backoff"
        elif 'server has gone away' in exception_message:
            return "Database server connection lost - will attempt to reconnect"
        elif 'lock wait timeout' in exception_message:
            return "Lock wait timeout - will retry after delay"
        elif 'too many connections' in exception_message:
            return "Database connection pool exhausted - will retry after delay"
        else:
            return "Transient database error - may recover on retry"
    
    def _get_no_retry_reason(self, exception: Exception) -> str:
        """Get reason for not retrying"""
        exception_message = str(exception).lower()
        
        if 'syntax error' in exception_message or 'parse error' in exception_message:
            return "SQL syntax error - fix query syntax"
        elif 'table does not exist' in exception_message:
            return "Table does not exist - check schema"
        elif 'column does not exist' in exception_message:
            return "Column does not exist - check table structure"
        elif 'access denied' in exception_message:
            return "Database access denied - check permissions"
        elif 'constraint' in exception_message:
            return "Data integrity constraint violation - fix data"
        elif 'data too long' in exception_message:
            return "Data exceeds column length - truncate data"
        else:
            return "Permanent database error - requires manual intervention"
    
    def should_retry(self, exception: Exception, attempt_number: int,
                    context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if should retry with attempt limit (enterprise style)"""
        if not self.can_handle(exception, context):
            return False
        
        # Enterprise pattern uses max 3 attempts for database operations
        max_attempts = 3
        if attempt_number >= max_attempts:
            return False
        
        # Use detailed retry logic
        handling_result = self._handle_exception(exception, context)
        return handling_result.get('should_retry', False)
    
    def calculate_delay(self, exception: Exception, attempt_number: int,
                       base_delay: float = 2.0, context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay with database-specific logic"""
        if not self.can_handle(exception, context):
            return super().calculate_delay(exception, attempt_number, base_delay, context)
        
        # Add attempt number to context
        if context is None:
            context = {}
        context['attempt_number'] = attempt_number
        
        return self._calculate_database_delay(exception, context)
    
    def transform_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Exception:
        """Transform to database-specific retryable exception"""
        if not self.can_handle(exception, context):
            return exception
        
        error_code = self._extract_error_code(exception)
        handling_result = self._handle_exception(exception, context)
        retry_after = handling_result.get('delay_seconds', 0.0)
        
        return DatabaseRetryableError(
            message=str(exception),
            error_code=error_code,
            retry_after=retry_after
        )
    
    def get_supported_exceptions(self) -> List[Type[Exception]]:
        """Get supported exception types (enterprise style)"""
        supported = [Exception]  # Fallback
        
        try:
            from sqlalchemy.exc import (
                SQLAlchemyError, OperationalError, ProgrammingError,
                IntegrityError, DataError, DatabaseError
            )
            supported.extend([
                SQLAlchemyError, OperationalError, ProgrammingError,
                IntegrityError, DataError, DatabaseError
            ])
        except ImportError:
            pass
        
        try:
            supported.append(pymysql.Error)
        except ImportError:
            pass
        
        return supported