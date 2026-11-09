"""
Enterprise retry decorators

Main decorator implementation following enterprise patterns.
Provides easy-to-use decorators for applying retry logic to functions.
"""

import functools
from typing import Optional, Type, List, Union, Callable, Any, Dict
from .strategies import RetryStrategy, StrategyFactory, RetryConfig, create_enterprise_logger
from .exceptions import MaxRetriesExceededError, RetryConfigurationError


def enterprise_retry(
    strategy: Union[RetryStrategy, str] = RetryStrategy.EXPONENTIAL,
    max_attempts: Optional[int] = None,
    base_delay: Optional[float] = None,
    max_delay: Optional[float] = None,
    multiplier: Optional[float] = None,
    exceptions: Optional[List[Type[Exception]]] = None,
    stop_on_exceptions: Optional[List[Type[Exception]]] = None,
    jitter: Optional[bool] = None,
    should_retry: Optional[Callable] = None,
    monitor_type: Optional[Type] = None,
    integration_name: Optional[str] = None,
    job_id: Optional[int] = None,
    job_run_id: Optional[int] = None,
    enable_logging: bool = True,
    **kwargs
):
    """
    Enterprise retry decorator
    
    Enterprise-level retry decorator with flexible and configurable patterns.
    
    Args:
        strategy: Retry strategy to use
        max_attempts: Maximum retry attempts (overrides strategy default)
        base_delay: Base delay in seconds (overrides strategy default)  
        max_delay: Maximum delay in seconds (overrides strategy default)
        multiplier: Backoff multiplier (overrides strategy default)
        exceptions: Exception types to retry on (overrides strategy default)
        stop_on_exceptions: Exception types that should stop retrying
        jitter: Add randomization to delays (overrides strategy default)
        should_retry: Custom retry condition function
        monitor_type: Monitor class for tracking retry attempts
        integration_name: Integration name for logging
        job_id: Job ID for logging
        job_run_id: Job run ID for logging
        enable_logging: Enable sql_helper logging integration (LoggingDetails)
        **kwargs: Additional configuration overrides
    
    Usage:
        # Simple usage (uses exponential strategy)
        @enterprise_retry
        def api_call():
            pass
            
        # Strategy-based usage
        @enterprise_retry(strategy=RetryStrategy.API_CALLS)
        def api_call():
            pass
            
        # Custom configuration
        @enterprise_retry(
            strategy=RetryStrategy.DATABASE,
            max_attempts=5,
            integration_name="my_integration"
        )
        def database_operation():
            pass
            
        # Gateway-specific retry
        @enterprise_retry(
            strategy=RetryStrategy.GATEWAY_CALLS,
            exceptions=[RequestException, Timeout, ConnectionError],
            max_attempts=3
        )
        def gateway_call():
            pass
    """
    
    def decorator(func: Callable) -> Callable:
        # Convert string strategy to enum if needed
        if isinstance(strategy, str):
            try:
                retry_strategy = RetryStrategy(strategy)
            except ValueError:
                raise RetryConfigurationError(f"Unknown retry strategy: {strategy}")
        else:
            retry_strategy = strategy
        
        # Build configuration overrides
        config_overrides = kwargs.copy()
        if max_attempts is not None:
            config_overrides['max_attempts'] = max_attempts
        if base_delay is not None:
            config_overrides['base_delay'] = base_delay  
        if max_delay is not None:
            config_overrides['max_delay'] = max_delay
        if multiplier is not None:
            config_overrides['multiplier'] = multiplier
        if jitter is not None:
            config_overrides['jitter'] = jitter
        if should_retry is not None:
            config_overrides['should_retry'] = should_retry
        if integration_name is not None:
            config_overrides['integration_name'] = integration_name
        if job_id is not None:
            config_overrides['job_id'] = job_id
        if job_run_id is not None:
            config_overrides['job_run_id'] = job_run_id
            
        # Handle exceptions
        if exceptions is not None:
            # Auto-detect exception types if not imported
            resolved_exceptions = _resolve_exception_types(exceptions)
            config_overrides['exceptions'] = resolved_exceptions
            
        if stop_on_exceptions is not None:
            resolved_stop_exceptions = _resolve_exception_types(stop_on_exceptions)
            config_overrides['stop_on_exceptions'] = resolved_stop_exceptions
        
        # Create retry configuration
        try:
            config = StrategyFactory.create_config(retry_strategy, **config_overrides)
        except Exception as e:
            raise RetryConfigurationError(f"Failed to create retry configuration: {e}")
        
        # Add sql_helper logging integration if enabled
        if enable_logging:
            config.before_sleep = create_enterprise_logger(
                integration_name or func.__name__,
                job_id,
                job_run_id
            )
        
        # Create monitor if specified
        monitor = None
        if monitor_type:
            try:
                monitor = monitor_type(
                    operation_name=func.__name__,
                    config=config
                )
            except Exception as e:
                print(f"⚠️ Warning: Failed to create monitor {monitor_type.__name__}: {e}")
        
        # Create tenacity retry decorator
        try:
            tenacity_retry = StrategyFactory.create_tenacity_retry(config)
        except Exception as e:
            raise RetryConfigurationError(f"Failed to create tenacity retry: {e}")
        
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            # Initialize monitor if present
            if monitor:
                monitor.start_operation()
            
            try:
                # Execute with retry
                result = tenacity_retry.wraps(func)(*args, **kwargs)
                
                # Log success if monitor present
                if monitor:
                    monitor.log_success()
                    
                return result
                
            except Exception as e:
                # Log failure if monitor present
                if monitor:
                    monitor.log_failure(e)
                
                # Convert to our exception type for better error messages
                if hasattr(e, 'retry_state'):
                    raise MaxRetriesExceededError(
                        function_name=func.__name__,
                        max_attempts=config.max_attempts,
                        last_exception=e.retry_state.outcome.exception(),
                        attempts_made=e.retry_state.attempt_number
                    ) from e
                else:
                    raise
            finally:
                # Finalize monitor if present
                if monitor:
                    monitor.end_operation()
        
        # Add metadata for introspection
        wrapper.__retry_config__ = config
        wrapper.__retry_strategy__ = retry_strategy
        wrapper.__monitor_type__ = monitor_type
        
        return wrapper
    
    return decorator


