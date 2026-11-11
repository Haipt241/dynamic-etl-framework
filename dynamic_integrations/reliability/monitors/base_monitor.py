"""
Base retry monitor

Abstract base class for all retry monitors, providing common functionality
and interface. Inspired by enterprise's monitoring patterns.
"""

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Dict, List, Optional, Any, Type
import json
from pathlib import Path


@dataclass
class RetryAttempt:
    """Single retry attempt record"""
    attempt_number: int
    timestamp: datetime
    exception_type: Optional[str] = None
    exception_message: Optional[str] = None
    delay_seconds: Optional[float] = None
    success: bool = False


@dataclass
class OperationRecord:
    """Complete operation record with all retry attempts"""
    operation_name: str
    start_time: datetime
    end_time: Optional[datetime] = None
    total_attempts: int = 0
    success: bool = False
    final_exception: Optional[str] = None
    attempts: List[RetryAttempt] = field(default_factory=list)
    context: Dict[str, Any] = field(default_factory=dict)
    
    @property
    def duration_seconds(self) -> Optional[float]:
        """Calculate total operation duration"""
        if self.start_time and self.end_time:
            return (self.end_time - self.start_time).total_seconds()
        return None
    
    @property
    def total_delay_seconds(self) -> float:
        """Calculate total delay time from retries"""
        return sum(attempt.delay_seconds or 0 for attempt in self.attempts)


