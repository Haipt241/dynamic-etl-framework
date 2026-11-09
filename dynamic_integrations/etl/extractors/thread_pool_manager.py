"""
ThreadPoolManager - Manages thread pools with rate limiting for ETL operations
"""

import logging
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from functools import wraps
from threading import RLock, Semaphore
from typing import Any, Callable, Dict, List, Optional

# Import RateLimiter from generator directory
from dynamic_integrations.generator.rate_limiter import RateLimiter


class ThreadedExecutionError(Exception):
    """Exception raised when threaded execution encounters failures"""

    def __init__(self, failed_items: List[Any], successful_count: int):
        self.failed_items = failed_items
        self.successful_count = successful_count
        total_count = successful_count + len(failed_items)
        super().__init__(
            f"Threading execution completed with {len(failed_items)} failures "
            f"out of {total_count} total items"
        )


class ThreadPoolManager:
    """
    Manages thread pool with rate limiting using Semaphore for ETL operations

    Features:
    - ThreadPoolExecutor for concurrent processing
    - Semaphore-based rate limiting with safety margin
    - Time-based rate limiting as secondary control
    - Comprehensive error handling and logging
    """

    def __init__(self, max_workers: int = 5, rate_limit_per_minute: int = 300,
                 safety_margin: float = 0.8, logger_name: str = None):
        """
        Initialize ThreadPoolManager

        Args:
            max_workers: Maximum number of worker threads
            rate_limit_per_minute: API rate limit per minute
            safety_margin: Safety margin for rate limiting (default 80%)
            logger_name: Custom logger name
        """
        self.max_workers = max_workers
        self.rate_limit_per_minute = rate_limit_per_minute
        self.safety_margin = safety_margin

        # Use existing RateLimiter instead of custom implementation
        self.rate_limiter = RateLimiter()

        safe_rate = int(rate_limit_per_minute * safety_margin)

        # Keep semaphore tight to control concurrent requests
        requests_per_second = rate_limit_per_minute / 60.0
        safe_requests_per_second = requests_per_second * safety_margin
        max_concurrent_requests = max(1, int(safe_requests_per_second * 0.8))

        self.semaphore = Semaphore(max_concurrent_requests)

        # Logging setup
        self.logger = logging.getLogger(logger_name or f"{__name__}.ThreadPoolManager")

        # Stats tracking
        self.total_processed = 0
        self.total_failed = 0

    def threaded_execution(self, items: List[Any], processor_func: Callable,
                          *args, **kwargs) -> List[Any]:
        """
        Execute function over items using ThreadPool with Semaphore rate limiting

        Args:
            items: List of items to process
            processor_func: Function to process each item
            *args, **kwargs: Additional arguments for processor_func

        Returns:
            List of results (None for failed items)

        Raises:
            ThreadedExecutionError: If error_policy is 'raise' and failures occur
        """
        if not items:
            self.logger.info("No items to process")
            return []

        print(f"🚀 Starting threaded execution: {len(items)} items, "
              f"{self.max_workers} workers, {self.rate_limit_per_minute}/min rate limit")
        print(f"⚡ ThreadPool active with {self.max_workers} threads processing in parallel")

        results = []
        failed_items = []
        start_time = time.time()

        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            # Submit all tasks
            futures = []
            for i, item in enumerate(items):
                future = executor.submit(
                    self._rate_limited_processor,
                    processor_func, item, i, *args, **kwargs
                )
                futures.append((future, item, i))

            # Collect results as they complete
            for future, item, index in futures:
                try:
                    result = future.result()
                    results.append(result)
                    self.total_processed += 1

                    # Progress logging every 200 items or when complete
                    if (index + 1) % 200 == 0 or (index + 1) == len(items):
                        print(f"✅ Thread Progress: {index + 1}/{len(items)} items completed")

                    # Garbage collection every 20 items to prevent memory buildup
                    if (index + 1) % 20 == 0:
                        import gc
                        gc.collect()

                except Exception as e:
                    self.logger.error(f"❌ Error processing item {index} ({item}): {e}")
                    results.append(None)
                    failed_items.append((item, e))
                    self.total_failed += 1

        # Execution summary
        execution_time = time.time() - start_time
        success_count = len(results) - len(failed_items)
        print(f"📊 Threading execution completed: {success_count} successful, "
              f"{len(failed_items)} failed, {execution_time:.1f}s total")

        # Handle failures based on error policy
        if failed_items:
            failure_rate = len(failed_items) / len(items) * 100
            self.logger.warning(f"⚠️ Failure rate: {failure_rate:.1f}% ({len(failed_items)}/{len(items)})")

            # Could add error_policy parameter to raise exception or continue
            # For now, continue with partial results

        return results

    def _rate_limited_processor(self, func: Callable, item: Any, index: int, *args, **kwargs):
        """
        Wrapper that applies rate limiting via semaphore before function execution

        Args:
            func: Function to execute
            item: Item to process
            index: Item index for logging
            *args, **kwargs: Additional arguments

        Returns:
            Function result
        """
        # Add staggered startup delay for high-rate APIs to prevent initial burst
        if self.rate_limit_per_minute > 300:
            # Calculate per-second rate limit for startup delay
            requests_per_second = self.rate_limit_per_minute / 60.0
            # Delay between requests to respect per-second limit
            startup_delay_per_request = 1.0 / requests_per_second

            # Stagger first requests based on their index
            if index < (requests_per_second * 2):  # First 2 seconds worth of requests
                delay_seconds = index * startup_delay_per_request
                if delay_seconds > 0:
                    time.sleep(delay_seconds)

        # Acquire semaphore permit (blocks if limit reached)
        self.semaphore.acquire()

        try:
            # Additional time-based rate limiting as secondary control
            self._enforce_rate_limit()

            # Execute actual function (minimal logging to reduce verbosity)
            result = func(item, *args, **kwargs)

            return result

        finally:
            # Force garbage collection to free memory after each task
            import gc
            gc.collect()

            # Always release permit, even on exception
            self.semaphore.release()

    def _enforce_rate_limit(self):
        """
        Use existing RateLimiter for time-based rate limiting
        """
        # Use the existing RateLimiter's wait_if_needed method
        self.rate_limiter.wait_if_needed(self.rate_limit_per_minute, self.safety_margin)

    def get_stats(self) -> Dict[str, Any]:
        """Get execution statistics"""
        return {
            'total_processed': self.total_processed,
            'total_failed': self.total_failed,
            'success_rate': (self.total_processed / (self.total_processed + self.total_failed) * 100)
                           if (self.total_processed + self.total_failed) > 0 else 0,
            'max_workers': self.max_workers,
            'rate_limit_per_minute': self.rate_limit_per_minute,
            'safety_margin': self.safety_margin
        }

    def reset_stats(self):
        """Reset execution statistics"""
        self.total_processed = 0
        self.total_failed = 0


