"""
Retry strategies implementation

Defines various retry strategies with enterprise patterns and enhancements.
Uses tenacity library for robust retry mechanics with configurable decorators.
"""

from enum import Enum
from dataclasses import dataclass, field
from typing import List, Type, Optional, Callable
from tenacity import (
    retry_if_exception_type, 
    stop_after_attempt, 
    wait_exponential, 
    wait_fixed,
    wait_random,
    wait_combine
)


class RetryStrategy(Enum):
    """
    Retry strategy types
    
    Enterprise retry strategies with flexible configuration
    """
    # Core enterprise strategies
    DATABASE = "database"           # For database operations (SQLAlchemy errors)
    API_CALLS = "api_calls"        # For API calls (HTTP errors, timeouts)
    GATEWAY_CALLS = "gateway_calls" # For gateway calls (502, 503, 504)
    
    # Extended strategies (Dynamic integrations-specific)
    GENERATION = "generation"       # For LLM/AI generation operations
    CHUNK_BASED = "chunk_based"     # For chunk processing
    FILE_OPERATIONS = "file_operations"  # For file I/O
    
    # Composite strategies
    EXPONENTIAL = "exponential"     # General exponential backoff
    LINEAR = "linear"              # Linear backoff
    CUSTOM = "custom"              # User-defined strategy


@dataclass
class RetryConfig:
    """
    Retry configuration class
    
    Enterprise retry configuration with flexible options
    """
    # Core retry parameters
    max_attempts: int = 3
    base_delay: float = 1.0         # Base delay in seconds
    max_delay: float = 300.0        # Max delay in seconds
    multiplier: float = 2.0         # Exponential multiplier for backoff
    
    # Exception handling configuration
    exceptions: List[Type[Exception]] = field(default_factory=list)
    stop_on_exceptions: List[Type[Exception]] = field(default_factory=list)
    
    # Advanced options
    jitter: bool = True             # Add randomization to prevent thundering herd
    should_retry: Optional[Callable] = None  # Custom retry condition
    before_sleep: Optional[Callable] = None  # Callback before sleep for logging
    after: Optional[Callable] = None # Callback after each attempt
    
    # Context for job tracking
    integration_name: Optional[str] = None
    job_id: Optional[int] = None
    job_run_id: Optional[int] = None
    
    def __post_init__(self):
        """Validate configuration after initialization"""
        if self.max_attempts <= 0:
            raise ValueError("max_attempts must be positive")
        if self.base_delay < 0:
            raise ValueError("base_delay must be non-negative")
        if self.max_delay < self.base_delay:
            raise ValueError("max_delay must be >= base_delay")
        if self.multiplier <= 0:
            raise ValueError("multiplier must be positive")


