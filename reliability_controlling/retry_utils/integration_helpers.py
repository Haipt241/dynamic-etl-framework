"""
Integration helpers

Utilities for integrating the retry system with existing codebases,
particularly for dynamic_integrations and enterprise compatibility.
"""

from typing import Dict, Any, Optional, List, Type
from ..core.strategies import RetryStrategy, StrategyFactory
from ..handlers import APIExceptionHandler, DatabaseExceptionHandler, GenerationExceptionHandler
from ..monitors import APIMonitor, DatabaseMonitor, GenerationMonitor, ChunkMonitor


def setup_default_strategies() -> None:
    """
    Set up default exception mappings for retry strategies
    
    Configures the strategy factory with appropriate exception types
    for each retry strategy based on available imports.
    """
    # Database exceptions
    database_exceptions = []
    try:
        from sqlalchemy.exc import SQLAlchemyError, OperationalError, ProgrammingError
        database_exceptions.extend([SQLAlchemyError, OperationalError, ProgrammingError])
    except ImportError:
        pass
    
    try:
        import pymysql
        database_exceptions.append(pymysql.Error)
    except ImportError:
        pass
    
    if database_exceptions:
        StrategyFactory.set_default_exceptions(RetryStrategy.DATABASE, database_exceptions)
    
    # API exceptions
    api_exceptions = []
    try:
        import requests
        api_exceptions.extend([
            requests.RequestException,
            requests.HTTPError, 
            requests.ConnectionError,
            requests.Timeout,
            requests.ConnectTimeout,
            requests.ReadTimeout
        ])
    except ImportError:
        pass
    
    # Add built-in exceptions
    api_exceptions.extend([ConnectionError, TimeoutError])
    
    StrategyFactory.set_default_exceptions(RetryStrategy.API_CALLS, api_exceptions)
    StrategyFactory.set_default_exceptions(RetryStrategy.GATEWAY_CALLS, api_exceptions)
    
    # Generation exceptions
    generation_exceptions = [ValueError, TypeError, KeyError, AttributeError]
    
    try:
        import json
        generation_exceptions.append(json.JSONDecodeError)
    except (ImportError, AttributeError):
        pass
    
    StrategyFactory.set_default_exceptions(RetryStrategy.GENERATION, generation_exceptions)
    
    print("✅ Default retry strategies configured")


def create_handler_chain() -> APIExceptionHandler:
    """
    Create a complete exception handler chain
    
    Returns:
        Root handler of the chain
    """
    # Create handlers
    api_handler = APIExceptionHandler()
    database_handler = DatabaseExceptionHandler()
    generation_handler = GenerationExceptionHandler()
    
    # Chain them together (order matters - most specific first)
    api_handler.set_next(database_handler).set_next(generation_handler)
    
    return api_handler


def integrate_with_sql_helper_logging(integration_name: str, job_id: Optional[int] = None,
                                    job_run_id: Optional[int] = None) -> Optional[callable]:
    """
    Create sql_helper-compatible logging callback
    
    Args:
        integration_name: Name of integration 
        job_id: Job ID for logging
        job_run_id: Job run ID for logging
        
    Returns:
        Logging callback function or None if sql_helper not available
    """
    try:
        from sql_helper import LoggingDetails, update_container_logs
        
        def sql_helper_logging_callback(retry_state):
            """sql_helper-compatible retry logging callback"""
            fn_name = retry_state.fn.__name__ if hasattr(retry_state, 'fn') else 'unknown_function'
            attempt_number = getattr(retry_state, 'attempt_number', 1)
            exception = getattr(retry_state.outcome, 'exception', lambda: None)()
            
            retry_msg = (f"Retrying {fn_name} (Attempt {attempt_number}) "
                        f"due to {exception}")
            
            # Enterprise-style detailed logging
            LoggingDetails(
                TaskName="RETRY",
                StatusMessage=retry_msg,
                job_id=job_id or 1,
                job_run_id=job_run_id or 1, 
                error_list=[],
                integration_name=integration_name
            )
            
            # Container logging
            params = {
                "p_integration": fn_name,
                "p_organisation_id": None,
                "p_client_id": None,
                "p_firm_id": None,
                "p_start_date": None,
                "p_end_date": None,
                "p_status": f"RETRYING {fn_name}",
                "p_log_id": None,
                "p_remarks": retry_msg
            }
            update_container_logs(params)
        
        return sql_helper_logging_callback
        
    except ImportError:
        print("⚠️ Warning: sql_helper not available, enterprise logging disabled")
        return None


