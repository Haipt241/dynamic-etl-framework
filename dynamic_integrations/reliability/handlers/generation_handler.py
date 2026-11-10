"""
Generation exception handler

Specialized handler for AI/LLM generation exceptions.
Handles parsing errors, timeouts, token limits, and other generation-specific issues.
"""

from typing import Dict, Any, Optional, List, Type
from dynamic_integrations.reliability.handlers.base_handler import BaseExceptionHandler
from dynamic_integrations.reliability.core.exceptions import GenerationRetryableError


class GenerationExceptionHandler(BaseExceptionHandler):
    """
    Handler for AI/LLM generation-related exceptions
    
    Handles parsing errors, LLM timeouts, token limits, service errors,
    and other generation-specific issues with appropriate retry strategies.
    """
    
    # Generation errors that should trigger retry
    RETRYABLE_ERROR_PATTERNS = [
        # Service errors
        'timeout', 'service unavailable', 'server error',
        'connection', 'network', 'temporary',
        
        # LLM service issues
        'rate limit', 'quota exceeded', 'throttled',
        'service busy', 'overloaded',
        
        # Parsing issues (may be temporary)
        'parsing error', 'malformed', 'incomplete response',
        'empty response', 'truncated',
        
        # API issues
        'gateway', 'upstream', 'proxy error'
    ]
    
    # Errors that should NOT trigger retry  
    NON_RETRYABLE_ERROR_PATTERNS = [
        # Configuration errors
        'invalid api key', 'authentication failed', 'unauthorized',
        'access denied', 'permission',
        
        # Model/prompt errors
        'model not found', 'unsupported model', 'invalid model',
        'prompt too long', 'content policy', 'safety filter',
        
        # Hard token limits
        'maximum context length', 'context window exceeded',
        
        # Invalid requests
        'bad request', 'invalid parameter', 'malformed request'
    ]
    
    def can_handle(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> bool:
        """Check if this is a generation-related exception"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Check for generation-specific exception names
        if any(term in exception_name for term in [
            'generation', 'parsing', 'llm', 'openai', 'claude',
            'completion', 'response', 'token'
        ]):
            return True
        
        # Check for generation-related terms in message
        if any(term in exception_message for term in [
            'llm', 'language model', 'completion', 'generation',
            'parsing', 'json', 'response', 'token', 'prompt',
            'openai', 'claude', 'gpt', 'model'
        ]):
            return True
        
        # Check context for generation indicators
        if context and context.get('operation_type') == 'generation':
            return True
        
        # Check for JSON parsing errors (common in generation)
        if 'json' in exception_name or 'json' in exception_message:
            return True
        
        return False
    
    def _handle_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Handle generation exception"""
        result = {
            'handler': self.get_handler_name(),
            'exception_type': type(exception).__name__,
            'should_retry': False,
            'delay_seconds': 0.0,
            'reason': 'Unknown generation error',
            'category': 'generation_error'
        }
        
        # Categorize the error
        result['category'] = self._categorize_generation_error(exception)
        
        # Extract generation-specific details
        if context:
            if 'response_content' in context:
                result['response_length'] = len(str(context['response_content']))
            if 'tokens_used' in context:
                result['tokens_used'] = context['tokens_used']
            if 'model' in context:
                result['model'] = context['model']
        
        # Determine if should retry
        result['should_retry'] = self._should_retry_generation_exception(exception, context)
        
        # Set reason and delay
        if result['should_retry']:
            result['reason'] = self._get_retry_reason(exception)
            result['delay_seconds'] = self._calculate_generation_delay(exception, context)
        else:
            result['reason'] = self._get_no_retry_reason(exception)
        
        return result

    @staticmethod
    def _categorize_generation_error(exception: Exception) -> str:
        """Categorize generation error"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Response parsing issues
        if any(term in exception_message for term in [
            'json', 'parsing', 'malformed', 'invalid format'
        ]) or 'json' in exception_name:
            return 'parsing_error'
        
        # LLM service issues
        if any(term in exception_message for term in [
            'rate limit', 'quota', 'throttled', 'service busy'
        ]):
            return 'rate_limit'
        
        # Timeout issues
        if 'timeout' in exception_message or 'timeout' in exception_name:
            return 'timeout'
        
        # Token limit issues
        if any(term in exception_message for term in [
            'token', 'context length', 'context window', 'maximum length'
        ]):
            return 'token_limit'
        
        # Empty or incomplete responses
        if any(term in exception_message for term in [
            'empty', 'no response', 'incomplete', 'truncated'
        ]):
            return 'empty_response'
        
        # Service errors
        if any(term in exception_message for term in [
            'service', 'server', 'gateway', 'upstream'
        ]):
            return 'service_error'
        
        # Authentication/authorization
        if any(term in exception_message for term in [
            'api key', 'authentication', 'unauthorized', 'access denied'
        ]):
            return 'auth_error'
        
        return 'unknown_generation_error'
    
    def _should_retry_generation_exception(self, exception: Exception, 
                                         context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if generation exception should trigger retry"""
        exception_message = str(exception).lower()
        
        # Don't retry non-retryable patterns
        if any(pattern in exception_message for pattern in self.NON_RETRYABLE_ERROR_PATTERNS):
            return False
        
        # Retry retryable patterns
        if any(pattern in exception_message for pattern in self.RETRYABLE_ERROR_PATTERNS):
            return True
        
        # Special handling for specific error types
        category = self._categorize_generation_error(exception)
        
        # Always retry these categories
        if category in ['parsing_error', 'timeout', 'empty_response', 'service_error']:
            return True
        
        # Conditional retry for rate limits (usually retryable)
        if category == 'rate_limit':
            return True
        
        # Don't retry authentication errors or hard token limits
        if category in ['auth_error', 'token_limit']:
            return False
        
        # Default to retry for unknown generation errors (often temporary)
        return True

    @staticmethod
    def _calculate_generation_delay(exception: Exception,
                                  context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay for generation retry"""
        exception_message = str(exception).lower()
        base_delay = 1.0
        
        # Different delays for different error types
        if 'rate limit' in exception_message or 'quota' in exception_message:
            base_delay = 10.0  # Longer delay for rate limits
        elif 'service busy' in exception_message or 'overloaded' in exception_message:
            base_delay = 5.0   # Medium delay for busy service
        elif 'parsing' in exception_message:
            base_delay = 0.5   # Quick retry for parsing errors
        elif 'timeout' in exception_message:
            base_delay = 2.0   # Medium delay for timeouts
        elif 'empty' in exception_message:
            base_delay = 1.0   # Standard delay for empty responses
        
        # Get attempt number from context
        attempt_number = context.get('attempt_number', 1) if context else 1
        
        # Generation operations use less aggressive backoff (fewer retries anyway)
        delay = base_delay * (1.5 ** (attempt_number - 1))
        
        # Cap maximum delay (generation operations should be faster)
        return min(delay, 30.0)

    @staticmethod
    def _get_retry_reason(exception: Exception) -> str:
        """Get reason for retrying"""
        exception_message = str(exception).lower()
        
        if 'rate limit' in exception_message or 'quota' in exception_message:
            return "Rate limit exceeded - will retry with longer delay"
        elif 'parsing' in exception_message:
            return "Response parsing failed - may be incomplete, will retry"
        elif 'timeout' in exception_message:
            return "Generation timeout - will retry with backoff"
        elif 'empty' in exception_message or 'no response' in exception_message:
            return "Empty response from LLM - will retry generation"
        elif 'service' in exception_message:
            return "LLM service error - may be temporary, will retry"
        elif 'network' in exception_message or 'connection' in exception_message:
            return "Network error during generation - will retry"
        else:
            return "Transient generation error - may recover on retry"

    @staticmethod
    def _get_no_retry_reason(exception: Exception) -> str:
        """Get reason for not retrying"""
        exception_message = str(exception).lower()
        
        if 'api key' in exception_message or 'authentication' in exception_message:
            return "Authentication error - check API credentials"
        elif 'unauthorized' in exception_message or 'access denied' in exception_message:
            return "Access denied - check permissions and API key"
        elif 'context length' in exception_message or 'context window' in exception_message:
            return "Context length exceeded - reduce prompt size"
        elif 'content policy' in exception_message or 'safety' in exception_message:
            return "Content policy violation - modify prompt content"
        elif 'model not found' in exception_message:
            return "Model not available - check model name"
        elif 'bad request' in exception_message:
            return "Invalid request format - fix request parameters"
        else:
            return "Permanent generation error - requires manual intervention"
    
    def should_retry(self, exception: Exception, attempt_number: int,
                    context: Optional[Dict[str, Any]] = None) -> bool:
        """Determine if should retry with attempt limit"""
        if not self.can_handle(exception, context):
            return False
        
        # Generation operations use fewer attempts (they're expensive)
        max_attempts = 2
        if attempt_number >= max_attempts:
            return False
        
        # Use detailed retry logic
        handling_result = self._handle_exception(exception, context)
        return handling_result.get('should_retry', False)
    
    def calculate_delay(self, exception: Exception, attempt_number: int,
                       base_delay: float = 1.0, context: Optional[Dict[str, Any]] = None) -> float:
        """Calculate delay with generation-specific logic"""
        if not self.can_handle(exception, context):
            return super().calculate_delay(exception, attempt_number, base_delay, context)
        
        # Add attempt number to context
        if context is None:
            context = {}
        context['attempt_number'] = attempt_number
        
        return self._calculate_generation_delay(exception, context)
    
    def transform_exception(self, exception: Exception, context: Optional[Dict[str, Any]] = None) -> Exception:
        """Transform to generation-specific retryable exception"""
        if not self.can_handle(exception, context):
            return exception
        
        handling_result = self._handle_exception(exception, context)
        retry_after = handling_result.get('delay_seconds', 0.0)
        generation_type = handling_result.get('category', 'unknown')
        
        return GenerationRetryableError(
            message=str(exception),
            generation_type=generation_type,
            retry_after=retry_after
        )
    
    def get_supported_exceptions(self) -> List[Type[Exception]]:
        """Get supported exception types"""
        supported = [
            Exception,      # Fallback
            ValueError,     # Common for parsing errors
            TypeError,      # Common for data type issues
            KeyError,       # Common for missing response fields
            AttributeError, # Common for malformed objects
        ]
        
        # Add JSON-related exceptions
        try:
            import json
            supported.append(json.JSONDecodeError)
        except (ImportError, AttributeError):
            pass
        
        return supported