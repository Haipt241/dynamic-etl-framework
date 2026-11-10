"""
Exception analyzer

Analyzes exceptions and provides recommendations for retry strategies.
Helps determine appropriate retry behavior based on exception characteristics.
"""

from typing import Dict, Any, List, Optional, Tuple, Set
import re
from dynamic_integrations.reliability.core.strategies import RetryStrategy


class ExceptionAnalyzer:
    """
    Analyzer for exceptions and retry recommendations
    
    Provides intelligent analysis of exceptions to determine
    appropriate retry strategies and configurations.
    """
    
    # Exception patterns for different categories
    EXCEPTION_PATTERNS = {
        'database': {
            'names': [
                'sqlalchemy', 'operational', 'programming', 'integrity',
                'database', 'connection', 'mysql', 'postgresql', 'sqlite'
            ],
            'messages': [
                'connection', 'deadlock', 'lock wait', 'timeout',
                'server has gone away', 'lost connection', 'query'
            ]
        },
        
        'api': {
            'names': [
                'http', 'request', 'connection', 'timeout', 'url'
            ],
            'messages': [
                'gateway', 'server error', 'service unavailable',
                'too many requests', 'rate limit', 'connection',
                'timeout', '502', '503', '504', '429', '500'
            ]
        },
        
        'generation': {
            'names': [
                'json', 'parsing', 'generation', 'completion', 'llm'
            ],
            'messages': [
                'parsing', 'json', 'malformed', 'empty response',
                'generation', 'completion', 'token', 'model'
            ]
        },
        
        'network': {
            'names': [
                'connection', 'network', 'socket', 'dns'
            ],
            'messages': [
                'connection refused', 'connection reset', 'network',
                'dns', 'host', 'unreachable'
            ]
        }
    }
    
    # Retry confidence levels
    RETRY_CONFIDENCE = {
        'high': 0.8,      # Very likely to succeed on retry
        'medium': 0.6,    # Moderately likely to succeed
        'low': 0.3,       # Low chance of success
        'none': 0.0       # Should not retry
    }
    
    def analyze_exception(self, exception: Exception, 
                         context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Analyze an exception and provide retry recommendations
        
        Args:
            exception: Exception to analyze
            context: Additional context (operation type, attempt number, etc.)
            
        Returns:
            Analysis results with recommendations
        """
        analysis = {
            'exception_type': type(exception).__name__,
            'exception_message': str(exception),
            'category': self._categorize_exception(exception),
            'retry_recommendation': None,
            'recommended_strategy': None,
            'confidence': 0.0,
            'reasons': [],
            'configuration_suggestions': {}
        }
        
        # Categorize and analyze
        category = analysis['category']
        retry_decision = self._should_retry_exception(exception, category, context)
        
        analysis['retry_recommendation'] = retry_decision['should_retry']
        analysis['confidence'] = retry_decision['confidence']
        analysis['reasons'] = retry_decision['reasons']
        
        # Recommend strategy
        if analysis['retry_recommendation']:
            analysis['recommended_strategy'] = self._recommend_strategy(exception, category, context)
            analysis['configuration_suggestions'] = self._suggest_configuration(
                exception, category, analysis['recommended_strategy'], context
            )
        
        return analysis
    
    def _categorize_exception(self, exception: Exception) -> str:
        """Categorize exception into broad categories"""
        exception_name = type(exception).__name__.lower()
        exception_message = str(exception).lower()
        
        # Check each category
        for category, patterns in self.EXCEPTION_PATTERNS.items():
            # Check exception name patterns
            if any(pattern in exception_name for pattern in patterns['names']):
                return category
            
            # Check message patterns
            if any(pattern in exception_message for pattern in patterns['messages']):
                return category
        
        # Default categorization based on common exception types
        if 'timeout' in exception_name or 'timeout' in exception_message:
            return 'network'
        elif 'connection' in exception_name or 'connection' in exception_message:
            return 'network'
        elif 'http' in exception_name or any(code in exception_message for code in ['500', '502', '503', '504']):
            return 'api'
        
        return 'unknown'
    
    def _should_retry_exception(self, exception: Exception, category: str,
                              context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Determine if exception should trigger retry"""
        decision = {
            'should_retry': False,
            'confidence': 0.0,
            'reasons': []
        }
        
        exception_message = str(exception).lower()
        
        # Category-specific retry logic
        if category == 'database':
            decision = self._analyze_database_exception(exception, exception_message)
        elif category == 'api':
            decision = self._analyze_api_exception(exception, exception_message)
        elif category == 'generation':
            decision = self._analyze_generation_exception(exception, exception_message)
        elif category == 'network':
            decision = self._analyze_network_exception(exception, exception_message)
        else:
            # Unknown category - conservative approach
            decision['should_retry'] = True
            decision['confidence'] = self.RETRY_CONFIDENCE['low']
            decision['reasons'] = ['Unknown exception type - may be transient']
        
        # Apply context-based adjustments
        if context:
            decision = self._apply_context_adjustments(decision, context)
        
        return decision
    
    def _analyze_database_exception(self, exception: Exception, message: str) -> Dict[str, Any]:
        """Analyze database-specific exceptions"""
        # Non-retryable patterns
        non_retryable = [
            'syntax error', 'parse error', 'table does not exist',
            'column does not exist', 'access denied', 'permission denied'
        ]
        
        if any(pattern in message for pattern in non_retryable):
            return {
                'should_retry': False,
                'confidence': self.RETRY_CONFIDENCE['none'],
                'reasons': ['Permanent database error - requires manual fix']
            }
        
        # Retryable patterns
        retryable_patterns = {
            'deadlock': ('high', 'Deadlock detected - very likely to succeed on retry'),
            'lock wait': ('high', 'Lock timeout - retry after delay'),
            'connection': ('medium', 'Connection issue - may recover'),
            'timeout': ('medium', 'Database timeout - retry with backoff'),
            'server has gone away': ('medium', 'Server connection lost - may reconnect'),
            'too many connections': ('low', 'Connection pool exhausted - may recover')
        }
        
        for pattern, (confidence, reason) in retryable_patterns.items():
            if pattern in message:
                return {
                    'should_retry': True,
                    'confidence': self.RETRY_CONFIDENCE[confidence],
                    'reasons': [reason]
                }
        
        # Default for database errors
        return {
            'should_retry': True,
            'confidence': self.RETRY_CONFIDENCE['medium'],
            'reasons': ['Database error may be transient']
        }
    
    def _analyze_api_exception(self, exception: Exception, message: str) -> Dict[str, Any]:
        """Analyze API-specific exceptions"""
        # Extract status code if available
        status_code = self._extract_status_code(message)
        
        if status_code:
            # Non-retryable status codes
            if status_code in [400, 401, 403, 404, 405, 409, 422]:
                return {
                    'should_retry': False,
                    'confidence': self.RETRY_CONFIDENCE['none'],
                    'reasons': [f'HTTP {status_code} - client error, fix request']
                }
            
            # Retryable status codes
            retryable_codes = {
                429: ('high', 'Rate limit - retry with backoff'),
                502: ('high', 'Bad Gateway - service issue'),
                503: ('high', 'Service Unavailable - temporary'),
                504: ('high', 'Gateway Timeout - service slow'),
                500: ('medium', 'Internal Server Error - may be temporary')
            }
            
            if status_code in retryable_codes:
                confidence, reason = retryable_codes[status_code]
                return {
                    'should_retry': True,
                    'confidence': self.RETRY_CONFIDENCE[confidence],
                    'reasons': [reason]
                }
        
        # Check for timeout/connection errors
        if any(term in message for term in ['timeout', 'connection']):
            return {
                'should_retry': True,
                'confidence': self.RETRY_CONFIDENCE['high'],
                'reasons': ['Network/timeout error - likely transient']
            }
        
        # Default for API errors
        return {
            'should_retry': True,
            'confidence': self.RETRY_CONFIDENCE['medium'],
            'reasons': ['API error may be temporary']
        }
    
    def _analyze_generation_exception(self, exception: Exception, message: str) -> Dict[str, Any]:
        """Analyze generation-specific exceptions"""
        # Non-retryable patterns
        non_retryable = [
            'api key', 'authentication', 'unauthorized', 'access denied',
            'context length', 'context window', 'content policy'
        ]
        
        if any(pattern in message for pattern in non_retryable):
            return {
                'should_retry': False,
                'confidence': self.RETRY_CONFIDENCE['none'],
                'reasons': ['Permanent configuration/policy error']
            }
        
        # Retryable patterns
        retryable_patterns = {
            'parsing': ('high', 'Response parsing failed - may get valid response'),
            'empty response': ('high', 'Empty response - retry may succeed'),
            'timeout': ('medium', 'Generation timeout - retry with backoff'),
            'rate limit': ('medium', 'Rate limit - retry with delay'),
            'service': ('medium', 'Service error - may be temporary')
        }
        
        for pattern, (confidence, reason) in retryable_patterns.items():
            if pattern in message:
                return {
                    'should_retry': True,
                    'confidence': self.RETRY_CONFIDENCE[confidence],
                    'reasons': [reason]
                }
        
        # Default for generation errors
        return {
            'should_retry': True,
            'confidence': self.RETRY_CONFIDENCE['medium'],
            'reasons': ['Generation error may be transient']
        }
    
    def _analyze_network_exception(self, exception: Exception, message: str) -> Dict[str, Any]:
        """Analyze network-specific exceptions"""
        # Network errors are generally retryable
        network_patterns = {
            'connection refused': ('medium', 'Connection refused - service may be down'),
            'connection reset': ('high', 'Connection reset - retry should work'),
            'timeout': ('high', 'Network timeout - retry with backoff'),
            'dns': ('low', 'DNS error - may require time to resolve'),
            'unreachable': ('low', 'Network unreachable - infrastructure issue')
        }
        
        for pattern, (confidence, reason) in network_patterns.items():
            if pattern in message:
                return {
                    'should_retry': True,
                    'confidence': self.RETRY_CONFIDENCE[confidence],
                    'reasons': [reason]
                }
        
        # Default for network errors
        return {
            'should_retry': True,
            'confidence': self.RETRY_CONFIDENCE['medium'],
            'reasons': ['Network error likely transient']
        }
    
    def _apply_context_adjustments(self, decision: Dict[str, Any], 
                                 context: Dict[str, Any]) -> Dict[str, Any]:
        """Apply context-based adjustments to retry decision"""
        # Reduce confidence if many attempts already made
        if 'attempt_number' in context and context['attempt_number'] > 2:
            decision['confidence'] *= 0.8
            decision['reasons'].append(f"Confidence reduced due to {context['attempt_number']} attempts")
        
        # Consider operation criticality
        if context.get('critical', False):
            decision['confidence'] *= 1.2  # Increase willingness to retry
            decision['reasons'].append("Critical operation - increased retry confidence")
        
        # Consider time constraints
        if context.get('time_sensitive', False) and decision['confidence'] < 0.5:
            decision['should_retry'] = False
            decision['reasons'].append("Time-sensitive operation - skipping low-confidence retry")
        
        return decision
    
    def _recommend_strategy(self, exception: Exception, category: str,
                          context: Optional[Dict[str, Any]] = None) -> RetryStrategy:
        """Recommend appropriate retry strategy"""
        strategy_mapping = {
            'database': RetryStrategy.DATABASE,
            'api': RetryStrategy.API_CALLS,
            'generation': RetryStrategy.GENERATION,
            'network': RetryStrategy.API_CALLS
        }
        
        # Check for gateway-specific errors
        if category == 'api':
            message = str(exception).lower()
            if any(code in message for code in ['502', '503', '504']) or 'gateway' in message:
                return RetryStrategy.GATEWAY_CALLS
        
        # Check context for specific strategy hints
        if context:
            if context.get('operation_type') == 'chunk_processing':
                return RetryStrategy.CHUNK_BASED
            elif context.get('high_latency_acceptable'):
                return RetryStrategy.EXPONENTIAL
        
        return strategy_mapping.get(category, RetryStrategy.EXPONENTIAL)
    
    def _suggest_configuration(self, exception: Exception, category: str,
                             strategy: RetryStrategy, context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Suggest configuration adjustments"""
        suggestions = {}
        message = str(exception).lower()
        
        # Strategy-specific suggestions
        if strategy == RetryStrategy.DATABASE:
            if 'deadlock' in message:
                suggestions['base_delay'] = 0.1  # Quick retry for deadlocks
                suggestions['max_delay'] = 2.0
            elif 'connection' in message:
                suggestions['base_delay'] = 5.0  # Longer delay for connections
                suggestions['max_delay'] = 60.0
        
        elif strategy == RetryStrategy.API_CALLS:
            if '429' in message or 'rate limit' in message:
                suggestions['base_delay'] = 10.0  # Longer delay for rate limits
                suggestions['max_delay'] = 120.0
            elif any(code in message for code in ['502', '503', '504']):
                suggestions['base_delay'] = 3.0   # Medium delay for gateway errors
                suggestions['max_delay'] = 30.0
        
        elif strategy == RetryStrategy.GENERATION:
            if 'parsing' in message:
                suggestions['max_attempts'] = 3    # More attempts for parsing
                suggestions['base_delay'] = 0.5
            elif 'timeout' in message:
                suggestions['base_delay'] = 2.0    # Longer delay for timeouts
                suggestions['max_attempts'] = 2
        
        # Context-based suggestions
        if context:
            if context.get('high_priority'):
                suggestions['max_attempts'] = suggestions.get('max_attempts', 3) + 1
            elif context.get('background_task'):
                suggestions['max_delay'] = 300.0  # Allow longer delays for background tasks
        
        return suggestions
    
    def _extract_status_code(self, message: str) -> Optional[int]:
        """Extract HTTP status code from message"""
        patterns = [
            r'(?:HTTP|Status|Code)(?:\s*:)?\s*(\d{3})',
            r'(\d{3})\s*(?:Server Error|Gateway|Service)',
            r'HTTP\s*(\d{3})'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, message, re.IGNORECASE)
            if match:
                try:
                    return int(match.group(1))
                except (ValueError, IndexError):
                    continue
        
        return None
    
    def analyze_multiple_exceptions(self, exceptions: List[Exception],
                                  context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Analyze multiple exceptions to find patterns
        
        Args:
            exceptions: List of exceptions to analyze
            context: Additional context
            
        Returns:
            Aggregated analysis results
        """
        if not exceptions:
            return {'error': 'No exceptions provided'}
        
        analyses = [self.analyze_exception(exc, context) for exc in exceptions]
        
        # Aggregate results
        categories = [a['category'] for a in analyses]
        retry_recommendations = [a['retry_recommendation'] for a in analyses]
        strategies = [a['recommended_strategy'] for a in analyses if a['recommended_strategy']]
        
        # Find most common patterns
        from collections import Counter
        
        return {
            'total_exceptions': len(exceptions),
            'most_common_category': Counter(categories).most_common(1)[0] if categories else None,
            'retry_rate': sum(retry_recommendations) / len(retry_recommendations) if retry_recommendations else 0,
            'most_common_strategy': Counter(strategies).most_common(1)[0] if strategies else None,
            'individual_analyses': analyses,
            'pattern_summary': {
                'categories': dict(Counter(categories)),
                'strategies': dict(Counter(strategies))
            }
        }