def create_monitor_for_strategy(strategy: RetryStrategy, operation_name: str,
                              integration_name: Optional[str] = None,
                              **kwargs) -> Optional[Any]:
    """
    Create appropriate monitor for retry strategy
    
    Args:
        strategy: Retry strategy
        operation_name: Name of operation being monitored
        integration_name: Integration name
        **kwargs: Additional monitor configuration
        
    Returns:
        Monitor instance or None
    """
    monitor_map = {
        RetryStrategy.API_CALLS: APIMonitor,
        RetryStrategy.GATEWAY_CALLS: APIMonitor,
        RetryStrategy.DATABASE: DatabaseMonitor,
        RetryStrategy.GENERATION: GenerationMonitor,
        RetryStrategy.CHUNK_BASED: ChunkMonitor
    }
    
    monitor_class = monitor_map.get(strategy)
    if monitor_class:
        try:
            return monitor_class(
                operation_name=operation_name,
                integration_name=integration_name,
                **kwargs
            )
        except Exception as e:
            print(f"⚠️ Warning: Failed to create monitor {monitor_class.__name__}: {e}")
    
    return None


def upgrade_existing_retry_code(file_path: str, strategy: RetryStrategy = RetryStrategy.EXPONENTIAL,
                              integration_name: Optional[str] = None) -> str:
    """
    Generate upgrade suggestions for existing retry code
    
    Args:
        file_path: Path to file with existing retry code
        strategy: Suggested retry strategy
        integration_name: Integration name for logging
        
    Returns:
        Upgrade suggestions as string
    """
    suggestions = f"""
# Upgrade suggestions for {file_path}

## Replace manual retry loops with decorators:

### Before:
```python
max_retries = 3
for attempt in range(max_retries):
    try:
        result = some_operation()
        return result
    except Exception as e:
        if attempt < max_retries - 1:
            time.sleep(2 ** attempt)
            continue
        else:
            raise
```

### After:
```python
from reliability_controlling import enterprise_retry, RetryStrategy

@enterprise_retry(
    strategy=RetryStrategy.{strategy.name},
    integration_name="{integration_name or 'YOUR_INTEGRATION'}"
)
def some_operation():
    # Original operation code
    pass
```

## Benefits of upgrade:
1. ✅ Automatic enterprise-style logging
2. ✅ Sophisticated error handling and classification
3. ✅ Configurable retry strategies
4. ✅ Comprehensive monitoring and reporting
5. ✅ No changes to core business logic

## Migration steps:
1. Import retry decorators: `from reliability_controlling import enterprise_retry`
2. Replace manual loops with `@enterprise_retry` decorator
3. Remove manual delay/backoff logic (handled automatically)
4. Configure strategy and integration name
5. Test with existing error conditions
"""
    
    return suggestions