def with_threading(max_workers: int = 5, rate_limit: int = 300, safety_margin: float = 0.8):
    """
    Decorator to make any function thread-safe with rate limiting

    Usage:
    @with_threading(max_workers=5, rate_limit=300)
    def process_items(self, items):
        # This function will be called for each item
        pass

    Args:
        max_workers: Maximum number of worker threads
        rate_limit: API rate limit per minute
        safety_margin: Safety margin for rate limiting (default 80%)
    """
    def decorator(func):
        @wraps(func)
        def wrapper(self, items: List[Any], *args, **kwargs):
            # Create or reuse thread pool manager
            manager_attr = f'_thread_pool_manager_{func.__name__}'
            if not hasattr(self, manager_attr):
                logger_name = f"{self.__class__.__name__}.{func.__name__}"
                setattr(self, manager_attr,
                       ThreadPoolManager(max_workers, rate_limit, safety_margin, logger_name))

            thread_manager = getattr(self, manager_attr)

            # Define processor function that calls original function for each item
            def processor(item):
                return func(self, item, *args, **kwargs)

            return thread_manager.threaded_execution(items, processor)

        return wrapper
    return decorator


def calculate_optimal_workers(rate_limit_per_minute: int, safety_margin: float = 0.8,
                            max_workers: int = 5) -> int:
    """
    Calculate optimal number of workers based on rate limits

    Uses the same logic as api_client.py for consistency

    Args:
        rate_limit_per_minute: API rate limit per minute
        safety_margin: Safety margin (default 80%)
        max_workers: Maximum allowed workers

    Returns:
        Optimal number of workers
    """
    safe_requests_per_minute = int(rate_limit_per_minute * safety_margin)

    # For low-rate APIs: single worker
    if safe_requests_per_minute <= 30:  # < 0.5 req/sec
        return 1

    # Calculate based on ~15 requests per worker per minute
    max_effective_workers = max(1, safe_requests_per_minute // 15)

    # Return minimum of calculated workers and max allowed
    return min(max_workers, max_effective_workers)


# Example usage and testing
if __name__ == "__main__":
    import random

    # Setup logging
    logging.basicConfig(level=logging.INFO)

    # Test function
    def test_processor(item):
        """Mock processor for testing"""
        time.sleep(random.uniform(0.1, 0.5))  # Simulate API call
        return f"processed_{item}"

    # Test ThreadPoolManager
    manager = ThreadPoolManager(max_workers=3, rate_limit_per_minute=60)

    test_items = list(range(10))
    results = manager.threaded_execution(test_items, test_processor)

    print(f"Results: {results}")
    print(f"Stats: {manager.get_stats()}")