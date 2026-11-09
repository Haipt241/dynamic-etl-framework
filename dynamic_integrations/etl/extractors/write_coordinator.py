"""
WriteCoordinator - Coordinates database writes to avoid race conditions in multi-threaded environments
"""

import logging
import threading
from functools import wraps
from typing import Any, Callable, Dict, Optional


class WriteCoordinator:
    """
    Coordinates database writes to avoid race conditions between multiple threads

    Features:
    - Table-level locking to prevent concurrent writes to same stage table
    - Thread-safe lock creation and management
    - Support for different write modes (overwrite, append, upsert)
    - Comprehensive logging for troubleshooting
    """

    def __init__(self, logger_name: str = None):
        """
        Initialize WriteCoordinator

        Args:
            logger_name: Custom logger name for this coordinator
        """
        # Dictionary to store locks for each stage table
        self._table_locks: Dict[str, threading.Lock] = {}

        # Lock for creating new table locks (thread-safe lock creation)
        self._lock_creation_lock = threading.Lock()

        # Logging setup
        self.logger = logging.getLogger(logger_name or f"{__name__}.WriteCoordinator")

        # Statistics tracking
        self._write_stats = {
            'total_writes': 0,
            'concurrent_blocks': 0,
            'tables_accessed': set()
        }
        self._stats_lock = threading.Lock()

    def get_table_lock(self, stage_table: str) -> threading.Lock:
        """
        Get or create lock for specific stage table

        Uses double-checked locking pattern for thread-safe lock creation

        Args:
            stage_table: Name of the stage table

        Returns:
            Threading lock for the specified table
        """
        if stage_table not in self._table_locks:
            with self._lock_creation_lock:
                # Double-checked locking pattern
                if stage_table not in self._table_locks:
                    self._table_locks[stage_table] = threading.Lock()
                    self.logger.debug(f"🔐 Created new lock for table: {stage_table}")

                    # Track table access
                    with self._stats_lock:
                        self._write_stats['tables_accessed'].add(stage_table)

        return self._table_locks[stage_table]

    def synchronized_write(self, stage_table: str, write_func: Callable, *args, **kwargs) -> Any:
        """
        Execute write function with table-level locking

        Args:
            stage_table: Name of the stage table being written to
            write_func: Function to execute (should perform the actual write)
            *args, **kwargs: Arguments to pass to write_func

        Returns:
            Result of write_func execution
        """
        table_lock = self.get_table_lock(stage_table)

        # Track if we had to wait for lock (indicates concurrent access)
        lock_acquired_immediately = table_lock.acquire(blocking=False)

        if not lock_acquired_immediately:
            self.logger.debug(f"⏳ Waiting for write lock on table: {stage_table}")
            table_lock.acquire()  # Block until we can acquire

            with self._stats_lock:
                self._write_stats['concurrent_blocks'] += 1

        try:
            self.logger.debug(f"🔒 Acquired write lock for table: {stage_table}")

            # Track write operation
            with self._stats_lock:
                self._write_stats['total_writes'] += 1

            # Execute the write function
            result = write_func(*args, **kwargs)

            self.logger.debug(f"✅ Write completed for table: {stage_table}")
            return result

        except Exception as e:
            self.logger.error(f"❌ Write failed for table {stage_table}: {e}")
            raise

        finally:
            table_lock.release()
            self.logger.debug(f"🔓 Released write lock for table: {stage_table}")

    def synchronized_write_with_mode(self, stage_table: str, write_mode: str,
                                   write_func: Callable, *args, **kwargs) -> Any:
        """
        Execute write function with table-level locking and write mode consideration

        Handles special logic for different write modes:
        - 'overwrite': Ensures only one thread can truncate and write
        - 'append': Allows concurrent appends (but still synchronized)
        - 'upsert': Allows concurrent upserts

        Args:
            stage_table: Name of the stage table
            write_mode: Write mode ('overwrite', 'append', 'upsert')
            write_func: Function to execute
            *args, **kwargs: Arguments for write_func

        Returns:
            Result of write_func execution
        """
        if write_mode == 'overwrite':
            self.logger.info(f"🗑️ Overwrite mode for {stage_table} - ensuring exclusive access")

        return self.synchronized_write(stage_table, write_func, *args, **kwargs)

    def get_stats(self) -> Dict[str, Any]:
        """
        Get coordination statistics

        Returns:
            Dictionary with coordination statistics
        """
        with self._stats_lock:
            return {
                'total_writes': self._write_stats['total_writes'],
                'concurrent_blocks': self._write_stats['concurrent_blocks'],
                'tables_accessed': len(self._write_stats['tables_accessed']),
                'active_locks': len(self._table_locks),
                'contention_rate': (
                    self._write_stats['concurrent_blocks'] / max(self._write_stats['total_writes'], 1) * 100
                )
            }

    def reset_stats(self):
        """Reset coordination statistics"""
        with self._stats_lock:
            self._write_stats = {
                'total_writes': 0,
                'concurrent_blocks': 0,
                'tables_accessed': set()
            }

    def cleanup_locks(self, stage_table: Optional[str] = None):
        """
        Cleanup locks for specified table or all tables

        Args:
            stage_table: Specific table to cleanup, or None for all tables
        """
        with self._lock_creation_lock:
            if stage_table:
                if stage_table in self._table_locks:
                    del self._table_locks[stage_table]
                    self.logger.debug(f"🧹 Cleaned up lock for table: {stage_table}")
            else:
                count = len(self._table_locks)
                self._table_locks.clear()
                self.logger.debug(f"🧹 Cleaned up {count} table locks")