class StrategyFactory:
    """
    Factory for creating retry strategies
    
    Factory for creating retry strategies with flexible configuration
    """
    
    # Default enterprise configurations
    _DEFAULT_CONFIGS = {
        RetryStrategy.DATABASE: RetryConfig(
            max_attempts=3,
            base_delay=2.0,           # Conservative starting point
            max_delay=300.0,          # Maximum delay cap
            multiplier=2.0,           # Exponential backoff multiplier
            exceptions=[],            # Will be set based on imports
            jitter=True
        ),
        
        RetryStrategy.API_CALLS: RetryConfig(
            max_attempts=5,           # More attempts for API calls
            base_delay=1.0,
            max_delay=60.0,           # Faster than database operations
            multiplier=2.0,
            exceptions=[],            # Will be set based on imports
            jitter=True
        ),
        
        RetryStrategy.GATEWAY_CALLS: RetryConfig(
            max_attempts=3,
            base_delay=5.0,           # Longer delays for gateway issues
            max_delay=60.0,
            multiplier=2.0,
            exceptions=[],            # Will be set based on imports
            jitter=True
        ),
        
        RetryStrategy.GENERATION: RetryConfig(
            max_attempts=2,           # Fewer attempts for expensive operations
            base_delay=1.0,
            max_delay=10.0,
            multiplier=2.0,
            exceptions=[],
            jitter=False              # No jitter for generation
        ),
        
        RetryStrategy.CHUNK_BASED: RetryConfig(
            max_attempts=2,
            base_delay=0.5,
            max_delay=5.0,
            multiplier=2.0,
            exceptions=[],
            jitter=False
        ),
        
        RetryStrategy.FILE_OPERATIONS: RetryConfig(
            max_attempts=3,
            base_delay=0.1,
            max_delay=2.0,
            multiplier=1.5,
            exceptions=[],
            jitter=True
        ),
        
        RetryStrategy.EXPONENTIAL: RetryConfig(
            max_attempts=3,
            base_delay=1.0,
            max_delay=60.0,
            multiplier=2.0,
            exceptions=[],
            jitter=True
        ),
        
        RetryStrategy.LINEAR: RetryConfig(
            max_attempts=3,
            base_delay=1.0,
            max_delay=10.0,
            multiplier=1.0,           # Linear = no multiplication
            exceptions=[],
            jitter=False
        )
    }
    
    @classmethod
    def create_config(cls, strategy: RetryStrategy, **overrides) -> RetryConfig:
        """
        Create retry configuration for a strategy
        
        Args:
            strategy: The retry strategy to use
            **overrides: Configuration overrides
            
        Returns:
            RetryConfig instance
        """
        if strategy not in cls._DEFAULT_CONFIGS:
            if strategy == RetryStrategy.CUSTOM:
                # For custom strategy, user must provide full config
                return RetryConfig(**overrides)
            else:
                raise ValueError(f"Unknown retry strategy: {strategy}")
        
        # Get default config and apply overrides
        default_config = cls._DEFAULT_CONFIGS[strategy]
        config_dict = {
            'max_attempts': default_config.max_attempts,
            'base_delay': default_config.base_delay,
            'max_delay': default_config.max_delay,
            'multiplier': default_config.multiplier,
            'exceptions': default_config.exceptions.copy(),
            'stop_on_exceptions': default_config.stop_on_exceptions.copy(),
            'jitter': default_config.jitter,
            'should_retry': default_config.should_retry,
            'before_sleep': default_config.before_sleep,
            'after': default_config.after,
            'integration_name': default_config.integration_name,
            'job_id': default_config.job_id,
            'job_run_id': default_config.job_run_id
        }
        
        # Apply overrides
        config_dict.update(overrides)
        
        return RetryConfig(**config_dict)
    
    @classmethod
    def create_tenacity_retry(cls, config: RetryConfig):
        """
        Create tenacity retry decorator from config
        
        Create tenacity retry decorator with enterprise configuration
        """
        from tenacity import Retrying
        
        # Build stop condition
        stop_condition = stop_after_attempt(config.max_attempts)
        
        # Build wait condition
        if config.multiplier == 1.0:
            # Linear backoff
            wait_condition = wait_fixed(config.base_delay)
        else:
            # Exponential backoff configuration
            wait_condition = wait_exponential(
                multiplier=config.multiplier,
                min=config.base_delay,
                max=config.max_delay
            )
        
        # Add jitter if requested (prevents thundering herd)
        if config.jitter:
            jitter_wait = wait_random(min=0, max=1)
            wait_condition = wait_combine(wait_condition, jitter_wait)
        
        # Build retry condition
        retry_conditions = []
        
        if config.exceptions:
            retry_conditions.append(retry_if_exception_type(tuple(config.exceptions)))
        
        if config.should_retry:
            # Create custom retry condition
            def custom_retry_condition(retry_state):
                return config.should_retry(retry_state)
            retry_conditions.append(custom_retry_condition)
        
        # Default to retry on any exception if no conditions specified
        if not retry_conditions:
            retry_conditions = [retry_if_exception_type(Exception)]
        
        # Combine retry conditions
        if len(retry_conditions) == 1:
            retry_condition = retry_conditions[0]
        else:
            # Create composite condition (any condition triggers retry)
            def combined_condition(retry_state):
                return any(condition(retry_state) for condition in retry_conditions)
            retry_condition = combined_condition
        
        return Retrying(
            stop=stop_condition,
            wait=wait_condition,
            retry=retry_condition,
            before_sleep=config.before_sleep,
            after=config.after,
            reraise=True
        )
    
    @classmethod
    def set_default_exceptions(cls, strategy: RetryStrategy, exceptions: List[Type[Exception]]):
        """Set default exceptions for a strategy"""
        if strategy in cls._DEFAULT_CONFIGS:
            cls._DEFAULT_CONFIGS[strategy].exceptions = exceptions


def create_enterprise_logger(integration_name: str, job_id: Optional[int] = None, 
                           job_run_id: Optional[int] = None):
    """
    Create retry logging callback compatible with sql_helper
    
    Integrates retry attempts with existing LoggingDetails and update_container_logs
    from sql_helper module. Falls back to console logging if sql_helper not available.
    """
    # def log_retry_attempt(retry_state):
    #     fn_name = getattr(retry_state.outcome.result, '__name__', 'unknown_function') if hasattr(retry_state.outcome, 'result') else 'unknown_function'
    #     if hasattr(retry_state, 'next_action') and hasattr(retry_state.next_action, 'sleep'):
    #         sleep_time = retry_state.next_action.sleep
    #     else:
    #         sleep_time = 0
    #         
    #     retry_msg = (f"Retrying {fn_name} (Attempt {retry_state.attempt_number}) "
    #                 f"due to {retry_state.outcome.exception()} "
    #                 f"(sleeping {sleep_time:.2f}s)")
    #     
    #     print(f"🔄 RETRY: {retry_msg}")
    #     
    #     # Try to integrate with sql_helper logging system
    #     try:
    #         # This will work if sql_helper is available
    #         from sql_helper import LoggingDetails, update_container_logs
    #         
    #         # Use LoggingDetails from sql_helper
    #         LoggingDetails(
    #             TaskName="RETRY",
    #             StatusMessage=retry_msg,
    #             job_id=job_id or 1,
    #             job_run_id=job_run_id or 1,
    #             error_list=[],
    #             integration_name=integration_name
    #         )
    #         
    #         # Container/job-level logging
    #         params = {
    #             "p_integration": fn_name,
    #             "p_organisation_id": None,
    #             "p_client_id": None,
    #             "p_firm_id": None,
    #             "p_start_date": None,
    #             "p_end_date": None,
    #             "p_status": f"RETRYING {fn_name}",
    #             "p_log_id": None,
    #             "p_remarks": retry_msg
    #         }
    #         update_container_logs(params)
    #         
    #     except ImportError:
    #         # Fallback to simple logging if sql_helper not available
    #         pass
    # 
    # return log_retry_attempt
    pass