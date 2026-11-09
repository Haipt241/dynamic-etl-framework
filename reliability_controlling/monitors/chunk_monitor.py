"""
Chunk retry monitor

Enhanced version of the existing chunk retry functionality from dynamic_integrations.
Provides enterprise-level monitoring for chunk-based operations like SQL generation.
"""

from typing import Dict, Any, Optional, List
from pathlib import Path
import json
from .base_monitor import BaseRetryMonitor, RetryAttempt, OperationRecord


class ChunkMonitor(BaseRetryMonitor):
    """
    Monitor for chunk-based retry operations
    
    Enhanced version of the existing ChunkRetryMonitor from dynamic_integrations
    with enterprise-level monitoring capabilities.
    """
    
    def __init__(self, operation_name: str, config: Optional[Any] = None,
                 integration_name: Optional[str] = None,
                 sql_type: Optional[str] = None):
        """
        Initialize chunk monitor
        
        Args:
            operation_name: Name of the operation being monitored
            config: Retry configuration object
            integration_name: Name of integration
            sql_type: Type of SQL being generated (stage, prod, view, procedure)
        """
        super().__init__(operation_name, config, integration_name)
        
        self.sql_type = sql_type
        
        # Chunk-specific tracking
        self.total_chunks = 0
        self.successful_chunks: List[int] = []
        self.failed_chunks: List[int] = []
        self.template_fallback_chunks: List[int] = []
        
        # Statistics
        self._chunk_success_count = 0
        self._chunk_failure_count = 0
        self._template_fallback_count = 0
        self._llm_refinement_success_count = 0
        self._empty_sql_count = 0
    
    def set_total_chunks(self, total: int) -> None:
        """Set total number of chunks being processed"""
        self.total_chunks = total
        print(f"📦 Chunk Monitor: Processing {total} chunks for '{self.operation_name}'")
    
    def log_chunk_result(self, chunk_number: int, success: bool, 
                        template_fallback: bool = False, 
                        llm_refinement_success: bool = False,
                        sql_length: Optional[int] = None,
                        error_message: Optional[str] = None) -> None:
        """
        Log the result of a chunk processing attempt
        
        Args:
            chunk_number: The chunk number (1-based indexing)
            success: Whether the chunk processing succeeded
            template_fallback: Whether template fallback was used
            llm_refinement_success: Whether LLM refinement was successful
            sql_length: Length of generated SQL
            error_message: Error message if failed
        """
        if success:
            self.successful_chunks.append(chunk_number)
            self._chunk_success_count += 1
            
            if template_fallback:
                self.template_fallback_chunks.append(chunk_number)
                self._template_fallback_count += 1
            
            if llm_refinement_success:
                self._llm_refinement_success_count += 1
                
            if sql_length == 0:
                self._empty_sql_count += 1
                
        else:
            self.failed_chunks.append(chunk_number)
            self._chunk_failure_count += 1
        
        # Add to current operation context
        if self.current_operation:
            if 'chunk_results' not in self.current_operation.context:
                self.current_operation.context['chunk_results'] = []
            
            self.current_operation.context['chunk_results'].append({
                'chunk_number': chunk_number,
                'success': success,
                'template_fallback': template_fallback,
                'llm_refinement_success': llm_refinement_success,
                'sql_length': sql_length,
                'error_message': error_message
            })
        
        # Log the result
        status_emoji = "✅" if success else "❌"
        fallback_note = " (template fallback)" if template_fallback else ""
        sql_note = f" (sql: {sql_length} chars)" if sql_length is not None else ""
        
        print(f"📦 Chunk Monitor: {status_emoji} Chunk {chunk_number}{fallback_note}{sql_note}")
        
        if error_message:
            print(f"   Error: {error_message}")
    
    def log_llm_refinement_attempt(self, chunk_number: int, template_length: int,
                                  refined_length: int, validation_success: bool) -> None:
        """
        Log an LLM refinement attempt
        
        Args:
            chunk_number: The chunk number
            template_length: Length of template SQL
            refined_length: Length of refined SQL
            validation_success: Whether refined SQL passed validation
        """
        # Add to current operation context
        if self.current_operation:
            if 'llm_refinements' not in self.current_operation.context:
                self.current_operation.context['llm_refinements'] = []
            
            self.current_operation.context['llm_refinements'].append({
                'chunk_number': chunk_number,
                'template_length': template_length,
                'refined_length': refined_length,
                'validation_success': validation_success
            })
        
        status = "✅" if validation_success else "🔄"
        print(f"📦 Chunk Monitor: {status} Chunk {chunk_number} LLM refinement "
              f"(template: {template_length} → refined: {refined_length} chars)")
    
    def get_failed_chunk_numbers(self) -> List[int]:
        """Get list of failed chunk numbers"""
        return self.failed_chunks.copy()
    
    def generate_retry_command(self) -> Optional[str]:
        """
        Generate retry command for failed chunks (compatible with existing chunk_retrier)
        
        Returns:
            Retry command string or None if no failures
        """
        if not self.failed_chunks:
            return None
        
        failed_chunks_str = ",".join(map(str, sorted(self.failed_chunks)))
        
        if self.sql_type:
            return (f"python chunk_retrier.py --integration {self.integration_name} "
                   f"--sql-type {self.sql_type} --chunks {failed_chunks_str}")
        else:
            return f"Retry chunks: {failed_chunks_str}"
    
    def save_retry_status(self, output_dir: Optional[Path] = None) -> Path:
        """
        Save retry status compatible with existing ChunkRetryMonitor format
        
        Args:
            output_dir: Directory to save status (default: analysis_generated/retry_monitoring)
            
        Returns:
            Path to saved status file
        """
        if output_dir is None:
            output_dir = Path("analysis_generated") / "retry_monitoring"
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate status in compatible format
        status = {
            "integration": self.integration_name,
            "sql_type": self.sql_type,
            "operation_name": self.operation_name,
            "total_chunks": self.total_chunks,
            "successful_chunks": sorted(self.successful_chunks),
            "failed_chunks": sorted(self.failed_chunks),
            "template_fallback_chunks": sorted(self.template_fallback_chunks),
            "status": "partial_failure" if self.failed_chunks else "success",
            "statistics": {
                "success_rate": (len(self.successful_chunks) / self.total_chunks * 100) if self.total_chunks > 0 else 0,
                "template_fallback_rate": (len(self.template_fallback_chunks) / len(self.successful_chunks) * 100) if self.successful_chunks else 0,
                "llm_refinement_success_count": self._llm_refinement_success_count,
                "empty_sql_count": self._empty_sql_count
            }
        }
        
        # Add retry command if needed
        retry_command = self.generate_retry_command()
        if retry_command:
            status["retry_command"] = retry_command
        
        # Save status file
        if self.sql_type:
            filename = f"retry_status_{self.integration_name}_{self.sql_type}.json"
        else:
            filename = f"chunk_status_{self.operation_name}.json"
            
        status_file = output_dir / filename
        
        with open(status_file, 'w') as f:
            json.dump(status, f, indent=2)
        
        return status_file
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get chunk-specific statistics"""
        base_stats = super().get_statistics()
        
        # Calculate rates
        success_rate = 0.0
        template_fallback_rate = 0.0
        llm_success_rate = 0.0
        
        if self.total_chunks > 0:
            success_rate = (len(self.successful_chunks) / self.total_chunks) * 100
        
        if self.successful_chunks:
            template_fallback_rate = (len(self.template_fallback_chunks) / len(self.successful_chunks)) * 100
        
        if self._chunk_success_count > 0:
            llm_success_rate = (self._llm_refinement_success_count / self._chunk_success_count) * 100
        
        # Add chunk-specific metrics
        chunk_stats = {
            'sql_type': self.sql_type,
            'total_chunks': self.total_chunks,
            'successful_chunks': len(self.successful_chunks),
            'failed_chunks': len(self.failed_chunks),
            'template_fallback_chunks': len(self.template_fallback_chunks),
            'chunk_success_rate': round(success_rate, 2),
            'template_fallback_rate': round(template_fallback_rate, 2),
            'llm_refinement_success_rate': round(llm_success_rate, 2),
            'empty_sql_count': self._empty_sql_count,
            'failed_chunk_numbers': sorted(self.failed_chunks),
            'retry_command': self.generate_retry_command()
        }
        
        # Merge with base statistics
        base_stats.update(chunk_stats)
        return base_stats
    
    # Implementation of abstract methods
    
    def _log_operation_start(self) -> None:
        """Log chunk operation start"""
        operation_desc = f"{self.sql_type} SQL generation" if self.sql_type else "chunk processing"
        print(f"📦 Chunk Monitor: Starting {operation_desc} for '{self.operation_name}'")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="CHUNK_RETRY_START",
                StatusMessage=f"Starting chunk operation: {self.operation_name} ({operation_desc})",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "CHUNK_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_attempt(self, attempt: RetryAttempt) -> None:
        """Log chunk retry attempt"""
        status_emoji = "❌" if attempt.exception_type else "✅"
        delay_info = f" (delay: {attempt.delay_seconds:.2f}s)" if attempt.delay_seconds else ""
        
        print(f"📦 Chunk Monitor: {status_emoji} Attempt {attempt.attempt_number} "
              f"for '{self.operation_name}'{delay_info}")
        
        if attempt.exception_type:
            print(f"   Error: {attempt.exception_type} - {attempt.exception_message}")
    
    def _log_success(self) -> None:
        """Log chunk operation success"""
        if not self.current_operation:
            return
            
        success_rate = (len(self.successful_chunks) / self.total_chunks * 100) if self.total_chunks > 0 else 0
        fallback_rate = (len(self.template_fallback_chunks) / len(self.successful_chunks) * 100) if self.successful_chunks else 0
        
        print(f"📦 Chunk Monitor: ✅ Operation '{self.operation_name}' succeeded")
        print(f"   Chunks: {len(self.successful_chunks)}/{self.total_chunks} successful ({success_rate:.1f}%)")
        
        if self.template_fallback_chunks:
            print(f"   Template fallback: {len(self.template_fallback_chunks)} chunks ({fallback_rate:.1f}%)")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            LoggingDetails(
                TaskName="CHUNK_RETRY_SUCCESS",
                StatusMessage=f"Chunk operation succeeded: {self.operation_name} "
                             f"({len(self.successful_chunks)}/{self.total_chunks} chunks)",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=[],
                integration_name=self.integration_name or "CHUNK_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_failure(self, exception: Exception) -> None:
        """Log chunk operation failure"""
        if not self.current_operation:
            return
            
        success_rate = (len(self.successful_chunks) / self.total_chunks * 100) if self.total_chunks > 0 else 0
        
        print(f"📦 Chunk Monitor: ❌ Operation '{self.operation_name}' failed")
        print(f"   Chunks: {len(self.successful_chunks)}/{self.total_chunks} successful ({success_rate:.1f}%)")
        print(f"   Failed chunks: {sorted(self.failed_chunks)}")
        print(f"   Final error: {type(exception).__name__} - {str(exception)}")
        
        # Show retry command
        retry_command = self.generate_retry_command()
        if retry_command:
            print(f"   Retry command: {retry_command}")
        
        # Try to integrate with enterprise logging
        try:
            from sql_helper import LoggingDetails
            error_list = [f"Failed chunks: {sorted(self.failed_chunks)}", str(exception)]
            LoggingDetails(
                TaskName="CHUNK_RETRY_FAILURE",
                StatusMessage=f"Chunk operation failed: {self.operation_name} "
                             f"({len(self.successful_chunks)}/{self.total_chunks} chunks) - {str(exception)}",
                job_id=getattr(self.config, 'job_id', 1) if self.config else 1,
                job_run_id=getattr(self.config, 'job_run_id', 1) if self.config else 1,
                error_list=error_list,
                integration_name=self.integration_name or "CHUNK_MONITOR"
            )
        except ImportError:
            pass
    
    def _log_operation_end(self, operation: OperationRecord) -> None:
        """Log chunk operation end"""
        status = "SUCCESS" if operation.success else "FAILURE"
        duration_str = f" ({operation.duration_seconds:.2f}s)" if operation.duration_seconds else ""
        
        print(f"📦 Chunk Monitor: Operation '{operation.operation_name}' ended - "
              f"{status}{duration_str}")
        
        # Print detailed chunk summary
        if self.total_chunks > 0:
            success_rate = (len(self.successful_chunks) / self.total_chunks) * 100
            print(f"   Final chunk results: {len(self.successful_chunks)}/{self.total_chunks} "
                  f"successful ({success_rate:.1f}%)")
            
            if self.template_fallback_chunks:
                fallback_rate = (len(self.template_fallback_chunks) / len(self.successful_chunks)) * 100
                print(f"   Template fallback used: {len(self.template_fallback_chunks)} chunks "
                      f"({fallback_rate:.1f}% of successful)")
            
            if self._llm_refinement_success_count > 0:
                llm_rate = (self._llm_refinement_success_count / len(self.successful_chunks)) * 100
                print(f"   LLM refinement successful: {self._llm_refinement_success_count} chunks "
                      f"({llm_rate:.1f}% of successful)")
            
            if self.failed_chunks:
                retry_command = self.generate_retry_command()
                if retry_command:
                    print(f"   🔄 {retry_command}")
                    
        # Save retry status automatically
        try:
            status_file = self.save_retry_status()
            print(f"   📊 Status saved: {status_file}")
        except Exception as e:
            print(f"   ⚠️ Failed to save status: {e}")