def analyze_existing_exceptions(file_path: str) -> Dict[str, List[str]]:
    """
    Analyze existing exception handling patterns in a file
    
    Args:
        file_path: Path to Python file to analyze
        
    Returns:
        Dictionary mapping exception types to suggested strategies
    """
    try:
        with open(file_path, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        return {"error": ["File not found"]}
    
    analysis = {
        "database_exceptions": [],
        "api_exceptions": [], 
        "generation_exceptions": [],
        "generic_exceptions": [],
        "suggested_strategies": []
    }
    
    # Look for database patterns
    db_patterns = [
        'sqlalchemy', 'operationalerror', 'programmingerror',
        'mysql', 'postgresql', 'connection', 'deadlock'
    ]
    if any(pattern in content.lower() for pattern in db_patterns):
        analysis["database_exceptions"].append("Database operations detected")
        analysis["suggested_strategies"].append("RetryStrategy.DATABASE")
    
    # Look for API patterns
    api_patterns = [
        'requests.', 'http', 'api', 'gateway', 'timeout',
        'connectionerror', 'httperror'
    ]
    if any(pattern in content.lower() for pattern in api_patterns):
        analysis["api_exceptions"].append("API operations detected")
        analysis["suggested_strategies"].append("RetryStrategy.API_CALLS")
    
    # Look for generation patterns
    gen_patterns = [
        'json', 'parsing', 'llm', 'generation', 'claude', 'openai'
    ]
    if any(pattern in content.lower() for pattern in gen_patterns):
        analysis["generation_exceptions"].append("Generation operations detected")
        analysis["suggested_strategies"].append("RetryStrategy.GENERATION")
    
    # Look for chunk patterns
    chunk_patterns = [
        'chunk', 'batch', 'process_chunk', 'chunk_retrier'
    ]
    if any(pattern in content.lower() for pattern in chunk_patterns):
        analysis["generation_exceptions"].append("Chunk processing detected")
        analysis["suggested_strategies"].append("RetryStrategy.CHUNK_BASED")
    
    return analysis


def create_integration_specific_config(integration_name: str,
                                     operation_types: List[str]) -> Dict[str, Any]:
    """
    Create integration-specific retry configuration
    
    Args:
        integration_name: Name of integration
        operation_types: Types of operations (api, database, generation, chunk)
        
    Returns:
        Configuration dictionary
    """
    config = {
        "integration_name": integration_name,
        "enable_logging": True,
        "created_by": "retry_system_integration_helper"
    }
    
    # Add operation-specific configurations
    if "api" in operation_types:
        config["api_calls"] = {
            "max_attempts": 5,
            "base_delay": 1.0,
            "max_delay": 60.0,
            "multiplier": 2.0,
            "jitter": True
        }
        
        config["gateway_calls"] = {
            "max_attempts": 3,
            "base_delay": 5.0,
            "max_delay": 60.0,
            "multiplier": 2.0,
            "jitter": True
        }
    
    if "database" in operation_types:
        config["database"] = {
            "max_attempts": 3,
            "base_delay": 2.0,
            "max_delay": 300.0,  # Enterprise style
            "multiplier": 2.0,
            "jitter": True
        }
    
    if "generation" in operation_types:
        config["generation"] = {
            "max_attempts": 2,  # Expensive operations
            "base_delay": 1.0,
            "max_delay": 10.0,
            "multiplier": 2.0,
            "jitter": False
        }
    
    if "chunk" in operation_types:
        config["chunk_based"] = {
            "max_attempts": 2,
            "base_delay": 0.5,
            "max_delay": 5.0,
            "multiplier": 2.0,
            "jitter": False
        }
    
    return config


def migrate_chunk_retrier_to_enterprise(chunk_retrier_path: str) -> str:
    """
    Generate migration guide for existing ChunkRetryMonitor to enterprise system
    
    Args:
        chunk_retrier_path: Path to existing chunk_retrier.py
        
    Returns:
        Migration guide
    """
    migration_guide = f"""
        # Migration Guide: ChunkRetryMonitor → Enterprise Retry System
        
        ## Existing file: {chunk_retrier_path}
        
        ### Current Usage:
        ```python
        from dynamic_integrations.generator.retry_monitor import ChunkRetryMonitor
        monitor = ChunkRetryMonitor(integration_name, sql_type)
        ```
        
        ### Migrated Usage:
        ```python
        from reliability_controlling import enterprise_retry, ChunkMonitor, RetryStrategy
        
        # Replace existing monitor with enterprise monitor
        @enterprise_retry(
            strategy=RetryStrategy.CHUNK_BASED,
            monitor_type=ChunkMonitor,
            integration_name="your_integration"
        )
        def process_chunk_with_retry(chunk_data):
            # Your existing chunk processing logic
            return processed_result
        ```
        
        ### Benefits:
        1. ✅ Enhanced monitoring with enterprise-style logging
        2. ✅ Automatic retry with sophisticated error handling  
        3. ✅ Backward compatibility with existing retry commands
        4. ✅ Better error categorization and reporting
        5. ✅ Integration with overall retry system
        
        ### Migration Steps:
        1. Import enterprise retry system
        2. Replace ChunkRetryMonitor initialization with decorator
        3. Update chunk processing functions to use decorator
        4. Remove manual retry loops (handled by decorator)
        5. Test with existing failure scenarios
        
        ### Compatibility:
        - ✅ Existing retry commands still work
        - ✅ Same JSON status file format
        - ✅ Compatible with chunk_retrier.py CLI tool
        - ✅ Same retry status reporting
        """
    
    return migration_guide