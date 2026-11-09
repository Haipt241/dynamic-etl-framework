"""
Custom exceptions for retry system

Defines enterprise-level exception hierarchy for retry systems.
"""

from typing import Optional, Any, Dict


class RetryError(Exception):
    """Base exception for retry system errors"""
    
    def __init__(self, message: str, context: Optional[Dict[str, Any]] = None):
        super().__init__(message)
        self.message = message
        self.context = context or {}
        
    def __str__(self) -> str:
        if self.context:
            context_str = ", ".join(f"{k}={v}" for k, v in self.context.items())
            return f"{self.message} (Context: {context_str})"
        return self.message


class MaxRetriesExceededError(RetryError):
    """Raised when maximum retry attempts have been exceeded"""
    
    def __init__(self, function_name: str, max_attempts: int, 
                 last_exception: Exception, attempts_made: int = None):
        self.function_name = function_name
        self.max_attempts = max_attempts
        self.last_exception = last_exception
        self.attempts_made = attempts_made or max_attempts
        
        message = (f"Function '{function_name}' failed after {self.attempts_made} attempts "
                  f"(max: {max_attempts}). Last error: {str(last_exception)}")
        
        context = {
            'function': function_name,
            'max_attempts': max_attempts,
            'attempts_made': self.attempts_made,
            'last_exception_type': type(last_exception).__name__
        }
        
        super().__init__(message, context)


class RetryConfigurationError(RetryError):
    """Raised when retry configuration is invalid"""
    
    def __init__(self, config_issue: str, config_data: Optional[Dict] = None):
        self.config_issue = config_issue
        self.config_data = config_data or {}
        
        message = f"Retry configuration error: {config_issue}"
        context = {'config_data': self.config_data}
        
        super().__init__(message, context)


class RetryableError(Exception):
    """
    Base class for exceptions that should trigger retry
    
    Provides categorization for different types of retryable errors
    """
    
    def __init__(self, message: str, retry_after: Optional[float] = None):
        super().__init__(message)
        self.retry_after = retry_after  # Seconds to wait before retry


class APIRetryableError(RetryableError):
    """API-specific retryable errors (5xx, timeouts, connection issues)"""
    
    def __init__(self, message: str, status_code: Optional[int] = None, 
                 retry_after: Optional[float] = None):
        super().__init__(message, retry_after)
        self.status_code = status_code


class DatabaseRetryableError(RetryableError):
    """Database-specific retryable errors (connection, deadlock, timeout)"""
    
    def __init__(self, message: str, error_code: Optional[str] = None,
                 retry_after: Optional[float] = None):
        super().__init__(message, retry_after)
        self.error_code = error_code


class GenerationRetryableError(RetryableError):
    """Generation-specific retryable errors (LLM timeout, parsing errors)"""
    
    def __init__(self, message: str, generation_type: Optional[str] = None,
                 retry_after: Optional[float] = None):
        super().__init__(message, retry_after)
        self.generation_type = generation_type