def synchronized_write(stage_table_attr: str = 'stage_table'):
    """
    Decorator for synchronizing write operations

    Usage:
    @synchronized_write()
    def my_write_function(self, data, stage_table, ...):
        # Write logic here
        pass

    @synchronized_write('table_name')
    def my_write_function(self, data, table_name, ...):
        # Write logic here - uses 'table_name' instead of 'stage_table'
        pass

    Args:
        stage_table_attr: Name of the parameter/attribute containing stage table name
    """
    def decorator(func):
        @wraps(func)
        def wrapper(self, *args, **kwargs):
            # Get or create write coordinator
            if not hasattr(self, '_write_coordinator'):
                logger_name = f"{self.__class__.__name__}.WriteCoordinator"
                self._write_coordinator = WriteCoordinator(logger_name)

            # Extract stage table name from arguments or kwargs
            stage_table = None

            # Try to get from kwargs first
            if stage_table_attr in kwargs:
                stage_table = kwargs[stage_table_attr]
            else:
                # Try to get from self attribute
                if hasattr(self, stage_table_attr):
                    stage_table = getattr(self, stage_table_attr)

            if not stage_table:
                raise ValueError(f"Could not determine stage table name from {stage_table_attr}")

            # Execute function with coordination
            def write_operation():
                return func(self, *args, **kwargs)

            return self._write_coordinator.synchronized_write(stage_table, write_operation)

        return wrapper
    return decorator


class WriteMode:
    """Constants for different write modes"""
    OVERWRITE = 'overwrite'
    APPEND = 'append'
    UPSERT = 'upsert'


# Example usage
if __name__ == "__main__":
    import time
    import threading

    # Setup logging
    logging.basicConfig(level=logging.DEBUG)

    # Test WriteCoordinator
    coordinator = WriteCoordinator()

    def simulate_write(table_name: str, data: str, delay: float = 0.5):
        """Simulate a database write operation"""
        print(f"Writing to {table_name}: {data}")
        time.sleep(delay)  # Simulate write time
        print(f"Completed writing to {table_name}: {data}")
        return f"result_{data}"

    # Test concurrent writes to same table
    def test_concurrent_writes():
        results = []

        def writer(writer_id: int):
            result = coordinator.synchronized_write(
                "test_table",
                simulate_write,
                "test_table",
                f"data_from_writer_{writer_id}"
            )
            results.append(result)

        # Start multiple threads writing to same table
        threads = []
        for i in range(3):
            t = threading.Thread(target=writer, args=(i,))
            threads.append(t)
            t.start()

        # Wait for completion
        for t in threads:
            t.join()

        print(f"Results: {results}")
        print(f"Stats: {coordinator.get_stats()}")

    test_concurrent_writes()