class BaseRetryMonitor(ABC):
    """
    Abstract base class for retry monitors
    
    Provides common functionality for tracking and reporting retry operations.
    Follows enterprise's monitoring philosophy but with enhanced structure.
    """
    
    def __init__(self, operation_name: str, config: Optional[Any] = None,
                 integration_name: Optional[str] = None):
        """
        Initialize base monitor
        
        Args:
            operation_name: Name of the operation being monitored
            config: Retry configuration object
            integration_name: Name of integration (enterprise-style)
        """
        self.operation_name = operation_name
        self.config = config
        self.integration_name = integration_name
        
        # Current operation tracking
        self.current_operation: Optional[OperationRecord] = None
        self.operation_history: List[OperationRecord] = []
        
        # Statistics
        self._total_operations = 0
        self._successful_operations = 0
        self._failed_operations = 0
        
    def start_operation(self, context: Optional[Dict[str, Any]] = None) -> None:
        """
        Start monitoring an operation
        
        Args:
            context: Additional context information
        """
        self.current_operation = OperationRecord(
            operation_name=self.operation_name,
            start_time=datetime.now(timezone.utc),
            context=context or {}
        )
        
        self._total_operations += 1
        self._log_operation_start()
    
    def log_attempt(self, attempt_number: int, exception: Optional[Exception] = None,
                   delay_seconds: Optional[float] = None) -> None:
        """
        Log a retry attempt
        
        Args:
            attempt_number: The attempt number (1-based)
            exception: Exception that triggered the retry
            delay_seconds: Delay before next attempt
        """
        if not self.current_operation:
            return
        
        attempt = RetryAttempt(
            attempt_number=attempt_number,
            timestamp=datetime.now(timezone.utc),
            exception_type=type(exception).__name__ if exception else None,
            exception_message=str(exception) if exception else None,
            delay_seconds=delay_seconds,
            success=exception is None
        )
        
        self.current_operation.attempts.append(attempt)
        self.current_operation.total_attempts = max(
            self.current_operation.total_attempts, 
            attempt_number
        )
        
        self._log_attempt(attempt)
    
    def log_success(self) -> None:
        """Log successful completion of operation"""
        if not self.current_operation:
            return
        
        self.current_operation.success = True
        self.current_operation.end_time = datetime.now(timezone.utc)
        self._successful_operations += 1
        
        self._log_success()
    
    def log_failure(self, final_exception: Exception) -> None:
        """
        Log final failure of operation
        
        Args:
            final_exception: The final exception that caused failure
        """
        if not self.current_operation:
            return
        
        self.current_operation.success = False
        self.current_operation.end_time = datetime.now(timezone.utc)
        self.current_operation.final_exception = str(final_exception)
        self._failed_operations += 1
        
        self._log_failure(final_exception)
    
    def end_operation(self) -> Optional[OperationRecord]:
        """
        End the current operation and return the record
        
        Returns:
            The completed operation record
        """
        if not self.current_operation:
            return None
        
        if self.current_operation.end_time is None:
            self.current_operation.end_time = datetime.now(timezone.utc)
        
        # Add to history
        self.operation_history.append(self.current_operation)
        
        # Keep history manageable (last 100 operations)
        if len(self.operation_history) > 100:
            self.operation_history = self.operation_history[-100:]
        
        completed_operation = self.current_operation
        self.current_operation = None
        
        self._log_operation_end(completed_operation)
        
        return completed_operation
    
    def get_statistics(self) -> Dict[str, Any]:
        """
        Get monitoring statistics
        
        Returns:
            Dictionary with monitoring statistics
        """
        success_rate = 0.0
        if self._total_operations > 0:
            success_rate = (self._successful_operations / self._total_operations) * 100
        
        # Calculate average attempts for successful operations
        successful_ops = [op for op in self.operation_history if op.success]
        avg_attempts = 0.0
        if successful_ops:
            avg_attempts = sum(op.total_attempts for op in successful_ops) / len(successful_ops)
        
        return {
            'operation_name': self.operation_name,
            'integration_name': self.integration_name,
            'monitor_type': self.__class__.__name__,
            'total_operations': self._total_operations,
            'successful_operations': self._successful_operations,
            'failed_operations': self._failed_operations,
            'success_rate_percent': round(success_rate, 2),
            'average_attempts_successful': round(avg_attempts, 2),
            'current_operation_active': self.current_operation is not None
        }
    
    def save_report(self, output_dir: Optional[Path] = None) -> Path:
        """
        Save monitoring report to file
        
        Args:
            output_dir: Directory to save report (default: ./retry_reports)
            
        Returns:
            Path to saved report file
        """
        if output_dir is None:
            output_dir = Path("retry_reports")
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate report data
        report_data = {
            'metadata': {
                'generated_at': datetime.now(timezone.utc).isoformat(),
                'operation_name': self.operation_name,
                'integration_name': self.integration_name,
                'monitor_type': self.__class__.__name__
            },
            'statistics': self.get_statistics(),
            'recent_operations': [
                {
                    'operation_name': op.operation_name,
                    'start_time': op.start_time.isoformat(),
                    'end_time': op.end_time.isoformat() if op.end_time else None,
                    'duration_seconds': op.duration_seconds,
                    'total_attempts': op.total_attempts,
                    'success': op.success,
                    'final_exception': op.final_exception,
                    'total_delay_seconds': op.total_delay_seconds,
                    'attempts': [
                        {
                            'attempt_number': attempt.attempt_number,
                            'timestamp': attempt.timestamp.isoformat(),
                            'exception_type': attempt.exception_type,
                            'exception_message': attempt.exception_message,
                            'delay_seconds': attempt.delay_seconds,
                            'success': attempt.success
                        }
                        for attempt in op.attempts
                    ]
                }
                for op in self.operation_history[-20:]  # Last 20 operations
            ]
        }
        
        # Save report
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{self.__class__.__name__.lower()}_{self.operation_name}_{timestamp}.json"
        report_path = output_dir / filename
        
        with open(report_path, 'w') as f:
            json.dump(report_data, f, indent=2, default=str)
        
        return report_path
    
    # Abstract methods for subclass implementation
    
    @abstractmethod
    def _log_operation_start(self) -> None:
        """Log the start of an operation (subclass implementation)"""
        pass
    
    @abstractmethod  
    def _log_attempt(self, attempt: RetryAttempt) -> None:
        """Log a retry attempt (subclass implementation)"""
        pass
    
    @abstractmethod
    def _log_success(self) -> None:
        """Log successful completion (subclass implementation)"""
        pass
    
    @abstractmethod
    def _log_failure(self, exception: Exception) -> None:
        """Log operation failure (subclass implementation)"""
        pass
    
    @abstractmethod
    def _log_operation_end(self, operation: OperationRecord) -> None:
        """Log the end of an operation (subclass implementation)"""
        pass