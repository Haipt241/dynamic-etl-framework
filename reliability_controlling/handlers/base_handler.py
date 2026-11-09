"""
Base exception handler

Abstract base class for exception-specific retry handlers.
Implements Chain of Responsibility pattern.
"""

from abc import ABC, abstractmethod
from typing import Optional, Any, Dict, List, Type
from ..core.exceptions import RetryableError


class BaseExceptionHandler(ABC):
    """
    Abstract base class for exception handlers
    
    Implements Chain of Responsibility pattern where each handler
    can decide whether to handle an exception or pass it to the next handler.
    """
    
    def __init__(self, next_handler: Optional['BaseExceptionHandler'] = None):
        """
        Initialize handler
        
        Args:
            next_handler: Next handler in the chain
        """
        self._next_handler = next_handler
    
    def set_next(self, handler: 'BaseExceptionHandler') -> 'BaseExceptionHandler':
        """
        Set the next handler in the chain
        
        Args:
            handler: Next handler to set
            
        Returns:
            The handler for method chaining
        """
        self._next_handler = handler
        return handler
    
    def handle(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Optional[Dict[str, Any]]:
        """
        Handle an exception
        
        Args:
            exception: The exception to handle
            context: Additional context information
            
        Returns:
            Handling result or None if not handled
        """
        if self.can_handle(exception, context):
            return self._handle_exception(exception, context)
        elif self._next_handler:
            return self._next_handler.handle(exception, context)
        else:
            return None
    
    @abstractmethod
    def can_handle(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> bool:
        """
        Check if this handler can handle the exception
        
        Args:
            exception: The exception to check
            context: Additional context information
            
        Returns:
            True if this handler can handle the exception
        """
        pass
    
    @abstractmethod
    def _handle_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Handle the exception (implementation by subclasses)
        
        Args:
            exception: The exception to handle
            context: Additional context information
            
        Returns:
            Dictionary with handling results
        """
        pass
    
    def get_supported_exceptions(self) -> List[Type[Exception]]:
        """
        Get list of exception types supported by this handler
        
        Returns:
            List of exception types
        """
        return []
    
    def get_handler_name(self) -> str:
        """
        Get the name of this handler
        
        Returns:
            Handler name
        """
        return self.__class__.__name__
    
    def should_retry(self, exception: Exception, attempt_number: int, 
                    context: Optional[Dict[str, Any]] = None) -> bool:
        """
        Determine if the exception should trigger a retry
        
        Args:
            exception: The exception that occurred
            attempt_number: Current attempt number
            context: Additional context information
            
        Returns:
            True if should retry, False otherwise
        """
        # Default implementation - can be overridden by subclasses
        return self.can_handle(exception, context) and attempt_number < 3
    
    def calculate_delay(self, exception: Exception, attempt_number: int,
                       base_delay: float = 1.0, context: Optional[Dict[str, Any]] = None) -> float:
        """
        Calculate delay before next retry attempt
        
        Args:
            exception: The exception that occurred
            attempt_number: Current attempt number
            base_delay: Base delay in seconds
            context: Additional context information
            
        Returns:
            Delay in seconds
        """
        # Default exponential backoff - can be overridden by subclasses
        return min(base_delay * (2 ** (attempt_number - 1)), 60.0)
    
    def transform_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Exception:
        """
        Transform exception into a more specific retry-aware exception
        
        Args:
            exception: Original exception
            context: Additional context information
            
        Returns:
            Transformed exception (may be the same as input)
        """
        # Default implementation returns the same exception
        return exception