def _resolve_exception_types(exception_types: List[Union[Type[Exception], str]]) -> List[Type[Exception]]:
    """
    Resolve exception types from names or types
    
    Handles cases where exception classes might not be imported yet.
    """
    resolved = []
    
    for exc_type in exception_types:
        if isinstance(exc_type, str):
            # Try to resolve string to actual exception type
            resolved_type = _resolve_exception_by_name(exc_type)
            if resolved_type:
                resolved.append(resolved_type)
            else:
                print(f"⚠️ Warning: Could not resolve exception type: {exc_type}")
        else:
            # Already a type
            resolved.append(exc_type)
    
    return resolved


def _resolve_exception_by_name(exception_name: str) -> Optional[Type[Exception]]:
    """
    Resolve exception type by name
    
    Tries common exception locations and imports.
    """
    # Common exception mappings
    common_exceptions = {
        # Built-in exceptions
        'Exception': Exception,
        'ValueError': ValueError,
        'TypeError': TypeError,
        'KeyError': KeyError,
        'AttributeError': AttributeError,
        'ImportError': ImportError,
        'IOError': IOError,
        'OSError': OSError,
        'ConnectionError': ConnectionError if hasattr(__builtins__, 'ConnectionError') else Exception,
        'TimeoutError': TimeoutError if hasattr(__builtins__, 'TimeoutError') else Exception,
        
        # Try to import common library exceptions
    }
    
    if exception_name in common_exceptions:
        return common_exceptions[exception_name]
    
    # Try SQLAlchemy exceptions
    try:
        from sqlalchemy.exc import SQLAlchemyError, ProgrammingError, OperationalError
        sqlalchemy_exceptions = {
            'SQLAlchemyError': SQLAlchemyError,
            'ProgrammingError': ProgrammingError, 
            'OperationalError': OperationalError
        }
        if exception_name in sqlalchemy_exceptions:
            return sqlalchemy_exceptions[exception_name]
    except ImportError:
        pass
    
    # Try requests exceptions  
    try:
        import requests
        requests_exceptions = {
            'RequestException': requests.RequestException,
            'HTTPError': requests.HTTPError,
            'ConnectionError': requests.ConnectionError,
            'Timeout': requests.Timeout,
            'ConnectTimeout': requests.ConnectTimeout,
            'ReadTimeout': requests.ReadTimeout
        }
        if exception_name in requests_exceptions:
            return requests_exceptions[exception_name]
    except ImportError:
        pass
    
    return None


# Convenience decorators for common patterns

def database_retry(max_attempts: int = 3, integration_name: str = None, **kwargs):
    """Convenience decorator for database operations"""
    return enterprise_retry(
        strategy=RetryStrategy.DATABASE,
        max_attempts=max_attempts,
        integration_name=integration_name,
        **kwargs
    )


def api_retry(max_attempts: int = 5, integration_name: str = None, **kwargs):
    """Convenience decorator for API operations"""
    return enterprise_retry(
        strategy=RetryStrategy.API_CALLS,
        max_attempts=max_attempts,
        integration_name=integration_name,
        **kwargs
    )


def gateway_retry(max_attempts: int = 3, integration_name: str = None, **kwargs):
    """Convenience decorator for gateway operations (502, 503, 504 errors)"""
    return enterprise_retry(
        strategy=RetryStrategy.GATEWAY_CALLS,
        max_attempts=max_attempts,
        integration_name=integration_name,
        **kwargs
    )


def generation_retry(max_attempts: int = 2, integration_name: str = None, **kwargs):
    """Convenience decorator for generation operations (LLM, AI)"""
    return enterprise_retry(
        strategy=RetryStrategy.GENERATION,
        max_attempts=max_attempts,
        integration_name=integration_name,
        **kwargs
    )