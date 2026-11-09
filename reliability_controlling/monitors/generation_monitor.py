"""
Generation retry monitor

Specialized monitor for AI/LLM generation operations.
Tracks generation-specific errors like timeouts, parsing failures, and token limits.
"""

from typing import Dict, Any, Optional
from .base_monitor import BaseRetryMonitor, RetryAttempt, OperationRecord


class GenerationMonitor(BaseRetryMonitor):
    """
    Monitor for AI/LLM generation retry operations
    
    Tracks generation-specific metrics like prompt processing,
    response parsing, token limits, and LLM service timeouts.
    """
    
    def __init__(self, operation_name: str, config: Optional[Any] = None,
                 integration_name: Optional[str] = None):
        """Initialize generation monitor"""
        super().__init__(operation_name, config, integration_name)
        
        # Generation-specific statistics
        self._parsing_error_count = 0
        self._timeout_count = 0
        self._token_limit_count = 0
        self._service_error_count = 0
        self._empty_response_count = 0
        self._malformed_json_count = 0
        
        # Track generation metrics
        self._total_tokens_used = 0
        self._total_response_time = 0.0
        self._response_count = 0
    
    def log_parsing_error(self, attempt_number: int, response_content: str,
                         parse_error: str, delay_seconds: Optional[float] = None) -> None:
        """
        Log a response parsing error
        
        Args:
            attempt_number: The attempt number
            response_content: The raw response that failed to parse
            parse_error: Description of the parsing error
            delay_seconds: Delay before next retry
        """
        self._parsing_error_count += 1
        
        # Check if it's specifically a JSON parsing error
        if "json" in parse_error.lower():
            self._malformed_json_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'parsing_errors' not in self.current_operation.context:
                self.current_operation.context['parsing_errors'] = []
            
            self.current_operation.context['parsing_errors'].append({
                'attempt': attempt_number,
                'parse_error': parse_error,
                'response_length': len(response_content),
                'response_preview': response_content[:200] + "..." if len(response_content) > 200 else response_content
            })
        
        # Create mock exception for base logging
        class GenerationParsingError(Exception):
            pass
        
        mock_exception = GenerationParsingError(f"Parsing error: {parse_error}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_llm_timeout(self, attempt_number: int, timeout_seconds: float,
                       delay_seconds: Optional[float] = None) -> None:
        """
        Log an LLM service timeout
        
        Args:
            attempt_number: The attempt number
            timeout_seconds: Timeout value that was exceeded
            delay_seconds: Delay before next retry
        """
        self._timeout_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'llm_timeouts' not in self.current_operation.context:
                self.current_operation.context['llm_timeouts'] = []
                
            self.current_operation.context['llm_timeouts'].append({
                'attempt': attempt_number,
                'timeout_seconds': timeout_seconds
            })
        
        # Create mock exception for base logging
        class LLMTimeoutError(Exception):
            pass
        
        mock_exception = LLMTimeoutError(f"LLM timeout after {timeout_seconds}s")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_token_limit_error(self, attempt_number: int, tokens_used: int, 
                            token_limit: int, delay_seconds: Optional[float] = None) -> None:
        """
        Log a token limit exceeded error
        
        Args:
            attempt_number: The attempt number
            tokens_used: Number of tokens that were attempted
            token_limit: Maximum allowed tokens
            delay_seconds: Delay before next retry
        """
        self._token_limit_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'token_limit_errors' not in self.current_operation.context:
                self.current_operation.context['token_limit_errors'] = []
                
            self.current_operation.context['token_limit_errors'].append({
                'attempt': attempt_number,
                'tokens_used': tokens_used,
                'token_limit': token_limit
            })
        
        # Create mock exception for base logging
        class TokenLimitError(Exception):
            pass
        
        mock_exception = TokenLimitError(f"Token limit exceeded: {tokens_used}/{token_limit}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_service_error(self, attempt_number: int, service_error: str,
                         delay_seconds: Optional[float] = None) -> None:
        """
        Log an LLM service error
        
        Args:
            attempt_number: The attempt number
            service_error: Description of the service error
            delay_seconds: Delay before next retry
        """
        self._service_error_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'service_errors' not in self.current_operation.context:
                self.current_operation.context['service_errors'] = []
                
            self.current_operation.context['service_errors'].append({
                'attempt': attempt_number,
                'service_error': service_error
            })
        
        # Create mock exception for base logging
        class LLMServiceError(Exception):
            pass
        
        mock_exception = LLMServiceError(f"LLM service error: {service_error}")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_empty_response(self, attempt_number: int, delay_seconds: Optional[float] = None) -> None:
        """
        Log an empty response from LLM
        
        Args:
            attempt_number: The attempt number
            delay_seconds: Delay before next retry
        """
        self._empty_response_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'empty_responses' not in self.current_operation.context:
                self.current_operation.context['empty_responses'] = []
                
            self.current_operation.context['empty_responses'].append({
                'attempt': attempt_number
            })
        
        # Create mock exception for base logging
        class EmptyResponseError(Exception):
            pass
        
        mock_exception = EmptyResponseError("Empty response from LLM")
        self.log_attempt(attempt_number, mock_exception, delay_seconds)
    
    def log_successful_generation(self, tokens_used: int, response_time: float,
                                response_length: int) -> None:
        """
        Log a successful generation with metrics
        
        Args:
            tokens_used: Number of tokens consumed
            response_time: Time taken for generation
            response_length: Length of generated response
        """
        self._total_tokens_used += tokens_used
        self._total_response_time += response_time
        self._response_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'successful_generations' not in self.current_operation.context:
                self.current_operation.context['successful_generations'] = []
                
            self.current_operation.context['successful_generations'].append({
                'tokens_used': tokens_used,
                'response_time': response_time,
                'response_length': response_length
            })
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get generation-specific statistics"""
        base_stats = super().get_statistics()
        
        # Calculate averages
        avg_tokens = 0.0
        avg_response_time = 0.0
        if self._response_count > 0:
            avg_tokens = self._total_tokens_used / self._response_count
            avg_response_time = self._total_response_time / self._response_count
        
        # Add generation-specific metrics
        gen_stats = {
            'parsing_error_count': self._parsing_error_count,
            'timeout_count': self._timeout_count,
            'token_limit_count': self._token_limit_count,
            'service_error_count': self._service_error_count,
            'empty_response_count': self._empty_response_count,
            'malformed_json_count': self._malformed_json_count,
            'total_tokens_used': self._total_tokens_used,
            'average_tokens_per_response': round(avg_tokens, 2),
            'average_response_time_seconds': round(avg_response_time, 2),
            'successful_generations': self._response_count,
            'parsing_success_rate': 0.0
        }
        
        # Calculate parsing success rate
        total_attempts = sum([
            self._parsing_error_count,
            self._empty_response_count,
            self._response_count
        ])
        if total_attempts > 0:
            gen_stats['parsing_success_rate'] = round(
                (self._response_count / total_attempts) * 100, 2
            )
        
        # Merge with base statistics
        base_stats.update(gen_stats)
        return base_stats
    
    # Implementation of abstract methods
    
    def _log_operation_start(self) -> None:
        """Log generation operation start"""
        print(f"🤖 Generation Monitor: Starting operation '{self.operation_name}'")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="GEN_RETRY_START",
                StatusMessage=f"Starting generation operation: {self.operation_name}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "GEN_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_attempt(self, attempt: RetryAttempt) -> None:
        """Log generation retry attempt"""
        status_emoji = "❌" if attempt.exception_type else "✅"
        delay_info = f" (delay: {attempt.delay_seconds:.2f}s)" if attempt.delay_seconds else ""
        
        print(f"🤖 Generation Monitor: {status_emoji} Attempt {attempt.attempt_number} "
              f"for '{self.operation_name}'{delay_info}")
        
        if attempt.exception_type:
            print(f"   Error: {attempt.exception_type} - {attempt.exception_message}")
            
            # Show specific generation error details
            error_category = self._categorize_generation_error(attempt.exception_type, attempt.exception_message)
            if error_category:
                print(f"   Category: {error_category}")
    
    def _log_success(self) -> None:
        """Log generation operation success"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" in {duration:.2f}s" if duration else ""
        
        print(f"🤖 Generation Monitor: ✅ Operation '{self.operation_name}' succeeded "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        
        # Show generation metrics if available
        context = self.current_operation.context
        if context.get('successful_generations'):
            latest_gen = context['successful_generations'][-1]
            print(f"   Generated: {latest_gen['response_length']} chars, "
                  f"{latest_gen['tokens_used']} tokens, "
                  f"{latest_gen['response_time']:.2f}s")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="GEN_RETRY_SUCCESS",
                StatusMessage=f"Generation operation succeeded: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts)",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "GEN_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_failure(self, exception: Exception) -> None:
        """Log generation operation failure"""
        if not self.current_operation:
            return
            
        duration = self.current_operation.duration_seconds
        duration_str = f" after {duration:.2f}s" if duration else ""
        
        print(f"🤖 Generation Monitor: ❌ Operation '{self.operation_name}' failed "
              f"after {self.current_operation.total_attempts} attempts{duration_str}")
        print(f"   Final error: {type(exception).__name__} - {str(exception)}")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            error_list = [str(exception)]
            LoggingDetails(
                TaskName="GEN_RETRY_FAILURE",
                StatusMessage=f"Generation operation failed: {self.operation_name} "
                             f"({self.current_operation.total_attempts} attempts) - {str(exception)}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=error_list,
                integration_name=self.integration_name or "GEN_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_operation_end(self, operation: OperationRecord) -> None:
        """Log generation operation end"""
        status = "SUCCESS" if operation.success else "FAILURE"
        duration_str = f" ({operation.duration_seconds:.2f}s)" if operation.duration_seconds else ""
        
        print(f"🤖 Generation Monitor: Operation '{operation.operation_name}' ended - "
              f"{status}{duration_str}")
        
        # Print summary of generation-specific errors if any occurred
        context = operation.context
        if context.get('parsing_errors'):
            print(f"   Parsing errors: {len(context['parsing_errors'])}")
        if context.get('llm_timeouts'):
            print(f"   LLM timeouts: {len(context['llm_timeouts'])}")
        if context.get('token_limit_errors'):
            print(f"   Token limit errors: {len(context['token_limit_errors'])}")
        if context.get('service_errors'):
            print(f"   Service errors: {len(context['service_errors'])}")
        if context.get('empty_responses'):
            print(f"   Empty responses: {len(context['empty_responses'])}")
        if context.get('successful_generations'):
            total_tokens = sum(g['tokens_used'] for g in context['successful_generations'])
            avg_response_time = sum(g['response_time'] for g in context['successful_generations']) / len(context['successful_generations'])
            print(f"   Successful generations: {len(context['successful_generations'])} "
                  f"(total tokens: {total_tokens}, avg time: {avg_response_time:.2f}s)")
    
    def _categorize_generation_error(self, exception_type: str, exception_message: str) -> Optional[str]:
        """
        Categorize generation errors
        
        Returns error category for better error understanding
        """
        if not exception_message:
            return None
            
        message_lower = exception_message.lower()
        
        if "parsing" in message_lower or "json" in message_lower:
            return "Response Parsing"
        elif "timeout" in message_lower:
            return "LLM Timeout"
        elif "token" in message_lower and "limit" in message_lower:
            return "Token Limit"
        elif "service" in message_lower or "api" in message_lower:
            return "LLM Service Error"
        elif "empty" in message_lower or "no response" in message_lower:
            return "Empty Response"
        elif "rate limit" in message_lower:
            return "Rate Limit"
        else:
            return "Other Generation Error"